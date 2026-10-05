// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'staff_update_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UpdateStaff {

 String get id; String get name; Designation? get designation;
/// Create a copy of UpdateStaff
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateStaffCopyWith<UpdateStaff> get copyWith => _$UpdateStaffCopyWithImpl<UpdateStaff>(this as UpdateStaff, _$identity);

  /// Serializes this UpdateStaff to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as UpdateStaff;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateStaff&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.designation, _this.designation) || other.designation == _this.designation));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as UpdateStaff;
  return Object.hash(runtimeType,_this.id,_this.name,_this.designation);
}

@override
String toString() {
  final _this = this as UpdateStaff;
  return 'UpdateStaff(id: ${_this.id}, name: ${_this.name}, designation: ${_this.designation})';
}


}

/// @nodoc
abstract mixin class $UpdateStaffCopyWith<$Res>  {
  factory $UpdateStaffCopyWith(UpdateStaff value, $Res Function(UpdateStaff) _then) = _$UpdateStaffCopyWithImpl;
@useResult
$Res call({
 String id, String name, Designation? designation
});




}
/// @nodoc
class _$UpdateStaffCopyWithImpl<$Res>
    implements $UpdateStaffCopyWith<$Res> {
  _$UpdateStaffCopyWithImpl(this._self, this._then);

  final UpdateStaff _self;
  final $Res Function(UpdateStaff) _then;

/// Create a copy of UpdateStaff
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? designation = freezed,}) {
  return _then(UpdateStaff(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,designation: freezed == designation ? _self.designation : designation // ignore: cast_nullable_to_non_nullable
as Designation?,
  ));
}

}


/// Adds pattern-matching-related methods to [UpdateStaff].
extension UpdateStaffPatterns on UpdateStaff {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UpdateStaff value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UpdateStaff() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UpdateStaff value)  $default,){
final _that = this;
switch (_that) {
case _UpdateStaff():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UpdateStaff value)?  $default,){
final _that = this;
switch (_that) {
case _UpdateStaff() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  Designation? designation)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UpdateStaff() when $default != null:
return $default(_that.id,_that.name,_that.designation);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  Designation? designation)  $default,) {final _that = this;
switch (_that) {
case _UpdateStaff():
return $default(_that.id,_that.name,_that.designation);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  Designation? designation)?  $default,) {final _that = this;
switch (_that) {
case _UpdateStaff() when $default != null:
return $default(_that.id,_that.name,_that.designation);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UpdateStaff implements UpdateStaff {
  const _UpdateStaff({required this.id, required this.name, this.designation});
  factory _UpdateStaff.fromJson(Map<String, dynamic> json) => _$UpdateStaffFromJson(json);

@override final  String id;
@override final  String name;
@override final  Designation? designation;

/// Create a copy of UpdateStaff
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateStaffCopyWith<_UpdateStaff> get copyWith => __$UpdateStaffCopyWithImpl<_UpdateStaff>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UpdateStaffToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateStaff&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.designation, designation) || other.designation == designation));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,designation);
}

@override
String toString() {
    return 'UpdateStaff(id: $id, name: $name, designation: $designation)';
}


}

/// @nodoc
abstract mixin class _$UpdateStaffCopyWith<$Res> implements $UpdateStaffCopyWith<$Res> {
  factory _$UpdateStaffCopyWith(_UpdateStaff value, $Res Function(_UpdateStaff) _then) = __$UpdateStaffCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, Designation? designation
});




}
/// @nodoc
class __$UpdateStaffCopyWithImpl<$Res>
    implements _$UpdateStaffCopyWith<$Res> {
  __$UpdateStaffCopyWithImpl(this._self, this._then);

  final _UpdateStaff _self;
  final $Res Function(_UpdateStaff) _then;

/// Create a copy of UpdateStaff
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? designation = freezed,}) {
  return _then(_UpdateStaff(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,designation: freezed == designation ? _self.designation : designation // ignore: cast_nullable_to_non_nullable
as Designation?,
  ));
}


}


/// @nodoc
mixin _$UpdateLocation {

 LocationFlag get flag; int? get distanceFromSiteM;
/// Create a copy of UpdateLocation
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateLocationCopyWith<UpdateLocation> get copyWith => _$UpdateLocationCopyWithImpl<UpdateLocation>(this as UpdateLocation, _$identity);

  /// Serializes this UpdateLocation to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as UpdateLocation;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateLocation&&(identical(other.flag, _this.flag) || other.flag == _this.flag)&&(identical(other.distanceFromSiteM, _this.distanceFromSiteM) || other.distanceFromSiteM == _this.distanceFromSiteM));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as UpdateLocation;
  return Object.hash(runtimeType,_this.flag,_this.distanceFromSiteM);
}

@override
String toString() {
  final _this = this as UpdateLocation;
  return 'UpdateLocation(flag: ${_this.flag}, distanceFromSiteM: ${_this.distanceFromSiteM})';
}


}

/// @nodoc
abstract mixin class $UpdateLocationCopyWith<$Res>  {
  factory $UpdateLocationCopyWith(UpdateLocation value, $Res Function(UpdateLocation) _then) = _$UpdateLocationCopyWithImpl;
@useResult
$Res call({
 LocationFlag flag, int? distanceFromSiteM
});




}
/// @nodoc
class _$UpdateLocationCopyWithImpl<$Res>
    implements $UpdateLocationCopyWith<$Res> {
  _$UpdateLocationCopyWithImpl(this._self, this._then);

  final UpdateLocation _self;
  final $Res Function(UpdateLocation) _then;

/// Create a copy of UpdateLocation
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? flag = null,Object? distanceFromSiteM = freezed,}) {
  return _then(UpdateLocation(
flag: null == flag ? _self.flag : flag // ignore: cast_nullable_to_non_nullable
as LocationFlag,distanceFromSiteM: freezed == distanceFromSiteM ? _self.distanceFromSiteM : distanceFromSiteM // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [UpdateLocation].
extension UpdateLocationPatterns on UpdateLocation {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UpdateLocation value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UpdateLocation() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UpdateLocation value)  $default,){
final _that = this;
switch (_that) {
case _UpdateLocation():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UpdateLocation value)?  $default,){
final _that = this;
switch (_that) {
case _UpdateLocation() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( LocationFlag flag,  int? distanceFromSiteM)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UpdateLocation() when $default != null:
return $default(_that.flag,_that.distanceFromSiteM);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( LocationFlag flag,  int? distanceFromSiteM)  $default,) {final _that = this;
switch (_that) {
case _UpdateLocation():
return $default(_that.flag,_that.distanceFromSiteM);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( LocationFlag flag,  int? distanceFromSiteM)?  $default,) {final _that = this;
switch (_that) {
case _UpdateLocation() when $default != null:
return $default(_that.flag,_that.distanceFromSiteM);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UpdateLocation implements UpdateLocation {
  const _UpdateLocation({required this.flag, this.distanceFromSiteM});
  factory _UpdateLocation.fromJson(Map<String, dynamic> json) => _$UpdateLocationFromJson(json);

@override final  LocationFlag flag;
@override final  int? distanceFromSiteM;

/// Create a copy of UpdateLocation
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateLocationCopyWith<_UpdateLocation> get copyWith => __$UpdateLocationCopyWithImpl<_UpdateLocation>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UpdateLocationToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateLocation&&(identical(other.flag, flag) || other.flag == flag)&&(identical(other.distanceFromSiteM, distanceFromSiteM) || other.distanceFromSiteM == distanceFromSiteM));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,flag,distanceFromSiteM);
}

@override
String toString() {
    return 'UpdateLocation(flag: $flag, distanceFromSiteM: $distanceFromSiteM)';
}


}

/// @nodoc
abstract mixin class _$UpdateLocationCopyWith<$Res> implements $UpdateLocationCopyWith<$Res> {
  factory _$UpdateLocationCopyWith(_UpdateLocation value, $Res Function(_UpdateLocation) _then) = __$UpdateLocationCopyWithImpl;
@override @useResult
$Res call({
 LocationFlag flag, int? distanceFromSiteM
});




}
/// @nodoc
class __$UpdateLocationCopyWithImpl<$Res>
    implements _$UpdateLocationCopyWith<$Res> {
  __$UpdateLocationCopyWithImpl(this._self, this._then);

  final _UpdateLocation _self;
  final $Res Function(_UpdateLocation) _then;

/// Create a copy of UpdateLocation
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? flag = null,Object? distanceFromSiteM = freezed,}) {
  return _then(_UpdateLocation(
flag: null == flag ? _self.flag : flag // ignore: cast_nullable_to_non_nullable
as LocationFlag,distanceFromSiteM: freezed == distanceFromSiteM ? _self.distanceFromSiteM : distanceFromSiteM // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$UpdateImage {

 ImageStatus get status; DateTime get expiresAt; DateTime? get deletedAt; ImageDeleteReason? get deleteReason;
/// Create a copy of UpdateImage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateImageCopyWith<UpdateImage> get copyWith => _$UpdateImageCopyWithImpl<UpdateImage>(this as UpdateImage, _$identity);

  /// Serializes this UpdateImage to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as UpdateImage;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateImage&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.expiresAt, _this.expiresAt) || other.expiresAt == _this.expiresAt)&&(identical(other.deletedAt, _this.deletedAt) || other.deletedAt == _this.deletedAt)&&(identical(other.deleteReason, _this.deleteReason) || other.deleteReason == _this.deleteReason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as UpdateImage;
  return Object.hash(runtimeType,_this.status,_this.expiresAt,_this.deletedAt,_this.deleteReason);
}

@override
String toString() {
  final _this = this as UpdateImage;
  return 'UpdateImage(status: ${_this.status}, expiresAt: ${_this.expiresAt}, deletedAt: ${_this.deletedAt}, deleteReason: ${_this.deleteReason})';
}


}

/// @nodoc
abstract mixin class $UpdateImageCopyWith<$Res>  {
  factory $UpdateImageCopyWith(UpdateImage value, $Res Function(UpdateImage) _then) = _$UpdateImageCopyWithImpl;
@useResult
$Res call({
 ImageStatus status, DateTime expiresAt, DateTime? deletedAt, ImageDeleteReason? deleteReason
});




}
/// @nodoc
class _$UpdateImageCopyWithImpl<$Res>
    implements $UpdateImageCopyWith<$Res> {
  _$UpdateImageCopyWithImpl(this._self, this._then);

  final UpdateImage _self;
  final $Res Function(UpdateImage) _then;

/// Create a copy of UpdateImage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? expiresAt = null,Object? deletedAt = freezed,Object? deleteReason = freezed,}) {
  return _then(UpdateImage(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ImageStatus,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,deleteReason: freezed == deleteReason ? _self.deleteReason : deleteReason // ignore: cast_nullable_to_non_nullable
as ImageDeleteReason?,
  ));
}

}


/// Adds pattern-matching-related methods to [UpdateImage].
extension UpdateImagePatterns on UpdateImage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UpdateImage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UpdateImage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UpdateImage value)  $default,){
final _that = this;
switch (_that) {
case _UpdateImage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UpdateImage value)?  $default,){
final _that = this;
switch (_that) {
case _UpdateImage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ImageStatus status,  DateTime expiresAt,  DateTime? deletedAt,  ImageDeleteReason? deleteReason)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UpdateImage() when $default != null:
return $default(_that.status,_that.expiresAt,_that.deletedAt,_that.deleteReason);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ImageStatus status,  DateTime expiresAt,  DateTime? deletedAt,  ImageDeleteReason? deleteReason)  $default,) {final _that = this;
switch (_that) {
case _UpdateImage():
return $default(_that.status,_that.expiresAt,_that.deletedAt,_that.deleteReason);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ImageStatus status,  DateTime expiresAt,  DateTime? deletedAt,  ImageDeleteReason? deleteReason)?  $default,) {final _that = this;
switch (_that) {
case _UpdateImage() when $default != null:
return $default(_that.status,_that.expiresAt,_that.deletedAt,_that.deleteReason);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UpdateImage implements UpdateImage {
  const _UpdateImage({required this.status, required this.expiresAt, this.deletedAt, this.deleteReason});
  factory _UpdateImage.fromJson(Map<String, dynamic> json) => _$UpdateImageFromJson(json);

@override final  ImageStatus status;
@override final  DateTime expiresAt;
@override final  DateTime? deletedAt;
@override final  ImageDeleteReason? deleteReason;

/// Create a copy of UpdateImage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateImageCopyWith<_UpdateImage> get copyWith => __$UpdateImageCopyWithImpl<_UpdateImage>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UpdateImageToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateImage&&(identical(other.status, status) || other.status == status)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt)&&(identical(other.deleteReason, deleteReason) || other.deleteReason == deleteReason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,status,expiresAt,deletedAt,deleteReason);
}

@override
String toString() {
    return 'UpdateImage(status: $status, expiresAt: $expiresAt, deletedAt: $deletedAt, deleteReason: $deleteReason)';
}


}

/// @nodoc
abstract mixin class _$UpdateImageCopyWith<$Res> implements $UpdateImageCopyWith<$Res> {
  factory _$UpdateImageCopyWith(_UpdateImage value, $Res Function(_UpdateImage) _then) = __$UpdateImageCopyWithImpl;
@override @useResult
$Res call({
 ImageStatus status, DateTime expiresAt, DateTime? deletedAt, ImageDeleteReason? deleteReason
});




}
/// @nodoc
class __$UpdateImageCopyWithImpl<$Res>
    implements _$UpdateImageCopyWith<$Res> {
  __$UpdateImageCopyWithImpl(this._self, this._then);

  final _UpdateImage _self;
  final $Res Function(_UpdateImage) _then;

/// Create a copy of UpdateImage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? expiresAt = null,Object? deletedAt = freezed,Object? deleteReason = freezed,}) {
  return _then(_UpdateImage(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ImageStatus,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,deleteReason: freezed == deleteReason ? _self.deleteReason : deleteReason // ignore: cast_nullable_to_non_nullable
as ImageDeleteReason?,
  ));
}


}


/// @nodoc
mixin _$StaffUpdate {

 String get id; String get workDate; TimeSlot get slot; String get description; UpdateStaff get staff; IdName get site; IdName get engineer; DateTime get submittedAt; DateTime get capturedAt; bool get submittedOffline; UpdateLocation get location; PhotoSource get photoSource; UpdateImage get image; DateTime? get engineerViewedAt; DateTime? get adminViewedAt;
/// Create a copy of StaffUpdate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StaffUpdateCopyWith<StaffUpdate> get copyWith => _$StaffUpdateCopyWithImpl<StaffUpdate>(this as StaffUpdate, _$identity);

  /// Serializes this StaffUpdate to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as StaffUpdate;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StaffUpdate&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.workDate, _this.workDate) || other.workDate == _this.workDate)&&(identical(other.slot, _this.slot) || other.slot == _this.slot)&&(identical(other.description, _this.description) || other.description == _this.description)&&(identical(other.staff, _this.staff) || other.staff == _this.staff)&&(identical(other.site, _this.site) || other.site == _this.site)&&(identical(other.engineer, _this.engineer) || other.engineer == _this.engineer)&&(identical(other.submittedAt, _this.submittedAt) || other.submittedAt == _this.submittedAt)&&(identical(other.capturedAt, _this.capturedAt) || other.capturedAt == _this.capturedAt)&&(identical(other.submittedOffline, _this.submittedOffline) || other.submittedOffline == _this.submittedOffline)&&(identical(other.location, _this.location) || other.location == _this.location)&&(identical(other.photoSource, _this.photoSource) || other.photoSource == _this.photoSource)&&(identical(other.image, _this.image) || other.image == _this.image)&&(identical(other.engineerViewedAt, _this.engineerViewedAt) || other.engineerViewedAt == _this.engineerViewedAt)&&(identical(other.adminViewedAt, _this.adminViewedAt) || other.adminViewedAt == _this.adminViewedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as StaffUpdate;
  return Object.hash(runtimeType,_this.id,_this.workDate,_this.slot,_this.description,_this.staff,_this.site,_this.engineer,_this.submittedAt,_this.capturedAt,_this.submittedOffline,_this.location,_this.photoSource,_this.image,_this.engineerViewedAt,_this.adminViewedAt);
}

@override
String toString() {
  final _this = this as StaffUpdate;
  return 'StaffUpdate(id: ${_this.id}, workDate: ${_this.workDate}, slot: ${_this.slot}, description: ${_this.description}, staff: ${_this.staff}, site: ${_this.site}, engineer: ${_this.engineer}, submittedAt: ${_this.submittedAt}, capturedAt: ${_this.capturedAt}, submittedOffline: ${_this.submittedOffline}, location: ${_this.location}, photoSource: ${_this.photoSource}, image: ${_this.image}, engineerViewedAt: ${_this.engineerViewedAt}, adminViewedAt: ${_this.adminViewedAt})';
}


}

/// @nodoc
abstract mixin class $StaffUpdateCopyWith<$Res>  {
  factory $StaffUpdateCopyWith(StaffUpdate value, $Res Function(StaffUpdate) _then) = _$StaffUpdateCopyWithImpl;
@useResult
$Res call({
 String id, String workDate, TimeSlot slot, String description, UpdateStaff staff, IdName site, IdName engineer, DateTime submittedAt, DateTime capturedAt, bool submittedOffline, UpdateLocation location, PhotoSource photoSource, UpdateImage image, DateTime? engineerViewedAt, DateTime? adminViewedAt
});


$UpdateStaffCopyWith<$Res> get staff;$IdNameCopyWith<$Res> get site;$IdNameCopyWith<$Res> get engineer;$UpdateLocationCopyWith<$Res> get location;$UpdateImageCopyWith<$Res> get image;

}
/// @nodoc
class _$StaffUpdateCopyWithImpl<$Res>
    implements $StaffUpdateCopyWith<$Res> {
  _$StaffUpdateCopyWithImpl(this._self, this._then);

  final StaffUpdate _self;
  final $Res Function(StaffUpdate) _then;

/// Create a copy of StaffUpdate
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? workDate = null,Object? slot = null,Object? description = null,Object? staff = null,Object? site = null,Object? engineer = null,Object? submittedAt = null,Object? capturedAt = null,Object? submittedOffline = null,Object? location = null,Object? photoSource = null,Object? image = null,Object? engineerViewedAt = freezed,Object? adminViewedAt = freezed,}) {
  return _then(StaffUpdate(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,workDate: null == workDate ? _self.workDate : workDate // ignore: cast_nullable_to_non_nullable
as String,slot: null == slot ? _self.slot : slot // ignore: cast_nullable_to_non_nullable
as TimeSlot,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,staff: null == staff ? _self.staff : staff // ignore: cast_nullable_to_non_nullable
as UpdateStaff,site: null == site ? _self.site : site // ignore: cast_nullable_to_non_nullable
as IdName,engineer: null == engineer ? _self.engineer : engineer // ignore: cast_nullable_to_non_nullable
as IdName,submittedAt: null == submittedAt ? _self.submittedAt : submittedAt // ignore: cast_nullable_to_non_nullable
as DateTime,capturedAt: null == capturedAt ? _self.capturedAt : capturedAt // ignore: cast_nullable_to_non_nullable
as DateTime,submittedOffline: null == submittedOffline ? _self.submittedOffline : submittedOffline // ignore: cast_nullable_to_non_nullable
as bool,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as UpdateLocation,photoSource: null == photoSource ? _self.photoSource : photoSource // ignore: cast_nullable_to_non_nullable
as PhotoSource,image: null == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as UpdateImage,engineerViewedAt: freezed == engineerViewedAt ? _self.engineerViewedAt : engineerViewedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,adminViewedAt: freezed == adminViewedAt ? _self.adminViewedAt : adminViewedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}
/// Create a copy of StaffUpdate
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UpdateStaffCopyWith<$Res> get staff {
  
  return $UpdateStaffCopyWith<$Res>(_self.staff, (value) {
    return _then(_self.copyWith(staff: value));
  });
}/// Create a copy of StaffUpdate
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$IdNameCopyWith<$Res> get site {
  
  return $IdNameCopyWith<$Res>(_self.site, (value) {
    return _then(_self.copyWith(site: value));
  });
}/// Create a copy of StaffUpdate
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$IdNameCopyWith<$Res> get engineer {
  
  return $IdNameCopyWith<$Res>(_self.engineer, (value) {
    return _then(_self.copyWith(engineer: value));
  });
}/// Create a copy of StaffUpdate
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UpdateLocationCopyWith<$Res> get location {
  
  return $UpdateLocationCopyWith<$Res>(_self.location, (value) {
    return _then(_self.copyWith(location: value));
  });
}/// Create a copy of StaffUpdate
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UpdateImageCopyWith<$Res> get image {
  
  return $UpdateImageCopyWith<$Res>(_self.image, (value) {
    return _then(_self.copyWith(image: value));
  });
}
}


/// Adds pattern-matching-related methods to [StaffUpdate].
extension StaffUpdatePatterns on StaffUpdate {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StaffUpdate value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StaffUpdate() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StaffUpdate value)  $default,){
final _that = this;
switch (_that) {
case _StaffUpdate():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StaffUpdate value)?  $default,){
final _that = this;
switch (_that) {
case _StaffUpdate() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String workDate,  TimeSlot slot,  String description,  UpdateStaff staff,  IdName site,  IdName engineer,  DateTime submittedAt,  DateTime capturedAt,  bool submittedOffline,  UpdateLocation location,  PhotoSource photoSource,  UpdateImage image,  DateTime? engineerViewedAt,  DateTime? adminViewedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StaffUpdate() when $default != null:
return $default(_that.id,_that.workDate,_that.slot,_that.description,_that.staff,_that.site,_that.engineer,_that.submittedAt,_that.capturedAt,_that.submittedOffline,_that.location,_that.photoSource,_that.image,_that.engineerViewedAt,_that.adminViewedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String workDate,  TimeSlot slot,  String description,  UpdateStaff staff,  IdName site,  IdName engineer,  DateTime submittedAt,  DateTime capturedAt,  bool submittedOffline,  UpdateLocation location,  PhotoSource photoSource,  UpdateImage image,  DateTime? engineerViewedAt,  DateTime? adminViewedAt)  $default,) {final _that = this;
switch (_that) {
case _StaffUpdate():
return $default(_that.id,_that.workDate,_that.slot,_that.description,_that.staff,_that.site,_that.engineer,_that.submittedAt,_that.capturedAt,_that.submittedOffline,_that.location,_that.photoSource,_that.image,_that.engineerViewedAt,_that.adminViewedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String workDate,  TimeSlot slot,  String description,  UpdateStaff staff,  IdName site,  IdName engineer,  DateTime submittedAt,  DateTime capturedAt,  bool submittedOffline,  UpdateLocation location,  PhotoSource photoSource,  UpdateImage image,  DateTime? engineerViewedAt,  DateTime? adminViewedAt)?  $default,) {final _that = this;
switch (_that) {
case _StaffUpdate() when $default != null:
return $default(_that.id,_that.workDate,_that.slot,_that.description,_that.staff,_that.site,_that.engineer,_that.submittedAt,_that.capturedAt,_that.submittedOffline,_that.location,_that.photoSource,_that.image,_that.engineerViewedAt,_that.adminViewedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StaffUpdate implements StaffUpdate {
  const _StaffUpdate({required this.id, required this.workDate, required this.slot, required this.description, required this.staff, required this.site, required this.engineer, required this.submittedAt, required this.capturedAt, required this.submittedOffline, required this.location, required this.photoSource, required this.image, this.engineerViewedAt, this.adminViewedAt});
  factory _StaffUpdate.fromJson(Map<String, dynamic> json) => _$StaffUpdateFromJson(json);

@override final  String id;
@override final  String workDate;
@override final  TimeSlot slot;
@override final  String description;
@override final  UpdateStaff staff;
@override final  IdName site;
@override final  IdName engineer;
@override final  DateTime submittedAt;
@override final  DateTime capturedAt;
@override final  bool submittedOffline;
@override final  UpdateLocation location;
@override final  PhotoSource photoSource;
@override final  UpdateImage image;
@override final  DateTime? engineerViewedAt;
@override final  DateTime? adminViewedAt;

/// Create a copy of StaffUpdate
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StaffUpdateCopyWith<_StaffUpdate> get copyWith => __$StaffUpdateCopyWithImpl<_StaffUpdate>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StaffUpdateToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _StaffUpdate&&(identical(other.id, id) || other.id == id)&&(identical(other.workDate, workDate) || other.workDate == workDate)&&(identical(other.slot, slot) || other.slot == slot)&&(identical(other.description, description) || other.description == description)&&(identical(other.staff, staff) || other.staff == staff)&&(identical(other.site, site) || other.site == site)&&(identical(other.engineer, engineer) || other.engineer == engineer)&&(identical(other.submittedAt, submittedAt) || other.submittedAt == submittedAt)&&(identical(other.capturedAt, capturedAt) || other.capturedAt == capturedAt)&&(identical(other.submittedOffline, submittedOffline) || other.submittedOffline == submittedOffline)&&(identical(other.location, location) || other.location == location)&&(identical(other.photoSource, photoSource) || other.photoSource == photoSource)&&(identical(other.image, image) || other.image == image)&&(identical(other.engineerViewedAt, engineerViewedAt) || other.engineerViewedAt == engineerViewedAt)&&(identical(other.adminViewedAt, adminViewedAt) || other.adminViewedAt == adminViewedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,workDate,slot,description,staff,site,engineer,submittedAt,capturedAt,submittedOffline,location,photoSource,image,engineerViewedAt,adminViewedAt);
}

@override
String toString() {
    return 'StaffUpdate(id: $id, workDate: $workDate, slot: $slot, description: $description, staff: $staff, site: $site, engineer: $engineer, submittedAt: $submittedAt, capturedAt: $capturedAt, submittedOffline: $submittedOffline, location: $location, photoSource: $photoSource, image: $image, engineerViewedAt: $engineerViewedAt, adminViewedAt: $adminViewedAt)';
}


}

/// @nodoc
abstract mixin class _$StaffUpdateCopyWith<$Res> implements $StaffUpdateCopyWith<$Res> {
  factory _$StaffUpdateCopyWith(_StaffUpdate value, $Res Function(_StaffUpdate) _then) = __$StaffUpdateCopyWithImpl;
@override @useResult
$Res call({
 String id, String workDate, TimeSlot slot, String description, UpdateStaff staff, IdName site, IdName engineer, DateTime submittedAt, DateTime capturedAt, bool submittedOffline, UpdateLocation location, PhotoSource photoSource, UpdateImage image, DateTime? engineerViewedAt, DateTime? adminViewedAt
});


@override $UpdateStaffCopyWith<$Res> get staff;@override $IdNameCopyWith<$Res> get site;@override $IdNameCopyWith<$Res> get engineer;@override $UpdateLocationCopyWith<$Res> get location;@override $UpdateImageCopyWith<$Res> get image;

}
/// @nodoc
class __$StaffUpdateCopyWithImpl<$Res>
    implements _$StaffUpdateCopyWith<$Res> {
  __$StaffUpdateCopyWithImpl(this._self, this._then);

  final _StaffUpdate _self;
  final $Res Function(_StaffUpdate) _then;

/// Create a copy of StaffUpdate
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? workDate = null,Object? slot = null,Object? description = null,Object? staff = null,Object? site = null,Object? engineer = null,Object? submittedAt = null,Object? capturedAt = null,Object? submittedOffline = null,Object? location = null,Object? photoSource = null,Object? image = null,Object? engineerViewedAt = freezed,Object? adminViewedAt = freezed,}) {
  return _then(_StaffUpdate(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,workDate: null == workDate ? _self.workDate : workDate // ignore: cast_nullable_to_non_nullable
as String,slot: null == slot ? _self.slot : slot // ignore: cast_nullable_to_non_nullable
as TimeSlot,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,staff: null == staff ? _self.staff : staff // ignore: cast_nullable_to_non_nullable
as UpdateStaff,site: null == site ? _self.site : site // ignore: cast_nullable_to_non_nullable
as IdName,engineer: null == engineer ? _self.engineer : engineer // ignore: cast_nullable_to_non_nullable
as IdName,submittedAt: null == submittedAt ? _self.submittedAt : submittedAt // ignore: cast_nullable_to_non_nullable
as DateTime,capturedAt: null == capturedAt ? _self.capturedAt : capturedAt // ignore: cast_nullable_to_non_nullable
as DateTime,submittedOffline: null == submittedOffline ? _self.submittedOffline : submittedOffline // ignore: cast_nullable_to_non_nullable
as bool,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as UpdateLocation,photoSource: null == photoSource ? _self.photoSource : photoSource // ignore: cast_nullable_to_non_nullable
as PhotoSource,image: null == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as UpdateImage,engineerViewedAt: freezed == engineerViewedAt ? _self.engineerViewedAt : engineerViewedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,adminViewedAt: freezed == adminViewedAt ? _self.adminViewedAt : adminViewedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

/// Create a copy of StaffUpdate
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UpdateStaffCopyWith<$Res> get staff {
  
  return $UpdateStaffCopyWith<$Res>(_self.staff, (value) {
    return _then(_self.copyWith(staff: value));
  });
}/// Create a copy of StaffUpdate
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$IdNameCopyWith<$Res> get site {
  
  return $IdNameCopyWith<$Res>(_self.site, (value) {
    return _then(_self.copyWith(site: value));
  });
}/// Create a copy of StaffUpdate
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$IdNameCopyWith<$Res> get engineer {
  
  return $IdNameCopyWith<$Res>(_self.engineer, (value) {
    return _then(_self.copyWith(engineer: value));
  });
}/// Create a copy of StaffUpdate
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UpdateLocationCopyWith<$Res> get location {
  
  return $UpdateLocationCopyWith<$Res>(_self.location, (value) {
    return _then(_self.copyWith(location: value));
  });
}/// Create a copy of StaffUpdate
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UpdateImageCopyWith<$Res> get image {
  
  return $UpdateImageCopyWith<$Res>(_self.image, (value) {
    return _then(_self.copyWith(image: value));
  });
}
}


/// @nodoc
mixin _$ImageLink {

 String get url; DateTime get expiresAt;
/// Create a copy of ImageLink
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ImageLinkCopyWith<ImageLink> get copyWith => _$ImageLinkCopyWithImpl<ImageLink>(this as ImageLink, _$identity);

  /// Serializes this ImageLink to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ImageLink;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ImageLink&&(identical(other.url, _this.url) || other.url == _this.url)&&(identical(other.expiresAt, _this.expiresAt) || other.expiresAt == _this.expiresAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ImageLink;
  return Object.hash(runtimeType,_this.url,_this.expiresAt);
}

@override
String toString() {
  final _this = this as ImageLink;
  return 'ImageLink(url: ${_this.url}, expiresAt: ${_this.expiresAt})';
}


}

/// @nodoc
abstract mixin class $ImageLinkCopyWith<$Res>  {
  factory $ImageLinkCopyWith(ImageLink value, $Res Function(ImageLink) _then) = _$ImageLinkCopyWithImpl;
@useResult
$Res call({
 String url, DateTime expiresAt
});




}
/// @nodoc
class _$ImageLinkCopyWithImpl<$Res>
    implements $ImageLinkCopyWith<$Res> {
  _$ImageLinkCopyWithImpl(this._self, this._then);

  final ImageLink _self;
  final $Res Function(ImageLink) _then;

/// Create a copy of ImageLink
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? url = null,Object? expiresAt = null,}) {
  return _then(ImageLink(
url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [ImageLink].
extension ImageLinkPatterns on ImageLink {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ImageLink value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ImageLink() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ImageLink value)  $default,){
final _that = this;
switch (_that) {
case _ImageLink():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ImageLink value)?  $default,){
final _that = this;
switch (_that) {
case _ImageLink() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String url,  DateTime expiresAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ImageLink() when $default != null:
return $default(_that.url,_that.expiresAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String url,  DateTime expiresAt)  $default,) {final _that = this;
switch (_that) {
case _ImageLink():
return $default(_that.url,_that.expiresAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String url,  DateTime expiresAt)?  $default,) {final _that = this;
switch (_that) {
case _ImageLink() when $default != null:
return $default(_that.url,_that.expiresAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ImageLink implements ImageLink {
  const _ImageLink({required this.url, required this.expiresAt});
  factory _ImageLink.fromJson(Map<String, dynamic> json) => _$ImageLinkFromJson(json);

@override final  String url;
@override final  DateTime expiresAt;

/// Create a copy of ImageLink
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ImageLinkCopyWith<_ImageLink> get copyWith => __$ImageLinkCopyWithImpl<_ImageLink>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ImageLinkToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ImageLink&&(identical(other.url, url) || other.url == url)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,url,expiresAt);
}

@override
String toString() {
    return 'ImageLink(url: $url, expiresAt: $expiresAt)';
}


}

/// @nodoc
abstract mixin class _$ImageLinkCopyWith<$Res> implements $ImageLinkCopyWith<$Res> {
  factory _$ImageLinkCopyWith(_ImageLink value, $Res Function(_ImageLink) _then) = __$ImageLinkCopyWithImpl;
@override @useResult
$Res call({
 String url, DateTime expiresAt
});




}
/// @nodoc
class __$ImageLinkCopyWithImpl<$Res>
    implements _$ImageLinkCopyWith<$Res> {
  __$ImageLinkCopyWithImpl(this._self, this._then);

  final _ImageLink _self;
  final $Res Function(_ImageLink) _then;

/// Create a copy of ImageLink
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? url = null,Object? expiresAt = null,}) {
  return _then(_ImageLink(
url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$SlotUpdateRef {

 String get id; DateTime get submittedAt; bool get submittedOffline; ImageStatus? get imageStatus; DateTime? get engineerViewedAt; DateTime? get adminViewedAt;
/// Create a copy of SlotUpdateRef
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SlotUpdateRefCopyWith<SlotUpdateRef> get copyWith => _$SlotUpdateRefCopyWithImpl<SlotUpdateRef>(this as SlotUpdateRef, _$identity);

  /// Serializes this SlotUpdateRef to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as SlotUpdateRef;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SlotUpdateRef&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.submittedAt, _this.submittedAt) || other.submittedAt == _this.submittedAt)&&(identical(other.submittedOffline, _this.submittedOffline) || other.submittedOffline == _this.submittedOffline)&&(identical(other.imageStatus, _this.imageStatus) || other.imageStatus == _this.imageStatus)&&(identical(other.engineerViewedAt, _this.engineerViewedAt) || other.engineerViewedAt == _this.engineerViewedAt)&&(identical(other.adminViewedAt, _this.adminViewedAt) || other.adminViewedAt == _this.adminViewedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as SlotUpdateRef;
  return Object.hash(runtimeType,_this.id,_this.submittedAt,_this.submittedOffline,_this.imageStatus,_this.engineerViewedAt,_this.adminViewedAt);
}

@override
String toString() {
  final _this = this as SlotUpdateRef;
  return 'SlotUpdateRef(id: ${_this.id}, submittedAt: ${_this.submittedAt}, submittedOffline: ${_this.submittedOffline}, imageStatus: ${_this.imageStatus}, engineerViewedAt: ${_this.engineerViewedAt}, adminViewedAt: ${_this.adminViewedAt})';
}


}

/// @nodoc
abstract mixin class $SlotUpdateRefCopyWith<$Res>  {
  factory $SlotUpdateRefCopyWith(SlotUpdateRef value, $Res Function(SlotUpdateRef) _then) = _$SlotUpdateRefCopyWithImpl;
@useResult
$Res call({
 String id, DateTime submittedAt, bool submittedOffline, ImageStatus? imageStatus, DateTime? engineerViewedAt, DateTime? adminViewedAt
});




}
/// @nodoc
class _$SlotUpdateRefCopyWithImpl<$Res>
    implements $SlotUpdateRefCopyWith<$Res> {
  _$SlotUpdateRefCopyWithImpl(this._self, this._then);

  final SlotUpdateRef _self;
  final $Res Function(SlotUpdateRef) _then;

/// Create a copy of SlotUpdateRef
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? submittedAt = null,Object? submittedOffline = null,Object? imageStatus = freezed,Object? engineerViewedAt = freezed,Object? adminViewedAt = freezed,}) {
  return _then(SlotUpdateRef(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,submittedAt: null == submittedAt ? _self.submittedAt : submittedAt // ignore: cast_nullable_to_non_nullable
as DateTime,submittedOffline: null == submittedOffline ? _self.submittedOffline : submittedOffline // ignore: cast_nullable_to_non_nullable
as bool,imageStatus: freezed == imageStatus ? _self.imageStatus : imageStatus // ignore: cast_nullable_to_non_nullable
as ImageStatus?,engineerViewedAt: freezed == engineerViewedAt ? _self.engineerViewedAt : engineerViewedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,adminViewedAt: freezed == adminViewedAt ? _self.adminViewedAt : adminViewedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [SlotUpdateRef].
extension SlotUpdateRefPatterns on SlotUpdateRef {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SlotUpdateRef value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SlotUpdateRef() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SlotUpdateRef value)  $default,){
final _that = this;
switch (_that) {
case _SlotUpdateRef():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SlotUpdateRef value)?  $default,){
final _that = this;
switch (_that) {
case _SlotUpdateRef() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  DateTime submittedAt,  bool submittedOffline,  ImageStatus? imageStatus,  DateTime? engineerViewedAt,  DateTime? adminViewedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SlotUpdateRef() when $default != null:
return $default(_that.id,_that.submittedAt,_that.submittedOffline,_that.imageStatus,_that.engineerViewedAt,_that.adminViewedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  DateTime submittedAt,  bool submittedOffline,  ImageStatus? imageStatus,  DateTime? engineerViewedAt,  DateTime? adminViewedAt)  $default,) {final _that = this;
switch (_that) {
case _SlotUpdateRef():
return $default(_that.id,_that.submittedAt,_that.submittedOffline,_that.imageStatus,_that.engineerViewedAt,_that.adminViewedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  DateTime submittedAt,  bool submittedOffline,  ImageStatus? imageStatus,  DateTime? engineerViewedAt,  DateTime? adminViewedAt)?  $default,) {final _that = this;
switch (_that) {
case _SlotUpdateRef() when $default != null:
return $default(_that.id,_that.submittedAt,_that.submittedOffline,_that.imageStatus,_that.engineerViewedAt,_that.adminViewedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SlotUpdateRef implements SlotUpdateRef {
  const _SlotUpdateRef({required this.id, required this.submittedAt, required this.submittedOffline, this.imageStatus, this.engineerViewedAt, this.adminViewedAt});
  factory _SlotUpdateRef.fromJson(Map<String, dynamic> json) => _$SlotUpdateRefFromJson(json);

@override final  String id;
@override final  DateTime submittedAt;
@override final  bool submittedOffline;
@override final  ImageStatus? imageStatus;
@override final  DateTime? engineerViewedAt;
@override final  DateTime? adminViewedAt;

/// Create a copy of SlotUpdateRef
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SlotUpdateRefCopyWith<_SlotUpdateRef> get copyWith => __$SlotUpdateRefCopyWithImpl<_SlotUpdateRef>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SlotUpdateRefToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SlotUpdateRef&&(identical(other.id, id) || other.id == id)&&(identical(other.submittedAt, submittedAt) || other.submittedAt == submittedAt)&&(identical(other.submittedOffline, submittedOffline) || other.submittedOffline == submittedOffline)&&(identical(other.imageStatus, imageStatus) || other.imageStatus == imageStatus)&&(identical(other.engineerViewedAt, engineerViewedAt) || other.engineerViewedAt == engineerViewedAt)&&(identical(other.adminViewedAt, adminViewedAt) || other.adminViewedAt == adminViewedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,submittedAt,submittedOffline,imageStatus,engineerViewedAt,adminViewedAt);
}

@override
String toString() {
    return 'SlotUpdateRef(id: $id, submittedAt: $submittedAt, submittedOffline: $submittedOffline, imageStatus: $imageStatus, engineerViewedAt: $engineerViewedAt, adminViewedAt: $adminViewedAt)';
}


}

/// @nodoc
abstract mixin class _$SlotUpdateRefCopyWith<$Res> implements $SlotUpdateRefCopyWith<$Res> {
  factory _$SlotUpdateRefCopyWith(_SlotUpdateRef value, $Res Function(_SlotUpdateRef) _then) = __$SlotUpdateRefCopyWithImpl;
@override @useResult
$Res call({
 String id, DateTime submittedAt, bool submittedOffline, ImageStatus? imageStatus, DateTime? engineerViewedAt, DateTime? adminViewedAt
});




}
/// @nodoc
class __$SlotUpdateRefCopyWithImpl<$Res>
    implements _$SlotUpdateRefCopyWith<$Res> {
  __$SlotUpdateRefCopyWithImpl(this._self, this._then);

  final _SlotUpdateRef _self;
  final $Res Function(_SlotUpdateRef) _then;

/// Create a copy of SlotUpdateRef
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? submittedAt = null,Object? submittedOffline = null,Object? imageStatus = freezed,Object? engineerViewedAt = freezed,Object? adminViewedAt = freezed,}) {
  return _then(_SlotUpdateRef(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,submittedAt: null == submittedAt ? _self.submittedAt : submittedAt // ignore: cast_nullable_to_non_nullable
as DateTime,submittedOffline: null == submittedOffline ? _self.submittedOffline : submittedOffline // ignore: cast_nullable_to_non_nullable
as bool,imageStatus: freezed == imageStatus ? _self.imageStatus : imageStatus // ignore: cast_nullable_to_non_nullable
as ImageStatus?,engineerViewedAt: freezed == engineerViewedAt ? _self.engineerViewedAt : engineerViewedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,adminViewedAt: freezed == adminViewedAt ? _self.adminViewedAt : adminViewedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$DaySlot {

 TimeSlot get slot; SlotState get state; DateTime get start; DateTime get end;/// The window's end plus grace: until then a late update still counts.
 DateTime get closesAt; SlotUpdateRef? get update;
/// Create a copy of DaySlot
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DaySlotCopyWith<DaySlot> get copyWith => _$DaySlotCopyWithImpl<DaySlot>(this as DaySlot, _$identity);

  /// Serializes this DaySlot to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as DaySlot;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DaySlot&&(identical(other.slot, _this.slot) || other.slot == _this.slot)&&(identical(other.state, _this.state) || other.state == _this.state)&&(identical(other.start, _this.start) || other.start == _this.start)&&(identical(other.end, _this.end) || other.end == _this.end)&&(identical(other.closesAt, _this.closesAt) || other.closesAt == _this.closesAt)&&(identical(other.update, _this.update) || other.update == _this.update));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as DaySlot;
  return Object.hash(runtimeType,_this.slot,_this.state,_this.start,_this.end,_this.closesAt,_this.update);
}

@override
String toString() {
  final _this = this as DaySlot;
  return 'DaySlot(slot: ${_this.slot}, state: ${_this.state}, start: ${_this.start}, end: ${_this.end}, closesAt: ${_this.closesAt}, update: ${_this.update})';
}


}

/// @nodoc
abstract mixin class $DaySlotCopyWith<$Res>  {
  factory $DaySlotCopyWith(DaySlot value, $Res Function(DaySlot) _then) = _$DaySlotCopyWithImpl;
@useResult
$Res call({
 TimeSlot slot, SlotState state, DateTime start, DateTime end, DateTime closesAt, SlotUpdateRef? update
});


$SlotUpdateRefCopyWith<$Res>? get update;

}
/// @nodoc
class _$DaySlotCopyWithImpl<$Res>
    implements $DaySlotCopyWith<$Res> {
  _$DaySlotCopyWithImpl(this._self, this._then);

  final DaySlot _self;
  final $Res Function(DaySlot) _then;

/// Create a copy of DaySlot
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? slot = null,Object? state = null,Object? start = null,Object? end = null,Object? closesAt = null,Object? update = freezed,}) {
  return _then(DaySlot(
slot: null == slot ? _self.slot : slot // ignore: cast_nullable_to_non_nullable
as TimeSlot,state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as SlotState,start: null == start ? _self.start : start // ignore: cast_nullable_to_non_nullable
as DateTime,end: null == end ? _self.end : end // ignore: cast_nullable_to_non_nullable
as DateTime,closesAt: null == closesAt ? _self.closesAt : closesAt // ignore: cast_nullable_to_non_nullable
as DateTime,update: freezed == update ? _self.update : update // ignore: cast_nullable_to_non_nullable
as SlotUpdateRef?,
  ));
}
/// Create a copy of DaySlot
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SlotUpdateRefCopyWith<$Res>? get update {
    if (_self.update == null) {
    return null;
  }

  return $SlotUpdateRefCopyWith<$Res>(_self.update!, (value) {
    return _then(_self.copyWith(update: value));
  });
}
}


/// Adds pattern-matching-related methods to [DaySlot].
extension DaySlotPatterns on DaySlot {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DaySlot value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DaySlot() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DaySlot value)  $default,){
final _that = this;
switch (_that) {
case _DaySlot():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DaySlot value)?  $default,){
final _that = this;
switch (_that) {
case _DaySlot() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( TimeSlot slot,  SlotState state,  DateTime start,  DateTime end,  DateTime closesAt,  SlotUpdateRef? update)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DaySlot() when $default != null:
return $default(_that.slot,_that.state,_that.start,_that.end,_that.closesAt,_that.update);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( TimeSlot slot,  SlotState state,  DateTime start,  DateTime end,  DateTime closesAt,  SlotUpdateRef? update)  $default,) {final _that = this;
switch (_that) {
case _DaySlot():
return $default(_that.slot,_that.state,_that.start,_that.end,_that.closesAt,_that.update);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( TimeSlot slot,  SlotState state,  DateTime start,  DateTime end,  DateTime closesAt,  SlotUpdateRef? update)?  $default,) {final _that = this;
switch (_that) {
case _DaySlot() when $default != null:
return $default(_that.slot,_that.state,_that.start,_that.end,_that.closesAt,_that.update);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DaySlot implements DaySlot {
  const _DaySlot({required this.slot, required this.state, required this.start, required this.end, required this.closesAt, this.update});
  factory _DaySlot.fromJson(Map<String, dynamic> json) => _$DaySlotFromJson(json);

@override final  TimeSlot slot;
@override final  SlotState state;
@override final  DateTime start;
@override final  DateTime end;
/// The window's end plus grace: until then a late update still counts.
@override final  DateTime closesAt;
@override final  SlotUpdateRef? update;

/// Create a copy of DaySlot
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DaySlotCopyWith<_DaySlot> get copyWith => __$DaySlotCopyWithImpl<_DaySlot>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DaySlotToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DaySlot&&(identical(other.slot, slot) || other.slot == slot)&&(identical(other.state, state) || other.state == state)&&(identical(other.start, start) || other.start == start)&&(identical(other.end, end) || other.end == end)&&(identical(other.closesAt, closesAt) || other.closesAt == closesAt)&&(identical(other.update, update) || other.update == update));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,slot,state,start,end,closesAt,update);
}

@override
String toString() {
    return 'DaySlot(slot: $slot, state: $state, start: $start, end: $end, closesAt: $closesAt, update: $update)';
}


}

/// @nodoc
abstract mixin class _$DaySlotCopyWith<$Res> implements $DaySlotCopyWith<$Res> {
  factory _$DaySlotCopyWith(_DaySlot value, $Res Function(_DaySlot) _then) = __$DaySlotCopyWithImpl;
@override @useResult
$Res call({
 TimeSlot slot, SlotState state, DateTime start, DateTime end, DateTime closesAt, SlotUpdateRef? update
});


@override $SlotUpdateRefCopyWith<$Res>? get update;

}
/// @nodoc
class __$DaySlotCopyWithImpl<$Res>
    implements _$DaySlotCopyWith<$Res> {
  __$DaySlotCopyWithImpl(this._self, this._then);

  final _DaySlot _self;
  final $Res Function(_DaySlot) _then;

/// Create a copy of DaySlot
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? slot = null,Object? state = null,Object? start = null,Object? end = null,Object? closesAt = null,Object? update = freezed,}) {
  return _then(_DaySlot(
slot: null == slot ? _self.slot : slot // ignore: cast_nullable_to_non_nullable
as TimeSlot,state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as SlotState,start: null == start ? _self.start : start // ignore: cast_nullable_to_non_nullable
as DateTime,end: null == end ? _self.end : end // ignore: cast_nullable_to_non_nullable
as DateTime,closesAt: null == closesAt ? _self.closesAt : closesAt // ignore: cast_nullable_to_non_nullable
as DateTime,update: freezed == update ? _self.update : update // ignore: cast_nullable_to_non_nullable
as SlotUpdateRef?,
  ));
}

/// Create a copy of DaySlot
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SlotUpdateRefCopyWith<$Res>? get update {
    if (_self.update == null) {
    return null;
  }

  return $SlotUpdateRefCopyWith<$Res>(_self.update!, (value) {
    return _then(_self.copyWith(update: value));
  });
}
}


/// @nodoc
mixin _$TodaySite {

 String get id; String get code; String get name; String get address; double? get latitude; double? get longitude; int? get geofenceRadiusM;
/// Create a copy of TodaySite
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TodaySiteCopyWith<TodaySite> get copyWith => _$TodaySiteCopyWithImpl<TodaySite>(this as TodaySite, _$identity);

  /// Serializes this TodaySite to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TodaySite;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TodaySite&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.code, _this.code) || other.code == _this.code)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.address, _this.address) || other.address == _this.address)&&(identical(other.latitude, _this.latitude) || other.latitude == _this.latitude)&&(identical(other.longitude, _this.longitude) || other.longitude == _this.longitude)&&(identical(other.geofenceRadiusM, _this.geofenceRadiusM) || other.geofenceRadiusM == _this.geofenceRadiusM));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TodaySite;
  return Object.hash(runtimeType,_this.id,_this.code,_this.name,_this.address,_this.latitude,_this.longitude,_this.geofenceRadiusM);
}

@override
String toString() {
  final _this = this as TodaySite;
  return 'TodaySite(id: ${_this.id}, code: ${_this.code}, name: ${_this.name}, address: ${_this.address}, latitude: ${_this.latitude}, longitude: ${_this.longitude}, geofenceRadiusM: ${_this.geofenceRadiusM})';
}


}

/// @nodoc
abstract mixin class $TodaySiteCopyWith<$Res>  {
  factory $TodaySiteCopyWith(TodaySite value, $Res Function(TodaySite) _then) = _$TodaySiteCopyWithImpl;
@useResult
$Res call({
 String id, String code, String name, String address, double? latitude, double? longitude, int? geofenceRadiusM
});




}
/// @nodoc
class _$TodaySiteCopyWithImpl<$Res>
    implements $TodaySiteCopyWith<$Res> {
  _$TodaySiteCopyWithImpl(this._self, this._then);

  final TodaySite _self;
  final $Res Function(TodaySite) _then;

/// Create a copy of TodaySite
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? code = null,Object? name = null,Object? address = null,Object? latitude = freezed,Object? longitude = freezed,Object? geofenceRadiusM = freezed,}) {
  return _then(TodaySite(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,latitude: freezed == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double?,longitude: freezed == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double?,geofenceRadiusM: freezed == geofenceRadiusM ? _self.geofenceRadiusM : geofenceRadiusM // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [TodaySite].
extension TodaySitePatterns on TodaySite {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TodaySite value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TodaySite() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TodaySite value)  $default,){
final _that = this;
switch (_that) {
case _TodaySite():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TodaySite value)?  $default,){
final _that = this;
switch (_that) {
case _TodaySite() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String code,  String name,  String address,  double? latitude,  double? longitude,  int? geofenceRadiusM)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TodaySite() when $default != null:
return $default(_that.id,_that.code,_that.name,_that.address,_that.latitude,_that.longitude,_that.geofenceRadiusM);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String code,  String name,  String address,  double? latitude,  double? longitude,  int? geofenceRadiusM)  $default,) {final _that = this;
switch (_that) {
case _TodaySite():
return $default(_that.id,_that.code,_that.name,_that.address,_that.latitude,_that.longitude,_that.geofenceRadiusM);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String code,  String name,  String address,  double? latitude,  double? longitude,  int? geofenceRadiusM)?  $default,) {final _that = this;
switch (_that) {
case _TodaySite() when $default != null:
return $default(_that.id,_that.code,_that.name,_that.address,_that.latitude,_that.longitude,_that.geofenceRadiusM);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TodaySite implements TodaySite {
  const _TodaySite({required this.id, required this.code, required this.name, required this.address, this.latitude, this.longitude, this.geofenceRadiusM});
  factory _TodaySite.fromJson(Map<String, dynamic> json) => _$TodaySiteFromJson(json);

@override final  String id;
@override final  String code;
@override final  String name;
@override final  String address;
@override final  double? latitude;
@override final  double? longitude;
@override final  int? geofenceRadiusM;

/// Create a copy of TodaySite
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TodaySiteCopyWith<_TodaySite> get copyWith => __$TodaySiteCopyWithImpl<_TodaySite>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TodaySiteToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TodaySite&&(identical(other.id, id) || other.id == id)&&(identical(other.code, code) || other.code == code)&&(identical(other.name, name) || other.name == name)&&(identical(other.address, address) || other.address == address)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.geofenceRadiusM, geofenceRadiusM) || other.geofenceRadiusM == geofenceRadiusM));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,code,name,address,latitude,longitude,geofenceRadiusM);
}

@override
String toString() {
    return 'TodaySite(id: $id, code: $code, name: $name, address: $address, latitude: $latitude, longitude: $longitude, geofenceRadiusM: $geofenceRadiusM)';
}


}

/// @nodoc
abstract mixin class _$TodaySiteCopyWith<$Res> implements $TodaySiteCopyWith<$Res> {
  factory _$TodaySiteCopyWith(_TodaySite value, $Res Function(_TodaySite) _then) = __$TodaySiteCopyWithImpl;
@override @useResult
$Res call({
 String id, String code, String name, String address, double? latitude, double? longitude, int? geofenceRadiusM
});




}
/// @nodoc
class __$TodaySiteCopyWithImpl<$Res>
    implements _$TodaySiteCopyWith<$Res> {
  __$TodaySiteCopyWithImpl(this._self, this._then);

  final _TodaySite _self;
  final $Res Function(_TodaySite) _then;

/// Create a copy of TodaySite
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? code = null,Object? name = null,Object? address = null,Object? latitude = freezed,Object? longitude = freezed,Object? geofenceRadiusM = freezed,}) {
  return _then(_TodaySite(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,latitude: freezed == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double?,longitude: freezed == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double?,geofenceRadiusM: freezed == geofenceRadiusM ? _self.geofenceRadiusM : geofenceRadiusM // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$TodayAssignment {

 TodaySite get site; PersonRef get engineer;
/// Create a copy of TodayAssignment
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TodayAssignmentCopyWith<TodayAssignment> get copyWith => _$TodayAssignmentCopyWithImpl<TodayAssignment>(this as TodayAssignment, _$identity);

  /// Serializes this TodayAssignment to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TodayAssignment;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TodayAssignment&&(identical(other.site, _this.site) || other.site == _this.site)&&(identical(other.engineer, _this.engineer) || other.engineer == _this.engineer));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TodayAssignment;
  return Object.hash(runtimeType,_this.site,_this.engineer);
}

@override
String toString() {
  final _this = this as TodayAssignment;
  return 'TodayAssignment(site: ${_this.site}, engineer: ${_this.engineer})';
}


}

/// @nodoc
abstract mixin class $TodayAssignmentCopyWith<$Res>  {
  factory $TodayAssignmentCopyWith(TodayAssignment value, $Res Function(TodayAssignment) _then) = _$TodayAssignmentCopyWithImpl;
@useResult
$Res call({
 TodaySite site, PersonRef engineer
});


$TodaySiteCopyWith<$Res> get site;$PersonRefCopyWith<$Res> get engineer;

}
/// @nodoc
class _$TodayAssignmentCopyWithImpl<$Res>
    implements $TodayAssignmentCopyWith<$Res> {
  _$TodayAssignmentCopyWithImpl(this._self, this._then);

  final TodayAssignment _self;
  final $Res Function(TodayAssignment) _then;

/// Create a copy of TodayAssignment
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? site = null,Object? engineer = null,}) {
  return _then(TodayAssignment(
site: null == site ? _self.site : site // ignore: cast_nullable_to_non_nullable
as TodaySite,engineer: null == engineer ? _self.engineer : engineer // ignore: cast_nullable_to_non_nullable
as PersonRef,
  ));
}
/// Create a copy of TodayAssignment
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TodaySiteCopyWith<$Res> get site {
  
  return $TodaySiteCopyWith<$Res>(_self.site, (value) {
    return _then(_self.copyWith(site: value));
  });
}/// Create a copy of TodayAssignment
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PersonRefCopyWith<$Res> get engineer {
  
  return $PersonRefCopyWith<$Res>(_self.engineer, (value) {
    return _then(_self.copyWith(engineer: value));
  });
}
}


/// Adds pattern-matching-related methods to [TodayAssignment].
extension TodayAssignmentPatterns on TodayAssignment {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TodayAssignment value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TodayAssignment() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TodayAssignment value)  $default,){
final _that = this;
switch (_that) {
case _TodayAssignment():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TodayAssignment value)?  $default,){
final _that = this;
switch (_that) {
case _TodayAssignment() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( TodaySite site,  PersonRef engineer)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TodayAssignment() when $default != null:
return $default(_that.site,_that.engineer);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( TodaySite site,  PersonRef engineer)  $default,) {final _that = this;
switch (_that) {
case _TodayAssignment():
return $default(_that.site,_that.engineer);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( TodaySite site,  PersonRef engineer)?  $default,) {final _that = this;
switch (_that) {
case _TodayAssignment() when $default != null:
return $default(_that.site,_that.engineer);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TodayAssignment implements TodayAssignment {
  const _TodayAssignment({required this.site, required this.engineer});
  factory _TodayAssignment.fromJson(Map<String, dynamic> json) => _$TodayAssignmentFromJson(json);

@override final  TodaySite site;
@override final  PersonRef engineer;

/// Create a copy of TodayAssignment
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TodayAssignmentCopyWith<_TodayAssignment> get copyWith => __$TodayAssignmentCopyWithImpl<_TodayAssignment>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TodayAssignmentToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TodayAssignment&&(identical(other.site, site) || other.site == site)&&(identical(other.engineer, engineer) || other.engineer == engineer));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,site,engineer);
}

@override
String toString() {
    return 'TodayAssignment(site: $site, engineer: $engineer)';
}


}

/// @nodoc
abstract mixin class _$TodayAssignmentCopyWith<$Res> implements $TodayAssignmentCopyWith<$Res> {
  factory _$TodayAssignmentCopyWith(_TodayAssignment value, $Res Function(_TodayAssignment) _then) = __$TodayAssignmentCopyWithImpl;
@override @useResult
$Res call({
 TodaySite site, PersonRef engineer
});


@override $TodaySiteCopyWith<$Res> get site;@override $PersonRefCopyWith<$Res> get engineer;

}
/// @nodoc
class __$TodayAssignmentCopyWithImpl<$Res>
    implements _$TodayAssignmentCopyWith<$Res> {
  __$TodayAssignmentCopyWithImpl(this._self, this._then);

  final _TodayAssignment _self;
  final $Res Function(_TodayAssignment) _then;

/// Create a copy of TodayAssignment
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? site = null,Object? engineer = null,}) {
  return _then(_TodayAssignment(
site: null == site ? _self.site : site // ignore: cast_nullable_to_non_nullable
as TodaySite,engineer: null == engineer ? _self.engineer : engineer // ignore: cast_nullable_to_non_nullable
as PersonRef,
  ));
}

/// Create a copy of TodayAssignment
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TodaySiteCopyWith<$Res> get site {
  
  return $TodaySiteCopyWith<$Res>(_self.site, (value) {
    return _then(_self.copyWith(site: value));
  });
}/// Create a copy of TodayAssignment
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PersonRefCopyWith<$Res> get engineer {
  
  return $PersonRefCopyWith<$Res>(_self.engineer, (value) {
    return _then(_self.copyWith(engineer: value));
  });
}
}


/// @nodoc
mixin _$FieldRules {

 bool get requireCheckIn; bool get allowGallery; bool get locationRequired; int get fixTimeoutSeconds; double get maxUploadMb; int get offlineAcceptanceMinutes; int get defaultGeofenceRadiusM;
/// Create a copy of FieldRules
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FieldRulesCopyWith<FieldRules> get copyWith => _$FieldRulesCopyWithImpl<FieldRules>(this as FieldRules, _$identity);

  /// Serializes this FieldRules to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as FieldRules;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FieldRules&&(identical(other.requireCheckIn, _this.requireCheckIn) || other.requireCheckIn == _this.requireCheckIn)&&(identical(other.allowGallery, _this.allowGallery) || other.allowGallery == _this.allowGallery)&&(identical(other.locationRequired, _this.locationRequired) || other.locationRequired == _this.locationRequired)&&(identical(other.fixTimeoutSeconds, _this.fixTimeoutSeconds) || other.fixTimeoutSeconds == _this.fixTimeoutSeconds)&&(identical(other.maxUploadMb, _this.maxUploadMb) || other.maxUploadMb == _this.maxUploadMb)&&(identical(other.offlineAcceptanceMinutes, _this.offlineAcceptanceMinutes) || other.offlineAcceptanceMinutes == _this.offlineAcceptanceMinutes)&&(identical(other.defaultGeofenceRadiusM, _this.defaultGeofenceRadiusM) || other.defaultGeofenceRadiusM == _this.defaultGeofenceRadiusM));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as FieldRules;
  return Object.hash(runtimeType,_this.requireCheckIn,_this.allowGallery,_this.locationRequired,_this.fixTimeoutSeconds,_this.maxUploadMb,_this.offlineAcceptanceMinutes,_this.defaultGeofenceRadiusM);
}

@override
String toString() {
  final _this = this as FieldRules;
  return 'FieldRules(requireCheckIn: ${_this.requireCheckIn}, allowGallery: ${_this.allowGallery}, locationRequired: ${_this.locationRequired}, fixTimeoutSeconds: ${_this.fixTimeoutSeconds}, maxUploadMb: ${_this.maxUploadMb}, offlineAcceptanceMinutes: ${_this.offlineAcceptanceMinutes}, defaultGeofenceRadiusM: ${_this.defaultGeofenceRadiusM})';
}


}

/// @nodoc
abstract mixin class $FieldRulesCopyWith<$Res>  {
  factory $FieldRulesCopyWith(FieldRules value, $Res Function(FieldRules) _then) = _$FieldRulesCopyWithImpl;
@useResult
$Res call({
 bool requireCheckIn, bool allowGallery, bool locationRequired, int fixTimeoutSeconds, double maxUploadMb, int offlineAcceptanceMinutes, int defaultGeofenceRadiusM
});




}
/// @nodoc
class _$FieldRulesCopyWithImpl<$Res>
    implements $FieldRulesCopyWith<$Res> {
  _$FieldRulesCopyWithImpl(this._self, this._then);

  final FieldRules _self;
  final $Res Function(FieldRules) _then;

/// Create a copy of FieldRules
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? requireCheckIn = null,Object? allowGallery = null,Object? locationRequired = null,Object? fixTimeoutSeconds = null,Object? maxUploadMb = null,Object? offlineAcceptanceMinutes = null,Object? defaultGeofenceRadiusM = null,}) {
  return _then(FieldRules(
requireCheckIn: null == requireCheckIn ? _self.requireCheckIn : requireCheckIn // ignore: cast_nullable_to_non_nullable
as bool,allowGallery: null == allowGallery ? _self.allowGallery : allowGallery // ignore: cast_nullable_to_non_nullable
as bool,locationRequired: null == locationRequired ? _self.locationRequired : locationRequired // ignore: cast_nullable_to_non_nullable
as bool,fixTimeoutSeconds: null == fixTimeoutSeconds ? _self.fixTimeoutSeconds : fixTimeoutSeconds // ignore: cast_nullable_to_non_nullable
as int,maxUploadMb: null == maxUploadMb ? _self.maxUploadMb : maxUploadMb // ignore: cast_nullable_to_non_nullable
as double,offlineAcceptanceMinutes: null == offlineAcceptanceMinutes ? _self.offlineAcceptanceMinutes : offlineAcceptanceMinutes // ignore: cast_nullable_to_non_nullable
as int,defaultGeofenceRadiusM: null == defaultGeofenceRadiusM ? _self.defaultGeofenceRadiusM : defaultGeofenceRadiusM // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [FieldRules].
extension FieldRulesPatterns on FieldRules {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FieldRules value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FieldRules() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FieldRules value)  $default,){
final _that = this;
switch (_that) {
case _FieldRules():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FieldRules value)?  $default,){
final _that = this;
switch (_that) {
case _FieldRules() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool requireCheckIn,  bool allowGallery,  bool locationRequired,  int fixTimeoutSeconds,  double maxUploadMb,  int offlineAcceptanceMinutes,  int defaultGeofenceRadiusM)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FieldRules() when $default != null:
return $default(_that.requireCheckIn,_that.allowGallery,_that.locationRequired,_that.fixTimeoutSeconds,_that.maxUploadMb,_that.offlineAcceptanceMinutes,_that.defaultGeofenceRadiusM);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool requireCheckIn,  bool allowGallery,  bool locationRequired,  int fixTimeoutSeconds,  double maxUploadMb,  int offlineAcceptanceMinutes,  int defaultGeofenceRadiusM)  $default,) {final _that = this;
switch (_that) {
case _FieldRules():
return $default(_that.requireCheckIn,_that.allowGallery,_that.locationRequired,_that.fixTimeoutSeconds,_that.maxUploadMb,_that.offlineAcceptanceMinutes,_that.defaultGeofenceRadiusM);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool requireCheckIn,  bool allowGallery,  bool locationRequired,  int fixTimeoutSeconds,  double maxUploadMb,  int offlineAcceptanceMinutes,  int defaultGeofenceRadiusM)?  $default,) {final _that = this;
switch (_that) {
case _FieldRules() when $default != null:
return $default(_that.requireCheckIn,_that.allowGallery,_that.locationRequired,_that.fixTimeoutSeconds,_that.maxUploadMb,_that.offlineAcceptanceMinutes,_that.defaultGeofenceRadiusM);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FieldRules implements FieldRules {
  const _FieldRules({required this.requireCheckIn, required this.allowGallery, required this.locationRequired, required this.fixTimeoutSeconds, required this.maxUploadMb, required this.offlineAcceptanceMinutes, required this.defaultGeofenceRadiusM});
  factory _FieldRules.fromJson(Map<String, dynamic> json) => _$FieldRulesFromJson(json);

@override final  bool requireCheckIn;
@override final  bool allowGallery;
@override final  bool locationRequired;
@override final  int fixTimeoutSeconds;
@override final  double maxUploadMb;
@override final  int offlineAcceptanceMinutes;
@override final  int defaultGeofenceRadiusM;

/// Create a copy of FieldRules
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FieldRulesCopyWith<_FieldRules> get copyWith => __$FieldRulesCopyWithImpl<_FieldRules>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FieldRulesToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _FieldRules&&(identical(other.requireCheckIn, requireCheckIn) || other.requireCheckIn == requireCheckIn)&&(identical(other.allowGallery, allowGallery) || other.allowGallery == allowGallery)&&(identical(other.locationRequired, locationRequired) || other.locationRequired == locationRequired)&&(identical(other.fixTimeoutSeconds, fixTimeoutSeconds) || other.fixTimeoutSeconds == fixTimeoutSeconds)&&(identical(other.maxUploadMb, maxUploadMb) || other.maxUploadMb == maxUploadMb)&&(identical(other.offlineAcceptanceMinutes, offlineAcceptanceMinutes) || other.offlineAcceptanceMinutes == offlineAcceptanceMinutes)&&(identical(other.defaultGeofenceRadiusM, defaultGeofenceRadiusM) || other.defaultGeofenceRadiusM == defaultGeofenceRadiusM));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,requireCheckIn,allowGallery,locationRequired,fixTimeoutSeconds,maxUploadMb,offlineAcceptanceMinutes,defaultGeofenceRadiusM);
}

@override
String toString() {
    return 'FieldRules(requireCheckIn: $requireCheckIn, allowGallery: $allowGallery, locationRequired: $locationRequired, fixTimeoutSeconds: $fixTimeoutSeconds, maxUploadMb: $maxUploadMb, offlineAcceptanceMinutes: $offlineAcceptanceMinutes, defaultGeofenceRadiusM: $defaultGeofenceRadiusM)';
}


}

/// @nodoc
abstract mixin class _$FieldRulesCopyWith<$Res> implements $FieldRulesCopyWith<$Res> {
  factory _$FieldRulesCopyWith(_FieldRules value, $Res Function(_FieldRules) _then) = __$FieldRulesCopyWithImpl;
@override @useResult
$Res call({
 bool requireCheckIn, bool allowGallery, bool locationRequired, int fixTimeoutSeconds, double maxUploadMb, int offlineAcceptanceMinutes, int defaultGeofenceRadiusM
});




}
/// @nodoc
class __$FieldRulesCopyWithImpl<$Res>
    implements _$FieldRulesCopyWith<$Res> {
  __$FieldRulesCopyWithImpl(this._self, this._then);

  final _FieldRules _self;
  final $Res Function(_FieldRules) _then;

/// Create a copy of FieldRules
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? requireCheckIn = null,Object? allowGallery = null,Object? locationRequired = null,Object? fixTimeoutSeconds = null,Object? maxUploadMb = null,Object? offlineAcceptanceMinutes = null,Object? defaultGeofenceRadiusM = null,}) {
  return _then(_FieldRules(
requireCheckIn: null == requireCheckIn ? _self.requireCheckIn : requireCheckIn // ignore: cast_nullable_to_non_nullable
as bool,allowGallery: null == allowGallery ? _self.allowGallery : allowGallery // ignore: cast_nullable_to_non_nullable
as bool,locationRequired: null == locationRequired ? _self.locationRequired : locationRequired // ignore: cast_nullable_to_non_nullable
as bool,fixTimeoutSeconds: null == fixTimeoutSeconds ? _self.fixTimeoutSeconds : fixTimeoutSeconds // ignore: cast_nullable_to_non_nullable
as int,maxUploadMb: null == maxUploadMb ? _self.maxUploadMb : maxUploadMb // ignore: cast_nullable_to_non_nullable
as double,offlineAcceptanceMinutes: null == offlineAcceptanceMinutes ? _self.offlineAcceptanceMinutes : offlineAcceptanceMinutes // ignore: cast_nullable_to_non_nullable
as int,defaultGeofenceRadiusM: null == defaultGeofenceRadiusM ? _self.defaultGeofenceRadiusM : defaultGeofenceRadiusM // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$StaffToday {

 DateTime get serverTime; String get date; bool get isWorkingDay; String? get holiday; TodayAssignment? get assignment; AttendanceRecord? get attendance; List<DaySlot> get slots; FieldRules get rules;
/// Create a copy of StaffToday
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StaffTodayCopyWith<StaffToday> get copyWith => _$StaffTodayCopyWithImpl<StaffToday>(this as StaffToday, _$identity);

  /// Serializes this StaffToday to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as StaffToday;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StaffToday&&(identical(other.serverTime, _this.serverTime) || other.serverTime == _this.serverTime)&&(identical(other.date, _this.date) || other.date == _this.date)&&(identical(other.isWorkingDay, _this.isWorkingDay) || other.isWorkingDay == _this.isWorkingDay)&&(identical(other.holiday, _this.holiday) || other.holiday == _this.holiday)&&(identical(other.assignment, _this.assignment) || other.assignment == _this.assignment)&&(identical(other.attendance, _this.attendance) || other.attendance == _this.attendance)&&const DeepCollectionEquality().equals(other.slots, _this.slots)&&(identical(other.rules, _this.rules) || other.rules == _this.rules));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as StaffToday;
  return Object.hash(runtimeType,_this.serverTime,_this.date,_this.isWorkingDay,_this.holiday,_this.assignment,_this.attendance,const DeepCollectionEquality().hash(_this.slots),_this.rules);
}

@override
String toString() {
  final _this = this as StaffToday;
  return 'StaffToday(serverTime: ${_this.serverTime}, date: ${_this.date}, isWorkingDay: ${_this.isWorkingDay}, holiday: ${_this.holiday}, assignment: ${_this.assignment}, attendance: ${_this.attendance}, slots: ${_this.slots}, rules: ${_this.rules})';
}


}

/// @nodoc
abstract mixin class $StaffTodayCopyWith<$Res>  {
  factory $StaffTodayCopyWith(StaffToday value, $Res Function(StaffToday) _then) = _$StaffTodayCopyWithImpl;
@useResult
$Res call({
 DateTime serverTime, String date, bool isWorkingDay, String? holiday, TodayAssignment? assignment, AttendanceRecord? attendance, List<DaySlot> slots, FieldRules rules
});


$TodayAssignmentCopyWith<$Res>? get assignment;$AttendanceRecordCopyWith<$Res>? get attendance;$FieldRulesCopyWith<$Res> get rules;

}
/// @nodoc
class _$StaffTodayCopyWithImpl<$Res>
    implements $StaffTodayCopyWith<$Res> {
  _$StaffTodayCopyWithImpl(this._self, this._then);

  final StaffToday _self;
  final $Res Function(StaffToday) _then;

/// Create a copy of StaffToday
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? serverTime = null,Object? date = null,Object? isWorkingDay = null,Object? holiday = freezed,Object? assignment = freezed,Object? attendance = freezed,Object? slots = null,Object? rules = null,}) {
  return _then(StaffToday(
serverTime: null == serverTime ? _self.serverTime : serverTime // ignore: cast_nullable_to_non_nullable
as DateTime,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,isWorkingDay: null == isWorkingDay ? _self.isWorkingDay : isWorkingDay // ignore: cast_nullable_to_non_nullable
as bool,holiday: freezed == holiday ? _self.holiday : holiday // ignore: cast_nullable_to_non_nullable
as String?,assignment: freezed == assignment ? _self.assignment : assignment // ignore: cast_nullable_to_non_nullable
as TodayAssignment?,attendance: freezed == attendance ? _self.attendance : attendance // ignore: cast_nullable_to_non_nullable
as AttendanceRecord?,slots: null == slots ? _self.slots : slots // ignore: cast_nullable_to_non_nullable
as List<DaySlot>,rules: null == rules ? _self.rules : rules // ignore: cast_nullable_to_non_nullable
as FieldRules,
  ));
}
/// Create a copy of StaffToday
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TodayAssignmentCopyWith<$Res>? get assignment {
    if (_self.assignment == null) {
    return null;
  }

  return $TodayAssignmentCopyWith<$Res>(_self.assignment!, (value) {
    return _then(_self.copyWith(assignment: value));
  });
}/// Create a copy of StaffToday
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AttendanceRecordCopyWith<$Res>? get attendance {
    if (_self.attendance == null) {
    return null;
  }

  return $AttendanceRecordCopyWith<$Res>(_self.attendance!, (value) {
    return _then(_self.copyWith(attendance: value));
  });
}/// Create a copy of StaffToday
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FieldRulesCopyWith<$Res> get rules {
  
  return $FieldRulesCopyWith<$Res>(_self.rules, (value) {
    return _then(_self.copyWith(rules: value));
  });
}
}


/// Adds pattern-matching-related methods to [StaffToday].
extension StaffTodayPatterns on StaffToday {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StaffToday value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StaffToday() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StaffToday value)  $default,){
final _that = this;
switch (_that) {
case _StaffToday():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StaffToday value)?  $default,){
final _that = this;
switch (_that) {
case _StaffToday() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime serverTime,  String date,  bool isWorkingDay,  String? holiday,  TodayAssignment? assignment,  AttendanceRecord? attendance,  List<DaySlot> slots,  FieldRules rules)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StaffToday() when $default != null:
return $default(_that.serverTime,_that.date,_that.isWorkingDay,_that.holiday,_that.assignment,_that.attendance,_that.slots,_that.rules);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime serverTime,  String date,  bool isWorkingDay,  String? holiday,  TodayAssignment? assignment,  AttendanceRecord? attendance,  List<DaySlot> slots,  FieldRules rules)  $default,) {final _that = this;
switch (_that) {
case _StaffToday():
return $default(_that.serverTime,_that.date,_that.isWorkingDay,_that.holiday,_that.assignment,_that.attendance,_that.slots,_that.rules);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime serverTime,  String date,  bool isWorkingDay,  String? holiday,  TodayAssignment? assignment,  AttendanceRecord? attendance,  List<DaySlot> slots,  FieldRules rules)?  $default,) {final _that = this;
switch (_that) {
case _StaffToday() when $default != null:
return $default(_that.serverTime,_that.date,_that.isWorkingDay,_that.holiday,_that.assignment,_that.attendance,_that.slots,_that.rules);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StaffToday extends StaffToday {
  const _StaffToday({required this.serverTime, required this.date, required this.isWorkingDay, this.holiday, this.assignment, this.attendance, required  List<DaySlot> slots, required this.rules}): _slots = slots,super._();
  factory _StaffToday.fromJson(Map<String, dynamic> json) => _$StaffTodayFromJson(json);

@override final  DateTime serverTime;
@override final  String date;
@override final  bool isWorkingDay;
@override final  String? holiday;
@override final  TodayAssignment? assignment;
@override final  AttendanceRecord? attendance;
 final  List<DaySlot> _slots;
@override List<DaySlot> get slots {
  if (_slots is EqualUnmodifiableListView) return _slots;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_slots);
}

@override final  FieldRules rules;

/// Create a copy of StaffToday
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StaffTodayCopyWith<_StaffToday> get copyWith => __$StaffTodayCopyWithImpl<_StaffToday>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StaffTodayToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _StaffToday&&(identical(other.serverTime, serverTime) || other.serverTime == serverTime)&&(identical(other.date, date) || other.date == date)&&(identical(other.isWorkingDay, isWorkingDay) || other.isWorkingDay == isWorkingDay)&&(identical(other.holiday, holiday) || other.holiday == holiday)&&(identical(other.assignment, assignment) || other.assignment == assignment)&&(identical(other.attendance, attendance) || other.attendance == attendance)&&const DeepCollectionEquality().equals(other.slots, _slots)&&(identical(other.rules, rules) || other.rules == rules));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,serverTime,date,isWorkingDay,holiday,assignment,attendance,const DeepCollectionEquality().hash(_slots),rules);
}

@override
String toString() {
    return 'StaffToday(serverTime: $serverTime, date: $date, isWorkingDay: $isWorkingDay, holiday: $holiday, assignment: $assignment, attendance: $attendance, slots: $slots, rules: $rules)';
}


}

/// @nodoc
abstract mixin class _$StaffTodayCopyWith<$Res> implements $StaffTodayCopyWith<$Res> {
  factory _$StaffTodayCopyWith(_StaffToday value, $Res Function(_StaffToday) _then) = __$StaffTodayCopyWithImpl;
@override @useResult
$Res call({
 DateTime serverTime, String date, bool isWorkingDay, String? holiday, TodayAssignment? assignment, AttendanceRecord? attendance, List<DaySlot> slots, FieldRules rules
});


@override $TodayAssignmentCopyWith<$Res>? get assignment;@override $AttendanceRecordCopyWith<$Res>? get attendance;@override $FieldRulesCopyWith<$Res> get rules;

}
/// @nodoc
class __$StaffTodayCopyWithImpl<$Res>
    implements _$StaffTodayCopyWith<$Res> {
  __$StaffTodayCopyWithImpl(this._self, this._then);

  final _StaffToday _self;
  final $Res Function(_StaffToday) _then;

/// Create a copy of StaffToday
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? serverTime = null,Object? date = null,Object? isWorkingDay = null,Object? holiday = freezed,Object? assignment = freezed,Object? attendance = freezed,Object? slots = null,Object? rules = null,}) {
  return _then(_StaffToday(
serverTime: null == serverTime ? _self.serverTime : serverTime // ignore: cast_nullable_to_non_nullable
as DateTime,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,isWorkingDay: null == isWorkingDay ? _self.isWorkingDay : isWorkingDay // ignore: cast_nullable_to_non_nullable
as bool,holiday: freezed == holiday ? _self.holiday : holiday // ignore: cast_nullable_to_non_nullable
as String?,assignment: freezed == assignment ? _self.assignment : assignment // ignore: cast_nullable_to_non_nullable
as TodayAssignment?,attendance: freezed == attendance ? _self.attendance : attendance // ignore: cast_nullable_to_non_nullable
as AttendanceRecord?,slots: null == slots ? _self._slots : slots // ignore: cast_nullable_to_non_nullable
as List<DaySlot>,rules: null == rules ? _self.rules : rules // ignore: cast_nullable_to_non_nullable
as FieldRules,
  ));
}

/// Create a copy of StaffToday
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TodayAssignmentCopyWith<$Res>? get assignment {
    if (_self.assignment == null) {
    return null;
  }

  return $TodayAssignmentCopyWith<$Res>(_self.assignment!, (value) {
    return _then(_self.copyWith(assignment: value));
  });
}/// Create a copy of StaffToday
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AttendanceRecordCopyWith<$Res>? get attendance {
    if (_self.attendance == null) {
    return null;
  }

  return $AttendanceRecordCopyWith<$Res>(_self.attendance!, (value) {
    return _then(_self.copyWith(attendance: value));
  });
}/// Create a copy of StaffToday
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FieldRulesCopyWith<$Res> get rules {
  
  return $FieldRulesCopyWith<$Res>(_self.rules, (value) {
    return _then(_self.copyWith(rules: value));
  });
}
}

// dart format on
