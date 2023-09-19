import 'package:dartz/dartz.dart';
import 'package:quick_flashcards/app/data/card_model.dart';

import '../../core/errors/failure.dart';

abstract class FlashcardRepository {
  Future<void> createFlashcard(String question, String answer, String color);
  Future<Either<Failure, List<CardModel>>> getFlashcards();
}
