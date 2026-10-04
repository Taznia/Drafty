import { z } from 'zod';

const sectionSchema = z.object({
  type: z.string().trim().min(1).max(50),
  title: z.string().trim().min(1).max(120),
  data: z.unknown().default({}),
  order: z.number().int().min(0),
}).strict();

export const createCvSchema = z.object({
  title: z.string().trim().min(1).max(120),
  templateId: z.string().trim().optional(),
  profilePhotoUrl: z.string().trim().max(2048).optional(),
  links: z.record(z.string().trim().max(2048)).default({}),
  sections: z.array(sectionSchema).max(50).default([]),
  completion: z.number().min(0).max(1).default(0),
}).strict();

export const updateCvSchema = createCvSchema.partial();

export const paginationSchema = z.object({
  page: z.coerce.number().int().min(1).default(1),
  limit: z.coerce.number().int().min(1).max(50).default(20),
  search: z.string().trim().max(120).default(''),
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