import 'package:flutter/material.dart';

import '../../../../core/widgets/glass_panel.dart';
import '../../../../data/models/sound_mix.dart';

class MixStudioCard extends StatelessWidget {
  const MixStudioCard({
    required this.mix,
    required this.isPremium,
    required this.onTap,
    super.key,
  });

  final SoundMix mix;
  final bool isPremium;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return GlassPanel(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Mix Studio', style: textTheme.titleLarge),
                    const SizedBox(height: 6),
                    Text(
                      'Layer rain, piano, wind, and cafe textures into one room.',
                      style: textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: const LinearGradient(
                    colors: <Color>[Color(0x66D9B99B), Color(0x663A335C)],
                  ),
                ),
                child: const Icon(Icons.layers_rounded),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children:
                mix.layers.map((String layer) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(999),
                      color: Colors.white.withValues(alpha: 0.08),
                    ),
                    child: Text(layer, style: textTheme.bodySmall),
                  );
                }).toList(),
          ),
          const SizedBox(height: 18),
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  isPremium
                      ? 'Ready to save custom mixes.'
                      : 'Locked in free preview.',
                  style: textTheme.bodyMedium,
                ),
              ),
              const SizedBox(width: 12),
              FilledButton(
                onPressed: onTap,
                child: Text(isPremium ? 'Open Studio' : 'Unlock'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
