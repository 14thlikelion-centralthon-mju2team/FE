// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserEvent {

 String? get title;// 저장 여부 미결(Q-004) — 화면엔 일단 노출하되 서버 정책 확정 전까지 주의
 DateTime get startsAt; DateTime get endsAt; String? get placeText;
/// Create a copy of UserEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserEventCopyWith<UserEvent> get copyWith => _$UserEventCopyWithImpl<UserEvent>(this as UserEvent, _$identity);

  /// Serializes this UserEvent to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserEvent&&(identical(other.title, title) || other.title == title)&&(identical(other.startsAt, startsAt) || other.startsAt == startsAt)&&(identical(other.endsAt, endsAt) || other.endsAt == endsAt)&&(identical(other.placeText, placeText) || other.placeText == placeText));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,startsAt,endsAt,placeText);

@override
String toString() {
  return 'UserEvent(title: $title, startsAt: $startsAt, endsAt: $endsAt, placeText: $placeText)';
}


}

/// @nodoc
abstract mixin class $UserEventCopyWith<$Res>  {
  factory $UserEventCopyWith(UserEvent value, $Res Function(UserEvent) _then) = _$UserEventCopyWithImpl;
@useResult
$Res call({
 String? title, DateTime startsAt, DateTime endsAt, String? placeText
});




}
/// @nodoc
class _$UserEventCopyWithImpl<$Res>
    implements $UserEventCopyWith<$Res> {
  _$UserEventCopyWithImpl(this._self, this._then);

  final UserEvent _self;
  final $Res Function(UserEvent) _then;

/// Create a copy of UserEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = freezed,Object? startsAt = null,Object? endsAt = null,Object? placeText = freezed,}) {
  return _then(_self.copyWith(
title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,startsAt: null == startsAt ? _self.startsAt : startsAt // ignore: cast_nullable_to_non_nullable
as DateTime,endsAt: null == endsAt ? _self.endsAt : endsAt // ignore: cast_nullable_to_non_nullable
as DateTime,placeText: freezed == placeText ? _self.placeText : placeText // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [UserEvent].
extension UserEventPatterns on UserEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserEvent value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserEvent() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserEvent value)  $default,){
final _that = this;
switch (_that) {
case _UserEvent():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserEvent value)?  $default,){
final _that = this;
switch (_that) {
case _UserEvent() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? title,  DateTime startsAt,  DateTime endsAt,  String? placeText)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserEvent() when $default != null:
return $default(_that.title,_that.startsAt,_that.endsAt,_that.placeText);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? title,  DateTime startsAt,  DateTime endsAt,  String? placeText)  $default,) {final _that = this;
switch (_that) {
case _UserEvent():
return $default(_that.title,_that.startsAt,_that.endsAt,_that.placeText);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? title,  DateTime startsAt,  DateTime endsAt,  String? placeText)?  $default,) {final _that = this;
switch (_that) {
case _UserEvent() when $default != null:
return $default(_that.title,_that.startsAt,_that.endsAt,_that.placeText);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserEvent implements UserEvent {
  const _UserEvent({this.title, required this.startsAt, required this.endsAt, this.placeText});
  factory _UserEvent.fromJson(Map<String, dynamic> json) => _$UserEventFromJson(json);

@override final  String? title;
// 저장 여부 미결(Q-004) — 화면엔 일단 노출하되 서버 정책 확정 전까지 주의
@override final  DateTime startsAt;
@override final  DateTime endsAt;
@override final  String? placeText;

/// Create a copy of UserEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserEventCopyWith<_UserEvent> get copyWith => __$UserEventCopyWithImpl<_UserEvent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserEventToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserEvent&&(identical(other.title, title) || other.title == title)&&(identical(other.startsAt, startsAt) || other.startsAt == startsAt)&&(identical(other.endsAt, endsAt) || other.endsAt == endsAt)&&(identical(other.placeText, placeText) || other.placeText == placeText));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,startsAt,endsAt,placeText);

@override
String toString() {
  return 'UserEvent(title: $title, startsAt: $startsAt, endsAt: $endsAt, placeText: $placeText)';
}


}

/// @nodoc
abstract mixin class _$UserEventCopyWith<$Res> implements $UserEventCopyWith<$Res> {
  factory _$UserEventCopyWith(_UserEvent value, $Res Function(_UserEvent) _then) = __$UserEventCopyWithImpl;
@override @useResult
$Res call({
 String? title, DateTime startsAt, DateTime endsAt, String? placeText
});




}
/// @nodoc
class __$UserEventCopyWithImpl<$Res>
    implements _$UserEventCopyWith<$Res> {
  __$UserEventCopyWithImpl(this._self, this._then);

  final _UserEvent _self;
  final $Res Function(_UserEvent) _then;

/// Create a copy of UserEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = freezed,Object? startsAt = null,Object? endsAt = null,Object? placeText = freezed,}) {
  return _then(_UserEvent(
title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,startsAt: null == startsAt ? _self.startsAt : startsAt // ignore: cast_nullable_to_non_nullable
as DateTime,endsAt: null == endsAt ? _self.endsAt : endsAt // ignore: cast_nullable_to_non_nullable
as DateTime,placeText: freezed == placeText ? _self.placeText : placeText // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
