import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_gradients.dart';
import '../../../../core/widgets/ambient_background.dart';
import '../../../../core/widgets/fade_slide_in.dart';
import '../../../../core/widgets/section_header.dart';
import '../../../../data/mock/mock_sound_mixes.dart';
import '../../../../data/models/sound_item.dart';
import '../../../premium/presentation/widgets/premium_gate.dart';
import '../widgets/mix_studio_card.dart';
import '../widgets/player_hero_card.dart';
import '../widgets/sound_library_tile.dart';

class SoundsScreen extends StatefulWidget {
  const SoundsScreen({
    required this.sounds,
    required this.currentSound,
    required this.isPremium,
    required this.onSelectSound,
    required this.onToggleFavorite,
    required this.onPlayNext,
    required this.onPlayPrevious,
    required this.onOpenPremium,
    super.key,
  });

  final List<SoundItem> sounds;
  final SoundItem currentSound;
  final bool isPremium;
  final ValueChanged<SoundItem> onSelectSound;
  final ValueChanged<SoundItem> onToggleFavorite;
  final VoidCallback onPlayNext;
  final VoidCallback onPlayPrevious;
  final VoidCallback onOpenPremium;

  @override
  State<SoundsScreen> createState() => _SoundsScreenState();
}

class _SoundsScreenState extends State<SoundsScreen> {
  static const List<String> _categories = <String>[
    'All',
    'Nature',
    'ASMR',
    'City',
    'Cafe',
    'Sleep',
    'Focus',
  ];

  String _selectedCategory = 'All';
  double _volume = 0.76;
  bool _isPlayingPreview = true;

  List<SoundItem> get _filteredSounds {
    if (_selectedCategory == 'All') {
      return widget.sounds;
    }

    return widget.sounds
        .where((SoundItem sound) => sound.category == _selectedCategory)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final List<SoundItem> filteredSounds = _filteredSounds;

    return AmbientBackground(
      gradient: AppGradients.screenBackground(0),
      primaryOrbColors: const <Color>[Color(0x55F4EDE3), Color(0x003A335C)],
      secondaryOrbColors: const <Color>[Color(0x33B98299), Color(0x0011182E)],
      child: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 140),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              FadeSlideIn(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Soundscape Days',
                      style: textTheme.bodySmall?.copyWith(letterSpacing: 1.6),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'A dreamy room for calm listening.',
                      style: textTheme.displayMedium,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Mock gradients stand in for missing artwork, but the player flow and premium structure are ready.',
                      style: textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 26),
              FadeSlideIn(
                delay: const Duration(milliseconds: 120),
                child: PlayerHeroCard(
                  sound: widget.currentSound,
                  isPlaying: _isPlayingPreview,
                  volume: _volume,
                  onPlayPause: () {
                    setState(() {
                      _isPlayingPreview = !_isPlayingPreview;
                    });
                  },
                  onPrevious: widget.onPlayPrevious,
                  onNext: widget.onPlayNext,
                  onToggleFavorite:
                      () => widget.onToggleFavorite(widget.currentSound),
                  onVolumeChanged: (double value) {
                    setState(() {
                      _volume = value;
                    });
                  },
                ),
              ),
              const SizedBox(height: 26),
              FadeSlideIn(
                delay: const Duration(milliseconds: 180),
                child: const SectionHeader(
                  title: 'Sound Library',
                  actionLabel: '10 rooms',
                ),
              ),
              const SizedBox(height: 14),
              FadeSlideIn(
                delay: const Duration(milliseconds: 220),
                child: SizedBox(
                  height: 42,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _categories.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 10),
                    itemBuilder: (BuildContext context, int index) {
                      final String category = _categories[index];
                      final bool isSelected = category == _selectedCategory;

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedCategory = category;
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 220),
                          curve: Curves.easeOutCubic,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(999),
                            color:
                                isSelected
                                    ? AppColors.moonWhite.withValues(
                                      alpha: 0.14,
                                    )
                                    : Colors.white.withValues(alpha: 0.05),
                            border: Border.all(
                              color:
                                  isSelected
                                      ? AppColors.moonWhite.withValues(
                                        alpha: 0.24,
                                      )
                                      : Colors.white.withValues(alpha: 0.08),
                            ),
                          ),
                          child: Text(
                            category,
                            style: textTheme.bodySmall?.copyWith(
                              color:
                                  isSelected
                                      ? AppColors.moonWhite
                                      : Colors.white.withValues(alpha: 0.7),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),
              FadeSlideIn(
                delay: const Duration(milliseconds: 280),
                child: Column(
                  children:
                      filteredSounds.map((SoundItem sound) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: SoundLibraryTile(
                            sound: sound,
                            isSelected: sound.id == widget.currentSound.id,
                            onTap: () => widget.onSelectSound(sound),
                            onToggleFavorite:
                                () => widget.onToggleFavorite(sound),
                            onPremiumTap: widget.onOpenPremium,
                          ),
                        );
                      }).toList(),
                ),
              ),
              const SizedBox(height: 14),
              FadeSlideIn(
                delay: const Duration(milliseconds: 340),
                child: const SectionHeader(
                  title: 'Mix Studio',
                  actionLabel: 'Premium-ready',
                ),
              ),
              const SizedBox(height: 14),
              FadeSlideIn(
                delay: const Duration(milliseconds: 380),
                child: PremiumGate(
                  isPremium: widget.isPremium,
                  onUnlock: widget.onOpenPremium,
                  title: 'Custom layered rooms',
                  subtitle:
                      'Rain, piano, fire, and city layers are prepared for premium mixing.',
                  child: MixStudioCard(
                    mix: mockSoundMixes.first,
                    isPremium: widget.isPremium,
                    onTap: widget.onOpenPremium,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
