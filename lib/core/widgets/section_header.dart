import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({required this.title, this.actionLabel, super.key});

  final String title;
  final String? actionLabel;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Row(
      children: <Widget>[
        Expanded(child: Text(title, style: textTheme.titleLarge)),
        if (actionLabel != null) Text(actionLabel!, style: textTheme.bodySmall),
      ],
    );
  }
}
