import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_flashcards/app/data/repository/flashcards_repository_impl.dart';

class AddFlashcardUsecase {
  final FlashcardRepositoryImpl _repo;
  AddFlashcardUsecase(this._repo);

  Future<void> execute(String question, String answer) async {
    return await _repo.addFlashcard(question, answer);
  }
}

// usecase provider
final fcUsecase = Provider<AddFlashcardUsecase>(
  (ref) => AddFlashcardUsecase(
    ref.watch(fcRepoProvider),
  ),
);
