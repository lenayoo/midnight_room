import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_gradients.dart';
import '../../../../core/widgets/glass_panel.dart';
import '../../../../data/models/sound_item.dart';

class PlayerHeroCard extends StatelessWidget {
  const PlayerHeroCard({
    required this.sound,
    required this.isPlaying,
    required this.volume,
    required this.onPlayPause,
    required this.onPrevious,
    required this.onNext,
    required this.onToggleFavorite,
    required this.onVolumeChanged,
    super.key,
  });

  final SoundItem sound;
  final bool isPlaying;
  final double volume;
  final VoidCallback onPlayPause;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final VoidCallback onToggleFavorite;
  final ValueChanged<double> onVolumeChanged;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final List<Color> artworkColors = AppGradients.soundArtwork(sound.category);

    return GlassPanel(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 280,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(26),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: artworkColors,
              ),
            ),
            child: Stack(
              children: <Widget>[
                Align(
                  alignment: const Alignment(0.55, -0.55),
                  child: Container(
                    width: 108,
                    height: 108,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: <Color>[
                          AppColors.moonWhite.withValues(alpha: 0.95),
                          AppColors.moonWhite.withValues(alpha: 0),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 18,
                  right: 18,
                  bottom: 18,
                  child: GlassPanel(
                    padding: const EdgeInsets.all(18),
                    borderRadius: const BorderRadius.all(Radius.circular(22)),
                    gradientColors: const <Color>[
                      Color(0x26FFFFFF),
                      Color(0x14FFFFFF),
                    ],
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'TONIGHT’S ROOM',
                          style: textTheme.bodySmall?.copyWith(
                            letterSpacing: 1.5,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(sound.title, style: textTheme.headlineLarge),
                        const SizedBox(height: 6),
                        Text(
                          sound.moodTags.join(' · '),
                          style: textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final bool useCompactControls = constraints.maxWidth < 260;
              final bool useIconOnlyLabel = constraints.maxWidth < 220;
              final double sideButtonSize = useCompactControls ? 56 : 64;
              final String actionLabel =
                  useIconOnlyLabel
                      ? ''
                      : isPlaying
                      ? useCompactControls
                          ? 'Pause'
                          : 'Pause room'
                      : useCompactControls
                      ? 'Play'
                      : 'Play room';

              return Row(
                children: <Widget>[
                  _SoftIconButton(
                    icon: Icons.skip_previous_rounded,
                    onTap: onPrevious,
                    size: sideButtonSize,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: GestureDetector(
                      onTap: onPlayPause,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 280),
                        curve: Curves.easeOutCubic,
                        height: 72,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          gradient: LinearGradient(
                            colors:
                                isPlaying
                                    ? const <Color>[
                                      AppColors.moonWhite,
                                      AppColors.warmBeige,
                                    ]
                                    : const <Color>[
                                      AppColors.dustyPink,
                                      AppColors.softPurple,
                                    ],
                          ),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                              color:
                                  isPlaying
                                      ? AppColors.warmBeige.withValues(
                                        alpha: 0.28,
                                      )
                                      : AppColors.softPurple.withValues(
                                        alpha: 0.28,
                                      ),
                              blurRadius: 32,
                              offset: const Offset(0, 16),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              isPlaying
                                  ? Icons.pause_rounded
                                  : Icons.play_arrow_rounded,
                              size: 32,
                              color:
                                  isPlaying
                                      ? AppColors.deepNavy
                                      : AppColors.moonWhite,
                            ),
                            if (actionLabel.isNotEmpty) ...<Widget>[
                              const SizedBox(width: 10),
                              Flexible(
                                child: Text(
                                  actionLabel,
                                  overflow: TextOverflow.fade,
                                  softWrap: false,
                                  style: textTheme.titleMedium?.copyWith(
                                    color:
                                        isPlaying
                                            ? AppColors.deepNavy
                                            : AppColors.moonWhite,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  _SoftIconButton(
                    icon: Icons.skip_next_rounded,
                    onTap: onNext,
                    size: sideButtonSize,
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 18),
          Row(
            children: <Widget>[
              Icon(
                Icons.volume_up_rounded,
                color: Colors.white.withValues(alpha: 0.72),
              ),
              Expanded(
                child: Slider(value: volume, onChanged: onVolumeChanged),
              ),
              const SizedBox(width: 8),
              _SoftIconButton(
                icon:
                    sound.isFavorite
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                onTap: onToggleFavorite,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SoftIconButton extends StatelessWidget {
  const _SoftIconButton({
    required this.icon,
    required this.onTap,
    this.size = 64,
  });

  final IconData icon;
  final VoidCallback onTap;
  final double size;

  @override
  Widget build(BuildContext context) {
    final double cornerRadius = size * 0.34;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(cornerRadius),
      child: Ink(
        width: size,
        height: size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(cornerRadius),
          color: Colors.white.withValues(alpha: 0.08),
          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        ),
        child: Icon(icon, color: Colors.white),
      ),
    );
  }
}
