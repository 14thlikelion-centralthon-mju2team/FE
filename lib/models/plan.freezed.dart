// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'plan.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PlanReason {

 String get field;// breakdown 필드명 (estimatedPrepMinutes 등)
 String get source;// estimate | prepRule | routeProvider | environment
 bool get adjusted; String get text; int? get sampleCount;
/// Create a copy of PlanReason
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlanReasonCopyWith<PlanReason> get copyWith => _$PlanReasonCopyWithImpl<PlanReason>(this as PlanReason, _$identity);

  /// Serializes this PlanReason to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlanReason&&(identical(other.field, field) || other.field == field)&&(identical(other.source, source) || other.source == source)&&(identical(other.adjusted, adjusted) || other.adjusted == adjusted)&&(identical(other.text, text) || other.text == text)&&(identical(other.sampleCount, sampleCount) || other.sampleCount == sampleCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,field,source,adjusted,text,sampleCount);

@override
String toString() {
  return 'PlanReason(field: $field, source: $source, adjusted: $adjusted, text: $text, sampleCount: $sampleCount)';
}


}

/// @nodoc
abstract mixin class $PlanReasonCopyWith<$Res>  {
  factory $PlanReasonCopyWith(PlanReason value, $Res Function(PlanReason) _then) = _$PlanReasonCopyWithImpl;
@useResult
$Res call({
 String field, String source, bool adjusted, String text, int? sampleCount
});




}
/// @nodoc
class _$PlanReasonCopyWithImpl<$Res>
    implements $PlanReasonCopyWith<$Res> {
  _$PlanReasonCopyWithImpl(this._self, this._then);

  final PlanReason _self;
  final $Res Function(PlanReason) _then;

/// Create a copy of PlanReason
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? field = null,Object? source = null,Object? adjusted = null,Object? text = null,Object? sampleCount = freezed,}) {
  return _then(_self.copyWith(
field: null == field ? _self.field : field // ignore: cast_nullable_to_non_nullable
as String,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String,adjusted: null == adjusted ? _self.adjusted : adjusted // ignore: cast_nullable_to_non_nullable
as bool,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,sampleCount: freezed == sampleCount ? _self.sampleCount : sampleCount // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [PlanReason].
extension PlanReasonPatterns on PlanReason {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PlanReason value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PlanReason() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PlanReason value)  $default,){
final _that = this;
switch (_that) {
case _PlanReason():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PlanReason value)?  $default,){
final _that = this;
switch (_that) {
case _PlanReason() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String field,  String source,  bool adjusted,  String text,  int? sampleCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PlanReason() when $default != null:
return $default(_that.field,_that.source,_that.adjusted,_that.text,_that.sampleCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String field,  String source,  bool adjusted,  String text,  int? sampleCount)  $default,) {final _that = this;
switch (_that) {
case _PlanReason():
return $default(_that.field,_that.source,_that.adjusted,_that.text,_that.sampleCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String field,  String source,  bool adjusted,  String text,  int? sampleCount)?  $default,) {final _that = this;
switch (_that) {
case _PlanReason() when $default != null:
return $default(_that.field,_that.source,_that.adjusted,_that.text,_that.sampleCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PlanReason implements PlanReason {
  const _PlanReason({required this.field, required this.source, required this.adjusted, required this.text, this.sampleCount});
  factory _PlanReason.fromJson(Map<String, dynamic> json) => _$PlanReasonFromJson(json);

@override final  String field;
// breakdown 필드명 (estimatedPrepMinutes 등)
@override final  String source;
// estimate | prepRule | routeProvider | environment
@override final  bool adjusted;
@override final  String text;
@override final  int? sampleCount;

/// Create a copy of PlanReason
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlanReasonCopyWith<_PlanReason> get copyWith => __$PlanReasonCopyWithImpl<_PlanReason>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PlanReasonToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlanReason&&(identical(other.field, field) || other.field == field)&&(identical(other.source, source) || other.source == source)&&(identical(other.adjusted, adjusted) || other.adjusted == adjusted)&&(identical(other.text, text) || other.text == text)&&(identical(other.sampleCount, sampleCount) || other.sampleCount == sampleCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,field,source,adjusted,text,sampleCount);

@override
String toString() {
  return 'PlanReason(field: $field, source: $source, adjusted: $adjusted, text: $text, sampleCount: $sampleCount)';
}


}

/// @nodoc
abstract mixin class _$PlanReasonCopyWith<$Res> implements $PlanReasonCopyWith<$Res> {
  factory _$PlanReasonCopyWith(_PlanReason value, $Res Function(_PlanReason) _then) = __$PlanReasonCopyWithImpl;
@override @useResult
$Res call({
 String field, String source, bool adjusted, String text, int? sampleCount
});




}
/// @nodoc
class __$PlanReasonCopyWithImpl<$Res>
    implements _$PlanReasonCopyWith<$Res> {
  __$PlanReasonCopyWithImpl(this._self, this._then);

  final _PlanReason _self;
  final $Res Function(_PlanReason) _then;

/// Create a copy of PlanReason
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? field = null,Object? source = null,Object? adjusted = null,Object? text = null,Object? sampleCount = freezed,}) {
  return _then(_PlanReason(
field: null == field ? _self.field : field // ignore: cast_nullable_to_non_nullable
as String,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String,adjusted: null == adjusted ? _self.adjusted : adjusted // ignore: cast_nullable_to_non_nullable
as bool,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,sampleCount: freezed == sampleCount ? _self.sampleCount : sampleCount // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$PlanBreakdown {

 int get estimatedPrepMinutes; int get extraPrepMinutes; int get personalRoutineMinutes; int get travelMinutes; int get trafficBufferMinutes; int get arrivalBufferMinutes;
/// Create a copy of PlanBreakdown
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlanBreakdownCopyWith<PlanBreakdown> get copyWith => _$PlanBreakdownCopyWithImpl<PlanBreakdown>(this as PlanBreakdown, _$identity);

  /// Serializes this PlanBreakdown to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlanBreakdown&&(identical(other.estimatedPrepMinutes, estimatedPrepMinutes) || other.estimatedPrepMinutes == estimatedPrepMinutes)&&(identical(other.extraPrepMinutes, extraPrepMinutes) || other.extraPrepMinutes == extraPrepMinutes)&&(identical(other.personalRoutineMinutes, personalRoutineMinutes) || other.personalRoutineMinutes == personalRoutineMinutes)&&(identical(other.travelMinutes, travelMinutes) || other.travelMinutes == travelMinutes)&&(identical(other.trafficBufferMinutes, trafficBufferMinutes) || other.trafficBufferMinutes == trafficBufferMinutes)&&(identical(other.arrivalBufferMinutes, arrivalBufferMinutes) || other.arrivalBufferMinutes == arrivalBufferMinutes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,estimatedPrepMinutes,extraPrepMinutes,personalRoutineMinutes,travelMinutes,trafficBufferMinutes,arrivalBufferMinutes);

@override
String toString() {
  return 'PlanBreakdown(estimatedPrepMinutes: $estimatedPrepMinutes, extraPrepMinutes: $extraPrepMinutes, personalRoutineMinutes: $personalRoutineMinutes, travelMinutes: $travelMinutes, trafficBufferMinutes: $trafficBufferMinutes, arrivalBufferMinutes: $arrivalBufferMinutes)';
}


}

/// @nodoc
abstract mixin class $PlanBreakdownCopyWith<$Res>  {
  factory $PlanBreakdownCopyWith(PlanBreakdown value, $Res Function(PlanBreakdown) _then) = _$PlanBreakdownCopyWithImpl;
@useResult
$Res call({
 int estimatedPrepMinutes, int extraPrepMinutes, int personalRoutineMinutes, int travelMinutes, int trafficBufferMinutes, int arrivalBufferMinutes
});




}
/// @nodoc
class _$PlanBreakdownCopyWithImpl<$Res>
    implements $PlanBreakdownCopyWith<$Res> {
  _$PlanBreakdownCopyWithImpl(this._self, this._then);

  final PlanBreakdown _self;
  final $Res Function(PlanBreakdown) _then;

/// Create a copy of PlanBreakdown
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? estimatedPrepMinutes = null,Object? extraPrepMinutes = null,Object? personalRoutineMinutes = null,Object? travelMinutes = null,Object? trafficBufferMinutes = null,Object? arrivalBufferMinutes = null,}) {
  return _then(_self.copyWith(
estimatedPrepMinutes: null == estimatedPrepMinutes ? _self.estimatedPrepMinutes : estimatedPrepMinutes // ignore: cast_nullable_to_non_nullable
as int,extraPrepMinutes: null == extraPrepMinutes ? _self.extraPrepMinutes : extraPrepMinutes // ignore: cast_nullable_to_non_nullable
as int,personalRoutineMinutes: null == personalRoutineMinutes ? _self.personalRoutineMinutes : personalRoutineMinutes // ignore: cast_nullable_to_non_nullable
as int,travelMinutes: null == travelMinutes ? _self.travelMinutes : travelMinutes // ignore: cast_nullable_to_non_nullable
as int,trafficBufferMinutes: null == trafficBufferMinutes ? _self.trafficBufferMinutes : trafficBufferMinutes // ignore: cast_nullable_to_non_nullable
as int,arrivalBufferMinutes: null == arrivalBufferMinutes ? _self.arrivalBufferMinutes : arrivalBufferMinutes // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [PlanBreakdown].
extension PlanBreakdownPatterns on PlanBreakdown {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PlanBreakdown value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PlanBreakdown() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PlanBreakdown value)  $default,){
final _that = this;
switch (_that) {
case _PlanBreakdown():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PlanBreakdown value)?  $default,){
final _that = this;
switch (_that) {
case _PlanBreakdown() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int estimatedPrepMinutes,  int extraPrepMinutes,  int personalRoutineMinutes,  int travelMinutes,  int trafficBufferMinutes,  int arrivalBufferMinutes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PlanBreakdown() when $default != null:
return $default(_that.estimatedPrepMinutes,_that.extraPrepMinutes,_that.personalRoutineMinutes,_that.travelMinutes,_that.trafficBufferMinutes,_that.arrivalBufferMinutes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int estimatedPrepMinutes,  int extraPrepMinutes,  int personalRoutineMinutes,  int travelMinutes,  int trafficBufferMinutes,  int arrivalBufferMinutes)  $default,) {final _that = this;
switch (_that) {
case _PlanBreakdown():
return $default(_that.estimatedPrepMinutes,_that.extraPrepMinutes,_that.personalRoutineMinutes,_that.travelMinutes,_that.trafficBufferMinutes,_that.arrivalBufferMinutes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int estimatedPrepMinutes,  int extraPrepMinutes,  int personalRoutineMinutes,  int travelMinutes,  int trafficBufferMinutes,  int arrivalBufferMinutes)?  $default,) {final _that = this;
switch (_that) {
case _PlanBreakdown() when $default != null:
return $default(_that.estimatedPrepMinutes,_that.extraPrepMinutes,_that.personalRoutineMinutes,_that.travelMinutes,_that.trafficBufferMinutes,_that.arrivalBufferMinutes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PlanBreakdown implements PlanBreakdown {
  const _PlanBreakdown({required this.estimatedPrepMinutes, required this.extraPrepMinutes, required this.personalRoutineMinutes, required this.travelMinutes, required this.trafficBufferMinutes, required this.arrivalBufferMinutes});
  factory _PlanBreakdown.fromJson(Map<String, dynamic> json) => _$PlanBreakdownFromJson(json);

@override final  int estimatedPrepMinutes;
@override final  int extraPrepMinutes;
@override final  int personalRoutineMinutes;
@override final  int travelMinutes;
@override final  int trafficBufferMinutes;
@override final  int arrivalBufferMinutes;

/// Create a copy of PlanBreakdown
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlanBreakdownCopyWith<_PlanBreakdown> get copyWith => __$PlanBreakdownCopyWithImpl<_PlanBreakdown>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PlanBreakdownToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlanBreakdown&&(identical(other.estimatedPrepMinutes, estimatedPrepMinutes) || other.estimatedPrepMinutes == estimatedPrepMinutes)&&(identical(other.extraPrepMinutes, extraPrepMinutes) || other.extraPrepMinutes == extraPrepMinutes)&&(identical(other.personalRoutineMinutes, personalRoutineMinutes) || other.personalRoutineMinutes == personalRoutineMinutes)&&(identical(other.travelMinutes, travelMinutes) || other.travelMinutes == travelMinutes)&&(identical(other.trafficBufferMinutes, trafficBufferMinutes) || other.trafficBufferMinutes == trafficBufferMinutes)&&(identical(other.arrivalBufferMinutes, arrivalBufferMinutes) || other.arrivalBufferMinutes == arrivalBufferMinutes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,estimatedPrepMinutes,extraPrepMinutes,personalRoutineMinutes,travelMinutes,trafficBufferMinutes,arrivalBufferMinutes);

@override
String toString() {
  return 'PlanBreakdown(estimatedPrepMinutes: $estimatedPrepMinutes, extraPrepMinutes: $extraPrepMinutes, personalRoutineMinutes: $personalRoutineMinutes, travelMinutes: $travelMinutes, trafficBufferMinutes: $trafficBufferMinutes, arrivalBufferMinutes: $arrivalBufferMinutes)';
}


}

/// @nodoc
abstract mixin class _$PlanBreakdownCopyWith<$Res> implements $PlanBreakdownCopyWith<$Res> {
  factory _$PlanBreakdownCopyWith(_PlanBreakdown value, $Res Function(_PlanBreakdown) _then) = __$PlanBreakdownCopyWithImpl;
@override @useResult
$Res call({
 int estimatedPrepMinutes, int extraPrepMinutes, int personalRoutineMinutes, int travelMinutes, int trafficBufferMinutes, int arrivalBufferMinutes
});




}
/// @nodoc
class __$PlanBreakdownCopyWithImpl<$Res>
    implements _$PlanBreakdownCopyWith<$Res> {
  __$PlanBreakdownCopyWithImpl(this._self, this._then);

  final _PlanBreakdown _self;
  final $Res Function(_PlanBreakdown) _then;

/// Create a copy of PlanBreakdown
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? estimatedPrepMinutes = null,Object? extraPrepMinutes = null,Object? personalRoutineMinutes = null,Object? travelMinutes = null,Object? trafficBufferMinutes = null,Object? arrivalBufferMinutes = null,}) {
  return _then(_PlanBreakdown(
estimatedPrepMinutes: null == estimatedPrepMinutes ? _self.estimatedPrepMinutes : estimatedPrepMinutes // ignore: cast_nullable_to_non_nullable
as int,extraPrepMinutes: null == extraPrepMinutes ? _self.extraPrepMinutes : extraPrepMinutes // ignore: cast_nullable_to_non_nullable
as int,personalRoutineMinutes: null == personalRoutineMinutes ? _self.personalRoutineMinutes : personalRoutineMinutes // ignore: cast_nullable_to_non_nullable
as int,travelMinutes: null == travelMinutes ? _self.travelMinutes : travelMinutes // ignore: cast_nullable_to_non_nullable
as int,trafficBufferMinutes: null == trafficBufferMinutes ? _self.trafficBufferMinutes : trafficBufferMinutes // ignore: cast_nullable_to_non_nullable
as int,arrivalBufferMinutes: null == arrivalBufferMinutes ? _self.arrivalBufferMinutes : arrivalBufferMinutes // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$ChecklistItem {

 String get planPrepItemId; String get itemName; PrepActionType get actionType; ChecklistSourceType get sourceType; ChecklistCompletionStatus get completionStatus; bool get isSensitive; int get appliedMinutes; String? get reason;
/// Create a copy of ChecklistItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChecklistItemCopyWith<ChecklistItem> get copyWith => _$ChecklistItemCopyWithImpl<ChecklistItem>(this as ChecklistItem, _$identity);

  /// Serializes this ChecklistItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChecklistItem&&(identical(other.planPrepItemId, planPrepItemId) || other.planPrepItemId == planPrepItemId)&&(identical(other.itemName, itemName) || other.itemName == itemName)&&(identical(other.actionType, actionType) || other.actionType == actionType)&&(identical(other.sourceType, sourceType) || other.sourceType == sourceType)&&(identical(other.completionStatus, completionStatus) || other.completionStatus == completionStatus)&&(identical(other.isSensitive, isSensitive) || other.isSensitive == isSensitive)&&(identical(other.appliedMinutes, appliedMinutes) || other.appliedMinutes == appliedMinutes)&&(identical(other.reason, reason) || other.reason == reason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,planPrepItemId,itemName,actionType,sourceType,completionStatus,isSensitive,appliedMinutes,reason);

@override
String toString() {
  return 'ChecklistItem(planPrepItemId: $planPrepItemId, itemName: $itemName, actionType: $actionType, sourceType: $sourceType, completionStatus: $completionStatus, isSensitive: $isSensitive, appliedMinutes: $appliedMinutes, reason: $reason)';
}


}

/// @nodoc
abstract mixin class $ChecklistItemCopyWith<$Res>  {
  factory $ChecklistItemCopyWith(ChecklistItem value, $Res Function(ChecklistItem) _then) = _$ChecklistItemCopyWithImpl;
@useResult
$Res call({
 String planPrepItemId, String itemName, PrepActionType actionType, ChecklistSourceType sourceType, ChecklistCompletionStatus completionStatus, bool isSensitive, int appliedMinutes, String? reason
});




}
/// @nodoc
class _$ChecklistItemCopyWithImpl<$Res>
    implements $ChecklistItemCopyWith<$Res> {
  _$ChecklistItemCopyWithImpl(this._self, this._then);

  final ChecklistItem _self;
  final $Res Function(ChecklistItem) _then;

/// Create a copy of ChecklistItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? planPrepItemId = null,Object? itemName = null,Object? actionType = null,Object? sourceType = null,Object? completionStatus = null,Object? isSensitive = null,Object? appliedMinutes = null,Object? reason = freezed,}) {
  return _then(_self.copyWith(
planPrepItemId: null == planPrepItemId ? _self.planPrepItemId : planPrepItemId // ignore: cast_nullable_to_non_nullable
as String,itemName: null == itemName ? _self.itemName : itemName // ignore: cast_nullable_to_non_nullable
as String,actionType: null == actionType ? _self.actionType : actionType // ignore: cast_nullable_to_non_nullable
as PrepActionType,sourceType: null == sourceType ? _self.sourceType : sourceType // ignore: cast_nullable_to_non_nullable
as ChecklistSourceType,completionStatus: null == completionStatus ? _self.completionStatus : completionStatus // ignore: cast_nullable_to_non_nullable
as ChecklistCompletionStatus,isSensitive: null == isSensitive ? _self.isSensitive : isSensitive // ignore: cast_nullable_to_non_nullable
as bool,appliedMinutes: null == appliedMinutes ? _self.appliedMinutes : appliedMinutes // ignore: cast_nullable_to_non_nullable
as int,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ChecklistItem].
extension ChecklistItemPatterns on ChecklistItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChecklistItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChecklistItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChecklistItem value)  $default,){
final _that = this;
switch (_that) {
case _ChecklistItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChecklistItem value)?  $default,){
final _that = this;
switch (_that) {
case _ChecklistItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String planPrepItemId,  String itemName,  PrepActionType actionType,  ChecklistSourceType sourceType,  ChecklistCompletionStatus completionStatus,  bool isSensitive,  int appliedMinutes,  String? reason)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChecklistItem() when $default != null:
return $default(_that.planPrepItemId,_that.itemName,_that.actionType,_that.sourceType,_that.completionStatus,_that.isSensitive,_that.appliedMinutes,_that.reason);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String planPrepItemId,  String itemName,  PrepActionType actionType,  ChecklistSourceType sourceType,  ChecklistCompletionStatus completionStatus,  bool isSensitive,  int appliedMinutes,  String? reason)  $default,) {final _that = this;
switch (_that) {
case _ChecklistItem():
return $default(_that.planPrepItemId,_that.itemName,_that.actionType,_that.sourceType,_that.completionStatus,_that.isSensitive,_that.appliedMinutes,_that.reason);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String planPrepItemId,  String itemName,  PrepActionType actionType,  ChecklistSourceType sourceType,  ChecklistCompletionStatus completionStatus,  bool isSensitive,  int appliedMinutes,  String? reason)?  $default,) {final _that = this;
switch (_that) {
case _ChecklistItem() when $default != null:
return $default(_that.planPrepItemId,_that.itemName,_that.actionType,_that.sourceType,_that.completionStatus,_that.isSensitive,_that.appliedMinutes,_that.reason);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChecklistItem implements ChecklistItem {
  const _ChecklistItem({required this.planPrepItemId, required this.itemName, required this.actionType, required this.sourceType, required this.completionStatus, this.isSensitive = false, this.appliedMinutes = 0, this.reason});
  factory _ChecklistItem.fromJson(Map<String, dynamic> json) => _$ChecklistItemFromJson(json);

@override final  String planPrepItemId;
@override final  String itemName;
@override final  PrepActionType actionType;
@override final  ChecklistSourceType sourceType;
@override final  ChecklistCompletionStatus completionStatus;
@override@JsonKey() final  bool isSensitive;
@override@JsonKey() final  int appliedMinutes;
@override final  String? reason;

/// Create a copy of ChecklistItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChecklistItemCopyWith<_ChecklistItem> get copyWith => __$ChecklistItemCopyWithImpl<_ChecklistItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChecklistItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChecklistItem&&(identical(other.planPrepItemId, planPrepItemId) || other.planPrepItemId == planPrepItemId)&&(identical(other.itemName, itemName) || other.itemName == itemName)&&(identical(other.actionType, actionType) || other.actionType == actionType)&&(identical(other.sourceType, sourceType) || other.sourceType == sourceType)&&(identical(other.completionStatus, completionStatus) || other.completionStatus == completionStatus)&&(identical(other.isSensitive, isSensitive) || other.isSensitive == isSensitive)&&(identical(other.appliedMinutes, appliedMinutes) || other.appliedMinutes == appliedMinutes)&&(identical(other.reason, reason) || other.reason == reason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,planPrepItemId,itemName,actionType,sourceType,completionStatus,isSensitive,appliedMinutes,reason);

@override
String toString() {
  return 'ChecklistItem(planPrepItemId: $planPrepItemId, itemName: $itemName, actionType: $actionType, sourceType: $sourceType, completionStatus: $completionStatus, isSensitive: $isSensitive, appliedMinutes: $appliedMinutes, reason: $reason)';
}


}

/// @nodoc
abstract mixin class _$ChecklistItemCopyWith<$Res> implements $ChecklistItemCopyWith<$Res> {
  factory _$ChecklistItemCopyWith(_ChecklistItem value, $Res Function(_ChecklistItem) _then) = __$ChecklistItemCopyWithImpl;
@override @useResult
$Res call({
 String planPrepItemId, String itemName, PrepActionType actionType, ChecklistSourceType sourceType, ChecklistCompletionStatus completionStatus, bool isSensitive, int appliedMinutes, String? reason
});




}
/// @nodoc
class __$ChecklistItemCopyWithImpl<$Res>
    implements _$ChecklistItemCopyWith<$Res> {
  __$ChecklistItemCopyWithImpl(this._self, this._then);

  final _ChecklistItem _self;
  final $Res Function(_ChecklistItem) _then;

/// Create a copy of ChecklistItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? planPrepItemId = null,Object? itemName = null,Object? actionType = null,Object? sourceType = null,Object? completionStatus = null,Object? isSensitive = null,Object? appliedMinutes = null,Object? reason = freezed,}) {
  return _then(_ChecklistItem(
planPrepItemId: null == planPrepItemId ? _self.planPrepItemId : planPrepItemId // ignore: cast_nullable_to_non_nullable
as String,itemName: null == itemName ? _self.itemName : itemName // ignore: cast_nullable_to_non_nullable
as String,actionType: null == actionType ? _self.actionType : actionType // ignore: cast_nullable_to_non_nullable
as PrepActionType,sourceType: null == sourceType ? _self.sourceType : sourceType // ignore: cast_nullable_to_non_nullable
as ChecklistSourceType,completionStatus: null == completionStatus ? _self.completionStatus : completionStatus // ignore: cast_nullable_to_non_nullable
as ChecklistCompletionStatus,isSensitive: null == isSensitive ? _self.isSensitive : isSensitive // ignore: cast_nullable_to_non_nullable
as bool,appliedMinutes: null == appliedMinutes ? _self.appliedMinutes : appliedMinutes // ignore: cast_nullable_to_non_nullable
as int,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$WellnessAction {

 String get wellnessActionId; String get wellnessTopic; String get actionCode; String get actionLabel; int get displayRank; String? get reasonSnapshot; WellnessActionCompletionStatus get completionStatus;
/// Create a copy of WellnessAction
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WellnessActionCopyWith<WellnessAction> get copyWith => _$WellnessActionCopyWithImpl<WellnessAction>(this as WellnessAction, _$identity);

  /// Serializes this WellnessAction to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WellnessAction&&(identical(other.wellnessActionId, wellnessActionId) || other.wellnessActionId == wellnessActionId)&&(identical(other.wellnessTopic, wellnessTopic) || other.wellnessTopic == wellnessTopic)&&(identical(other.actionCode, actionCode) || other.actionCode == actionCode)&&(identical(other.actionLabel, actionLabel) || other.actionLabel == actionLabel)&&(identical(other.displayRank, displayRank) || other.displayRank == displayRank)&&(identical(other.reasonSnapshot, reasonSnapshot) || other.reasonSnapshot == reasonSnapshot)&&(identical(other.completionStatus, completionStatus) || other.completionStatus == completionStatus));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,wellnessActionId,wellnessTopic,actionCode,actionLabel,displayRank,reasonSnapshot,completionStatus);

@override
String toString() {
  return 'WellnessAction(wellnessActionId: $wellnessActionId, wellnessTopic: $wellnessTopic, actionCode: $actionCode, actionLabel: $actionLabel, displayRank: $displayRank, reasonSnapshot: $reasonSnapshot, completionStatus: $completionStatus)';
}


}

/// @nodoc
abstract mixin class $WellnessActionCopyWith<$Res>  {
  factory $WellnessActionCopyWith(WellnessAction value, $Res Function(WellnessAction) _then) = _$WellnessActionCopyWithImpl;
@useResult
$Res call({
 String wellnessActionId, String wellnessTopic, String actionCode, String actionLabel, int displayRank, String? reasonSnapshot, WellnessActionCompletionStatus completionStatus
});




}
/// @nodoc
class _$WellnessActionCopyWithImpl<$Res>
    implements $WellnessActionCopyWith<$Res> {
  _$WellnessActionCopyWithImpl(this._self, this._then);

  final WellnessAction _self;
  final $Res Function(WellnessAction) _then;

/// Create a copy of WellnessAction
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? wellnessActionId = null,Object? wellnessTopic = null,Object? actionCode = null,Object? actionLabel = null,Object? displayRank = null,Object? reasonSnapshot = freezed,Object? completionStatus = null,}) {
  return _then(_self.copyWith(
wellnessActionId: null == wellnessActionId ? _self.wellnessActionId : wellnessActionId // ignore: cast_nullable_to_non_nullable
as String,wellnessTopic: null == wellnessTopic ? _self.wellnessTopic : wellnessTopic // ignore: cast_nullable_to_non_nullable
as String,actionCode: null == actionCode ? _self.actionCode : actionCode // ignore: cast_nullable_to_non_nullable
as String,actionLabel: null == actionLabel ? _self.actionLabel : actionLabel // ignore: cast_nullable_to_non_nullable
as String,displayRank: null == displayRank ? _self.displayRank : displayRank // ignore: cast_nullable_to_non_nullable
as int,reasonSnapshot: freezed == reasonSnapshot ? _self.reasonSnapshot : reasonSnapshot // ignore: cast_nullable_to_non_nullable
as String?,completionStatus: null == completionStatus ? _self.completionStatus : completionStatus // ignore: cast_nullable_to_non_nullable
as WellnessActionCompletionStatus,
  ));
}

}


/// Adds pattern-matching-related methods to [WellnessAction].
extension WellnessActionPatterns on WellnessAction {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WellnessAction value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WellnessAction() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WellnessAction value)  $default,){
final _that = this;
switch (_that) {
case _WellnessAction():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WellnessAction value)?  $default,){
final _that = this;
switch (_that) {
case _WellnessAction() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String wellnessActionId,  String wellnessTopic,  String actionCode,  String actionLabel,  int displayRank,  String? reasonSnapshot,  WellnessActionCompletionStatus completionStatus)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WellnessAction() when $default != null:
return $default(_that.wellnessActionId,_that.wellnessTopic,_that.actionCode,_that.actionLabel,_that.displayRank,_that.reasonSnapshot,_that.completionStatus);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String wellnessActionId,  String wellnessTopic,  String actionCode,  String actionLabel,  int displayRank,  String? reasonSnapshot,  WellnessActionCompletionStatus completionStatus)  $default,) {final _that = this;
switch (_that) {
case _WellnessAction():
return $default(_that.wellnessActionId,_that.wellnessTopic,_that.actionCode,_that.actionLabel,_that.displayRank,_that.reasonSnapshot,_that.completionStatus);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String wellnessActionId,  String wellnessTopic,  String actionCode,  String actionLabel,  int displayRank,  String? reasonSnapshot,  WellnessActionCompletionStatus completionStatus)?  $default,) {final _that = this;
switch (_that) {
case _WellnessAction() when $default != null:
return $default(_that.wellnessActionId,_that.wellnessTopic,_that.actionCode,_that.actionLabel,_that.displayRank,_that.reasonSnapshot,_that.completionStatus);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WellnessAction implements WellnessAction {
  const _WellnessAction({required this.wellnessActionId, required this.wellnessTopic, required this.actionCode, required this.actionLabel, required this.displayRank, this.reasonSnapshot, required this.completionStatus});
  factory _WellnessAction.fromJson(Map<String, dynamic> json) => _$WellnessActionFromJson(json);

@override final  String wellnessActionId;
@override final  String wellnessTopic;
@override final  String actionCode;
@override final  String actionLabel;
@override final  int displayRank;
@override final  String? reasonSnapshot;
@override final  WellnessActionCompletionStatus completionStatus;

/// Create a copy of WellnessAction
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WellnessActionCopyWith<_WellnessAction> get copyWith => __$WellnessActionCopyWithImpl<_WellnessAction>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WellnessActionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WellnessAction&&(identical(other.wellnessActionId, wellnessActionId) || other.wellnessActionId == wellnessActionId)&&(identical(other.wellnessTopic, wellnessTopic) || other.wellnessTopic == wellnessTopic)&&(identical(other.actionCode, actionCode) || other.actionCode == actionCode)&&(identical(other.actionLabel, actionLabel) || other.actionLabel == actionLabel)&&(identical(other.displayRank, displayRank) || other.displayRank == displayRank)&&(identical(other.reasonSnapshot, reasonSnapshot) || other.reasonSnapshot == reasonSnapshot)&&(identical(other.completionStatus, completionStatus) || other.completionStatus == completionStatus));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,wellnessActionId,wellnessTopic,actionCode,actionLabel,displayRank,reasonSnapshot,completionStatus);

@override
String toString() {
  return 'WellnessAction(wellnessActionId: $wellnessActionId, wellnessTopic: $wellnessTopic, actionCode: $actionCode, actionLabel: $actionLabel, displayRank: $displayRank, reasonSnapshot: $reasonSnapshot, completionStatus: $completionStatus)';
}


}

/// @nodoc
abstract mixin class _$WellnessActionCopyWith<$Res> implements $WellnessActionCopyWith<$Res> {
  factory _$WellnessActionCopyWith(_WellnessAction value, $Res Function(_WellnessAction) _then) = __$WellnessActionCopyWithImpl;
@override @useResult
$Res call({
 String wellnessActionId, String wellnessTopic, String actionCode, String actionLabel, int displayRank, String? reasonSnapshot, WellnessActionCompletionStatus completionStatus
});




}
/// @nodoc
class __$WellnessActionCopyWithImpl<$Res>
    implements _$WellnessActionCopyWith<$Res> {
  __$WellnessActionCopyWithImpl(this._self, this._then);

  final _WellnessAction _self;
  final $Res Function(_WellnessAction) _then;

/// Create a copy of WellnessAction
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? wellnessActionId = null,Object? wellnessTopic = null,Object? actionCode = null,Object? actionLabel = null,Object? displayRank = null,Object? reasonSnapshot = freezed,Object? completionStatus = null,}) {
  return _then(_WellnessAction(
wellnessActionId: null == wellnessActionId ? _self.wellnessActionId : wellnessActionId // ignore: cast_nullable_to_non_nullable
as String,wellnessTopic: null == wellnessTopic ? _self.wellnessTopic : wellnessTopic // ignore: cast_nullable_to_non_nullable
as String,actionCode: null == actionCode ? _self.actionCode : actionCode // ignore: cast_nullable_to_non_nullable
as String,actionLabel: null == actionLabel ? _self.actionLabel : actionLabel // ignore: cast_nullable_to_non_nullable
as String,displayRank: null == displayRank ? _self.displayRank : displayRank // ignore: cast_nullable_to_non_nullable
as int,reasonSnapshot: freezed == reasonSnapshot ? _self.reasonSnapshot : reasonSnapshot // ignore: cast_nullable_to_non_nullable
as String?,completionStatus: null == completionStatus ? _self.completionStatus : completionStatus // ignore: cast_nullable_to_non_nullable
as WellnessActionCompletionStatus,
  ));
}


}


/// @nodoc
mixin _$WellnessSummary {

 int get wisScore; WisBand get wisBand; String get weightVersion; bool get eventArmed;
/// Create a copy of WellnessSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WellnessSummaryCopyWith<WellnessSummary> get copyWith => _$WellnessSummaryCopyWithImpl<WellnessSummary>(this as WellnessSummary, _$identity);

  /// Serializes this WellnessSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WellnessSummary&&(identical(other.wisScore, wisScore) || other.wisScore == wisScore)&&(identical(other.wisBand, wisBand) || other.wisBand == wisBand)&&(identical(other.weightVersion, weightVersion) || other.weightVersion == weightVersion)&&(identical(other.eventArmed, eventArmed) || other.eventArmed == eventArmed));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,wisScore,wisBand,weightVersion,eventArmed);

@override
String toString() {
  return 'WellnessSummary(wisScore: $wisScore, wisBand: $wisBand, weightVersion: $weightVersion, eventArmed: $eventArmed)';
}


}

/// @nodoc
abstract mixin class $WellnessSummaryCopyWith<$Res>  {
  factory $WellnessSummaryCopyWith(WellnessSummary value, $Res Function(WellnessSummary) _then) = _$WellnessSummaryCopyWithImpl;
@useResult
$Res call({
 int wisScore, WisBand wisBand, String weightVersion, bool eventArmed
});




}
/// @nodoc
class _$WellnessSummaryCopyWithImpl<$Res>
    implements $WellnessSummaryCopyWith<$Res> {
  _$WellnessSummaryCopyWithImpl(this._self, this._then);

  final WellnessSummary _self;
  final $Res Function(WellnessSummary) _then;

/// Create a copy of WellnessSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? wisScore = null,Object? wisBand = null,Object? weightVersion = null,Object? eventArmed = null,}) {
  return _then(_self.copyWith(
wisScore: null == wisScore ? _self.wisScore : wisScore // ignore: cast_nullable_to_non_nullable
as int,wisBand: null == wisBand ? _self.wisBand : wisBand // ignore: cast_nullable_to_non_nullable
as WisBand,weightVersion: null == weightVersion ? _self.weightVersion : weightVersion // ignore: cast_nullable_to_non_nullable
as String,eventArmed: null == eventArmed ? _self.eventArmed : eventArmed // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [WellnessSummary].
extension WellnessSummaryPatterns on WellnessSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WellnessSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WellnessSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WellnessSummary value)  $default,){
final _that = this;
switch (_that) {
case _WellnessSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WellnessSummary value)?  $default,){
final _that = this;
switch (_that) {
case _WellnessSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int wisScore,  WisBand wisBand,  String weightVersion,  bool eventArmed)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WellnessSummary() when $default != null:
return $default(_that.wisScore,_that.wisBand,_that.weightVersion,_that.eventArmed);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int wisScore,  WisBand wisBand,  String weightVersion,  bool eventArmed)  $default,) {final _that = this;
switch (_that) {
case _WellnessSummary():
return $default(_that.wisScore,_that.wisBand,_that.weightVersion,_that.eventArmed);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int wisScore,  WisBand wisBand,  String weightVersion,  bool eventArmed)?  $default,) {final _that = this;
switch (_that) {
case _WellnessSummary() when $default != null:
return $default(_that.wisScore,_that.wisBand,_that.weightVersion,_that.eventArmed);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WellnessSummary implements WellnessSummary {
  const _WellnessSummary({required this.wisScore, required this.wisBand, required this.weightVersion, required this.eventArmed});
  factory _WellnessSummary.fromJson(Map<String, dynamic> json) => _$WellnessSummaryFromJson(json);

@override final  int wisScore;
@override final  WisBand wisBand;
@override final  String weightVersion;
@override final  bool eventArmed;

/// Create a copy of WellnessSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WellnessSummaryCopyWith<_WellnessSummary> get copyWith => __$WellnessSummaryCopyWithImpl<_WellnessSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WellnessSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WellnessSummary&&(identical(other.wisScore, wisScore) || other.wisScore == wisScore)&&(identical(other.wisBand, wisBand) || other.wisBand == wisBand)&&(identical(other.weightVersion, weightVersion) || other.weightVersion == weightVersion)&&(identical(other.eventArmed, eventArmed) || other.eventArmed == eventArmed));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,wisScore,wisBand,weightVersion,eventArmed);

@override
String toString() {
  return 'WellnessSummary(wisScore: $wisScore, wisBand: $wisBand, weightVersion: $weightVersion, eventArmed: $eventArmed)';
}


}

/// @nodoc
abstract mixin class _$WellnessSummaryCopyWith<$Res> implements $WellnessSummaryCopyWith<$Res> {
  factory _$WellnessSummaryCopyWith(_WellnessSummary value, $Res Function(_WellnessSummary) _then) = __$WellnessSummaryCopyWithImpl;
@override @useResult
$Res call({
 int wisScore, WisBand wisBand, String weightVersion, bool eventArmed
});




}
/// @nodoc
class __$WellnessSummaryCopyWithImpl<$Res>
    implements _$WellnessSummaryCopyWith<$Res> {
  __$WellnessSummaryCopyWithImpl(this._self, this._then);

  final _WellnessSummary _self;
  final $Res Function(_WellnessSummary) _then;

/// Create a copy of WellnessSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? wisScore = null,Object? wisBand = null,Object? weightVersion = null,Object? eventArmed = null,}) {
  return _then(_WellnessSummary(
wisScore: null == wisScore ? _self.wisScore : wisScore // ignore: cast_nullable_to_non_nullable
as int,wisBand: null == wisBand ? _self.wisBand : wisBand // ignore: cast_nullable_to_non_nullable
as WisBand,weightVersion: null == weightVersion ? _self.weightVersion : weightVersion // ignore: cast_nullable_to_non_nullable
as String,eventArmed: null == eventArmed ? _self.eventArmed : eventArmed // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$PlanContext {

 int? get uvIndex; int? get pm10; int? get pm25; double? get feelsLike; int? get precipitationProb; int get estimatedOutdoorMinutes; String? get weatherProvider; String? get airProvider; DateTime? get observedAt;
/// Create a copy of PlanContext
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlanContextCopyWith<PlanContext> get copyWith => _$PlanContextCopyWithImpl<PlanContext>(this as PlanContext, _$identity);

  /// Serializes this PlanContext to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlanContext&&(identical(other.uvIndex, uvIndex) || other.uvIndex == uvIndex)&&(identical(other.pm10, pm10) || other.pm10 == pm10)&&(identical(other.pm25, pm25) || other.pm25 == pm25)&&(identical(other.feelsLike, feelsLike) || other.feelsLike == feelsLike)&&(identical(other.precipitationProb, precipitationProb) || other.precipitationProb == precipitationProb)&&(identical(other.estimatedOutdoorMinutes, estimatedOutdoorMinutes) || other.estimatedOutdoorMinutes == estimatedOutdoorMinutes)&&(identical(other.weatherProvider, weatherProvider) || other.weatherProvider == weatherProvider)&&(identical(other.airProvider, airProvider) || other.airProvider == airProvider)&&(identical(other.observedAt, observedAt) || other.observedAt == observedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,uvIndex,pm10,pm25,feelsLike,precipitationProb,estimatedOutdoorMinutes,weatherProvider,airProvider,observedAt);

@override
String toString() {
  return 'PlanContext(uvIndex: $uvIndex, pm10: $pm10, pm25: $pm25, feelsLike: $feelsLike, precipitationProb: $precipitationProb, estimatedOutdoorMinutes: $estimatedOutdoorMinutes, weatherProvider: $weatherProvider, airProvider: $airProvider, observedAt: $observedAt)';
}


}

/// @nodoc
abstract mixin class $PlanContextCopyWith<$Res>  {
  factory $PlanContextCopyWith(PlanContext value, $Res Function(PlanContext) _then) = _$PlanContextCopyWithImpl;
@useResult
$Res call({
 int? uvIndex, int? pm10, int? pm25, double? feelsLike, int? precipitationProb, int estimatedOutdoorMinutes, String? weatherProvider, String? airProvider, DateTime? observedAt
});




}
/// @nodoc
class _$PlanContextCopyWithImpl<$Res>
    implements $PlanContextCopyWith<$Res> {
  _$PlanContextCopyWithImpl(this._self, this._then);

  final PlanContext _self;
  final $Res Function(PlanContext) _then;

/// Create a copy of PlanContext
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? uvIndex = freezed,Object? pm10 = freezed,Object? pm25 = freezed,Object? feelsLike = freezed,Object? precipitationProb = freezed,Object? estimatedOutdoorMinutes = null,Object? weatherProvider = freezed,Object? airProvider = freezed,Object? observedAt = freezed,}) {
  return _then(_self.copyWith(
uvIndex: freezed == uvIndex ? _self.uvIndex : uvIndex // ignore: cast_nullable_to_non_nullable
as int?,pm10: freezed == pm10 ? _self.pm10 : pm10 // ignore: cast_nullable_to_non_nullable
as int?,pm25: freezed == pm25 ? _self.pm25 : pm25 // ignore: cast_nullable_to_non_nullable
as int?,feelsLike: freezed == feelsLike ? _self.feelsLike : feelsLike // ignore: cast_nullable_to_non_nullable
as double?,precipitationProb: freezed == precipitationProb ? _self.precipitationProb : precipitationProb // ignore: cast_nullable_to_non_nullable
as int?,estimatedOutdoorMinutes: null == estimatedOutdoorMinutes ? _self.estimatedOutdoorMinutes : estimatedOutdoorMinutes // ignore: cast_nullable_to_non_nullable
as int,weatherProvider: freezed == weatherProvider ? _self.weatherProvider : weatherProvider // ignore: cast_nullable_to_non_nullable
as String?,airProvider: freezed == airProvider ? _self.airProvider : airProvider // ignore: cast_nullable_to_non_nullable
as String?,observedAt: freezed == observedAt ? _self.observedAt : observedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [PlanContext].
extension PlanContextPatterns on PlanContext {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PlanContext value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PlanContext() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PlanContext value)  $default,){
final _that = this;
switch (_that) {
case _PlanContext():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PlanContext value)?  $default,){
final _that = this;
switch (_that) {
case _PlanContext() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? uvIndex,  int? pm10,  int? pm25,  double? feelsLike,  int? precipitationProb,  int estimatedOutdoorMinutes,  String? weatherProvider,  String? airProvider,  DateTime? observedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PlanContext() when $default != null:
return $default(_that.uvIndex,_that.pm10,_that.pm25,_that.feelsLike,_that.precipitationProb,_that.estimatedOutdoorMinutes,_that.weatherProvider,_that.airProvider,_that.observedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? uvIndex,  int? pm10,  int? pm25,  double? feelsLike,  int? precipitationProb,  int estimatedOutdoorMinutes,  String? weatherProvider,  String? airProvider,  DateTime? observedAt)  $default,) {final _that = this;
switch (_that) {
case _PlanContext():
return $default(_that.uvIndex,_that.pm10,_that.pm25,_that.feelsLike,_that.precipitationProb,_that.estimatedOutdoorMinutes,_that.weatherProvider,_that.airProvider,_that.observedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? uvIndex,  int? pm10,  int? pm25,  double? feelsLike,  int? precipitationProb,  int estimatedOutdoorMinutes,  String? weatherProvider,  String? airProvider,  DateTime? observedAt)?  $default,) {final _that = this;
switch (_that) {
case _PlanContext() when $default != null:
return $default(_that.uvIndex,_that.pm10,_that.pm25,_that.feelsLike,_that.precipitationProb,_that.estimatedOutdoorMinutes,_that.weatherProvider,_that.airProvider,_that.observedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PlanContext implements PlanContext {
  const _PlanContext({this.uvIndex, this.pm10, this.pm25, this.feelsLike, this.precipitationProb, required this.estimatedOutdoorMinutes, this.weatherProvider, this.airProvider, this.observedAt});
  factory _PlanContext.fromJson(Map<String, dynamic> json) => _$PlanContextFromJson(json);

@override final  int? uvIndex;
@override final  int? pm10;
@override final  int? pm25;
@override final  double? feelsLike;
@override final  int? precipitationProb;
@override final  int estimatedOutdoorMinutes;
@override final  String? weatherProvider;
@override final  String? airProvider;
@override final  DateTime? observedAt;

/// Create a copy of PlanContext
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlanContextCopyWith<_PlanContext> get copyWith => __$PlanContextCopyWithImpl<_PlanContext>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PlanContextToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlanContext&&(identical(other.uvIndex, uvIndex) || other.uvIndex == uvIndex)&&(identical(other.pm10, pm10) || other.pm10 == pm10)&&(identical(other.pm25, pm25) || other.pm25 == pm25)&&(identical(other.feelsLike, feelsLike) || other.feelsLike == feelsLike)&&(identical(other.precipitationProb, precipitationProb) || other.precipitationProb == precipitationProb)&&(identical(other.estimatedOutdoorMinutes, estimatedOutdoorMinutes) || other.estimatedOutdoorMinutes == estimatedOutdoorMinutes)&&(identical(other.weatherProvider, weatherProvider) || other.weatherProvider == weatherProvider)&&(identical(other.airProvider, airProvider) || other.airProvider == airProvider)&&(identical(other.observedAt, observedAt) || other.observedAt == observedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,uvIndex,pm10,pm25,feelsLike,precipitationProb,estimatedOutdoorMinutes,weatherProvider,airProvider,observedAt);

@override
String toString() {
  return 'PlanContext(uvIndex: $uvIndex, pm10: $pm10, pm25: $pm25, feelsLike: $feelsLike, precipitationProb: $precipitationProb, estimatedOutdoorMinutes: $estimatedOutdoorMinutes, weatherProvider: $weatherProvider, airProvider: $airProvider, observedAt: $observedAt)';
}


}

/// @nodoc
abstract mixin class _$PlanContextCopyWith<$Res> implements $PlanContextCopyWith<$Res> {
  factory _$PlanContextCopyWith(_PlanContext value, $Res Function(_PlanContext) _then) = __$PlanContextCopyWithImpl;
@override @useResult
$Res call({
 int? uvIndex, int? pm10, int? pm25, double? feelsLike, int? precipitationProb, int estimatedOutdoorMinutes, String? weatherProvider, String? airProvider, DateTime? observedAt
});




}
/// @nodoc
class __$PlanContextCopyWithImpl<$Res>
    implements _$PlanContextCopyWith<$Res> {
  __$PlanContextCopyWithImpl(this._self, this._then);

  final _PlanContext _self;
  final $Res Function(_PlanContext) _then;

/// Create a copy of PlanContext
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? uvIndex = freezed,Object? pm10 = freezed,Object? pm25 = freezed,Object? feelsLike = freezed,Object? precipitationProb = freezed,Object? estimatedOutdoorMinutes = null,Object? weatherProvider = freezed,Object? airProvider = freezed,Object? observedAt = freezed,}) {
  return _then(_PlanContext(
uvIndex: freezed == uvIndex ? _self.uvIndex : uvIndex // ignore: cast_nullable_to_non_nullable
as int?,pm10: freezed == pm10 ? _self.pm10 : pm10 // ignore: cast_nullable_to_non_nullable
as int?,pm25: freezed == pm25 ? _self.pm25 : pm25 // ignore: cast_nullable_to_non_nullable
as int?,feelsLike: freezed == feelsLike ? _self.feelsLike : feelsLike // ignore: cast_nullable_to_non_nullable
as double?,precipitationProb: freezed == precipitationProb ? _self.precipitationProb : precipitationProb // ignore: cast_nullable_to_non_nullable
as int?,estimatedOutdoorMinutes: null == estimatedOutdoorMinutes ? _self.estimatedOutdoorMinutes : estimatedOutdoorMinutes // ignore: cast_nullable_to_non_nullable
as int,weatherProvider: freezed == weatherProvider ? _self.weatherProvider : weatherProvider // ignore: cast_nullable_to_non_nullable
as String?,airProvider: freezed == airProvider ? _self.airProvider : airProvider // ignore: cast_nullable_to_non_nullable
as String?,observedAt: freezed == observedAt ? _self.observedAt : observedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$Plan {

 String get planId; String get eventId; int get revisionNo; String get calcVersion; PlanStatus get planStatus; EventLifecycleStatus get eventStatus; bool get feasible; String? get predictionConfidence; DateTime get prepStartAt; DateTime get recommendedDepartAt; DateTime get targetArriveAt; PlanBreakdown get breakdown; List<PlanReason> get reasons; List<ChecklistItem> get checklist; List<WellnessAction> get wellnessActions; WellnessSummary? get wellness; PlanContext? get context; String? get selectedRouteOptionId; List<String> get degraded;
/// Create a copy of Plan
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlanCopyWith<Plan> get copyWith => _$PlanCopyWithImpl<Plan>(this as Plan, _$identity);

  /// Serializes this Plan to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Plan&&(identical(other.planId, planId) || other.planId == planId)&&(identical(other.eventId, eventId) || other.eventId == eventId)&&(identical(other.revisionNo, revisionNo) || other.revisionNo == revisionNo)&&(identical(other.calcVersion, calcVersion) || other.calcVersion == calcVersion)&&(identical(other.planStatus, planStatus) || other.planStatus == planStatus)&&(identical(other.eventStatus, eventStatus) || other.eventStatus == eventStatus)&&(identical(other.feasible, feasible) || other.feasible == feasible)&&(identical(other.predictionConfidence, predictionConfidence) || other.predictionConfidence == predictionConfidence)&&(identical(other.prepStartAt, prepStartAt) || other.prepStartAt == prepStartAt)&&(identical(other.recommendedDepartAt, recommendedDepartAt) || other.recommendedDepartAt == recommendedDepartAt)&&(identical(other.targetArriveAt, targetArriveAt) || other.targetArriveAt == targetArriveAt)&&(identical(other.breakdown, breakdown) || other.breakdown == breakdown)&&const DeepCollectionEquality().equals(other.reasons, reasons)&&const DeepCollectionEquality().equals(other.checklist, checklist)&&const DeepCollectionEquality().equals(other.wellnessActions, wellnessActions)&&(identical(other.wellness, wellness) || other.wellness == wellness)&&(identical(other.context, context) || other.context == context)&&(identical(other.selectedRouteOptionId, selectedRouteOptionId) || other.selectedRouteOptionId == selectedRouteOptionId)&&const DeepCollectionEquality().equals(other.degraded, degraded));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,planId,eventId,revisionNo,calcVersion,planStatus,eventStatus,feasible,predictionConfidence,prepStartAt,recommendedDepartAt,targetArriveAt,breakdown,const DeepCollectionEquality().hash(reasons),const DeepCollectionEquality().hash(checklist),const DeepCollectionEquality().hash(wellnessActions),wellness,context,selectedRouteOptionId,const DeepCollectionEquality().hash(degraded)]);

@override
String toString() {
  return 'Plan(planId: $planId, eventId: $eventId, revisionNo: $revisionNo, calcVersion: $calcVersion, planStatus: $planStatus, eventStatus: $eventStatus, feasible: $feasible, predictionConfidence: $predictionConfidence, prepStartAt: $prepStartAt, recommendedDepartAt: $recommendedDepartAt, targetArriveAt: $targetArriveAt, breakdown: $breakdown, reasons: $reasons, checklist: $checklist, wellnessActions: $wellnessActions, wellness: $wellness, context: $context, selectedRouteOptionId: $selectedRouteOptionId, degraded: $degraded)';
}


}

/// @nodoc
abstract mixin class $PlanCopyWith<$Res>  {
  factory $PlanCopyWith(Plan value, $Res Function(Plan) _then) = _$PlanCopyWithImpl;
@useResult
$Res call({
 String planId, String eventId, int revisionNo, String calcVersion, PlanStatus planStatus, EventLifecycleStatus eventStatus, bool feasible, String? predictionConfidence, DateTime prepStartAt, DateTime recommendedDepartAt, DateTime targetArriveAt, PlanBreakdown breakdown, List<PlanReason> reasons, List<ChecklistItem> checklist, List<WellnessAction> wellnessActions, WellnessSummary? wellness, PlanContext? context, String? selectedRouteOptionId, List<String> degraded
});


$PlanBreakdownCopyWith<$Res> get breakdown;$WellnessSummaryCopyWith<$Res>? get wellness;$PlanContextCopyWith<$Res>? get context;

}
/// @nodoc
class _$PlanCopyWithImpl<$Res>
    implements $PlanCopyWith<$Res> {
  _$PlanCopyWithImpl(this._self, this._then);

  final Plan _self;
  final $Res Function(Plan) _then;

/// Create a copy of Plan
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? planId = null,Object? eventId = null,Object? revisionNo = null,Object? calcVersion = null,Object? planStatus = null,Object? eventStatus = null,Object? feasible = null,Object? predictionConfidence = freezed,Object? prepStartAt = null,Object? recommendedDepartAt = null,Object? targetArriveAt = null,Object? breakdown = null,Object? reasons = null,Object? checklist = null,Object? wellnessActions = null,Object? wellness = freezed,Object? context = freezed,Object? selectedRouteOptionId = freezed,Object? degraded = null,}) {
  return _then(_self.copyWith(
planId: null == planId ? _self.planId : planId // ignore: cast_nullable_to_non_nullable
as String,eventId: null == eventId ? _self.eventId : eventId // ignore: cast_nullable_to_non_nullable
as String,revisionNo: null == revisionNo ? _self.revisionNo : revisionNo // ignore: cast_nullable_to_non_nullable
as int,calcVersion: null == calcVersion ? _self.calcVersion : calcVersion // ignore: cast_nullable_to_non_nullable
as String,planStatus: null == planStatus ? _self.planStatus : planStatus // ignore: cast_nullable_to_non_nullable
as PlanStatus,eventStatus: null == eventStatus ? _self.eventStatus : eventStatus // ignore: cast_nullable_to_non_nullable
as EventLifecycleStatus,feasible: null == feasible ? _self.feasible : feasible // ignore: cast_nullable_to_non_nullable
as bool,predictionConfidence: freezed == predictionConfidence ? _self.predictionConfidence : predictionConfidence // ignore: cast_nullable_to_non_nullable
as String?,prepStartAt: null == prepStartAt ? _self.prepStartAt : prepStartAt // ignore: cast_nullable_to_non_nullable
as DateTime,recommendedDepartAt: null == recommendedDepartAt ? _self.recommendedDepartAt : recommendedDepartAt // ignore: cast_nullable_to_non_nullable
as DateTime,targetArriveAt: null == targetArriveAt ? _self.targetArriveAt : targetArriveAt // ignore: cast_nullable_to_non_nullable
as DateTime,breakdown: null == breakdown ? _self.breakdown : breakdown // ignore: cast_nullable_to_non_nullable
as PlanBreakdown,reasons: null == reasons ? _self.reasons : reasons // ignore: cast_nullable_to_non_nullable
as List<PlanReason>,checklist: null == checklist ? _self.checklist : checklist // ignore: cast_nullable_to_non_nullable
as List<ChecklistItem>,wellnessActions: null == wellnessActions ? _self.wellnessActions : wellnessActions // ignore: cast_nullable_to_non_nullable
as List<WellnessAction>,wellness: freezed == wellness ? _self.wellness : wellness // ignore: cast_nullable_to_non_nullable
as WellnessSummary?,context: freezed == context ? _self.context : context // ignore: cast_nullable_to_non_nullable
as PlanContext?,selectedRouteOptionId: freezed == selectedRouteOptionId ? _self.selectedRouteOptionId : selectedRouteOptionId // ignore: cast_nullable_to_non_nullable
as String?,degraded: null == degraded ? _self.degraded : degraded // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}
/// Create a copy of Plan
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PlanBreakdownCopyWith<$Res> get breakdown {
  
  return $PlanBreakdownCopyWith<$Res>(_self.breakdown, (value) {
    return _then(_self.copyWith(breakdown: value));
  });
}/// Create a copy of Plan
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WellnessSummaryCopyWith<$Res>? get wellness {
    if (_self.wellness == null) {
    return null;
  }

  return $WellnessSummaryCopyWith<$Res>(_self.wellness!, (value) {
    return _then(_self.copyWith(wellness: value));
  });
}/// Create a copy of Plan
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PlanContextCopyWith<$Res>? get context {
    if (_self.context == null) {
    return null;
  }

  return $PlanContextCopyWith<$Res>(_self.context!, (value) {
    return _then(_self.copyWith(context: value));
  });
}
}


/// Adds pattern-matching-related methods to [Plan].
extension PlanPatterns on Plan {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Plan value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Plan() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Plan value)  $default,){
final _that = this;
switch (_that) {
case _Plan():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Plan value)?  $default,){
final _that = this;
switch (_that) {
case _Plan() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String planId,  String eventId,  int revisionNo,  String calcVersion,  PlanStatus planStatus,  EventLifecycleStatus eventStatus,  bool feasible,  String? predictionConfidence,  DateTime prepStartAt,  DateTime recommendedDepartAt,  DateTime targetArriveAt,  PlanBreakdown breakdown,  List<PlanReason> reasons,  List<ChecklistItem> checklist,  List<WellnessAction> wellnessActions,  WellnessSummary? wellness,  PlanContext? context,  String? selectedRouteOptionId,  List<String> degraded)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Plan() when $default != null:
return $default(_that.planId,_that.eventId,_that.revisionNo,_that.calcVersion,_that.planStatus,_that.eventStatus,_that.feasible,_that.predictionConfidence,_that.prepStartAt,_that.recommendedDepartAt,_that.targetArriveAt,_that.breakdown,_that.reasons,_that.checklist,_that.wellnessActions,_that.wellness,_that.context,_that.selectedRouteOptionId,_that.degraded);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String planId,  String eventId,  int revisionNo,  String calcVersion,  PlanStatus planStatus,  EventLifecycleStatus eventStatus,  bool feasible,  String? predictionConfidence,  DateTime prepStartAt,  DateTime recommendedDepartAt,  DateTime targetArriveAt,  PlanBreakdown breakdown,  List<PlanReason> reasons,  List<ChecklistItem> checklist,  List<WellnessAction> wellnessActions,  WellnessSummary? wellness,  PlanContext? context,  String? selectedRouteOptionId,  List<String> degraded)  $default,) {final _that = this;
switch (_that) {
case _Plan():
return $default(_that.planId,_that.eventId,_that.revisionNo,_that.calcVersion,_that.planStatus,_that.eventStatus,_that.feasible,_that.predictionConfidence,_that.prepStartAt,_that.recommendedDepartAt,_that.targetArriveAt,_that.breakdown,_that.reasons,_that.checklist,_that.wellnessActions,_that.wellness,_that.context,_that.selectedRouteOptionId,_that.degraded);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String planId,  String eventId,  int revisionNo,  String calcVersion,  PlanStatus planStatus,  EventLifecycleStatus eventStatus,  bool feasible,  String? predictionConfidence,  DateTime prepStartAt,  DateTime recommendedDepartAt,  DateTime targetArriveAt,  PlanBreakdown breakdown,  List<PlanReason> reasons,  List<ChecklistItem> checklist,  List<WellnessAction> wellnessActions,  WellnessSummary? wellness,  PlanContext? context,  String? selectedRouteOptionId,  List<String> degraded)?  $default,) {final _that = this;
switch (_that) {
case _Plan() when $default != null:
return $default(_that.planId,_that.eventId,_that.revisionNo,_that.calcVersion,_that.planStatus,_that.eventStatus,_that.feasible,_that.predictionConfidence,_that.prepStartAt,_that.recommendedDepartAt,_that.targetArriveAt,_that.breakdown,_that.reasons,_that.checklist,_that.wellnessActions,_that.wellness,_that.context,_that.selectedRouteOptionId,_that.degraded);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Plan implements Plan {
  const _Plan({required this.planId, required this.eventId, required this.revisionNo, required this.calcVersion, required this.planStatus, required this.eventStatus, required this.feasible, this.predictionConfidence, required this.prepStartAt, required this.recommendedDepartAt, required this.targetArriveAt, required this.breakdown, required final  List<PlanReason> reasons, required final  List<ChecklistItem> checklist, final  List<WellnessAction> wellnessActions = const [], this.wellness, this.context, this.selectedRouteOptionId, final  List<String> degraded = const []}): _reasons = reasons,_checklist = checklist,_wellnessActions = wellnessActions,_degraded = degraded;
  factory _Plan.fromJson(Map<String, dynamic> json) => _$PlanFromJson(json);

@override final  String planId;
@override final  String eventId;
@override final  int revisionNo;
@override final  String calcVersion;
@override final  PlanStatus planStatus;
@override final  EventLifecycleStatus eventStatus;
@override final  bool feasible;
@override final  String? predictionConfidence;
@override final  DateTime prepStartAt;
@override final  DateTime recommendedDepartAt;
@override final  DateTime targetArriveAt;
@override final  PlanBreakdown breakdown;
 final  List<PlanReason> _reasons;
@override List<PlanReason> get reasons {
  if (_reasons is EqualUnmodifiableListView) return _reasons;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_reasons);
}

 final  List<ChecklistItem> _checklist;
@override List<ChecklistItem> get checklist {
  if (_checklist is EqualUnmodifiableListView) return _checklist;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_checklist);
}

 final  List<WellnessAction> _wellnessActions;
@override@JsonKey() List<WellnessAction> get wellnessActions {
  if (_wellnessActions is EqualUnmodifiableListView) return _wellnessActions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_wellnessActions);
}

@override final  WellnessSummary? wellness;
@override final  PlanContext? context;
@override final  String? selectedRouteOptionId;
 final  List<String> _degraded;
@override@JsonKey() List<String> get degraded {
  if (_degraded is EqualUnmodifiableListView) return _degraded;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_degraded);
}


/// Create a copy of Plan
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlanCopyWith<_Plan> get copyWith => __$PlanCopyWithImpl<_Plan>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PlanToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Plan&&(identical(other.planId, planId) || other.planId == planId)&&(identical(other.eventId, eventId) || other.eventId == eventId)&&(identical(other.revisionNo, revisionNo) || other.revisionNo == revisionNo)&&(identical(other.calcVersion, calcVersion) || other.calcVersion == calcVersion)&&(identical(other.planStatus, planStatus) || other.planStatus == planStatus)&&(identical(other.eventStatus, eventStatus) || other.eventStatus == eventStatus)&&(identical(other.feasible, feasible) || other.feasible == feasible)&&(identical(other.predictionConfidence, predictionConfidence) || other.predictionConfidence == predictionConfidence)&&(identical(other.prepStartAt, prepStartAt) || other.prepStartAt == prepStartAt)&&(identical(other.recommendedDepartAt, recommendedDepartAt) || other.recommendedDepartAt == recommendedDepartAt)&&(identical(other.targetArriveAt, targetArriveAt) || other.targetArriveAt == targetArriveAt)&&(identical(other.breakdown, breakdown) || other.breakdown == breakdown)&&const DeepCollectionEquality().equals(other._reasons, _reasons)&&const DeepCollectionEquality().equals(other._checklist, _checklist)&&const DeepCollectionEquality().equals(other._wellnessActions, _wellnessActions)&&(identical(other.wellness, wellness) || other.wellness == wellness)&&(identical(other.context, context) || other.context == context)&&(identical(other.selectedRouteOptionId, selectedRouteOptionId) || other.selectedRouteOptionId == selectedRouteOptionId)&&const DeepCollectionEquality().equals(other._degraded, _degraded));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,planId,eventId,revisionNo,calcVersion,planStatus,eventStatus,feasible,predictionConfidence,prepStartAt,recommendedDepartAt,targetArriveAt,breakdown,const DeepCollectionEquality().hash(_reasons),const DeepCollectionEquality().hash(_checklist),const DeepCollectionEquality().hash(_wellnessActions),wellness,context,selectedRouteOptionId,const DeepCollectionEquality().hash(_degraded)]);

@override
String toString() {
  return 'Plan(planId: $planId, eventId: $eventId, revisionNo: $revisionNo, calcVersion: $calcVersion, planStatus: $planStatus, eventStatus: $eventStatus, feasible: $feasible, predictionConfidence: $predictionConfidence, prepStartAt: $prepStartAt, recommendedDepartAt: $recommendedDepartAt, targetArriveAt: $targetArriveAt, breakdown: $breakdown, reasons: $reasons, checklist: $checklist, wellnessActions: $wellnessActions, wellness: $wellness, context: $context, selectedRouteOptionId: $selectedRouteOptionId, degraded: $degraded)';
}


}

/// @nodoc
abstract mixin class _$PlanCopyWith<$Res> implements $PlanCopyWith<$Res> {
  factory _$PlanCopyWith(_Plan value, $Res Function(_Plan) _then) = __$PlanCopyWithImpl;
@override @useResult
$Res call({
 String planId, String eventId, int revisionNo, String calcVersion, PlanStatus planStatus, EventLifecycleStatus eventStatus, bool feasible, String? predictionConfidence, DateTime prepStartAt, DateTime recommendedDepartAt, DateTime targetArriveAt, PlanBreakdown breakdown, List<PlanReason> reasons, List<ChecklistItem> checklist, List<WellnessAction> wellnessActions, WellnessSummary? wellness, PlanContext? context, String? selectedRouteOptionId, List<String> degraded
});


@override $PlanBreakdownCopyWith<$Res> get breakdown;@override $WellnessSummaryCopyWith<$Res>? get wellness;@override $PlanContextCopyWith<$Res>? get context;

}
/// @nodoc
class __$PlanCopyWithImpl<$Res>
    implements _$PlanCopyWith<$Res> {
  __$PlanCopyWithImpl(this._self, this._then);

  final _Plan _self;
  final $Res Function(_Plan) _then;

/// Create a copy of Plan
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? planId = null,Object? eventId = null,Object? revisionNo = null,Object? calcVersion = null,Object? planStatus = null,Object? eventStatus = null,Object? feasible = null,Object? predictionConfidence = freezed,Object? prepStartAt = null,Object? recommendedDepartAt = null,Object? targetArriveAt = null,Object? breakdown = null,Object? reasons = null,Object? checklist = null,Object? wellnessActions = null,Object? wellness = freezed,Object? context = freezed,Object? selectedRouteOptionId = freezed,Object? degraded = null,}) {
  return _then(_Plan(
planId: null == planId ? _self.planId : planId // ignore: cast_nullable_to_non_nullable
as String,eventId: null == eventId ? _self.eventId : eventId // ignore: cast_nullable_to_non_nullable
as String,revisionNo: null == revisionNo ? _self.revisionNo : revisionNo // ignore: cast_nullable_to_non_nullable
as int,calcVersion: null == calcVersion ? _self.calcVersion : calcVersion // ignore: cast_nullable_to_non_nullable
as String,planStatus: null == planStatus ? _self.planStatus : planStatus // ignore: cast_nullable_to_non_nullable
as PlanStatus,eventStatus: null == eventStatus ? _self.eventStatus : eventStatus // ignore: cast_nullable_to_non_nullable
as EventLifecycleStatus,feasible: null == feasible ? _self.feasible : feasible // ignore: cast_nullable_to_non_nullable
as bool,predictionConfidence: freezed == predictionConfidence ? _self.predictionConfidence : predictionConfidence // ignore: cast_nullable_to_non_nullable
as String?,prepStartAt: null == prepStartAt ? _self.prepStartAt : prepStartAt // ignore: cast_nullable_to_non_nullable
as DateTime,recommendedDepartAt: null == recommendedDepartAt ? _self.recommendedDepartAt : recommendedDepartAt // ignore: cast_nullable_to_non_nullable
as DateTime,targetArriveAt: null == targetArriveAt ? _self.targetArriveAt : targetArriveAt // ignore: cast_nullable_to_non_nullable
as DateTime,breakdown: null == breakdown ? _self.breakdown : breakdown // ignore: cast_nullable_to_non_nullable
as PlanBreakdown,reasons: null == reasons ? _self._reasons : reasons // ignore: cast_nullable_to_non_nullable
as List<PlanReason>,checklist: null == checklist ? _self._checklist : checklist // ignore: cast_nullable_to_non_nullable
as List<ChecklistItem>,wellnessActions: null == wellnessActions ? _self._wellnessActions : wellnessActions // ignore: cast_nullable_to_non_nullable
as List<WellnessAction>,wellness: freezed == wellness ? _self.wellness : wellness // ignore: cast_nullable_to_non_nullable
as WellnessSummary?,context: freezed == context ? _self.context : context // ignore: cast_nullable_to_non_nullable
as PlanContext?,selectedRouteOptionId: freezed == selectedRouteOptionId ? _self.selectedRouteOptionId : selectedRouteOptionId // ignore: cast_nullable_to_non_nullable
as String?,degraded: null == degraded ? _self._degraded : degraded // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

/// Create a copy of Plan
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PlanBreakdownCopyWith<$Res> get breakdown {
  
  return $PlanBreakdownCopyWith<$Res>(_self.breakdown, (value) {
    return _then(_self.copyWith(breakdown: value));
  });
}/// Create a copy of Plan
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WellnessSummaryCopyWith<$Res>? get wellness {
    if (_self.wellness == null) {
    return null;
  }

  return $WellnessSummaryCopyWith<$Res>(_self.wellness!, (value) {
    return _then(_self.copyWith(wellness: value));
  });
}/// Create a copy of Plan
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PlanContextCopyWith<$Res>? get context {
    if (_self.context == null) {
    return null;
  }

  return $PlanContextCopyWith<$Res>(_self.context!, (value) {
    return _then(_self.copyWith(context: value));
  });
}
}


/// @nodoc
mixin _$RouteOption {

 String get routeOptionId; int get routeRank; RouteType get routeType; int get totalMinutes; int get walkMinutes; int get transferCount; DateTime? get departAt; DateTime? get arriveAt;
/// Create a copy of RouteOption
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RouteOptionCopyWith<RouteOption> get copyWith => _$RouteOptionCopyWithImpl<RouteOption>(this as RouteOption, _$identity);

  /// Serializes this RouteOption to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RouteOption&&(identical(other.routeOptionId, routeOptionId) || other.routeOptionId == routeOptionId)&&(identical(other.routeRank, routeRank) || other.routeRank == routeRank)&&(identical(other.routeType, routeType) || other.routeType == routeType)&&(identical(other.totalMinutes, totalMinutes) || other.totalMinutes == totalMinutes)&&(identical(other.walkMinutes, walkMinutes) || other.walkMinutes == walkMinutes)&&(identical(other.transferCount, transferCount) || other.transferCount == transferCount)&&(identical(other.departAt, departAt) || other.departAt == departAt)&&(identical(other.arriveAt, arriveAt) || other.arriveAt == arriveAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,routeOptionId,routeRank,routeType,totalMinutes,walkMinutes,transferCount,departAt,arriveAt);

@override
String toString() {
  return 'RouteOption(routeOptionId: $routeOptionId, routeRank: $routeRank, routeType: $routeType, totalMinutes: $totalMinutes, walkMinutes: $walkMinutes, transferCount: $transferCount, departAt: $departAt, arriveAt: $arriveAt)';
}


}

/// @nodoc
abstract mixin class $RouteOptionCopyWith<$Res>  {
  factory $RouteOptionCopyWith(RouteOption value, $Res Function(RouteOption) _then) = _$RouteOptionCopyWithImpl;
@useResult
$Res call({
 String routeOptionId, int routeRank, RouteType routeType, int totalMinutes, int walkMinutes, int transferCount, DateTime? departAt, DateTime? arriveAt
});




}
/// @nodoc
class _$RouteOptionCopyWithImpl<$Res>
    implements $RouteOptionCopyWith<$Res> {
  _$RouteOptionCopyWithImpl(this._self, this._then);

  final RouteOption _self;
  final $Res Function(RouteOption) _then;

/// Create a copy of RouteOption
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? routeOptionId = null,Object? routeRank = null,Object? routeType = null,Object? totalMinutes = null,Object? walkMinutes = null,Object? transferCount = null,Object? departAt = freezed,Object? arriveAt = freezed,}) {
  return _then(_self.copyWith(
routeOptionId: null == routeOptionId ? _self.routeOptionId : routeOptionId // ignore: cast_nullable_to_non_nullable
as String,routeRank: null == routeRank ? _self.routeRank : routeRank // ignore: cast_nullable_to_non_nullable
as int,routeType: null == routeType ? _self.routeType : routeType // ignore: cast_nullable_to_non_nullable
as RouteType,totalMinutes: null == totalMinutes ? _self.totalMinutes : totalMinutes // ignore: cast_nullable_to_non_nullable
as int,walkMinutes: null == walkMinutes ? _self.walkMinutes : walkMinutes // ignore: cast_nullable_to_non_nullable
as int,transferCount: null == transferCount ? _self.transferCount : transferCount // ignore: cast_nullable_to_non_nullable
as int,departAt: freezed == departAt ? _self.departAt : departAt // ignore: cast_nullable_to_non_nullable
as DateTime?,arriveAt: freezed == arriveAt ? _self.arriveAt : arriveAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [RouteOption].
extension RouteOptionPatterns on RouteOption {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RouteOption value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RouteOption() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RouteOption value)  $default,){
final _that = this;
switch (_that) {
case _RouteOption():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RouteOption value)?  $default,){
final _that = this;
switch (_that) {
case _RouteOption() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String routeOptionId,  int routeRank,  RouteType routeType,  int totalMinutes,  int walkMinutes,  int transferCount,  DateTime? departAt,  DateTime? arriveAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RouteOption() when $default != null:
return $default(_that.routeOptionId,_that.routeRank,_that.routeType,_that.totalMinutes,_that.walkMinutes,_that.transferCount,_that.departAt,_that.arriveAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String routeOptionId,  int routeRank,  RouteType routeType,  int totalMinutes,  int walkMinutes,  int transferCount,  DateTime? departAt,  DateTime? arriveAt)  $default,) {final _that = this;
switch (_that) {
case _RouteOption():
return $default(_that.routeOptionId,_that.routeRank,_that.routeType,_that.totalMinutes,_that.walkMinutes,_that.transferCount,_that.departAt,_that.arriveAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String routeOptionId,  int routeRank,  RouteType routeType,  int totalMinutes,  int walkMinutes,  int transferCount,  DateTime? departAt,  DateTime? arriveAt)?  $default,) {final _that = this;
switch (_that) {
case _RouteOption() when $default != null:
return $default(_that.routeOptionId,_that.routeRank,_that.routeType,_that.totalMinutes,_that.walkMinutes,_that.transferCount,_that.departAt,_that.arriveAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RouteOption implements RouteOption {
  const _RouteOption({required this.routeOptionId, required this.routeRank, required this.routeType, required this.totalMinutes, required this.walkMinutes, required this.transferCount, this.departAt, this.arriveAt});
  factory _RouteOption.fromJson(Map<String, dynamic> json) => _$RouteOptionFromJson(json);

@override final  String routeOptionId;
@override final  int routeRank;
@override final  RouteType routeType;
@override final  int totalMinutes;
@override final  int walkMinutes;
@override final  int transferCount;
@override final  DateTime? departAt;
@override final  DateTime? arriveAt;

/// Create a copy of RouteOption
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RouteOptionCopyWith<_RouteOption> get copyWith => __$RouteOptionCopyWithImpl<_RouteOption>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RouteOptionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RouteOption&&(identical(other.routeOptionId, routeOptionId) || other.routeOptionId == routeOptionId)&&(identical(other.routeRank, routeRank) || other.routeRank == routeRank)&&(identical(other.routeType, routeType) || other.routeType == routeType)&&(identical(other.totalMinutes, totalMinutes) || other.totalMinutes == totalMinutes)&&(identical(other.walkMinutes, walkMinutes) || other.walkMinutes == walkMinutes)&&(identical(other.transferCount, transferCount) || other.transferCount == transferCount)&&(identical(other.departAt, departAt) || other.departAt == departAt)&&(identical(other.arriveAt, arriveAt) || other.arriveAt == arriveAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,routeOptionId,routeRank,routeType,totalMinutes,walkMinutes,transferCount,departAt,arriveAt);

@override
String toString() {
  return 'RouteOption(routeOptionId: $routeOptionId, routeRank: $routeRank, routeType: $routeType, totalMinutes: $totalMinutes, walkMinutes: $walkMinutes, transferCount: $transferCount, departAt: $departAt, arriveAt: $arriveAt)';
}


}

/// @nodoc
abstract mixin class _$RouteOptionCopyWith<$Res> implements $RouteOptionCopyWith<$Res> {
  factory _$RouteOptionCopyWith(_RouteOption value, $Res Function(_RouteOption) _then) = __$RouteOptionCopyWithImpl;
@override @useResult
$Res call({
 String routeOptionId, int routeRank, RouteType routeType, int totalMinutes, int walkMinutes, int transferCount, DateTime? departAt, DateTime? arriveAt
});




}
/// @nodoc
class __$RouteOptionCopyWithImpl<$Res>
    implements _$RouteOptionCopyWith<$Res> {
  __$RouteOptionCopyWithImpl(this._self, this._then);

  final _RouteOption _self;
  final $Res Function(_RouteOption) _then;

/// Create a copy of RouteOption
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? routeOptionId = null,Object? routeRank = null,Object? routeType = null,Object? totalMinutes = null,Object? walkMinutes = null,Object? transferCount = null,Object? departAt = freezed,Object? arriveAt = freezed,}) {
  return _then(_RouteOption(
routeOptionId: null == routeOptionId ? _self.routeOptionId : routeOptionId // ignore: cast_nullable_to_non_nullable
as String,routeRank: null == routeRank ? _self.routeRank : routeRank // ignore: cast_nullable_to_non_nullable
as int,routeType: null == routeType ? _self.routeType : routeType // ignore: cast_nullable_to_non_nullable
as RouteType,totalMinutes: null == totalMinutes ? _self.totalMinutes : totalMinutes // ignore: cast_nullable_to_non_nullable
as int,walkMinutes: null == walkMinutes ? _self.walkMinutes : walkMinutes // ignore: cast_nullable_to_non_nullable
as int,transferCount: null == transferCount ? _self.transferCount : transferCount // ignore: cast_nullable_to_non_nullable
as int,departAt: freezed == departAt ? _self.departAt : departAt // ignore: cast_nullable_to_non_nullable
as DateTime?,arriveAt: freezed == arriveAt ? _self.arriveAt : arriveAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
