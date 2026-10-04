import { Router } from 'express';

import { cancelSubscription, getStatus } from '../controllers/subscription.js';
import { asyncHandler } from '../middleware/async-handler.js';
import { authenticate } from '../middleware/authenticate.js';

export const subscriptionRouter = Router();

subscriptionRouter.use(authenticate);
subscriptionRouter.get('/status', asyncHandler(getStatus));
subscriptionRouter.post('/cancel', asyncHandler(cancelSubscription));