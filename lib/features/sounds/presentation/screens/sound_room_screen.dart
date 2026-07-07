import 'dart:async';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/widgets/ambient_background.dart';
import '../../../../data/models/sound_item.dart';
import '../../../ads/models/admob_ids.dart';
import '../../../ads/widgets/top_banner_ad.dart';
import '../../services/sound_player_service.dart';

class SoundRoomScreen extends StatefulWidget {
  const SoundRoomScreen({
    required this.sound,
    required this.initialVolume,
    this.autoStartPlayback = false,
    super.key,
  });

  final SoundItem sound;
  final double initialVolume;
  final bool autoStartPlayback;

  @override
  State<SoundRoomScreen> createState() => _SoundRoomScreenState();
}

class _SoundRoomScreenState extends State<SoundRoomScreen>
    with WidgetsBindingObserver {
  final SoundPlayerService _soundPlayerService = SoundPlayerService();

  VideoPlayerController? _videoController;
  Future<void>? _initializeVideoFuture;
  bool _isPlaying = false;
  bool _hasStartedPlayback = false;
  bool _isPreparingMedia = false;
  String? _playbackErrorMessage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    if (widget.sound.videoPath != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) {
          return;
        }
        Future<void>.delayed(const Duration(milliseconds: 180), () {
          if (!mounted) {
            return;
          }
          unawaited(_ensureVideoReady(silent: true));
        });
      });
    }
    if (widget.autoStartPlayback) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) {
          return;
        }
        unawaited(_startPlayback());
      });
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      unawaited(_pauseMediaForLifecycle());
    }
  }

  Future<void> _pauseMediaForLifecycle() async {
    await _videoController?.pause();
    await _soundPlayerService.pause();

    if (!mounted || !_isPlaying) {
      return;
    }

    setState(() {
      _isPlaying = false;
    });
  }

  Future<void> _ensureVideoReady({bool silent = false}) async {
    final String? videoPath = widget.sound.videoPath;
    if (videoPath == null) {
      return;
    }

    final Future<void>? existingFuture = _initializeVideoFuture;
    if (existingFuture != null) {
      if (silent) {
        try {
          await existingFuture;
        } catch (_) {}
        return;
      }

      await existingFuture;
      return;
    }

    final VideoPlayerController controller = VideoPlayerController.asset(
      videoPath,
    );
    _videoController = controller;

    final Future<void> initializeFuture = _initializeVideo(controller);
    _initializeVideoFuture = initializeFuture;

    if (mounted) {
      setState(() {});
    }

    try {
      await initializeFuture;
    } catch (error) {
      if (identical(_videoController, controller)) {
        _videoController = null;
        _initializeVideoFuture = null;
      }
      await controller.dispose();
      if (!silent) {
        rethrow;
      }
    }
  }

  Future<void> _initializeVideo(VideoPlayerController controller) async {
    await controller.initialize();
    await controller.setLooping(true);
  }

  Future<void> _startPlayback() async {
    if (_isPreparingMedia) {
      return;
    }

    setState(() {
      _isPreparingMedia = true;
      _playbackErrorMessage = null;
    });

    try {
      await _ensureVideoReady();
      await _videoController?.play();
      await _soundPlayerService.stop();
      await _soundPlayerService.playAsset(
        widget.sound.audioPath,
        volume: widget.initialVolume,
      );

      if (!mounted) {
        return;
      }
      setState(() {
        _hasStartedPlayback = true;
        _isPlaying = true;
        _isPreparingMedia = false;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }

      final AppLocalizations l10n = context.l10n;
      final String message = l10n.unableToPlay(
        l10n.soundTitle(widget.sound.id, fallback: widget.sound.title),
      );
      setState(() {
        _isPreparingMedia = false;
        _isPlaying = false;
        _playbackErrorMessage = message;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  Future<void> _togglePlayback() async {
    if (_isPreparingMedia) {
      return;
    }

    if (_isPlaying) {
      await _videoController?.pause();
      await _soundPlayerService.pause();

      if (!mounted) {
        return;
      }
      setState(() {
        _isPlaying = false;
      });
      return;
    }

    if (_hasStartedPlayback) {
      await _ensureVideoReady(silent: true);
      await _videoController?.play();
      await _soundPlayerService.resume();

      if (!mounted) {
        return;
      }
      setState(() {
        _isPlaying = true;
      });
      return;
    }

    await _startPlayback();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    final VideoPlayerController? videoController = _videoController;
    unawaited(_soundPlayerService.stop());
    unawaited(_soundPlayerService.dispose());
    if (videoController != null) {
      unawaited(videoController.dispose());
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = context.l10n;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          _videoBackground(),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[
                  Color(0x55000000),
                  Color(0x22000000),
                  Color(0x99000000),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  if (_isPlaying && AdMobIds.shouldLoadAds) const TopBannerAd(),
                  if (_isPlaying && AdMobIds.shouldLoadAds)
                    const SizedBox(height: 8),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.22),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.14),
                      ),
                    ),
                    child: IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.arrow_back_ios_new_rounded),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    l10n.soundTitle(
                      widget.sound.id,
                      fallback: widget.sound.title,
                    ),
                    style: textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.moodTagLabels(widget.sound.moodTags).join(' · '),
                    style: textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 20),
                  if (_playbackErrorMessage != null) ...<Widget>[
                    Text(
                      _playbackErrorMessage!,
                      style: textTheme.bodySmall?.copyWith(
                        color: const Color(0xFFF0B8B8),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                  Align(
                    alignment: Alignment.center,
                    child: _RoundControlButton(
                      icon:
                          _isPreparingMedia
                              ? Icons.hourglass_top_rounded
                              : _isPlaying
                              ? Icons.pause_rounded
                              : Icons.play_arrow_rounded,
                      label:
                          _isPreparingMedia
                              ? l10n.loadingLabel
                              : _isPlaying
                              ? l10n.pauseLabel
                              : l10n.playLabel,
                      isPrimary: true,
                      onPressed: _isPreparingMedia ? null : _togglePlayback,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _videoBackground() {
    final VideoPlayerController? videoController = _videoController;
    final Future<void>? initializeVideoFuture = _initializeVideoFuture;

    if (videoController == null || initializeVideoFuture == null) {
      return const AmbientBackground(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            Color(0xFF0B1020),
            Color(0xFF1B2440),
            Color(0xFF3A335C),
          ],
        ),
        child: SizedBox.expand(),
      );
    }

    return FutureBuilder<void>(
      future: initializeVideoFuture,
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const ColoredBox(color: Color(0xFF0B1020));
        }

        return FittedBox(
          fit: BoxFit.cover,
          child: SizedBox(
            width: videoController.value.size.width,
            height: videoController.value.size.height,
            child: VideoPlayer(videoController),
          ),
        );
      },
    );
  }
}

class _RoundControlButton extends StatelessWidget {
  const _RoundControlButton({
    required this.icon,
    required this.label,
    required this.onPressed,
    this.isPrimary = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onPressed;
  final bool isPrimary;

  @override
  Widget build(BuildContext context) {
    final bool isEnabled = onPressed != null;

    return Semantics(
      button: true,
      label: label,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 180),
        opacity: isEnabled ? 1 : 0.45,
        child: DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color:
                isPrimary
                    ? const Color(0x80D9B99B)
                    : Colors.black.withValues(alpha: 0.22),
            border: Border.all(
              color:
                  isPrimary
                      ? Colors.white.withValues(alpha: 0.18)
                      : Colors.white.withValues(alpha: 0.12),
            ),
            boxShadow:
                isPrimary
                    ? <BoxShadow>[
                      BoxShadow(
                        color: const Color(0x55D9B99B),
                        blurRadius: 28,
                        spreadRadius: 2,
                      ),
                    ]
                    : const <BoxShadow>[],
          ),
          child: IconButton(
            onPressed: onPressed,
            iconSize: isPrimary ? 48 : 28,
            padding: EdgeInsets.all(isPrimary ? 24 : 18),
            icon: Icon(icon),
          ),
        ),
      ),
    );
  }
}
