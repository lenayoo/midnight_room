import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_gradients.dart';
import '../../../../core/widgets/ambient_background.dart';
import '../../../../core/widgets/floating_sparkles.dart';
import '../../../../core/widgets/soft_reveal_text.dart';
import '../../../profile/services/user_profile_service.dart';
import 'home_shell_screen.dart';

enum _LaunchMode { loading, askName, welcomeBack, home }

class LaunchFlowScreen extends StatefulWidget {
  const LaunchFlowScreen({
    this.userProfileService = const UserProfileService(),
    super.key,
  });

  final UserProfileService userProfileService;

  @override
  State<LaunchFlowScreen> createState() => _LaunchFlowScreenState();
}

class _LaunchFlowScreenState extends State<LaunchFlowScreen> {
  final TextEditingController _nameController = TextEditingController();
  final FocusNode _nameFocusNode = FocusNode();

  _LaunchMode _launchMode = _LaunchMode.loading;
  String? _userName;
  bool _isSavingName = false;

  @override
  void initState() {
    super.initState();
    unawaited(_restoreUserName());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nameFocusNode.dispose();
    super.dispose();
  }

  Future<void> _restoreUserName() async {
    final String? storedUserName =
        await widget.userProfileService.loadUserName();

    if (!mounted) {
      return;
    }

    if (storedUserName == null) {
      setState(() {
        _launchMode = _LaunchMode.askName;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _nameFocusNode.requestFocus();
        }
      });
      return;
    }

    setState(() {
      _userName = storedUserName;
      _launchMode = _LaunchMode.welcomeBack;
    });
  }

  Future<void> _submitName() async {
    if (_launchMode == _LaunchMode.welcomeBack) {
      setState(() {
        _launchMode = _LaunchMode.home;
      });
      return;
    }

    final String trimmedName = _nameController.text.trim();
    if (trimmedName.isEmpty || _isSavingName) {
      return;
    }

    FocusScope.of(context).unfocus();

    setState(() {
      _isSavingName = true;
    });

    await widget.userProfileService.saveUserName(trimmedName);

    if (!mounted) {
      return;
    }

    setState(() {
      _userName = trimmedName;
      _isSavingName = false;
      _launchMode = _LaunchMode.home;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_launchMode == _LaunchMode.loading) {
      return const ColoredBox(color: Colors.black);
    }

    if (_launchMode == _LaunchMode.home) {
      return HomeShellScreen(userName: _userName);
    }

    return _LaunchScene(
      key: ValueKey<_LaunchMode>(_launchMode),
      mode: _launchMode,
      userName: _userName,
      nameController: _nameController,
      nameFocusNode: _nameFocusNode,
      isSavingName: _isSavingName,
      onSubmitName: _submitName,
    );
  }
}

class _LaunchScene extends StatefulWidget {
  const _LaunchScene({
    required this.mode,
    required this.userName,
    required this.nameController,
    required this.nameFocusNode,
    required this.isSavingName,
    required this.onSubmitName,
    super.key,
  });

  final _LaunchMode mode;
  final String? userName;
  final TextEditingController nameController;
  final FocusNode nameFocusNode;
  final bool isSavingName;
  final VoidCallback onSubmitName;

  @override
  State<_LaunchScene> createState() => _LaunchSceneState();
}

class _LaunchSceneState extends State<_LaunchScene>
    with SingleTickerProviderStateMixin {
  static const Duration _revealDuration = Duration(milliseconds: 2200);

  late final AnimationController _revealController;

  @override
  void initState() {
    super.initState();
    _revealController = AnimationController(
      vsync: this,
      duration: _revealDuration,
    )..forward();
  }

  @override
  void dispose() {
    _revealController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = context.l10n;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Colors.black,
      body: AmbientBackground(
        gradient: AppGradients.shell,
        child: Stack(
          children: <Widget>[
            const Positioned.fill(child: FloatingSparkles()),
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                    24,
                    32,
                    24,
                    32 + MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 420),
                    child: AnimatedBuilder(
                      animation: _revealController,
                      builder: (BuildContext context, _) {
                        final double progress = _revealController.value;
                        final double contentOpacity = intervalValue(
                          progress,
                          0.18,
                          0.96,
                        );

                        return AnimatedOpacity(
                          opacity: contentOpacity,
                          duration: const Duration(milliseconds: 280),
                          curve: Curves.easeOutCubic,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SoftRevealText(
                                text: l10n.appName,
                                progress: progress,
                                start: 0.02,
                                end: 0.22,
                                style: textTheme.displayLarge?.copyWith(
                                  color: AppColors.moonWhite,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 64,
                                  height: 0.94,
                                  letterSpacing: -0.4,
                                ),
                              ),
                              const SizedBox(height: 22),
                              SoftRevealDivider(
                                width: 74,
                                progress: progress,
                                start: 0.24,
                                end: 0.34,
                              ),
                              const SizedBox(height: 34),
                              _SceneCard(
                                mode: widget.mode,
                                userName: widget.userName,
                                nameController: widget.nameController,
                                nameFocusNode: widget.nameFocusNode,
                                isSavingName: widget.isSavingName,
                                onSubmitName: widget.onSubmitName,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SceneCard extends StatelessWidget {
  const _SceneCard({
    required this.mode,
    required this.userName,
    required this.nameController,
    required this.nameFocusNode,
    required this.isSavingName,
    required this.onSubmitName,
  });

  final _LaunchMode mode;
  final String? userName;
  final TextEditingController nameController;
  final FocusNode nameFocusNode;
  final bool isSavingName;
  final VoidCallback onSubmitName;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = context.l10n;
    final TextTheme textTheme = Theme.of(context).textTheme;
    final String languageCode = Localizations.localeOf(context).languageCode;

    switch (mode) {
      case _LaunchMode.loading:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              l10n.preparingRoomLabel,
              style: textTheme.titleLarge?.copyWith(color: AppColors.moonWhite),
            ),
            const SizedBox(height: 10),
            Text(
              l10n.oneQuietMomentLabel,
              style: textTheme.bodyMedium?.copyWith(
                color: AppColors.moonWhite.withValues(alpha: 0.72),
              ),
            ),
          ],
        );
      case _LaunchMode.askName:
        return ValueListenableBuilder<TextEditingValue>(
          valueListenable: nameController,
          builder: (BuildContext context, TextEditingValue value, _) {
            final bool hasText = value.text.trim().isNotEmpty;
            final bool canSubmit = hasText && !isSavingName;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  l10n.howCanICallYouLabel,
                  style: textTheme.headlineMedium?.copyWith(
                    color: AppColors.moonWhite,
                    fontWeight: FontWeight.w500,
                    fontSize: 34,
                    height: 1.08,
                  ),
                ),
                const SizedBox(height: 26),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          TextField(
                            controller: nameController,
                            focusNode: nameFocusNode,
                            textInputAction: TextInputAction.done,
                            onSubmitted:
                                (_) => FocusScope.of(context).unfocus(),
                            inputFormatters: <TextInputFormatter>[
                              LengthLimitingTextInputFormatter(18),
                            ],
                            cursorColor: AppColors.warmBeige,
                            decoration: InputDecoration(
                              isDense: true,
                              border: InputBorder.none,
                              hintText: l10n.yourNameHint,
                              hintStyle: textTheme.titleMedium?.copyWith(
                                color: AppColors.moonWhite.withValues(
                                  alpha: 0.3,
                                ),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            style: textTheme.titleLarge?.copyWith(
                              color: AppColors.moonWhite,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            height: 1,
                            color: AppColors.moonWhite.withValues(alpha: 0.34),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 22),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: canSubmit ? onSubmitName : null,
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.warmBeige,
                      disabledBackgroundColor: AppColors.moonWhite.withValues(
                        alpha: 0.18,
                      ),
                      foregroundColor: AppColors.deepNavy,
                      disabledForegroundColor: AppColors.moonWhite.withValues(
                        alpha: 0.38,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(999),
                      ),
                      elevation: 0,
                    ),
                    child:
                        isSavingName
                            ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                            : Text(
                              l10n.enterYourRoomLabel,
                              style: textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                  ),
                ),
              ],
            );
          },
        );
      case _LaunchMode.welcomeBack:
        final String displayName = userName ?? l10n.friendLabel;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              l10n.welcomeBackGreeting,
              style: textTheme.headlineMedium?.copyWith(
                color: AppColors.moonWhite,
                fontWeight: FontWeight.w500,
                fontSize: languageCode == 'ko' ? 34 : 30,
                height: 1.08,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              displayName,
              style: textTheme.displayMedium?.copyWith(
                color: AppColors.moonWhite,
                fontWeight: FontWeight.w500,
                fontSize: 40,
                height: 1.0,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: isSavingName ? null : onSubmitName,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.warmBeige,
                  foregroundColor: AppColors.deepNavy,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(999),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  l10n.enterYourRoomLabel,
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        );
      case _LaunchMode.home:
        return const SizedBox.shrink();
    }
  }
}
