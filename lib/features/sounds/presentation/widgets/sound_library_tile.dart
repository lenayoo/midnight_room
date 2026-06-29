import 'package:flutter/material.dart';

import '../../../../core/localization/app_localizations.dart';
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
    final AppLocalizations l10n = context.l10n;
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
              child: _LeadingSymbol(sound: sound),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    l10n.soundTitle(sound.id, fallback: sound.title),
                    style: textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${l10n.soundCategoryLabel(sound.category)} · ${l10n.durationLabel(sound.duration)}',
                    style: textTheme.bodySmall,
                  ),
                ],
              ),
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
}

class _LeadingSymbol extends StatelessWidget {
  const _LeadingSymbol({required this.sound});

  final SoundItem sound;

  @override
  Widget build(BuildContext context) {
    return Icon(_iconForSound(sound), color: Colors.white, size: 21);
  }
}

IconData _iconForSound(SoundItem sound) {
  switch (sound.id) {
    case 'afternoon_rain':
      return Icons.umbrella_rounded;
    case 'in_the_universe':
      return Icons.nights_stay_rounded;
    case 'under_the_stars':
      return Icons.star_rounded;
    case 'crisp_morning':
      return Icons.wb_sunny_rounded;
    case 'stormy_night':
      return Icons.thunderstorm_rounded;
    case 'sunset_beach':
      return Icons.wb_twilight_rounded;
    case 'weekend_rainy_day':
      return Icons.cloud_rounded;
    default:
      return _iconForCategory(sound.category);
  }
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
    case 'Yoga':
      return Icons.self_improvement_rounded;
    default:
      return Icons.music_note_rounded;
  }
}
