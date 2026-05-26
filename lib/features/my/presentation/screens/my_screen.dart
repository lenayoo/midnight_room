import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_gradients.dart';
import '../../../../core/widgets/ambient_background.dart';
import '../../../../core/widgets/fade_slide_in.dart';
import '../../../../core/widgets/glass_panel.dart';
import '../../../../core/widgets/section_header.dart';
import '../../../../data/models/quote_item.dart';
import '../../../../data/models/sound_item.dart';
import '../../../../data/models/timer_session.dart';
import '../../../premium/domain/subscription_state.dart';

class MyScreen extends StatelessWidget {
  const MyScreen({
    required this.subscriptionState,
    required this.savedQuotes,
    required this.favoriteSounds,
    required this.timerHistory,
    required this.onOpenPremium,
    required this.onOpenNotificationPreview,
    required this.onOpenThemePreview,
    super.key,
  });

  final SubscriptionState subscriptionState;
  final List<QuoteItem> savedQuotes;
  final List<SoundItem> favoriteSounds;
  final List<TimerSession> timerHistory;
  final VoidCallback onOpenPremium;
  final VoidCallback onOpenNotificationPreview;
  final VoidCallback onOpenThemePreview;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return AmbientBackground(
      gradient: AppGradients.screenBackground(3),
      primaryOrbColors: const <Color>[Color(0x44D9B99B), Color(0x003A335C)],
      secondaryOrbColors: const <Color>[Color(0x22B98299), Color(0x0011182E)],
      child: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 140),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              FadeSlideIn(
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 72,
                      height: 72,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: <Color>[
                            AppColors.warmBeige,
                            AppColors.dustyPink,
                          ],
                        ),
                      ),
                      child: const Icon(
                        Icons.nightlight_round,
                        color: AppColors.deepNavy,
                        size: 32,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('Quiet evenings', style: textTheme.displaySmall),
                          const SizedBox(height: 4),
                          Text(
                            subscriptionState.isPremium
                                ? 'Your premium soundscape is active.'
                                : 'Free plan with premium-ready pathways.',
                            style: textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              FadeSlideIn(
                delay: const Duration(milliseconds: 120),
                child: GlassPanel(
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              subscriptionState.isPremium
                                  ? 'Premium calm'
                                  : 'Upgrade to premium',
                              style: textTheme.titleLarge,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              subscriptionState.isPremium
                                  ? 'Layered mixes, unlimited saves, and sleep tools are unlocked.'
                                  : 'Unlock all rooms, custom mixes, and deeper timer controls.',
                              style: textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      FilledButton(
                        onPressed: onOpenPremium,
                        child: Text(
                          subscriptionState.isPremium ? 'Manage' : 'View',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 26),
              FadeSlideIn(
                delay: const Duration(milliseconds: 180),
                child: const SectionHeader(
                  title: 'Your Library',
                  actionLabel: 'Saved previews',
                ),
              ),
              const SizedBox(height: 14),
              FadeSlideIn(
                delay: const Duration(milliseconds: 220),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: _MetricCard(
                        label: 'Saved Quotes',
                        value: '${savedQuotes.length}',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _MetricCard(
                        label: 'Favorites',
                        value: '${favoriteSounds.length}',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _MetricCard(
                        label: 'Sessions',
                        value: '${timerHistory.length}',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              FadeSlideIn(
                delay: const Duration(milliseconds: 260),
                child: _DetailCard(
                  title: 'Saved Quotes',
                  subtitle:
                      savedQuotes.isEmpty
                          ? 'No saved reflections yet.'
                          : savedQuotes
                              .map((QuoteItem quote) => quote.author)
                              .take(3)
                              .join(' · '),
                  trailing: '${savedQuotes.length} items',
                ),
              ),
              const SizedBox(height: 12),
              FadeSlideIn(
                delay: const Duration(milliseconds: 300),
                child: _DetailCard(
                  title: 'Favorite Sounds',
                  subtitle:
                      favoriteSounds.isEmpty
                          ? 'No favorite rooms yet.'
                          : favoriteSounds
                              .map((SoundItem sound) => sound.title)
                              .take(3)
                              .join(' · '),
                  trailing: '${favoriteSounds.length} rooms',
                ),
              ),
              const SizedBox(height: 12),
              FadeSlideIn(
                delay: const Duration(milliseconds: 340),
                child: _DetailCard(
                  title: 'Timer History',
                  subtitle:
                      timerHistory.isEmpty
                          ? 'No completed sessions yet.'
                          : timerHistory
                              .take(2)
                              .map(
                                (TimerSession session) =>
                                    '${session.mode} · ${AppStrings.formatMonthDay(session.completedAt)}',
                              )
                              .join('  /  '),
                  trailing: '${timerHistory.length} logs',
                ),
              ),
              const SizedBox(height: 26),
              FadeSlideIn(
                delay: const Duration(milliseconds: 380),
                child: const SectionHeader(
                  title: 'Calm Settings',
                  actionLabel: 'Notification-ready',
                ),
              ),
              const SizedBox(height: 14),
              FadeSlideIn(
                delay: const Duration(milliseconds: 420),
                child: _InteractiveCard(
                  title: 'Notification Settings',
                  subtitle:
                      'Daily quote 8:30 AM · Focus reminder 2:00 PM · Sleep reminder 11:00 PM',
                  onTap: onOpenNotificationPreview,
                ),
              ),
              const SizedBox(height: 12),
              FadeSlideIn(
                delay: const Duration(milliseconds: 460),
                child: _InteractiveCard(
                  title: 'App Theme',
                  subtitle:
                      'Warm dark mode is active. Premium themes can plug in here later.',
                  onTap: onOpenThemePreview,
                ),
              ),
              const SizedBox(height: 12),
              const FadeSlideIn(
                delay: Duration(milliseconds: 500),
                child: _DetailCard(
                  title: 'About',
                  subtitle:
                      'Soundscape Days prototype · English only for now · ready for JP/KR localization later.',
                  trailing: 'v1.0.0',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      padding: const EdgeInsets.all(16),
      borderRadius: const BorderRadius.all(Radius.circular(22)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(label, style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 8),
          Text(value, style: Theme.of(context).textTheme.headlineMedium),
        ],
      ),
    );
  }
}

class _DetailCard extends StatelessWidget {
  const _DetailCard({
    required this.title,
    required this.subtitle,
    required this.trailing,
  });

  final String title;
  final String subtitle;
  final String trailing;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return GlassPanel(
      padding: const EdgeInsets.all(18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(title, style: textTheme.titleMedium),
                const SizedBox(height: 8),
                Text(subtitle, style: textTheme.bodyMedium),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(trailing, style: textTheme.bodySmall),
        ],
      ),
    );
  }
}

class _InteractiveCard extends StatelessWidget {
  const _InteractiveCard({
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(28),
      child: GlassPanel(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(title, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            ),
            const SizedBox(width: 12),
            const Icon(Icons.chevron_right_rounded),
          ],
        ),
      ),
    );
  }
}
