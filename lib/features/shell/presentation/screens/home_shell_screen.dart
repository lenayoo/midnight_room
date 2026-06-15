import 'dart:async';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import '../../../../data/mock/mock_sounds.dart';
import '../../../../data/models/quote_item.dart';
import '../../../../data/models/sound_item.dart';
import '../../../my/presentation/screens/my_screen.dart';
import '../../../quote/presentation/screens/quote_screen.dart';
import '../../../quote/services/quote_asset_service.dart';
import '../../../sounds/presentation/screens/sound_room_screen.dart';
import '../../../sounds/presentation/screens/sounds_screen.dart';
import '../../../sounds/services/sound_player_service.dart';
import '../widgets/app_bottom_navigation_bar.dart';

class HomeShellScreen extends StatefulWidget {
  const HomeShellScreen({super.key});

  @override
  State<HomeShellScreen> createState() => _HomeShellScreenState();
}

class _HomeShellScreenState extends State<HomeShellScreen> {
  static const String _yogaSoundId = 'yoga';
  static const List<String> _quoteCategories = <String>[
    'calm',
    'hope',
    'reflection',
  ];

  final SoundPlayerService _soundPlayerService = SoundPlayerService();
  final QuoteAssetService _quoteAssetService = const QuoteAssetService();
  final Random _random = Random();

  int _currentIndex = 0;
  late final Set<String> _favoriteSoundIds =
      mockSounds
          .where((SoundItem sound) => sound.isFavorite)
          .map((SoundItem sound) => sound.id)
          .toSet();
  final Set<String> _savedQuoteIds = <String>{};
  List<QuoteItem> _baseQuotes = <QuoteItem>[];
  String _currentSoundId = mockSounds.first.id;
  String _selectedQuoteCategory = _quoteCategories.first;
  int? _quoteIndex;
  double _playbackVolume = 0.76;
  PlayerState _playerState = PlayerState.stopped;
  StreamSubscription<PlayerState>? _playerStateSubscription;
  String? _loadedSoundId;
  bool _isLoadingQuotes = true;

  bool get _isPlaying => _playerState == PlayerState.playing;

  @override
  void initState() {
    super.initState();
    unawaited(_loadQuotes());
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
    return _baseQuotes
        .map(
          (QuoteItem quote) =>
              quote.copyWith(isSaved: _savedQuoteIds.contains(quote.id)),
        )
        .toList(growable: false);
  }

  List<QuoteItem> get _filteredQuotes {
    return _quotes
        .where((QuoteItem quote) => quote.category == _selectedQuoteCategory)
        .toList(growable: false);
  }

  SoundItem get _currentSound => _sounds.firstWhere(
    (SoundItem sound) => sound.id == _currentSoundId,
    orElse: () => _sounds.first,
  );

  SoundItem? get _yogaSound {
    for (final SoundItem sound in _sounds) {
      if (sound.id == _yogaSoundId) {
        return sound;
      }
    }
    return null;
  }

  QuoteItem? get _currentQuote {
    if (_filteredQuotes.isEmpty || _quoteIndex == null) {
      return null;
    }

    if (_quoteIndex! < 0 || _quoteIndex! >= _filteredQuotes.length) {
      return null;
    }

    return _filteredQuotes[_quoteIndex!];
  }

  Future<void> _loadQuotes() async {
    try {
      final List<QuoteItem> loadedQuotes =
          await _quoteAssetService.loadQuotes();
      final String initialCategory = _resolveInitialQuoteCategory(loadedQuotes);
      final List<QuoteItem> initialQuotes = loadedQuotes
          .where((QuoteItem quote) => quote.category == initialCategory)
          .toList(growable: false);
      final int? randomIndex = _pickRandomIndex(
        length: initialQuotes.length,
        currentIndex: null,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _baseQuotes = loadedQuotes;
        _selectedQuoteCategory = initialCategory;
        _quoteIndex = randomIndex;
        _isLoadingQuotes = false;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }

      setState(() {
        _baseQuotes = <QuoteItem>[];
        _quoteIndex = null;
        _isLoadingQuotes = false;
      });
    }
  }

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
    final QuoteItem? currentQuote = _currentQuote;
    if (currentQuote == null) {
      return;
    }

    setState(() {
      if (_savedQuoteIds.contains(currentQuote.id)) {
        _savedQuoteIds.remove(currentQuote.id);
      } else {
        _savedQuoteIds.add(currentQuote.id);
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

  Future<void> _openSoundRoom(
    SoundItem sound, {
    bool autoStartPlayback = false,
  }) async {
    if (_currentSoundId != sound.id) {
      setState(() {
        _currentSoundId = sound.id;
      });
    }

    if (_playerState != PlayerState.stopped) {
      await _soundPlayerService.pause();
    }

    if (!mounted) {
      return;
    }

    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder:
            (BuildContext context) => SoundRoomScreen(
              sound: _currentSound,
              initialVolume: _playbackVolume,
              autoStartPlayback: autoStartPlayback,
            ),
      ),
    );
  }

  void _showNextQuote() {
    final int? nextIndex = _pickRandomIndex(
      length: _filteredQuotes.length,
      currentIndex: _quoteIndex,
    );

    if (nextIndex == null) {
      return;
    }

    setState(() {
      _quoteIndex = nextIndex;
    });
  }

  void _selectQuoteCategory(String category) {
    if (category == _selectedQuoteCategory) {
      return;
    }

    final List<QuoteItem> nextQuotes = _quotes
        .where((QuoteItem quote) => quote.category == category)
        .toList(growable: false);
    final int? nextIndex = _pickRandomIndex(
      length: nextQuotes.length,
      currentIndex: null,
    );

    setState(() {
      _selectedQuoteCategory = category;
      _quoteIndex = nextIndex;
    });
  }

  String _resolveInitialQuoteCategory(List<QuoteItem> quotes) {
    for (final String category in _quoteCategories) {
      if (quotes.any((QuoteItem quote) => quote.category == category)) {
        return category;
      }
    }

    return quotes.isEmpty ? _quoteCategories.first : quotes.first.category;
  }

  int? _pickRandomIndex({required int length, required int? currentIndex}) {
    if (length == 0) {
      return null;
    }

    if (length == 1) {
      return 0;
    }

    int nextIndex = _random.nextInt(length);
    while (nextIndex == currentIndex) {
      nextIndex = _random.nextInt(length);
    }
    return nextIndex;
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
      _showMessage('Audio preview failed to load. Check ${sound.audioPath}.');
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
        yogaSound: _yogaSound,
        currentSound: _currentSound,
        isPlaying: _isPlaying,
        volume: _playbackVolume,
        onSelectSound: (SoundItem sound) {
          unawaited(_selectSound(sound));
        },
        onOpenSoundRoom: (SoundItem sound) {
          unawaited(
            _openSoundRoom(sound, autoStartPlayback: sound.id == _yogaSoundId),
          );
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
        isLoading: _isLoadingQuotes,
        categories: _quoteCategories,
        selectedCategory: _selectedQuoteCategory,
        savedCount: _savedQuoteIds.length,
        onSelectCategory: _selectQuoteCategory,
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
