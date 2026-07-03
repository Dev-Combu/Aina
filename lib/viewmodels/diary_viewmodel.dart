import 'dart:async'; // FutureOr를 쓰기 위해 필수입니다.
import 'package:aina/data/models/diary.dart';
import 'package:aina/data/repository/diary_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'diary_viewmodel.g.dart';

@riverpod
class DiaryViewmodel extends _$DiaryViewmodel {

  // 1. 화면이 켜질 때 최초로 들고 있을 상태(초기값)를 설정
  @override
  FutureOr<List<Diary>> build() async {
    final repo = ref.watch(diaryRepositoryProvider);
    return await repo.fetchDiaryEntries();
  }

  // 2. 일기 추가 같은 'UI 이벤트' 비즈니스 로직 처리
  Future<void> addDiary(Diary diary) async {
    state = const AsyncValue.loading(); // UI에 로딩 스타트 전파

    state = await AsyncValue.guard(() async {
      final repo = ref.read(diaryRepositoryProvider);

      // 3. [수정] 리포지토리가 Diary 객체를 받으므로 toJson()을 빼고 diary 통째로 전달
      await repo.saveDiaryEntry(diary);

      // 4. [수정] 최신 리스트 갱신 시에도 동일하게 메서드명 변경 및 바로 반환
      return await repo.fetchDiaryEntries();
    });
  }

  //3. 일기 수정
  Future<void> updateDiary(String id, Diary diary) async {
    state = const AsyncValue.loading(); // UI에 로딩 스타트 전파
    state = await AsyncValue.guard(() async {
      final repo = ref.read(diaryRepositoryProvider);
      await repo.updateDiaryEntry(id, diary);
      return await repo.fetchDiaryEntries();
    });
  }

  // 4. 일기 삭제
  Future<void> deleteDiary(String id) async {
    state = const AsyncValue.loading(); // UI에 로딩 스타트 전파
    state = await AsyncValue.guard(() async {
      final repo = ref.read(diaryRepositoryProvider);
      await repo.deleteDiaryEntry(id);
      return await repo.fetchDiaryEntries();
    });
  }
}
