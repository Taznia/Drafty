import { z } from 'zod';

const email = z.string().trim().toLowerCase().email().max(254);

export const registerSchema = z.object({
  name: z.string().trim().min(2).max(100),
  email,
  password: z.string().min(8).max(128),
}).strict();

export const loginSchema = z.object({
  email,
  password: z.string().min(1).max(128),
}).strict();

export function parseRequest(schema, input) {
  const result = schema.safeParse(input);

  if (!result.success) {
    const error = new Error('Request validation failed.');
    error.statusCode = 400;
    error.code = 'VALIDATION_ERROR';
    error.details = result.error.flatten().fieldErrors;
    throw error;
  }

  return result.data;
}