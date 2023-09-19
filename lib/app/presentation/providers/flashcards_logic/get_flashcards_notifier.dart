import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/card_model.dart';
import '../../../domain/usecases/flashcard_usecase/get_flashcards_usecase.dart';

enum GetFlashcardsState { initial, loading, loaded, failed }

class GetFlashcardsNotifier extends StateNotifier<GetFlashcardsState> {
  final GetFlashcardsUsecase _usecase;

  GetFlashcardsNotifier(this._usecase) : super(GetFlashcardsState.initial);

  String? error;
  List<CardModel>? flashcardsList;

  // Handle list refresh
  void triggerRefresh() {
    getFlashcards();
  }

  Future<void> getFlashcards() async {
    state = GetFlashcardsState.loading;
    try {
      final result = await _usecase.execute();
      result.fold(
        (failure) {
          state = GetFlashcardsState.failed;
          error = failure.message;
        },
        (flashcards) {
          state = GetFlashcardsState.loaded;
          flashcardsList = flashcards;
        },
      );
    } catch (e) {
      state = GetFlashcardsState.failed;
      error = e.toString();
    }
  }
}

final getFlashcardsProvider =
    StateNotifierProvider<GetFlashcardsNotifier, GetFlashcardsState>(
  (ref) {
    final notifier = GetFlashcardsNotifier(
      ref.watch(
        getFlashcardsUsecaseProvider,
      ),
    );
    notifier.getFlashcards();
    return notifier;
  },
);
