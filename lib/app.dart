import 'package:flutter/material.dart';

import 'core/localization/app_localizations.dart';
import 'core/theme/app_theme.dart';
import 'features/shell/presentation/screens/launch_flow_screen.dart';

class SoundscapeDaysApp extends StatelessWidget {
  const SoundscapeDaysApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateTitle: (BuildContext context) => context.l10n.appName,
      debugShowCheckedModeBanner: false,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      theme: AppTheme.build(),
      builder: (BuildContext context, Widget? child) {
        final Locale locale =
            Localizations.maybeLocaleOf(context) ?? const Locale('en');
        return Theme(
          data: AppTheme.build(locale),
          child: child ?? const SizedBox.shrink(),
        );
      },
      home: const LaunchFlowScreen(),
    );
  }
}
