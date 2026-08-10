// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'task_log.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TaskLog {

 String get id; String get routineRunId; String get routineTaskId; String get status;// done|skipped|partial|unknown
 DateTime? get completedAt; int? get durationSeconds; String? get memo;
/// Create a copy of TaskLog
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskLogCopyWith<TaskLog> get copyWith => _$TaskLogCopyWithImpl<TaskLog>(this as TaskLog, _$identity);

  /// Serializes this TaskLog to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskLog&&(identical(other.id, id) || other.id == id)&&(identical(other.routineRunId, routineRunId) || other.routineRunId == routineRunId)&&(identical(other.routineTaskId, routineTaskId) || other.routineTaskId == routineTaskId)&&(identical(other.status, status) || other.status == status)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt)&&(identical(other.durationSeconds, durationSeconds) || other.durationSeconds == durationSeconds)&&(identical(other.memo, memo) || other.memo == memo));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,routineRunId,routineTaskId,status,completedAt,durationSeconds,memo);

@override
String toString() {
  return 'TaskLog(id: $id, routineRunId: $routineRunId, routineTaskId: $routineTaskId, status: $status, completedAt: $completedAt, durationSeconds: $durationSeconds, memo: $memo)';
}


}

/// @nodoc
abstract mixin class $TaskLogCopyWith<$Res>  {
  factory $TaskLogCopyWith(TaskLog value, $Res Function(TaskLog) _then) = _$TaskLogCopyWithImpl;
@useResult
$Res call({
 String id, String routineRunId, String routineTaskId, String status, DateTime? completedAt, int? durationSeconds, String? memo
});




}
/// @nodoc
class _$TaskLogCopyWithImpl<$Res>
    implements $TaskLogCopyWith<$Res> {
  _$TaskLogCopyWithImpl(this._self, this._then);

  final TaskLog _self;
  final $Res Function(TaskLog) _then;

/// Create a copy of TaskLog
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? routineRunId = null,Object? routineTaskId = null,Object? status = null,Object? completedAt = freezed,Object? durationSeconds = freezed,Object? memo = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,routineRunId: null == routineRunId ? _self.routineRunId : routineRunId // ignore: cast_nullable_to_non_nullable
as String,routineTaskId: null == routineTaskId ? _self.routineTaskId : routineTaskId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,durationSeconds: freezed == durationSeconds ? _self.durationSeconds : durationSeconds // ignore: cast_nullable_to_non_nullable
as int?,memo: freezed == memo ? _self.memo : memo // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [TaskLog].
extension TaskLogPatterns on TaskLog {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TaskLog value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TaskLog() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TaskLog value)  $default,){
final _that = this;
switch (_that) {
case _TaskLog():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TaskLog value)?  $default,){
final _that = this;
switch (_that) {
case _TaskLog() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String routineRunId,  String routineTaskId,  String status,  DateTime? completedAt,  int? durationSeconds,  String? memo)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TaskLog() when $default != null:
return $default(_that.id,_that.routineRunId,_that.routineTaskId,_that.status,_that.completedAt,_that.durationSeconds,_that.memo);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String routineRunId,  String routineTaskId,  String status,  DateTime? completedAt,  int? durationSeconds,  String? memo)  $default,) {final _that = this;
switch (_that) {
case _TaskLog():
return $default(_that.id,_that.routineRunId,_that.routineTaskId,_that.status,_that.completedAt,_that.durationSeconds,_that.memo);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String routineRunId,  String routineTaskId,  String status,  DateTime? completedAt,  int? durationSeconds,  String? memo)?  $default,) {final _that = this;
switch (_that) {
case _TaskLog() when $default != null:
return $default(_that.id,_that.routineRunId,_that.routineTaskId,_that.status,_that.completedAt,_that.durationSeconds,_that.memo);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TaskLog implements TaskLog {
  const _TaskLog({required this.id, required this.routineRunId, required this.routineTaskId, required this.status, this.completedAt, this.durationSeconds, this.memo});
  factory _TaskLog.fromJson(Map<String, dynamic> json) => _$TaskLogFromJson(json);

@override final  String id;
@override final  String routineRunId;
@override final  String routineTaskId;
@override final  String status;
// done|skipped|partial|unknown
@override final  DateTime? completedAt;
@override final  int? durationSeconds;
@override final  String? memo;

/// Create a copy of TaskLog
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TaskLogCopyWith<_TaskLog> get copyWith => __$TaskLogCopyWithImpl<_TaskLog>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TaskLogToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TaskLog&&(identical(other.id, id) || other.id == id)&&(identical(other.routineRunId, routineRunId) || other.routineRunId == routineRunId)&&(identical(other.routineTaskId, routineTaskId) || other.routineTaskId == routineTaskId)&&(identical(other.status, status) || other.status == status)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt)&&(identical(other.durationSeconds, durationSeconds) || other.durationSeconds == durationSeconds)&&(identical(other.memo, memo) || other.memo == memo));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,routineRunId,routineTaskId,status,completedAt,durationSeconds,memo);

@override
String toString() {
  return 'TaskLog(id: $id, routineRunId: $routineRunId, routineTaskId: $routineTaskId, status: $status, completedAt: $completedAt, durationSeconds: $durationSeconds, memo: $memo)';
}


}

/// @nodoc
abstract mixin class _$TaskLogCopyWith<$Res> implements $TaskLogCopyWith<$Res> {
  factory _$TaskLogCopyWith(_TaskLog value, $Res Function(_TaskLog) _then) = __$TaskLogCopyWithImpl;
@override @useResult
$Res call({
 String id, String routineRunId, String routineTaskId, String status, DateTime? completedAt, int? durationSeconds, String? memo
});




}
/// @nodoc
class __$TaskLogCopyWithImpl<$Res>
    implements _$TaskLogCopyWith<$Res> {
  __$TaskLogCopyWithImpl(this._self, this._then);

  final _TaskLog _self;
  final $Res Function(_TaskLog) _then;

/// Create a copy of TaskLog
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? routineRunId = null,Object? routineTaskId = null,Object? status = null,Object? completedAt = freezed,Object? durationSeconds = freezed,Object? memo = freezed,}) {
  return _then(_TaskLog(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,routineRunId: null == routineRunId ? _self.routineRunId : routineRunId // ignore: cast_nullable_to_non_nullable
as String,routineTaskId: null == routineTaskId ? _self.routineTaskId : routineTaskId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,durationSeconds: freezed == durationSeconds ? _self.durationSeconds : durationSeconds // ignore: cast_nullable_to_non_nullable
as int?,memo: freezed == memo ? _self.memo : memo // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
