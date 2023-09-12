import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../core/errors/failure.dart';

abstract class AuthRepository {
  Future<Either<Failure, User?>> createAccountRepo(Map<String, dynamic> data);
  Future<void> signIn(String email, String password);
  Future<void> resetPassword(String email);
  Future<bool> checkAuthStatus();
  Future<void> signOut();
}
