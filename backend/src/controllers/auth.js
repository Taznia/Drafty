import mongoose from 'mongoose';

import { User } from '../models/user.js';
import { parseRequest, loginSchema, registerSchema } from '../validators/auth.js';
import { comparePassword, createAccessToken, hashPassword, publicUser } from '../utils/auth.js';

function requireDatabase() {
  if (mongoose.connection.readyState !== 1) {
    const error = new Error('Authentication is temporarily unavailable.');
    error.statusCode = 503;
    error.code = 'DATABASE_UNAVAILABLE';
    throw error;
  }
}

export async function register(request, response) {
  requireDatabase();
  const input = parseRequest(registerSchema, request.body);
  const existingUser = await User.findOne({ email: input.email }).lean();

  if (existingUser) {
    const error = new Error('An account with this email already exists.');
    error.statusCode = 409;
    error.code = 'EMAIL_IN_USE';
    throw error;
  }

  const user = await User.create({
    name: input.name,
    email: input.email,
    passwordHash: await hashPassword(input.password),
  });

  response.status(201).json({ data: { user: publicUser(user), accessToken: createAccessToken(user) } });
}

export async function login(request, response) {
  requireDatabase();
  const input = parseRequest(loginSchema, request.body);
  const user = await User.findOne({ email: input.email }).select('+passwordHash');
  const validPassword = user ? await comparePassword(input.password, user.passwordHash) : false;

  if (!user || !validPassword) {
    const error = new Error('Email or password is incorrect.');
    error.statusCode = 401;
    error.code = 'INVALID_CREDENTIALS';
    throw error;
  }

  response.status(200).json({ data: { user: publicUser(user), accessToken: createAccessToken(user) } });
}

export async function currentUser(request, response) {
  requireDatabase();
  const user = await User.findById(request.auth.sub);

  if (!user) {
    const error = new Error('User account was not found.');
    error.statusCode = 404;
    error.code = 'USER_NOT_FOUND';
    throw error;
  }

  response.status(200).json({ data: { user: publicUser(user) } });
}

export function logout(request, response) {
  response.status(204).send();
}