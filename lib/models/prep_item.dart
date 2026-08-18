import 'package:freezed_annotation/freezed_annotation.dart';

part 'prep_item.freezed.dart';
part 'prep_item.g.dart';

/// 챙기기 / 사용·섭취하기 / 구매하기 / 시간이 필요한 루틴 (PRD §11.3, ERD prep_kind).
enum PrepKind {
  @JsonValue('carry')
  carry,
  @JsonValue('consume')
  consume,
  @JsonValue('purchase')
  purchase,
  @JsonValue('routine')
  routine,
}

/// 맞춤 준비 항목. 준비시간 화면 안의 한 섹션에서 등록되며
/// 별도 온보딩 단계로 분리하지 않는다 (PRD §11.3).
@freezed
abstract class PrepItem with _$PrepItem {
  const factory PrepItem({
    required String id,
    required String label,
    required PrepKind kind,
    @Default(0) int extraMin, // routine만 0보다 큰 값 허용 (ERD ck_prep_minutes)
    @Default(false) bool sensitive, // 복용약 등. 잠금화면 lockAlias로 치환
    @Default(false) bool fromChip, // 추천 칩 선택 vs 직접 입력
    @Default(true) bool active,
  }) = _PrepItem;

  factory PrepItem.fromJson(Map<String, dynamic> json) =>
      _$PrepItemFromJson(json);

  const PrepItem._();

  /// 서버 검증 규칙과 동일한 클라이언트측 가드.
  /// fromChip=true ∧ sensitive=true 조합은 애초에 추천 칩에 없어야 하므로
  /// 이 조합이 만들어지면 UI 레벨에서 막는다 (TR-10).
  bool get isInvalidChipCombination => fromChip && sensitive;
}

/// 추천 칩 목록. 민감·규제 품목(담배·주류·복용약 등)은 여기 포함하지 않는다
/// (PRD §1.1 "추천 칩은 일반적인 준비물 위주로 제공", TR-10 추천 경계).
/// 복용약은 사용자가 "직접 추가"로만 등록할 수 있으며, 선택 시 서버가
/// ruleCategory='medication'을 판별해 isSensitive=true를 강제 세팅한다.
const List<Map<String, dynamic>> kPrepItemQuickAddChips = [
  {'label': '영양제', 'kind': PrepKind.consume},
  {'label': '물·텀블러', 'kind': PrepKind.carry},
  {'label': '선크림', 'kind': PrepKind.carry},
  {'label': '마스크', 'kind': PrepKind.carry},
  {'label': '우산', 'kind': PrepKind.carry},
  {'label': '보조배터리', 'kind': PrepKind.carry},
  {'label': '커피·차·간식', 'kind': PrepKind.purchase},
];
