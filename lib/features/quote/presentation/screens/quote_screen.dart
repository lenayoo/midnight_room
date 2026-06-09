import 'package:flutter/material.dart';

import '../../../../core/theme/app_gradients.dart';
import '../../../../core/widgets/ambient_background.dart';
import '../../../../core/widgets/glass_panel.dart';
import '../../../../data/models/quote_item.dart';

class QuoteScreen extends StatelessWidget {
  const QuoteScreen({
    required this.quote,
    required this.isLoading,
    required this.categories,
    required this.selectedCategory,
    required this.savedCount,
    required this.onSelectCategory,
    required this.onToggleSaved,
    required this.onNextQuote,
    super.key,
  });

  final QuoteItem? quote;
  final bool isLoading;
  final List<String> categories;
  final String selectedCategory;
  final int savedCount;
  final ValueChanged<String> onSelectCategory;
  final VoidCallback onToggleSaved;
  final VoidCallback onNextQuote;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return AmbientBackground(
      gradient: AppGradients.screenBackground(2),
      primaryOrbColors: AppGradients.quoteCard,
      secondaryOrbColors: const <Color>[Color(0x26F4EDE3), Color(0x0011182E)],
      child: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
          children: <Widget>[
            Text('Quote', style: textTheme.displayMedium),
            const SizedBox(height: 8),
            Text(
              'Read one quote and save it if you want.',
              style: textTheme.bodyMedium,
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: categories
                  .map((String category) {
                    final bool isSelected = category == selectedCategory;

                    return ChoiceChip(
                      label: Text(_labelForCategory(category)),
                      selected: isSelected,
                      onSelected: (_) => onSelectCategory(category),
                    );
                  })
                  .toList(growable: false),
            ),
            const SizedBox(height: 16),
            GlassPanel(
              child:
                  isLoading
                      ? const Text('Loading quotes...')
                      : quote == null
                      ? const Text('No quotes found.')
                      : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            quote!.text,
                            style: textTheme.headlineSmall?.copyWith(
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            _labelForCategory(selectedCategory),
                            style: textTheme.bodySmall,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Saved quotes: $savedCount',
                            style: textTheme.bodySmall,
                          ),
                        ],
                      ),
            ),
            const SizedBox(height: 20),
            Row(
              children: <Widget>[
                Expanded(
                  child: FilledButton(
                    onPressed: quote == null ? null : onToggleSaved,
                    child: Text(quote?.isSaved ?? false ? 'Saved' : 'Save'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: onNextQuote,
                    child: const Text('Next quote'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _labelForCategory(String category) {
    switch (category) {
      case 'calm':
        return 'Calm';
      case 'hope':
        return 'Hope';
      case 'reflection':
        return 'Reflection';
      default:
        if (category.isEmpty) {
          return '';
        }
        return '${category[0].toUpperCase()}${category.substring(1)}';
    }
  }
}
