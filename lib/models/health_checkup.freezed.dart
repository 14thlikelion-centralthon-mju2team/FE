// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'health_checkup.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HealthCheckup {

 DateTime get measuredOn; Map<String, dynamic> get data;
/// Create a copy of HealthCheckup
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HealthCheckupCopyWith<HealthCheckup> get copyWith => _$HealthCheckupCopyWithImpl<HealthCheckup>(this as HealthCheckup, _$identity);

  /// Serializes this HealthCheckup to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HealthCheckup&&(identical(other.measuredOn, measuredOn) || other.measuredOn == measuredOn)&&const DeepCollectionEquality().equals(other.data, data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,measuredOn,const DeepCollectionEquality().hash(data));

@override
String toString() {
  return 'HealthCheckup(measuredOn: $measuredOn, data: $data)';
}


}

/// @nodoc
abstract mixin class $HealthCheckupCopyWith<$Res>  {
  factory $HealthCheckupCopyWith(HealthCheckup value, $Res Function(HealthCheckup) _then) = _$HealthCheckupCopyWithImpl;
@useResult
$Res call({
 DateTime measuredOn, Map<String, dynamic> data
});




}
/// @nodoc
class _$HealthCheckupCopyWithImpl<$Res>
    implements $HealthCheckupCopyWith<$Res> {
  _$HealthCheckupCopyWithImpl(this._self, this._then);

  final HealthCheckup _self;
  final $Res Function(HealthCheckup) _then;

/// Create a copy of HealthCheckup
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? measuredOn = null,Object? data = null,}) {
  return _then(_self.copyWith(
measuredOn: null == measuredOn ? _self.measuredOn : measuredOn // ignore: cast_nullable_to_non_nullable
as DateTime,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,
  ));
}

}


/// Adds pattern-matching-related methods to [HealthCheckup].
extension HealthCheckupPatterns on HealthCheckup {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HealthCheckup value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HealthCheckup() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HealthCheckup value)  $default,){
final _that = this;
switch (_that) {
case _HealthCheckup():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HealthCheckup value)?  $default,){
final _that = this;
switch (_that) {
case _HealthCheckup() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime measuredOn,  Map<String, dynamic> data)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HealthCheckup() when $default != null:
return $default(_that.measuredOn,_that.data);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime measuredOn,  Map<String, dynamic> data)  $default,) {final _that = this;
switch (_that) {
case _HealthCheckup():
return $default(_that.measuredOn,_that.data);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime measuredOn,  Map<String, dynamic> data)?  $default,) {final _that = this;
switch (_that) {
case _HealthCheckup() when $default != null:
return $default(_that.measuredOn,_that.data);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HealthCheckup implements HealthCheckup {
  const _HealthCheckup({required this.measuredOn, required final  Map<String, dynamic> data}): _data = data;
  factory _HealthCheckup.fromJson(Map<String, dynamic> json) => _$HealthCheckupFromJson(json);

@override final  DateTime measuredOn;
 final  Map<String, dynamic> _data;
@override Map<String, dynamic> get data {
  if (_data is EqualUnmodifiableMapView) return _data;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_data);
}


/// Create a copy of HealthCheckup
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HealthCheckupCopyWith<_HealthCheckup> get copyWith => __$HealthCheckupCopyWithImpl<_HealthCheckup>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HealthCheckupToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HealthCheckup&&(identical(other.measuredOn, measuredOn) || other.measuredOn == measuredOn)&&const DeepCollectionEquality().equals(other._data, _data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,measuredOn,const DeepCollectionEquality().hash(_data));

@override
String toString() {
  return 'HealthCheckup(measuredOn: $measuredOn, data: $data)';
}


}

/// @nodoc
abstract mixin class _$HealthCheckupCopyWith<$Res> implements $HealthCheckupCopyWith<$Res> {
  factory _$HealthCheckupCopyWith(_HealthCheckup value, $Res Function(_HealthCheckup) _then) = __$HealthCheckupCopyWithImpl;
@override @useResult
$Res call({
 DateTime measuredOn, Map<String, dynamic> data
});




}
/// @nodoc
class __$HealthCheckupCopyWithImpl<$Res>
    implements _$HealthCheckupCopyWith<$Res> {
  __$HealthCheckupCopyWithImpl(this._self, this._then);

  final _HealthCheckup _self;
  final $Res Function(_HealthCheckup) _then;

/// Create a copy of HealthCheckup
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? measuredOn = null,Object? data = null,}) {
  return _then(_HealthCheckup(
measuredOn: null == measuredOn ? _self.measuredOn : measuredOn // ignore: cast_nullable_to_non_nullable
as DateTime,data: null == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,
  ));
}


}

// dart format on
