import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/usecases/auth_usecases/sign_up_usecase.dart';

enum CreateAccountState { initial, loading, success, failed }

class CreateAccountNotifier extends StateNotifier<CreateAccountState> {
  final CreateAccountUsecase _createAccountUsecase;

  CreateAccountNotifier(this._createAccountUsecase)
      : super(CreateAccountState.initial);

  String? errorMessage;
  User? userResponse;

  Future<CreateAccountState> createAccount(Map<String, dynamic> data) async {
    state = CreateAccountState.loading;
    try {
      final result = await _createAccountUsecase.execute(data);
      result.fold((failure) {
        state = CreateAccountState.failed;
        errorMessage = failure.message;
        return state;
      }, (user) {
        state = CreateAccountState.success;
        userResponse = user;
        return state;
      });
      return state;
    } catch (e) {
      state = CreateAccountState.failed;
      errorMessage = e.toString();
      return state;
    }
  }
}

final createAccountProvider = StateNotifierProvider.family<
    CreateAccountNotifier, CreateAccountState, Map<String, dynamic>>(
  (ref, data) {
    final notifier = CreateAccountNotifier(
      ref.watch(createAccountUsecaseProvider),
    );
    notifier.createAccount(data);
    return notifier;
  },
);
