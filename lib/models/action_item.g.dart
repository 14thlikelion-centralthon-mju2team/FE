// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'action_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ActionItem _$ActionItemFromJson(Map<String, dynamic> json) => _ActionItem(
  id: json['id'] as String,
  category: json['category'] as String,
  ladderKey: json['ladderKey'] as String,
  difficulty: (json['difficulty'] as num).toInt(),
  estMinutes: (json['estMinutes'] as num).toInt(),
  title: json['title'] as String,
  description: json['description'] as String?,
);

Map<String, dynamic> _$ActionItemToJson(_ActionItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'category': instance.category,
      'ladderKey': instance.ladderKey,
      'difficulty': instance.difficulty,
      'estMinutes': instance.estMinutes,
      'title': instance.title,
      'description': instance.description,
    };
