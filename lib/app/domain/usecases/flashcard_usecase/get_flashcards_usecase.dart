import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_flashcards/app/data/card_model.dart';
import 'package:quick_flashcards/app/data/repository/flashcards_repository_impl.dart';

import '../../../core/utilities/errors/failure.dart';
import '../../repositories/flashcard_repository.dart';

class GetFlashcardsUsecase {
  final FlashcardRepository repository;
  GetFlashcardsUsecase(this.repository);

  Future<Either<Failure, List<CardModel>>> execute() async {
    final result = await repository.getFlashcards();
    return result.fold(
      (failure) => Left(failure),
      (flashcards) => Right(flashcards),
    );
  }
}

final getFlashcardsUsecaseProvider = Provider<GetFlashcardsUsecase>(
  (ref) => GetFlashcardsUsecase(
    ref.watch(flashcardRepoProvider),
  ),
);
