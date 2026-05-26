import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_gradients.dart';
import '../../../../core/widgets/ambient_background.dart';
import '../../../../core/widgets/fade_slide_in.dart';
import '../../../../core/widgets/glass_panel.dart';
import '../../../../data/models/quote_item.dart';

class QuoteScreen extends StatelessWidget {
  const QuoteScreen({
    required this.quote,
    required this.savedCount,
    required this.onToggleSaved,
    required this.onRefresh,
    required this.onShare,
    super.key,
  });

  final QuoteItem quote;
  final int savedCount;
  final VoidCallback onToggleSaved;
  final VoidCallback onRefresh;
  final VoidCallback onShare;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return AmbientBackground(
      gradient: AppGradients.screenBackground(2),
      primaryOrbColors: AppGradients.quoteCard,
      secondaryOrbColors: const <Color>[Color(0x26F4EDE3), Color(0x0011182E)],
      child: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 140),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              FadeSlideIn(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      AppStrings.formatLongDate(quote.date),
                      style: textTheme.bodySmall?.copyWith(letterSpacing: 1.5),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'A quiet reflection room.',
                      style: textTheme.displayMedium,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Daily quote presentation is live, while sharing and notifications stay ready for platform wiring.',
                      style: textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              FadeSlideIn(
                delay: const Duration(milliseconds: 120),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  switchInCurve: Curves.easeOutCubic,
                  child: GlassPanel(
                    key: ValueKey<String>(quote.id),
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          '“',
                          style: textTheme.displayLarge?.copyWith(
                            color: AppColors.moonWhite.withValues(alpha: 0.7),
                            height: 0.7,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          quote.text,
                          style: textTheme.headlineMedium?.copyWith(
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 18),
                        Text(
                          quote.author,
                          style: textTheme.titleMedium?.copyWith(
                            color: AppColors.warmBeige,
                          ),
                        ),
                        const SizedBox(height: 18),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(999),
                            color: Colors.white.withValues(alpha: 0.08),
                          ),
                          child: Text(
                            '$savedCount saved reflections',
                            style: textTheme.bodySmall,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              FadeSlideIn(
                delay: const Duration(milliseconds: 180),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: _ActionButton(
                        icon:
                            quote.isSaved
                                ? Icons.favorite_rounded
                                : Icons.favorite_border_rounded,
                        label: quote.isSaved ? 'Saved' : 'Save',
                        onTap: onToggleSaved,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _ActionButton(
                        icon: Icons.ios_share_rounded,
                        label: 'Share',
                        onTap: onShare,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _ActionButton(
                        icon: Icons.refresh_rounded,
                        label: 'Refresh',
                        onTap: onRefresh,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              FadeSlideIn(
                delay: const Duration(milliseconds: 240),
                child: GlassPanel(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Daily quote notification',
                        style: textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Prepared for a soft morning delivery at 8:30 AM without platform code yet.',
                        style: textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Ink(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: Colors.white.withValues(alpha: 0.08),
          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        ),
        child: Column(
          children: <Widget>[
            Icon(icon),
            const SizedBox(height: 8),
            Text(label, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}
