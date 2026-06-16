import 'dart:async';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../../../core/widgets/ambient_background.dart';
import '../../../../data/models/sound_item.dart';
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

class _SoundRoomScreenState extends State<SoundRoomScreen> {
  late final VideoPlayerController? _videoController =
      widget.sound.videoPath == null
          ? null
          : VideoPlayerController.asset(widget.sound.videoPath!);
  final SoundPlayerService _soundPlayerService = SoundPlayerService();
  Future<void>? _initializeVideoFuture;
  bool _isPlaying = false;
  bool _hasStartedPlayback = false;

  @override
  void initState() {
    super.initState();
    final VideoPlayerController? videoController = _videoController;
    if (videoController != null) {
      _initializeVideoFuture = _initializeVideo(videoController);
    }
    if (widget.autoStartPlayback) {
      unawaited(_startPlayback());
    }
  }

  Future<void> _initializeVideo(VideoPlayerController controller) async {
    await controller.initialize();
    await controller.setLooping(true);
  }

  Future<void> _startPlayback() async {
    final VideoPlayerController? videoController = _videoController;
    final Future<void>? initializeVideoFuture = _initializeVideoFuture;
    if (initializeVideoFuture != null) {
      await initializeVideoFuture;
    }

    await videoController?.play();
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
    });
  }

  Future<void> _togglePlayback() async {
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
    unawaited(_soundPlayerService.dispose());
    final VideoPlayerController? videoController = _videoController;
    if (videoController != null) {
      unawaited(videoController.dispose());
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          if (_videoController != null)
            FutureBuilder<void>(
              future: _initializeVideoFuture,
              builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const ColoredBox(color: Color(0xFF0B1020));
                }

                final VideoPlayerController controller = _videoController;
                return FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: controller.value.size.width,
                    height: controller.value.size.height,
                    child: VideoPlayer(controller),
                  ),
                );
              },
            )
          else
            const AmbientBackground(
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
            ),
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
                  Text(widget.sound.title, style: textTheme.headlineMedium),
                  const SizedBox(height: 8),
                  Text(
                    widget.sound.moodTags.join(' · '),
                    style: textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.center,
                    child: _RoundControlButton(
                      icon:
                          _isPlaying
                              ? Icons.pause_rounded
                              : Icons.play_arrow_rounded,
                      label: _isPlaying ? 'Pause' : 'Play',
                      isPrimary: true,
                      onPressed: _togglePlayback,
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
                      ? const Color(0x99F4EDE3)
                      : Colors.white.withValues(alpha: 0.18),
            ),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.22),
                blurRadius: 24,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: IconButton(
            onPressed: onPressed,
            icon: Icon(icon, size: 32),
            padding: const EdgeInsets.all(18),
            splashRadius: 30,
          ),
        ),
      ),
    );
  }
}
