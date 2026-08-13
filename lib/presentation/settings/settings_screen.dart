import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F6F0), // Warm beige
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            floating: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            scrolledUnderElevation: 0,
            centerTitle: false,
            title: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  color: Colors.white.withOpacity(0.5),
                  child: const Text(
                    '설정',
                    style: TextStyle(
                      color: Color(0xFF4A4A4A),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(24.0).copyWith(bottom: 160),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Profile Section
                InkWell(
                  onTap: () {
                    context.push('/profile'); // Navigate to the profile screen
                  },
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.03),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: const Color(
                            0xFFE8F0E5,
                          ), // Soft pastel green
                          child: const Icon(
                            Icons.person_rounded,
                            size: 36,
                            color: Color(0xFF86B082),
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '사용자 님',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF4A4A4A),
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                '소중한 기록이 자라나고 있어요 🌱',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF8A8A8A),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                _buildSectionTitle('앱 설정'),
                _buildSettingsCard([
                  _buildListTile(
                    icon: Icons.notifications_none_rounded,
                    iconColor: const Color(0xFFE5A496),
                    title: '알림 설정',
                    onTap: () {},
                  ),
                  _buildDivider(),
                  _buildListTile(
                    icon: Icons.lock_outline_rounded,
                    iconColor: const Color(0xFF81C784),
                    title: '앱 잠금 (Face ID / 비밀번호)',
                    onTap: () {},
                  ),
                  _buildDivider(),
                  _buildListTile(
                    icon: Icons.palette_outlined,
                    iconColor: const Color(0xFF9FA8DA),
                    title: '테마 설정',
                    trailing: const Text(
                      '따뜻한 파스텔',
                      style: TextStyle(color: Color(0xFF8A8A8A), fontSize: 14),
                    ),
                    onTap: () {},
                  ),
                ]),

                const SizedBox(height: 24),
                _buildSectionTitle('계정 및 지원'),
                _buildSettingsCard([
                  _buildListTile(
                    icon: Icons.cloud_done_outlined,
                    iconColor: const Color(0xFF64B5F6),
                    title: '데이터 백업 및 복원',
                    onTap: () {},
                  ),
                  _buildDivider(),
                  _buildListTile(
                    icon: Icons.help_outline_rounded,
                    iconColor: const Color(0xFFFFB74D),
                    title: '문의하기',
                    onTap: () {},
                  ),
                  _buildDivider(),
                  _buildListTile(
                    icon: Icons.info_outline_rounded,
                    iconColor: const Color(0xFFBCAAA4),
                    title: '앱 정보',
                    trailing: const Text(
                      'v1.0.0',
                      style: TextStyle(color: Color(0xFF8A8A8A), fontSize: 14),
                    ),
                    onTap: () {},
                  ),
                ]),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, bottom: 12.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: Color(0xFF8A8A8A),
        ),
      ),
    );
  }

  Widget _buildSettingsCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    Widget? trailing,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: iconColor.withOpacity(0.15),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: iconColor, size: 22),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          color: Color(0xFF4A4A4A),
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing:
          trailing ??
          const Icon(Icons.chevron_right_rounded, color: Color(0xFFD4D4D4)),
      onTap: onTap,
    );
  }

  Widget _buildDivider() {
    return const Divider(
      height: 1,
      thickness: 1,
      indent: 60,
      endIndent: 20,
      color: Color(0xFFF0F0F0),
    );
  }
}
