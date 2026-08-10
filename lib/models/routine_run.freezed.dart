// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'routine_run.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RoutineRun {

 String get id; String get routineId; DateTime get runDate; String get status;// scheduled|in_progress|done|skipped
 DateTime? get startedAt; DateTime? get finishedAt;
/// Create a copy of RoutineRun
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RoutineRunCopyWith<RoutineRun> get copyWith => _$RoutineRunCopyWithImpl<RoutineRun>(this as RoutineRun, _$identity);

  /// Serializes this RoutineRun to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RoutineRun&&(identical(other.id, id) || other.id == id)&&(identical(other.routineId, routineId) || other.routineId == routineId)&&(identical(other.runDate, runDate) || other.runDate == runDate)&&(identical(other.status, status) || other.status == status)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.finishedAt, finishedAt) || other.finishedAt == finishedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,routineId,runDate,status,startedAt,finishedAt);

@override
String toString() {
  return 'RoutineRun(id: $id, routineId: $routineId, runDate: $runDate, status: $status, startedAt: $startedAt, finishedAt: $finishedAt)';
}


}

/// @nodoc
abstract mixin class $RoutineRunCopyWith<$Res>  {
  factory $RoutineRunCopyWith(RoutineRun value, $Res Function(RoutineRun) _then) = _$RoutineRunCopyWithImpl;
@useResult
$Res call({
 String id, String routineId, DateTime runDate, String status, DateTime? startedAt, DateTime? finishedAt
});




}
/// @nodoc
class _$RoutineRunCopyWithImpl<$Res>
    implements $RoutineRunCopyWith<$Res> {
  _$RoutineRunCopyWithImpl(this._self, this._then);

  final RoutineRun _self;
  final $Res Function(RoutineRun) _then;

/// Create a copy of RoutineRun
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? routineId = null,Object? runDate = null,Object? status = null,Object? startedAt = freezed,Object? finishedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,routineId: null == routineId ? _self.routineId : routineId // ignore: cast_nullable_to_non_nullable
as String,runDate: null == runDate ? _self.runDate : runDate // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,startedAt: freezed == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,finishedAt: freezed == finishedAt ? _self.finishedAt : finishedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [RoutineRun].
extension RoutineRunPatterns on RoutineRun {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RoutineRun value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RoutineRun() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RoutineRun value)  $default,){
final _that = this;
switch (_that) {
case _RoutineRun():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RoutineRun value)?  $default,){
final _that = this;
switch (_that) {
case _RoutineRun() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String routineId,  DateTime runDate,  String status,  DateTime? startedAt,  DateTime? finishedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RoutineRun() when $default != null:
return $default(_that.id,_that.routineId,_that.runDate,_that.status,_that.startedAt,_that.finishedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String routineId,  DateTime runDate,  String status,  DateTime? startedAt,  DateTime? finishedAt)  $default,) {final _that = this;
switch (_that) {
case _RoutineRun():
return $default(_that.id,_that.routineId,_that.runDate,_that.status,_that.startedAt,_that.finishedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String routineId,  DateTime runDate,  String status,  DateTime? startedAt,  DateTime? finishedAt)?  $default,) {final _that = this;
switch (_that) {
case _RoutineRun() when $default != null:
return $default(_that.id,_that.routineId,_that.runDate,_that.status,_that.startedAt,_that.finishedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RoutineRun implements RoutineRun {
  const _RoutineRun({required this.id, required this.routineId, required this.runDate, required this.status, this.startedAt, this.finishedAt});
  factory _RoutineRun.fromJson(Map<String, dynamic> json) => _$RoutineRunFromJson(json);

@override final  String id;
@override final  String routineId;
@override final  DateTime runDate;
@override final  String status;
// scheduled|in_progress|done|skipped
@override final  DateTime? startedAt;
@override final  DateTime? finishedAt;

/// Create a copy of RoutineRun
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RoutineRunCopyWith<_RoutineRun> get copyWith => __$RoutineRunCopyWithImpl<_RoutineRun>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RoutineRunToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RoutineRun&&(identical(other.id, id) || other.id == id)&&(identical(other.routineId, routineId) || other.routineId == routineId)&&(identical(other.runDate, runDate) || other.runDate == runDate)&&(identical(other.status, status) || other.status == status)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.finishedAt, finishedAt) || other.finishedAt == finishedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,routineId,runDate,status,startedAt,finishedAt);

@override
String toString() {
  return 'RoutineRun(id: $id, routineId: $routineId, runDate: $runDate, status: $status, startedAt: $startedAt, finishedAt: $finishedAt)';
}


}

/// @nodoc
abstract mixin class _$RoutineRunCopyWith<$Res> implements $RoutineRunCopyWith<$Res> {
  factory _$RoutineRunCopyWith(_RoutineRun value, $Res Function(_RoutineRun) _then) = __$RoutineRunCopyWithImpl;
@override @useResult
$Res call({
 String id, String routineId, DateTime runDate, String status, DateTime? startedAt, DateTime? finishedAt
});




}
/// @nodoc
class __$RoutineRunCopyWithImpl<$Res>
    implements _$RoutineRunCopyWith<$Res> {
  __$RoutineRunCopyWithImpl(this._self, this._then);

  final _RoutineRun _self;
  final $Res Function(_RoutineRun) _then;

/// Create a copy of RoutineRun
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? routineId = null,Object? runDate = null,Object? status = null,Object? startedAt = freezed,Object? finishedAt = freezed,}) {
  return _then(_RoutineRun(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,routineId: null == routineId ? _self.routineId : routineId // ignore: cast_nullable_to_non_nullable
as String,runDate: null == runDate ? _self.runDate : runDate // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,startedAt: freezed == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,finishedAt: freezed == finishedAt ? _self.finishedAt : finishedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
