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
///
/// BE 응답 필드명과 FE 내부 필드명 매핑:
///   BE prepRuleId    → FE id
///   BE ruleName      → FE label
///   BE actionType    → FE kind (carry/consume/purchase/timed_routine→routine)
///   BE defaultMinutes → FE extraMin
///   BE isSensitive   → FE sensitive
///   BE isActive      → FE active
///   BE fromChip      → FE fromChip (동일)
@freezed
abstract class PrepItem with _$PrepItem {
  const factory PrepItem({
    required String id,
    required String label,
    required PrepKind kind,
    @Default(0) int extraMin,
    @Default(false) bool sensitive,
    @Default(false) bool fromChip,
    @Default(true) bool active,
  }) = _PrepItem;

  /// BE 응답 필드명과 FE 필드명 양쪽 모두 지원하는 커스텀 factory.
  /// BE가 DTO 매핑을 완료하면 FE 필드명으로 올 수 있고,
  /// 매핑 전이면 원래 BE 필드명(prepRuleId, ruleName 등)으로 온다.
  factory PrepItem.fromJson(Map<String, dynamic> json) {
    return PrepItem(
      id: (json['id'] ?? json['prepRuleId'] ?? '') as String,
      label: (json['label'] ?? json['ruleName'] ?? '') as String,
      kind: _parseKind(json['kind'] ?? json['actionType']),
      extraMin: (json['extraMin'] ?? json['defaultMinutes'] ?? 0) as int,
      sensitive: (json['sensitive'] ?? json['isSensitive'] ?? false) as bool,
      fromChip: (json['fromChip'] ?? false) as bool,
      active: (json['active'] ?? json['isActive'] ?? true) as bool,
    );
  }

  const PrepItem._();

  /// 서버 검증 규칙과 동일한 클라이언트측 가드.
  bool get isInvalidChipCombination => fromChip && sensitive;

  /// FE → BE 요청 시 사용하는 직렬화 (API 명세 §6.1 필드명 기준)
  Map<String, dynamic> toJson() => _$PrepItemToJson(this as _PrepItem);
}

/// BE의 actionType 값(carry/consume/purchase/timed_routine)이나
/// FE의 kind 값(carry/consume/purchase/routine) 모두 파싱 가능.
PrepKind _parseKind(dynamic value) {
  if (value == null) return PrepKind.carry;
  final s = value.toString();
  switch (s) {
    case 'carry':
      return PrepKind.carry;
    case 'consume':
      return PrepKind.consume;
    case 'purchase':
      return PrepKind.purchase;
    case 'routine':
    case 'timed_routine':
      return PrepKind.routine;
    default:
      return PrepKind.carry;
  }
}

/// 추천 칩 목록. 민감·규제 품목(담배·주류·복용약 등)은 여기 포함하지 않는다
/// (PRD §1.1 "추천 칩은 일반적인 준비물 위주로 제공", TR-10 추천 경계).
const List<Map<String, dynamic>> kPrepItemQuickAddChips = [
  {'label': '영양제', 'kind': PrepKind.consume},
  {'label': '물·텀블러', 'kind': PrepKind.carry},
  {'label': '선크림', 'kind': PrepKind.carry},
  {'label': '마스크', 'kind': PrepKind.carry},
  {'label': '우산', 'kind': PrepKind.carry},
  {'label': '보조배터리', 'kind': PrepKind.carry},
  {'label': '커피·차·간식', 'kind': PrepKind.purchase},
];
