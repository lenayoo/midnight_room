import 'package:flutter/material.dart';

import '../../../../data/mock/mock_quotes.dart';
import '../../../../data/mock/mock_sounds.dart';
import '../../../../data/mock/mock_timer_history.dart';
import '../../../../data/models/quote_item.dart';
import '../../../../data/models/sound_item.dart';
import '../../../my/presentation/screens/my_screen.dart';
import '../../../notification/services/notification_service.dart';
import '../../../premium/presentation/screens/premium_paywall_screen.dart';
import '../../../premium/services/premium_service.dart';
import '../../../quote/presentation/screens/quote_screen.dart';
import '../../../sounds/presentation/screens/sounds_screen.dart';
import '../../../timer/presentation/screens/timer_screen.dart';
import '../widgets/app_bottom_navigation_bar.dart';

class HomeShellScreen extends StatefulWidget {
  const HomeShellScreen({super.key});

  @override
  State<HomeShellScreen> createState() => _HomeShellScreenState();
}

class _HomeShellScreenState extends State<HomeShellScreen> {
  final PremiumService _premiumService = PremiumService();
  final NotificationService _notificationService = NotificationService();

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

  @override
  void initState() {
    super.initState();
    _premiumService.initialize();
    _notificationService.initialize();
  }

  @override
  void dispose() {
    _premiumService.dispose();
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

  void _selectSound(SoundItem sound) {
    if (sound.isPremium && !_premiumService.isPremium) {
      _openPremiumPaywall();
      return;
    }

    setState(() {
      _currentSoundId = sound.id;
    });
  }

  void _cycleSound(int direction) {
    final List<SoundItem> sounds = _sounds;
    final int currentIndex = sounds.indexWhere(
      (SoundItem sound) => sound.id == _currentSoundId,
    );

    for (int step = 1; step <= sounds.length; step++) {
      final int nextIndex =
          (currentIndex + (direction * step) + sounds.length) % sounds.length;
      final SoundItem candidate = sounds[nextIndex];
      if (!candidate.isPremium || _premiumService.isPremium) {
        setState(() {
          _currentSoundId = candidate.id;
        });
        return;
      }
    }

    _openPremiumPaywall();
  }

  void _refreshQuote() {
    setState(() {
      _quoteIndex = (_quoteIndex + 1) % _quotes.length;
    });
  }

  void _showPrototypeMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _openPremiumPaywall() async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return PremiumPaywallScreen(
          subscriptionState: _premiumService.value,
          onStartTrial: () async {
            await _premiumService.startFreeTrial();
            if (!context.mounted) {
              return;
            }
            Navigator.of(context).pop();
            setState(() {});
            _showPrototypeMessage(
              'Premium preview enabled. Billing hooks can replace this stub later.',
            );
          },
          onRestorePurchases: () {
            Navigator.of(context).pop();
            _showPrototypeMessage(
              'Restore flow is scaffolded for real purchase integration.',
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = <Widget>[
      SoundsScreen(
        sounds: _sounds,
        currentSound: _currentSound,
        isPremium: _premiumService.isPremium,
        onSelectSound: _selectSound,
        onToggleFavorite: _toggleFavorite,
        onPlayNext: () => _cycleSound(1),
        onPlayPrevious: () => _cycleSound(-1),
        onOpenPremium: _openPremiumPaywall,
      ),
      TimerScreen(
        currentSound: _currentSound,
        isPremium: _premiumService.isPremium,
        onOpenPremium: _openPremiumPaywall,
      ),
      QuoteScreen(
        quote: _currentQuote,
        savedCount: _savedQuoteIds.length,
        onToggleSaved: _toggleSavedQuote,
        onRefresh: _refreshQuote,
        onShare:
            () => _showPrototypeMessage(
              'Share action is ready for the platform share sheet.',
            ),
      ),
      MyScreen(
        subscriptionState: _premiumService.value,
        savedQuotes: _quotes.where((QuoteItem quote) => quote.isSaved).toList(),
        favoriteSounds:
            _sounds.where((SoundItem sound) => sound.isFavorite).toList(),
        timerHistory: mockTimerHistory,
        onOpenPremium: _openPremiumPaywall,
        onOpenNotificationPreview:
            () => _showPrototypeMessage(
              'Notification service and scheduler are scaffolded for later implementation.',
            ),
        onOpenThemePreview:
            () => _showPrototypeMessage(
              'Theme switching is ready for premium extensions later.',
            ),
      ),
    ];

    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.transparent,
      body: Stack(
        children: <Widget>[
          Positioned.fill(
            child: IndexedStack(index: _currentIndex, children: screens),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SafeArea(
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
          ),
        ],
      ),
    );
  }
}
