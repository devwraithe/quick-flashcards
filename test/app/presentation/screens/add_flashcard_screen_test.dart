import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quick_flashcards/app/presentation/screens/add_flashcard_screen.dart';
import 'package:quick_flashcards/app/presentation/widgets/flashcard_text_field.dart';

import '../../../core/helpers/test_helpers.mocks.dart';

void main() {
  late MockAddFlashcardNotifier mockNotifier;

  setUp(() {
    mockNotifier = MockAddFlashcardNotifier();
  });

  testWidgets('renders the screen correctly', (tester) async {
    // render the widget tree
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: AddFlashcardScreen(),
        ),
      ),
    );

    // verify that widgets are rendered
    expect(find.byType(Scaffold), findsOneWidget);
    expect(find.byType(SafeArea), findsOneWidget);
    expect(find.byType(FlashcardTextField), findsNWidgets(2));
    expect(find.byType(Text), findsWidgets);
    expect(find.byType(Consumer), findsOneWidget);

    // verify the presence of texts
    expect(find.text("Back"), findsOneWidget);
    expect(find.text("Save"), findsOneWidget);
    expect(find.text("Question"), findsOneWidget);
    expect(find.text("Answer"), findsOneWidget);
  });
}
