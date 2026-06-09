import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_gradients.dart';
import '../../../../core/widgets/ambient_background.dart';
import '../../../../core/widgets/glass_panel.dart';
import '../../../../data/models/quote_item.dart';

class QuoteScreen extends StatelessWidget {
  const QuoteScreen({
    required this.quote,
    required this.savedCount,
    required this.onToggleSaved,
    required this.onNextQuote,
    super.key,
  });

  final QuoteItem quote;
  final int savedCount;
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
            GlassPanel(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    AppStrings.formatLongDate(quote.date),
                    style: textTheme.bodySmall,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    quote.text,
                    style: textTheme.headlineSmall?.copyWith(height: 1.4),
                  ),
                  const SizedBox(height: 12),
                  Text(quote.author, style: textTheme.titleMedium),
                  const SizedBox(height: 16),
                  Text('Saved quotes: $savedCount', style: textTheme.bodySmall),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: <Widget>[
                Expanded(
                  child: FilledButton(
                    onPressed: onToggleSaved,
                    child: Text(quote.isSaved ? 'Saved' : 'Save'),
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
}
