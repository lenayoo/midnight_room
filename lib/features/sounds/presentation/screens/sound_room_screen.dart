import 'dart:async';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../../../core/widgets/ambient_background.dart';
import '../../../../core/widgets/glass_panel.dart';
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
      _isPlaying = true;
    });
  }

  Future<void> _stopPlayback() async {
    final VideoPlayerController? videoController = _videoController;
    await videoController?.pause();
    await videoController?.seekTo(Duration.zero);
    await _soundPlayerService.stop();

    if (!mounted) {
      return;
    }
    setState(() {
      _isPlaying = false;
    });
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
                return _RoomBackdrop(controller: controller);
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
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
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
                      const SizedBox(height: 20),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            if (_videoController != null)
                              _RoomVideoStage(
                                controller: _videoController,
                                constraints: constraints,
                                sound: widget.sound,
                              ),
                            const SizedBox(height: 24),
                            GlassPanel(
                              gradientColors: _panelGradientColors(
                                widget.sound,
                              ),
                              borderColor: _panelBorderColor(widget.sound),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    widget.sound.title,
                                    style: textTheme.headlineMedium,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    _roomDescription(widget.sound),
                                    style: textTheme.bodyMedium,
                                  ),
                                  const SizedBox(height: 14),
                                  Text(
                                    '${widget.sound.category} · ${widget.sound.duration}',
                                    style: textTheme.bodySmall,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    widget.sound.moodTags.join(' · '),
                                    style: textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(28),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.12),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 12,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                FilledButton(
                                  onPressed: _isPlaying ? null : _startPlayback,
                                  style: FilledButton.styleFrom(
                                    minimumSize: const Size(110, 48),
                                  ),
                                  child: const Text('Start'),
                                ),
                                const SizedBox(width: 12),
                                OutlinedButton(
                                  onPressed: _isPlaying ? _stopPlayback : null,
                                  style: OutlinedButton.styleFrom(
                                    minimumSize: const Size(110, 48),
                                    side: BorderSide(
                                      color: Colors.white.withValues(
                                        alpha: 0.22,
                                      ),
                                    ),
                                  ),
                                  child: const Text('Stop'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _RoomBackdrop extends StatelessWidget {
  const _RoomBackdrop({required this.controller});

  final VideoPlayerController controller;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.48,
      child: FittedBox(
        fit: BoxFit.cover,
        child: SizedBox(
          width: controller.value.size.width,
          height: controller.value.size.height,
          child: VideoPlayer(controller),
        ),
      ),
    );
  }
}

class _RoomVideoStage extends StatelessWidget {
  const _RoomVideoStage({
    required this.controller,
    required this.constraints,
    required this.sound,
  });

  final VideoPlayerController controller;
  final BoxConstraints constraints;
  final SoundItem sound;

  @override
  Widget build(BuildContext context) {
    final double aspectRatio =
        controller.value.aspectRatio <= 0
            ? 9 / 16
            : controller.value.aspectRatio;
    final double maxWidth = constraints.maxWidth * 0.72;
    final double maxHeight = constraints.maxHeight * 0.44;

    double width = maxWidth;
    double height = width / aspectRatio;
    if (height > maxHeight) {
      height = maxHeight;
      width = height * aspectRatio;
    }

    return Center(
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(34),
          border: Border.all(color: Colors.white.withValues(alpha: 0.16)),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.28),
              blurRadius: 34,
              offset: const Offset(0, 18),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(34),
          child: SizedBox(
            width: width,
            height: height,
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                ColoredBox(
                  color: Colors.black.withValues(alpha: 0.18),
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: SizedBox(
                      width: controller.value.size.width,
                      height: controller.value.size.height,
                      child: VideoPlayer(controller),
                    ),
                  ),
                ),
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: _stageOverlayColors(sound),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

String _roomDescription(SoundItem sound) {
  switch (sound.id) {
    case 'in_the_universe':
      return 'A slower cosmic wash for drifting sleep and quiet breath.';
    case 'deep_sleep':
      return 'Soft midnight warmth for deeper rest and an unhurried mind.';
    case 'yoga':
      return 'Gentle motion and open air for stretching into calm focus.';
    default:
      return 'A quiet room shaped around the sound you are hearing now.';
  }
}

List<Color> _panelGradientColors(SoundItem sound) {
  switch (sound.id) {
    case 'in_the_universe':
      return const <Color>[Color(0x3A7F90FF), Color(0x228C98C8)];
    case 'deep_sleep':
      return const <Color>[Color(0x33D9B99B), Color(0x1A8B6F77)];
    case 'yoga':
      return const <Color>[Color(0x33B98299), Color(0x1AF4EDE3)];
    default:
      return const <Color>[Color(0x2EFFFFFF), Color(0x18FFFFFF)];
  }
}

Color _panelBorderColor(SoundItem sound) {
  switch (sound.id) {
    case 'in_the_universe':
      return const Color(0x4C9AA9FF);
    case 'deep_sleep':
      return const Color(0x44D9B99B);
    case 'yoga':
      return const Color(0x44F4EDE3);
    default:
      return const Color(0x2EFFFFFF);
  }
}

List<Color> _stageOverlayColors(SoundItem sound) {
  switch (sound.id) {
    case 'in_the_universe':
      return const <Color>[
        Color(0x0D0B1020),
        Color(0x0A11182E),
        Color(0x660B1020),
      ];
    case 'deep_sleep':
      return const <Color>[
        Color(0x1411182E),
        Color(0x0A3A335C),
        Color(0x6611182E),
      ];
    case 'yoga':
      return const <Color>[
        Color(0x0D11182E),
        Color(0x0AB98299),
        Color(0x6611182E),
      ];
    default:
      return const <Color>[
        Color(0x120B1020),
        Color(0x0A11182E),
        Color(0x660B1020),
      ];
  }
}
