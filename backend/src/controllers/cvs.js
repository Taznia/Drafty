import mongoose from 'mongoose';

import { Cv } from '../models/cv.js';
import { parseRequest, createCvSchema, paginationSchema, updateCvSchema } from '../validators/cv.js';

function requireDatabase() {
  if (mongoose.connection.readyState !== 1) {
    const error = new Error('CV service is temporarily unavailable.');
    error.statusCode = 503;
    error.code = 'DATABASE_UNAVAILABLE';
    throw error;
  }
}

function requireCvId(value) {
  if (!mongoose.isValidObjectId(value)) {
    const error = new Error('The CV id is invalid.');
    error.statusCode = 400;
    error.code = 'INVALID_CV_ID';
    throw error;
  }
}

function cvNotFound() {
  const error = new Error('CV not found.');
  error.statusCode = 404;
  error.code = 'CV_NOT_FOUND';
  return error;
}

function publicCv(cv) {
  return {
    id: cv.id,
    title: cv.title,
    templateId: cv.templateId ?? null,
    sections: cv.sections,
    completion: cv.completion,
    createdAt: cv.createdAt,
    updatedAt: cv.updatedAt,
  };
}

function normalizeSections(sections) {
  return sections?.map((section, index) => ({ ...section, order: index }));
}

export async function listCvs(request, response) {
  requireDatabase();
  const { page, limit, search } = parseRequest(paginationSchema, request.query);
  const filter = { userId: request.auth.sub, isDeleted: false };

  if (search) {
    filter.title = { $regex: search.replace(/[.*+?^${}()|[\]\\]/g, '\\$&'), $options: 'i' };
  }

  const [cvs, total] = await Promise.all([
    Cv.find(filter).sort({ updatedAt: -1 }).skip((page - 1) * limit).limit(limit).lean(),
    Cv.countDocuments(filter),
  ]);

  response.status(200).json({
    data: cvs.map(publicCv),
    pagination: { page, limit, total, pages: Math.ceil(total / limit) },
  });
}

export async function createCv(request, response) {
  requireDatabase();
  const input = parseRequest(createCvSchema, request.body);
  const cv = await Cv.create({ ...input, sections: normalizeSections(input.sections), userId: request.auth.sub });
  response.status(201).json({ data: publicCv(cv) });
}

export async function getCv(request, response) {
  requireDatabase();
  requireCvId(request.params.id);
  const cv = await Cv.findOne({ _id: request.params.id, userId: request.auth.sub, isDeleted: false }).lean();

  if (!cv) throw cvNotFound();
  response.status(200).json({ data: publicCv(cv) });
}

export async function updateCv(request, response) {
  requireDatabase();
  requireCvId(request.params.id);
  const input = parseRequest(updateCvSchema, request.body);
     if (input.sections) input.sections = normalizeSections(input.sections);
  const cv = await Cv.findOneAndUpdate(
    { _id: request.params.id, userId: request.auth.sub, isDeleted: false },
    { $set: input },
    { returnDocument: 'after', runValidators: true },
  ).lean();

  if (!cv) throw cvNotFound();
  response.status(200).json({ data: publicCv(cv) });
}

export async function deleteCv(request, response) {
  requireDatabase();
  requireCvId(request.params.id);
  const cv = await Cv.findOneAndUpdate(
    { _id: request.params.id, userId: request.auth.sub, isDeleted: false },
    { $set: { isDeleted: true } },
    { returnDocument: 'after' },
  );

  if (!cv) throw cvNotFound();
  response.status(204).send();
}

export async function duplicateCv(request, response) {
  requireDatabase();
  requireCvId(request.params.id);
  const source = await Cv.findOne({ _id: request.params.id, userId: request.auth.sub, isDeleted: false }).lean();

  if (!source) throw cvNotFound();

  const duplicate = await Cv.create({
    userId: request.auth.sub,
    title: `${source.title} copy`,
    templateId: source.templateId,
    sections: source.sections,
    completion: source.completion,
  });

  response.status(201).json({ data: publicCv(duplicate) });
}