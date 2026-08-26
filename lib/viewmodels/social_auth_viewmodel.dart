import 'package:aina/data/repository/social_auth_repository.dart';
import 'package:aina/presentation/onboardings/social_provider.dart'; // SocialProvider 위치
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'social_auth_viewmodel.g.dart';

@riverpod
class SocialAuthViewmodel extends _$SocialAuthViewmodel {
  @override
  FutureOr<void> build() {
    // 초기화 상태 (필요 시 작성)
  }

  /// 카카오, 구글, 애플 통합 소셜 로그인 메서드
  Future<void> signInWithSocial(SocialProvider provider) async {
    state = const AsyncLoading();
    
    state = await AsyncValue.guard(() async {
      final repository = ref.read(socialAuthRepositoryProvider);

      switch (provider) {
        case SocialProvider.kakao:
          await repository.signInWithKakao();
          break;
        case SocialProvider.google:
          await repository.signInWithGoogle();
          break;
        case SocialProvider.apple:
          await repository.signInWithApple();
          break;
      }
    });

    if (state.hasError) {
      // 에러 로그 출력
      print('Error signing in with ${provider.name}: ${state.error}');
    }
  }
}