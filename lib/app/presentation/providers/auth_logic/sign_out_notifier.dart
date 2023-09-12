import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/usecases/auth_usecases/signout_usecase.dart';

enum SignOutState { initial, loading, success, failed }

class SignOutNotifier extends StateNotifier<SignOutState> {
  final SignOutUsecase _usecase;
  SignOutNotifier(this._usecase) : super(SignOutState.initial);

  String? error;

  Future<SignOutState> signOut() async {
    state = SignOutState.loading;
    try {
      await _usecase.execute();
      state = SignOutState.success;
      return state;
    } catch (e) {
      state = SignOutState.failed;
      error = e.toString();
      return state;
    }
  }
}

final signOutProvider = StateNotifierProvider<SignOutNotifier, SignOutState>(
  (ref) => SignOutNotifier(
    ref.watch(signOutUsecaseProvider),
  ),
);
