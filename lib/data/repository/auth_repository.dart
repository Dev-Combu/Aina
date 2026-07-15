import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:aina/main.dart';

part 'auth_repository.g.dart';

@riverpod
AuthRepository authRepository(Ref ref) {
  return AuthRepository();
}

class AuthRepository {
  Future<Object> signInWithEmail(String email, String password) async {
    try {
      final response = await client.emailIdp.login(
        email: email,
        password: password,
      );

      return response;
    } catch (e) {
      print(e);
      return false;
    } 
  }
  

  Future<Object> signUpWithEmail(String email, String password) async {
    try {
      final accountRequestId = await client.emailIdp.startRegistration(
        email: email,
      );
      final registrationToken = await client.emailIdp.verifyRegistrationCode(
        accountRequestId: accountRequestId,
        verificationCode: code,
      );

      final authSuccess = await client.emailIdp.finishRegistration(
        registrationToken: registrationToken,
        password: password,
      );
      
    } catch (e) {
      print(e);
      return false;
    }
  }
}