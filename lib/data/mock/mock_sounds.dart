import '../models/sound_item.dart';

const String _previewAudioAssetPath = 'assets/sounds/sound1.mp3';
const String _universeAudioAssetPath = 'assets/sounds/universe_sound.mp3';
const String _underThePalmTreeAudioAssetPath =
    'assets/sounds/underthepalmtree_sound.mp3';
const String _yogaAudioAssetPath = 'assets/sounds/yoga_sound.mp3';

const String _crispMorningVideoAssetPath = 'assets/images/crisp_morning.mp4';
const String _stormyNightVideoAssetPath = 'assets/images/stormy_night.mp4';
const String _summerNightVideoAssetPath = 'assets/images/summer_night.mp4';
const String _sunsetBeachVideoAssetPath = 'assets/images/sunset_beach.mp4';
const String _underTheStarVideoAssetPath = 'assets/images/under_the_star.mp4';
const String _weekendRainyDayVideoAssetPath =
    'assets/images/weekend_rainny_day.mp4';

const String _crispMorningAudioAssetPath = 'assets/sounds/crisp_morning.mp3';
const String _stormyNightAudioAssetPath = 'assets/sounds/stormy_night.mp3';
const String _summerNightAudioAssetPath = 'assets/sounds/summer_night.mp3';
const String _sunsetBeachAudioAssetPath = 'assets/sounds/sunset_beach.mp3';
const String _underTheStarAudioAssetPath = 'assets/sounds/under_the_star.mp3';
const String _weekendRainyDayAudioAssetPath =
    'assets/sounds/weekend_rainny_day.mp3';

const List<SoundItem> mockSounds = <SoundItem>[
  SoundItem(
    id: 'afternoon_rain',
    title: 'Afternoon Rain',
    category: 'Nature',
    duration: '45 min',
    imagePath: 'assets/images/afternoon_rain.png',
    audioPath: _previewAudioAssetPath,
    isPremium: false,
    isFavorite: true,
    videoPath: 'assets/images/afternoon_rain.mp4',
    moodTags: <String>['Rain', 'Afternoon', 'Relax'],
  ),
  SoundItem(
    id: 'in_the_universe',
    title: 'In the Universe',
    category: 'Sleep',
    duration: '52 min',
    imagePath: 'assets/images/universe_bg.mp4',
    audioPath: _universeAudioAssetPath,
    isPremium: false,
    isFavorite: false,
    videoPath: 'assets/images/universe_bg.mp4',
    moodTags: <String>['Night Sky', 'Drift', 'Stillness'],
  ),
  SoundItem(
    id: 'deep_sleep',
    title: 'Deep Sleep',
    category: 'Sleep',
    duration: '64 min',
    imagePath: 'assets/images/underthepalmtree_bg.mp4',
    audioPath: _underThePalmTreeAudioAssetPath,
    isPremium: false,
    isFavorite: false,
    videoPath: 'assets/images/underthepalmtree_bg.mp4',
    moodTags: <String>['Palm', 'Moon', 'Dream'],
  ),
  SoundItem(
    id: 'yoga',
    title: 'Yoga',
    category: 'Yoga',
    duration: '24 min',
    imagePath: 'assets/images/yoga_bg.mp4',
    audioPath: _yogaAudioAssetPath,
    isPremium: false,
    isFavorite: false,
    videoPath: 'assets/images/yoga_bg.mp4',
    moodTags: <String>['Stretch', 'Breathe', 'Align'],
  ),
  SoundItem(
    id: 'crisp_morning',
    title: 'Crisp Morning',
    category: 'Focus',
    duration: '34 min',
    imagePath: _crispMorningVideoAssetPath,
    audioPath: _crispMorningAudioAssetPath,
    isPremium: false,
    isFavorite: true,
    videoPath: _crispMorningVideoAssetPath,
    moodTags: <String>['Morning', 'Breeze', 'Reset'],
  ),
  SoundItem(
    id: 'stormy_night',
    title: 'Stormy Night',
    category: 'Sleep',
    duration: '48 min',
    imagePath: _stormyNightVideoAssetPath,
    audioPath: _stormyNightAudioAssetPath,
    isPremium: false,
    isFavorite: true,
    videoPath: _stormyNightVideoAssetPath,
    moodTags: <String>['Thunder', 'Rain', 'Night'],
  ),
  SoundItem(
    id: 'summer_night',
    title: 'Summer Night',
    category: 'Sleep',
    duration: '41 min',
    imagePath: _summerNightVideoAssetPath,
    audioPath: _summerNightAudioAssetPath,
    isPremium: false,
    isFavorite: false,
    videoPath: _summerNightVideoAssetPath,
    moodTags: <String>['Warm Air', 'Crickets', 'Drift'],
  ),
  SoundItem(
    id: 'sunset_beach',
    title: 'Sunset Beach',
    category: 'Nature',
    duration: '38 min',
    imagePath: _sunsetBeachVideoAssetPath,
    audioPath: _sunsetBeachAudioAssetPath,
    isPremium: false,
    isFavorite: false,
    videoPath: _sunsetBeachVideoAssetPath,
    moodTags: <String>['Ocean', 'Golden Hour', 'Ease'],
  ),
  SoundItem(
    id: 'under_the_stars',
    title: 'Under the Stars',
    category: 'Sleep',
    duration: '52 min',
    imagePath: _underTheStarVideoAssetPath,
    audioPath: _underTheStarAudioAssetPath,
    isPremium: false,
    isFavorite: false,
    videoPath: _underTheStarVideoAssetPath,
    moodTags: <String>['Stars', 'Stillness', 'Dream'],
  ),
  SoundItem(
    id: 'weekend_rainy_day',
    title: 'Weekend Rainy Day',
    category: 'ASMR',
    duration: '43 min',
    imagePath: _weekendRainyDayVideoAssetPath,
    audioPath: _weekendRainyDayAudioAssetPath,
    isPremium: false,
    isFavorite: false,
    videoPath: _weekendRainyDayVideoAssetPath,
    moodTags: <String>['Rain', 'Weekend', 'Cozy'],
  ),
];
