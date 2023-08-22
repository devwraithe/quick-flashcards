import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_flashcards/app/core/errors/failure.dart';

import '../../../data/repository/auth_repository_impl.dart';
import '../../repositories/auth_repository.dart';

class CreateAccountUsecase {
  final AuthRepository _repository;
  CreateAccountUsecase(this._repository);

  Future<Either<Failure, User?>> execute(Map<String, dynamic> data) async {
    final response = await _repository.createAccountRepo(data);
    return response.fold(
      (failure) => Left(failure),
      (user) => Right(user),
    );
  }
}

final createAccountUsecaseProvider = Provider<CreateAccountUsecase>(
  (ref) => CreateAccountUsecase(
    ref.watch(authRepoProvider),
  ),
);
