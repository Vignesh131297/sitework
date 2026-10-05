// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'site_day.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BoardStaff {

 String get id; String get name; String get phone; Designation? get designation;
/// Create a copy of BoardStaff
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BoardStaffCopyWith<BoardStaff> get copyWith => _$BoardStaffCopyWithImpl<BoardStaff>(this as BoardStaff, _$identity);

  /// Serializes this BoardStaff to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as BoardStaff;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BoardStaff&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.phone, _this.phone) || other.phone == _this.phone)&&(identical(other.designation, _this.designation) || other.designation == _this.designation));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as BoardStaff;
  return Object.hash(runtimeType,_this.id,_this.name,_this.phone,_this.designation);
}

@override
String toString() {
  final _this = this as BoardStaff;
  return 'BoardStaff(id: ${_this.id}, name: ${_this.name}, phone: ${_this.phone}, designation: ${_this.designation})';
}


}

/// @nodoc
abstract mixin class $BoardStaffCopyWith<$Res>  {
  factory $BoardStaffCopyWith(BoardStaff value, $Res Function(BoardStaff) _then) = _$BoardStaffCopyWithImpl;
@useResult
$Res call({
 String id, String name, String phone, Designation? designation
});




}
/// @nodoc
class _$BoardStaffCopyWithImpl<$Res>
    implements $BoardStaffCopyWith<$Res> {
  _$BoardStaffCopyWithImpl(this._self, this._then);

  final BoardStaff _self;
  final $Res Function(BoardStaff) _then;

/// Create a copy of BoardStaff
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? phone = null,Object? designation = freezed,}) {
  return _then(BoardStaff(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,designation: freezed == designation ? _self.designation : designation // ignore: cast_nullable_to_non_nullable
as Designation?,
  ));
}

}


/// Adds pattern-matching-related methods to [BoardStaff].
extension BoardStaffPatterns on BoardStaff {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BoardStaff value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BoardStaff() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BoardStaff value)  $default,){
final _that = this;
switch (_that) {
case _BoardStaff():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BoardStaff value)?  $default,){
final _that = this;
switch (_that) {
case _BoardStaff() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String phone,  Designation? designation)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BoardStaff() when $default != null:
return $default(_that.id,_that.name,_that.phone,_that.designation);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String phone,  Designation? designation)  $default,) {final _that = this;
switch (_that) {
case _BoardStaff():
return $default(_that.id,_that.name,_that.phone,_that.designation);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String phone,  Designation? designation)?  $default,) {final _that = this;
switch (_that) {
case _BoardStaff() when $default != null:
return $default(_that.id,_that.name,_that.phone,_that.designation);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BoardStaff implements BoardStaff {
  const _BoardStaff({required this.id, required this.name, required this.phone, this.designation});
  factory _BoardStaff.fromJson(Map<String, dynamic> json) => _$BoardStaffFromJson(json);

@override final  String id;
@override final  String name;
@override final  String phone;
@override final  Designation? designation;

/// Create a copy of BoardStaff
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BoardStaffCopyWith<_BoardStaff> get copyWith => __$BoardStaffCopyWithImpl<_BoardStaff>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BoardStaffToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _BoardStaff&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.designation, designation) || other.designation == designation));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,phone,designation);
}

@override
String toString() {
    return 'BoardStaff(id: $id, name: $name, phone: $phone, designation: $designation)';
}


}

/// @nodoc
abstract mixin class _$BoardStaffCopyWith<$Res> implements $BoardStaffCopyWith<$Res> {
  factory _$BoardStaffCopyWith(_BoardStaff value, $Res Function(_BoardStaff) _then) = __$BoardStaffCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String phone, Designation? designation
});




}
/// @nodoc
class __$BoardStaffCopyWithImpl<$Res>
    implements _$BoardStaffCopyWith<$Res> {
  __$BoardStaffCopyWithImpl(this._self, this._then);

  final _BoardStaff _self;
  final $Res Function(_BoardStaff) _then;

/// Create a copy of BoardStaff
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? phone = null,Object? designation = freezed,}) {
  return _then(_BoardStaff(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,designation: freezed == designation ? _self.designation : designation // ignore: cast_nullable_to_non_nullable
as Designation?,
  ));
}


}


/// @nodoc
mixin _$BoardAttendance {

 AttendanceStatus get status; DateTime? get checkInAt; DateTime? get checkOutAt;
/// Create a copy of BoardAttendance
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BoardAttendanceCopyWith<BoardAttendance> get copyWith => _$BoardAttendanceCopyWithImpl<BoardAttendance>(this as BoardAttendance, _$identity);

  /// Serializes this BoardAttendance to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as BoardAttendance;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BoardAttendance&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.checkInAt, _this.checkInAt) || other.checkInAt == _this.checkInAt)&&(identical(other.checkOutAt, _this.checkOutAt) || other.checkOutAt == _this.checkOutAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as BoardAttendance;
  return Object.hash(runtimeType,_this.status,_this.checkInAt,_this.checkOutAt);
}

@override
String toString() {
  final _this = this as BoardAttendance;
  return 'BoardAttendance(status: ${_this.status}, checkInAt: ${_this.checkInAt}, checkOutAt: ${_this.checkOutAt})';
}


}

/// @nodoc
abstract mixin class $BoardAttendanceCopyWith<$Res>  {
  factory $BoardAttendanceCopyWith(BoardAttendance value, $Res Function(BoardAttendance) _then) = _$BoardAttendanceCopyWithImpl;
@useResult
$Res call({
 AttendanceStatus status, DateTime? checkInAt, DateTime? checkOutAt
});




}
/// @nodoc
class _$BoardAttendanceCopyWithImpl<$Res>
    implements $BoardAttendanceCopyWith<$Res> {
  _$BoardAttendanceCopyWithImpl(this._self, this._then);

  final BoardAttendance _self;
  final $Res Function(BoardAttendance) _then;

/// Create a copy of BoardAttendance
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? checkInAt = freezed,Object? checkOutAt = freezed,}) {
  return _then(BoardAttendance(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AttendanceStatus,checkInAt: freezed == checkInAt ? _self.checkInAt : checkInAt // ignore: cast_nullable_to_non_nullable
as DateTime?,checkOutAt: freezed == checkOutAt ? _self.checkOutAt : checkOutAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [BoardAttendance].
extension BoardAttendancePatterns on BoardAttendance {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BoardAttendance value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BoardAttendance() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BoardAttendance value)  $default,){
final _that = this;
switch (_that) {
case _BoardAttendance():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BoardAttendance value)?  $default,){
final _that = this;
switch (_that) {
case _BoardAttendance() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AttendanceStatus status,  DateTime? checkInAt,  DateTime? checkOutAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BoardAttendance() when $default != null:
return $default(_that.status,_that.checkInAt,_that.checkOutAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AttendanceStatus status,  DateTime? checkInAt,  DateTime? checkOutAt)  $default,) {final _that = this;
switch (_that) {
case _BoardAttendance():
return $default(_that.status,_that.checkInAt,_that.checkOutAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AttendanceStatus status,  DateTime? checkInAt,  DateTime? checkOutAt)?  $default,) {final _that = this;
switch (_that) {
case _BoardAttendance() when $default != null:
return $default(_that.status,_that.checkInAt,_that.checkOutAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BoardAttendance implements BoardAttendance {
  const _BoardAttendance({required this.status, this.checkInAt, this.checkOutAt});
  factory _BoardAttendance.fromJson(Map<String, dynamic> json) => _$BoardAttendanceFromJson(json);

@override final  AttendanceStatus status;
@override final  DateTime? checkInAt;
@override final  DateTime? checkOutAt;

/// Create a copy of BoardAttendance
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BoardAttendanceCopyWith<_BoardAttendance> get copyWith => __$BoardAttendanceCopyWithImpl<_BoardAttendance>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BoardAttendanceToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _BoardAttendance&&(identical(other.status, status) || other.status == status)&&(identical(other.checkInAt, checkInAt) || other.checkInAt == checkInAt)&&(identical(other.checkOutAt, checkOutAt) || other.checkOutAt == checkOutAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,status,checkInAt,checkOutAt);
}

@override
String toString() {
    return 'BoardAttendance(status: $status, checkInAt: $checkInAt, checkOutAt: $checkOutAt)';
}


}

/// @nodoc
abstract mixin class _$BoardAttendanceCopyWith<$Res> implements $BoardAttendanceCopyWith<$Res> {
  factory _$BoardAttendanceCopyWith(_BoardAttendance value, $Res Function(_BoardAttendance) _then) = __$BoardAttendanceCopyWithImpl;
@override @useResult
$Res call({
 AttendanceStatus status, DateTime? checkInAt, DateTime? checkOutAt
});




}
/// @nodoc
class __$BoardAttendanceCopyWithImpl<$Res>
    implements _$BoardAttendanceCopyWith<$Res> {
  __$BoardAttendanceCopyWithImpl(this._self, this._then);

  final _BoardAttendance _self;
  final $Res Function(_BoardAttendance) _then;

/// Create a copy of BoardAttendance
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? checkInAt = freezed,Object? checkOutAt = freezed,}) {
  return _then(_BoardAttendance(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AttendanceStatus,checkInAt: freezed == checkInAt ? _self.checkInAt : checkInAt // ignore: cast_nullable_to_non_nullable
as DateTime?,checkOutAt: freezed == checkOutAt ? _self.checkOutAt : checkOutAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$StaffDay {

 BoardStaff get staff; IdName get site; IdName get engineer; BoardAttendance? get attendance;/// The late threshold has passed without a check-in.
 bool get notCheckedIn; List<DaySlot> get slots;
/// Create a copy of StaffDay
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StaffDayCopyWith<StaffDay> get copyWith => _$StaffDayCopyWithImpl<StaffDay>(this as StaffDay, _$identity);

  /// Serializes this StaffDay to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as StaffDay;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StaffDay&&(identical(other.staff, _this.staff) || other.staff == _this.staff)&&(identical(other.site, _this.site) || other.site == _this.site)&&(identical(other.engineer, _this.engineer) || other.engineer == _this.engineer)&&(identical(other.attendance, _this.attendance) || other.attendance == _this.attendance)&&(identical(other.notCheckedIn, _this.notCheckedIn) || other.notCheckedIn == _this.notCheckedIn)&&const DeepCollectionEquality().equals(other.slots, _this.slots));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as StaffDay;
  return Object.hash(runtimeType,_this.staff,_this.site,_this.engineer,_this.attendance,_this.notCheckedIn,const DeepCollectionEquality().hash(_this.slots));
}

@override
String toString() {
  final _this = this as StaffDay;
  return 'StaffDay(staff: ${_this.staff}, site: ${_this.site}, engineer: ${_this.engineer}, attendance: ${_this.attendance}, notCheckedIn: ${_this.notCheckedIn}, slots: ${_this.slots})';
}


}

/// @nodoc
abstract mixin class $StaffDayCopyWith<$Res>  {
  factory $StaffDayCopyWith(StaffDay value, $Res Function(StaffDay) _then) = _$StaffDayCopyWithImpl;
@useResult
$Res call({
 BoardStaff staff, IdName site, IdName engineer, BoardAttendance? attendance, bool notCheckedIn, List<DaySlot> slots
});


$BoardStaffCopyWith<$Res> get staff;$IdNameCopyWith<$Res> get site;$IdNameCopyWith<$Res> get engineer;$BoardAttendanceCopyWith<$Res>? get attendance;

}
/// @nodoc
class _$StaffDayCopyWithImpl<$Res>
    implements $StaffDayCopyWith<$Res> {
  _$StaffDayCopyWithImpl(this._self, this._then);

  final StaffDay _self;
  final $Res Function(StaffDay) _then;

/// Create a copy of StaffDay
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? staff = null,Object? site = null,Object? engineer = null,Object? attendance = freezed,Object? notCheckedIn = null,Object? slots = null,}) {
  return _then(StaffDay(
staff: null == staff ? _self.staff : staff // ignore: cast_nullable_to_non_nullable
as BoardStaff,site: null == site ? _self.site : site // ignore: cast_nullable_to_non_nullable
as IdName,engineer: null == engineer ? _self.engineer : engineer // ignore: cast_nullable_to_non_nullable
as IdName,attendance: freezed == attendance ? _self.attendance : attendance // ignore: cast_nullable_to_non_nullable
as BoardAttendance?,notCheckedIn: null == notCheckedIn ? _self.notCheckedIn : notCheckedIn // ignore: cast_nullable_to_non_nullable
as bool,slots: null == slots ? _self.slots : slots // ignore: cast_nullable_to_non_nullable
as List<DaySlot>,
  ));
}
/// Create a copy of StaffDay
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BoardStaffCopyWith<$Res> get staff {
  
  return $BoardStaffCopyWith<$Res>(_self.staff, (value) {
    return _then(_self.copyWith(staff: value));
  });
}/// Create a copy of StaffDay
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$IdNameCopyWith<$Res> get site {
  
  return $IdNameCopyWith<$Res>(_self.site, (value) {
    return _then(_self.copyWith(site: value));
  });
}/// Create a copy of StaffDay
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$IdNameCopyWith<$Res> get engineer {
  
  return $IdNameCopyWith<$Res>(_self.engineer, (value) {
    return _then(_self.copyWith(engineer: value));
  });
}/// Create a copy of StaffDay
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BoardAttendanceCopyWith<$Res>? get attendance {
    if (_self.attendance == null) {
    return null;
  }

  return $BoardAttendanceCopyWith<$Res>(_self.attendance!, (value) {
    return _then(_self.copyWith(attendance: value));
  });
}
}


/// Adds pattern-matching-related methods to [StaffDay].
extension StaffDayPatterns on StaffDay {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StaffDay value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StaffDay() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StaffDay value)  $default,){
final _that = this;
switch (_that) {
case _StaffDay():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StaffDay value)?  $default,){
final _that = this;
switch (_that) {
case _StaffDay() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( BoardStaff staff,  IdName site,  IdName engineer,  BoardAttendance? attendance,  bool notCheckedIn,  List<DaySlot> slots)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StaffDay() when $default != null:
return $default(_that.staff,_that.site,_that.engineer,_that.attendance,_that.notCheckedIn,_that.slots);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( BoardStaff staff,  IdName site,  IdName engineer,  BoardAttendance? attendance,  bool notCheckedIn,  List<DaySlot> slots)  $default,) {final _that = this;
switch (_that) {
case _StaffDay():
return $default(_that.staff,_that.site,_that.engineer,_that.attendance,_that.notCheckedIn,_that.slots);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( BoardStaff staff,  IdName site,  IdName engineer,  BoardAttendance? attendance,  bool notCheckedIn,  List<DaySlot> slots)?  $default,) {final _that = this;
switch (_that) {
case _StaffDay() when $default != null:
return $default(_that.staff,_that.site,_that.engineer,_that.attendance,_that.notCheckedIn,_that.slots);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StaffDay implements StaffDay {
  const _StaffDay({required this.staff, required this.site, required this.engineer, this.attendance, required this.notCheckedIn, required  List<DaySlot> slots}): _slots = slots;
  factory _StaffDay.fromJson(Map<String, dynamic> json) => _$StaffDayFromJson(json);

@override final  BoardStaff staff;
@override final  IdName site;
@override final  IdName engineer;
@override final  BoardAttendance? attendance;
/// The late threshold has passed without a check-in.
@override final  bool notCheckedIn;
 final  List<DaySlot> _slots;
@override List<DaySlot> get slots {
  if (_slots is EqualUnmodifiableListView) return _slots;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_slots);
}


/// Create a copy of StaffDay
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StaffDayCopyWith<_StaffDay> get copyWith => __$StaffDayCopyWithImpl<_StaffDay>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StaffDayToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _StaffDay&&(identical(other.staff, staff) || other.staff == staff)&&(identical(other.site, site) || other.site == site)&&(identical(other.engineer, engineer) || other.engineer == engineer)&&(identical(other.attendance, attendance) || other.attendance == attendance)&&(identical(other.notCheckedIn, notCheckedIn) || other.notCheckedIn == notCheckedIn)&&const DeepCollectionEquality().equals(other.slots, _slots));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,staff,site,engineer,attendance,notCheckedIn,const DeepCollectionEquality().hash(_slots));
}

@override
String toString() {
    return 'StaffDay(staff: $staff, site: $site, engineer: $engineer, attendance: $attendance, notCheckedIn: $notCheckedIn, slots: $slots)';
}


}

/// @nodoc
abstract mixin class _$StaffDayCopyWith<$Res> implements $StaffDayCopyWith<$Res> {
  factory _$StaffDayCopyWith(_StaffDay value, $Res Function(_StaffDay) _then) = __$StaffDayCopyWithImpl;
@override @useResult
$Res call({
 BoardStaff staff, IdName site, IdName engineer, BoardAttendance? attendance, bool notCheckedIn, List<DaySlot> slots
});


@override $BoardStaffCopyWith<$Res> get staff;@override $IdNameCopyWith<$Res> get site;@override $IdNameCopyWith<$Res> get engineer;@override $BoardAttendanceCopyWith<$Res>? get attendance;

}
/// @nodoc
class __$StaffDayCopyWithImpl<$Res>
    implements _$StaffDayCopyWith<$Res> {
  __$StaffDayCopyWithImpl(this._self, this._then);

  final _StaffDay _self;
  final $Res Function(_StaffDay) _then;

/// Create a copy of StaffDay
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? staff = null,Object? site = null,Object? engineer = null,Object? attendance = freezed,Object? notCheckedIn = null,Object? slots = null,}) {
  return _then(_StaffDay(
staff: null == staff ? _self.staff : staff // ignore: cast_nullable_to_non_nullable
as BoardStaff,site: null == site ? _self.site : site // ignore: cast_nullable_to_non_nullable
as IdName,engineer: null == engineer ? _self.engineer : engineer // ignore: cast_nullable_to_non_nullable
as IdName,attendance: freezed == attendance ? _self.attendance : attendance // ignore: cast_nullable_to_non_nullable
as BoardAttendance?,notCheckedIn: null == notCheckedIn ? _self.notCheckedIn : notCheckedIn // ignore: cast_nullable_to_non_nullable
as bool,slots: null == slots ? _self._slots : slots // ignore: cast_nullable_to_non_nullable
as List<DaySlot>,
  ));
}

/// Create a copy of StaffDay
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BoardStaffCopyWith<$Res> get staff {
  
  return $BoardStaffCopyWith<$Res>(_self.staff, (value) {
    return _then(_self.copyWith(staff: value));
  });
}/// Create a copy of StaffDay
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$IdNameCopyWith<$Res> get site {
  
  return $IdNameCopyWith<$Res>(_self.site, (value) {
    return _then(_self.copyWith(site: value));
  });
}/// Create a copy of StaffDay
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$IdNameCopyWith<$Res> get engineer {
  
  return $IdNameCopyWith<$Res>(_self.engineer, (value) {
    return _then(_self.copyWith(engineer: value));
  });
}/// Create a copy of StaffDay
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BoardAttendanceCopyWith<$Res>? get attendance {
    if (_self.attendance == null) {
    return null;
  }

  return $BoardAttendanceCopyWith<$Res>(_self.attendance!, (value) {
    return _then(_self.copyWith(attendance: value));
  });
}
}


/// @nodoc
mixin _$SiteDay {

 String get date; bool get isWorkingDay; String? get holiday; List<StaffDay> get staff;
/// Create a copy of SiteDay
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SiteDayCopyWith<SiteDay> get copyWith => _$SiteDayCopyWithImpl<SiteDay>(this as SiteDay, _$identity);

  /// Serializes this SiteDay to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as SiteDay;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SiteDay&&(identical(other.date, _this.date) || other.date == _this.date)&&(identical(other.isWorkingDay, _this.isWorkingDay) || other.isWorkingDay == _this.isWorkingDay)&&(identical(other.holiday, _this.holiday) || other.holiday == _this.holiday)&&const DeepCollectionEquality().equals(other.staff, _this.staff));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as SiteDay;
  return Object.hash(runtimeType,_this.date,_this.isWorkingDay,_this.holiday,const DeepCollectionEquality().hash(_this.staff));
}

@override
String toString() {
  final _this = this as SiteDay;
  return 'SiteDay(date: ${_this.date}, isWorkingDay: ${_this.isWorkingDay}, holiday: ${_this.holiday}, staff: ${_this.staff})';
}


}

/// @nodoc
abstract mixin class $SiteDayCopyWith<$Res>  {
  factory $SiteDayCopyWith(SiteDay value, $Res Function(SiteDay) _then) = _$SiteDayCopyWithImpl;
@useResult
$Res call({
 String date, bool isWorkingDay, String? holiday, List<StaffDay> staff
});




}
/// @nodoc
class _$SiteDayCopyWithImpl<$Res>
    implements $SiteDayCopyWith<$Res> {
  _$SiteDayCopyWithImpl(this._self, this._then);

  final SiteDay _self;
  final $Res Function(SiteDay) _then;

/// Create a copy of SiteDay
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? date = null,Object? isWorkingDay = null,Object? holiday = freezed,Object? staff = null,}) {
  return _then(SiteDay(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,isWorkingDay: null == isWorkingDay ? _self.isWorkingDay : isWorkingDay // ignore: cast_nullable_to_non_nullable
as bool,holiday: freezed == holiday ? _self.holiday : holiday // ignore: cast_nullable_to_non_nullable
as String?,staff: null == staff ? _self.staff : staff // ignore: cast_nullable_to_non_nullable
as List<StaffDay>,
  ));
}

}


/// Adds pattern-matching-related methods to [SiteDay].
extension SiteDayPatterns on SiteDay {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SiteDay value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SiteDay() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SiteDay value)  $default,){
final _that = this;
switch (_that) {
case _SiteDay():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SiteDay value)?  $default,){
final _that = this;
switch (_that) {
case _SiteDay() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String date,  bool isWorkingDay,  String? holiday,  List<StaffDay> staff)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SiteDay() when $default != null:
return $default(_that.date,_that.isWorkingDay,_that.holiday,_that.staff);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String date,  bool isWorkingDay,  String? holiday,  List<StaffDay> staff)  $default,) {final _that = this;
switch (_that) {
case _SiteDay():
return $default(_that.date,_that.isWorkingDay,_that.holiday,_that.staff);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String date,  bool isWorkingDay,  String? holiday,  List<StaffDay> staff)?  $default,) {final _that = this;
switch (_that) {
case _SiteDay() when $default != null:
return $default(_that.date,_that.isWorkingDay,_that.holiday,_that.staff);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SiteDay implements SiteDay {
  const _SiteDay({required this.date, required this.isWorkingDay, this.holiday, required  List<StaffDay> staff}): _staff = staff;
  factory _SiteDay.fromJson(Map<String, dynamic> json) => _$SiteDayFromJson(json);

@override final  String date;
@override final  bool isWorkingDay;
@override final  String? holiday;
 final  List<StaffDay> _staff;
@override List<StaffDay> get staff {
  if (_staff is EqualUnmodifiableListView) return _staff;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_staff);
}


/// Create a copy of SiteDay
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SiteDayCopyWith<_SiteDay> get copyWith => __$SiteDayCopyWithImpl<_SiteDay>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SiteDayToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SiteDay&&(identical(other.date, date) || other.date == date)&&(identical(other.isWorkingDay, isWorkingDay) || other.isWorkingDay == isWorkingDay)&&(identical(other.holiday, holiday) || other.holiday == holiday)&&const DeepCollectionEquality().equals(other.staff, _staff));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,date,isWorkingDay,holiday,const DeepCollectionEquality().hash(_staff));
}

@override
String toString() {
    return 'SiteDay(date: $date, isWorkingDay: $isWorkingDay, holiday: $holiday, staff: $staff)';
}


}

/// @nodoc
abstract mixin class _$SiteDayCopyWith<$Res> implements $SiteDayCopyWith<$Res> {
  factory _$SiteDayCopyWith(_SiteDay value, $Res Function(_SiteDay) _then) = __$SiteDayCopyWithImpl;
@override @useResult
$Res call({
 String date, bool isWorkingDay, String? holiday, List<StaffDay> staff
});




}
/// @nodoc
class __$SiteDayCopyWithImpl<$Res>
    implements _$SiteDayCopyWith<$Res> {
  __$SiteDayCopyWithImpl(this._self, this._then);

  final _SiteDay _self;
  final $Res Function(_SiteDay) _then;

/// Create a copy of SiteDay
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? date = null,Object? isWorkingDay = null,Object? holiday = freezed,Object? staff = null,}) {
  return _then(_SiteDay(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,isWorkingDay: null == isWorkingDay ? _self.isWorkingDay : isWorkingDay // ignore: cast_nullable_to_non_nullable
as bool,holiday: freezed == holiday ? _self.holiday : holiday // ignore: cast_nullable_to_non_nullable
as String?,staff: null == staff ? _self._staff : staff // ignore: cast_nullable_to_non_nullable
as List<StaffDay>,
  ));
}


}

// dart format on
