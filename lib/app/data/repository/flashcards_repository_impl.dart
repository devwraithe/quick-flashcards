import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_flashcards/app/core/constants/firebase_constants.dart';
import 'package:quick_flashcards/app/domain/repositories/flashcard_repository.dart';

import '../../core/constants/string_constants.dart';
import '../../core/errors/exceptions.dart';

class FlashcardRepositoryImpl implements FlashcardRepository {
  @override
  Future<void> addFlashcard(String question, String answer) async {
    final itemsRef = FirebaseConstants.firestore.collection("flashcards");
    try {
      final newItemRef = itemsRef.doc(); // this generates a new id
      final newItemId = newItemRef.id;

      await itemsRef.add({
        'id': newItemId,
        'question': question,
        'answer': answer,
      }).then((value) {
        debugPrint("Flashcard created: $value");
      }).catchError((err) {
        debugPrint("Error creating flashcard: $err");
      });
    } on SocketException catch (e) {
      debugPrint("SocketException: $e");
      throw ConnectionException(StringConstants.socketError);
    } catch (e) {
      debugPrint("Something went wrong: $e");
      throw AuthException(StringConstants.unknownError);
    }
  }
}

// repo impl provider
final fcRepoProvider = Provider<FlashcardRepositoryImpl>(
  (ref) => FlashcardRepositoryImpl(),
);
