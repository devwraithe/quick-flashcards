import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/repository/auth_repository_impl.dart';
import '../../repositories/auth_repository.dart';

class LoginUsecase {
  final AuthRepository _repo;
  LoginUsecase(this._repo);

  Future<void> execute(Map<String, dynamic> data) async {
    return await _repo.login(data);
  }
}

final loginUsecaseProvider = Provider<LoginUsecase>(
  (ref) => LoginUsecase(
    ref.watch(authRepoProvider),
  ),
);
