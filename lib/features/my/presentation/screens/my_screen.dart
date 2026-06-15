import 'package:flutter/material.dart';

import '../../../../core/theme/app_gradients.dart';
import '../../../../core/widgets/ambient_background.dart';
import '../../../../core/widgets/app_brand_mark.dart';
import '../../../../core/widgets/glass_panel.dart';
import '../../../../data/models/quote_item.dart';
import '../../../../data/models/sound_item.dart';

class MyScreen extends StatelessWidget {
  const MyScreen({
    required this.savedQuotes,
    required this.favoriteSounds,
    super.key,
  });

  final List<QuoteItem> savedQuotes;
  final List<SoundItem> favoriteSounds;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return AmbientBackground(
      gradient: AppGradients.screenBackground(3),
      primaryOrbColors: const <Color>[Color(0x44D9B99B), Color(0x003A335C)],
      secondaryOrbColors: const <Color>[Color(0x22B98299), Color(0x0011182E)],
      child: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
          children: <Widget>[
            const AppBrandMark(
              subtitle:
                  'Your saved reflections, favorite rooms, and quiet routine.',
            ),
            const SizedBox(height: 20),
            Text('My', style: textTheme.displayMedium),
            const SizedBox(height: 8),
            Text(
              'Only saved quotes and favorite sounds are shown here.',
              style: textTheme.bodyMedium,
            ),
            const SizedBox(height: 20),
            Row(
              children: <Widget>[
                Expanded(
                  child: _CountCard(
                    label: 'Saved quotes',
                    value: '${savedQuotes.length}',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _CountCard(
                    label: 'Favorite sounds',
                    value: '${favoriteSounds.length}',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _SimpleListCard(
              title: 'Saved quotes',
              items: savedQuotes
                  .map((QuoteItem quote) => quote.text)
                  .toList(growable: false),
              emptyText: 'No saved quotes yet.',
            ),
            const SizedBox(height: 12),
            _SimpleListCard(
              title: 'Favorite sounds',
              items: favoriteSounds
                  .map((SoundItem sound) => sound.title)
                  .toList(growable: false),
              emptyText: 'No favorite sounds yet.',
            ),
          ],
        ),
      ),
    );
  }
}

class _CountCard extends StatelessWidget {
  const _CountCard({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      padding: const EdgeInsets.all(16),
      borderRadius: const BorderRadius.all(Radius.circular(24)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(label, style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 8),
          Text(value, style: Theme.of(context).textTheme.headlineMedium),
        ],
      ),
    );
  }
}

class _SimpleListCard extends StatelessWidget {
  const _SimpleListCard({
    required this.title,
    required this.items,
    required this.emptyText,
  });

  final String title;
  final List<String> items;
  final String emptyText;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return GlassPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title, style: textTheme.titleMedium),
          const SizedBox(height: 12),
          if (items.isEmpty)
            Text(emptyText, style: textTheme.bodyMedium)
          else
            ...items.map((String item) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(item, style: textTheme.bodyMedium),
              );
            }),
        ],
      ),
    );
  }
}
