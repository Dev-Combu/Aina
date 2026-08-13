import 'package:aina/presentation/onboardings/social_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
      redirectTo: kIsWeb ? null : 'aina://login-callback', // Optionally set the redirect link to bring back the user via deeplink.
      authScreenLaunchMode:
          kIsWeb ? LaunchMode.platformDefault : LaunchMode.externalApplication, // Launch the auth screen in a new webview on mobile.
    );
  }
  //GOOGLE
    Future<void> signInWithGoogle() async {
    await _client.auth.signInWithOAuth(
      OAuthProvider.google,
      redirectTo: kIsWeb ? null : 'aina://login-callback', // Optionally set the redirect link to bring back the user via deeplink.
      authScreenLaunchMode:
          kIsWeb ? LaunchMode.platformDefault : LaunchMode.externalApplication, // Launch the auth screen in a new webview on mobile.
    );
  }
  
  //APPLE
    Future<void> signInWithApple() async {
    await _client.auth.signInWithOAuth(
      OAuthProvider.apple,
      redirectTo: kIsWeb ? null : 'aina://login-callback', // Optionally set the redirect link to bring back the user via deeplink.
      authScreenLaunchMode:
          kIsWeb ? LaunchMode.platformDefault : LaunchMode.externalApplication, // Launch the auth screen in a new webview on mobile.
    );
  }
}