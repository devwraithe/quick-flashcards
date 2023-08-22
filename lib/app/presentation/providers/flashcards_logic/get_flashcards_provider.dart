import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/card_model.dart';
import '../../../domain/usecases/flashcard_usecase/get_flashcards_usecase.dart';

enum GetFlashcardsState { initial, loading, loaded, failed }

class GetFlashcardsNotifier extends StateNotifier<GetFlashcardsState> {
  final GetFlashcardsUsecase _getFlashcardsUsecase;

  GetFlashcardsNotifier(this._getFlashcardsUsecase)
      : super(GetFlashcardsState.initial);

  String? error;
  List<CardModel>? flashcardsList;

  void triggerRefresh() {
    getFlashcards();
  }

  void getFlashcards() async {
    state = GetFlashcardsState.loading;
    try {
      final result = await _getFlashcardsUsecase.execute();
      result.fold(
        (failure) {
          state = GetFlashcardsState.failed;
          debugPrint("failure from server in provider: ${failure.message}");
          error = failure.message;
        },
        (flashcards) {
          state = GetFlashcardsState.loaded;
          debugPrint("success from server in provider");
          flashcardsList = flashcards;
        },
      );
    } catch (e) {
      state = GetFlashcardsState.failed;
      debugPrint("[CUBIT UNKNOWN ERROR] ${e.toString()}");
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
