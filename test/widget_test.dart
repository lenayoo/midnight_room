import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:midnight_room/app.dart';
import 'package:midnight_room/data/mock/mock_quotes.dart';
import 'package:midnight_room/data/mock/mock_sounds.dart';
import 'package:midnight_room/features/my/presentation/screens/my_screen.dart';
import 'package:midnight_room/features/quote/presentation/screens/quote_screen.dart';
import 'package:midnight_room/features/sounds/presentation/screens/sounds_screen.dart';

void main() {
  testWidgets('renders the three main tabs and simplified sounds screen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const SoundscapeDaysApp());
    await tester.pumpAndSettle();

    expect(find.text('Sounds'), findsNWidgets(2));
    expect(find.text('Quote'), findsOneWidget);
    expect(find.text('My'), findsOneWidget);
    expect(find.text('Timer'), findsNothing);
    expect(find.text('Pick one sound and press play.'), findsOneWidget);
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
            yogaSound: mockSounds.firstWhere((sound) => sound.id == 'yoga'),
            currentSound: mockSounds.first,
            isPlaying: false,
            volume: 0.76,
            onSelectSound: (_) {},
            onOpenSoundRoom: (_) {},
            onToggleFavorite: (_) {},
            onPlayPause: () {},
            onVolumeChanged: (_) {},
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Selected sound'), findsOneWidget);
    expect(find.text('Yoga'), findsWidgets);
    expect(tester.takeException(), isNull);
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
            savedCount: 1,
            onSelectCategory: (_) {},
            onToggleSaved: () {},
            onNextQuote: () {},
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.text('Read one quote and save it if you want.'),
      findsOneWidget,
    );
    expect(find.text('Calm'), findsOneWidget);
    expect(find.text('Hope'), findsNWidgets(2));
    expect(find.text('Reflection'), findsOneWidget);
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
    await tester.pumpAndSettle();

    expect(
      find.text('Only saved quotes and favorite sounds are shown here.'),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('preview sound asset is bundled', (WidgetTester tester) async {
    final ByteData audioData = await rootBundle.load(
      'assets/sounds/sound1.mp3',
    );

    expect(audioData.lengthInBytes, greaterThan(0));
  });
}
