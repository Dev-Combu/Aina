import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 1. 이제 Scaffold가 직접 따뜻한 베이지 배경색을 가집니다.
      backgroundColor: const Color(0xFFF9F6F0), 
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        toolbarHeight: 70,
        title: Container(
          width: 120,
          height: 48, // 너무 크지 않게 살짝 다듬었어요
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.85), // 반투명한 흰색으로 깔끔하게
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04), // 은은한 그림자
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Text(
            '나의 마음 나무',
            style: TextStyle(
              color: Color(0xFF2A2A2A),
              fontWeight: FontWeight.bold,
              fontSize: 16,
              letterSpacing: -0.5,
            ),
          ),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 20.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 100), // 앱 바 아래 패딩

                  // AI Tree 영역
                  Center(
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F0E5),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.eco_rounded,
                        size: 100,
                        color: Color(0xFF86B082),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),

                  // 2. 글래스 효과를 걷어낸 포근한 작성 유도 카드
                  GestureDetector(
                    onTap: () {
                      context.push('/diary/write');
                    },
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 16,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFF0EC),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: const Icon(
                              Icons.edit_note_rounded,
                              color: Color(0xFFE5A496),
                            ),
                          ),
                          const SizedBox(width: 16),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '오늘 하루는 어땠나요?',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF4A4A4A),
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  '일기를 작성해보세요',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF9E9E9E),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(
                            Icons.chevron_right_rounded,
                            color: Color(0xFFD4D4D4),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  const Text(
                    '최근 기록',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4A4A4A),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),

          // 3. 최근 기록 리스트 (소프트 섀도우 카드 스타일 적용)
          SliverPadding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
            ).copyWith(bottom: 120),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                return _buildDiaryCard(
                  date: '5월 ${10 - index}일',
                  preview: '오늘 하루는 참 따뜻했다. 길을 걷다 예쁜 꽃을 발견해서 기분이 좋았다.',
                  emotionIcon: index % 2 == 0
                      ? Icons.sentiment_very_satisfied
                      : Icons.sentiment_satisfied,
                  emotionColor: index % 2 == 0
                      ? const Color(0xFFFFD54F)
                      : const Color(0xFF81C784),
                );
              }, childCount: 3),
            ),
          ),
        ],
      ),
    );
  }

  // 부드러운 그림자가 적용된 기본 컨테이너 카드
  Widget _buildDiaryCard({
    required String date,
    required String preview,
    required IconData emotionIcon,
    required Color emotionColor,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04), // 튀지 않는 아주 연한 그림자
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  date,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF8A8A8A),
                  ),
                ),
                Icon(emotionIcon, color: emotionColor, size: 20),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              preview,
              style: const TextStyle(
                fontSize: 15,
                color: Color(0xFF4A4A4A),
                height: 1.5,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}