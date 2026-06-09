import 'package:flutter/material.dart';

import '../../../../core/widgets/glass_panel.dart';
import '../../../../data/models/sound_item.dart';

class SoundLibraryTile extends StatelessWidget {
  const SoundLibraryTile({
    required this.sound,
    required this.isSelected,
    required this.onTap,
    required this.onToggleFavorite,
    super.key,
  });

  final SoundItem sound;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onToggleFavorite;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: GlassPanel(
        padding: const EdgeInsets.all(16),
        borderRadius: const BorderRadius.all(Radius.circular(24)),
        gradientColors:
            isSelected
                ? const <Color>[Color(0x3AF4EDE3), Color(0x1AFFFFFF)]
                : const <Color>[Color(0x22FFFFFF), Color(0x12FFFFFF)],
        borderColor:
            isSelected ? const Color(0x55F4EDE3) : const Color(0x20FFFFFF),
        child: Row(
          children: <Widget>[
            CircleAvatar(
              radius: 22,
              backgroundColor: Colors.white.withValues(alpha: 0.12),
              child: Icon(
                _iconForCategory(sound.category),
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(sound.title, style: textTheme.titleMedium),
                  const SizedBox(height: 4),
                  Text(
                    '${sound.category} · ${sound.duration}',
                    style: textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            if (isSelected)
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Text('Selected', style: textTheme.bodySmall),
              ),
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
      ),
    );
  }

  IconData _iconForCategory(String category) {
    switch (category) {
      case 'Nature':
        return Icons.park_outlined;
      case 'City':
        return Icons.apartment_rounded;
      case 'Cafe':
        return Icons.local_cafe_outlined;
      case 'Focus':
        return Icons.menu_book_rounded;
      case 'ASMR':
        return Icons.nightlight_round;
      case 'Sleep':
        return Icons.bedtime_outlined;
      default:
        return Icons.music_note_rounded;
    }
  }
}
