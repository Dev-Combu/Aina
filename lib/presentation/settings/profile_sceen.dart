import 'package:aina/viewmodels/auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {

  void _logout() async {
    try {
      await ref.read(authViewmodelProvider.notifier).signOut();
      // 로그아웃 성공 시 처리
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('로그아웃 성공')),
      );
      Navigator.of(context).popUntil((route) => route.isFirst); // 첫 번째 화면으로 돌아가기
    } catch (e) {
      // 로그아웃 실패 시 처리
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('로그아웃 실패: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'User Profile',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  // Add your profile details here
                  const Text('Name: John Doe'),
                  const Text('Email:  '),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      _logout();
                    },
                    child: const Text('Logout'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
