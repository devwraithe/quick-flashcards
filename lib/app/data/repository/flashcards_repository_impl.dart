import 'dart:async';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_flashcards/app/core/utilities/constants/firebase_constants.dart';
import 'package:quick_flashcards/app/data/card_model.dart';
import 'package:quick_flashcards/app/domain/repositories/flashcard_repository.dart';

import '../../core/utilities/constants/constants.dart';
import '../../core/utilities/errors/exceptions.dart';
import '../../core/utilities/errors/failure.dart';

class FlashcardRepositoryImpl implements FlashcardRepository {
  @override
  Future<void> createFlashcard(
    String question,
    String answer,
    String color,
  ) async {
    final flashcardCollection = FirebaseConstants.firestore.collection(
      "flashcards",
    );
    try {
      final newFlashcardCollection = flashcardCollection.doc();
      final newFlashcardId = newFlashcardCollection.id;

      await flashcardCollection.add({
        'id': newFlashcardId,
        'user': FirebaseConstants.user!.uid,
        'question': question,
        'answer': answer,
        'color': color,
      }).then((value) {
        debugPrint("Flashcard created successfully: $value");
      }).catchError((err) {
        debugPrint("Error creating flashcard: $err");
      });
    } on SocketException catch (_) {
      throw ConnectionException(Constants.socketError);
    } on TimeoutException catch (_) {
      throw ConnectionException(Constants.timeoutError);
    } catch (e) {
      throw ServerException(Constants.unknownError);
    }
  }

  @override
  Future<Either<Failure, List<CardModel>>> getFlashcards() async {
    try {
      final user = FirebaseConstants.firebaseAuth.currentUser;
      final querySnapshot = await FirebaseConstants.firestore
          .collection('flashcards')
          .where('user', isEqualTo: user!.uid)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        final flashcardsList = querySnapshot.docs.map((flashcard) {
          return CardModel.fromSnapshot(flashcard);
        }).toList();
        return Right(flashcardsList);
      } else {
        return Left(Failure(Constants.emptyFlashcardsList));
      }
    } on SocketException catch (_) {
      throw ConnectionException(Constants.socketError);
    } on TimeoutException catch (_) {
      throw ConnectionException(Constants.timeoutError);
    } on FirebaseAuthException catch (e) {
      throw ServerException(e.toString());
    } on FirebaseException catch (e) {
      throw ServerException(e.toString());
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}

final flashcardRepoProvider = Provider<FlashcardRepository>(
  (ref) => FlashcardRepositoryImpl(),
);
