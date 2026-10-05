// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pending_update.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PendingUpdate {

/// Also the clientSubmissionId: the server saves it at most once.
 String get id;/// Only the person who took it can send it.
 String get userId; TimeSlot get slot; String get workDate; String get description;/// When the photo was taken, by the server's clock (see ServerClock).
 DateTime get capturedAt; PhotoSource get photoSource;/// From `LocationResult.toApiFields()`.
 Map<String, Object> get location; String get photoPath; PendingState get state; int get attempts;/// Why the server refused it (API code and message), when [state] is failed.
 String? get errorCode; String? get errorMessage;
/// Create a copy of PendingUpdate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PendingUpdateCopyWith<PendingUpdate> get copyWith => _$PendingUpdateCopyWithImpl<PendingUpdate>(this as PendingUpdate, _$identity);

  /// Serializes this PendingUpdate to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PendingUpdate;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PendingUpdate&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.userId, _this.userId) || other.userId == _this.userId)&&(identical(other.slot, _this.slot) || other.slot == _this.slot)&&(identical(other.workDate, _this.workDate) || other.workDate == _this.workDate)&&(identical(other.description, _this.description) || other.description == _this.description)&&(identical(other.capturedAt, _this.capturedAt) || other.capturedAt == _this.capturedAt)&&(identical(other.photoSource, _this.photoSource) || other.photoSource == _this.photoSource)&&const DeepCollectionEquality().equals(other.location, _this.location)&&(identical(other.photoPath, _this.photoPath) || other.photoPath == _this.photoPath)&&(identical(other.state, _this.state) || other.state == _this.state)&&(identical(other.attempts, _this.attempts) || other.attempts == _this.attempts)&&(identical(other.errorCode, _this.errorCode) || other.errorCode == _this.errorCode)&&(identical(other.errorMessage, _this.errorMessage) || other.errorMessage == _this.errorMessage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PendingUpdate;
  return Object.hash(runtimeType,_this.id,_this.userId,_this.slot,_this.workDate,_this.description,_this.capturedAt,_this.photoSource,const DeepCollectionEquality().hash(_this.location),_this.photoPath,_this.state,_this.attempts,_this.errorCode,_this.errorMessage);
}

@override
String toString() {
  final _this = this as PendingUpdate;
  return 'PendingUpdate(id: ${_this.id}, userId: ${_this.userId}, slot: ${_this.slot}, workDate: ${_this.workDate}, description: ${_this.description}, capturedAt: ${_this.capturedAt}, photoSource: ${_this.photoSource}, location: ${_this.location}, photoPath: ${_this.photoPath}, state: ${_this.state}, attempts: ${_this.attempts}, errorCode: ${_this.errorCode}, errorMessage: ${_this.errorMessage})';
}


}

/// @nodoc
abstract mixin class $PendingUpdateCopyWith<$Res>  {
  factory $PendingUpdateCopyWith(PendingUpdate value, $Res Function(PendingUpdate) _then) = _$PendingUpdateCopyWithImpl;
@useResult
$Res call({
 String id, String userId, TimeSlot slot, String workDate, String description, DateTime capturedAt, PhotoSource photoSource, Map<String, Object> location, String photoPath, PendingState state, int attempts, String? errorCode, String? errorMessage
});




}
/// @nodoc
class _$PendingUpdateCopyWithImpl<$Res>
    implements $PendingUpdateCopyWith<$Res> {
  _$PendingUpdateCopyWithImpl(this._self, this._then);

  final PendingUpdate _self;
  final $Res Function(PendingUpdate) _then;

/// Create a copy of PendingUpdate
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? slot = null,Object? workDate = null,Object? description = null,Object? capturedAt = null,Object? photoSource = null,Object? location = null,Object? photoPath = null,Object? state = null,Object? attempts = null,Object? errorCode = freezed,Object? errorMessage = freezed,}) {
  return _then(PendingUpdate(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,slot: null == slot ? _self.slot : slot // ignore: cast_nullable_to_non_nullable
as TimeSlot,workDate: null == workDate ? _self.workDate : workDate // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,capturedAt: null == capturedAt ? _self.capturedAt : capturedAt // ignore: cast_nullable_to_non_nullable
as DateTime,photoSource: null == photoSource ? _self.photoSource : photoSource // ignore: cast_nullable_to_non_nullable
as PhotoSource,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as Map<String, Object>,photoPath: null == photoPath ? _self.photoPath : photoPath // ignore: cast_nullable_to_non_nullable
as String,state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as PendingState,attempts: null == attempts ? _self.attempts : attempts // ignore: cast_nullable_to_non_nullable
as int,errorCode: freezed == errorCode ? _self.errorCode : errorCode // ignore: cast_nullable_to_non_nullable
as String?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [PendingUpdate].
extension PendingUpdatePatterns on PendingUpdate {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PendingUpdate value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PendingUpdate() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PendingUpdate value)  $default,){
final _that = this;
switch (_that) {
case _PendingUpdate():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PendingUpdate value)?  $default,){
final _that = this;
switch (_that) {
case _PendingUpdate() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userId,  TimeSlot slot,  String workDate,  String description,  DateTime capturedAt,  PhotoSource photoSource,  Map<String, Object> location,  String photoPath,  PendingState state,  int attempts,  String? errorCode,  String? errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PendingUpdate() when $default != null:
return $default(_that.id,_that.userId,_that.slot,_that.workDate,_that.description,_that.capturedAt,_that.photoSource,_that.location,_that.photoPath,_that.state,_that.attempts,_that.errorCode,_that.errorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userId,  TimeSlot slot,  String workDate,  String description,  DateTime capturedAt,  PhotoSource photoSource,  Map<String, Object> location,  String photoPath,  PendingState state,  int attempts,  String? errorCode,  String? errorMessage)  $default,) {final _that = this;
switch (_that) {
case _PendingUpdate():
return $default(_that.id,_that.userId,_that.slot,_that.workDate,_that.description,_that.capturedAt,_that.photoSource,_that.location,_that.photoPath,_that.state,_that.attempts,_that.errorCode,_that.errorMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userId,  TimeSlot slot,  String workDate,  String description,  DateTime capturedAt,  PhotoSource photoSource,  Map<String, Object> location,  String photoPath,  PendingState state,  int attempts,  String? errorCode,  String? errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _PendingUpdate() when $default != null:
return $default(_that.id,_that.userId,_that.slot,_that.workDate,_that.description,_that.capturedAt,_that.photoSource,_that.location,_that.photoPath,_that.state,_that.attempts,_that.errorCode,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PendingUpdate implements PendingUpdate {
  const _PendingUpdate({required this.id, required this.userId, required this.slot, required this.workDate, required this.description, required this.capturedAt, required this.photoSource, required  Map<String, Object> location, required this.photoPath, this.state = PendingState.waiting, this.attempts = 0, this.errorCode, this.errorMessage}): _location = location;
  factory _PendingUpdate.fromJson(Map<String, dynamic> json) => _$PendingUpdateFromJson(json);

/// Also the clientSubmissionId: the server saves it at most once.
@override final  String id;
/// Only the person who took it can send it.
@override final  String userId;
@override final  TimeSlot slot;
@override final  String workDate;
@override final  String description;
/// When the photo was taken, by the server's clock (see ServerClock).
@override final  DateTime capturedAt;
@override final  PhotoSource photoSource;
/// From `LocationResult.toApiFields()`.
 final  Map<String, Object> _location;
/// From `LocationResult.toApiFields()`.
@override Map<String, Object> get location {
  if (_location is EqualUnmodifiableMapView) return _location;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_location);
}

@override final  String photoPath;
@override@JsonKey() final  PendingState state;
@override@JsonKey() final  int attempts;
/// Why the server refused it (API code and message), when [state] is failed.
@override final  String? errorCode;
@override final  String? errorMessage;

/// Create a copy of PendingUpdate
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PendingUpdateCopyWith<_PendingUpdate> get copyWith => __$PendingUpdateCopyWithImpl<_PendingUpdate>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PendingUpdateToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PendingUpdate&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.slot, slot) || other.slot == slot)&&(identical(other.workDate, workDate) || other.workDate == workDate)&&(identical(other.description, description) || other.description == description)&&(identical(other.capturedAt, capturedAt) || other.capturedAt == capturedAt)&&(identical(other.photoSource, photoSource) || other.photoSource == photoSource)&&const DeepCollectionEquality().equals(other.location, _location)&&(identical(other.photoPath, photoPath) || other.photoPath == photoPath)&&(identical(other.state, state) || other.state == state)&&(identical(other.attempts, attempts) || other.attempts == attempts)&&(identical(other.errorCode, errorCode) || other.errorCode == errorCode)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,userId,slot,workDate,description,capturedAt,photoSource,const DeepCollectionEquality().hash(_location),photoPath,state,attempts,errorCode,errorMessage);
}

@override
String toString() {
    return 'PendingUpdate(id: $id, userId: $userId, slot: $slot, workDate: $workDate, description: $description, capturedAt: $capturedAt, photoSource: $photoSource, location: $location, photoPath: $photoPath, state: $state, attempts: $attempts, errorCode: $errorCode, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$PendingUpdateCopyWith<$Res> implements $PendingUpdateCopyWith<$Res> {
  factory _$PendingUpdateCopyWith(_PendingUpdate value, $Res Function(_PendingUpdate) _then) = __$PendingUpdateCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, TimeSlot slot, String workDate, String description, DateTime capturedAt, PhotoSource photoSource, Map<String, Object> location, String photoPath, PendingState state, int attempts, String? errorCode, String? errorMessage
});




}
/// @nodoc
class __$PendingUpdateCopyWithImpl<$Res>
    implements _$PendingUpdateCopyWith<$Res> {
  __$PendingUpdateCopyWithImpl(this._self, this._then);

  final _PendingUpdate _self;
  final $Res Function(_PendingUpdate) _then;

/// Create a copy of PendingUpdate
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? slot = null,Object? workDate = null,Object? description = null,Object? capturedAt = null,Object? photoSource = null,Object? location = null,Object? photoPath = null,Object? state = null,Object? attempts = null,Object? errorCode = freezed,Object? errorMessage = freezed,}) {
  return _then(_PendingUpdate(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,slot: null == slot ? _self.slot : slot // ignore: cast_nullable_to_non_nullable
as TimeSlot,workDate: null == workDate ? _self.workDate : workDate // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,capturedAt: null == capturedAt ? _self.capturedAt : capturedAt // ignore: cast_nullable_to_non_nullable
as DateTime,photoSource: null == photoSource ? _self.photoSource : photoSource // ignore: cast_nullable_to_non_nullable
as PhotoSource,location: null == location ? _self._location : location // ignore: cast_nullable_to_non_nullable
as Map<String, Object>,photoPath: null == photoPath ? _self.photoPath : photoPath // ignore: cast_nullable_to_non_nullable
as String,state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as PendingState,attempts: null == attempts ? _self.attempts : attempts // ignore: cast_nullable_to_non_nullable
as int,errorCode: freezed == errorCode ? _self.errorCode : errorCode // ignore: cast_nullable_to_non_nullable
as String?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
