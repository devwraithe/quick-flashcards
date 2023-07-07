import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_flashcards/app/core/constants/firebase_constants.dart';
import 'package:quick_flashcards/app/data/card_model.dart';
import 'package:quick_flashcards/app/domain/repositories/flashcard_repository.dart';

import '../../core/constants/string_constants.dart';
import '../../core/errors/exceptions.dart';

class FlashcardRepositoryImpl implements FlashcardRepository {
  @override
  Future<void> addFlashcard(
      String question, String answer, String color) async {
    final itemsRef = FirebaseConstants.firestore.collection("flashcards");
    try {
      final newItemRef = itemsRef.doc(); // this generates a new id
      final newItemId = newItemRef.id;

      await itemsRef.add({
        'id': newItemId,
        'user': FirebaseConstants.user!.uid,
        'question': question,
        'answer': answer,
        'color': color,
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

  @override
  Future<List<CardModel>> getFlashcards() async {
    try {
      final user = FirebaseConstants.firebaseAuth.currentUser;
      final querySnapshot = await FirebaseConstants.firestore
          .collection('flashcards')
          .where('user', isEqualTo: user!.uid)
          .get();
      final flashcards = querySnapshot.docs.map((flashcard) {
        return CardModel.fromSnapshot(flashcard);
      }).toList();
      return flashcards;
    } on SocketException catch (e) {
      throw ConnectionException(StringConstants.socketError);
    } catch (e) {
      debugPrint("Something went wrong: $e");
      return [];
    }
  }
}

// repo impl provider
final fcRepoProvider = Provider<FlashcardRepositoryImpl>(
  (ref) => FlashcardRepositoryImpl(),
);
