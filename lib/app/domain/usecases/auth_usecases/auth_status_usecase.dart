import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_flashcards/app/data/repository/auth_repository_impl.dart';

import '../../repositories/auth_repository.dart';

class CheckAuthStatusUsecase {
  final AuthRepository _repo;
  CheckAuthStatusUsecase(this._repo);

  Future<bool> execute() async {
    return await _repo.checkAuthStatus();
  }
}

final checkAuthProvider = Provider<CheckAuthStatusUsecase>(
  (ref) => CheckAuthStatusUsecase(
    ref.watch(authRepoProvider),
  ),
);
