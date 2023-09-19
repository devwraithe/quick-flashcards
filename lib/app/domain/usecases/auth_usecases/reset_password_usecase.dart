import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_flashcards/app/data/repository/auth_repository_impl.dart';

import '../../repositories/auth_repository.dart';

class ResetPasswordUsecase {
  final AuthRepository _repository;
  ResetPasswordUsecase(this._repository);

  Future<void> execute(String email) async {
    return await _repository.resetPassword(email);
  }
}

final resetPasswordUsecaseProvider = Provider<ResetPasswordUsecase>(
  (ref) => ResetPasswordUsecase(
    ref.watch(
      authRepoProvider,
    ),
  ),
);
