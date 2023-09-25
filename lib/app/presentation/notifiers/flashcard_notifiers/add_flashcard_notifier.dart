import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_flashcards/app/domain/usecases/flashcard_usecase/create_flashcard_usecase.dart';

import 'get_flashcards_notifier.dart';

enum CreateFlashcardState { initial, loading, success, failed }

class CreateFlashcardNotifier extends StateNotifier<CreateFlashcardState> {
  final CreateFlashcardUsecase _usecase;
  final GetFlashcardsNotifier _getFlashcardNotifier;

  CreateFlashcardNotifier(
    this._usecase,
    this._getFlashcardNotifier,
  ) : super(CreateFlashcardState.initial);

  String? error;

  Future<CreateFlashcardState> createFlashcard(
    String question,
    String answer,
    String color,
  ) async {
    state = CreateFlashcardState.loading;
    try {
      await _usecase.execute(question, answer, color);
      state = CreateFlashcardState.success;
      // trigger a refresh when flashcard is created
      _getFlashcardNotifier.triggerRefresh();
      return state;
    } catch (e) {
      state = CreateFlashcardState.failed;
      error = e.toString();
      return state;
    }
  }
}

final createFlashcardProvider =
    StateNotifierProvider<CreateFlashcardNotifier, CreateFlashcardState>(
  (ref) => CreateFlashcardNotifier(
    ref.watch(createFlashcardUsecaseProvider),
    // watch the get flashcards notifier for refresh trigger
    ref.watch(getFlashcardsProvider.notifier),
  ),
);
