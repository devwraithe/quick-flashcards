import 'dart:async';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utilities/constants/constants.dart';
import '../../core/utilities/constants/firebase_constants.dart';
import '../../core/utilities/errors/exceptions.dart';
import '../../core/utilities/errors/failure.dart';
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
      } else if (e.code == "network-request-failed") {
        throw ConnectionException(Constants.socketError);
      } else {
        throw ServerException(Constants.unknownError);
      }
    } on SocketException catch (_) {
      throw ConnectionException(Constants.socketError);
    } on TimeoutException catch (_) {
      throw ConnectionException(Constants.timeoutError);
    } catch (e) {
      throw ServerException(Constants.unknownError);
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
      print("ERROR: ${e.code}");
      if (e.code == 'user-not-found') {
        throw ServerException("No user found for this email");
      } else if (e.code == 'wrong-password') {
        throw ServerException("You have entered an incorrect password");
      } else if (e.code == 'invalid-email') {
        throw ServerException("You provided an invalid email address");
      } else if (e.code == "network-request-failed") {
        throw ConnectionException(Constants.socketError);
      }
    } on SocketException catch (e) {
      throw ConnectionException(Constants.socketError);
    } on TimeoutException catch (e) {
      throw ConnectionException(Constants.timeoutError);
    } catch (e) {
      throw ServerException(Constants.unknownError);
    }
  }

  @override
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(
        email: email,
      );
    } on FirebaseAuthException catch (e) {
      debugPrint("ServerException: $e");
      if (e.code == 'user-not-found') {
        throw ServerException("No user found for this email");
      } else if (e.code == 'invalid-email') {
        throw ServerException("You provided an invalid email address");
      }
    } on SocketException catch (_) {
      throw ConnectionException(Constants.socketError);
    } on TimeoutException catch (_) {
      throw ConnectionException(Constants.timeoutError);
    } catch (e) {
      throw ServerException(Constants.unknownError);
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _auth.signOut();
    } on FirebaseAuthException catch (e) {
      throw ServerException("No user found for this email");
    } on SocketException catch (e) {
      throw ConnectionException(Constants.socketError);
    } on TimeoutException catch (_) {
      throw ConnectionException(Constants.timeoutError);
    } catch (e) {
      throw ServerException(Constants.unknownError);
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
