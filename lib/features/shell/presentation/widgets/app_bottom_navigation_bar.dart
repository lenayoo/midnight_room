import 'package:flutter/material.dart';

class AppBottomNavigationBar extends StatelessWidget {
  const AppBottomNavigationBar({
    required this.currentIndex,
    required this.onTap,
    super.key,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: onTap,
      backgroundColor: const Color(0xFF11182E),
      destinations: const <Widget>[
        NavigationDestination(
          icon: Icon(Icons.graphic_eq_rounded),
          label: 'Sounds',
        ),
        NavigationDestination(
          icon: Icon(Icons.auto_awesome_rounded),
          label: 'Quote',
        ),
        NavigationDestination(
          icon: Icon(Icons.person_outline_rounded),
          label: 'My',
        ),
      ],
    );
  }
}
