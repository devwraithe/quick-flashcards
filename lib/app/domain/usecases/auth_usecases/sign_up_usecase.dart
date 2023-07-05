import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/repository/auth_repository_impl.dart';

class SignUpUsecase {
  final AuthRepositoryImpl _repo;
  SignUpUsecase(this._repo);

  Future<User?> execute(String email, String password) async {
    return await _repo.signUp(email, password);
  }
}

// usecase provider
final signUpUsecase = Provider<SignUpUsecase>(
  (ref) => SignUpUsecase(
    ref.watch(authRepoProvider),
  ),
);
