import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_flashcards/app/data/card_model.dart';
import 'package:quick_flashcards/app/data/repository/flashcards_repository_impl.dart';

class GetFlashcardsUsecase {
  final FlashcardRepositoryImpl _repo;
  GetFlashcardsUsecase(this._repo);

  Future<List<CardModel>> execute() async {
    return await _repo.getFlashcards();
  }
}

// usecase provider
final getFcUsecase = Provider<GetFlashcardsUsecase>(
  (ref) => GetFlashcardsUsecase(
    ref.watch(fcRepoProvider),
  ),
);
