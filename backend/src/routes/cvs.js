import { Router } from 'express';

import { createCv, deleteCv, duplicateCv, getCv, listCvs, updateCv } from '../controllers/cvs.js';
import { asyncHandler } from '../middleware/async-handler.js';
import { authenticate } from '../middleware/authenticate.js';

export const cvsRouter = Router();

cvsRouter.use(authenticate);
cvsRouter.get('/', asyncHandler(listCvs));
cvsRouter.post('/', asyncHandler(createCv));
cvsRouter.get('/:id', asyncHandler(getCv));
cvsRouter.put('/:id', asyncHandler(updateCv));
cvsRouter.delete('/:id', asyncHandler(deleteCv));
cvsRouter.post('/:id/duplicate', asyncHandler(duplicateCv));