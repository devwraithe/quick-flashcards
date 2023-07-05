import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRepository {
  Future<User?> signUp(String email, String password);
  Future<void> signIn(String email, String password);
  Future<void> resetPassword(String email);
  Future<bool> checkAuthStatus();
  Future<void> signOut();
}
