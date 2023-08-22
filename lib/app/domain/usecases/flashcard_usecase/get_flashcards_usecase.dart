import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_flashcards/app/data/card_model.dart';
import 'package:quick_flashcards/app/data/repository/flashcards_repository_impl.dart';

import '../../../core/errors/failure.dart';
import '../../repositories/flashcard_repository.dart';

class GetFlashcardsUsecase {
  final FlashcardRepository repository;
  GetFlashcardsUsecase(this.repository);

  Future<Either<Failure, List<CardModel>>> execute() async {
    final result = await repository.getFlashcards();
    return result.fold(
      (failure) {
        debugPrint("[ERROR QUERYING MODEL] ${failure.message}");
        return Left(failure);
      },
      (flashcards) {
        debugPrint("[QUERIED MODEL] ${flashcards.length}");
        return Right(flashcards);
      },
    );
  }
}

final getFlashcardsUsecaseProvider = Provider<GetFlashcardsUsecase>(
  (ref) => GetFlashcardsUsecase(
    ref.watch(flashcardRepoProvider),
  ),
);
