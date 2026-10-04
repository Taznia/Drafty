export const premiumEntitlements = {
  premiumTemplates: true,
  advancedCustomization: true,
  aiTools: true,
  atsChecker: true,
  unlimitedCvs: true,
};

export const freeEntitlements = {
  premiumTemplates: false,
  advancedCustomization: false,
  aiTools: false,
  atsChecker: false,
  unlimitedCvs: false,
};

export function hasPremiumAccess(subscription) {
  if (!subscription || subscription.plan !== 'premium' || subscription.status !== 'active') return false;
  return !subscription.currentPeriodEndsAt || new Date(subscription.currentPeriodEndsAt) > new Date();
}

export function publicSubscription(subscription) {
  const premium = hasPremiumAccess(subscription);
  return {
    plan: premium ? 'premium' : 'free',
    status: subscription?.status ?? 'active',
    currentPeriodEndsAt: subscription?.currentPeriodEndsAt ?? null,
    entitlements: premium ? premiumEntitlements : freeEntitlements,
  };
}