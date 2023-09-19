import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/repository/auth_repository_impl.dart';
import '../../repositories/auth_repository.dart';

class LogoutUsecase {
  final AuthRepository _repo;
  LogoutUsecase(this._repo);

  Future<void> execute() async {
    return await _repo.logout();
  }
}

final logoutUsecaseProvider = Provider<LogoutUsecase>(
  (ref) => LogoutUsecase(
    ref.watch(authRepoProvider),
  ),
);
