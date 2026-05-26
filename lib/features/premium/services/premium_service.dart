import 'package:flutter/foundation.dart';

import '../../../core/constants/app_strings.dart';
import '../domain/subscription_state.dart';

class PremiumService extends ValueNotifier<SubscriptionState> {
  PremiumService()
    : super(
        const SubscriptionState(
          plan: SubscriptionPlan.free,
          priceLabel: AppStrings.premiumPrice,
        ),
      );

  bool get isPremium => value.isPremium;

  Future<void> initialize() async {
    // TODO(lenayoo): Load purchase state from StoreKit / Play Billing when enabled.
  }

  Future<void> startFreeTrial() async {
    value = value.copyWith(plan: SubscriptionPlan.premiumTrial, trialDays: 7);
  }

  Future<void> restorePurchases() async {
    // TODO(lenayoo): Restore purchases with the native billing SDK.
  }
}
