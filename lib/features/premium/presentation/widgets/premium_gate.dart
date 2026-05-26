import 'package:flutter/material.dart';

import '../../../../core/widgets/glass_panel.dart';

class PremiumGate extends StatelessWidget {
  const PremiumGate({
    required this.isPremium,
    required this.child,
    required this.onUnlock,
    this.title = 'Premium feature',
    this.subtitle = 'Unlock this room to continue.',
    super.key,
  });

  final bool isPremium;
  final Widget child;
  final VoidCallback onUnlock;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    if (isPremium) {
      return child;
    }

    return Stack(
      children: <Widget>[
        IgnorePointer(child: Opacity(opacity: 0.55, child: child)),
        Positioned.fill(
          child: GlassPanel(
            padding: const EdgeInsets.all(18),
            borderRadius: const BorderRadius.all(Radius.circular(28)),
            gradientColors: const <Color>[Color(0x66FFFFFF), Color(0x26FFFFFF)],
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Icon(Icons.workspace_premium_rounded, size: 34),
                const SizedBox(height: 12),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 18),
                FilledButton(
                  onPressed: onUnlock,
                  child: const Text('See Premium'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
