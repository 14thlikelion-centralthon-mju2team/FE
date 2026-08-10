// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'action_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ActionItem {

 String get id; String get category;// sleep|hydration|move|focus|meal
 String get ladderKey; int get difficulty;// 1~5
 int get estMinutes; String get title; String? get description;
/// Create a copy of ActionItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ActionItemCopyWith<ActionItem> get copyWith => _$ActionItemCopyWithImpl<ActionItem>(this as ActionItem, _$identity);

  /// Serializes this ActionItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ActionItem&&(identical(other.id, id) || other.id == id)&&(identical(other.category, category) || other.category == category)&&(identical(other.ladderKey, ladderKey) || other.ladderKey == ladderKey)&&(identical(other.difficulty, difficulty) || other.difficulty == difficulty)&&(identical(other.estMinutes, estMinutes) || other.estMinutes == estMinutes)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,category,ladderKey,difficulty,estMinutes,title,description);

@override
String toString() {
  return 'ActionItem(id: $id, category: $category, ladderKey: $ladderKey, difficulty: $difficulty, estMinutes: $estMinutes, title: $title, description: $description)';
}


}

/// @nodoc
abstract mixin class $ActionItemCopyWith<$Res>  {
  factory $ActionItemCopyWith(ActionItem value, $Res Function(ActionItem) _then) = _$ActionItemCopyWithImpl;
@useResult
$Res call({
 String id, String category, String ladderKey, int difficulty, int estMinutes, String title, String? description
});




}
/// @nodoc
class _$ActionItemCopyWithImpl<$Res>
    implements $ActionItemCopyWith<$Res> {
  _$ActionItemCopyWithImpl(this._self, this._then);

  final ActionItem _self;
  final $Res Function(ActionItem) _then;

/// Create a copy of ActionItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? category = null,Object? ladderKey = null,Object? difficulty = null,Object? estMinutes = null,Object? title = null,Object? description = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,ladderKey: null == ladderKey ? _self.ladderKey : ladderKey // ignore: cast_nullable_to_non_nullable
as String,difficulty: null == difficulty ? _self.difficulty : difficulty // ignore: cast_nullable_to_non_nullable
as int,estMinutes: null == estMinutes ? _self.estMinutes : estMinutes // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ActionItem].
extension ActionItemPatterns on ActionItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ActionItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ActionItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ActionItem value)  $default,){
final _that = this;
switch (_that) {
case _ActionItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ActionItem value)?  $default,){
final _that = this;
switch (_that) {
case _ActionItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String category,  String ladderKey,  int difficulty,  int estMinutes,  String title,  String? description)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ActionItem() when $default != null:
return $default(_that.id,_that.category,_that.ladderKey,_that.difficulty,_that.estMinutes,_that.title,_that.description);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String category,  String ladderKey,  int difficulty,  int estMinutes,  String title,  String? description)  $default,) {final _that = this;
switch (_that) {
case _ActionItem():
return $default(_that.id,_that.category,_that.ladderKey,_that.difficulty,_that.estMinutes,_that.title,_that.description);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String category,  String ladderKey,  int difficulty,  int estMinutes,  String title,  String? description)?  $default,) {final _that = this;
switch (_that) {
case _ActionItem() when $default != null:
return $default(_that.id,_that.category,_that.ladderKey,_that.difficulty,_that.estMinutes,_that.title,_that.description);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ActionItem implements ActionItem {
  const _ActionItem({required this.id, required this.category, required this.ladderKey, required this.difficulty, required this.estMinutes, required this.title, this.description});
  factory _ActionItem.fromJson(Map<String, dynamic> json) => _$ActionItemFromJson(json);

@override final  String id;
@override final  String category;
// sleep|hydration|move|focus|meal
@override final  String ladderKey;
@override final  int difficulty;
// 1~5
@override final  int estMinutes;
@override final  String title;
@override final  String? description;

/// Create a copy of ActionItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ActionItemCopyWith<_ActionItem> get copyWith => __$ActionItemCopyWithImpl<_ActionItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ActionItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ActionItem&&(identical(other.id, id) || other.id == id)&&(identical(other.category, category) || other.category == category)&&(identical(other.ladderKey, ladderKey) || other.ladderKey == ladderKey)&&(identical(other.difficulty, difficulty) || other.difficulty == difficulty)&&(identical(other.estMinutes, estMinutes) || other.estMinutes == estMinutes)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,category,ladderKey,difficulty,estMinutes,title,description);

@override
String toString() {
  return 'ActionItem(id: $id, category: $category, ladderKey: $ladderKey, difficulty: $difficulty, estMinutes: $estMinutes, title: $title, description: $description)';
}


}

/// @nodoc
abstract mixin class _$ActionItemCopyWith<$Res> implements $ActionItemCopyWith<$Res> {
  factory _$ActionItemCopyWith(_ActionItem value, $Res Function(_ActionItem) _then) = __$ActionItemCopyWithImpl;
@override @useResult
$Res call({
 String id, String category, String ladderKey, int difficulty, int estMinutes, String title, String? description
});




}
/// @nodoc
class __$ActionItemCopyWithImpl<$Res>
    implements _$ActionItemCopyWith<$Res> {
  __$ActionItemCopyWithImpl(this._self, this._then);

  final _ActionItem _self;
  final $Res Function(_ActionItem) _then;

/// Create a copy of ActionItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? category = null,Object? ladderKey = null,Object? difficulty = null,Object? estMinutes = null,Object? title = null,Object? description = freezed,}) {
  return _then(_ActionItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,ladderKey: null == ladderKey ? _self.ladderKey : ladderKey // ignore: cast_nullable_to_non_nullable
as String,difficulty: null == difficulty ? _self.difficulty : difficulty // ignore: cast_nullable_to_non_nullable
as int,estMinutes: null == estMinutes ? _self.estMinutes : estMinutes // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
