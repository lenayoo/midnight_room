import 'package:flutter/material.dart';

import '../../../../core/widgets/glass_panel.dart';

class AppBottomNavigationBar extends StatelessWidget {
  const AppBottomNavigationBar({
    required this.currentIndex,
    required this.onTap,
    super.key,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  static const List<_NavItem> _items = <_NavItem>[
    _NavItem('Sounds', Icons.graphic_eq_rounded),
    _NavItem('Timer', Icons.timelapse_rounded),
    _NavItem('Quote', Icons.auto_awesome_rounded),
    _NavItem('My', Icons.nights_stay_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 0, 18, 20),
      child: GlassPanel(
        padding: const EdgeInsets.all(8),
        borderRadius: const BorderRadius.all(Radius.circular(30)),
        gradientColors: const <Color>[Color(0x4D0B1020), Color(0x7311182E)],
        child: Row(
          children: List<Widget>.generate(_items.length, (int index) {
            final _NavItem item = _items[index];
            final bool isActive = index == currentIndex;

            return Expanded(
              child: InkWell(
                borderRadius: BorderRadius.circular(22),
                onTap: () => onTap(index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 260),
                  curve: Curves.easeOutCubic,
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 8,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22),
                    gradient:
                        isActive
                            ? const LinearGradient(
                              colors: <Color>[
                                Color(0x30F4EDE3),
                                Color(0x18FFFFFF),
                              ],
                            )
                            : null,
                    border:
                        isActive
                            ? Border.all(
                              color: Colors.white.withValues(alpha: 0.12),
                            )
                            : null,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(
                        item.icon,
                        color:
                            isActive
                                ? Colors.white
                                : Colors.white.withValues(alpha: 0.6),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        item.label,
                        style: textTheme.bodySmall?.copyWith(
                          color:
                              isActive
                                  ? Colors.white
                                  : Colors.white.withValues(alpha: 0.58),
                          fontWeight:
                              isActive ? FontWeight.w600 : FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class _NavItem {
  const _NavItem(this.label, this.icon);

  final String label;
  final IconData icon;
}
