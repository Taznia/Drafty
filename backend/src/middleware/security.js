import cors from 'cors';
import helmet from 'helmet';
import rateLimit from 'express-rate-limit';

import { env } from '../config/env.js';

export const securityMiddleware = [
  helmet(),
  cors({
    origin(origin, callback) {
      const isLocalDevelopmentOrigin = env.NODE_ENV === 'development'
        && /^https?:\/\/(localhost|127\.0\.0\.1)(:\d+)?$/.test(origin ?? '');

      if (!origin || env.corsOrigins.includes(origin) || isLocalDevelopmentOrigin) {
        callback(null, true);
        return;
      }

      callback(new Error('Origin is not allowed by CORS.'));
    },
    methods: ['GET', 'POST', 'PUT', 'PATCH', 'DELETE', 'OPTIONS'],
  }),
  rateLimit({
    windowMs: 15 * 60 * 1000,
    limit: 100,
    standardHeaders: 'draft-8',
    legacyHeaders: false,
    message: { error: { code: 'RATE_LIMITED', message: 'Too many requests. Try again later.' } },
  }),
];
