import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import '../../../../data/mock/mock_quotes.dart';
import '../../../../data/mock/mock_sounds.dart';
import '../../../../data/models/quote_item.dart';
import '../../../../data/models/sound_item.dart';
import '../../../my/presentation/screens/my_screen.dart';
import '../../../quote/presentation/screens/quote_screen.dart';
import '../../../sounds/presentation/screens/sounds_screen.dart';
import '../../../sounds/services/sound_player_service.dart';
import '../widgets/app_bottom_navigation_bar.dart';

class HomeShellScreen extends StatefulWidget {
  const HomeShellScreen({super.key});

  @override
  State<HomeShellScreen> createState() => _HomeShellScreenState();
}

class _HomeShellScreenState extends State<HomeShellScreen> {
  final SoundPlayerService _soundPlayerService = SoundPlayerService();

  int _currentIndex = 0;
  late final Set<String> _favoriteSoundIds =
      mockSounds
          .where((SoundItem sound) => sound.isFavorite)
          .map((SoundItem sound) => sound.id)
          .toSet();
  late final Set<String> _savedQuoteIds =
      mockQuotes
          .where((QuoteItem quote) => quote.isSaved)
          .map((QuoteItem quote) => quote.id)
          .toSet();
  String _currentSoundId = mockSounds.first.id;
  int _quoteIndex = 0;
  double _playbackVolume = 0.76;
  PlayerState _playerState = PlayerState.stopped;
  StreamSubscription<PlayerState>? _playerStateSubscription;
  String? _loadedSoundId;

  bool get _isPlaying => _playerState == PlayerState.playing;

  @override
  void initState() {
    super.initState();
    _playerStateSubscription = _soundPlayerService.onPlayerStateChanged.listen((
      PlayerState state,
    ) {
      if (!mounted) {
        return;
      }
      setState(() {
        _playerState = state;
      });
    });
  }

  @override
  void dispose() {
    final StreamSubscription<PlayerState>? playerStateSubscription =
        _playerStateSubscription;
    if (playerStateSubscription != null) {
      unawaited(playerStateSubscription.cancel());
    }
    unawaited(_soundPlayerService.dispose());
    super.dispose();
  }

  List<SoundItem> get _sounds {
    return mockSounds
        .map(
          (SoundItem sound) =>
              sound.copyWith(isFavorite: _favoriteSoundIds.contains(sound.id)),
        )
        .toList(growable: false);
  }

  List<QuoteItem> get _quotes {
    return mockQuotes
        .map(
          (QuoteItem quote) =>
              quote.copyWith(isSaved: _savedQuoteIds.contains(quote.id)),
        )
        .toList(growable: false);
  }

  SoundItem get _currentSound => _sounds.firstWhere(
    (SoundItem sound) => sound.id == _currentSoundId,
    orElse: () => _sounds.first,
  );

  QuoteItem get _currentQuote => _quotes[_quoteIndex % _quotes.length];

  void _toggleFavorite(SoundItem sound) {
    setState(() {
      if (_favoriteSoundIds.contains(sound.id)) {
        _favoriteSoundIds.remove(sound.id);
      } else {
        _favoriteSoundIds.add(sound.id);
      }
    });
  }

  void _toggleSavedQuote() {
    setState(() {
      if (_savedQuoteIds.contains(_currentQuote.id)) {
        _savedQuoteIds.remove(_currentQuote.id);
      } else {
        _savedQuoteIds.add(_currentQuote.id);
      }
    });
  }

  void _showMessage(String message) {
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _selectSound(SoundItem sound) async {
    final bool shouldKeepPlaying = _isPlaying;

    setState(() {
      _currentSoundId = sound.id;
    });

    if (shouldKeepPlaying) {
      await _playSound(sound);
    }
  }

  void _showNextQuote() {
    setState(() {
      _quoteIndex = (_quoteIndex + 1) % _quotes.length;
    });
  }

  Future<void> _togglePlayback() async {
    if (_isPlaying) {
      await _soundPlayerService.pause();
      return;
    }

    if (_playerState == PlayerState.paused &&
        _loadedSoundId == _currentSoundId) {
      await _soundPlayerService.resume();
      return;
    }

    await _playSound(_currentSound);
  }

  Future<void> _playSound(SoundItem sound) async {
    try {
      await _soundPlayerService.playAsset(
        sound.audioPath,
        volume: _playbackVolume,
      );
      _loadedSoundId = sound.id;
    } catch (_) {
      _showMessage(
        'Audio preview failed to load. Check assets/sounds/sound1.mp3.',
      );
    }
  }

  Future<void> _updateVolume(double volume) async {
    setState(() {
      _playbackVolume = volume;
    });
    await _soundPlayerService.setVolume(volume);
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = <Widget>[
      SoundsScreen(
        sounds: _sounds,
        currentSound: _currentSound,
        isPlaying: _isPlaying,
        volume: _playbackVolume,
        onSelectSound: (SoundItem sound) {
          unawaited(_selectSound(sound));
        },
        onToggleFavorite: _toggleFavorite,
        onPlayPause: () {
          unawaited(_togglePlayback());
        },
        onVolumeChanged: (double volume) {
          unawaited(_updateVolume(volume));
        },
      ),
      QuoteScreen(
        quote: _currentQuote,
        savedCount: _savedQuoteIds.length,
        onToggleSaved: _toggleSavedQuote,
        onNextQuote: _showNextQuote,
      ),
      MyScreen(
        savedQuotes: _quotes.where((QuoteItem quote) => quote.isSaved).toList(),
        favoriteSounds:
            _sounds.where((SoundItem sound) => sound.isFavorite).toList(),
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: IndexedStack(index: _currentIndex, children: screens),
      bottomNavigationBar: SafeArea(
        top: false,
        child: AppBottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (int index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
      ),
    );
  }
}
