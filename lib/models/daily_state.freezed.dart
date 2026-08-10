// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'daily_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DailyState {

 DateTime get runDate; int get doneCount; int get expectedCount; double get completionRate; String get signal;
/// Create a copy of DailyState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DailyStateCopyWith<DailyState> get copyWith => _$DailyStateCopyWithImpl<DailyState>(this as DailyState, _$identity);

  /// Serializes this DailyState to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DailyState&&(identical(other.runDate, runDate) || other.runDate == runDate)&&(identical(other.doneCount, doneCount) || other.doneCount == doneCount)&&(identical(other.expectedCount, expectedCount) || other.expectedCount == expectedCount)&&(identical(other.completionRate, completionRate) || other.completionRate == completionRate)&&(identical(other.signal, signal) || other.signal == signal));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,runDate,doneCount,expectedCount,completionRate,signal);

@override
String toString() {
  return 'DailyState(runDate: $runDate, doneCount: $doneCount, expectedCount: $expectedCount, completionRate: $completionRate, signal: $signal)';
}


}

/// @nodoc
abstract mixin class $DailyStateCopyWith<$Res>  {
  factory $DailyStateCopyWith(DailyState value, $Res Function(DailyState) _then) = _$DailyStateCopyWithImpl;
@useResult
$Res call({
 DateTime runDate, int doneCount, int expectedCount, double completionRate, String signal
});




}
/// @nodoc
class _$DailyStateCopyWithImpl<$Res>
    implements $DailyStateCopyWith<$Res> {
  _$DailyStateCopyWithImpl(this._self, this._then);

  final DailyState _self;
  final $Res Function(DailyState) _then;

/// Create a copy of DailyState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? runDate = null,Object? doneCount = null,Object? expectedCount = null,Object? completionRate = null,Object? signal = null,}) {
  return _then(_self.copyWith(
runDate: null == runDate ? _self.runDate : runDate // ignore: cast_nullable_to_non_nullable
as DateTime,doneCount: null == doneCount ? _self.doneCount : doneCount // ignore: cast_nullable_to_non_nullable
as int,expectedCount: null == expectedCount ? _self.expectedCount : expectedCount // ignore: cast_nullable_to_non_nullable
as int,completionRate: null == completionRate ? _self.completionRate : completionRate // ignore: cast_nullable_to_non_nullable
as double,signal: null == signal ? _self.signal : signal // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [DailyState].
extension DailyStatePatterns on DailyState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DailyState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DailyState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DailyState value)  $default,){
final _that = this;
switch (_that) {
case _DailyState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DailyState value)?  $default,){
final _that = this;
switch (_that) {
case _DailyState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime runDate,  int doneCount,  int expectedCount,  double completionRate,  String signal)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DailyState() when $default != null:
return $default(_that.runDate,_that.doneCount,_that.expectedCount,_that.completionRate,_that.signal);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime runDate,  int doneCount,  int expectedCount,  double completionRate,  String signal)  $default,) {final _that = this;
switch (_that) {
case _DailyState():
return $default(_that.runDate,_that.doneCount,_that.expectedCount,_that.completionRate,_that.signal);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime runDate,  int doneCount,  int expectedCount,  double completionRate,  String signal)?  $default,) {final _that = this;
switch (_that) {
case _DailyState() when $default != null:
return $default(_that.runDate,_that.doneCount,_that.expectedCount,_that.completionRate,_that.signal);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DailyState implements DailyState {
  const _DailyState({required this.runDate, required this.doneCount, required this.expectedCount, required this.completionRate, required this.signal});
  factory _DailyState.fromJson(Map<String, dynamic> json) => _$DailyStateFromJson(json);

@override final  DateTime runDate;
@override final  int doneCount;
@override final  int expectedCount;
@override final  double completionRate;
@override final  String signal;

/// Create a copy of DailyState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DailyStateCopyWith<_DailyState> get copyWith => __$DailyStateCopyWithImpl<_DailyState>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DailyStateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DailyState&&(identical(other.runDate, runDate) || other.runDate == runDate)&&(identical(other.doneCount, doneCount) || other.doneCount == doneCount)&&(identical(other.expectedCount, expectedCount) || other.expectedCount == expectedCount)&&(identical(other.completionRate, completionRate) || other.completionRate == completionRate)&&(identical(other.signal, signal) || other.signal == signal));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,runDate,doneCount,expectedCount,completionRate,signal);

@override
String toString() {
  return 'DailyState(runDate: $runDate, doneCount: $doneCount, expectedCount: $expectedCount, completionRate: $completionRate, signal: $signal)';
}


}

/// @nodoc
abstract mixin class _$DailyStateCopyWith<$Res> implements $DailyStateCopyWith<$Res> {
  factory _$DailyStateCopyWith(_DailyState value, $Res Function(_DailyState) _then) = __$DailyStateCopyWithImpl;
@override @useResult
$Res call({
 DateTime runDate, int doneCount, int expectedCount, double completionRate, String signal
});




}
/// @nodoc
class __$DailyStateCopyWithImpl<$Res>
    implements _$DailyStateCopyWith<$Res> {
  __$DailyStateCopyWithImpl(this._self, this._then);

  final _DailyState _self;
  final $Res Function(_DailyState) _then;

/// Create a copy of DailyState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? runDate = null,Object? doneCount = null,Object? expectedCount = null,Object? completionRate = null,Object? signal = null,}) {
  return _then(_DailyState(
runDate: null == runDate ? _self.runDate : runDate // ignore: cast_nullable_to_non_nullable
as DateTime,doneCount: null == doneCount ? _self.doneCount : doneCount // ignore: cast_nullable_to_non_nullable
as int,expectedCount: null == expectedCount ? _self.expectedCount : expectedCount // ignore: cast_nullable_to_non_nullable
as int,completionRate: null == completionRate ? _self.completionRate : completionRate // ignore: cast_nullable_to_non_nullable
as double,signal: null == signal ? _self.signal : signal // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
