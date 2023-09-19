import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/repository/auth_repository_impl.dart';
import '../../repositories/auth_repository.dart';

class LoginUsecase {
  final AuthRepository _repository;
  LoginUsecase(this._repository);

  Future<void> execute(Map<String, dynamic> data) async {
    return await _repository.login(data);
  }
}

final loginUsecaseProvider = Provider<LoginUsecase>(
  (ref) => LoginUsecase(
    ref.watch(authRepoProvider),
  ),
);
