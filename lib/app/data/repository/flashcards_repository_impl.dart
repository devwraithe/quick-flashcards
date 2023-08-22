import 'dart:async';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_flashcards/app/core/constants/firebase_constants.dart';
import 'package:quick_flashcards/app/data/card_model.dart';
import 'package:quick_flashcards/app/domain/repositories/flashcard_repository.dart';

import '../../core/constants/string_constants.dart';
import '../../core/errors/exceptions.dart';
import '../../core/errors/failure.dart';

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
  Future<Either<Failure, List<CardModel>>> getFlashcards() async {
    try {
      final user = FirebaseConstants.firebaseAuth.currentUser;
      final querySnapshot = await FirebaseConstants.firestore
          .collection('flashcards')
          .where('user', isEqualTo: user!.uid)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        debugPrint("[QUERY DATA SNAPSHOT] ${querySnapshot.docs.first.data()}");
        final flashcardsList = querySnapshot.docs.map((flashcard) {
          return CardModel.fromSnapshot(flashcard);
        }).toList();
        debugPrint("[PARSE IN MODEL] ${flashcardsList.length}");
        return Right(flashcardsList);
      } else {
        return Left(
          Failure(
            StringConstants.emptyFlashcardsList,
          ),
        );
      }
    } on SocketException catch (_) {
      throw ConnectionException(StringConstants.socketError);
    } on FirebaseAuthException catch (e) {
      debugPrint("[AUTH EXCEPTION] $e");
      throw ServerException(e.toString());
    } on FirebaseException catch (e) {
      debugPrint("[FIREBASE EXCEPTION] $e");
      throw ServerException(e.toString());
    } catch (e) {
      debugPrint("Something went wrong: $e");
      throw ServerException(e.toString());
    }
  }
}

final flashcardRepoProvider = Provider<FlashcardRepository>(
  (ref) => FlashcardRepositoryImpl(),
);
