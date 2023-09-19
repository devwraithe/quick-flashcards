import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/usecases/auth_usecases/register_usecase.dart';

enum RegisterState { initial, loading, success, failed }

class RegisterNotifier extends StateNotifier<RegisterState> {
  final RegisterUsecase _usecase;
  RegisterNotifier(this._usecase) : super(RegisterState.initial);

  String? error;
  User? user;

  Future<RegisterState> register(Map<String, dynamic> data) async {
    state = RegisterState.loading;
    try {
      final result = await _usecase.execute(data);
      result.fold((failure) {
        state = RegisterState.failed;
        error = failure.message;
        return state;
      }, (user) {
        state = RegisterState.success;
        user = user;
        return state;
      });
      return state;
    } catch (e) {
      state = RegisterState.failed;
      error = e.toString();
      return state;
    }
  }
}

final registerProvider = StateNotifierProvider<RegisterNotifier, RegisterState>(
  (ref) => RegisterNotifier(
    ref.watch(registerUsecaseProvider),
  ),
);
