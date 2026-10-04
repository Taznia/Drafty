class PremiumAccess {
  const PremiumAccess({required this.plan, required this.isPremium, required this.entitlements});

  const PremiumAccess.free()
      : plan = 'free',
        isPremium = false,
        entitlements = const {};

  final String plan;
  final bool isPremium;
  final Map<String, bool> entitlements;

  bool can(String entitlement) => isPremium && entitlements[entitlement] == true;
}