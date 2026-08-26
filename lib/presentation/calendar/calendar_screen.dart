import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:aina/viewmodels/diary_viewmodel.dart';
import 'package:aina/presentation/home/CRUD/diary_screen.dart';

class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({super.key});

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
  }

  @override
  Widget build(BuildContext context) {
    final diaryState = ref.watch(diaryViewmodelProvider);

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
            centerTitle: true,
            title: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  color: Colors.white.withOpacity(0.5),
                  child: const Text(
                    '월간 기록',
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
          diaryState.when(
            data: (diaries) {
              final selectedDiaries = diaries.where((diary) {
                return _selectedDay != null && _isSameDay(diary.createdAt, _selectedDay);
              }).toList();

              return SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0).copyWith(top: 20.0, bottom: 160.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
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
                        padding: const EdgeInsets.all(16),
                        child: TableCalendar(
                          locale: 'ko_KR',
                          firstDay: DateTime.utc(2020, 10, 16),
                          lastDay: DateTime.utc(2030, 3, 14),
                          focusedDay: _focusedDay,
                          selectedDayPredicate: (day) {
                            return isSameDay(_selectedDay, day);
                          },
                          onDaySelected: (selectedDay, focusedDay) {
                            setState(() {
                              _selectedDay = selectedDay;
                              _focusedDay = focusedDay;
                            });
                          },
                          eventLoader: (day) {
                            return diaries.where((diary) => _isSameDay(diary.createdAt, day)).toList();
                          },
                          calendarStyle: CalendarStyle(
                            todayDecoration: BoxDecoration(
                              color: const Color(0xFF86B082).withOpacity(0.5), // Soft pastel green
                              shape: BoxShape.circle,
                            ),
                            selectedDecoration: const BoxDecoration(
                              color: Color(0xFF86B082),
                              shape: BoxShape.circle,
                            ),
                            markerDecoration: const BoxDecoration(
                              color: Color(0xFFE5A496),
                              shape: BoxShape.circle,
                            ),
                          ),
                          headerStyle: const HeaderStyle(
                            formatButtonVisible: false,
                            titleCentered: true,
                            titleTextStyle: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF4A4A4A),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      const Text(
                        '이 날의 기록',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4A4A4A),
                        ),
                      ),
                      const SizedBox(height: 16),
                      selectedDiaries.isEmpty
                          ? _buildEmptyState()
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.zero,
                              itemCount: selectedDiaries.length,
                              itemBuilder: (context, index) {
                                final diary = selectedDiaries[index];
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
                              },
                            ),
                    ],
                  ),
                ),
              );
            },
            loading: () => const SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF86B082),
                  strokeWidth: 2.5,
                ),
              ),
            ),
            error: (error, stackTrace) => SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
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
                      onTap: () => ref.invalidate(diaryViewmodelProvider),
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
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(40),
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
      child: const Column(
        children: [
          Icon(
            Icons.edit_note_rounded,
            size: 48,
            color: Color(0xFFD4D4D4),
          ),
          SizedBox(height: 16),
          Text(
            '작성된 일기가 없습니다.\n새로운 마음을 기록해보세요.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF9E9E9E),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final localDate = date.toLocal();
    return '${localDate.month}월 ${localDate.day}일';
  }

  bool _isSameDay(DateTime diaryDate, DateTime? calendarDate) {
    if (calendarDate == null) return false;
    final localDiary = diaryDate.toLocal();
    return localDiary.year == calendarDate.year &&
        localDiary.month == calendarDate.month &&
        localDiary.day == calendarDate.day;
  }

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
              color: Colors.black.withOpacity(0.04),
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
