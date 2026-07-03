import 'package:aina/data/models/diary.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'diary_repository.g.dart';

@riverpod
DiaryRepository diaryRepository(Ref ref) { // 1. [수정] Ref 파라미터 필수!
  return DiaryRepository(Supabase.instance.client);
}

class DiaryRepository {
  final SupabaseClient _supabase;
  DiaryRepository(this._supabase);

  /// 다이어리 저장 (Create)
  Future<void> saveDiaryEntry(Diary diary) async {
    try {
      // Freezed 모델에 가놓은 toJson()을 활용하면 맵을 직접 타이핑하지 않아도 됩니다.
      await _supabase.from('diaries').insert(diary.toJson());
    } catch (e) {
      throw Exception('Error saving diary entry: $e');
    }
  }

  /// 다이어리 조회 (Read)
  Future<List<Diary>> fetchDiaryEntries() async {
    try {
      final response = await _supabase
          .from('diaries')
          .select()
          .order('date', ascending: false);
      
      // 2. [수정] 수동 파싱 대신 Freezed가 만들어준 Diary.fromJson을 적용
      return (response as List).map((entry) => Diary.fromJson(entry)).toList();
    } catch (e) {
      throw Exception('Error fetching diary entries: $e');
    }
  }

  /// 다이어리 삭제 (Delete)
  Future<void> deleteDiaryEntry(String id) async {
    try {
      await _supabase.from('diaries').delete().eq('id', id);
    } catch (e) {
      throw Exception('Error deleting diary entry: $e');
    }
  }

  /// 다이어리 수정 (Update)
  Future<void> updateDiaryEntry(String id, Diary diary) async {
    try {
      await _supabase
          .from('diaries')
          .update(diary.toJson()) // 통째로 넘기거나 원하시는 필드만 Map으로 넘겨도 됩니다.
          .eq('id', id);
    } catch (e) {
      throw Exception('Error updating diary entry: $e');
    }
  }
}