import 'package:flutter/material.dart';

import '../localization/app_localizations.dart';
import '../theme/app_typography.dart';
import 'glass_panel.dart';

class AppBrandMark extends StatelessWidget {
  const AppBrandMark({required this.subtitle, super.key});

  final String subtitle;

  static const String _logoAssetPath = 'assets/images/appIcon.png';

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = context.l10n;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return GlassPanel(
      padding: const EdgeInsets.all(16),
      borderRadius: const BorderRadius.all(Radius.circular(32)),
      gradientColors: const <Color>[Color(0x2AF4EDE3), Color(0x16B98299)],
      borderColor: const Color(0x36F4EDE3),
      child: Row(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Image.asset(
              _logoAssetPath,
              width: 76,
              height: 76,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  l10n.appName,
                  style: AppTypography.brandTitle(
                    textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(subtitle, style: textTheme.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
