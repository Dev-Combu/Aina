import 'package:aina/viewmodels/auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void _signUp() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    try {
      await ref.read(authViewmodelProvider.notifier).signUp(email, password);
      // 회원가입 성공 시 처리
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('회원가입 성공')),
      );
      context.pop(); // 회원가입 성공 후 이전 화면으로 돌아가기
    } catch (e) {
      // 회원가입 실패 시 처리
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('회원가입 실패: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Signup'),
        
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _signUp();
              },
              child: const Text('Sign Up'),
            ),
            ElevatedButton(
              onPressed: () {
                // Navigate back to the signin screen
                context.go('/login');
              },
              child: const Text('Back to Signin'),
            ),
          ],
        ),
      ),
    );
  }
}