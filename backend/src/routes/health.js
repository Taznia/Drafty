import { Router } from 'express';
import mongoose from 'mongoose';

export const healthRouter = Router();

healthRouter.get('/', (request, response) => {
  const databaseState = mongoose.connection.readyState === 1 ? 'connected' : 'disconnected';

  response.status(200).json({
    status: 'ok',
    service: 'cv-maker-backend',
    database: databaseState,
    timestamp: new Date().toISOString(),
  });
});
