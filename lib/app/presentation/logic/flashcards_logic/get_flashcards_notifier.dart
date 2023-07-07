import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/exceptions.dart';
import '../../../data/card_model.dart';
import '../../../domain/usecases/flashcard_usecase/get_flashcards_usecase.dart';

enum GetFlashcardsState { initial, loading, success, failed }

class GetFlashcardsNotifier extends StateNotifier<GetFlashcardsState> {
  final GetFlashcardsUsecase _usecase;

  GetFlashcardsNotifier(this._usecase) : super(GetFlashcardsState.initial);

  Future<List<CardModel?>> getFlashcards() async {
    state = GetFlashcardsState.loading; // begin the loading
    try {
      state = GetFlashcardsState.success; // req is successful
      return await _usecase.execute(); // handle the req
    } on AuthException catch (e) {
      debugPrint("[CUBIT AUTH ERROR] ${e.message}");
      state = GetFlashcardsState.failed;
      return [];
    } on SocketException catch (e) {
      debugPrint("[CUBIT SOCKET ERROR] ${e.message}");
      state = GetFlashcardsState.failed;
      return [];
    } catch (e) {
      debugPrint("[CUBIT UNKNOWN ERROR] ${e.toString()}");
      state = GetFlashcardsState.failed;
      return [];
    }
  }
}

final getFlashcardProv = FutureProvider<List<CardModel?>>(
  (ref) async {
    final notifier = GetFlashcardsNotifier(
      ref.watch(getFcUsecase),
    );
    return await notifier.getFlashcards();
  },
);
