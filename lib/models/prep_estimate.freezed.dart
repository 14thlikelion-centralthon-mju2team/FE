// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'prep_estimate.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PrepEstimate {

 String get scopeType;// global | event_kind | weather | origin_place | time_band
 String? get scopeValue; int get estimatedMinutes; int get sampleCount;// BE 응답 필드명은 adjustmentReason(API v5.0 §15 · ERD USER_PREP_ESTIMATE).
// JsonKey 없이는 json['lastReason']을 찾아 항상 null이 되어 보정 근거가
// 화면에 뜨지 않는다.
@JsonKey(name: "adjustmentReason") String? get lastReason;
/// Create a copy of PrepEstimate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PrepEstimateCopyWith<PrepEstimate> get copyWith => _$PrepEstimateCopyWithImpl<PrepEstimate>(this as PrepEstimate, _$identity);

  /// Serializes this PrepEstimate to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PrepEstimate&&(identical(other.scopeType, scopeType) || other.scopeType == scopeType)&&(identical(other.scopeValue, scopeValue) || other.scopeValue == scopeValue)&&(identical(other.estimatedMinutes, estimatedMinutes) || other.estimatedMinutes == estimatedMinutes)&&(identical(other.sampleCount, sampleCount) || other.sampleCount == sampleCount)&&(identical(other.lastReason, lastReason) || other.lastReason == lastReason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,scopeType,scopeValue,estimatedMinutes,sampleCount,lastReason);

@override
String toString() {
  return 'PrepEstimate(scopeType: $scopeType, scopeValue: $scopeValue, estimatedMinutes: $estimatedMinutes, sampleCount: $sampleCount, lastReason: $lastReason)';
}


}

/// @nodoc
abstract mixin class $PrepEstimateCopyWith<$Res>  {
  factory $PrepEstimateCopyWith(PrepEstimate value, $Res Function(PrepEstimate) _then) = _$PrepEstimateCopyWithImpl;
@useResult
$Res call({
 String scopeType, String? scopeValue, int estimatedMinutes, int sampleCount,@JsonKey(name: "adjustmentReason") String? lastReason
});




}
/// @nodoc
class _$PrepEstimateCopyWithImpl<$Res>
    implements $PrepEstimateCopyWith<$Res> {
  _$PrepEstimateCopyWithImpl(this._self, this._then);

  final PrepEstimate _self;
  final $Res Function(PrepEstimate) _then;

/// Create a copy of PrepEstimate
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? scopeType = null,Object? scopeValue = freezed,Object? estimatedMinutes = null,Object? sampleCount = null,Object? lastReason = freezed,}) {
  return _then(_self.copyWith(
scopeType: null == scopeType ? _self.scopeType : scopeType // ignore: cast_nullable_to_non_nullable
as String,scopeValue: freezed == scopeValue ? _self.scopeValue : scopeValue // ignore: cast_nullable_to_non_nullable
as String?,estimatedMinutes: null == estimatedMinutes ? _self.estimatedMinutes : estimatedMinutes // ignore: cast_nullable_to_non_nullable
as int,sampleCount: null == sampleCount ? _self.sampleCount : sampleCount // ignore: cast_nullable_to_non_nullable
as int,lastReason: freezed == lastReason ? _self.lastReason : lastReason // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [PrepEstimate].
extension PrepEstimatePatterns on PrepEstimate {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PrepEstimate value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PrepEstimate() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PrepEstimate value)  $default,){
final _that = this;
switch (_that) {
case _PrepEstimate():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PrepEstimate value)?  $default,){
final _that = this;
switch (_that) {
case _PrepEstimate() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String scopeType,  String? scopeValue,  int estimatedMinutes,  int sampleCount, @JsonKey(name: "adjustmentReason")  String? lastReason)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PrepEstimate() when $default != null:
return $default(_that.scopeType,_that.scopeValue,_that.estimatedMinutes,_that.sampleCount,_that.lastReason);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String scopeType,  String? scopeValue,  int estimatedMinutes,  int sampleCount, @JsonKey(name: "adjustmentReason")  String? lastReason)  $default,) {final _that = this;
switch (_that) {
case _PrepEstimate():
return $default(_that.scopeType,_that.scopeValue,_that.estimatedMinutes,_that.sampleCount,_that.lastReason);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String scopeType,  String? scopeValue,  int estimatedMinutes,  int sampleCount, @JsonKey(name: "adjustmentReason")  String? lastReason)?  $default,) {final _that = this;
switch (_that) {
case _PrepEstimate() when $default != null:
return $default(_that.scopeType,_that.scopeValue,_that.estimatedMinutes,_that.sampleCount,_that.lastReason);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PrepEstimate implements PrepEstimate {
  const _PrepEstimate({required this.scopeType, this.scopeValue, required this.estimatedMinutes, required this.sampleCount, @JsonKey(name: "adjustmentReason") this.lastReason});
  factory _PrepEstimate.fromJson(Map<String, dynamic> json) => _$PrepEstimateFromJson(json);

@override final  String scopeType;
// global | event_kind | weather | origin_place | time_band
@override final  String? scopeValue;
@override final  int estimatedMinutes;
@override final  int sampleCount;
// BE 응답 필드명은 adjustmentReason(API v5.0 §15 · ERD USER_PREP_ESTIMATE).
// JsonKey 없이는 json['lastReason']을 찾아 항상 null이 되어 보정 근거가
// 화면에 뜨지 않는다.
@override@JsonKey(name: "adjustmentReason") final  String? lastReason;

/// Create a copy of PrepEstimate
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PrepEstimateCopyWith<_PrepEstimate> get copyWith => __$PrepEstimateCopyWithImpl<_PrepEstimate>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PrepEstimateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PrepEstimate&&(identical(other.scopeType, scopeType) || other.scopeType == scopeType)&&(identical(other.scopeValue, scopeValue) || other.scopeValue == scopeValue)&&(identical(other.estimatedMinutes, estimatedMinutes) || other.estimatedMinutes == estimatedMinutes)&&(identical(other.sampleCount, sampleCount) || other.sampleCount == sampleCount)&&(identical(other.lastReason, lastReason) || other.lastReason == lastReason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,scopeType,scopeValue,estimatedMinutes,sampleCount,lastReason);

@override
String toString() {
  return 'PrepEstimate(scopeType: $scopeType, scopeValue: $scopeValue, estimatedMinutes: $estimatedMinutes, sampleCount: $sampleCount, lastReason: $lastReason)';
}


}

/// @nodoc
abstract mixin class _$PrepEstimateCopyWith<$Res> implements $PrepEstimateCopyWith<$Res> {
  factory _$PrepEstimateCopyWith(_PrepEstimate value, $Res Function(_PrepEstimate) _then) = __$PrepEstimateCopyWithImpl;
@override @useResult
$Res call({
 String scopeType, String? scopeValue, int estimatedMinutes, int sampleCount,@JsonKey(name: "adjustmentReason") String? lastReason
});




}
/// @nodoc
class __$PrepEstimateCopyWithImpl<$Res>
    implements _$PrepEstimateCopyWith<$Res> {
  __$PrepEstimateCopyWithImpl(this._self, this._then);

  final _PrepEstimate _self;
  final $Res Function(_PrepEstimate) _then;

/// Create a copy of PrepEstimate
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? scopeType = null,Object? scopeValue = freezed,Object? estimatedMinutes = null,Object? sampleCount = null,Object? lastReason = freezed,}) {
  return _then(_PrepEstimate(
scopeType: null == scopeType ? _self.scopeType : scopeType // ignore: cast_nullable_to_non_nullable
as String,scopeValue: freezed == scopeValue ? _self.scopeValue : scopeValue // ignore: cast_nullable_to_non_nullable
as String?,estimatedMinutes: null == estimatedMinutes ? _self.estimatedMinutes : estimatedMinutes // ignore: cast_nullable_to_non_nullable
as int,sampleCount: null == sampleCount ? _self.sampleCount : sampleCount // ignore: cast_nullable_to_non_nullable
as int,lastReason: freezed == lastReason ? _self.lastReason : lastReason // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
