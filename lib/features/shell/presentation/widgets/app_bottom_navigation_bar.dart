import 'package:flutter/material.dart';

import '../../../../core/localization/app_localizations.dart';

class AppBottomNavigationBar extends StatelessWidget {
  const AppBottomNavigationBar({
    required this.currentIndex,
    required this.onTap,
    this.profileLabel,
    super.key,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;
  final String? profileLabel;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = context.l10n;

    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: onTap,
      backgroundColor: const Color(0xFF11182E),
      destinations: <Widget>[
        NavigationDestination(
          icon: Icon(Icons.graphic_eq_rounded),
          label: l10n.soundsTabLabel,
        ),
        NavigationDestination(
          icon: Icon(Icons.auto_awesome_rounded),
          label: l10n.quoteTabLabel,
        ),
        NavigationDestination(
          icon: Icon(Icons.person_outline_rounded),
          label: _resolvedProfileLabel(l10n.myTabLabel),
        ),
      ],
    );
  }

  String _resolvedProfileLabel(String fallbackLabel) {
    final String? trimmedLabel = profileLabel?.trim();
    if (trimmedLabel == null || trimmedLabel.isEmpty) {
      return fallbackLabel;
    }

    return trimmedLabel;
  }
}
