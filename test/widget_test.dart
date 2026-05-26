import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:midnight_room/data/mock/mock_quotes.dart';
import 'package:midnight_room/app.dart';
import 'package:midnight_room/data/mock/mock_sounds.dart';
import 'package:midnight_room/data/mock/mock_timer_history.dart';
import 'package:midnight_room/features/my/presentation/screens/my_screen.dart';
import 'package:midnight_room/features/premium/domain/subscription_state.dart';
import 'package:midnight_room/features/quote/presentation/screens/quote_screen.dart';
import 'package:midnight_room/features/sounds/presentation/screens/sounds_screen.dart';
import 'package:midnight_room/features/timer/presentation/screens/timer_screen.dart';

void main() {
  testWidgets('renders the four main tabs and initial sound room', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const SoundscapeDaysApp());
    await tester.pumpAndSettle();

    expect(find.text('Sounds'), findsOneWidget);
    expect(find.text('Timer'), findsOneWidget);
    expect(find.text('Quote'), findsOneWidget);
    expect(find.text('My'), findsOneWidget);
    expect(find.text('A dreamy room for calm listening.'), findsOneWidget);
  });

  testWidgets('timer screen scrolls to premium pomodoro section without errors', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const SoundscapeDaysApp());
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    await tester.tap(find.text('Timer'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    await tester.drag(find.byType(SingleChildScrollView), const Offset(0, -500));
    await tester.pumpAndSettle();

    expect(find.text('Advanced Pomodoro controls'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('standalone timer screen lays out on a small viewport', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TimerScreen(
            currentSound: mockSounds.first,
            isPremium: false,
            onOpenPremium: () {},
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Pomodoro Room'), findsOneWidget);
    expect(tester.takeException(), isNull);
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
            currentSound: mockSounds.first,
            isPremium: false,
            onSelectSound: (_) {},
            onToggleFavorite: (_) {},
            onPlayNext: () {},
            onPlayPrevious: () {},
            onOpenPremium: () {},
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Soundscape Days'), findsOneWidget);
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
            savedCount: 1,
            onToggleSaved: () {},
            onRefresh: () {},
            onShare: () {},
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('A quiet reflection room.'), findsOneWidget);
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
            subscriptionState: const SubscriptionState(
              plan: SubscriptionPlan.free,
              priceLabel: '¥490 / month',
            ),
            savedQuotes: mockQuotes.where((quote) => quote.isSaved).toList(),
            favoriteSounds: mockSounds.where((sound) => sound.isFavorite).toList(),
            timerHistory: mockTimerHistory,
            onOpenPremium: () {},
            onOpenNotificationPreview: () {},
            onOpenThemePreview: () {},
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Quiet evenings'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
