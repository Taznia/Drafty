import express from 'express';
import morgan from 'morgan';

import { asyncHandler } from './middleware/async-handler.js';
import { errorHandler, notFoundHandler } from './middleware/error-handler.js';
import { securityMiddleware } from './middleware/security.js';
import { authRouter } from './routes/auth.js';
import { cvsRouter } from './routes/cvs.js';
import { healthRouter } from './routes/health.js';
import { templatesRouter } from './routes/templates.js';
import { subscriptionRouter } from './routes/subscription.js';
import { aiRouter } from './routes/ai.js';

export const app = express();

app.disable('x-powered-by');
app.use(...securityMiddleware);
app.use(express.json({ limit: '1mb' }));
app.use(express.urlencoded({ extended: false, limit: '1mb' }));
app.use(morgan(process.env.NODE_ENV === 'production' ? 'combined' : 'dev'));

app.get('/', asyncHandler(async (request, response) => {
  response.status(200).json({ name: 'CV Maker API', version: '1.0.0' });
}));
app.use('/health', healthRouter);
app.use('/api/auth', authRouter);
app.use('/api/cvs', cvsRouter);
app.use('/api/templates', templatesRouter);
app.use('/api/subscription', subscriptionRouter);
app.use('/api/ai', aiRouter);

app.use(notFoundHandler);
app.use(errorHandler);
