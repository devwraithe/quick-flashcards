import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_flashcards/app/data/repository/auth_repository_impl.dart';

import '../../repositories/auth_repository.dart';

class ResetPasswordUsecase {
  final AuthRepository _repo;
  ResetPasswordUsecase(this._repo);

  Future<void> execute(String email) async {
    return await _repo.resetPassword(email);
  }
}

// usecase provider
final resetPasswordUsecase = Provider<ResetPasswordUsecase>(
  (ref) => ResetPasswordUsecase(
    ref.watch(authRepoProvider),
  ),
);
