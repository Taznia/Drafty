import mongoose from 'mongoose';

import { Subscription } from '../models/subscription.js';
import { publicSubscription } from '../services/premium-entitlements.js';

function requireDatabase() {
  if (mongoose.connection.readyState !== 1) {
    const error = new Error('Subscription service is temporarily unavailable.');
    error.statusCode = 503;
    error.code = 'DATABASE_UNAVAILABLE';
    throw error;
  }
}

export async function getStatus(request, response) {
  requireDatabase();
  const subscription = await Subscription.findOne({ userId: request.auth.sub }).lean();
  response.status(200).json({ data: publicSubscription(subscription) });
}

export async function cancelSubscription(request, response) {
  requireDatabase();
  const subscription = await Subscription.findOneAndUpdate(
    { userId: request.auth.sub, plan: 'premium', status: 'active' },
    { $set: { status: 'canceled' } },
    { returnDocument: 'after' },
  ).lean();

  if (!subscription) {
    const error = new Error('No active premium subscription was found.');
    error.statusCode = 404;
    error.code = 'ACTIVE_SUBSCRIPTION_NOT_FOUND';
    throw error;
  }

  response.status(200).json({ data: publicSubscription(subscription) });
}