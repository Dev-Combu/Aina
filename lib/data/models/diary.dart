// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'diary.freezed.dart';
part 'diary.g.dart';

@freezed
class Diary with _$Diary {
  const factory Diary({
    int? id, 
    required String content,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _Diary;

  // Supabase의 Map(JSON) 데이터를 모델 객체로 바꾸고, 반대로 보낼 때 필수입니다.
  factory Diary.fromJson(Map<String, dynamic> json) => _$DiaryFromJson(json);
}