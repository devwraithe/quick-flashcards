import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/exceptions.dart';
import '../../../domain/usecases/auth_usecases/sign_in_usecase.dart';

enum SignInState { initial, loading, success, failed }

class SignInNotifier extends StateNotifier<SignInState> {
  final SignInUsecase _usecase;

  SignInNotifier(this._usecase) : super(SignInState.initial);

  Future<String?> signIn(String email, String password) async {
    state = SignInState.loading; // begin the loading
    try {
      await _usecase.execute(email, password); // handle the req
      state = SignInState.success; // req is successful
      return null.toString();
    } on AuthException catch (e) {
      debugPrint("[CUBIT AUTH ERROR] ${e.message}");
      state = SignInState.failed;
      return e.message;
    } on SocketException catch (e) {
      debugPrint("[CUBIT SOCKET ERROR] ${e.message}");
      state = SignInState.failed;
      return e.message;
    } catch (e) {
      debugPrint("[CUBIT UNKNOWN ERROR] ${e.toString()}");
      state = SignInState.failed;
      return e.toString();
    }
  }
}

// notifier provider
final signInProvider = StateNotifierProvider<SignInNotifier, SignInState>(
  (ref) => SignInNotifier(
    ref.watch(signInUsecase),
  ),
);
