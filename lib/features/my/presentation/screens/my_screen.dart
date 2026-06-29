import 'package:flutter/material.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/floating_sparkles.dart';
import '../../../../core/widgets/soft_reveal_text.dart';
import '../../../../data/models/quote_item.dart';
import '../../../../data/models/sound_item.dart';

class MyScreen extends StatefulWidget {
  const MyScreen({
    required this.savedQuotes,
    required this.favoriteSounds,
    this.isActive = true,
    super.key,
  });

  final List<QuoteItem> savedQuotes;
  final List<SoundItem> favoriteSounds;
  final bool isActive;

  @override
  State<MyScreen> createState() => _MyScreenState();
}

class _MyScreenState extends State<MyScreen>
    with SingleTickerProviderStateMixin {
  static const Duration _timelineDuration = Duration(milliseconds: 9000);

  late final AnimationController _timelineController;

  @override
  void initState() {
    super.initState();
    _timelineController = AnimationController(
      vsync: this,
      duration: _timelineDuration,
    );

    if (widget.isActive) {
      _timelineController.forward();
    }
  }

  @override
  void didUpdateWidget(covariant MyScreen oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (!oldWidget.isActive && widget.isActive) {
      _timelineController
        ..value = 0
        ..forward();
      return;
    }

    if (oldWidget.isActive && !widget.isActive) {
      _timelineController.value = 0;
    }
  }

  @override
  void dispose() {
    _timelineController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = context.l10n;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return ColoredBox(
      color: Colors.black,
      child: Stack(
        children: <Widget>[
          const Positioned.fill(child: FloatingSparkles()),
          SafeArea(
            bottom: false,
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(28, 40, 28, 120),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: AnimatedBuilder(
                    animation: _timelineController,
                    builder: (BuildContext context, _) {
                      final double progress = _timelineController.value;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SoftRevealText(
                            text: l10n.appName,
                            progress: progress,
                            start: 0.04,
                            end: 0.11,
                            style: AppTypography.brandTitle(
                              textTheme.displayMedium?.copyWith(
                                color: AppColors.moonWhite,
                                fontWeight: FontWeight.w600,
                                fontSize: 50,
                                height: 0.95,
                                letterSpacing: -0.2,
                              ),
                            ),
                          ),
                          const SizedBox(height: 18),
                          SoftRevealDivider(
                            width: 56,
                            progress: progress,
                            start: 0.11,
                            end: 0.15,
                          ),
                          const SizedBox(height: 24),
                          SoftRevealText(
                            text: l10n.myScreenIntro,
                            progress: progress,
                            start: 0.14,
                            end: 0.32,
                            style: textTheme.bodyLarge?.copyWith(
                              color: AppColors.moonWhite.withValues(
                                alpha: 0.88,
                              ),
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              height: 1.65,
                            ),
                          ),
                          const SizedBox(height: 28),
                          SoftRevealText(
                            text: l10n.calmYourMindLabel,
                            progress: progress,
                            start: 0.3,
                            end: 0.42,
                            style: textTheme.headlineSmall?.copyWith(
                              color: AppColors.moonWhite.withValues(
                                alpha: 0.92,
                              ),
                              fontWeight: FontWeight.w600,
                              fontSize: 24,
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 28),
                          SoftRevealText(
                            text: l10n.myScreenReflection,
                            progress: progress,
                            start: 0.4,
                            end: 0.58,
                            style: textTheme.bodyLarge?.copyWith(
                              color: AppColors.moonWhite.withValues(
                                alpha: 0.72,
                              ),
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              height: 1.65,
                            ),
                          ),
                          const SizedBox(height: 40),
                          SoftRevealText(
                            text: l10n.justBreatheLabel,
                            progress: progress,
                            start: 0.64,
                            end: 1,
                            style: textTheme.headlineMedium?.copyWith(
                              color: AppColors.warmBeige,
                              fontWeight: FontWeight.w600,
                              fontSize: 34,
                              height: 1.0,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
