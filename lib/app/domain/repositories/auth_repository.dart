import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../core/errors/failure.dart';

abstract class AuthRepository {
  Future<Either<Failure, User?>> register(Map<String, dynamic> data);
  Future<void> login(Map<String, dynamic> data);
  Future<void> resetPassword(String email);
  Future<void> logout();
  Future<bool> checkAuthStatus();
}
