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

 String get label; int get minutes; String get source; bool get adjusted; String? get reason;
/// Create a copy of PlanReason
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlanReasonCopyWith<PlanReason> get copyWith => _$PlanReasonCopyWithImpl<PlanReason>(this as PlanReason, _$identity);

  /// Serializes this PlanReason to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlanReason&&(identical(other.label, label) || other.label == label)&&(identical(other.minutes, minutes) || other.minutes == minutes)&&(identical(other.source, source) || other.source == source)&&(identical(other.adjusted, adjusted) || other.adjusted == adjusted)&&(identical(other.reason, reason) || other.reason == reason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,label,minutes,source,adjusted,reason);

@override
String toString() {
  return 'PlanReason(label: $label, minutes: $minutes, source: $source, adjusted: $adjusted, reason: $reason)';
}


}

/// @nodoc
abstract mixin class $PlanReasonCopyWith<$Res>  {
  factory $PlanReasonCopyWith(PlanReason value, $Res Function(PlanReason) _then) = _$PlanReasonCopyWithImpl;
@useResult
$Res call({
 String label, int minutes, String source, bool adjusted, String? reason
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
@pragma('vm:prefer-inline') @override $Res call({Object? label = null,Object? minutes = null,Object? source = null,Object? adjusted = null,Object? reason = freezed,}) {
  return _then(_self.copyWith(
label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,minutes: null == minutes ? _self.minutes : minutes // ignore: cast_nullable_to_non_nullable
as int,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String,adjusted: null == adjusted ? _self.adjusted : adjusted // ignore: cast_nullable_to_non_nullable
as bool,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String label,  int minutes,  String source,  bool adjusted,  String? reason)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PlanReason() when $default != null:
return $default(_that.label,_that.minutes,_that.source,_that.adjusted,_that.reason);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String label,  int minutes,  String source,  bool adjusted,  String? reason)  $default,) {final _that = this;
switch (_that) {
case _PlanReason():
return $default(_that.label,_that.minutes,_that.source,_that.adjusted,_that.reason);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String label,  int minutes,  String source,  bool adjusted,  String? reason)?  $default,) {final _that = this;
switch (_that) {
case _PlanReason() when $default != null:
return $default(_that.label,_that.minutes,_that.source,_that.adjusted,_that.reason);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PlanReason implements PlanReason {
  const _PlanReason({required this.label, required this.minutes, required this.source, required this.adjusted, this.reason});
  factory _PlanReason.fromJson(Map<String, dynamic> json) => _$PlanReasonFromJson(json);

@override final  String label;
@override final  int minutes;
@override final  String source;
@override final  bool adjusted;
@override final  String? reason;

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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlanReason&&(identical(other.label, label) || other.label == label)&&(identical(other.minutes, minutes) || other.minutes == minutes)&&(identical(other.source, source) || other.source == source)&&(identical(other.adjusted, adjusted) || other.adjusted == adjusted)&&(identical(other.reason, reason) || other.reason == reason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,label,minutes,source,adjusted,reason);

@override
String toString() {
  return 'PlanReason(label: $label, minutes: $minutes, source: $source, adjusted: $adjusted, reason: $reason)';
}


}

/// @nodoc
abstract mixin class _$PlanReasonCopyWith<$Res> implements $PlanReasonCopyWith<$Res> {
  factory _$PlanReasonCopyWith(_PlanReason value, $Res Function(_PlanReason) _then) = __$PlanReasonCopyWithImpl;
@override @useResult
$Res call({
 String label, int minutes, String source, bool adjusted, String? reason
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
@override @pragma('vm:prefer-inline') $Res call({Object? label = null,Object? minutes = null,Object? source = null,Object? adjusted = null,Object? reason = freezed,}) {
  return _then(_PlanReason(
label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,minutes: null == minutes ? _self.minutes : minutes // ignore: cast_nullable_to_non_nullable
as int,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String,adjusted: null == adjusted ? _self.adjusted : adjusted // ignore: cast_nullable_to_non_nullable
as bool,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$PlanBreakdown {

 int get prepMinutes; int get extraPrepMinutes; int get personalRoutineMinutes; int get travelMinutes; int get trafficBufferMinutes;
/// Create a copy of PlanBreakdown
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlanBreakdownCopyWith<PlanBreakdown> get copyWith => _$PlanBreakdownCopyWithImpl<PlanBreakdown>(this as PlanBreakdown, _$identity);

  /// Serializes this PlanBreakdown to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlanBreakdown&&(identical(other.prepMinutes, prepMinutes) || other.prepMinutes == prepMinutes)&&(identical(other.extraPrepMinutes, extraPrepMinutes) || other.extraPrepMinutes == extraPrepMinutes)&&(identical(other.personalRoutineMinutes, personalRoutineMinutes) || other.personalRoutineMinutes == personalRoutineMinutes)&&(identical(other.travelMinutes, travelMinutes) || other.travelMinutes == travelMinutes)&&(identical(other.trafficBufferMinutes, trafficBufferMinutes) || other.trafficBufferMinutes == trafficBufferMinutes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,prepMinutes,extraPrepMinutes,personalRoutineMinutes,travelMinutes,trafficBufferMinutes);

@override
String toString() {
  return 'PlanBreakdown(prepMinutes: $prepMinutes, extraPrepMinutes: $extraPrepMinutes, personalRoutineMinutes: $personalRoutineMinutes, travelMinutes: $travelMinutes, trafficBufferMinutes: $trafficBufferMinutes)';
}


}

/// @nodoc
abstract mixin class $PlanBreakdownCopyWith<$Res>  {
  factory $PlanBreakdownCopyWith(PlanBreakdown value, $Res Function(PlanBreakdown) _then) = _$PlanBreakdownCopyWithImpl;
@useResult
$Res call({
 int prepMinutes, int extraPrepMinutes, int personalRoutineMinutes, int travelMinutes, int trafficBufferMinutes
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
@pragma('vm:prefer-inline') @override $Res call({Object? prepMinutes = null,Object? extraPrepMinutes = null,Object? personalRoutineMinutes = null,Object? travelMinutes = null,Object? trafficBufferMinutes = null,}) {
  return _then(_self.copyWith(
prepMinutes: null == prepMinutes ? _self.prepMinutes : prepMinutes // ignore: cast_nullable_to_non_nullable
as int,extraPrepMinutes: null == extraPrepMinutes ? _self.extraPrepMinutes : extraPrepMinutes // ignore: cast_nullable_to_non_nullable
as int,personalRoutineMinutes: null == personalRoutineMinutes ? _self.personalRoutineMinutes : personalRoutineMinutes // ignore: cast_nullable_to_non_nullable
as int,travelMinutes: null == travelMinutes ? _self.travelMinutes : travelMinutes // ignore: cast_nullable_to_non_nullable
as int,trafficBufferMinutes: null == trafficBufferMinutes ? _self.trafficBufferMinutes : trafficBufferMinutes // ignore: cast_nullable_to_non_nullable
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int prepMinutes,  int extraPrepMinutes,  int personalRoutineMinutes,  int travelMinutes,  int trafficBufferMinutes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PlanBreakdown() when $default != null:
return $default(_that.prepMinutes,_that.extraPrepMinutes,_that.personalRoutineMinutes,_that.travelMinutes,_that.trafficBufferMinutes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int prepMinutes,  int extraPrepMinutes,  int personalRoutineMinutes,  int travelMinutes,  int trafficBufferMinutes)  $default,) {final _that = this;
switch (_that) {
case _PlanBreakdown():
return $default(_that.prepMinutes,_that.extraPrepMinutes,_that.personalRoutineMinutes,_that.travelMinutes,_that.trafficBufferMinutes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int prepMinutes,  int extraPrepMinutes,  int personalRoutineMinutes,  int travelMinutes,  int trafficBufferMinutes)?  $default,) {final _that = this;
switch (_that) {
case _PlanBreakdown() when $default != null:
return $default(_that.prepMinutes,_that.extraPrepMinutes,_that.personalRoutineMinutes,_that.travelMinutes,_that.trafficBufferMinutes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PlanBreakdown implements PlanBreakdown {
  const _PlanBreakdown({required this.prepMinutes, required this.extraPrepMinutes, required this.personalRoutineMinutes, required this.travelMinutes, required this.trafficBufferMinutes});
  factory _PlanBreakdown.fromJson(Map<String, dynamic> json) => _$PlanBreakdownFromJson(json);

@override final  int prepMinutes;
@override final  int extraPrepMinutes;
@override final  int personalRoutineMinutes;
@override final  int travelMinutes;
@override final  int trafficBufferMinutes;

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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlanBreakdown&&(identical(other.prepMinutes, prepMinutes) || other.prepMinutes == prepMinutes)&&(identical(other.extraPrepMinutes, extraPrepMinutes) || other.extraPrepMinutes == extraPrepMinutes)&&(identical(other.personalRoutineMinutes, personalRoutineMinutes) || other.personalRoutineMinutes == personalRoutineMinutes)&&(identical(other.travelMinutes, travelMinutes) || other.travelMinutes == travelMinutes)&&(identical(other.trafficBufferMinutes, trafficBufferMinutes) || other.trafficBufferMinutes == trafficBufferMinutes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,prepMinutes,extraPrepMinutes,personalRoutineMinutes,travelMinutes,trafficBufferMinutes);

@override
String toString() {
  return 'PlanBreakdown(prepMinutes: $prepMinutes, extraPrepMinutes: $extraPrepMinutes, personalRoutineMinutes: $personalRoutineMinutes, travelMinutes: $travelMinutes, trafficBufferMinutes: $trafficBufferMinutes)';
}


}

/// @nodoc
abstract mixin class _$PlanBreakdownCopyWith<$Res> implements $PlanBreakdownCopyWith<$Res> {
  factory _$PlanBreakdownCopyWith(_PlanBreakdown value, $Res Function(_PlanBreakdown) _then) = __$PlanBreakdownCopyWithImpl;
@override @useResult
$Res call({
 int prepMinutes, int extraPrepMinutes, int personalRoutineMinutes, int travelMinutes, int trafficBufferMinutes
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
@override @pragma('vm:prefer-inline') $Res call({Object? prepMinutes = null,Object? extraPrepMinutes = null,Object? personalRoutineMinutes = null,Object? travelMinutes = null,Object? trafficBufferMinutes = null,}) {
  return _then(_PlanBreakdown(
prepMinutes: null == prepMinutes ? _self.prepMinutes : prepMinutes // ignore: cast_nullable_to_non_nullable
as int,extraPrepMinutes: null == extraPrepMinutes ? _self.extraPrepMinutes : extraPrepMinutes // ignore: cast_nullable_to_non_nullable
as int,personalRoutineMinutes: null == personalRoutineMinutes ? _self.personalRoutineMinutes : personalRoutineMinutes // ignore: cast_nullable_to_non_nullable
as int,travelMinutes: null == travelMinutes ? _self.travelMinutes : travelMinutes // ignore: cast_nullable_to_non_nullable
as int,trafficBufferMinutes: null == trafficBufferMinutes ? _self.trafficBufferMinutes : trafficBufferMinutes // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$ChecklistItem {

 String get itemId; String get itemName; ChecklistSourceType get sourceType; String get actionType;// carry | consume | purchase | routine
 ChecklistCompletionStatus get completionStatus; String? get reason; bool get private;
/// Create a copy of ChecklistItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChecklistItemCopyWith<ChecklistItem> get copyWith => _$ChecklistItemCopyWithImpl<ChecklistItem>(this as ChecklistItem, _$identity);

  /// Serializes this ChecklistItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChecklistItem&&(identical(other.itemId, itemId) || other.itemId == itemId)&&(identical(other.itemName, itemName) || other.itemName == itemName)&&(identical(other.sourceType, sourceType) || other.sourceType == sourceType)&&(identical(other.actionType, actionType) || other.actionType == actionType)&&(identical(other.completionStatus, completionStatus) || other.completionStatus == completionStatus)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.private, private) || other.private == private));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,itemId,itemName,sourceType,actionType,completionStatus,reason,private);

@override
String toString() {
  return 'ChecklistItem(itemId: $itemId, itemName: $itemName, sourceType: $sourceType, actionType: $actionType, completionStatus: $completionStatus, reason: $reason, private: $private)';
}


}

/// @nodoc
abstract mixin class $ChecklistItemCopyWith<$Res>  {
  factory $ChecklistItemCopyWith(ChecklistItem value, $Res Function(ChecklistItem) _then) = _$ChecklistItemCopyWithImpl;
@useResult
$Res call({
 String itemId, String itemName, ChecklistSourceType sourceType, String actionType, ChecklistCompletionStatus completionStatus, String? reason, bool private
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
@pragma('vm:prefer-inline') @override $Res call({Object? itemId = null,Object? itemName = null,Object? sourceType = null,Object? actionType = null,Object? completionStatus = null,Object? reason = freezed,Object? private = null,}) {
  return _then(_self.copyWith(
itemId: null == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as String,itemName: null == itemName ? _self.itemName : itemName // ignore: cast_nullable_to_non_nullable
as String,sourceType: null == sourceType ? _self.sourceType : sourceType // ignore: cast_nullable_to_non_nullable
as ChecklistSourceType,actionType: null == actionType ? _self.actionType : actionType // ignore: cast_nullable_to_non_nullable
as String,completionStatus: null == completionStatus ? _self.completionStatus : completionStatus // ignore: cast_nullable_to_non_nullable
as ChecklistCompletionStatus,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,private: null == private ? _self.private : private // ignore: cast_nullable_to_non_nullable
as bool,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String itemId,  String itemName,  ChecklistSourceType sourceType,  String actionType,  ChecklistCompletionStatus completionStatus,  String? reason,  bool private)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChecklistItem() when $default != null:
return $default(_that.itemId,_that.itemName,_that.sourceType,_that.actionType,_that.completionStatus,_that.reason,_that.private);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String itemId,  String itemName,  ChecklistSourceType sourceType,  String actionType,  ChecklistCompletionStatus completionStatus,  String? reason,  bool private)  $default,) {final _that = this;
switch (_that) {
case _ChecklistItem():
return $default(_that.itemId,_that.itemName,_that.sourceType,_that.actionType,_that.completionStatus,_that.reason,_that.private);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String itemId,  String itemName,  ChecklistSourceType sourceType,  String actionType,  ChecklistCompletionStatus completionStatus,  String? reason,  bool private)?  $default,) {final _that = this;
switch (_that) {
case _ChecklistItem() when $default != null:
return $default(_that.itemId,_that.itemName,_that.sourceType,_that.actionType,_that.completionStatus,_that.reason,_that.private);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChecklistItem implements ChecklistItem {
  const _ChecklistItem({required this.itemId, required this.itemName, required this.sourceType, required this.actionType, required this.completionStatus, this.reason, this.private = false});
  factory _ChecklistItem.fromJson(Map<String, dynamic> json) => _$ChecklistItemFromJson(json);

@override final  String itemId;
@override final  String itemName;
@override final  ChecklistSourceType sourceType;
@override final  String actionType;
// carry | consume | purchase | routine
@override final  ChecklistCompletionStatus completionStatus;
@override final  String? reason;
@override@JsonKey() final  bool private;

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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChecklistItem&&(identical(other.itemId, itemId) || other.itemId == itemId)&&(identical(other.itemName, itemName) || other.itemName == itemName)&&(identical(other.sourceType, sourceType) || other.sourceType == sourceType)&&(identical(other.actionType, actionType) || other.actionType == actionType)&&(identical(other.completionStatus, completionStatus) || other.completionStatus == completionStatus)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.private, private) || other.private == private));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,itemId,itemName,sourceType,actionType,completionStatus,reason,private);

@override
String toString() {
  return 'ChecklistItem(itemId: $itemId, itemName: $itemName, sourceType: $sourceType, actionType: $actionType, completionStatus: $completionStatus, reason: $reason, private: $private)';
}


}

/// @nodoc
abstract mixin class _$ChecklistItemCopyWith<$Res> implements $ChecklistItemCopyWith<$Res> {
  factory _$ChecklistItemCopyWith(_ChecklistItem value, $Res Function(_ChecklistItem) _then) = __$ChecklistItemCopyWithImpl;
@override @useResult
$Res call({
 String itemId, String itemName, ChecklistSourceType sourceType, String actionType, ChecklistCompletionStatus completionStatus, String? reason, bool private
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
@override @pragma('vm:prefer-inline') $Res call({Object? itemId = null,Object? itemName = null,Object? sourceType = null,Object? actionType = null,Object? completionStatus = null,Object? reason = freezed,Object? private = null,}) {
  return _then(_ChecklistItem(
itemId: null == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as String,itemName: null == itemName ? _self.itemName : itemName // ignore: cast_nullable_to_non_nullable
as String,sourceType: null == sourceType ? _self.sourceType : sourceType // ignore: cast_nullable_to_non_nullable
as ChecklistSourceType,actionType: null == actionType ? _self.actionType : actionType // ignore: cast_nullable_to_non_nullable
as String,completionStatus: null == completionStatus ? _self.completionStatus : completionStatus // ignore: cast_nullable_to_non_nullable
as ChecklistCompletionStatus,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,private: null == private ? _self.private : private // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$WellnessSummary {

 int get wisScore; String get weightVersion; int get actionsShown; bool get eventArmed;
/// Create a copy of WellnessSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WellnessSummaryCopyWith<WellnessSummary> get copyWith => _$WellnessSummaryCopyWithImpl<WellnessSummary>(this as WellnessSummary, _$identity);

  /// Serializes this WellnessSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WellnessSummary&&(identical(other.wisScore, wisScore) || other.wisScore == wisScore)&&(identical(other.weightVersion, weightVersion) || other.weightVersion == weightVersion)&&(identical(other.actionsShown, actionsShown) || other.actionsShown == actionsShown)&&(identical(other.eventArmed, eventArmed) || other.eventArmed == eventArmed));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,wisScore,weightVersion,actionsShown,eventArmed);

@override
String toString() {
  return 'WellnessSummary(wisScore: $wisScore, weightVersion: $weightVersion, actionsShown: $actionsShown, eventArmed: $eventArmed)';
}


}

/// @nodoc
abstract mixin class $WellnessSummaryCopyWith<$Res>  {
  factory $WellnessSummaryCopyWith(WellnessSummary value, $Res Function(WellnessSummary) _then) = _$WellnessSummaryCopyWithImpl;
@useResult
$Res call({
 int wisScore, String weightVersion, int actionsShown, bool eventArmed
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
@pragma('vm:prefer-inline') @override $Res call({Object? wisScore = null,Object? weightVersion = null,Object? actionsShown = null,Object? eventArmed = null,}) {
  return _then(_self.copyWith(
wisScore: null == wisScore ? _self.wisScore : wisScore // ignore: cast_nullable_to_non_nullable
as int,weightVersion: null == weightVersion ? _self.weightVersion : weightVersion // ignore: cast_nullable_to_non_nullable
as String,actionsShown: null == actionsShown ? _self.actionsShown : actionsShown // ignore: cast_nullable_to_non_nullable
as int,eventArmed: null == eventArmed ? _self.eventArmed : eventArmed // ignore: cast_nullable_to_non_nullable
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int wisScore,  String weightVersion,  int actionsShown,  bool eventArmed)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WellnessSummary() when $default != null:
return $default(_that.wisScore,_that.weightVersion,_that.actionsShown,_that.eventArmed);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int wisScore,  String weightVersion,  int actionsShown,  bool eventArmed)  $default,) {final _that = this;
switch (_that) {
case _WellnessSummary():
return $default(_that.wisScore,_that.weightVersion,_that.actionsShown,_that.eventArmed);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int wisScore,  String weightVersion,  int actionsShown,  bool eventArmed)?  $default,) {final _that = this;
switch (_that) {
case _WellnessSummary() when $default != null:
return $default(_that.wisScore,_that.weightVersion,_that.actionsShown,_that.eventArmed);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WellnessSummary implements WellnessSummary {
  const _WellnessSummary({required this.wisScore, required this.weightVersion, required this.actionsShown, required this.eventArmed});
  factory _WellnessSummary.fromJson(Map<String, dynamic> json) => _$WellnessSummaryFromJson(json);

@override final  int wisScore;
@override final  String weightVersion;
@override final  int actionsShown;
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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WellnessSummary&&(identical(other.wisScore, wisScore) || other.wisScore == wisScore)&&(identical(other.weightVersion, weightVersion) || other.weightVersion == weightVersion)&&(identical(other.actionsShown, actionsShown) || other.actionsShown == actionsShown)&&(identical(other.eventArmed, eventArmed) || other.eventArmed == eventArmed));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,wisScore,weightVersion,actionsShown,eventArmed);

@override
String toString() {
  return 'WellnessSummary(wisScore: $wisScore, weightVersion: $weightVersion, actionsShown: $actionsShown, eventArmed: $eventArmed)';
}


}

/// @nodoc
abstract mixin class _$WellnessSummaryCopyWith<$Res> implements $WellnessSummaryCopyWith<$Res> {
  factory _$WellnessSummaryCopyWith(_WellnessSummary value, $Res Function(_WellnessSummary) _then) = __$WellnessSummaryCopyWithImpl;
@override @useResult
$Res call({
 int wisScore, String weightVersion, int actionsShown, bool eventArmed
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
@override @pragma('vm:prefer-inline') $Res call({Object? wisScore = null,Object? weightVersion = null,Object? actionsShown = null,Object? eventArmed = null,}) {
  return _then(_WellnessSummary(
wisScore: null == wisScore ? _self.wisScore : wisScore // ignore: cast_nullable_to_non_nullable
as int,weightVersion: null == weightVersion ? _self.weightVersion : weightVersion // ignore: cast_nullable_to_non_nullable
as String,actionsShown: null == actionsShown ? _self.actionsShown : actionsShown // ignore: cast_nullable_to_non_nullable
as int,eventArmed: null == eventArmed ? _self.eventArmed : eventArmed // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$Plan {

 String get planId; String get eventId; int get revisionNo; String get calcVersion; PlanStatus get planStatus; EventLifecycleStatus get eventStatus; bool get feasible; DateTime get prepStartAt; DateTime get recommendedDepartAt; DateTime get targetArriveAt; List<PlanReason> get reasons; PlanBreakdown get breakdown; List<ChecklistItem> get checklist; WellnessSummary? get wellness; List<String> get degraded;
/// Create a copy of Plan
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlanCopyWith<Plan> get copyWith => _$PlanCopyWithImpl<Plan>(this as Plan, _$identity);

  /// Serializes this Plan to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Plan&&(identical(other.planId, planId) || other.planId == planId)&&(identical(other.eventId, eventId) || other.eventId == eventId)&&(identical(other.revisionNo, revisionNo) || other.revisionNo == revisionNo)&&(identical(other.calcVersion, calcVersion) || other.calcVersion == calcVersion)&&(identical(other.planStatus, planStatus) || other.planStatus == planStatus)&&(identical(other.eventStatus, eventStatus) || other.eventStatus == eventStatus)&&(identical(other.feasible, feasible) || other.feasible == feasible)&&(identical(other.prepStartAt, prepStartAt) || other.prepStartAt == prepStartAt)&&(identical(other.recommendedDepartAt, recommendedDepartAt) || other.recommendedDepartAt == recommendedDepartAt)&&(identical(other.targetArriveAt, targetArriveAt) || other.targetArriveAt == targetArriveAt)&&const DeepCollectionEquality().equals(other.reasons, reasons)&&(identical(other.breakdown, breakdown) || other.breakdown == breakdown)&&const DeepCollectionEquality().equals(other.checklist, checklist)&&(identical(other.wellness, wellness) || other.wellness == wellness)&&const DeepCollectionEquality().equals(other.degraded, degraded));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,planId,eventId,revisionNo,calcVersion,planStatus,eventStatus,feasible,prepStartAt,recommendedDepartAt,targetArriveAt,const DeepCollectionEquality().hash(reasons),breakdown,const DeepCollectionEquality().hash(checklist),wellness,const DeepCollectionEquality().hash(degraded));

@override
String toString() {
  return 'Plan(planId: $planId, eventId: $eventId, revisionNo: $revisionNo, calcVersion: $calcVersion, planStatus: $planStatus, eventStatus: $eventStatus, feasible: $feasible, prepStartAt: $prepStartAt, recommendedDepartAt: $recommendedDepartAt, targetArriveAt: $targetArriveAt, reasons: $reasons, breakdown: $breakdown, checklist: $checklist, wellness: $wellness, degraded: $degraded)';
}


}

/// @nodoc
abstract mixin class $PlanCopyWith<$Res>  {
  factory $PlanCopyWith(Plan value, $Res Function(Plan) _then) = _$PlanCopyWithImpl;
@useResult
$Res call({
 String planId, String eventId, int revisionNo, String calcVersion, PlanStatus planStatus, EventLifecycleStatus eventStatus, bool feasible, DateTime prepStartAt, DateTime recommendedDepartAt, DateTime targetArriveAt, List<PlanReason> reasons, PlanBreakdown breakdown, List<ChecklistItem> checklist, WellnessSummary? wellness, List<String> degraded
});


$PlanBreakdownCopyWith<$Res> get breakdown;$WellnessSummaryCopyWith<$Res>? get wellness;

}
/// @nodoc
class _$PlanCopyWithImpl<$Res>
    implements $PlanCopyWith<$Res> {
  _$PlanCopyWithImpl(this._self, this._then);

  final Plan _self;
  final $Res Function(Plan) _then;

/// Create a copy of Plan
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? planId = null,Object? eventId = null,Object? revisionNo = null,Object? calcVersion = null,Object? planStatus = null,Object? eventStatus = null,Object? feasible = null,Object? prepStartAt = null,Object? recommendedDepartAt = null,Object? targetArriveAt = null,Object? reasons = null,Object? breakdown = null,Object? checklist = null,Object? wellness = freezed,Object? degraded = null,}) {
  return _then(_self.copyWith(
planId: null == planId ? _self.planId : planId // ignore: cast_nullable_to_non_nullable
as String,eventId: null == eventId ? _self.eventId : eventId // ignore: cast_nullable_to_non_nullable
as String,revisionNo: null == revisionNo ? _self.revisionNo : revisionNo // ignore: cast_nullable_to_non_nullable
as int,calcVersion: null == calcVersion ? _self.calcVersion : calcVersion // ignore: cast_nullable_to_non_nullable
as String,planStatus: null == planStatus ? _self.planStatus : planStatus // ignore: cast_nullable_to_non_nullable
as PlanStatus,eventStatus: null == eventStatus ? _self.eventStatus : eventStatus // ignore: cast_nullable_to_non_nullable
as EventLifecycleStatus,feasible: null == feasible ? _self.feasible : feasible // ignore: cast_nullable_to_non_nullable
as bool,prepStartAt: null == prepStartAt ? _self.prepStartAt : prepStartAt // ignore: cast_nullable_to_non_nullable
as DateTime,recommendedDepartAt: null == recommendedDepartAt ? _self.recommendedDepartAt : recommendedDepartAt // ignore: cast_nullable_to_non_nullable
as DateTime,targetArriveAt: null == targetArriveAt ? _self.targetArriveAt : targetArriveAt // ignore: cast_nullable_to_non_nullable
as DateTime,reasons: null == reasons ? _self.reasons : reasons // ignore: cast_nullable_to_non_nullable
as List<PlanReason>,breakdown: null == breakdown ? _self.breakdown : breakdown // ignore: cast_nullable_to_non_nullable
as PlanBreakdown,checklist: null == checklist ? _self.checklist : checklist // ignore: cast_nullable_to_non_nullable
as List<ChecklistItem>,wellness: freezed == wellness ? _self.wellness : wellness // ignore: cast_nullable_to_non_nullable
as WellnessSummary?,degraded: null == degraded ? _self.degraded : degraded // ignore: cast_nullable_to_non_nullable
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String planId,  String eventId,  int revisionNo,  String calcVersion,  PlanStatus planStatus,  EventLifecycleStatus eventStatus,  bool feasible,  DateTime prepStartAt,  DateTime recommendedDepartAt,  DateTime targetArriveAt,  List<PlanReason> reasons,  PlanBreakdown breakdown,  List<ChecklistItem> checklist,  WellnessSummary? wellness,  List<String> degraded)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Plan() when $default != null:
return $default(_that.planId,_that.eventId,_that.revisionNo,_that.calcVersion,_that.planStatus,_that.eventStatus,_that.feasible,_that.prepStartAt,_that.recommendedDepartAt,_that.targetArriveAt,_that.reasons,_that.breakdown,_that.checklist,_that.wellness,_that.degraded);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String planId,  String eventId,  int revisionNo,  String calcVersion,  PlanStatus planStatus,  EventLifecycleStatus eventStatus,  bool feasible,  DateTime prepStartAt,  DateTime recommendedDepartAt,  DateTime targetArriveAt,  List<PlanReason> reasons,  PlanBreakdown breakdown,  List<ChecklistItem> checklist,  WellnessSummary? wellness,  List<String> degraded)  $default,) {final _that = this;
switch (_that) {
case _Plan():
return $default(_that.planId,_that.eventId,_that.revisionNo,_that.calcVersion,_that.planStatus,_that.eventStatus,_that.feasible,_that.prepStartAt,_that.recommendedDepartAt,_that.targetArriveAt,_that.reasons,_that.breakdown,_that.checklist,_that.wellness,_that.degraded);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String planId,  String eventId,  int revisionNo,  String calcVersion,  PlanStatus planStatus,  EventLifecycleStatus eventStatus,  bool feasible,  DateTime prepStartAt,  DateTime recommendedDepartAt,  DateTime targetArriveAt,  List<PlanReason> reasons,  PlanBreakdown breakdown,  List<ChecklistItem> checklist,  WellnessSummary? wellness,  List<String> degraded)?  $default,) {final _that = this;
switch (_that) {
case _Plan() when $default != null:
return $default(_that.planId,_that.eventId,_that.revisionNo,_that.calcVersion,_that.planStatus,_that.eventStatus,_that.feasible,_that.prepStartAt,_that.recommendedDepartAt,_that.targetArriveAt,_that.reasons,_that.breakdown,_that.checklist,_that.wellness,_that.degraded);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Plan implements Plan {
  const _Plan({required this.planId, required this.eventId, required this.revisionNo, required this.calcVersion, required this.planStatus, required this.eventStatus, required this.feasible, required this.prepStartAt, required this.recommendedDepartAt, required this.targetArriveAt, required final  List<PlanReason> reasons, required this.breakdown, required final  List<ChecklistItem> checklist, this.wellness, final  List<String> degraded = const []}): _reasons = reasons,_checklist = checklist,_degraded = degraded;
  factory _Plan.fromJson(Map<String, dynamic> json) => _$PlanFromJson(json);

@override final  String planId;
@override final  String eventId;
@override final  int revisionNo;
@override final  String calcVersion;
@override final  PlanStatus planStatus;
@override final  EventLifecycleStatus eventStatus;
@override final  bool feasible;
@override final  DateTime prepStartAt;
@override final  DateTime recommendedDepartAt;
@override final  DateTime targetArriveAt;
 final  List<PlanReason> _reasons;
@override List<PlanReason> get reasons {
  if (_reasons is EqualUnmodifiableListView) return _reasons;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_reasons);
}

@override final  PlanBreakdown breakdown;
 final  List<ChecklistItem> _checklist;
@override List<ChecklistItem> get checklist {
  if (_checklist is EqualUnmodifiableListView) return _checklist;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_checklist);
}

@override final  WellnessSummary? wellness;
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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Plan&&(identical(other.planId, planId) || other.planId == planId)&&(identical(other.eventId, eventId) || other.eventId == eventId)&&(identical(other.revisionNo, revisionNo) || other.revisionNo == revisionNo)&&(identical(other.calcVersion, calcVersion) || other.calcVersion == calcVersion)&&(identical(other.planStatus, planStatus) || other.planStatus == planStatus)&&(identical(other.eventStatus, eventStatus) || other.eventStatus == eventStatus)&&(identical(other.feasible, feasible) || other.feasible == feasible)&&(identical(other.prepStartAt, prepStartAt) || other.prepStartAt == prepStartAt)&&(identical(other.recommendedDepartAt, recommendedDepartAt) || other.recommendedDepartAt == recommendedDepartAt)&&(identical(other.targetArriveAt, targetArriveAt) || other.targetArriveAt == targetArriveAt)&&const DeepCollectionEquality().equals(other._reasons, _reasons)&&(identical(other.breakdown, breakdown) || other.breakdown == breakdown)&&const DeepCollectionEquality().equals(other._checklist, _checklist)&&(identical(other.wellness, wellness) || other.wellness == wellness)&&const DeepCollectionEquality().equals(other._degraded, _degraded));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,planId,eventId,revisionNo,calcVersion,planStatus,eventStatus,feasible,prepStartAt,recommendedDepartAt,targetArriveAt,const DeepCollectionEquality().hash(_reasons),breakdown,const DeepCollectionEquality().hash(_checklist),wellness,const DeepCollectionEquality().hash(_degraded));

@override
String toString() {
  return 'Plan(planId: $planId, eventId: $eventId, revisionNo: $revisionNo, calcVersion: $calcVersion, planStatus: $planStatus, eventStatus: $eventStatus, feasible: $feasible, prepStartAt: $prepStartAt, recommendedDepartAt: $recommendedDepartAt, targetArriveAt: $targetArriveAt, reasons: $reasons, breakdown: $breakdown, checklist: $checklist, wellness: $wellness, degraded: $degraded)';
}


}

/// @nodoc
abstract mixin class _$PlanCopyWith<$Res> implements $PlanCopyWith<$Res> {
  factory _$PlanCopyWith(_Plan value, $Res Function(_Plan) _then) = __$PlanCopyWithImpl;
@override @useResult
$Res call({
 String planId, String eventId, int revisionNo, String calcVersion, PlanStatus planStatus, EventLifecycleStatus eventStatus, bool feasible, DateTime prepStartAt, DateTime recommendedDepartAt, DateTime targetArriveAt, List<PlanReason> reasons, PlanBreakdown breakdown, List<ChecklistItem> checklist, WellnessSummary? wellness, List<String> degraded
});


@override $PlanBreakdownCopyWith<$Res> get breakdown;@override $WellnessSummaryCopyWith<$Res>? get wellness;

}
/// @nodoc
class __$PlanCopyWithImpl<$Res>
    implements _$PlanCopyWith<$Res> {
  __$PlanCopyWithImpl(this._self, this._then);

  final _Plan _self;
  final $Res Function(_Plan) _then;

/// Create a copy of Plan
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? planId = null,Object? eventId = null,Object? revisionNo = null,Object? calcVersion = null,Object? planStatus = null,Object? eventStatus = null,Object? feasible = null,Object? prepStartAt = null,Object? recommendedDepartAt = null,Object? targetArriveAt = null,Object? reasons = null,Object? breakdown = null,Object? checklist = null,Object? wellness = freezed,Object? degraded = null,}) {
  return _then(_Plan(
planId: null == planId ? _self.planId : planId // ignore: cast_nullable_to_non_nullable
as String,eventId: null == eventId ? _self.eventId : eventId // ignore: cast_nullable_to_non_nullable
as String,revisionNo: null == revisionNo ? _self.revisionNo : revisionNo // ignore: cast_nullable_to_non_nullable
as int,calcVersion: null == calcVersion ? _self.calcVersion : calcVersion // ignore: cast_nullable_to_non_nullable
as String,planStatus: null == planStatus ? _self.planStatus : planStatus // ignore: cast_nullable_to_non_nullable
as PlanStatus,eventStatus: null == eventStatus ? _self.eventStatus : eventStatus // ignore: cast_nullable_to_non_nullable
as EventLifecycleStatus,feasible: null == feasible ? _self.feasible : feasible // ignore: cast_nullable_to_non_nullable
as bool,prepStartAt: null == prepStartAt ? _self.prepStartAt : prepStartAt // ignore: cast_nullable_to_non_nullable
as DateTime,recommendedDepartAt: null == recommendedDepartAt ? _self.recommendedDepartAt : recommendedDepartAt // ignore: cast_nullable_to_non_nullable
as DateTime,targetArriveAt: null == targetArriveAt ? _self.targetArriveAt : targetArriveAt // ignore: cast_nullable_to_non_nullable
as DateTime,reasons: null == reasons ? _self._reasons : reasons // ignore: cast_nullable_to_non_nullable
as List<PlanReason>,breakdown: null == breakdown ? _self.breakdown : breakdown // ignore: cast_nullable_to_non_nullable
as PlanBreakdown,checklist: null == checklist ? _self._checklist : checklist // ignore: cast_nullable_to_non_nullable
as List<ChecklistItem>,wellness: freezed == wellness ? _self.wellness : wellness // ignore: cast_nullable_to_non_nullable
as WellnessSummary?,degraded: null == degraded ? _self._degraded : degraded // ignore: cast_nullable_to_non_nullable
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
}
}


/// @nodoc
mixin _$RouteOption {

 String get routeId; RouteRank get rank; int get totalSec; int get walkSec; int get transfers; int get outdoorSec;
/// Create a copy of RouteOption
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RouteOptionCopyWith<RouteOption> get copyWith => _$RouteOptionCopyWithImpl<RouteOption>(this as RouteOption, _$identity);

  /// Serializes this RouteOption to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RouteOption&&(identical(other.routeId, routeId) || other.routeId == routeId)&&(identical(other.rank, rank) || other.rank == rank)&&(identical(other.totalSec, totalSec) || other.totalSec == totalSec)&&(identical(other.walkSec, walkSec) || other.walkSec == walkSec)&&(identical(other.transfers, transfers) || other.transfers == transfers)&&(identical(other.outdoorSec, outdoorSec) || other.outdoorSec == outdoorSec));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,routeId,rank,totalSec,walkSec,transfers,outdoorSec);

@override
String toString() {
  return 'RouteOption(routeId: $routeId, rank: $rank, totalSec: $totalSec, walkSec: $walkSec, transfers: $transfers, outdoorSec: $outdoorSec)';
}


}

/// @nodoc
abstract mixin class $RouteOptionCopyWith<$Res>  {
  factory $RouteOptionCopyWith(RouteOption value, $Res Function(RouteOption) _then) = _$RouteOptionCopyWithImpl;
@useResult
$Res call({
 String routeId, RouteRank rank, int totalSec, int walkSec, int transfers, int outdoorSec
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
@pragma('vm:prefer-inline') @override $Res call({Object? routeId = null,Object? rank = null,Object? totalSec = null,Object? walkSec = null,Object? transfers = null,Object? outdoorSec = null,}) {
  return _then(_self.copyWith(
routeId: null == routeId ? _self.routeId : routeId // ignore: cast_nullable_to_non_nullable
as String,rank: null == rank ? _self.rank : rank // ignore: cast_nullable_to_non_nullable
as RouteRank,totalSec: null == totalSec ? _self.totalSec : totalSec // ignore: cast_nullable_to_non_nullable
as int,walkSec: null == walkSec ? _self.walkSec : walkSec // ignore: cast_nullable_to_non_nullable
as int,transfers: null == transfers ? _self.transfers : transfers // ignore: cast_nullable_to_non_nullable
as int,outdoorSec: null == outdoorSec ? _self.outdoorSec : outdoorSec // ignore: cast_nullable_to_non_nullable
as int,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String routeId,  RouteRank rank,  int totalSec,  int walkSec,  int transfers,  int outdoorSec)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RouteOption() when $default != null:
return $default(_that.routeId,_that.rank,_that.totalSec,_that.walkSec,_that.transfers,_that.outdoorSec);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String routeId,  RouteRank rank,  int totalSec,  int walkSec,  int transfers,  int outdoorSec)  $default,) {final _that = this;
switch (_that) {
case _RouteOption():
return $default(_that.routeId,_that.rank,_that.totalSec,_that.walkSec,_that.transfers,_that.outdoorSec);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String routeId,  RouteRank rank,  int totalSec,  int walkSec,  int transfers,  int outdoorSec)?  $default,) {final _that = this;
switch (_that) {
case _RouteOption() when $default != null:
return $default(_that.routeId,_that.rank,_that.totalSec,_that.walkSec,_that.transfers,_that.outdoorSec);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RouteOption implements RouteOption {
  const _RouteOption({required this.routeId, required this.rank, required this.totalSec, required this.walkSec, required this.transfers, required this.outdoorSec});
  factory _RouteOption.fromJson(Map<String, dynamic> json) => _$RouteOptionFromJson(json);

@override final  String routeId;
@override final  RouteRank rank;
@override final  int totalSec;
@override final  int walkSec;
@override final  int transfers;
@override final  int outdoorSec;

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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RouteOption&&(identical(other.routeId, routeId) || other.routeId == routeId)&&(identical(other.rank, rank) || other.rank == rank)&&(identical(other.totalSec, totalSec) || other.totalSec == totalSec)&&(identical(other.walkSec, walkSec) || other.walkSec == walkSec)&&(identical(other.transfers, transfers) || other.transfers == transfers)&&(identical(other.outdoorSec, outdoorSec) || other.outdoorSec == outdoorSec));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,routeId,rank,totalSec,walkSec,transfers,outdoorSec);

@override
String toString() {
  return 'RouteOption(routeId: $routeId, rank: $rank, totalSec: $totalSec, walkSec: $walkSec, transfers: $transfers, outdoorSec: $outdoorSec)';
}


}

/// @nodoc
abstract mixin class _$RouteOptionCopyWith<$Res> implements $RouteOptionCopyWith<$Res> {
  factory _$RouteOptionCopyWith(_RouteOption value, $Res Function(_RouteOption) _then) = __$RouteOptionCopyWithImpl;
@override @useResult
$Res call({
 String routeId, RouteRank rank, int totalSec, int walkSec, int transfers, int outdoorSec
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
@override @pragma('vm:prefer-inline') $Res call({Object? routeId = null,Object? rank = null,Object? totalSec = null,Object? walkSec = null,Object? transfers = null,Object? outdoorSec = null,}) {
  return _then(_RouteOption(
routeId: null == routeId ? _self.routeId : routeId // ignore: cast_nullable_to_non_nullable
as String,rank: null == rank ? _self.rank : rank // ignore: cast_nullable_to_non_nullable
as RouteRank,totalSec: null == totalSec ? _self.totalSec : totalSec // ignore: cast_nullable_to_non_nullable
as int,walkSec: null == walkSec ? _self.walkSec : walkSec // ignore: cast_nullable_to_non_nullable
as int,transfers: null == transfers ? _self.transfers : transfers // ignore: cast_nullable_to_non_nullable
as int,outdoorSec: null == outdoorSec ? _self.outdoorSec : outdoorSec // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
