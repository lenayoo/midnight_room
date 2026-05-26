import 'package:flutter/material.dart';

import '../../../../core/theme/app_gradients.dart';
import '../../../../core/widgets/glass_panel.dart';
import '../../../../data/models/sound_item.dart';

class SoundLibraryTile extends StatelessWidget {
  const SoundLibraryTile({
    required this.sound,
    required this.isSelected,
    required this.onTap,
    required this.onToggleFavorite,
    required this.onPremiumTap,
    super.key,
  });

  final SoundItem sound;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onToggleFavorite;
  final VoidCallback onPremiumTap;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: sound.isPremium ? onPremiumTap : onTap,
      child: GlassPanel(
        padding: const EdgeInsets.all(14),
        gradientColors:
            isSelected
                ? const <Color>[Color(0x3AF4EDE3), Color(0x1AFFFFFF)]
                : const <Color>[Color(0x22FFFFFF), Color(0x12FFFFFF)],
        borderColor:
            isSelected ? const Color(0x55F4EDE3) : const Color(0x20FFFFFF),
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            if (constraints.maxWidth < 340) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _ArtworkThumbnail(sound: sound),
                      const Spacer(),
                      IconButton(
                        onPressed: onToggleFavorite,
                        icon: Icon(
                          sound.isFavorite
                              ? Icons.favorite_rounded
                              : Icons.favorite_border_rounded,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: <Widget>[
                      Text(sound.title, style: textTheme.titleMedium),
                      if (sound.isPremium) const _PremiumBadge(),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${sound.category} · ${sound.duration}',
                    style: textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 6),
                  Text(sound.moodTags.join(' · '), style: textTheme.bodySmall),
                ],
              );
            }

            return Row(
              children: <Widget>[
                _ArtworkThumbnail(sound: sound),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: <Widget>[
                          Text(sound.title, style: textTheme.titleMedium),
                          if (sound.isPremium) const _PremiumBadge(),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${sound.category} · ${sound.duration}',
                        style: textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        sound.moodTags.join(' · '),
                        style: textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                IconButton(
                  onPressed: onToggleFavorite,
                  icon: Icon(
                    sound.isFavorite
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _ArtworkThumbnail extends StatelessWidget {
  const _ArtworkThumbnail({required this.sound});

  final SoundItem sound;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: AppGradients.soundArtwork(sound.category),
        ),
      ),
      child: Icon(
        sound.category == 'Nature'
            ? Icons.forest_rounded
            : sound.category == 'City'
            ? Icons.train_rounded
            : sound.category == 'Cafe'
            ? Icons.local_cafe_rounded
            : sound.category == 'Focus'
            ? Icons.piano_rounded
            : Icons.nightlight_round,
        color: Colors.white.withValues(alpha: 0.9),
      ),
    );
  }
}

class _PremiumBadge extends StatelessWidget {
  const _PremiumBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: Colors.white.withValues(alpha: 0.08),
      ),
      child: Text('Premium', style: Theme.of(context).textTheme.bodySmall),
    );
  }
}
