import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/usecases/auth_usecases/reset_password_usecase.dart';

enum ResetPasswordState { initial, loading, success, failed }

class ResetPasswordNotifier extends StateNotifier<ResetPasswordState> {
  final ResetPasswordUsecase _usecase;
  ResetPasswordNotifier(this._usecase) : super(ResetPasswordState.initial);

  String? error;

  Future<ResetPasswordState> resetPassword(String email) async {
    state = ResetPasswordState.loading;
    try {
      await _usecase.execute(email);
      state = ResetPasswordState.success;
      return state;
    } catch (e) {
      state = ResetPasswordState.failed;
      error = e.toString();
      return state;
    }
  }
}

final resetPasswordProvider =
    StateNotifierProvider<ResetPasswordNotifier, ResetPasswordState>(
  (ref) => ResetPasswordNotifier(
    ref.watch(resetPasswordUsecaseProvider),
  ),
);
