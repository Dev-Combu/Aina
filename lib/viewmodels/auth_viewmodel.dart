import 'package:aina/data/repository/auth_repository.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_viewmodel.g.dart';

@riverpod
class AuthViewmodel extends _$AuthViewmodel {
  Logger logger = Logger();

  @override
  FutureOr<void> build() async {}

  Future<void> signUp(String email, String password) async {
    // 1. UI에 로딩 상태를 알림 (스피너 표시용)
    state = const AsyncLoading();

    // 2. AsyncValue.guard가 내부적으로 try-catch를 돌고 결과를 state에 반영해 줍니다.
    state = await AsyncValue.guard(() async {
      final authRepository = ref.read(authRepositoryProvider);
      await authRepository.signUpNewUser(email, password);

      logger.i('User signed up: $email'); // 💡 수정: 성공은 Info 로그로
    });

    // 만약 에러가 발생했다면 AsyncValue.guard가 알아서 state를 AsyncError로 만들어 줍니다.
    if (state.hasError) {
      logger.i('Error signing up: ${state.error}');
    }
  }

  Future<void> signIn(String email, String password) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final authRepository = ref.read(authRepositoryProvider);
      await authRepository.signInWithEmail(email, password);
      logger.i('User signed in: $email');
    });

    if (state.hasError) {
      logger.i('Error signing in: ${state.error}');
    }
  }

  Future<void> signOut() async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final authRepository = ref.read(authRepositoryProvider);
      await authRepository.signOut();
      logger.i('User signed out');
    });

    // 만약 에러가 발생했다면 AsyncValue.guard가 알아서 state를 AsyncError로 만들어 줍니다.
    if (state.hasError) {
      logger.i('Error signing out: ${state.error}');
    }
  }

  Future<void> resetPassword(String email) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final authRepository = ref.read(authRepositoryProvider);
      await authRepository.resetPassword(email);
      logger.i('Password reset email sent to $email');
    });
    if (state.hasError) {
      logger.i('Error resetting password: ${state.error}');
    }
  }
}
