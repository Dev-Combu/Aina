import 'package:aina/presentation/onboardings/social_provider.dart';
import 'package:aina/viewmodels/auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SigninScreen extends ConsumerStatefulWidget {
  const SigninScreen({super.key});

  @override
  ConsumerState<SigninScreen> createState() => _SigninScreenState();
  
}

class _SigninScreenState extends ConsumerState<SigninScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void _signIn() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    try {
      await ref.read(authViewmodelProvider.notifier).signIn(email, password);
      // 로그인 성공 시 처리
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('로그인 성공')),
      );
    } catch (e) {
      // 로그인 실패 시 처리
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('로그인 실패: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children:  [
              const SocialLoginButton(provider: SocialProvider.kakao),
              const SocialLoginButton(provider: SocialProvider.google),
              const SocialLoginButton(provider: SocialProvider.apple),
              Container(
                padding: EdgeInsets.all(16.0),
                child: TextField(
                  controller: emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                ),
              ),
              Container(
                padding: EdgeInsets.all(16.0),
                child: TextField(
                  controller: passwordController,
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  _signIn();
                },
                child: Text('Sign In'),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      // Navigate to the signup screen
                      context.push('/signup');
                    },
                    child: Text('Sign Up'),
                  ),
                  TextButton(
                    onPressed: () {
                      // Navigate to the password reset screen
                      context.go('/reset-password');
                    },
                    child: Text('Forgot Password?'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}