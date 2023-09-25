import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/usecases/auth_usecases/signout_usecase.dart';

enum LogoutState { initial, loading, success, failed }

class LogoutNotifier extends StateNotifier<LogoutState> {
  final LogoutUsecase _usecase;
  LogoutNotifier(this._usecase) : super(LogoutState.initial);

  String? error;

  Future<LogoutState> signOut() async {
    state = LogoutState.loading;
    try {
      await _usecase.execute();
      state = LogoutState.success;
      return state;
    } catch (e) {
      state = LogoutState.failed;
      error = e.toString();
      return state;
    }
  }
}

final logoutProvider = StateNotifierProvider<LogoutNotifier, LogoutState>(
  (ref) => LogoutNotifier(
    ref.watch(logoutUsecaseProvider),
  ),
);
