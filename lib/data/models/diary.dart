import 'package:freezed_annotation/freezed_annotation.dart';


part 'diary.freezed.dart';
part 'diary.g.dart';

@freezed
class Diary with _$Diary {
  const factory Diary({
    // ID가 자동 생성(UUID 또는 BigInt)된다면 Nullable 혹은 선언을 포함해줍니다.
    String? id, 
    required String title,
    required String content,
    required DateTime date,
  }) = _Diary;

  // Supabase의 Map(JSON) 데이터를 모델 객체로 바꾸고, 반대로 보낼 때 필수입니다.
  factory Diary.fromJson(Map<String, dynamic> json) => _$DiaryFromJson(json);
}