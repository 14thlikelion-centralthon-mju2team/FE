// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wellness_pref.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WellnessPref {

 String get topic;// uv | pm | heat | precipitation | hydration
 bool get isEnabled; int get remindIntervalMinutes; int get dailyEventCap;
/// Create a copy of WellnessPref
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WellnessPrefCopyWith<WellnessPref> get copyWith => _$WellnessPrefCopyWithImpl<WellnessPref>(this as WellnessPref, _$identity);

  /// Serializes this WellnessPref to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WellnessPref&&(identical(other.topic, topic) || other.topic == topic)&&(identical(other.isEnabled, isEnabled) || other.isEnabled == isEnabled)&&(identical(other.remindIntervalMinutes, remindIntervalMinutes) || other.remindIntervalMinutes == remindIntervalMinutes)&&(identical(other.dailyEventCap, dailyEventCap) || other.dailyEventCap == dailyEventCap));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,topic,isEnabled,remindIntervalMinutes,dailyEventCap);

@override
String toString() {
  return 'WellnessPref(topic: $topic, isEnabled: $isEnabled, remindIntervalMinutes: $remindIntervalMinutes, dailyEventCap: $dailyEventCap)';
}


}

/// @nodoc
abstract mixin class $WellnessPrefCopyWith<$Res>  {
  factory $WellnessPrefCopyWith(WellnessPref value, $Res Function(WellnessPref) _then) = _$WellnessPrefCopyWithImpl;
@useResult
$Res call({
 String topic, bool isEnabled, int remindIntervalMinutes, int dailyEventCap
});




}
/// @nodoc
class _$WellnessPrefCopyWithImpl<$Res>
    implements $WellnessPrefCopyWith<$Res> {
  _$WellnessPrefCopyWithImpl(this._self, this._then);

  final WellnessPref _self;
  final $Res Function(WellnessPref) _then;

/// Create a copy of WellnessPref
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? topic = null,Object? isEnabled = null,Object? remindIntervalMinutes = null,Object? dailyEventCap = null,}) {
  return _then(_self.copyWith(
topic: null == topic ? _self.topic : topic // ignore: cast_nullable_to_non_nullable
as String,isEnabled: null == isEnabled ? _self.isEnabled : isEnabled // ignore: cast_nullable_to_non_nullable
as bool,remindIntervalMinutes: null == remindIntervalMinutes ? _self.remindIntervalMinutes : remindIntervalMinutes // ignore: cast_nullable_to_non_nullable
as int,dailyEventCap: null == dailyEventCap ? _self.dailyEventCap : dailyEventCap // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [WellnessPref].
extension WellnessPrefPatterns on WellnessPref {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WellnessPref value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WellnessPref() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WellnessPref value)  $default,){
final _that = this;
switch (_that) {
case _WellnessPref():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WellnessPref value)?  $default,){
final _that = this;
switch (_that) {
case _WellnessPref() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String topic,  bool isEnabled,  int remindIntervalMinutes,  int dailyEventCap)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WellnessPref() when $default != null:
return $default(_that.topic,_that.isEnabled,_that.remindIntervalMinutes,_that.dailyEventCap);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String topic,  bool isEnabled,  int remindIntervalMinutes,  int dailyEventCap)  $default,) {final _that = this;
switch (_that) {
case _WellnessPref():
return $default(_that.topic,_that.isEnabled,_that.remindIntervalMinutes,_that.dailyEventCap);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String topic,  bool isEnabled,  int remindIntervalMinutes,  int dailyEventCap)?  $default,) {final _that = this;
switch (_that) {
case _WellnessPref() when $default != null:
return $default(_that.topic,_that.isEnabled,_that.remindIntervalMinutes,_that.dailyEventCap);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WellnessPref implements WellnessPref {
  const _WellnessPref({required this.topic, required this.isEnabled, required this.remindIntervalMinutes, this.dailyEventCap = 1});
  factory _WellnessPref.fromJson(Map<String, dynamic> json) => _$WellnessPrefFromJson(json);

@override final  String topic;
// uv | pm | heat | precipitation | hydration
@override final  bool isEnabled;
@override final  int remindIntervalMinutes;
@override@JsonKey() final  int dailyEventCap;

/// Create a copy of WellnessPref
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WellnessPrefCopyWith<_WellnessPref> get copyWith => __$WellnessPrefCopyWithImpl<_WellnessPref>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WellnessPrefToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WellnessPref&&(identical(other.topic, topic) || other.topic == topic)&&(identical(other.isEnabled, isEnabled) || other.isEnabled == isEnabled)&&(identical(other.remindIntervalMinutes, remindIntervalMinutes) || other.remindIntervalMinutes == remindIntervalMinutes)&&(identical(other.dailyEventCap, dailyEventCap) || other.dailyEventCap == dailyEventCap));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,topic,isEnabled,remindIntervalMinutes,dailyEventCap);

@override
String toString() {
  return 'WellnessPref(topic: $topic, isEnabled: $isEnabled, remindIntervalMinutes: $remindIntervalMinutes, dailyEventCap: $dailyEventCap)';
}


}

/// @nodoc
abstract mixin class _$WellnessPrefCopyWith<$Res> implements $WellnessPrefCopyWith<$Res> {
  factory _$WellnessPrefCopyWith(_WellnessPref value, $Res Function(_WellnessPref) _then) = __$WellnessPrefCopyWithImpl;
@override @useResult
$Res call({
 String topic, bool isEnabled, int remindIntervalMinutes, int dailyEventCap
});




}
/// @nodoc
class __$WellnessPrefCopyWithImpl<$Res>
    implements _$WellnessPrefCopyWith<$Res> {
  __$WellnessPrefCopyWithImpl(this._self, this._then);

  final _WellnessPref _self;
  final $Res Function(_WellnessPref) _then;

/// Create a copy of WellnessPref
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? topic = null,Object? isEnabled = null,Object? remindIntervalMinutes = null,Object? dailyEventCap = null,}) {
  return _then(_WellnessPref(
topic: null == topic ? _self.topic : topic // ignore: cast_nullable_to_non_nullable
as String,isEnabled: null == isEnabled ? _self.isEnabled : isEnabled // ignore: cast_nullable_to_non_nullable
as bool,remindIntervalMinutes: null == remindIntervalMinutes ? _self.remindIntervalMinutes : remindIntervalMinutes // ignore: cast_nullable_to_non_nullable
as int,dailyEventCap: null == dailyEventCap ? _self.dailyEventCap : dailyEventCap // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
