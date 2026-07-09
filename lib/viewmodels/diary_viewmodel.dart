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

  try {
    final repo = ref.read(diaryRepositoryProvider);

    // 1. 데이터 저장
    await repo.saveDiaryEntry(diary);

    // 2. 저장 성공 후 최신 데이터 다시 불러오기
    final updatedList = await repo.fetchDiaryEntries();
    
    // 3. 성공한 데이터로 상태 갱신
    state = AsyncValue.data(updatedList);
  } catch (e, stackTrace) {
    // ❌ 에러가 발생하면 state를 에러 상태로 만들고, 
    // UI(화면)에서도 catch할 수 있도록 에러를 위로 던집니다.
    state = AsyncValue.error(e, stackTrace);
    rethrow; 
  }
}

  //3. 일기 수정
  Future<void> updateDiary(int id, Diary diary) async {
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
