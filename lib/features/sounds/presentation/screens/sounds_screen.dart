import 'package:flutter/material.dart';

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
    final TextTheme textTheme = Theme.of(context).textTheme;
    final Set<String> featuredRoomIds =
        featuredRooms.map((SoundItem sound) => sound.id).toSet();
    final List<SoundItem> librarySounds = sounds
        .where((SoundItem sound) => !featuredRoomIds.contains(sound.id))
        .toList(growable: false);

    return AmbientBackground(
      gradient: AppGradients.screenBackground(0),
      primaryOrbColors: const <Color>[Color(0x55F4EDE3), Color(0x003A335C)],
      secondaryOrbColors: const <Color>[Color(0x33B98299), Color(0x0011182E)],
      child: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
          children: <Widget>[
            Text('Sound library', style: textTheme.displayMedium),
            const SizedBox(height: 8),
            Text('Pick one sound and press play.', style: textTheme.bodyMedium),
            const SizedBox(height: 20),
            for (final SoundItem sound in featuredRooms) ...<Widget>[
              SectionHeader(title: sound.title),
              const SizedBox(height: 12),
              _FeaturedSoundCard(
                sound: sound,
                iconData: _featuredIconForSound(sound),
                description: _featuredDescriptionForSound(sound),
                gradientColors: _featuredGradientColorsForSound(sound),
                borderColor: _featuredBorderColorForSound(sound),
                onTap: () => onOpenSoundRoom(sound),
              ),
              const SizedBox(height: 24),
            ],
            Text('All sounds', style: textTheme.titleLarge),
            const SizedBox(height: 12),
            ...librarySounds.map((SoundItem sound) {
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
                      Text(sound.title, style: textTheme.headlineSmall),
                      const SizedBox(height: 4),
                      Text(
                        '${sound.category} · ${sound.duration}',
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
            Text(sound.moodTags.join(' · '), style: textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}

IconData _featuredIconForSound(SoundItem sound) {
  switch (sound.id) {
    case 'in_the_universe':
      return Icons.auto_awesome_rounded;
    case 'deep_sleep':
      return Icons.bedtime_rounded;
    default:
      return Icons.self_improvement_rounded;
  }
}

String _featuredDescriptionForSound(SoundItem sound) {
  switch (sound.id) {
    case 'in_the_universe':
      return 'A quiet cosmic room for slow sleep, stillness, and a softer night pace.';
    case 'deep_sleep':
      return 'Palm shadows, warm air, and a slower rhythm for deep late-night rest.';
    default:
      return 'Open the Yoga room for gentle breath, space, and grounded movement.';
  }
}

List<Color> _featuredGradientColorsForSound(SoundItem sound) {
  switch (sound.id) {
    case 'in_the_universe':
      return const <Color>[Color(0x3A7D8CFF), Color(0x1AB98299)];
    case 'deep_sleep':
      return const <Color>[Color(0x33A6C0C5), Color(0x1AD9B99B)];
    default:
      return const <Color>[Color(0x3AB98299), Color(0x1AF4EDE3)];
  }
}

Color _featuredBorderColorForSound(SoundItem sound) {
  switch (sound.id) {
    case 'in_the_universe':
      return const Color(0x448EA0FF);
    case 'deep_sleep':
      return const Color(0x44D9B99B);
    default:
      return const Color(0x33F4EDE3);
  }
}
