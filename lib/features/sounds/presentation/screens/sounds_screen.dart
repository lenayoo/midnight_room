import 'package:flutter/material.dart';

import '../../../../core/theme/app_gradients.dart';
import '../../../../core/widgets/ambient_background.dart';
import '../../../../core/widgets/glass_panel.dart';
import '../../../../data/models/sound_item.dart';
import '../widgets/sound_library_tile.dart';

class SoundsScreen extends StatelessWidget {
  const SoundsScreen({
    required this.sounds,
    required this.currentSound,
    required this.isPlaying,
    required this.volume,
    required this.onSelectSound,
    required this.onOpenSoundRoom,
    required this.onToggleFavorite,
    required this.onPlayPause,
    required this.onVolumeChanged,
    super.key,
  });

  final List<SoundItem> sounds;
  final SoundItem currentSound;
  final bool isPlaying;
  final double volume;
  final ValueChanged<SoundItem> onSelectSound;
  final ValueChanged<SoundItem> onOpenSoundRoom;
  final ValueChanged<SoundItem> onToggleFavorite;
  final VoidCallback onPlayPause;
  final ValueChanged<double> onVolumeChanged;

  @override
  Widget build(BuildContext context) {
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
            Text('Sounds', style: textTheme.displayMedium),
            const SizedBox(height: 8),
            Text('Pick one sound and press play.', style: textTheme.bodyMedium),
            const SizedBox(height: 20),
            GestureDetector(
              onTap:
                  currentSound.videoPath == null
                      ? null
                      : () => onOpenSoundRoom(currentSound),
              child: GlassPanel(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Selected sound', style: textTheme.titleMedium),
                    const SizedBox(height: 12),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                currentSound.title,
                                style: textTheme.headlineSmall,
                              ),
                              const SizedBox(height: 6),
                              Text(
                                '${currentSound.category} · ${currentSound.duration}',
                                style: textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () => onToggleFavorite(currentSound),
                          icon: Icon(
                            currentSound.isFavorite
                                ? Icons.favorite_rounded
                                : Icons.favorite_border_rounded,
                          ),
                        ),
                      ],
                    ),
                    if (currentSound.videoPath != null) ...<Widget>[
                      const SizedBox(height: 6),
                      Text('Tap to enter the room.', style: textTheme.bodySmall),
                    ],
                    const SizedBox(height: 16),
                    FilledButton.icon(
                      onPressed: onPlayPause,
                      icon: Icon(
                        isPlaying
                            ? Icons.pause_circle_outline_rounded
                            : Icons.play_circle_outline_rounded,
                      ),
                      label: Text(isPlaying ? 'Pause' : 'Play'),
                    ),
                    const SizedBox(height: 16),
                    Text('Volume', style: textTheme.bodySmall),
                    Slider(value: volume, onChanged: onVolumeChanged),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text('All sounds', style: textTheme.titleLarge),
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
