import mongoose from 'mongoose';

import { env } from './env.js';

export async function connectDatabase() {
  if (!env.MONGODB_ENABLED || !env.MONGODB_URI) {
    console.warn('MONGODB_URI is not configured. Starting without a database connection.');
    return;
  }

  await mongoose.connect(env.MONGODB_URI, {
    // Conservative defaults for a long-running API before production traffic is measured.
    maxPoolSize: 10,
    minPoolSize: 0,
    maxIdleTimeMS: 300000,
    connectTimeoutMS: 10000,
    serverSelectionTimeoutMS: 5000,
    socketTimeoutMS: 30000,
  });

  console.log(`MongoDB connected: ${mongoose.connection.name}`);
}

export async function disconnectDatabase() {
  await mongoose.disconnect();
}
