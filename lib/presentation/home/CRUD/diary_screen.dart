import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aina/data/models/diary.dart';
import 'package:aina/viewmodels/diary_viewmodel.dart';

class DiaryScreen extends ConsumerStatefulWidget {
  final String? content;
  final DateTime? date;
  final int? diaryId;
  final bool isWriting;

  const DiaryScreen({
    super.key,
    this.content,
    this.date,
    this.diaryId,
    this.isWriting = false,
  });

  @override
  ConsumerState<DiaryScreen> createState() => _DiaryScreenState();
}

class _DiaryScreenState extends ConsumerState<DiaryScreen> {
  final TextEditingController _contentController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  DateTime _selectedDate = DateTime.now();
  bool _isSaving = false;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _contentController.text = widget.content ?? '';
    _selectedDate = widget.date ?? DateTime.now();
    _isEditing = widget.diaryId == null || widget.isWriting;

    if (_isEditing) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _focusNode.requestFocus();
      });
    }
  }

  Future<void> _pickDate() async {
    if (!_isEditing) return;

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
    if (_isSaving) return;

    final content = _contentController.text.trim();
    if (content.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('내용을 입력해주세요.')));
      return;
    }

    setState(() => _isSaving = true);

    try {
      final diary = Diary(content: content, createdAt: _selectedDate);
      await ref.read(diaryViewmodelProvider.notifier).addDiary(diary);

      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('저장 실패: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  Future<void> _updateDiary() async {
    if (_isSaving) return;

    final content = _contentController.text.trim();
    if (content.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('내용을 입력해주세요.')));
      return;
    }

    setState(() => _isSaving = true);

    try {
      final diary = Diary(content: content, createdAt: _selectedDate);
      await ref
          .read(diaryViewmodelProvider.notifier)
          .updateDiary(widget.diaryId!, diary);

      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('수정 실패: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  Future<void> _deleteDiary() async {
    if (widget.diaryId == null) return;

    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('일기 삭제'),
        content: const Text('정말로 이 일기를 삭제하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('취소', style: TextStyle(color: Colors.black87)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('삭제', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => _isSaving = true);

    try {
      await ref
          .read(diaryViewmodelProvider.notifier)
          .deleteDiary(widget.diaryId.toString());

      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('삭제 실패: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  void _toggleEditing() {
    setState(() => _isEditing = !_isEditing);
    if (_isEditing) {
      _focusNode.requestFocus();
    } else {
      _focusNode.unfocus();
    }
  }

  @override
  void dispose() {
    _contentController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    final String titleText = widget.diaryId == null
        ? '새 일기'
        : (_isEditing ? '일기 수정' : '일기 읽기');

    return Material(
      color: const Color(0xFFF9F6F0),
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(28),
        topRight: Radius.circular(28),
      ),
      clipBehavior: Clip.antiAlias,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.85,
        child: Padding(
          padding: EdgeInsets.only(bottom: bottomInset),
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // 🛠️ 가로 전체 확장 적용된 상단 바 영역
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                child: SizedBox(
                  width:
                      double.infinity, // 💡 이 코드가 누락되어 상단바가 쪼그라들었었습니다. 추가 완료!
                  height: 48,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // 1. 왼쪽 끝 고정 닫기 버튼
                      Positioned(
                        left: 0,
                        child: IconButton(
                          icon: const Icon(
                            Icons.close_rounded,
                            color: Colors.black87,
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),

                      // 2. 완벽한 정중앙 타이틀
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.85),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Text(
                          titleText,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),

                      // 3. 오른쪽 끝 고정 액션 버튼들
                      Positioned(
                        right: 0,
                        child: _isSaving
                            ? const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 12.0),
                                child: SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                              )
                            : (!_isEditing && widget.diaryId != null)
                            ? Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete_outline_rounded,
                                      color: Colors.redAccent,
                                    ),
                                    onPressed: _deleteDiary,
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.edit_rounded,
                                      color: Colors.black87,
                                    ),
                                    onPressed: () {
                                      _toggleEditing();
                                    },
                                  ),
                                ],
                              )
                            : IconButton(
                                icon: const Icon(
                                  Icons.check_rounded,
                                  color: Colors.black87,
                                ),
                                onPressed: widget.diaryId == null
                                    ? _saveDiary
                                    : _updateDiary,
                              ),
                      ),
                    ],
                  ),
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
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
                            color: Color(0xFF86B082),
                          ),
                          title: Text(
                            '${_selectedDate.year}년 ${_selectedDate.month}월 ${_selectedDate.day}일',
                            style: const TextStyle(
                              color: Color(0xFF4A4A4A),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          trailing: _isEditing
                              ? const Icon(
                                  Icons.keyboard_arrow_right_rounded,
                                  color: Color(0xFFD4D4D4),
                                )
                              : null,
                          onTap: _pickDate,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        constraints: BoxConstraints(
                          minHeight: MediaQuery.of(context).size.height * 0.4,
                        ),
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
                          focusNode: _focusNode,
                          readOnly: !_isEditing,
                          maxLines: null,
                          style: const TextStyle(
                            color: Color(0xFF4A4A4A),
                            fontSize: 16,
                            height: 1.6,
                          ),
                          decoration: InputDecoration(
                            hintText: _isEditing ? '오늘의 일기를 적어보세요...' : '',
                            hintStyle: const TextStyle(
                              color: Color(0xFF9E9E9E),
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
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
