// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'adjustment.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Adjustment {

 String get routineTaskId; String get beforeActionId; String get afterActionId; String get triggerType;// red_signal | streak_up | user_manual
 String get reason;
/// Create a copy of Adjustment
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdjustmentCopyWith<Adjustment> get copyWith => _$AdjustmentCopyWithImpl<Adjustment>(this as Adjustment, _$identity);

  /// Serializes this Adjustment to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Adjustment&&(identical(other.routineTaskId, routineTaskId) || other.routineTaskId == routineTaskId)&&(identical(other.beforeActionId, beforeActionId) || other.beforeActionId == beforeActionId)&&(identical(other.afterActionId, afterActionId) || other.afterActionId == afterActionId)&&(identical(other.triggerType, triggerType) || other.triggerType == triggerType)&&(identical(other.reason, reason) || other.reason == reason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,routineTaskId,beforeActionId,afterActionId,triggerType,reason);

@override
String toString() {
  return 'Adjustment(routineTaskId: $routineTaskId, beforeActionId: $beforeActionId, afterActionId: $afterActionId, triggerType: $triggerType, reason: $reason)';
}


}

/// @nodoc
abstract mixin class $AdjustmentCopyWith<$Res>  {
  factory $AdjustmentCopyWith(Adjustment value, $Res Function(Adjustment) _then) = _$AdjustmentCopyWithImpl;
@useResult
$Res call({
 String routineTaskId, String beforeActionId, String afterActionId, String triggerType, String reason
});




}
/// @nodoc
class _$AdjustmentCopyWithImpl<$Res>
    implements $AdjustmentCopyWith<$Res> {
  _$AdjustmentCopyWithImpl(this._self, this._then);

  final Adjustment _self;
  final $Res Function(Adjustment) _then;

/// Create a copy of Adjustment
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? routineTaskId = null,Object? beforeActionId = null,Object? afterActionId = null,Object? triggerType = null,Object? reason = null,}) {
  return _then(_self.copyWith(
routineTaskId: null == routineTaskId ? _self.routineTaskId : routineTaskId // ignore: cast_nullable_to_non_nullable
as String,beforeActionId: null == beforeActionId ? _self.beforeActionId : beforeActionId // ignore: cast_nullable_to_non_nullable
as String,afterActionId: null == afterActionId ? _self.afterActionId : afterActionId // ignore: cast_nullable_to_non_nullable
as String,triggerType: null == triggerType ? _self.triggerType : triggerType // ignore: cast_nullable_to_non_nullable
as String,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [Adjustment].
extension AdjustmentPatterns on Adjustment {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Adjustment value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Adjustment() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Adjustment value)  $default,){
final _that = this;
switch (_that) {
case _Adjustment():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Adjustment value)?  $default,){
final _that = this;
switch (_that) {
case _Adjustment() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String routineTaskId,  String beforeActionId,  String afterActionId,  String triggerType,  String reason)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Adjustment() when $default != null:
return $default(_that.routineTaskId,_that.beforeActionId,_that.afterActionId,_that.triggerType,_that.reason);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String routineTaskId,  String beforeActionId,  String afterActionId,  String triggerType,  String reason)  $default,) {final _that = this;
switch (_that) {
case _Adjustment():
return $default(_that.routineTaskId,_that.beforeActionId,_that.afterActionId,_that.triggerType,_that.reason);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String routineTaskId,  String beforeActionId,  String afterActionId,  String triggerType,  String reason)?  $default,) {final _that = this;
switch (_that) {
case _Adjustment() when $default != null:
return $default(_that.routineTaskId,_that.beforeActionId,_that.afterActionId,_that.triggerType,_that.reason);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Adjustment implements Adjustment {
  const _Adjustment({required this.routineTaskId, required this.beforeActionId, required this.afterActionId, required this.triggerType, required this.reason});
  factory _Adjustment.fromJson(Map<String, dynamic> json) => _$AdjustmentFromJson(json);

@override final  String routineTaskId;
@override final  String beforeActionId;
@override final  String afterActionId;
@override final  String triggerType;
// red_signal | streak_up | user_manual
@override final  String reason;

/// Create a copy of Adjustment
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdjustmentCopyWith<_Adjustment> get copyWith => __$AdjustmentCopyWithImpl<_Adjustment>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AdjustmentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Adjustment&&(identical(other.routineTaskId, routineTaskId) || other.routineTaskId == routineTaskId)&&(identical(other.beforeActionId, beforeActionId) || other.beforeActionId == beforeActionId)&&(identical(other.afterActionId, afterActionId) || other.afterActionId == afterActionId)&&(identical(other.triggerType, triggerType) || other.triggerType == triggerType)&&(identical(other.reason, reason) || other.reason == reason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,routineTaskId,beforeActionId,afterActionId,triggerType,reason);

@override
String toString() {
  return 'Adjustment(routineTaskId: $routineTaskId, beforeActionId: $beforeActionId, afterActionId: $afterActionId, triggerType: $triggerType, reason: $reason)';
}


}

/// @nodoc
abstract mixin class _$AdjustmentCopyWith<$Res> implements $AdjustmentCopyWith<$Res> {
  factory _$AdjustmentCopyWith(_Adjustment value, $Res Function(_Adjustment) _then) = __$AdjustmentCopyWithImpl;
@override @useResult
$Res call({
 String routineTaskId, String beforeActionId, String afterActionId, String triggerType, String reason
});




}
/// @nodoc
class __$AdjustmentCopyWithImpl<$Res>
    implements _$AdjustmentCopyWith<$Res> {
  __$AdjustmentCopyWithImpl(this._self, this._then);

  final _Adjustment _self;
  final $Res Function(_Adjustment) _then;

/// Create a copy of Adjustment
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? routineTaskId = null,Object? beforeActionId = null,Object? afterActionId = null,Object? triggerType = null,Object? reason = null,}) {
  return _then(_Adjustment(
routineTaskId: null == routineTaskId ? _self.routineTaskId : routineTaskId // ignore: cast_nullable_to_non_nullable
as String,beforeActionId: null == beforeActionId ? _self.beforeActionId : beforeActionId // ignore: cast_nullable_to_non_nullable
as String,afterActionId: null == afterActionId ? _self.afterActionId : afterActionId // ignore: cast_nullable_to_non_nullable
as String,triggerType: null == triggerType ? _self.triggerType : triggerType // ignore: cast_nullable_to_non_nullable
as String,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
