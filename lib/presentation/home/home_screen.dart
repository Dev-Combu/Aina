import 'package:aina/presentation/home/CRUD/diary_sceen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:aina/data/models/diary.dart';
import 'package:aina/viewmodels/diary_viewmodel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        // DiaryViewmodel을 구독하여 실제 데이터를 가져옵니다.
        final diaryState = ref.watch(diaryViewmodelProvider);

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

                      // 작성 유도 카드
                      GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled:
                                true,
                            backgroundColor: Colors
                                .transparent,
                            builder: (context) {
                              return const DiaryScreen(isWriting: true);
                            },
                          );
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

              // 최근 기록 리스트 — DiaryViewmodel의 실제 데이터와 연결
              diaryState.when(
                // ✅ 데이터 로드 성공
                data: (diaries) {
                  if (diaries.isEmpty) {
                    return SliverToBoxAdapter(
                      child: Padding(
                        // 💡 불필요한 큰 bottom 패딩 제거
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Container(
                          padding: const EdgeInsets.all(32),
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
                          child: const Column(
                            children: [
                              Icon(
                                Icons.auto_stories_rounded,
                                size: 48,
                                color: Color(0xFFD4D4D4),
                              ),
                              SizedBox(height: 16),
                              Text(
                                '아직 작성된 일기가 없어요',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF9E9E9E),
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                '위 카드를 눌러 첫 일기를 적어보세요!',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFFBDBDBD),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                  return SliverPadding(
                    // 💡 불필요한 큰 bottom 패딩 제거
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final diary = diaries[index];
                        return InkWell(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (context) {
                                return DiaryScreen(
                                  content: diary.content,
                                  date: diary.createdAt,
                                  diaryId: diary.id,
                                );
                              },
                            );
                          },
                          child: _buildDiaryCard(
                            date: _formatDate(diary.createdAt),
                            preview: diary.content,
                          ),
                        );
                      }, childCount: diaries.length),
                    ),
                  );
                },
                // ⏳ 로딩 중
                loading: () {
                  return const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.only(top: 40),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF86B082),
                          strokeWidth: 2.5,
                        ),
                      ),
                    ),
                  );
                },
                // ❌ 에러 발생
                error: (error, stackTrace) {
                  return SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Container(
                        padding: const EdgeInsets.all(24),
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
                        child: Column(
                          children: [
                            const Icon(
                              Icons.error_outline_rounded,
                              size: 48,
                              color: Color(0xFFE5A496),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              '기록을 불러오지 못했어요',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF4A4A4A),
                              ),
                            ),
                            const SizedBox(height: 12),
                            GestureDetector(
                              onTap: () =>
                                  ref.invalidate(diaryViewmodelProvider),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF0F7EE),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Text(
                                  '다시 시도',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF86B082),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),

              // 🛠️ 핵심 수정 사항: 하단 탭바에 가려지지 않도록 빈 공간(스크롤 여백) 제공
              // 탭바의 높이에 맞춰 height 값을 조절해 주세요. (기본 탭바는 보통 80~100 정도면 충분합니다)
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),
        );
      },
    );
  }

  /// DateTime을 "X월 Y일" 형식으로 포맷
  String _formatDate(DateTime date) {
    return '${date.month}월 ${date.day}일';
  }

  // 부드러운 그림자가 적용된 기본 컨테이너 카드
  Widget _buildDiaryCard({required String date, required String preview}) {
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
                const Icon(
                  Icons.bookmark_border_rounded,
                  color: Color(0xFFD4D4D4),
                  size: 20,
                ),
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
