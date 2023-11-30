import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_flashcards/app/data/repository/flashcards_repository_impl.dart';

import '../../repositories/flashcard_repository.dart';

class DeleteCardUsecase {
  final FlashcardRepository _repository;
  DeleteCardUsecase(this._repository);

  Future<void> execute(String cardId) async {
    return await _repository.deleteCard(cardId);
  }
}

final deleteCardUsecaseProvider = Provider<DeleteCardUsecase>(
  (ref) => DeleteCardUsecase(
    ref.watch(flashcardRepoProvider),
  ),
);
