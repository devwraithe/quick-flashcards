import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_flashcards/app/data/repository/flashcards_repository_impl.dart';

import '../../repositories/flashcard_repository.dart';

class CreateFlashcardUsecase {
  final FlashcardRepository _repository;
  CreateFlashcardUsecase(this._repository);

  Future<void> execute(String question, String answer, String color) async {
    return await _repository.createFlashcard(question, answer, color);
  }
}

final createFlashcardUsecaseProvider = Provider<CreateFlashcardUsecase>(
  (ref) => CreateFlashcardUsecase(
    ref.watch(flashcardRepoProvider),
  ),
);
