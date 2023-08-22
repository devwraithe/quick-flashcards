import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_flashcards/app/data/repository/flashcards_repository_impl.dart';

import '../../repositories/flashcard_repository.dart';

class AddFlashcardUsecase {
  final FlashcardRepository _repo;
  AddFlashcardUsecase(this._repo);

  Future<void> execute(String question, String answer, String color) async {
    return await _repo.addFlashcard(question, answer, color);
  }
}

// usecase provider
final fcUsecase = Provider<AddFlashcardUsecase>(
  (ref) => AddFlashcardUsecase(
    ref.watch(flashcardRepoProvider),
  ),
);
