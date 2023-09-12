import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/repository/auth_repository_impl.dart';
import '../../repositories/auth_repository.dart';

class SignOutUsecase {
  final AuthRepository _repo;
  SignOutUsecase(this._repo);

  Future<void> execute() async {
    return await _repo.signOut();
  }
}

final signOutUsecaseProvider = Provider<SignOutUsecase>(
  (ref) => SignOutUsecase(
    ref.watch(authRepoProvider),
  ),
);
