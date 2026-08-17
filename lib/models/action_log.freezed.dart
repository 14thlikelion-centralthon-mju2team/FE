// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'action_log.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ActionLogEntry {

 String get clientEventId; ActionType get type; DateTime get deviceTs; ActionSource get source; double? get confidence;
/// Create a copy of ActionLogEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ActionLogEntryCopyWith<ActionLogEntry> get copyWith => _$ActionLogEntryCopyWithImpl<ActionLogEntry>(this as ActionLogEntry, _$identity);

  /// Serializes this ActionLogEntry to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ActionLogEntry&&(identical(other.clientEventId, clientEventId) || other.clientEventId == clientEventId)&&(identical(other.type, type) || other.type == type)&&(identical(other.deviceTs, deviceTs) || other.deviceTs == deviceTs)&&(identical(other.source, source) || other.source == source)&&(identical(other.confidence, confidence) || other.confidence == confidence));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,clientEventId,type,deviceTs,source,confidence);

@override
String toString() {
  return 'ActionLogEntry(clientEventId: $clientEventId, type: $type, deviceTs: $deviceTs, source: $source, confidence: $confidence)';
}


}

/// @nodoc
abstract mixin class $ActionLogEntryCopyWith<$Res>  {
  factory $ActionLogEntryCopyWith(ActionLogEntry value, $Res Function(ActionLogEntry) _then) = _$ActionLogEntryCopyWithImpl;
@useResult
$Res call({
 String clientEventId, ActionType type, DateTime deviceTs, ActionSource source, double? confidence
});




}
/// @nodoc
class _$ActionLogEntryCopyWithImpl<$Res>
    implements $ActionLogEntryCopyWith<$Res> {
  _$ActionLogEntryCopyWithImpl(this._self, this._then);

  final ActionLogEntry _self;
  final $Res Function(ActionLogEntry) _then;

/// Create a copy of ActionLogEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? clientEventId = null,Object? type = null,Object? deviceTs = null,Object? source = null,Object? confidence = freezed,}) {
  return _then(_self.copyWith(
clientEventId: null == clientEventId ? _self.clientEventId : clientEventId // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as ActionType,deviceTs: null == deviceTs ? _self.deviceTs : deviceTs // ignore: cast_nullable_to_non_nullable
as DateTime,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as ActionSource,confidence: freezed == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [ActionLogEntry].
extension ActionLogEntryPatterns on ActionLogEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ActionLogEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ActionLogEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ActionLogEntry value)  $default,){
final _that = this;
switch (_that) {
case _ActionLogEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ActionLogEntry value)?  $default,){
final _that = this;
switch (_that) {
case _ActionLogEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String clientEventId,  ActionType type,  DateTime deviceTs,  ActionSource source,  double? confidence)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ActionLogEntry() when $default != null:
return $default(_that.clientEventId,_that.type,_that.deviceTs,_that.source,_that.confidence);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String clientEventId,  ActionType type,  DateTime deviceTs,  ActionSource source,  double? confidence)  $default,) {final _that = this;
switch (_that) {
case _ActionLogEntry():
return $default(_that.clientEventId,_that.type,_that.deviceTs,_that.source,_that.confidence);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String clientEventId,  ActionType type,  DateTime deviceTs,  ActionSource source,  double? confidence)?  $default,) {final _that = this;
switch (_that) {
case _ActionLogEntry() when $default != null:
return $default(_that.clientEventId,_that.type,_that.deviceTs,_that.source,_that.confidence);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ActionLogEntry implements ActionLogEntry {
  const _ActionLogEntry({required this.clientEventId, required this.type, required this.deviceTs, required this.source, this.confidence});
  factory _ActionLogEntry.fromJson(Map<String, dynamic> json) => _$ActionLogEntryFromJson(json);

@override final  String clientEventId;
@override final  ActionType type;
@override final  DateTime deviceTs;
@override final  ActionSource source;
@override final  double? confidence;

/// Create a copy of ActionLogEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ActionLogEntryCopyWith<_ActionLogEntry> get copyWith => __$ActionLogEntryCopyWithImpl<_ActionLogEntry>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ActionLogEntryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ActionLogEntry&&(identical(other.clientEventId, clientEventId) || other.clientEventId == clientEventId)&&(identical(other.type, type) || other.type == type)&&(identical(other.deviceTs, deviceTs) || other.deviceTs == deviceTs)&&(identical(other.source, source) || other.source == source)&&(identical(other.confidence, confidence) || other.confidence == confidence));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,clientEventId,type,deviceTs,source,confidence);

@override
String toString() {
  return 'ActionLogEntry(clientEventId: $clientEventId, type: $type, deviceTs: $deviceTs, source: $source, confidence: $confidence)';
}


}

/// @nodoc
abstract mixin class _$ActionLogEntryCopyWith<$Res> implements $ActionLogEntryCopyWith<$Res> {
  factory _$ActionLogEntryCopyWith(_ActionLogEntry value, $Res Function(_ActionLogEntry) _then) = __$ActionLogEntryCopyWithImpl;
@override @useResult
$Res call({
 String clientEventId, ActionType type, DateTime deviceTs, ActionSource source, double? confidence
});




}
/// @nodoc
class __$ActionLogEntryCopyWithImpl<$Res>
    implements _$ActionLogEntryCopyWith<$Res> {
  __$ActionLogEntryCopyWithImpl(this._self, this._then);

  final _ActionLogEntry _self;
  final $Res Function(_ActionLogEntry) _then;

/// Create a copy of ActionLogEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? clientEventId = null,Object? type = null,Object? deviceTs = null,Object? source = null,Object? confidence = freezed,}) {
  return _then(_ActionLogEntry(
clientEventId: null == clientEventId ? _self.clientEventId : clientEventId // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as ActionType,deviceTs: null == deviceTs ? _self.deviceTs : deviceTs // ignore: cast_nullable_to_non_nullable
as DateTime,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as ActionSource,confidence: freezed == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}


/// @nodoc
mixin _$ActionLogResponse {

 bool get accepted; bool get duplicated;// true면 재전송이 흡수된 것 — 오류 아님
 Map<String, dynamic> get plan;
/// Create a copy of ActionLogResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ActionLogResponseCopyWith<ActionLogResponse> get copyWith => _$ActionLogResponseCopyWithImpl<ActionLogResponse>(this as ActionLogResponse, _$identity);

  /// Serializes this ActionLogResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ActionLogResponse&&(identical(other.accepted, accepted) || other.accepted == accepted)&&(identical(other.duplicated, duplicated) || other.duplicated == duplicated)&&const DeepCollectionEquality().equals(other.plan, plan));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,accepted,duplicated,const DeepCollectionEquality().hash(plan));

@override
String toString() {
  return 'ActionLogResponse(accepted: $accepted, duplicated: $duplicated, plan: $plan)';
}


}

/// @nodoc
abstract mixin class $ActionLogResponseCopyWith<$Res>  {
  factory $ActionLogResponseCopyWith(ActionLogResponse value, $Res Function(ActionLogResponse) _then) = _$ActionLogResponseCopyWithImpl;
@useResult
$Res call({
 bool accepted, bool duplicated, Map<String, dynamic> plan
});




}
/// @nodoc
class _$ActionLogResponseCopyWithImpl<$Res>
    implements $ActionLogResponseCopyWith<$Res> {
  _$ActionLogResponseCopyWithImpl(this._self, this._then);

  final ActionLogResponse _self;
  final $Res Function(ActionLogResponse) _then;

/// Create a copy of ActionLogResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? accepted = null,Object? duplicated = null,Object? plan = null,}) {
  return _then(_self.copyWith(
accepted: null == accepted ? _self.accepted : accepted // ignore: cast_nullable_to_non_nullable
as bool,duplicated: null == duplicated ? _self.duplicated : duplicated // ignore: cast_nullable_to_non_nullable
as bool,plan: null == plan ? _self.plan : plan // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,
  ));
}

}


/// Adds pattern-matching-related methods to [ActionLogResponse].
extension ActionLogResponsePatterns on ActionLogResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ActionLogResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ActionLogResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ActionLogResponse value)  $default,){
final _that = this;
switch (_that) {
case _ActionLogResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ActionLogResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ActionLogResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool accepted,  bool duplicated,  Map<String, dynamic> plan)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ActionLogResponse() when $default != null:
return $default(_that.accepted,_that.duplicated,_that.plan);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool accepted,  bool duplicated,  Map<String, dynamic> plan)  $default,) {final _that = this;
switch (_that) {
case _ActionLogResponse():
return $default(_that.accepted,_that.duplicated,_that.plan);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool accepted,  bool duplicated,  Map<String, dynamic> plan)?  $default,) {final _that = this;
switch (_that) {
case _ActionLogResponse() when $default != null:
return $default(_that.accepted,_that.duplicated,_that.plan);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ActionLogResponse implements ActionLogResponse {
  const _ActionLogResponse({required this.accepted, required this.duplicated, required final  Map<String, dynamic> plan}): _plan = plan;
  factory _ActionLogResponse.fromJson(Map<String, dynamic> json) => _$ActionLogResponseFromJson(json);

@override final  bool accepted;
@override final  bool duplicated;
// true면 재전송이 흡수된 것 — 오류 아님
 final  Map<String, dynamic> _plan;
// true면 재전송이 흡수된 것 — 오류 아님
@override Map<String, dynamic> get plan {
  if (_plan is EqualUnmodifiableMapView) return _plan;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_plan);
}


/// Create a copy of ActionLogResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ActionLogResponseCopyWith<_ActionLogResponse> get copyWith => __$ActionLogResponseCopyWithImpl<_ActionLogResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ActionLogResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ActionLogResponse&&(identical(other.accepted, accepted) || other.accepted == accepted)&&(identical(other.duplicated, duplicated) || other.duplicated == duplicated)&&const DeepCollectionEquality().equals(other._plan, _plan));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,accepted,duplicated,const DeepCollectionEquality().hash(_plan));

@override
String toString() {
  return 'ActionLogResponse(accepted: $accepted, duplicated: $duplicated, plan: $plan)';
}


}

/// @nodoc
abstract mixin class _$ActionLogResponseCopyWith<$Res> implements $ActionLogResponseCopyWith<$Res> {
  factory _$ActionLogResponseCopyWith(_ActionLogResponse value, $Res Function(_ActionLogResponse) _then) = __$ActionLogResponseCopyWithImpl;
@override @useResult
$Res call({
 bool accepted, bool duplicated, Map<String, dynamic> plan
});




}
/// @nodoc
class __$ActionLogResponseCopyWithImpl<$Res>
    implements _$ActionLogResponseCopyWith<$Res> {
  __$ActionLogResponseCopyWithImpl(this._self, this._then);

  final _ActionLogResponse _self;
  final $Res Function(_ActionLogResponse) _then;

/// Create a copy of ActionLogResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? accepted = null,Object? duplicated = null,Object? plan = null,}) {
  return _then(_ActionLogResponse(
accepted: null == accepted ? _self.accepted : accepted // ignore: cast_nullable_to_non_nullable
as bool,duplicated: null == duplicated ? _self.duplicated : duplicated // ignore: cast_nullable_to_non_nullable
as bool,plan: null == plan ? _self._plan : plan // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,
  ));
}


}

// dart format on
