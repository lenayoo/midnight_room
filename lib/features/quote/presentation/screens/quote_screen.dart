import 'package:flutter/material.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_gradients.dart';
import '../../../../core/widgets/ambient_background.dart';
import '../../../../data/models/quote_item.dart';

class QuoteScreen extends StatelessWidget {
  const QuoteScreen({
    required this.quote,
    required this.isLoading,
    required this.categories,
    required this.selectedCategory,
    required this.onSelectCategory,
    super.key,
  });

  final QuoteItem? quote;
  final bool isLoading;
  final List<String> categories;
  final String selectedCategory;
  final ValueChanged<String> onSelectCategory;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = context.l10n;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return AmbientBackground(
      gradient: AppGradients.screenBackground(2),
      primaryOrbColors: const <Color>[Color(0x44E4C8A7), Color(0x00E4C8A7)],
      secondaryOrbColors: const <Color>[Color(0x33C38B86), Color(0x0011182E)],
      primaryAlignment: const Alignment(0.88, -0.82),
      secondaryAlignment: const Alignment(-0.72, 0.58),
      child: SafeArea(
        bottom: false,
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 116),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - 24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      l10n.quoteScreenTitle,
                      style: textTheme.displayMedium?.copyWith(
                        color: AppColors.moonWhite,
                      ),
                    ),
                    const SizedBox(height: 44),
                    _QuoteStage(
                      quote: quote,
                      isLoading: isLoading,
                      selectedCategoryLabel: l10n.quoteCategoryLabel(
                        selectedCategory,
                      ),
                    ),
                    const SizedBox(height: 40),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: categories
                          .map((String category) {
                            return _CategoryPill(
                              label: l10n.quoteCategoryLabel(category),
                              isSelected: category == selectedCategory,
                              onTap: () => onSelectCategory(category),
                            );
                          })
                          .toList(growable: false),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _QuoteStage extends StatelessWidget {
  const _QuoteStage({
    required this.quote,
    required this.isLoading,
    required this.selectedCategoryLabel,
  });

  final QuoteItem? quote;
  final bool isLoading;
  final String selectedCategoryLabel;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = context.l10n;
    final TextTheme textTheme = Theme.of(context).textTheme;

    if (isLoading) {
      return Text(
        l10n.loadingQuotesLabel,
        style: textTheme.bodyLarge?.copyWith(
          color: AppColors.moonWhite.withValues(alpha: 0.78),
        ),
      );
    }

    if (quote == null) {
      return Text(
        l10n.noQuotesFoundLabel,
        style: textTheme.bodyLarge?.copyWith(
          color: AppColors.moonWhite.withValues(alpha: 0.78),
        ),
      );
    }

    final bool hasAuthor = quote!.author.trim().isNotEmpty;

    return Stack(
      clipBehavior: Clip.none,
      children: <Widget>[
        Positioned(
          top: -24,
          left: -6,
          child: Text(
            '“',
            style: textTheme.displayLarge?.copyWith(
              fontSize: 132,
              color: AppColors.moonWhite.withValues(alpha: 0.1),
              height: 0.8,
            ),
          ),
        ),
        Positioned(
          top: 60,
          right: 0,
          child: DecoratedBox(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: <Color>[Color(0x2EE4C8A7), Color(0x00E4C8A7)],
              ),
            ),
            child: const SizedBox(width: 140, height: 140),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 34, 12, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                quote!.text,
                style: textTheme.headlineLarge?.copyWith(
                  color: AppColors.moonWhite,
                  height: 1.52,
                  letterSpacing: -0.2,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 26),
              if (hasAuthor)
                Text(
                  quote!.author,
                  style: textTheme.titleMedium?.copyWith(
                    color: AppColors.warmBeige,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              if (hasAuthor) const SizedBox(height: 8),
              Text(
                '${l10n.formatQuoteDate(quote!.date)}  ·  $selectedCategoryLabel',
                style: textTheme.bodySmall?.copyWith(
                  color: AppColors.moonWhite.withValues(alpha: 0.58),
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CategoryPill extends StatelessWidget {
  const _CategoryPill({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? AppColors.warmBeige.withValues(alpha: 0.2)
                  : Colors.white.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color:
                isSelected
                    ? AppColors.warmBeige.withValues(alpha: 0.44)
                    : Colors.white.withValues(alpha: 0.12),
          ),
        ),
        child: Text(
          label,
          style: textTheme.labelMedium?.copyWith(
            color:
                isSelected
                    ? AppColors.warmBeige
                    : AppColors.moonWhite.withValues(alpha: 0.76),
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
        ),
      ),
    );
  }
}
