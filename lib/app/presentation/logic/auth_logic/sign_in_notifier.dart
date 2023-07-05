import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/exceptions.dart';
import '../../../domain/usecases/auth_usecases/sign_in_usecase.dart';

enum SignInState { initial, loading, success, failed }

class SignInNotifier extends StateNotifier<SignInState> {
  final SignInUsecase _usecase;

  SignInNotifier(this._usecase) : super(SignInState.initial);

  Future<void> signIn(String email, String password) async {
    state = SignInState.loading; // begin the loading
    try {
      await _usecase.execute(email, password); // handle the req
      state = SignInState.success; // req is successful
    } on AuthException catch (e) {
      debugPrint(e.message);
      state = SignInState.failed;
    } on SocketException catch (e) {
      state = SignInState.failed;
    } catch (e) {
      state = SignInState.failed;
    }
  }
}

// notifier provider
final signInProvider = StateNotifierProvider<SignInNotifier, SignInState>(
  (ref) => SignInNotifier(
    ref.watch(signInUsecase),
  ),
);
