import bcrypt from 'bcryptjs';
import jwt from 'jsonwebtoken';

import { env } from '../config/env.js';

const passwordRounds = 12;

export function hashPassword(password) {
  return bcrypt.hash(password, passwordRounds);
}

export function comparePassword(password, passwordHash) {
  return bcrypt.compare(password, passwordHash);
}

export function createAccessToken(user) {
  return jwt.sign({ sub: user.id, email: user.email }, env.JWT_SECRET, { expiresIn: '7d' });
}

export function verifyAccessToken(token) {
  return jwt.verify(token, env.JWT_SECRET);
}

export function publicUser(user) {
  return {
    id: user.id,
    name: user.name,
    email: user.email,
    profilePhotoUrl: user.profilePhotoUrl ?? null,
    createdAt: user.createdAt,
  };
}