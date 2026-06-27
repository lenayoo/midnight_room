import 'package:flutter/material.dart';

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
    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: onTap,
      backgroundColor: const Color(0xFF11182E),
      destinations: <Widget>[
        const NavigationDestination(
          icon: Icon(Icons.graphic_eq_rounded),
          label: 'Sounds',
        ),
        const NavigationDestination(
          icon: Icon(Icons.auto_awesome_rounded),
          label: 'Quote',
        ),
        NavigationDestination(
          icon: Icon(Icons.person_outline_rounded),
          label: _resolvedProfileLabel,
        ),
      ],
    );
  }

  String get _resolvedProfileLabel {
    final String? trimmedLabel = profileLabel?.trim();
    if (trimmedLabel == null || trimmedLabel.isEmpty) {
      return 'My';
    }

    return trimmedLabel;
  }
}
