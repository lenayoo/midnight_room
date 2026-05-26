import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_gradients.dart';
import '../../../../core/widgets/ambient_background.dart';
import '../../../../core/widgets/glass_panel.dart';
import '../../domain/subscription_state.dart';

class PremiumPaywallScreen extends StatelessWidget {
  const PremiumPaywallScreen({
    required this.subscriptionState,
    required this.onStartTrial,
    required this.onRestorePurchases,
    super.key,
  });

  final SubscriptionState subscriptionState;
  final VoidCallback onStartTrial;
  final VoidCallback onRestorePurchases;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return FractionallySizedBox(
      heightFactor: 0.94,
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(36)),
        child: AmbientBackground(
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[
              AppColors.deepIndigo,
              AppColors.softPurple,
              AppColors.deepNavy,
            ],
          ),
          primaryOrbColors: AppGradients.premium,
          secondaryOrbColors: const <Color>[
            Color(0x55D9B99B),
            Color(0x003A335C),
          ],
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Center(
                    child: Container(
                      width: 52,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.35),
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Premium',
                    style: textTheme.bodySmall?.copyWith(letterSpacing: 1.4),
                  ),
                  const SizedBox(height: 8),
                  Text(AppStrings.premiumTitle, style: textTheme.displayMedium),
                  const SizedBox(height: 14),
                  Text(
                    'Build a deeper nightly ritual with premium rooms, layered mixes, and calmer focus tools.',
                    style: textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 24),
                  GlassPanel(
                    padding: const EdgeInsets.all(22),
                    child: Column(
                      children: const <Widget>[
                        _BenefitRow(label: 'All premium sounds & rooms'),
                        SizedBox(height: 16),
                        _BenefitRow(label: 'Mix custom sounds'),
                        SizedBox(height: 16),
                        _BenefitRow(label: 'Sleep & timer unlimited'),
                        SizedBox(height: 16),
                        _BenefitRow(label: 'Daily quotes unlimited'),
                        SizedBox(height: 16),
                        _BenefitRow(label: 'Widgets & more'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  GlassPanel(
                    padding: const EdgeInsets.all(22),
                    gradientColors: const <Color>[
                      Color(0x44F4EDE3),
                      Color(0x22FFFFFF),
                    ],
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                subscriptionState.isPremium
                                    ? 'Your calm space is unlocked'
                                    : '7-day free trial',
                                style: textTheme.titleMedium,
                              ),
                              const SizedBox(height: 6),
                              Text(
                                subscriptionState.priceLabel,
                                style: textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(999),
                            color: Colors.white.withValues(alpha: 0.12),
                          ),
                          child: Text(
                            subscriptionState.isTrial
                                ? 'Trial active'
                                : 'Cancel anytime',
                            style: textTheme.bodySmall?.copyWith(
                              color: AppColors.moonWhite,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed:
                          subscriptionState.isPremium ? null : onStartTrial,
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.moonWhite,
                        foregroundColor: AppColors.deepNavy,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                      ),
                      child: Text(
                        subscriptionState.isPremium
                            ? 'Premium Active'
                            : AppStrings.premiumCta,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: TextButton(
                      onPressed: onRestorePurchases,
                      child: const Text('Restore Purchases'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BenefitRow extends StatelessWidget {
  const _BenefitRow({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withValues(alpha: 0.12),
          ),
          child: const Icon(
            Icons.check_rounded,
            size: 18,
            color: AppColors.moonWhite,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(label, style: Theme.of(context).textTheme.bodyLarge),
        ),
      ],
    );
  }
}
