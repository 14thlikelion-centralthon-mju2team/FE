// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prep_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

// fromJson은 PrepItem.fromJson() 커스텀 factory에서 직접 처리하므로
// generated _$PrepItemFromJson은 사용하지 않는다.

Map<String, dynamic> _$PrepItemToJson(_PrepItem instance) => <String, dynamic>{
  'id': instance.id,
  'label': instance.label,
  'kind': _$PrepKindEnumMap[instance.kind]!,
  'extraMin': instance.extraMin,
  'sensitive': instance.sensitive,
  'fromChip': instance.fromChip,
  'active': instance.active,
};

const _$PrepKindEnumMap = {
  PrepKind.carry: 'carry',
  PrepKind.consume: 'consume',
  PrepKind.purchase: 'purchase',
  PrepKind.routine: 'routine',
};
