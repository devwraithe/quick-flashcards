import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/usecases/flashcard_usecase/delete_card_usecase.dart';
import 'get_flashcards_notifier.dart';

enum DeleteCardState { initial, loading, success, failed }

class DeleteCardNotifier extends StateNotifier<DeleteCardState> {
  final DeleteCardUsecase _usecase;
  final GetFlashcardsNotifier _getFlashcardNotifier;

  DeleteCardNotifier(
    this._usecase,
    this._getFlashcardNotifier,
  ) : super(DeleteCardState.initial);

  String? error;

  Future<DeleteCardState> deleteCard(String cardId) async {
    state = DeleteCardState.loading;
    try {
      await _usecase.execute(cardId);
      state = DeleteCardState.success;
      // trigger a refresh when flashcard is created
      _getFlashcardNotifier.triggerRefresh();
      return state;
    } catch (e) {
      state = DeleteCardState.failed;
      error = e.toString();
      return state;
    }
  }
}

final deleteCardProvider =
    StateNotifierProvider<DeleteCardNotifier, DeleteCardState>(
  (ref) => DeleteCardNotifier(
    ref.watch(deleteCardUsecaseProvider),
    // watch the get flashcards notifier for refresh trigger
    ref.watch(getFlashcardsProvider.notifier),
  ),
);
