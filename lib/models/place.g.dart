// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'place.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Place _$PlaceFromJson(Map<String, dynamic> json) => _Place(
  id: json['id'] as String,
  label: json['label'] as String,
  lat: (json['lat'] as num).toDouble(),
  lng: (json['lng'] as num).toDouble(),
  radiusM: (json['radiusM'] as num?)?.toInt() ?? 300,
  kakaoPlaceId: json['kakaoPlaceId'] as String?,
);

Map<String, dynamic> _$PlaceToJson(_Place instance) => <String, dynamic>{
  'id': instance.id,
  'label': instance.label,
  'lat': instance.lat,
  'lng': instance.lng,
  'radiusM': instance.radiusM,
  'kakaoPlaceId': instance.kakaoPlaceId,
};
