enum SubscriptionPlan { free, premiumTrial, premium }

class SubscriptionState {
  const SubscriptionState({
    required this.plan,
    required this.priceLabel,
    this.trialDays = 0,
  });

  final SubscriptionPlan plan;
  final String priceLabel;
  final int trialDays;

  bool get isPremium => plan != SubscriptionPlan.free;
  bool get isTrial => plan == SubscriptionPlan.premiumTrial;

  String get label {
    switch (plan) {
      case SubscriptionPlan.premium:
        return 'Premium';
      case SubscriptionPlan.premiumTrial:
        return 'Trial';
      case SubscriptionPlan.free:
        return 'Free';
    }
  }

  SubscriptionState copyWith({
    SubscriptionPlan? plan,
    String? priceLabel,
    int? trialDays,
  }) {
    return SubscriptionState(
      plan: plan ?? this.plan,
      priceLabel: priceLabel ?? this.priceLabel,
      trialDays: trialDays ?? this.trialDays,
    );
  }
}
