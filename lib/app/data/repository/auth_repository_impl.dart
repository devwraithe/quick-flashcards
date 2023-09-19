import 'dart:async';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_flashcards/app/core/constants/firebase_constants.dart';

import '../../core/constants/string_constants.dart';
import '../../core/errors/exceptions.dart';
import '../../core/errors/failure.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _auth;

  const AuthRepositoryImpl(this._auth);

  @override
  Future<Either<Failure, User?>> register(
    Map<String, dynamic> data,
  ) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: data['email'],
        password: data['password'],
      );
      return Right(userCredential.user);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        throw ServerException("Account already exists for this email");
      } else if (e.code == 'weak-password') {
        throw ServerException("Password must be more than 6 characters");
      } else if (e.code == 'invalid-email') {
        throw ServerException("An invalid email address was provided");
      } else {
        throw ServerException(StringConstants.unknownError);
      }
    } on SocketException catch (_) {
      throw ConnectionException(StringConstants.socketError);
    } on TimeoutException catch (_) {
      throw ConnectionException(StringConstants.timeoutError);
    } catch (e) {
      throw ServerException(StringConstants.unknownError);
    }
  }

  @override
  Future<void> login(Map<String, dynamic> data) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: data['email'],
        password: data['password'],
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw AuthException("No user found for this email");
      } else if (e.code == 'wrong-password') {
        throw AuthException("You have entered an incorrect password");
      } else if (e.code == 'invalid-email') {
        throw AuthException("You provided an invalid email address");
      }
    } on SocketException catch (e) {
      throw ConnectionException(StringConstants.socketError);
    } on TimeoutException catch (_) {
      throw ConnectionException(StringConstants.timeoutError);
    } catch (e) {
      throw AuthException(StringConstants.unknownError);
    }
  }

  @override
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(
        email: email,
      );
    } on FirebaseAuthException catch (e) {
      debugPrint("AuthException: $e");
      if (e.code == 'user-not-found') {
        throw AuthException("No user found for this email");
      } else if (e.code == 'invalid-email') {
        throw AuthException("You provided an invalid email address");
      }
    } on SocketException catch (_) {
      throw ConnectionException(StringConstants.socketError);
    } on TimeoutException catch (_) {
      throw ConnectionException(StringConstants.timeoutError);
    } catch (e) {
      throw AuthException(StringConstants.unknownError);
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _auth.signOut();
    } on FirebaseAuthException catch (e) {
      throw AuthException("No user found for this email");
    } on SocketException catch (e) {
      throw ConnectionException(StringConstants.socketError);
    } on TimeoutException catch (_) {
      throw ConnectionException(StringConstants.timeoutError);
    } catch (e) {
      throw AuthException(StringConstants.unknownError);
    }
  }

  @override
  Future<bool> checkAuthStatus() async {
    final User? user = _auth.currentUser;
    return user != null;
  }
}

// Authentication Repository Provider
final authRepoProvider = Provider<AuthRepository>(
  (ref) {
    return AuthRepositoryImpl(
      FirebaseConstants.firebaseAuth,
    );
  },
);
