// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'prep_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PrepItem {

 String get id; String get label; PrepKind get kind; int get extraMin;// routine만 0보다 큰 값 허용 (ERD ck_prep_minutes)
 bool get sensitive;// 복용약 등. 잠금화면 lockAlias로 치환
 bool get fromChip;// 추천 칩 선택 vs 직접 입력
 bool get active;
/// Create a copy of PrepItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PrepItemCopyWith<PrepItem> get copyWith => _$PrepItemCopyWithImpl<PrepItem>(this as PrepItem, _$identity);

  /// Serializes this PrepItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PrepItem&&(identical(other.id, id) || other.id == id)&&(identical(other.label, label) || other.label == label)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.extraMin, extraMin) || other.extraMin == extraMin)&&(identical(other.sensitive, sensitive) || other.sensitive == sensitive)&&(identical(other.fromChip, fromChip) || other.fromChip == fromChip)&&(identical(other.active, active) || other.active == active));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,label,kind,extraMin,sensitive,fromChip,active);

@override
String toString() {
  return 'PrepItem(id: $id, label: $label, kind: $kind, extraMin: $extraMin, sensitive: $sensitive, fromChip: $fromChip, active: $active)';
}


}

/// @nodoc
abstract mixin class $PrepItemCopyWith<$Res>  {
  factory $PrepItemCopyWith(PrepItem value, $Res Function(PrepItem) _then) = _$PrepItemCopyWithImpl;
@useResult
$Res call({
 String id, String label, PrepKind kind, int extraMin, bool sensitive, bool fromChip, bool active
});




}
/// @nodoc
class _$PrepItemCopyWithImpl<$Res>
    implements $PrepItemCopyWith<$Res> {
  _$PrepItemCopyWithImpl(this._self, this._then);

  final PrepItem _self;
  final $Res Function(PrepItem) _then;

/// Create a copy of PrepItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? label = null,Object? kind = null,Object? extraMin = null,Object? sensitive = null,Object? fromChip = null,Object? active = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as PrepKind,extraMin: null == extraMin ? _self.extraMin : extraMin // ignore: cast_nullable_to_non_nullable
as int,sensitive: null == sensitive ? _self.sensitive : sensitive // ignore: cast_nullable_to_non_nullable
as bool,fromChip: null == fromChip ? _self.fromChip : fromChip // ignore: cast_nullable_to_non_nullable
as bool,active: null == active ? _self.active : active // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [PrepItem].
extension PrepItemPatterns on PrepItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PrepItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PrepItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PrepItem value)  $default,){
final _that = this;
switch (_that) {
case _PrepItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PrepItem value)?  $default,){
final _that = this;
switch (_that) {
case _PrepItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String label,  PrepKind kind,  int extraMin,  bool sensitive,  bool fromChip,  bool active)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PrepItem() when $default != null:
return $default(_that.id,_that.label,_that.kind,_that.extraMin,_that.sensitive,_that.fromChip,_that.active);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String label,  PrepKind kind,  int extraMin,  bool sensitive,  bool fromChip,  bool active)  $default,) {final _that = this;
switch (_that) {
case _PrepItem():
return $default(_that.id,_that.label,_that.kind,_that.extraMin,_that.sensitive,_that.fromChip,_that.active);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String label,  PrepKind kind,  int extraMin,  bool sensitive,  bool fromChip,  bool active)?  $default,) {final _that = this;
switch (_that) {
case _PrepItem() when $default != null:
return $default(_that.id,_that.label,_that.kind,_that.extraMin,_that.sensitive,_that.fromChip,_that.active);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PrepItem extends PrepItem {
  const _PrepItem({required this.id, required this.label, required this.kind, this.extraMin = 0, this.sensitive = false, this.fromChip = false, this.active = true}): super._();
  factory _PrepItem.fromJson(Map<String, dynamic> json) => PrepItem.fromJson(json) as _PrepItem;

@override final  String id;
@override final  String label;
@override final  PrepKind kind;
@override@JsonKey() final  int extraMin;
// routine만 0보다 큰 값 허용 (ERD ck_prep_minutes)
@override@JsonKey() final  bool sensitive;
// 복용약 등. 잠금화면 lockAlias로 치환
@override@JsonKey() final  bool fromChip;
// 추천 칩 선택 vs 직접 입력
@override@JsonKey() final  bool active;

/// Create a copy of PrepItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PrepItemCopyWith<_PrepItem> get copyWith => __$PrepItemCopyWithImpl<_PrepItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PrepItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PrepItem&&(identical(other.id, id) || other.id == id)&&(identical(other.label, label) || other.label == label)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.extraMin, extraMin) || other.extraMin == extraMin)&&(identical(other.sensitive, sensitive) || other.sensitive == sensitive)&&(identical(other.fromChip, fromChip) || other.fromChip == fromChip)&&(identical(other.active, active) || other.active == active));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,label,kind,extraMin,sensitive,fromChip,active);

@override
String toString() {
  return 'PrepItem(id: $id, label: $label, kind: $kind, extraMin: $extraMin, sensitive: $sensitive, fromChip: $fromChip, active: $active)';
}


}

/// @nodoc
abstract mixin class _$PrepItemCopyWith<$Res> implements $PrepItemCopyWith<$Res> {
  factory _$PrepItemCopyWith(_PrepItem value, $Res Function(_PrepItem) _then) = __$PrepItemCopyWithImpl;
@override @useResult
$Res call({
 String id, String label, PrepKind kind, int extraMin, bool sensitive, bool fromChip, bool active
});




}
/// @nodoc
class __$PrepItemCopyWithImpl<$Res>
    implements _$PrepItemCopyWith<$Res> {
  __$PrepItemCopyWithImpl(this._self, this._then);

  final _PrepItem _self;
  final $Res Function(_PrepItem) _then;

/// Create a copy of PrepItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? label = null,Object? kind = null,Object? extraMin = null,Object? sensitive = null,Object? fromChip = null,Object? active = null,}) {
  return _then(_PrepItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as PrepKind,extraMin: null == extraMin ? _self.extraMin : extraMin // ignore: cast_nullable_to_non_nullable
as int,sensitive: null == sensitive ? _self.sensitive : sensitive // ignore: cast_nullable_to_non_nullable
as bool,fromChip: null == fromChip ? _self.fromChip : fromChip // ignore: cast_nullable_to_non_nullable
as bool,active: null == active ? _self.active : active // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
