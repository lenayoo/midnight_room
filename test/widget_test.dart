import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:midnight_room/app.dart';
import 'package:midnight_room/core/localization/app_localizations.dart';
import 'package:midnight_room/core/theme/app_theme.dart';
import 'package:midnight_room/data/mock/mock_quotes.dart';
import 'package:midnight_room/data/mock/mock_sounds.dart';
import 'package:midnight_room/data/models/sound_item.dart';
import 'package:midnight_room/features/profile/services/user_profile_service.dart';
import 'package:midnight_room/features/my/presentation/screens/my_screen.dart';
import 'package:midnight_room/features/quote/presentation/screens/quote_screen.dart';
import 'package:midnight_room/features/shell/presentation/screens/home_shell_screen.dart';
import 'package:midnight_room/features/sounds/presentation/screens/sounds_screen.dart';
import 'package:midnight_room/features/sounds/presentation/widgets/sound_library_tile.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
  });

  testWidgets('first launch asks for the user name', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const SoundscapeDaysApp());
    await tester.pump(const Duration(milliseconds: 700));

    expect(find.text('Midnight Room'), findsAtLeastNWidgets(1));
    expect(find.text('How can I call you?'), findsOneWidget);
    expect(find.text('Enter your room'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'Lena');
    await tester.pump(const Duration(milliseconds: 250));

    expect(find.text('Enter your room'), findsOneWidget);
    expect(find.text('Welcome back.'), findsNothing);
  });

  testWidgets('home shell uses the stored name in the bottom bar', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      _buildTestApp(home: const HomeShellScreen(userName: 'Lena')),
    );
    await tester.pump(const Duration(milliseconds: 700));

    expect(find.text('Lena'), findsOneWidget);
    expect(find.text('My'), findsNothing);
    expect(find.text('Midnight Room'), findsOneWidget);
  });

  testWidgets('returning users see the welcome back entry scene', (
    WidgetTester tester,
  ) async {
    SharedPreferences.setMockInitialValues(<String, Object>{
      UserProfileService.userNameKey: 'Lena',
    });

    await tester.pumpWidget(const SoundscapeDaysApp());
    await tester.pump(const Duration(milliseconds: 700));
    await tester.pump(const Duration(seconds: 3));

    expect(find.text('Midnight Room'), findsAtLeastNWidgets(1));
    expect(find.text('Welcome back.'), findsOneWidget);
    expect(find.text('Lena'), findsOneWidget);
    expect(find.text('Enter your room'), findsOneWidget);

    await tester.tap(find.text('Enter your room'));
    await tester.pump();

    expect(find.text('Midnight Room'), findsAtLeastNWidgets(1));
  });

  testWidgets('standalone sounds screen lays out on a small viewport', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      _buildTestApp(
        home: Scaffold(
          body: SoundsScreen(
            sounds: mockSounds,
            featuredRooms: const <SoundItem>[],
            currentSound: mockSounds.first,
            onSelectSound: (_) {},
            onOpenSoundRoom: (_) {},
            onToggleFavorite: (_) {},
          ),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 700));

    expect(find.text('Midnight Room'), findsOneWidget);
    expect(find.text('Tap the heart on any sound you like.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  test('mock sounds include new rooms and omit removed items', () {
    final List<String> soundIds = mockSounds
        .map((sound) => sound.id)
        .toList(growable: false);

    expect(soundIds, contains('in_the_universe'));
    expect(soundIds, contains('under_the_stars'));
    expect(soundIds, isNot(contains('deep_sleep')));
    expect(
      mockSounds.every((SoundItem sound) => sound.isFavorite == false),
      isTrue,
    );
    expect(soundIds, isNot(contains('night_train')));
    expect(soundIds, isNot(contains('soft_piano')));
    expect(soundIds, isNot(contains('tokyo_night')));
    expect(soundIds, isNot(contains('morning_birds')));
  });

  testWidgets('standalone quote screen lays out on a small viewport', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      _buildTestApp(
        home: Scaffold(
          body: QuoteScreen(
            quote: mockQuotes.first,
            isLoading: false,
            categories: const <String>['calm', 'hope', 'reflection'],
            selectedCategory: 'hope',
            onSelectCategory: (_) {},
          ),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 700));

    expect(find.text('Quote'), findsOneWidget);
    expect(find.text('Peter Drucker'), findsOneWidget);
    expect(find.text('Calm'), findsOneWidget);
    expect(find.text('Hope'), findsOneWidget);
    expect(find.text('Reflection'), findsOneWidget);
    expect(find.text('Next quote'), findsNothing);
    expect(find.text('Save'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('standalone my screen lays out on a small viewport', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      _buildTestApp(
        home: Scaffold(
          body: MyScreen(
            savedQuotes: mockQuotes.where((quote) => quote.isSaved).toList(),
            favoriteSounds:
                mockSounds.where((sound) => sound.isFavorite).toList(),
          ),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 700));

    expect(
      find.text(
        'A little room where you can slow down, breathe deeply, and simply be.',
      ),
      findsOneWidget,
    );
    expect(find.text('Calm your mind.'), findsOneWidget);
    expect(
      find.text(
        'Every breath, every step, and every day is part of celebrating your life.',
      ),
      findsOneWidget,
    );
    expect(find.textContaining('Just'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('my screen keeps Just breathe in Korean locale', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      _buildTestApp(
        home: Scaffold(
          body: MyScreen(
            savedQuotes: mockQuotes.where((quote) => quote.isSaved).toList(),
            favoriteSounds:
                mockSounds.where((sound) => sound.isFavorite).toList(),
          ),
        ),
        locale: const Locale('ko'),
      ),
    );
    await tester.pump(const Duration(milliseconds: 700));

    expect(find.text('Just breathe'), findsOneWidget);
  });

  testWidgets('sounds screen switches labels for Korean locale', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      _buildTestApp(
        home: Scaffold(
          body: SoundsScreen(
            sounds: mockSounds,
            featuredRooms: const <SoundItem>[],
            currentSound: mockSounds.first,
            onSelectSound: (_) {},
            onOpenSoundRoom: (_) {},
            onToggleFavorite: (_) {},
          ),
        ),
        locale: const Locale('ko'),
      ),
    );
    await tester.pump(const Duration(milliseconds: 700));

    expect(find.text('좋아하는 사운드'), findsOneWidget);
    expect(find.text('마음에 드는 사운드에 하트를 눌러보세요.'), findsOneWidget);
  });

  testWidgets('favoriting a sound promotes it into the room cards', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      _buildTestApp(home: const HomeShellScreen(userName: 'Lena')),
    );
    await tester.pump(const Duration(milliseconds: 700));

    expect(find.text('Afternoon Rain'), findsOneWidget);

    await tester.tap(
      find.descendant(
        of: find.byType(SoundLibraryTile).first,
        matching: find.byType(IconButton),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Afternoon Rain'), findsNWidgets(2));
    expect(
      find.text(
        'Soft afternoon rain settles the air and gently untangles a hurried state of mind.',
      ),
      findsOneWidget,
    );
  });

  testWidgets('preview sound asset is bundled', (WidgetTester tester) async {
    final ByteData audioData = await rootBundle.load(
      'assets/sounds/sound1.mp3',
    );

    expect(audioData.lengthInBytes, greaterThan(0));
  });
}

Widget _buildTestApp({
  required Widget home,
  Locale locale = const Locale('en'),
}) {
  return MaterialApp(
    locale: locale,
    supportedLocales: AppLocalizations.supportedLocales,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    theme: AppTheme.build(locale),
    home: home,
  );
}
