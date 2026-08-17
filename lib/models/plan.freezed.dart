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
mixin _$TraceItem {

 String get label; int get minutes; String get source;// model | prepItem | provider | wellness 등
 bool get adjusted; String? get reason;
/// Create a copy of TraceItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TraceItemCopyWith<TraceItem> get copyWith => _$TraceItemCopyWithImpl<TraceItem>(this as TraceItem, _$identity);

  /// Serializes this TraceItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TraceItem&&(identical(other.label, label) || other.label == label)&&(identical(other.minutes, minutes) || other.minutes == minutes)&&(identical(other.source, source) || other.source == source)&&(identical(other.adjusted, adjusted) || other.adjusted == adjusted)&&(identical(other.reason, reason) || other.reason == reason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,label,minutes,source,adjusted,reason);

@override
String toString() {
  return 'TraceItem(label: $label, minutes: $minutes, source: $source, adjusted: $adjusted, reason: $reason)';
}


}

/// @nodoc
abstract mixin class $TraceItemCopyWith<$Res>  {
  factory $TraceItemCopyWith(TraceItem value, $Res Function(TraceItem) _then) = _$TraceItemCopyWithImpl;
@useResult
$Res call({
 String label, int minutes, String source, bool adjusted, String? reason
});




}
/// @nodoc
class _$TraceItemCopyWithImpl<$Res>
    implements $TraceItemCopyWith<$Res> {
  _$TraceItemCopyWithImpl(this._self, this._then);

  final TraceItem _self;
  final $Res Function(TraceItem) _then;

/// Create a copy of TraceItem
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


/// Adds pattern-matching-related methods to [TraceItem].
extension TraceItemPatterns on TraceItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TraceItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TraceItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TraceItem value)  $default,){
final _that = this;
switch (_that) {
case _TraceItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TraceItem value)?  $default,){
final _that = this;
switch (_that) {
case _TraceItem() when $default != null:
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
case _TraceItem() when $default != null:
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
case _TraceItem():
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
case _TraceItem() when $default != null:
return $default(_that.label,_that.minutes,_that.source,_that.adjusted,_that.reason);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TraceItem implements TraceItem {
  const _TraceItem({required this.label, required this.minutes, required this.source, required this.adjusted, this.reason});
  factory _TraceItem.fromJson(Map<String, dynamic> json) => _$TraceItemFromJson(json);

@override final  String label;
@override final  int minutes;
@override final  String source;
// model | prepItem | provider | wellness 등
@override final  bool adjusted;
@override final  String? reason;

/// Create a copy of TraceItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TraceItemCopyWith<_TraceItem> get copyWith => __$TraceItemCopyWithImpl<_TraceItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TraceItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TraceItem&&(identical(other.label, label) || other.label == label)&&(identical(other.minutes, minutes) || other.minutes == minutes)&&(identical(other.source, source) || other.source == source)&&(identical(other.adjusted, adjusted) || other.adjusted == adjusted)&&(identical(other.reason, reason) || other.reason == reason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,label,minutes,source,adjusted,reason);

@override
String toString() {
  return 'TraceItem(label: $label, minutes: $minutes, source: $source, adjusted: $adjusted, reason: $reason)';
}


}

/// @nodoc
abstract mixin class _$TraceItemCopyWith<$Res> implements $TraceItemCopyWith<$Res> {
  factory _$TraceItemCopyWith(_TraceItem value, $Res Function(_TraceItem) _then) = __$TraceItemCopyWithImpl;
@override @useResult
$Res call({
 String label, int minutes, String source, bool adjusted, String? reason
});




}
/// @nodoc
class __$TraceItemCopyWithImpl<$Res>
    implements _$TraceItemCopyWith<$Res> {
  __$TraceItemCopyWithImpl(this._self, this._then);

  final _TraceItem _self;
  final $Res Function(_TraceItem) _then;

/// Create a copy of TraceItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? label = null,Object? minutes = null,Object? source = null,Object? adjusted = null,Object? reason = freezed,}) {
  return _then(_TraceItem(
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
mixin _$ChecklistItem {

 String get label; ChecklistOrigin get origin; String get kind;// carry | consume | purchase | routine
 ChecklistState get state; String? get reason; bool get private;
/// Create a copy of ChecklistItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChecklistItemCopyWith<ChecklistItem> get copyWith => _$ChecklistItemCopyWithImpl<ChecklistItem>(this as ChecklistItem, _$identity);

  /// Serializes this ChecklistItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChecklistItem&&(identical(other.label, label) || other.label == label)&&(identical(other.origin, origin) || other.origin == origin)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.state, state) || other.state == state)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.private, private) || other.private == private));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,label,origin,kind,state,reason,private);

@override
String toString() {
  return 'ChecklistItem(label: $label, origin: $origin, kind: $kind, state: $state, reason: $reason, private: $private)';
}


}

/// @nodoc
abstract mixin class $ChecklistItemCopyWith<$Res>  {
  factory $ChecklistItemCopyWith(ChecklistItem value, $Res Function(ChecklistItem) _then) = _$ChecklistItemCopyWithImpl;
@useResult
$Res call({
 String label, ChecklistOrigin origin, String kind, ChecklistState state, String? reason, bool private
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
@pragma('vm:prefer-inline') @override $Res call({Object? label = null,Object? origin = null,Object? kind = null,Object? state = null,Object? reason = freezed,Object? private = null,}) {
  return _then(_self.copyWith(
label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,origin: null == origin ? _self.origin : origin // ignore: cast_nullable_to_non_nullable
as ChecklistOrigin,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String,state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as ChecklistState,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String label,  ChecklistOrigin origin,  String kind,  ChecklistState state,  String? reason,  bool private)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChecklistItem() when $default != null:
return $default(_that.label,_that.origin,_that.kind,_that.state,_that.reason,_that.private);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String label,  ChecklistOrigin origin,  String kind,  ChecklistState state,  String? reason,  bool private)  $default,) {final _that = this;
switch (_that) {
case _ChecklistItem():
return $default(_that.label,_that.origin,_that.kind,_that.state,_that.reason,_that.private);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String label,  ChecklistOrigin origin,  String kind,  ChecklistState state,  String? reason,  bool private)?  $default,) {final _that = this;
switch (_that) {
case _ChecklistItem() when $default != null:
return $default(_that.label,_that.origin,_that.kind,_that.state,_that.reason,_that.private);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChecklistItem implements ChecklistItem {
  const _ChecklistItem({required this.label, required this.origin, required this.kind, required this.state, this.reason, this.private = false});
  factory _ChecklistItem.fromJson(Map<String, dynamic> json) => _$ChecklistItemFromJson(json);

@override final  String label;
@override final  ChecklistOrigin origin;
@override final  String kind;
// carry | consume | purchase | routine
@override final  ChecklistState state;
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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChecklistItem&&(identical(other.label, label) || other.label == label)&&(identical(other.origin, origin) || other.origin == origin)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.state, state) || other.state == state)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.private, private) || other.private == private));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,label,origin,kind,state,reason,private);

@override
String toString() {
  return 'ChecklistItem(label: $label, origin: $origin, kind: $kind, state: $state, reason: $reason, private: $private)';
}


}

/// @nodoc
abstract mixin class _$ChecklistItemCopyWith<$Res> implements $ChecklistItemCopyWith<$Res> {
  factory _$ChecklistItemCopyWith(_ChecklistItem value, $Res Function(_ChecklistItem) _then) = __$ChecklistItemCopyWithImpl;
@override @useResult
$Res call({
 String label, ChecklistOrigin origin, String kind, ChecklistState state, String? reason, bool private
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
@override @pragma('vm:prefer-inline') $Res call({Object? label = null,Object? origin = null,Object? kind = null,Object? state = null,Object? reason = freezed,Object? private = null,}) {
  return _then(_ChecklistItem(
label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,origin: null == origin ? _self.origin : origin // ignore: cast_nullable_to_non_nullable
as ChecklistOrigin,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String,state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as ChecklistState,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,private: null == private ? _self.private : private // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$WellnessSummary {

 int get wis; String get wisVer; int get actionsShown; bool get eventArmed;
/// Create a copy of WellnessSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WellnessSummaryCopyWith<WellnessSummary> get copyWith => _$WellnessSummaryCopyWithImpl<WellnessSummary>(this as WellnessSummary, _$identity);

  /// Serializes this WellnessSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WellnessSummary&&(identical(other.wis, wis) || other.wis == wis)&&(identical(other.wisVer, wisVer) || other.wisVer == wisVer)&&(identical(other.actionsShown, actionsShown) || other.actionsShown == actionsShown)&&(identical(other.eventArmed, eventArmed) || other.eventArmed == eventArmed));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,wis,wisVer,actionsShown,eventArmed);

@override
String toString() {
  return 'WellnessSummary(wis: $wis, wisVer: $wisVer, actionsShown: $actionsShown, eventArmed: $eventArmed)';
}


}

/// @nodoc
abstract mixin class $WellnessSummaryCopyWith<$Res>  {
  factory $WellnessSummaryCopyWith(WellnessSummary value, $Res Function(WellnessSummary) _then) = _$WellnessSummaryCopyWithImpl;
@useResult
$Res call({
 int wis, String wisVer, int actionsShown, bool eventArmed
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
@pragma('vm:prefer-inline') @override $Res call({Object? wis = null,Object? wisVer = null,Object? actionsShown = null,Object? eventArmed = null,}) {
  return _then(_self.copyWith(
wis: null == wis ? _self.wis : wis // ignore: cast_nullable_to_non_nullable
as int,wisVer: null == wisVer ? _self.wisVer : wisVer // ignore: cast_nullable_to_non_nullable
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int wis,  String wisVer,  int actionsShown,  bool eventArmed)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WellnessSummary() when $default != null:
return $default(_that.wis,_that.wisVer,_that.actionsShown,_that.eventArmed);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int wis,  String wisVer,  int actionsShown,  bool eventArmed)  $default,) {final _that = this;
switch (_that) {
case _WellnessSummary():
return $default(_that.wis,_that.wisVer,_that.actionsShown,_that.eventArmed);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int wis,  String wisVer,  int actionsShown,  bool eventArmed)?  $default,) {final _that = this;
switch (_that) {
case _WellnessSummary() when $default != null:
return $default(_that.wis,_that.wisVer,_that.actionsShown,_that.eventArmed);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WellnessSummary implements WellnessSummary {
  const _WellnessSummary({required this.wis, required this.wisVer, required this.actionsShown, required this.eventArmed});
  factory _WellnessSummary.fromJson(Map<String, dynamic> json) => _$WellnessSummaryFromJson(json);

@override final  int wis;
@override final  String wisVer;
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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WellnessSummary&&(identical(other.wis, wis) || other.wis == wis)&&(identical(other.wisVer, wisVer) || other.wisVer == wisVer)&&(identical(other.actionsShown, actionsShown) || other.actionsShown == actionsShown)&&(identical(other.eventArmed, eventArmed) || other.eventArmed == eventArmed));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,wis,wisVer,actionsShown,eventArmed);

@override
String toString() {
  return 'WellnessSummary(wis: $wis, wisVer: $wisVer, actionsShown: $actionsShown, eventArmed: $eventArmed)';
}


}

/// @nodoc
abstract mixin class _$WellnessSummaryCopyWith<$Res> implements $WellnessSummaryCopyWith<$Res> {
  factory _$WellnessSummaryCopyWith(_WellnessSummary value, $Res Function(_WellnessSummary) _then) = __$WellnessSummaryCopyWithImpl;
@override @useResult
$Res call({
 int wis, String wisVer, int actionsShown, bool eventArmed
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
@override @pragma('vm:prefer-inline') $Res call({Object? wis = null,Object? wisVer = null,Object? actionsShown = null,Object? eventArmed = null,}) {
  return _then(_WellnessSummary(
wis: null == wis ? _self.wis : wis // ignore: cast_nullable_to_non_nullable
as int,wisVer: null == wisVer ? _self.wisVer : wisVer // ignore: cast_nullable_to_non_nullable
as String,actionsShown: null == actionsShown ? _self.actionsShown : actionsShown // ignore: cast_nullable_to_non_nullable
as int,eventArmed: null == eventArmed ? _self.eventArmed : eventArmed // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$Plan {

 String get planId; int get revisionNo; String get engineVer; String get state;// PLANNED|NOTIFIED|PREPARING|ENROUTE|ARRIVED|UNRESOLVED|CLOSED|SKIPPED|CANCELLED
 bool get feasible; DateTime get prepStartAt; DateTime get departAt; DateTime get etaAt; List<TraceItem> get trace; List<ChecklistItem> get checklist; WellnessSummary? get wellness; List<String> get degraded;
/// Create a copy of Plan
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlanCopyWith<Plan> get copyWith => _$PlanCopyWithImpl<Plan>(this as Plan, _$identity);

  /// Serializes this Plan to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Plan&&(identical(other.planId, planId) || other.planId == planId)&&(identical(other.revisionNo, revisionNo) || other.revisionNo == revisionNo)&&(identical(other.engineVer, engineVer) || other.engineVer == engineVer)&&(identical(other.state, state) || other.state == state)&&(identical(other.feasible, feasible) || other.feasible == feasible)&&(identical(other.prepStartAt, prepStartAt) || other.prepStartAt == prepStartAt)&&(identical(other.departAt, departAt) || other.departAt == departAt)&&(identical(other.etaAt, etaAt) || other.etaAt == etaAt)&&const DeepCollectionEquality().equals(other.trace, trace)&&const DeepCollectionEquality().equals(other.checklist, checklist)&&(identical(other.wellness, wellness) || other.wellness == wellness)&&const DeepCollectionEquality().equals(other.degraded, degraded));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,planId,revisionNo,engineVer,state,feasible,prepStartAt,departAt,etaAt,const DeepCollectionEquality().hash(trace),const DeepCollectionEquality().hash(checklist),wellness,const DeepCollectionEquality().hash(degraded));

@override
String toString() {
  return 'Plan(planId: $planId, revisionNo: $revisionNo, engineVer: $engineVer, state: $state, feasible: $feasible, prepStartAt: $prepStartAt, departAt: $departAt, etaAt: $etaAt, trace: $trace, checklist: $checklist, wellness: $wellness, degraded: $degraded)';
}


}

/// @nodoc
abstract mixin class $PlanCopyWith<$Res>  {
  factory $PlanCopyWith(Plan value, $Res Function(Plan) _then) = _$PlanCopyWithImpl;
@useResult
$Res call({
 String planId, int revisionNo, String engineVer, String state, bool feasible, DateTime prepStartAt, DateTime departAt, DateTime etaAt, List<TraceItem> trace, List<ChecklistItem> checklist, WellnessSummary? wellness, List<String> degraded
});


$WellnessSummaryCopyWith<$Res>? get wellness;

}
/// @nodoc
class _$PlanCopyWithImpl<$Res>
    implements $PlanCopyWith<$Res> {
  _$PlanCopyWithImpl(this._self, this._then);

  final Plan _self;
  final $Res Function(Plan) _then;

/// Create a copy of Plan
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? planId = null,Object? revisionNo = null,Object? engineVer = null,Object? state = null,Object? feasible = null,Object? prepStartAt = null,Object? departAt = null,Object? etaAt = null,Object? trace = null,Object? checklist = null,Object? wellness = freezed,Object? degraded = null,}) {
  return _then(_self.copyWith(
planId: null == planId ? _self.planId : planId // ignore: cast_nullable_to_non_nullable
as String,revisionNo: null == revisionNo ? _self.revisionNo : revisionNo // ignore: cast_nullable_to_non_nullable
as int,engineVer: null == engineVer ? _self.engineVer : engineVer // ignore: cast_nullable_to_non_nullable
as String,state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as String,feasible: null == feasible ? _self.feasible : feasible // ignore: cast_nullable_to_non_nullable
as bool,prepStartAt: null == prepStartAt ? _self.prepStartAt : prepStartAt // ignore: cast_nullable_to_non_nullable
as DateTime,departAt: null == departAt ? _self.departAt : departAt // ignore: cast_nullable_to_non_nullable
as DateTime,etaAt: null == etaAt ? _self.etaAt : etaAt // ignore: cast_nullable_to_non_nullable
as DateTime,trace: null == trace ? _self.trace : trace // ignore: cast_nullable_to_non_nullable
as List<TraceItem>,checklist: null == checklist ? _self.checklist : checklist // ignore: cast_nullable_to_non_nullable
as List<ChecklistItem>,wellness: freezed == wellness ? _self.wellness : wellness // ignore: cast_nullable_to_non_nullable
as WellnessSummary?,degraded: null == degraded ? _self.degraded : degraded // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}
/// Create a copy of Plan
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String planId,  int revisionNo,  String engineVer,  String state,  bool feasible,  DateTime prepStartAt,  DateTime departAt,  DateTime etaAt,  List<TraceItem> trace,  List<ChecklistItem> checklist,  WellnessSummary? wellness,  List<String> degraded)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Plan() when $default != null:
return $default(_that.planId,_that.revisionNo,_that.engineVer,_that.state,_that.feasible,_that.prepStartAt,_that.departAt,_that.etaAt,_that.trace,_that.checklist,_that.wellness,_that.degraded);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String planId,  int revisionNo,  String engineVer,  String state,  bool feasible,  DateTime prepStartAt,  DateTime departAt,  DateTime etaAt,  List<TraceItem> trace,  List<ChecklistItem> checklist,  WellnessSummary? wellness,  List<String> degraded)  $default,) {final _that = this;
switch (_that) {
case _Plan():
return $default(_that.planId,_that.revisionNo,_that.engineVer,_that.state,_that.feasible,_that.prepStartAt,_that.departAt,_that.etaAt,_that.trace,_that.checklist,_that.wellness,_that.degraded);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String planId,  int revisionNo,  String engineVer,  String state,  bool feasible,  DateTime prepStartAt,  DateTime departAt,  DateTime etaAt,  List<TraceItem> trace,  List<ChecklistItem> checklist,  WellnessSummary? wellness,  List<String> degraded)?  $default,) {final _that = this;
switch (_that) {
case _Plan() when $default != null:
return $default(_that.planId,_that.revisionNo,_that.engineVer,_that.state,_that.feasible,_that.prepStartAt,_that.departAt,_that.etaAt,_that.trace,_that.checklist,_that.wellness,_that.degraded);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Plan implements Plan {
  const _Plan({required this.planId, required this.revisionNo, required this.engineVer, required this.state, required this.feasible, required this.prepStartAt, required this.departAt, required this.etaAt, required final  List<TraceItem> trace, required final  List<ChecklistItem> checklist, this.wellness, final  List<String> degraded = const []}): _trace = trace,_checklist = checklist,_degraded = degraded;
  factory _Plan.fromJson(Map<String, dynamic> json) => _$PlanFromJson(json);

@override final  String planId;
@override final  int revisionNo;
@override final  String engineVer;
@override final  String state;
// PLANNED|NOTIFIED|PREPARING|ENROUTE|ARRIVED|UNRESOLVED|CLOSED|SKIPPED|CANCELLED
@override final  bool feasible;
@override final  DateTime prepStartAt;
@override final  DateTime departAt;
@override final  DateTime etaAt;
 final  List<TraceItem> _trace;
@override List<TraceItem> get trace {
  if (_trace is EqualUnmodifiableListView) return _trace;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_trace);
}

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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Plan&&(identical(other.planId, planId) || other.planId == planId)&&(identical(other.revisionNo, revisionNo) || other.revisionNo == revisionNo)&&(identical(other.engineVer, engineVer) || other.engineVer == engineVer)&&(identical(other.state, state) || other.state == state)&&(identical(other.feasible, feasible) || other.feasible == feasible)&&(identical(other.prepStartAt, prepStartAt) || other.prepStartAt == prepStartAt)&&(identical(other.departAt, departAt) || other.departAt == departAt)&&(identical(other.etaAt, etaAt) || other.etaAt == etaAt)&&const DeepCollectionEquality().equals(other._trace, _trace)&&const DeepCollectionEquality().equals(other._checklist, _checklist)&&(identical(other.wellness, wellness) || other.wellness == wellness)&&const DeepCollectionEquality().equals(other._degraded, _degraded));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,planId,revisionNo,engineVer,state,feasible,prepStartAt,departAt,etaAt,const DeepCollectionEquality().hash(_trace),const DeepCollectionEquality().hash(_checklist),wellness,const DeepCollectionEquality().hash(_degraded));

@override
String toString() {
  return 'Plan(planId: $planId, revisionNo: $revisionNo, engineVer: $engineVer, state: $state, feasible: $feasible, prepStartAt: $prepStartAt, departAt: $departAt, etaAt: $etaAt, trace: $trace, checklist: $checklist, wellness: $wellness, degraded: $degraded)';
}


}

/// @nodoc
abstract mixin class _$PlanCopyWith<$Res> implements $PlanCopyWith<$Res> {
  factory _$PlanCopyWith(_Plan value, $Res Function(_Plan) _then) = __$PlanCopyWithImpl;
@override @useResult
$Res call({
 String planId, int revisionNo, String engineVer, String state, bool feasible, DateTime prepStartAt, DateTime departAt, DateTime etaAt, List<TraceItem> trace, List<ChecklistItem> checklist, WellnessSummary? wellness, List<String> degraded
});


@override $WellnessSummaryCopyWith<$Res>? get wellness;

}
/// @nodoc
class __$PlanCopyWithImpl<$Res>
    implements _$PlanCopyWith<$Res> {
  __$PlanCopyWithImpl(this._self, this._then);

  final _Plan _self;
  final $Res Function(_Plan) _then;

/// Create a copy of Plan
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? planId = null,Object? revisionNo = null,Object? engineVer = null,Object? state = null,Object? feasible = null,Object? prepStartAt = null,Object? departAt = null,Object? etaAt = null,Object? trace = null,Object? checklist = null,Object? wellness = freezed,Object? degraded = null,}) {
  return _then(_Plan(
planId: null == planId ? _self.planId : planId // ignore: cast_nullable_to_non_nullable
as String,revisionNo: null == revisionNo ? _self.revisionNo : revisionNo // ignore: cast_nullable_to_non_nullable
as int,engineVer: null == engineVer ? _self.engineVer : engineVer // ignore: cast_nullable_to_non_nullable
as String,state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as String,feasible: null == feasible ? _self.feasible : feasible // ignore: cast_nullable_to_non_nullable
as bool,prepStartAt: null == prepStartAt ? _self.prepStartAt : prepStartAt // ignore: cast_nullable_to_non_nullable
as DateTime,departAt: null == departAt ? _self.departAt : departAt // ignore: cast_nullable_to_non_nullable
as DateTime,etaAt: null == etaAt ? _self.etaAt : etaAt // ignore: cast_nullable_to_non_nullable
as DateTime,trace: null == trace ? _self._trace : trace // ignore: cast_nullable_to_non_nullable
as List<TraceItem>,checklist: null == checklist ? _self._checklist : checklist // ignore: cast_nullable_to_non_nullable
as List<ChecklistItem>,wellness: freezed == wellness ? _self.wellness : wellness // ignore: cast_nullable_to_non_nullable
as WellnessSummary?,degraded: null == degraded ? _self._degraded : degraded // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

/// Create a copy of Plan
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
