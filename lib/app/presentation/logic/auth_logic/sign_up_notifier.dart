import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/exceptions.dart';
import '../../../domain/usecases/auth_usecases/sign_up_usecase.dart';

enum SignUpState { initial, loading, success, failed }

class SignUpNotifier extends StateNotifier<SignUpState> {
  final SignUpUsecase _usecase;

  SignUpNotifier(this._usecase) : super(SignUpState.initial);

  Future<String?> signUp(String email, String password) async {
    state = SignUpState.loading; // begin the loading
    try {
      await _usecase.execute(email, password); // handle the req
      state = SignUpState.success; // req is successful
      return null.toString();
    } on AuthException catch (e) {
      debugPrint("[CUBIT AUTH ERROR] ${e.message}");
      state = SignUpState.failed;
      return e.message;
    } on SocketException catch (e) {
      debugPrint("[CUBIT SOCKET ERROR] ${e.message}");
      state = SignUpState.failed;
      return e.message;
    } catch (e) {
      debugPrint("[CUBIT UNKNOWN ERROR] ${e.toString()}");
      state = SignUpState.failed;
      return e.toString();
    }
  }
}

// notifier provider
final signUpProvider = StateNotifierProvider<SignUpNotifier, SignUpState>(
  (ref) => SignUpNotifier(
    ref.watch(signUpUsecase),
  ),
);
