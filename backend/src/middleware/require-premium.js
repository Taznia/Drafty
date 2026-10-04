import mongoose from 'mongoose';

import { Subscription } from '../models/subscription.js';
import { hasPremiumAccess } from '../services/premium-entitlements.js';

export async function requirePremium(request, response, next) {
  if (mongoose.connection.readyState !== 1) {
    response.status(503).json({ error: { code: 'DATABASE_UNAVAILABLE', message: 'Premium access is temporarily unavailable.' } });
    return;
  }

  const subscription = await Subscription.findOne({ userId: request.auth.sub }).lean();
  if (!hasPremiumAccess(subscription)) {
    response.status(403).json({ error: { code: 'PREMIUM_REQUIRED', message: 'This AI feature requires an active premium plan.' } });
    return;
  }

  next();
}