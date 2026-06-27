import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:midnight_room/app.dart';
import 'package:midnight_room/data/mock/mock_quotes.dart';
import 'package:midnight_room/data/mock/mock_sounds.dart';
import 'package:midnight_room/features/profile/services/user_profile_service.dart';
import 'package:midnight_room/features/my/presentation/screens/my_screen.dart';
import 'package:midnight_room/features/quote/presentation/screens/quote_screen.dart';
import 'package:midnight_room/features/shell/presentation/screens/home_shell_screen.dart';
import 'package:midnight_room/features/sounds/presentation/screens/sounds_screen.dart';
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
    expect(find.text('Welcome back, Lena.'), findsNothing);
  });

  testWidgets('home shell uses the stored name in the bottom bar', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: HomeShellScreen(userName: 'Lena')),
    );
    await tester.pump(const Duration(milliseconds: 700));

    expect(find.text('Lena'), findsOneWidget);
    expect(find.text('My'), findsNothing);
    expect(find.text('Sound library'), findsOneWidget);
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
    expect(find.text('Welcome back, Lena.'), findsOneWidget);
    expect(find.text('Enter your room'), findsOneWidget);
    expect(find.text('Sound library'), findsNothing);

    await tester.tap(find.text('Enter your room'));
    await tester.pump();

    expect(find.text('Sound library'), findsOneWidget);
  });

  testWidgets('standalone sounds screen lays out on a small viewport', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SoundsScreen(
            sounds: mockSounds,
            featuredRooms:
                mockSounds
                    .where(
                      (sound) => const <String>{
                        'in_the_universe',
                        'deep_sleep',
                        'yoga',
                      }.contains(sound.id),
                    )
                    .toList(),
            currentSound: mockSounds.first,
            onSelectSound: (_) {},
            onOpenSoundRoom: (_) {},
            onToggleFavorite: (_) {},
          ),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 700));

    expect(find.text('Sound library'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  test('mock sounds include new rooms and omit removed items', () {
    final List<String> soundIds = mockSounds
        .map((sound) => sound.id)
        .toList(growable: false);

    expect(soundIds, contains('in_the_universe'));
    expect(soundIds, contains('deep_sleep'));
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
      MaterialApp(
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
      MaterialApp(
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

  testWidgets('preview sound asset is bundled', (WidgetTester tester) async {
    final ByteData audioData = await rootBundle.load(
      'assets/sounds/sound1.mp3',
    );

    expect(audioData.lengthInBytes, greaterThan(0));
  });
}
