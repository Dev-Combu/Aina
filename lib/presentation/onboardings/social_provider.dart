import 'package:aina/viewmodels/social_auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

enum SocialProvider { kakao, google, apple }

extension SocialProviderX on SocialProvider {
  String get label {
    switch (this) {
      case SocialProvider.kakao:
        return '카카오로 시작하기';
      case SocialProvider.google:
        return 'Google로 시작하기';
      case SocialProvider.apple:
        return 'Apple로 시작하기';
    }
  }

  Color get backgroundColor {
    switch (this) {
      case SocialProvider.kakao:
        return const Color(0xFFFEE500);
      case SocialProvider.google:
        return Colors.white;
      case SocialProvider.apple:
        return Colors.black;
    }
  }

  Color get textColor {
    switch (this) {
      case SocialProvider.kakao:
      case SocialProvider.google:
        return const Color(0xFF191919);
      case SocialProvider.apple:
        return Colors.white;
    }
  }

  Color? get borderColor {
    switch (this) {
      case SocialProvider.google:
        return const Color(0xFFE0E0E0);
      default:
        return null;
    }
  }

  IconData get defaultIcon {
    switch (this) {
      case SocialProvider.kakao:
        return Icons.chat_bubble;
      case SocialProvider.google:
        return Icons.g_mobiledata_rounded;
      case SocialProvider.apple:
        return Icons.apple;
    }
  }

  OAuthProvider get supabaseProvider {
    switch (this) {
      case SocialProvider.kakao:
        return OAuthProvider.kakao;
      case SocialProvider.google:
        return OAuthProvider.google;
      case SocialProvider.apple:
        return OAuthProvider.apple;
    }
  }
}

class SocialLoginButton extends ConsumerStatefulWidget {
  final SocialProvider provider;
  final VoidCallback? onSuccess;
  final Function(Object error)? onError;

  const SocialLoginButton({
    super.key,
    required this.provider,
    this.onSuccess,
    this.onError,
  });

  @override
  ConsumerState<SocialLoginButton> createState() => _SocialLoginButtonState();
}

class _SocialLoginButtonState extends ConsumerState<SocialLoginButton> {
  bool _isLoading = false;

  Future<void> _handleSocialLogin() async {
    setState(() => _isLoading = true);
    try {
      // 💡 ViewModel의 signInWithSocial 메서드 호출 (카카오, 구글, 애플 자동 매핑)
      await ref
          .read(socialAuthViewmodelProvider.notifier)
          .signInWithSocial(widget.provider);

      if (!mounted) return;

      final state = ref.read(socialAuthViewmodelProvider);

      if (state.hasError) {
        widget.onError?.call(state.error!);
      } else {
        widget.onSuccess?.call();
      }
    } catch (error) {
      if (mounted) {
        widget.onError?.call(error);
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = widget.provider;

    return Container(
      width: double.infinity,
      height: 52,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Material(
        color: provider.backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: provider.borderColor != null
              ? BorderSide(color: provider.borderColor!)
              : BorderSide.none,
        ),
        child: InkWell(
          onTap: _isLoading ? null : _handleSocialLogin,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_isLoading)
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        provider.textColor,
                      ),
                    ),
                  )
                else ...[
                  Icon(
                    provider.defaultIcon,
                    color: provider.textColor,
                    size: provider == SocialProvider.google ? 28 : 22,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    provider.label,
                    style: TextStyle(
                      color: provider.textColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}