// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'environment_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$EnvironmentData {

 int? get temperature; String? get sky;// 맑음, 구름많음, 흐림
 String? get pm10Grade;// 좋음, 보통, 나쁨, 매우나쁨
 String? get pm25Grade;// 좋음, 보통, 나쁨, 매우나쁨
 int? get uvIndex;
/// Create a copy of EnvironmentData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EnvironmentDataCopyWith<EnvironmentData> get copyWith => _$EnvironmentDataCopyWithImpl<EnvironmentData>(this as EnvironmentData, _$identity);

  /// Serializes this EnvironmentData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EnvironmentData&&(identical(other.temperature, temperature) || other.temperature == temperature)&&(identical(other.sky, sky) || other.sky == sky)&&(identical(other.pm10Grade, pm10Grade) || other.pm10Grade == pm10Grade)&&(identical(other.pm25Grade, pm25Grade) || other.pm25Grade == pm25Grade)&&(identical(other.uvIndex, uvIndex) || other.uvIndex == uvIndex));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,temperature,sky,pm10Grade,pm25Grade,uvIndex);

@override
String toString() {
  return 'EnvironmentData(temperature: $temperature, sky: $sky, pm10Grade: $pm10Grade, pm25Grade: $pm25Grade, uvIndex: $uvIndex)';
}


}

/// @nodoc
abstract mixin class $EnvironmentDataCopyWith<$Res>  {
  factory $EnvironmentDataCopyWith(EnvironmentData value, $Res Function(EnvironmentData) _then) = _$EnvironmentDataCopyWithImpl;
@useResult
$Res call({
 int? temperature, String? sky, String? pm10Grade, String? pm25Grade, int? uvIndex
});




}
/// @nodoc
class _$EnvironmentDataCopyWithImpl<$Res>
    implements $EnvironmentDataCopyWith<$Res> {
  _$EnvironmentDataCopyWithImpl(this._self, this._then);

  final EnvironmentData _self;
  final $Res Function(EnvironmentData) _then;

/// Create a copy of EnvironmentData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? temperature = freezed,Object? sky = freezed,Object? pm10Grade = freezed,Object? pm25Grade = freezed,Object? uvIndex = freezed,}) {
  return _then(_self.copyWith(
temperature: freezed == temperature ? _self.temperature : temperature // ignore: cast_nullable_to_non_nullable
as int?,sky: freezed == sky ? _self.sky : sky // ignore: cast_nullable_to_non_nullable
as String?,pm10Grade: freezed == pm10Grade ? _self.pm10Grade : pm10Grade // ignore: cast_nullable_to_non_nullable
as String?,pm25Grade: freezed == pm25Grade ? _self.pm25Grade : pm25Grade // ignore: cast_nullable_to_non_nullable
as String?,uvIndex: freezed == uvIndex ? _self.uvIndex : uvIndex // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [EnvironmentData].
extension EnvironmentDataPatterns on EnvironmentData {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EnvironmentData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EnvironmentData() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EnvironmentData value)  $default,){
final _that = this;
switch (_that) {
case _EnvironmentData():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EnvironmentData value)?  $default,){
final _that = this;
switch (_that) {
case _EnvironmentData() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? temperature,  String? sky,  String? pm10Grade,  String? pm25Grade,  int? uvIndex)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EnvironmentData() when $default != null:
return $default(_that.temperature,_that.sky,_that.pm10Grade,_that.pm25Grade,_that.uvIndex);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? temperature,  String? sky,  String? pm10Grade,  String? pm25Grade,  int? uvIndex)  $default,) {final _that = this;
switch (_that) {
case _EnvironmentData():
return $default(_that.temperature,_that.sky,_that.pm10Grade,_that.pm25Grade,_that.uvIndex);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? temperature,  String? sky,  String? pm10Grade,  String? pm25Grade,  int? uvIndex)?  $default,) {final _that = this;
switch (_that) {
case _EnvironmentData() when $default != null:
return $default(_that.temperature,_that.sky,_that.pm10Grade,_that.pm25Grade,_that.uvIndex);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EnvironmentData implements EnvironmentData {
  const _EnvironmentData({this.temperature, this.sky, this.pm10Grade, this.pm25Grade, this.uvIndex});
  factory _EnvironmentData.fromJson(Map<String, dynamic> json) => _$EnvironmentDataFromJson(json);

@override final  int? temperature;
@override final  String? sky;
// 맑음, 구름많음, 흐림
@override final  String? pm10Grade;
// 좋음, 보통, 나쁨, 매우나쁨
@override final  String? pm25Grade;
// 좋음, 보통, 나쁨, 매우나쁨
@override final  int? uvIndex;

/// Create a copy of EnvironmentData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EnvironmentDataCopyWith<_EnvironmentData> get copyWith => __$EnvironmentDataCopyWithImpl<_EnvironmentData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EnvironmentDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EnvironmentData&&(identical(other.temperature, temperature) || other.temperature == temperature)&&(identical(other.sky, sky) || other.sky == sky)&&(identical(other.pm10Grade, pm10Grade) || other.pm10Grade == pm10Grade)&&(identical(other.pm25Grade, pm25Grade) || other.pm25Grade == pm25Grade)&&(identical(other.uvIndex, uvIndex) || other.uvIndex == uvIndex));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,temperature,sky,pm10Grade,pm25Grade,uvIndex);

@override
String toString() {
  return 'EnvironmentData(temperature: $temperature, sky: $sky, pm10Grade: $pm10Grade, pm25Grade: $pm25Grade, uvIndex: $uvIndex)';
}


}

/// @nodoc
abstract mixin class _$EnvironmentDataCopyWith<$Res> implements $EnvironmentDataCopyWith<$Res> {
  factory _$EnvironmentDataCopyWith(_EnvironmentData value, $Res Function(_EnvironmentData) _then) = __$EnvironmentDataCopyWithImpl;
@override @useResult
$Res call({
 int? temperature, String? sky, String? pm10Grade, String? pm25Grade, int? uvIndex
});




}
/// @nodoc
class __$EnvironmentDataCopyWithImpl<$Res>
    implements _$EnvironmentDataCopyWith<$Res> {
  __$EnvironmentDataCopyWithImpl(this._self, this._then);

  final _EnvironmentData _self;
  final $Res Function(_EnvironmentData) _then;

/// Create a copy of EnvironmentData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? temperature = freezed,Object? sky = freezed,Object? pm10Grade = freezed,Object? pm25Grade = freezed,Object? uvIndex = freezed,}) {
  return _then(_EnvironmentData(
temperature: freezed == temperature ? _self.temperature : temperature // ignore: cast_nullable_to_non_nullable
as int?,sky: freezed == sky ? _self.sky : sky // ignore: cast_nullable_to_non_nullable
as String?,pm10Grade: freezed == pm10Grade ? _self.pm10Grade : pm10Grade // ignore: cast_nullable_to_non_nullable
as String?,pm25Grade: freezed == pm25Grade ? _self.pm25Grade : pm25Grade // ignore: cast_nullable_to_non_nullable
as String?,uvIndex: freezed == uvIndex ? _self.uvIndex : uvIndex // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
