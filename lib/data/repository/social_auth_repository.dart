import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:crypto/crypto.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

part 'social_auth_repository.g.dart';

@riverpod
SocialAuthRepository socialAuthRepository(Ref ref) {
  // 1. [수정] Ref 파라미터 필수!
  return SocialAuthRepository(Supabase.instance.client);
}

class SocialAuthRepository {
  SocialAuthRepository(this._client);
  final SupabaseClient _client;

  //KAKAO
  Future<void> signInWithKakao() async {
    await _client.auth.signInWithOAuth(
      OAuthProvider.kakao,
      redirectTo: kIsWeb
          ? null
          : 'aina://login-callback', // Optionally set the redirect link to bring back the user via deeplink.
      authScreenLaunchMode: kIsWeb
          ? LaunchMode.platformDefault
          : LaunchMode
                .externalApplication, // Launch the auth screen in a new webview on mobile.
    );
  }

  //GOOGLE
  Future<void> signInWithGoogle() async {
    await _client.auth.signInWithOAuth(
      OAuthProvider.google,
      redirectTo: kIsWeb
          ? null
          : 'aina://login-callback', // Optionally set the redirect link to bring back the user via deeplink.
      authScreenLaunchMode: kIsWeb
          ? LaunchMode.platformDefault
          : LaunchMode
                .externalApplication, // Launch the auth screen in a new webview on mobile.
    );
  }

  // Performs Apple sign in on iOS or macOS
 Future<AuthResponse> signInWithApple() async {
  try {
    final rawNonce = _client.auth.generateRawNonce();
    final hashedNonce =
        sha256.convert(utf8.encode(rawNonce)).toString();

    print('1. Apple 로그인 시작');

    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: hashedNonce,
    );

    print('2. Apple credential 획득');
    print('email: ${credential.email}');
    print('givenName: ${credential.givenName}');
    print('familyName: ${credential.familyName}');
    print('identityToken 존재: ${credential.identityToken != null}');

    final idToken = credential.identityToken;

    if (idToken == null) {
      throw const AuthException(
        'Could not find ID Token from generated credential.',
      );
    }

    print('3. Supabase 로그인 시작');

    final authResponse = await _client.auth.signInWithIdToken(
      provider: OAuthProvider.apple,
      idToken: idToken,
      nonce: rawNonce,
    );

    print('4. Supabase 로그인 성공');
    print('user: ${authResponse.user?.id}');

    if (credential.givenName != null ||
        credential.familyName != null) {
      final nameParts = <String>[];

      if (credential.givenName != null) {
        nameParts.add(credential.givenName!);
      }

      if (credential.familyName != null) {
        nameParts.add(credential.familyName!);
      }

      final fullName = nameParts.join(' ');

      await _client.auth.updateUser(
        UserAttributes(
          data: {
            'full_name': fullName,
            'given_name': credential.givenName,
            'family_name': credential.familyName,
          },
        ),
      );

      print('5. 이름 저장 성공');
    }

    return authResponse;
  } catch (e, stack) {
    print('Apple 로그인 실패: $e');
    print(stack);
    rethrow;
  }
}}
