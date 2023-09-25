import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/usecases/auth_usecases/login_usecase.dart';

enum LoginState { initial, loading, success, failed }

class LoginNotifier extends StateNotifier<LoginState> {
  final LoginUsecase _usecase;
  LoginNotifier(this._usecase) : super(LoginState.initial);

  String? error;

  Future<LoginState> login(Map<String, dynamic> data) async {
    state = LoginState.loading;
    try {
      await _usecase.execute(data);
      state = LoginState.success;
      return state;
    } catch (e) {
      state = LoginState.failed;
      error = e.toString();
      return state;
    }
  }
}

final loginProvider = StateNotifierProvider<LoginNotifier, LoginState>(
  (ref) => LoginNotifier(
    ref.watch(loginUsecaseProvider),
  ),
);
