import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/exceptions.dart';
import '../../../domain/usecases/auth_usecases/reset_password_usecase.dart';

enum ResetPasswordState { initial, loading, success, failed }

class ResetPasswordNotifier extends StateNotifier<ResetPasswordState> {
  final ResetPasswordUsecase _usecase;

  ResetPasswordNotifier(this._usecase) : super(ResetPasswordState.initial);

  Future<String?> resetPassword(String email) async {
    state = ResetPasswordState.loading;
    try {
      await _usecase.execute(email);
      state = ResetPasswordState.success;
      return null.toString();
    } on AuthException catch (e) {
      debugPrint("[CUBIT AUTH ERROR] ${e.message}");
      state = ResetPasswordState.failed;
      return e.message;
    } on SocketException catch (e) {
      debugPrint("[CUBIT SOCKET ERROR] ${e.message}");
      state = ResetPasswordState.failed;
      return e.message;
    } catch (e) {
      debugPrint("[CUBIT UNKNOWN ERROR] ${e.toString()}");
      state = ResetPasswordState.failed;
      return e.toString();
    }
  }
}

// notifier provider
final resetPasswordProvider =
    StateNotifierProvider<ResetPasswordNotifier, ResetPasswordState>(
  (ref) => ResetPasswordNotifier(
    ref.watch(resetPasswordUsecase),
  ),
);
