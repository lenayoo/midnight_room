import 'package:flutter/material.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_gradients.dart';
import '../../../../core/widgets/ambient_background.dart';
import '../../../../core/widgets/glass_panel.dart';
import '../../../../core/widgets/section_header.dart';
import '../../../../data/models/sound_item.dart';
import '../widgets/sound_library_tile.dart';

class SoundsScreen extends StatelessWidget {
  const SoundsScreen({
    required this.sounds,
    required this.featuredRooms,
    required this.currentSound,
    required this.onSelectSound,
    required this.onOpenSoundRoom,
    required this.onToggleFavorite,
    super.key,
  });

  final List<SoundItem> sounds;
  final List<SoundItem> featuredRooms;
  final SoundItem currentSound;
  final ValueChanged<SoundItem> onSelectSound;
  final ValueChanged<SoundItem> onOpenSoundRoom;
  final ValueChanged<SoundItem> onToggleFavorite;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = context.l10n;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return AmbientBackground(
      gradient: AppGradients.screenBackground(0),
      primaryOrbColors: const <Color>[Color(0x55F4EDE3), Color(0x003A335C)],
      secondaryOrbColors: const <Color>[Color(0x33B98299), Color(0x0011182E)],
      child: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
          children: <Widget>[
            Text(l10n.soundsScreenTitle, style: textTheme.displayMedium),
            const SizedBox(height: 20),
            SectionHeader(
              title: l10n.favoriteSoundsLabel,
              actionLabel:
                  featuredRooms.isEmpty ? null : '${featuredRooms.length}',
            ),
            const SizedBox(height: 12),
            if (featuredRooms.isEmpty) ...<Widget>[
              _FavoriteRoomsEmptyCard(message: l10n.favoriteSoundsEmptyLabel),
              const SizedBox(height: 24),
            ] else ...<Widget>[
              for (final SoundItem sound in featuredRooms) ...<Widget>[
                _FeaturedSoundCard(
                  sound: sound,
                  iconData: _featuredIconForSound(sound),
                  description: l10n.featuredDescription(sound.id),
                  gradientColors: _featuredGradientColorsForSound(sound),
                  borderColor: _featuredBorderColorForSound(sound),
                  onTap: () => onOpenSoundRoom(sound),
                ),
                const SizedBox(height: 16),
              ],
              const SizedBox(height: 8),
            ],
            Text(l10n.allSoundsLabel, style: textTheme.titleLarge),
            const SizedBox(height: 12),
            ...sounds.map((SoundItem sound) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: SoundLibraryTile(
                  sound: sound,
                  isSelected: sound.id == currentSound.id,
                  onTap:
                      sound.videoPath == null
                          ? () => onSelectSound(sound)
                          : () => onOpenSoundRoom(sound),
                  onToggleFavorite: () => onToggleFavorite(sound),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _FavoriteRoomsEmptyCard extends StatelessWidget {
  const _FavoriteRoomsEmptyCard({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return GlassPanel(
      borderRadius: const BorderRadius.all(Radius.circular(28)),
      gradientColors: const <Color>[Color(0x1AF4EDE3), Color(0x10FFFFFF)],
      borderColor: const Color(0x26F4EDE3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Padding(
              padding: EdgeInsets.all(12),
              child: Icon(Icons.favorite_border_rounded, color: Colors.white),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(child: Text(message, style: textTheme.bodyMedium)),
        ],
      ),
    );
  }
}

class _FeaturedSoundCard extends StatelessWidget {
  const _FeaturedSoundCard({
    required this.sound,
    required this.iconData,
    required this.description,
    required this.gradientColors,
    required this.borderColor,
    required this.onTap,
  });

  final SoundItem sound;
  final IconData iconData;
  final String description;
  final List<Color> gradientColors;
  final Color borderColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = context.l10n;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(28),
      child: GlassPanel(
        borderRadius: const BorderRadius.all(Radius.circular(28)),
        gradientColors: gradientColors,
        borderColor: borderColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: Icon(iconData, color: Colors.white, size: 26),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        l10n.soundTitle(sound.id, fallback: sound.title),
                        style: textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${l10n.soundCategoryLabel(sound.category)} · ${l10n.durationLabel(sound.duration)}',
                        style: textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.play_circle_fill_rounded, size: 32),
              ],
            ),
            const SizedBox(height: 16),
            Text(description, style: textTheme.bodyMedium),
            const SizedBox(height: 10),
            Text(
              l10n.moodTagLabels(sound.moodTags).join(' · '),
              style: textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

IconData _featuredIconForSound(SoundItem sound) {
  switch (sound.id) {
    case 'afternoon_rain':
      return Icons.umbrella_rounded;
    case 'in_the_universe':
      return Icons.auto_awesome_rounded;
    case 'under_the_stars':
      return Icons.bedtime_rounded;
    case 'yoga':
      return Icons.self_improvement_rounded;
    case 'crisp_morning':
      return Icons.wb_sunny_outlined;
    case 'stormy_night':
      return Icons.thunderstorm_rounded;
    case 'summer_night':
      return Icons.nightlight_round;
    case 'sunset_beach':
      return Icons.waves_rounded;
    case 'weekend_rainy_day':
      return Icons.weekend_rounded;
    default:
      return Icons.music_note_rounded;
  }
}

List<Color> _featuredGradientColorsForSound(SoundItem sound) {
  switch (sound.id) {
    case 'afternoon_rain':
      return const <Color>[Color(0x334B78A8), Color(0x1AB4C7D9)];
    case 'in_the_universe':
      return const <Color>[Color(0x3A7D8CFF), Color(0x1AB98299)];
    case 'under_the_stars':
      return const <Color>[Color(0x33A6C0C5), Color(0x1AD9B99B)];
    case 'yoga':
      return const <Color>[Color(0x3AB98299), Color(0x1AF4EDE3)];
    case 'crisp_morning':
      return const <Color>[Color(0x33F0CF8D), Color(0x1AF4EDE3)];
    case 'stormy_night':
      return const <Color>[Color(0x334B5B8F), Color(0x1A9EA7C7)];
    case 'summer_night':
      return const <Color>[Color(0x334E5B89), Color(0x1AB98299)];
    case 'sunset_beach':
      return const <Color>[Color(0x33F2A974), Color(0x1AD9B99B)];
    case 'weekend_rainy_day':
      return const <Color>[Color(0x33738FA6), Color(0x1AB98299)];
    default:
      return const <Color>[Color(0x22FFFFFF), Color(0x12FFFFFF)];
  }
}

Color _featuredBorderColorForSound(SoundItem sound) {
  switch (sound.id) {
    case 'afternoon_rain':
      return const Color(0x446E9AC7);
    case 'in_the_universe':
      return const Color(0x448EA0FF);
    case 'under_the_stars':
      return const Color(0x44D9B99B);
    case 'yoga':
      return const Color(0x33F4EDE3);
    case 'crisp_morning':
      return const Color(0x44E8C792);
    case 'stormy_night':
      return const Color(0x44697CB2);
    case 'summer_night':
      return const Color(0x44798AB4);
    case 'sunset_beach':
      return const Color(0x44E0B087);
    case 'weekend_rainy_day':
      return const Color(0x447F9CB6);
    default:
      return const Color(0x20FFFFFF);
  }
}
