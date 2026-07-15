import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/web.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'auth_repository.g.dart';

@riverpod
AuthRepository authRepository(Ref ref) {
  return AuthRepository();
}

class AuthRepository {
  Logger log = Logger();
  final SupabaseClient supabase = Supabase.instance.client;

  Future<void> signUpNewUser(String email, String password) async {
    try {
      final AuthResponse res = await supabase.auth.signUp(
        email: email,
        password: password,
      );
      log.e('User signed up: ${res.user?.id}');
    } catch (e) {
      log.e('Error signing up: $e');
    }
  }

  Future<void> signInWithEmail(String email, String password) async {
    try {
      final AuthResponse res = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      log.e('User signed in: ${res.user?.id}');
    } catch (e) {
      log.e('Error signing in: $e');
    }
  }

  Future<void> signOut() async {
    try {
      await supabase.auth.signOut();
      log.e('User signed out');
    } catch (e) {
      log.e('Error signing out: $e');
    }
  }

  // Password reset steps1: Send a password reset email to the user
  Future<void> resetPassword(String email) async {
    try {
      await supabase.auth.resetPasswordForEmail(
        email,
        redirectTo: 'http://example.com/account/update-password',
      );
      log.e('Password reset email sent to $email');
    } catch (e) {
      log.e('Error sending password reset email: $e');
    }
  }

  // Password reset steps2: Update the user's password
  Future<void> updateUserPassword(String newPassword) async {
    try {
      final UserResponse res = await supabase.auth.updateUser(
        UserAttributes(password: newPassword),
      );
      log.e('User password updated: ${res.user?.id}');
    } catch (e) {
      log.e('Error updating user password: $e');
    }
  }
}
