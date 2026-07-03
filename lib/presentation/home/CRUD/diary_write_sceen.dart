import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DiaryWriteScreen extends StatefulWidget {
  const DiaryWriteScreen({Key? key}) : super(key: key);

  @override
  State<DiaryWriteScreen> createState() => _DiaryWriteScreenState();
}

class _DiaryWriteScreenState extends State<DiaryWriteScreen> {
  final TextEditingController _contentController = TextEditingController();
  final SupabaseClient _supabase = Supabase.instance.client;
  DateTime _selectedDate = DateTime.now();

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(now.year - 5),
      lastDate: now,
    );
    if (picked != null && mounted) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _saveDiary() async {
    final content = _contentController.text.trim();
    if (content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('내용을 입력해주세요.')),
      );
      return;
    }
    try {
      await _supabase.from('diaries').insert({
        'content': content,
        'created_at': _selectedDate.toIso8601String(),
      });
      if (mounted) Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('저장 실패: $e')),
      );
    }
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F6F0), // 전체 베이지 톤 배경
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.85),
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
            '새 일기',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              letterSpacing: -0.5,
            ),
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.check_rounded, color: Colors.black87),
            onPressed: _saveDiary,
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 10),
              
              // 1. 날짜 선택 카드
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: ListTile(
                  leading: const Icon(
                    Icons.calendar_today_rounded, 
                    color: Color(0xFF86B082), // 홈 화면의 나무와 어울리는 초록색 포인트
                  ),
                  title: Text(
                    '${_selectedDate.year}년 ${_selectedDate.month}월 ${_selectedDate.day}일',
                    style: const TextStyle(
                      color: Color(0xFF4A4A4A), 
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  trailing: const Icon(Icons.keyboard_arrow_right_rounded, color: Color(0xFFD4D4D4)),
                  onTap: _pickDate,
                ),
              ),
              const SizedBox(height: 20),
              
              // 2. 일기 작성 카드
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16.0),
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
                  child: TextField(
                    controller: _contentController,
                    expands: true,
                    maxLines: null,
                    style: const TextStyle(
                      color: Color(0xFF4A4A4A), 
                      fontSize: 16, 
                      height: 1.6,
                    ),
                    decoration: const InputDecoration(
                      hintText: '오늘의 일기를 적어보세요...',
                      hintStyle: TextStyle(color: Color(0xFF9E9E9E)),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}