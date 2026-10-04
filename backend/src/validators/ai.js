import { z } from 'zod';

const text = z.string().trim().min(1).max(12000);

export const summarySchema = z.object({
  name: z.string().trim().max(120).default(''),
  role: z.string().trim().max(160).default(''),
  experience: text.optional(),
  skills: z.array(z.string().trim().max(80)).max(40).default([]),
}).strict();

export const improveSchema = z.object({
  text,
  goal: z.string().trim().max(500).default('Make this clearer, stronger, and more concise.'),
}).strict();

export const tailorSchema = z.object({
  cvText: text,
  jobDescription: text,
}).strict();

export const atsSchema = z.object({
  cvText: text,
  jobDescription: text.optional(),
}).strict();

export const coverLetterSchema = z.object({
  cvText: text,
  jobDescription: text,
  company: z.string().trim().min(1).max(160),
  role: z.string().trim().min(1).max(160),
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