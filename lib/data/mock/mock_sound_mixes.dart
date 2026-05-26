import '../models/sound_mix.dart';

final List<SoundMix> mockSoundMixes = <SoundMix>[
  SoundMix(
    id: 'mix_1',
    title: 'Moon Library',
    layers: <String>['Rain', 'Piano', 'Fire'],
    createdAt: DateTime(2026, 5, 19),
    isPremium: true,
  ),
  SoundMix(
    id: 'mix_2',
    title: 'Night Train Focus',
    layers: <String>['Train', 'Wind', 'Cafe'],
    createdAt: DateTime(2026, 5, 18),
    isPremium: true,
  ),
];
