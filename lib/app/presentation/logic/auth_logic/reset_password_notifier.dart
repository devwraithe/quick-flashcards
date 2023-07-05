import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/exceptions.dart';
import '../../../core/errors/failure.dart';
import '../../../domain/usecases/auth_usecases/reset_password_usecase.dart';

enum ResetPasswordState { initial, loading, loaded, error }

class ResetPasswordNotifier extends StateNotifier<ResetPasswordState> {
  final ResetPasswordUsecase _usecase;

  ResetPasswordNotifier(this._usecase) : super(ResetPasswordState.initial);

  Failure? errorMessage;

  Future<void> resetPassword(String email) async {
    try {
      state = ResetPasswordState.loading;
      await _usecase.execute(email);
      state = ResetPasswordState.loaded;
    } on AuthException catch (e) {
      state = ResetPasswordState.error;
      errorMessage = Failure(e.message);
    } on SocketException catch (e) {
      state = ResetPasswordState.error;
      errorMessage = Failure(e.message);
    } catch (e) {
      state = ResetPasswordState.error;
      errorMessage = Failure(e.toString());
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
