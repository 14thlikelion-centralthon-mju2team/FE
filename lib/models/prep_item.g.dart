// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prep_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PrepItem _$PrepItemFromJson(Map<String, dynamic> json) => _PrepItem(
  id: json['id'] as String,
  label: json['label'] as String,
  kind: $enumDecode(_$PrepKindEnumMap, json['kind']),
  extraMin: (json['extraMin'] as num?)?.toInt() ?? 0,
  sensitive: json['sensitive'] as bool? ?? false,
  fromChip: json['fromChip'] as bool? ?? false,
  active: json['active'] as bool? ?? true,
);

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
