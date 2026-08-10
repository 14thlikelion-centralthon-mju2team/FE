// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'routine.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RoutineTask {

 String get id; String get routineId; ActionItem get action;// 현재 난이도 — adjustments를 통해서만 바뀜
 int get orderNo;
/// Create a copy of RoutineTask
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RoutineTaskCopyWith<RoutineTask> get copyWith => _$RoutineTaskCopyWithImpl<RoutineTask>(this as RoutineTask, _$identity);

  /// Serializes this RoutineTask to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RoutineTask&&(identical(other.id, id) || other.id == id)&&(identical(other.routineId, routineId) || other.routineId == routineId)&&(identical(other.action, action) || other.action == action)&&(identical(other.orderNo, orderNo) || other.orderNo == orderNo));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,routineId,action,orderNo);

@override
String toString() {
  return 'RoutineTask(id: $id, routineId: $routineId, action: $action, orderNo: $orderNo)';
}


}

/// @nodoc
abstract mixin class $RoutineTaskCopyWith<$Res>  {
  factory $RoutineTaskCopyWith(RoutineTask value, $Res Function(RoutineTask) _then) = _$RoutineTaskCopyWithImpl;
@useResult
$Res call({
 String id, String routineId, ActionItem action, int orderNo
});


$ActionItemCopyWith<$Res> get action;

}
/// @nodoc
class _$RoutineTaskCopyWithImpl<$Res>
    implements $RoutineTaskCopyWith<$Res> {
  _$RoutineTaskCopyWithImpl(this._self, this._then);

  final RoutineTask _self;
  final $Res Function(RoutineTask) _then;

/// Create a copy of RoutineTask
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? routineId = null,Object? action = null,Object? orderNo = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,routineId: null == routineId ? _self.routineId : routineId // ignore: cast_nullable_to_non_nullable
as String,action: null == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as ActionItem,orderNo: null == orderNo ? _self.orderNo : orderNo // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of RoutineTask
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ActionItemCopyWith<$Res> get action {
  
  return $ActionItemCopyWith<$Res>(_self.action, (value) {
    return _then(_self.copyWith(action: value));
  });
}
}


/// Adds pattern-matching-related methods to [RoutineTask].
extension RoutineTaskPatterns on RoutineTask {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RoutineTask value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RoutineTask() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RoutineTask value)  $default,){
final _that = this;
switch (_that) {
case _RoutineTask():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RoutineTask value)?  $default,){
final _that = this;
switch (_that) {
case _RoutineTask() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String routineId,  ActionItem action,  int orderNo)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RoutineTask() when $default != null:
return $default(_that.id,_that.routineId,_that.action,_that.orderNo);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String routineId,  ActionItem action,  int orderNo)  $default,) {final _that = this;
switch (_that) {
case _RoutineTask():
return $default(_that.id,_that.routineId,_that.action,_that.orderNo);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String routineId,  ActionItem action,  int orderNo)?  $default,) {final _that = this;
switch (_that) {
case _RoutineTask() when $default != null:
return $default(_that.id,_that.routineId,_that.action,_that.orderNo);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RoutineTask implements RoutineTask {
  const _RoutineTask({required this.id, required this.routineId, required this.action, required this.orderNo});
  factory _RoutineTask.fromJson(Map<String, dynamic> json) => _$RoutineTaskFromJson(json);

@override final  String id;
@override final  String routineId;
@override final  ActionItem action;
// 현재 난이도 — adjustments를 통해서만 바뀜
@override final  int orderNo;

/// Create a copy of RoutineTask
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RoutineTaskCopyWith<_RoutineTask> get copyWith => __$RoutineTaskCopyWithImpl<_RoutineTask>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RoutineTaskToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RoutineTask&&(identical(other.id, id) || other.id == id)&&(identical(other.routineId, routineId) || other.routineId == routineId)&&(identical(other.action, action) || other.action == action)&&(identical(other.orderNo, orderNo) || other.orderNo == orderNo));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,routineId,action,orderNo);

@override
String toString() {
  return 'RoutineTask(id: $id, routineId: $routineId, action: $action, orderNo: $orderNo)';
}


}

/// @nodoc
abstract mixin class _$RoutineTaskCopyWith<$Res> implements $RoutineTaskCopyWith<$Res> {
  factory _$RoutineTaskCopyWith(_RoutineTask value, $Res Function(_RoutineTask) _then) = __$RoutineTaskCopyWithImpl;
@override @useResult
$Res call({
 String id, String routineId, ActionItem action, int orderNo
});


@override $ActionItemCopyWith<$Res> get action;

}
/// @nodoc
class __$RoutineTaskCopyWithImpl<$Res>
    implements _$RoutineTaskCopyWith<$Res> {
  __$RoutineTaskCopyWithImpl(this._self, this._then);

  final _RoutineTask _self;
  final $Res Function(_RoutineTask) _then;

/// Create a copy of RoutineTask
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? routineId = null,Object? action = null,Object? orderNo = null,}) {
  return _then(_RoutineTask(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,routineId: null == routineId ? _self.routineId : routineId // ignore: cast_nullable_to_non_nullable
as String,action: null == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as ActionItem,orderNo: null == orderNo ? _self.orderNo : orderNo // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of RoutineTask
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ActionItemCopyWith<$Res> get action {
  
  return $ActionItemCopyWith<$Res>(_self.action, (value) {
    return _then(_self.copyWith(action: value));
  });
}
}


/// @nodoc
mixin _$Routine {

 String get id; String? get placeId;// null = 시간 기반
 String get title; String get scheduleType;// "time" | "place"
 String? get rrule; String? get anchorTime; List<RoutineTask> get tasks;
/// Create a copy of Routine
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RoutineCopyWith<Routine> get copyWith => _$RoutineCopyWithImpl<Routine>(this as Routine, _$identity);

  /// Serializes this Routine to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Routine&&(identical(other.id, id) || other.id == id)&&(identical(other.placeId, placeId) || other.placeId == placeId)&&(identical(other.title, title) || other.title == title)&&(identical(other.scheduleType, scheduleType) || other.scheduleType == scheduleType)&&(identical(other.rrule, rrule) || other.rrule == rrule)&&(identical(other.anchorTime, anchorTime) || other.anchorTime == anchorTime)&&const DeepCollectionEquality().equals(other.tasks, tasks));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,placeId,title,scheduleType,rrule,anchorTime,const DeepCollectionEquality().hash(tasks));

@override
String toString() {
  return 'Routine(id: $id, placeId: $placeId, title: $title, scheduleType: $scheduleType, rrule: $rrule, anchorTime: $anchorTime, tasks: $tasks)';
}


}

/// @nodoc
abstract mixin class $RoutineCopyWith<$Res>  {
  factory $RoutineCopyWith(Routine value, $Res Function(Routine) _then) = _$RoutineCopyWithImpl;
@useResult
$Res call({
 String id, String? placeId, String title, String scheduleType, String? rrule, String? anchorTime, List<RoutineTask> tasks
});




}
/// @nodoc
class _$RoutineCopyWithImpl<$Res>
    implements $RoutineCopyWith<$Res> {
  _$RoutineCopyWithImpl(this._self, this._then);

  final Routine _self;
  final $Res Function(Routine) _then;

/// Create a copy of Routine
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? placeId = freezed,Object? title = null,Object? scheduleType = null,Object? rrule = freezed,Object? anchorTime = freezed,Object? tasks = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,placeId: freezed == placeId ? _self.placeId : placeId // ignore: cast_nullable_to_non_nullable
as String?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,scheduleType: null == scheduleType ? _self.scheduleType : scheduleType // ignore: cast_nullable_to_non_nullable
as String,rrule: freezed == rrule ? _self.rrule : rrule // ignore: cast_nullable_to_non_nullable
as String?,anchorTime: freezed == anchorTime ? _self.anchorTime : anchorTime // ignore: cast_nullable_to_non_nullable
as String?,tasks: null == tasks ? _self.tasks : tasks // ignore: cast_nullable_to_non_nullable
as List<RoutineTask>,
  ));
}

}


/// Adds pattern-matching-related methods to [Routine].
extension RoutinePatterns on Routine {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Routine value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Routine() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Routine value)  $default,){
final _that = this;
switch (_that) {
case _Routine():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Routine value)?  $default,){
final _that = this;
switch (_that) {
case _Routine() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String? placeId,  String title,  String scheduleType,  String? rrule,  String? anchorTime,  List<RoutineTask> tasks)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Routine() when $default != null:
return $default(_that.id,_that.placeId,_that.title,_that.scheduleType,_that.rrule,_that.anchorTime,_that.tasks);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String? placeId,  String title,  String scheduleType,  String? rrule,  String? anchorTime,  List<RoutineTask> tasks)  $default,) {final _that = this;
switch (_that) {
case _Routine():
return $default(_that.id,_that.placeId,_that.title,_that.scheduleType,_that.rrule,_that.anchorTime,_that.tasks);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String? placeId,  String title,  String scheduleType,  String? rrule,  String? anchorTime,  List<RoutineTask> tasks)?  $default,) {final _that = this;
switch (_that) {
case _Routine() when $default != null:
return $default(_that.id,_that.placeId,_that.title,_that.scheduleType,_that.rrule,_that.anchorTime,_that.tasks);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Routine implements Routine {
  const _Routine({required this.id, this.placeId, required this.title, required this.scheduleType, this.rrule, this.anchorTime, required final  List<RoutineTask> tasks}): _tasks = tasks;
  factory _Routine.fromJson(Map<String, dynamic> json) => _$RoutineFromJson(json);

@override final  String id;
@override final  String? placeId;
// null = 시간 기반
@override final  String title;
@override final  String scheduleType;
// "time" | "place"
@override final  String? rrule;
@override final  String? anchorTime;
 final  List<RoutineTask> _tasks;
@override List<RoutineTask> get tasks {
  if (_tasks is EqualUnmodifiableListView) return _tasks;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tasks);
}


/// Create a copy of Routine
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RoutineCopyWith<_Routine> get copyWith => __$RoutineCopyWithImpl<_Routine>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RoutineToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Routine&&(identical(other.id, id) || other.id == id)&&(identical(other.placeId, placeId) || other.placeId == placeId)&&(identical(other.title, title) || other.title == title)&&(identical(other.scheduleType, scheduleType) || other.scheduleType == scheduleType)&&(identical(other.rrule, rrule) || other.rrule == rrule)&&(identical(other.anchorTime, anchorTime) || other.anchorTime == anchorTime)&&const DeepCollectionEquality().equals(other._tasks, _tasks));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,placeId,title,scheduleType,rrule,anchorTime,const DeepCollectionEquality().hash(_tasks));

@override
String toString() {
  return 'Routine(id: $id, placeId: $placeId, title: $title, scheduleType: $scheduleType, rrule: $rrule, anchorTime: $anchorTime, tasks: $tasks)';
}


}

/// @nodoc
abstract mixin class _$RoutineCopyWith<$Res> implements $RoutineCopyWith<$Res> {
  factory _$RoutineCopyWith(_Routine value, $Res Function(_Routine) _then) = __$RoutineCopyWithImpl;
@override @useResult
$Res call({
 String id, String? placeId, String title, String scheduleType, String? rrule, String? anchorTime, List<RoutineTask> tasks
});




}
/// @nodoc
class __$RoutineCopyWithImpl<$Res>
    implements _$RoutineCopyWith<$Res> {
  __$RoutineCopyWithImpl(this._self, this._then);

  final _Routine _self;
  final $Res Function(_Routine) _then;

/// Create a copy of Routine
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? placeId = freezed,Object? title = null,Object? scheduleType = null,Object? rrule = freezed,Object? anchorTime = freezed,Object? tasks = null,}) {
  return _then(_Routine(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,placeId: freezed == placeId ? _self.placeId : placeId // ignore: cast_nullable_to_non_nullable
as String?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,scheduleType: null == scheduleType ? _self.scheduleType : scheduleType // ignore: cast_nullable_to_non_nullable
as String,rrule: freezed == rrule ? _self.rrule : rrule // ignore: cast_nullable_to_non_nullable
as String?,anchorTime: freezed == anchorTime ? _self.anchorTime : anchorTime // ignore: cast_nullable_to_non_nullable
as String?,tasks: null == tasks ? _self._tasks : tasks // ignore: cast_nullable_to_non_nullable
as List<RoutineTask>,
  ));
}


}

// dart format on
