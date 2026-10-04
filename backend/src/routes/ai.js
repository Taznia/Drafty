import { Router } from 'express';
import rateLimit from 'express-rate-limit';

import { asyncHandler } from '../middleware/async-handler.js';
import { authenticate } from '../middleware/authenticate.js';
import { requirePremium } from '../middleware/require-premium.js';
import { checkAts, generateCoverLetter, generateSummary, improveText, tailorCv } from '../controllers/ai.js';

export const aiRouter = Router();

const aiRateLimit = rateLimit({
  windowMs: 15 * 60 * 1000,
  limit: 20,
  standardHeaders: 'draft-8',
  legacyHeaders: false,
  message: { error: { code: 'AI_RATE_LIMITED', message: 'Too many AI requests. Try again later.' } },
});

aiRouter.use(authenticate, aiRateLimit, requirePremium);
aiRouter.post('/summary', asyncHandler(generateSummary));
aiRouter.post('/improve', asyncHandler(improveText));
aiRouter.post('/tailor', asyncHandler(tailorCv));
aiRouter.post('/ats-check', asyncHandler(checkAts));
aiRouter.post('/cover-letter', asyncHandler(generateCoverLetter));