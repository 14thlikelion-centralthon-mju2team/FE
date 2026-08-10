// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'age_verification.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AgeVerificationRequest {

 DateTime get birthDate;
/// Create a copy of AgeVerificationRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AgeVerificationRequestCopyWith<AgeVerificationRequest> get copyWith => _$AgeVerificationRequestCopyWithImpl<AgeVerificationRequest>(this as AgeVerificationRequest, _$identity);

  /// Serializes this AgeVerificationRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AgeVerificationRequest&&(identical(other.birthDate, birthDate) || other.birthDate == birthDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,birthDate);

@override
String toString() {
  return 'AgeVerificationRequest(birthDate: $birthDate)';
}


}

/// @nodoc
abstract mixin class $AgeVerificationRequestCopyWith<$Res>  {
  factory $AgeVerificationRequestCopyWith(AgeVerificationRequest value, $Res Function(AgeVerificationRequest) _then) = _$AgeVerificationRequestCopyWithImpl;
@useResult
$Res call({
 DateTime birthDate
});




}
/// @nodoc
class _$AgeVerificationRequestCopyWithImpl<$Res>
    implements $AgeVerificationRequestCopyWith<$Res> {
  _$AgeVerificationRequestCopyWithImpl(this._self, this._then);

  final AgeVerificationRequest _self;
  final $Res Function(AgeVerificationRequest) _then;

/// Create a copy of AgeVerificationRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? birthDate = null,}) {
  return _then(_self.copyWith(
birthDate: null == birthDate ? _self.birthDate : birthDate // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [AgeVerificationRequest].
extension AgeVerificationRequestPatterns on AgeVerificationRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AgeVerificationRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AgeVerificationRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AgeVerificationRequest value)  $default,){
final _that = this;
switch (_that) {
case _AgeVerificationRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AgeVerificationRequest value)?  $default,){
final _that = this;
switch (_that) {
case _AgeVerificationRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime birthDate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AgeVerificationRequest() when $default != null:
return $default(_that.birthDate);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime birthDate)  $default,) {final _that = this;
switch (_that) {
case _AgeVerificationRequest():
return $default(_that.birthDate);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime birthDate)?  $default,) {final _that = this;
switch (_that) {
case _AgeVerificationRequest() when $default != null:
return $default(_that.birthDate);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AgeVerificationRequest implements AgeVerificationRequest {
  const _AgeVerificationRequest({required this.birthDate});
  factory _AgeVerificationRequest.fromJson(Map<String, dynamic> json) => _$AgeVerificationRequestFromJson(json);

@override final  DateTime birthDate;

/// Create a copy of AgeVerificationRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AgeVerificationRequestCopyWith<_AgeVerificationRequest> get copyWith => __$AgeVerificationRequestCopyWithImpl<_AgeVerificationRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AgeVerificationRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AgeVerificationRequest&&(identical(other.birthDate, birthDate) || other.birthDate == birthDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,birthDate);

@override
String toString() {
  return 'AgeVerificationRequest(birthDate: $birthDate)';
}


}

/// @nodoc
abstract mixin class _$AgeVerificationRequestCopyWith<$Res> implements $AgeVerificationRequestCopyWith<$Res> {
  factory _$AgeVerificationRequestCopyWith(_AgeVerificationRequest value, $Res Function(_AgeVerificationRequest) _then) = __$AgeVerificationRequestCopyWithImpl;
@override @useResult
$Res call({
 DateTime birthDate
});




}
/// @nodoc
class __$AgeVerificationRequestCopyWithImpl<$Res>
    implements _$AgeVerificationRequestCopyWith<$Res> {
  __$AgeVerificationRequestCopyWithImpl(this._self, this._then);

  final _AgeVerificationRequest _self;
  final $Res Function(_AgeVerificationRequest) _then;

/// Create a copy of AgeVerificationRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? birthDate = null,}) {
  return _then(_AgeVerificationRequest(
birthDate: null == birthDate ? _self.birthDate : birthDate // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$AgeVerificationResult {

 bool get eligible;// 만 14세 이상이면 true
 DateTime? get ageConfirmedAt;
/// Create a copy of AgeVerificationResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AgeVerificationResultCopyWith<AgeVerificationResult> get copyWith => _$AgeVerificationResultCopyWithImpl<AgeVerificationResult>(this as AgeVerificationResult, _$identity);

  /// Serializes this AgeVerificationResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AgeVerificationResult&&(identical(other.eligible, eligible) || other.eligible == eligible)&&(identical(other.ageConfirmedAt, ageConfirmedAt) || other.ageConfirmedAt == ageConfirmedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,eligible,ageConfirmedAt);

@override
String toString() {
  return 'AgeVerificationResult(eligible: $eligible, ageConfirmedAt: $ageConfirmedAt)';
}


}

/// @nodoc
abstract mixin class $AgeVerificationResultCopyWith<$Res>  {
  factory $AgeVerificationResultCopyWith(AgeVerificationResult value, $Res Function(AgeVerificationResult) _then) = _$AgeVerificationResultCopyWithImpl;
@useResult
$Res call({
 bool eligible, DateTime? ageConfirmedAt
});




}
/// @nodoc
class _$AgeVerificationResultCopyWithImpl<$Res>
    implements $AgeVerificationResultCopyWith<$Res> {
  _$AgeVerificationResultCopyWithImpl(this._self, this._then);

  final AgeVerificationResult _self;
  final $Res Function(AgeVerificationResult) _then;

/// Create a copy of AgeVerificationResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? eligible = null,Object? ageConfirmedAt = freezed,}) {
  return _then(_self.copyWith(
eligible: null == eligible ? _self.eligible : eligible // ignore: cast_nullable_to_non_nullable
as bool,ageConfirmedAt: freezed == ageConfirmedAt ? _self.ageConfirmedAt : ageConfirmedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [AgeVerificationResult].
extension AgeVerificationResultPatterns on AgeVerificationResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AgeVerificationResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AgeVerificationResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AgeVerificationResult value)  $default,){
final _that = this;
switch (_that) {
case _AgeVerificationResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AgeVerificationResult value)?  $default,){
final _that = this;
switch (_that) {
case _AgeVerificationResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool eligible,  DateTime? ageConfirmedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AgeVerificationResult() when $default != null:
return $default(_that.eligible,_that.ageConfirmedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool eligible,  DateTime? ageConfirmedAt)  $default,) {final _that = this;
switch (_that) {
case _AgeVerificationResult():
return $default(_that.eligible,_that.ageConfirmedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool eligible,  DateTime? ageConfirmedAt)?  $default,) {final _that = this;
switch (_that) {
case _AgeVerificationResult() when $default != null:
return $default(_that.eligible,_that.ageConfirmedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AgeVerificationResult implements AgeVerificationResult {
  const _AgeVerificationResult({required this.eligible, this.ageConfirmedAt});
  factory _AgeVerificationResult.fromJson(Map<String, dynamic> json) => _$AgeVerificationResultFromJson(json);

@override final  bool eligible;
// 만 14세 이상이면 true
@override final  DateTime? ageConfirmedAt;

/// Create a copy of AgeVerificationResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AgeVerificationResultCopyWith<_AgeVerificationResult> get copyWith => __$AgeVerificationResultCopyWithImpl<_AgeVerificationResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AgeVerificationResultToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AgeVerificationResult&&(identical(other.eligible, eligible) || other.eligible == eligible)&&(identical(other.ageConfirmedAt, ageConfirmedAt) || other.ageConfirmedAt == ageConfirmedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,eligible,ageConfirmedAt);

@override
String toString() {
  return 'AgeVerificationResult(eligible: $eligible, ageConfirmedAt: $ageConfirmedAt)';
}


}

/// @nodoc
abstract mixin class _$AgeVerificationResultCopyWith<$Res> implements $AgeVerificationResultCopyWith<$Res> {
  factory _$AgeVerificationResultCopyWith(_AgeVerificationResult value, $Res Function(_AgeVerificationResult) _then) = __$AgeVerificationResultCopyWithImpl;
@override @useResult
$Res call({
 bool eligible, DateTime? ageConfirmedAt
});




}
/// @nodoc
class __$AgeVerificationResultCopyWithImpl<$Res>
    implements _$AgeVerificationResultCopyWith<$Res> {
  __$AgeVerificationResultCopyWithImpl(this._self, this._then);

  final _AgeVerificationResult _self;
  final $Res Function(_AgeVerificationResult) _then;

/// Create a copy of AgeVerificationResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? eligible = null,Object? ageConfirmedAt = freezed,}) {
  return _then(_AgeVerificationResult(
eligible: null == eligible ? _self.eligible : eligible // ignore: cast_nullable_to_non_nullable
as bool,ageConfirmedAt: freezed == ageConfirmedAt ? _self.ageConfirmedAt : ageConfirmedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
