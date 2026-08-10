// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'daily_checkin.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DailyCheckin {

 DateTime get logDate; int get availableMinutes; String? get conditionInferred;// good|normal|tired — 서버가 먼저 추론
 String? get conditionFinal;// 사용자가 정정했으면 값 존재
 bool? get conditionAccepted;// 추론을 그대로 받아들였는지
 String? get focusArea;// sleep|hydration|move|focus|meal
 bool get isRestDay;
/// Create a copy of DailyCheckin
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DailyCheckinCopyWith<DailyCheckin> get copyWith => _$DailyCheckinCopyWithImpl<DailyCheckin>(this as DailyCheckin, _$identity);

  /// Serializes this DailyCheckin to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DailyCheckin&&(identical(other.logDate, logDate) || other.logDate == logDate)&&(identical(other.availableMinutes, availableMinutes) || other.availableMinutes == availableMinutes)&&(identical(other.conditionInferred, conditionInferred) || other.conditionInferred == conditionInferred)&&(identical(other.conditionFinal, conditionFinal) || other.conditionFinal == conditionFinal)&&(identical(other.conditionAccepted, conditionAccepted) || other.conditionAccepted == conditionAccepted)&&(identical(other.focusArea, focusArea) || other.focusArea == focusArea)&&(identical(other.isRestDay, isRestDay) || other.isRestDay == isRestDay));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,logDate,availableMinutes,conditionInferred,conditionFinal,conditionAccepted,focusArea,isRestDay);

@override
String toString() {
  return 'DailyCheckin(logDate: $logDate, availableMinutes: $availableMinutes, conditionInferred: $conditionInferred, conditionFinal: $conditionFinal, conditionAccepted: $conditionAccepted, focusArea: $focusArea, isRestDay: $isRestDay)';
}


}

/// @nodoc
abstract mixin class $DailyCheckinCopyWith<$Res>  {
  factory $DailyCheckinCopyWith(DailyCheckin value, $Res Function(DailyCheckin) _then) = _$DailyCheckinCopyWithImpl;
@useResult
$Res call({
 DateTime logDate, int availableMinutes, String? conditionInferred, String? conditionFinal, bool? conditionAccepted, String? focusArea, bool isRestDay
});




}
/// @nodoc
class _$DailyCheckinCopyWithImpl<$Res>
    implements $DailyCheckinCopyWith<$Res> {
  _$DailyCheckinCopyWithImpl(this._self, this._then);

  final DailyCheckin _self;
  final $Res Function(DailyCheckin) _then;

/// Create a copy of DailyCheckin
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? logDate = null,Object? availableMinutes = null,Object? conditionInferred = freezed,Object? conditionFinal = freezed,Object? conditionAccepted = freezed,Object? focusArea = freezed,Object? isRestDay = null,}) {
  return _then(_self.copyWith(
logDate: null == logDate ? _self.logDate : logDate // ignore: cast_nullable_to_non_nullable
as DateTime,availableMinutes: null == availableMinutes ? _self.availableMinutes : availableMinutes // ignore: cast_nullable_to_non_nullable
as int,conditionInferred: freezed == conditionInferred ? _self.conditionInferred : conditionInferred // ignore: cast_nullable_to_non_nullable
as String?,conditionFinal: freezed == conditionFinal ? _self.conditionFinal : conditionFinal // ignore: cast_nullable_to_non_nullable
as String?,conditionAccepted: freezed == conditionAccepted ? _self.conditionAccepted : conditionAccepted // ignore: cast_nullable_to_non_nullable
as bool?,focusArea: freezed == focusArea ? _self.focusArea : focusArea // ignore: cast_nullable_to_non_nullable
as String?,isRestDay: null == isRestDay ? _self.isRestDay : isRestDay // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [DailyCheckin].
extension DailyCheckinPatterns on DailyCheckin {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DailyCheckin value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DailyCheckin() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DailyCheckin value)  $default,){
final _that = this;
switch (_that) {
case _DailyCheckin():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DailyCheckin value)?  $default,){
final _that = this;
switch (_that) {
case _DailyCheckin() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime logDate,  int availableMinutes,  String? conditionInferred,  String? conditionFinal,  bool? conditionAccepted,  String? focusArea,  bool isRestDay)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DailyCheckin() when $default != null:
return $default(_that.logDate,_that.availableMinutes,_that.conditionInferred,_that.conditionFinal,_that.conditionAccepted,_that.focusArea,_that.isRestDay);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime logDate,  int availableMinutes,  String? conditionInferred,  String? conditionFinal,  bool? conditionAccepted,  String? focusArea,  bool isRestDay)  $default,) {final _that = this;
switch (_that) {
case _DailyCheckin():
return $default(_that.logDate,_that.availableMinutes,_that.conditionInferred,_that.conditionFinal,_that.conditionAccepted,_that.focusArea,_that.isRestDay);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime logDate,  int availableMinutes,  String? conditionInferred,  String? conditionFinal,  bool? conditionAccepted,  String? focusArea,  bool isRestDay)?  $default,) {final _that = this;
switch (_that) {
case _DailyCheckin() when $default != null:
return $default(_that.logDate,_that.availableMinutes,_that.conditionInferred,_that.conditionFinal,_that.conditionAccepted,_that.focusArea,_that.isRestDay);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DailyCheckin implements DailyCheckin {
  const _DailyCheckin({required this.logDate, required this.availableMinutes, this.conditionInferred, this.conditionFinal, this.conditionAccepted, this.focusArea, this.isRestDay = false});
  factory _DailyCheckin.fromJson(Map<String, dynamic> json) => _$DailyCheckinFromJson(json);

@override final  DateTime logDate;
@override final  int availableMinutes;
@override final  String? conditionInferred;
// good|normal|tired — 서버가 먼저 추론
@override final  String? conditionFinal;
// 사용자가 정정했으면 값 존재
@override final  bool? conditionAccepted;
// 추론을 그대로 받아들였는지
@override final  String? focusArea;
// sleep|hydration|move|focus|meal
@override@JsonKey() final  bool isRestDay;

/// Create a copy of DailyCheckin
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DailyCheckinCopyWith<_DailyCheckin> get copyWith => __$DailyCheckinCopyWithImpl<_DailyCheckin>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DailyCheckinToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DailyCheckin&&(identical(other.logDate, logDate) || other.logDate == logDate)&&(identical(other.availableMinutes, availableMinutes) || other.availableMinutes == availableMinutes)&&(identical(other.conditionInferred, conditionInferred) || other.conditionInferred == conditionInferred)&&(identical(other.conditionFinal, conditionFinal) || other.conditionFinal == conditionFinal)&&(identical(other.conditionAccepted, conditionAccepted) || other.conditionAccepted == conditionAccepted)&&(identical(other.focusArea, focusArea) || other.focusArea == focusArea)&&(identical(other.isRestDay, isRestDay) || other.isRestDay == isRestDay));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,logDate,availableMinutes,conditionInferred,conditionFinal,conditionAccepted,focusArea,isRestDay);

@override
String toString() {
  return 'DailyCheckin(logDate: $logDate, availableMinutes: $availableMinutes, conditionInferred: $conditionInferred, conditionFinal: $conditionFinal, conditionAccepted: $conditionAccepted, focusArea: $focusArea, isRestDay: $isRestDay)';
}


}

/// @nodoc
abstract mixin class _$DailyCheckinCopyWith<$Res> implements $DailyCheckinCopyWith<$Res> {
  factory _$DailyCheckinCopyWith(_DailyCheckin value, $Res Function(_DailyCheckin) _then) = __$DailyCheckinCopyWithImpl;
@override @useResult
$Res call({
 DateTime logDate, int availableMinutes, String? conditionInferred, String? conditionFinal, bool? conditionAccepted, String? focusArea, bool isRestDay
});




}
/// @nodoc
class __$DailyCheckinCopyWithImpl<$Res>
    implements _$DailyCheckinCopyWith<$Res> {
  __$DailyCheckinCopyWithImpl(this._self, this._then);

  final _DailyCheckin _self;
  final $Res Function(_DailyCheckin) _then;

/// Create a copy of DailyCheckin
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? logDate = null,Object? availableMinutes = null,Object? conditionInferred = freezed,Object? conditionFinal = freezed,Object? conditionAccepted = freezed,Object? focusArea = freezed,Object? isRestDay = null,}) {
  return _then(_DailyCheckin(
logDate: null == logDate ? _self.logDate : logDate // ignore: cast_nullable_to_non_nullable
as DateTime,availableMinutes: null == availableMinutes ? _self.availableMinutes : availableMinutes // ignore: cast_nullable_to_non_nullable
as int,conditionInferred: freezed == conditionInferred ? _self.conditionInferred : conditionInferred // ignore: cast_nullable_to_non_nullable
as String?,conditionFinal: freezed == conditionFinal ? _self.conditionFinal : conditionFinal // ignore: cast_nullable_to_non_nullable
as String?,conditionAccepted: freezed == conditionAccepted ? _self.conditionAccepted : conditionAccepted // ignore: cast_nullable_to_non_nullable
as bool?,focusArea: freezed == focusArea ? _self.focusArea : focusArea // ignore: cast_nullable_to_non_nullable
as String?,isRestDay: null == isRestDay ? _self.isRestDay : isRestDay // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
