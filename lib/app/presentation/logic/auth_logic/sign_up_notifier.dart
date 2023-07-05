import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/exceptions.dart';
import '../../../domain/usecases/auth_usecases/sign_up_usecase.dart';

enum SignUpState { initial, loading, success, failed }

class SignUpNotifier extends StateNotifier<SignUpState> {
  final SignUpUsecase _usecase;

  SignUpNotifier(this._usecase) : super(SignUpState.initial);

  Future<void> signUp(String email, String password) async {
    state = SignUpState.loading; // begin the loading
    try {
      await _usecase.execute(email, password); // handle the req
      state = SignUpState.success; // req is successful
    } on AuthException catch (e) {
      state = SignUpState.failed;
    } on SocketException catch (e) {
      state = SignUpState.failed;
    } catch (e) {
      state = SignUpState.failed;
    }
  }
}

// notifier provider
final signUpProvider = StateNotifierProvider<SignUpNotifier, SignUpState>(
  (ref) => SignUpNotifier(
    ref.watch(signUpUsecase),
  ),
);
