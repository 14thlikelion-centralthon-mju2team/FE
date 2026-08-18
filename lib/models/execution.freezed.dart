// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'execution.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$EventExecution {

 DateTime? get actualPrepStartedAt; DateTime? get actualDepartedAt; DateTime? get actualArrivedAt; ArrivalResult get arrivalResult; String? get resultSource;// user|geo
 int? get actualOutdoorMinutes;// rushLoadScore는 운영 지표 전용이라 클라이언트가 표시하지 않는다
// (PRD 절대 원칙 3) — 모델에는 실어 오되 화면에 노출하지 않는다.
 int? get rushLoadScore;
/// Create a copy of EventExecution
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EventExecutionCopyWith<EventExecution> get copyWith => _$EventExecutionCopyWithImpl<EventExecution>(this as EventExecution, _$identity);

  /// Serializes this EventExecution to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EventExecution&&(identical(other.actualPrepStartedAt, actualPrepStartedAt) || other.actualPrepStartedAt == actualPrepStartedAt)&&(identical(other.actualDepartedAt, actualDepartedAt) || other.actualDepartedAt == actualDepartedAt)&&(identical(other.actualArrivedAt, actualArrivedAt) || other.actualArrivedAt == actualArrivedAt)&&(identical(other.arrivalResult, arrivalResult) || other.arrivalResult == arrivalResult)&&(identical(other.resultSource, resultSource) || other.resultSource == resultSource)&&(identical(other.actualOutdoorMinutes, actualOutdoorMinutes) || other.actualOutdoorMinutes == actualOutdoorMinutes)&&(identical(other.rushLoadScore, rushLoadScore) || other.rushLoadScore == rushLoadScore));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,actualPrepStartedAt,actualDepartedAt,actualArrivedAt,arrivalResult,resultSource,actualOutdoorMinutes,rushLoadScore);

@override
String toString() {
  return 'EventExecution(actualPrepStartedAt: $actualPrepStartedAt, actualDepartedAt: $actualDepartedAt, actualArrivedAt: $actualArrivedAt, arrivalResult: $arrivalResult, resultSource: $resultSource, actualOutdoorMinutes: $actualOutdoorMinutes, rushLoadScore: $rushLoadScore)';
}


}

/// @nodoc
abstract mixin class $EventExecutionCopyWith<$Res>  {
  factory $EventExecutionCopyWith(EventExecution value, $Res Function(EventExecution) _then) = _$EventExecutionCopyWithImpl;
@useResult
$Res call({
 DateTime? actualPrepStartedAt, DateTime? actualDepartedAt, DateTime? actualArrivedAt, ArrivalResult arrivalResult, String? resultSource, int? actualOutdoorMinutes, int? rushLoadScore
});




}
/// @nodoc
class _$EventExecutionCopyWithImpl<$Res>
    implements $EventExecutionCopyWith<$Res> {
  _$EventExecutionCopyWithImpl(this._self, this._then);

  final EventExecution _self;
  final $Res Function(EventExecution) _then;

/// Create a copy of EventExecution
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? actualPrepStartedAt = freezed,Object? actualDepartedAt = freezed,Object? actualArrivedAt = freezed,Object? arrivalResult = null,Object? resultSource = freezed,Object? actualOutdoorMinutes = freezed,Object? rushLoadScore = freezed,}) {
  return _then(_self.copyWith(
actualPrepStartedAt: freezed == actualPrepStartedAt ? _self.actualPrepStartedAt : actualPrepStartedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,actualDepartedAt: freezed == actualDepartedAt ? _self.actualDepartedAt : actualDepartedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,actualArrivedAt: freezed == actualArrivedAt ? _self.actualArrivedAt : actualArrivedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,arrivalResult: null == arrivalResult ? _self.arrivalResult : arrivalResult // ignore: cast_nullable_to_non_nullable
as ArrivalResult,resultSource: freezed == resultSource ? _self.resultSource : resultSource // ignore: cast_nullable_to_non_nullable
as String?,actualOutdoorMinutes: freezed == actualOutdoorMinutes ? _self.actualOutdoorMinutes : actualOutdoorMinutes // ignore: cast_nullable_to_non_nullable
as int?,rushLoadScore: freezed == rushLoadScore ? _self.rushLoadScore : rushLoadScore // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [EventExecution].
extension EventExecutionPatterns on EventExecution {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EventExecution value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EventExecution() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EventExecution value)  $default,){
final _that = this;
switch (_that) {
case _EventExecution():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EventExecution value)?  $default,){
final _that = this;
switch (_that) {
case _EventExecution() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime? actualPrepStartedAt,  DateTime? actualDepartedAt,  DateTime? actualArrivedAt,  ArrivalResult arrivalResult,  String? resultSource,  int? actualOutdoorMinutes,  int? rushLoadScore)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EventExecution() when $default != null:
return $default(_that.actualPrepStartedAt,_that.actualDepartedAt,_that.actualArrivedAt,_that.arrivalResult,_that.resultSource,_that.actualOutdoorMinutes,_that.rushLoadScore);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime? actualPrepStartedAt,  DateTime? actualDepartedAt,  DateTime? actualArrivedAt,  ArrivalResult arrivalResult,  String? resultSource,  int? actualOutdoorMinutes,  int? rushLoadScore)  $default,) {final _that = this;
switch (_that) {
case _EventExecution():
return $default(_that.actualPrepStartedAt,_that.actualDepartedAt,_that.actualArrivedAt,_that.arrivalResult,_that.resultSource,_that.actualOutdoorMinutes,_that.rushLoadScore);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime? actualPrepStartedAt,  DateTime? actualDepartedAt,  DateTime? actualArrivedAt,  ArrivalResult arrivalResult,  String? resultSource,  int? actualOutdoorMinutes,  int? rushLoadScore)?  $default,) {final _that = this;
switch (_that) {
case _EventExecution() when $default != null:
return $default(_that.actualPrepStartedAt,_that.actualDepartedAt,_that.actualArrivedAt,_that.arrivalResult,_that.resultSource,_that.actualOutdoorMinutes,_that.rushLoadScore);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EventExecution implements EventExecution {
  const _EventExecution({this.actualPrepStartedAt, this.actualDepartedAt, this.actualArrivedAt, this.arrivalResult = ArrivalResult.unknown, this.resultSource, this.actualOutdoorMinutes, this.rushLoadScore});
  factory _EventExecution.fromJson(Map<String, dynamic> json) => _$EventExecutionFromJson(json);

@override final  DateTime? actualPrepStartedAt;
@override final  DateTime? actualDepartedAt;
@override final  DateTime? actualArrivedAt;
@override@JsonKey() final  ArrivalResult arrivalResult;
@override final  String? resultSource;
// user|geo
@override final  int? actualOutdoorMinutes;
// rushLoadScore는 운영 지표 전용이라 클라이언트가 표시하지 않는다
// (PRD 절대 원칙 3) — 모델에는 실어 오되 화면에 노출하지 않는다.
@override final  int? rushLoadScore;

/// Create a copy of EventExecution
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EventExecutionCopyWith<_EventExecution> get copyWith => __$EventExecutionCopyWithImpl<_EventExecution>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EventExecutionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EventExecution&&(identical(other.actualPrepStartedAt, actualPrepStartedAt) || other.actualPrepStartedAt == actualPrepStartedAt)&&(identical(other.actualDepartedAt, actualDepartedAt) || other.actualDepartedAt == actualDepartedAt)&&(identical(other.actualArrivedAt, actualArrivedAt) || other.actualArrivedAt == actualArrivedAt)&&(identical(other.arrivalResult, arrivalResult) || other.arrivalResult == arrivalResult)&&(identical(other.resultSource, resultSource) || other.resultSource == resultSource)&&(identical(other.actualOutdoorMinutes, actualOutdoorMinutes) || other.actualOutdoorMinutes == actualOutdoorMinutes)&&(identical(other.rushLoadScore, rushLoadScore) || other.rushLoadScore == rushLoadScore));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,actualPrepStartedAt,actualDepartedAt,actualArrivedAt,arrivalResult,resultSource,actualOutdoorMinutes,rushLoadScore);

@override
String toString() {
  return 'EventExecution(actualPrepStartedAt: $actualPrepStartedAt, actualDepartedAt: $actualDepartedAt, actualArrivedAt: $actualArrivedAt, arrivalResult: $arrivalResult, resultSource: $resultSource, actualOutdoorMinutes: $actualOutdoorMinutes, rushLoadScore: $rushLoadScore)';
}


}

/// @nodoc
abstract mixin class _$EventExecutionCopyWith<$Res> implements $EventExecutionCopyWith<$Res> {
  factory _$EventExecutionCopyWith(_EventExecution value, $Res Function(_EventExecution) _then) = __$EventExecutionCopyWithImpl;
@override @useResult
$Res call({
 DateTime? actualPrepStartedAt, DateTime? actualDepartedAt, DateTime? actualArrivedAt, ArrivalResult arrivalResult, String? resultSource, int? actualOutdoorMinutes, int? rushLoadScore
});




}
/// @nodoc
class __$EventExecutionCopyWithImpl<$Res>
    implements _$EventExecutionCopyWith<$Res> {
  __$EventExecutionCopyWithImpl(this._self, this._then);

  final _EventExecution _self;
  final $Res Function(_EventExecution) _then;

/// Create a copy of EventExecution
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? actualPrepStartedAt = freezed,Object? actualDepartedAt = freezed,Object? actualArrivedAt = freezed,Object? arrivalResult = null,Object? resultSource = freezed,Object? actualOutdoorMinutes = freezed,Object? rushLoadScore = freezed,}) {
  return _then(_EventExecution(
actualPrepStartedAt: freezed == actualPrepStartedAt ? _self.actualPrepStartedAt : actualPrepStartedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,actualDepartedAt: freezed == actualDepartedAt ? _self.actualDepartedAt : actualDepartedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,actualArrivedAt: freezed == actualArrivedAt ? _self.actualArrivedAt : actualArrivedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,arrivalResult: null == arrivalResult ? _self.arrivalResult : arrivalResult // ignore: cast_nullable_to_non_nullable
as ArrivalResult,resultSource: freezed == resultSource ? _self.resultSource : resultSource // ignore: cast_nullable_to_non_nullable
as String?,actualOutdoorMinutes: freezed == actualOutdoorMinutes ? _self.actualOutdoorMinutes : actualOutdoorMinutes // ignore: cast_nullable_to_non_nullable
as int?,rushLoadScore: freezed == rushLoadScore ? _self.rushLoadScore : rushLoadScore // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
