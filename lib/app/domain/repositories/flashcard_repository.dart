import 'package:quick_flashcards/app/data/card_model.dart';

abstract class FlashcardRepository {
  Future<void> addFlashcard(String question, String answer, String color);
  Future<List<CardModel>> getFlashcards();
}
