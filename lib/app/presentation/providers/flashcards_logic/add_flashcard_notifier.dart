import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_flashcards/app/domain/usecases/flashcard_usecase/add_flashcard_usecase.dart';

import '../../../core/errors/exceptions.dart';
import 'get_flashcards_provider.dart';

enum AddFlashcardState { initial, loading, success, failed }

class AddFlashcardNotifier extends StateNotifier<AddFlashcardState> {
  final AddFlashcardUsecase _usecase;
  final GetFlashcardsNotifier _getFlashcardNotifier;

  AddFlashcardNotifier(
    this._usecase,
    this._getFlashcardNotifier,
  ) : super(AddFlashcardState.initial);

  Future<String?> addFlashcard(
    String question,
    String answer,
    String color,
  ) async {
    state = AddFlashcardState.loading; // begin the loading
    try {
      await _usecase.execute(question, answer, color); // handle the req
      state = AddFlashcardState.success; // req is successful
      _getFlashcardNotifier.triggerRefresh(); // trigger refresh
      return "flashcard_created";
    } on AuthException catch (e) {
      debugPrint("[CUBIT AUTH ERROR] ${e.message}");
      state = AddFlashcardState.failed;
      return e.message;
    } on SocketException catch (e) {
      debugPrint("[CUBIT SOCKET ERROR] ${e.message}");
      state = AddFlashcardState.failed;
      return e.message;
    } catch (e) {
      debugPrint("[CUBIT UNKNOWN ERROR] ${e.toString()}");
      state = AddFlashcardState.failed;
      return e.toString();
    }
  }
}

// notifier provider
final fcProvider =
    StateNotifierProvider<AddFlashcardNotifier, AddFlashcardState>(
  (ref) => AddFlashcardNotifier(
    ref.watch(fcUsecase),
    ref.watch(getFlashcardsProvider.notifier),
  ),
);