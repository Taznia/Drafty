import mongoose from 'mongoose';

const subscriptionSchema = new mongoose.Schema(
  {
    userId: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true, unique: true, index: true },
    plan: { type: String, enum: ['free', 'premium'], default: 'free' },
    status: { type: String, enum: ['active', 'canceled', 'past_due'], default: 'active' },
    providerCustomerId: { type: String, trim: true },
    currentPeriodEndsAt: { type: Date },
  },
  { timestamps: true, versionKey: false },
);

export const Subscription = mongoose.model('Subscription', subscriptionSchema);
