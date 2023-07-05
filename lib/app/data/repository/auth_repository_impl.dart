import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_flashcards/app/core/constants/firebase_constants.dart';

import '../../core/constants/string_constants.dart';
import '../../core/errors/exceptions.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _auth;

  const AuthRepositoryImpl(this._auth);

  @override
  Future<User?> signUp(String email, String password) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      debugPrint("AuthException: $e");
      if (e.code == 'email-already-in-use') {
        throw AuthException("Account already exists for this email");
      } else if (e.code == 'weak-password') {
        throw AuthException("Password should be greater than 6 characters");
      } else if (e.code == 'invalid-email') {
        throw AuthException("You provided an invalid email address");
      }
    } on SocketException catch (e) {
      debugPrint("SocketException: $e");
      throw ConnectionException(StringConstants.socketError);
    } catch (e) {
      debugPrint("Error creating account: $e");
      throw AuthException(StringConstants.unknownError);
    }
    return null;
  }

  @override
  Future<void> signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      debugPrint("AuthException: $e");
      if (e.code == 'user-not-found') {
        throw AuthException("No user found for this email");
      } else if (e.code == 'wrong-password') {
        throw AuthException("You have entered an incorrect password");
      } else if (e.code == 'invalid-email') {
        throw AuthException("You provided an invalid email address");
      }
    } on SocketException catch (e) {
      debugPrint("SocketException: $e");
      throw ConnectionException(StringConstants.socketError);
    } catch (e) {
      debugPrint("Error signing in: $e");
      throw AuthException(StringConstants.unknownError);
    }
  }

  @override
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      debugPrint("AuthException: $e");
      if (e.code == 'user-not-found') {
        throw AuthException("No user found for this email");
      } else if (e.code == 'invalid-email') {
        throw AuthException("You provided an invalid email address");
      }
    } on SocketException catch (e) {
      debugPrint("SocketException: $e");
      throw ConnectionException(StringConstants.socketError);
    } catch (e) {
      debugPrint("Error resetting password: $e");
      throw AuthException(StringConstants.unknownError);
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } on FirebaseAuthException catch (e) {
      debugPrint("AuthException: $e");
      throw AuthException("No user found for this email");
    } on SocketException catch (e) {
      debugPrint("SocketException: $e");
      throw ConnectionException(StringConstants.socketError);
    } catch (e) {
      debugPrint("Error signing out: $e");
      throw AuthException(StringConstants.unknownError);
    }
  }

  @override
  Future<bool> checkAuthStatus() async {
    final User? user = _auth.currentUser;
    return user != null;
  }
}

// repo impl provider
final authRepoProvider = Provider<AuthRepositoryImpl>(
  (ref) {
    return AuthRepositoryImpl(FirebaseConstants.firebaseAuth);
  },
);