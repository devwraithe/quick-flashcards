import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/repository/auth_repository_impl.dart';

class SignInUsecase {
  final AuthRepositoryImpl _repo;
  SignInUsecase(this._repo);

  Future<void> execute(String email, String password) async {
    return await _repo.signIn(email, password);
  }
}

// usecase provider
final signInUsecase = Provider<SignInUsecase>(
  (ref) => SignInUsecase(
    ref.watch(authRepoProvider),
  ),
);
