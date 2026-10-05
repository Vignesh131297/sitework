// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'attendance_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AttendanceRecord {

 String get id; String get workDate; AttendanceStatus get status; IdName get staff; IdName get site; DateTime? get checkInAt; LocationFlag? get checkInLocationFlag; DateTime? get checkOutAt; LocationFlag? get checkOutLocationFlag; int? get workedMinutes; String? get correctionNote;
/// Create a copy of AttendanceRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AttendanceRecordCopyWith<AttendanceRecord> get copyWith => _$AttendanceRecordCopyWithImpl<AttendanceRecord>(this as AttendanceRecord, _$identity);

  /// Serializes this AttendanceRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AttendanceRecord;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AttendanceRecord&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.workDate, _this.workDate) || other.workDate == _this.workDate)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.staff, _this.staff) || other.staff == _this.staff)&&(identical(other.site, _this.site) || other.site == _this.site)&&(identical(other.checkInAt, _this.checkInAt) || other.checkInAt == _this.checkInAt)&&(identical(other.checkInLocationFlag, _this.checkInLocationFlag) || other.checkInLocationFlag == _this.checkInLocationFlag)&&(identical(other.checkOutAt, _this.checkOutAt) || other.checkOutAt == _this.checkOutAt)&&(identical(other.checkOutLocationFlag, _this.checkOutLocationFlag) || other.checkOutLocationFlag == _this.checkOutLocationFlag)&&(identical(other.workedMinutes, _this.workedMinutes) || other.workedMinutes == _this.workedMinutes)&&(identical(other.correctionNote, _this.correctionNote) || other.correctionNote == _this.correctionNote));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AttendanceRecord;
  return Object.hash(runtimeType,_this.id,_this.workDate,_this.status,_this.staff,_this.site,_this.checkInAt,_this.checkInLocationFlag,_this.checkOutAt,_this.checkOutLocationFlag,_this.workedMinutes,_this.correctionNote);
}

@override
String toString() {
  final _this = this as AttendanceRecord;
  return 'AttendanceRecord(id: ${_this.id}, workDate: ${_this.workDate}, status: ${_this.status}, staff: ${_this.staff}, site: ${_this.site}, checkInAt: ${_this.checkInAt}, checkInLocationFlag: ${_this.checkInLocationFlag}, checkOutAt: ${_this.checkOutAt}, checkOutLocationFlag: ${_this.checkOutLocationFlag}, workedMinutes: ${_this.workedMinutes}, correctionNote: ${_this.correctionNote})';
}


}

/// @nodoc
abstract mixin class $AttendanceRecordCopyWith<$Res>  {
  factory $AttendanceRecordCopyWith(AttendanceRecord value, $Res Function(AttendanceRecord) _then) = _$AttendanceRecordCopyWithImpl;
@useResult
$Res call({
 String id, String workDate, AttendanceStatus status, IdName staff, IdName site, DateTime? checkInAt, LocationFlag? checkInLocationFlag, DateTime? checkOutAt, LocationFlag? checkOutLocationFlag, int? workedMinutes, String? correctionNote
});


$IdNameCopyWith<$Res> get staff;$IdNameCopyWith<$Res> get site;

}
/// @nodoc
class _$AttendanceRecordCopyWithImpl<$Res>
    implements $AttendanceRecordCopyWith<$Res> {
  _$AttendanceRecordCopyWithImpl(this._self, this._then);

  final AttendanceRecord _self;
  final $Res Function(AttendanceRecord) _then;

/// Create a copy of AttendanceRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? workDate = null,Object? status = null,Object? staff = null,Object? site = null,Object? checkInAt = freezed,Object? checkInLocationFlag = freezed,Object? checkOutAt = freezed,Object? checkOutLocationFlag = freezed,Object? workedMinutes = freezed,Object? correctionNote = freezed,}) {
  return _then(AttendanceRecord(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,workDate: null == workDate ? _self.workDate : workDate // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AttendanceStatus,staff: null == staff ? _self.staff : staff // ignore: cast_nullable_to_non_nullable
as IdName,site: null == site ? _self.site : site // ignore: cast_nullable_to_non_nullable
as IdName,checkInAt: freezed == checkInAt ? _self.checkInAt : checkInAt // ignore: cast_nullable_to_non_nullable
as DateTime?,checkInLocationFlag: freezed == checkInLocationFlag ? _self.checkInLocationFlag : checkInLocationFlag // ignore: cast_nullable_to_non_nullable
as LocationFlag?,checkOutAt: freezed == checkOutAt ? _self.checkOutAt : checkOutAt // ignore: cast_nullable_to_non_nullable
as DateTime?,checkOutLocationFlag: freezed == checkOutLocationFlag ? _self.checkOutLocationFlag : checkOutLocationFlag // ignore: cast_nullable_to_non_nullable
as LocationFlag?,workedMinutes: freezed == workedMinutes ? _self.workedMinutes : workedMinutes // ignore: cast_nullable_to_non_nullable
as int?,correctionNote: freezed == correctionNote ? _self.correctionNote : correctionNote // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of AttendanceRecord
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$IdNameCopyWith<$Res> get staff {
  
  return $IdNameCopyWith<$Res>(_self.staff, (value) {
    return _then(_self.copyWith(staff: value));
  });
}/// Create a copy of AttendanceRecord
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$IdNameCopyWith<$Res> get site {
  
  return $IdNameCopyWith<$Res>(_self.site, (value) {
    return _then(_self.copyWith(site: value));
  });
}
}


/// Adds pattern-matching-related methods to [AttendanceRecord].
extension AttendanceRecordPatterns on AttendanceRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AttendanceRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AttendanceRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AttendanceRecord value)  $default,){
final _that = this;
switch (_that) {
case _AttendanceRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AttendanceRecord value)?  $default,){
final _that = this;
switch (_that) {
case _AttendanceRecord() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String workDate,  AttendanceStatus status,  IdName staff,  IdName site,  DateTime? checkInAt,  LocationFlag? checkInLocationFlag,  DateTime? checkOutAt,  LocationFlag? checkOutLocationFlag,  int? workedMinutes,  String? correctionNote)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AttendanceRecord() when $default != null:
return $default(_that.id,_that.workDate,_that.status,_that.staff,_that.site,_that.checkInAt,_that.checkInLocationFlag,_that.checkOutAt,_that.checkOutLocationFlag,_that.workedMinutes,_that.correctionNote);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String workDate,  AttendanceStatus status,  IdName staff,  IdName site,  DateTime? checkInAt,  LocationFlag? checkInLocationFlag,  DateTime? checkOutAt,  LocationFlag? checkOutLocationFlag,  int? workedMinutes,  String? correctionNote)  $default,) {final _that = this;
switch (_that) {
case _AttendanceRecord():
return $default(_that.id,_that.workDate,_that.status,_that.staff,_that.site,_that.checkInAt,_that.checkInLocationFlag,_that.checkOutAt,_that.checkOutLocationFlag,_that.workedMinutes,_that.correctionNote);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String workDate,  AttendanceStatus status,  IdName staff,  IdName site,  DateTime? checkInAt,  LocationFlag? checkInLocationFlag,  DateTime? checkOutAt,  LocationFlag? checkOutLocationFlag,  int? workedMinutes,  String? correctionNote)?  $default,) {final _that = this;
switch (_that) {
case _AttendanceRecord() when $default != null:
return $default(_that.id,_that.workDate,_that.status,_that.staff,_that.site,_that.checkInAt,_that.checkInLocationFlag,_that.checkOutAt,_that.checkOutLocationFlag,_that.workedMinutes,_that.correctionNote);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AttendanceRecord implements AttendanceRecord {
  const _AttendanceRecord({required this.id, required this.workDate, required this.status, required this.staff, required this.site, this.checkInAt, this.checkInLocationFlag, this.checkOutAt, this.checkOutLocationFlag, this.workedMinutes, this.correctionNote});
  factory _AttendanceRecord.fromJson(Map<String, dynamic> json) => _$AttendanceRecordFromJson(json);

@override final  String id;
@override final  String workDate;
@override final  AttendanceStatus status;
@override final  IdName staff;
@override final  IdName site;
@override final  DateTime? checkInAt;
@override final  LocationFlag? checkInLocationFlag;
@override final  DateTime? checkOutAt;
@override final  LocationFlag? checkOutLocationFlag;
@override final  int? workedMinutes;
@override final  String? correctionNote;

/// Create a copy of AttendanceRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AttendanceRecordCopyWith<_AttendanceRecord> get copyWith => __$AttendanceRecordCopyWithImpl<_AttendanceRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AttendanceRecordToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AttendanceRecord&&(identical(other.id, id) || other.id == id)&&(identical(other.workDate, workDate) || other.workDate == workDate)&&(identical(other.status, status) || other.status == status)&&(identical(other.staff, staff) || other.staff == staff)&&(identical(other.site, site) || other.site == site)&&(identical(other.checkInAt, checkInAt) || other.checkInAt == checkInAt)&&(identical(other.checkInLocationFlag, checkInLocationFlag) || other.checkInLocationFlag == checkInLocationFlag)&&(identical(other.checkOutAt, checkOutAt) || other.checkOutAt == checkOutAt)&&(identical(other.checkOutLocationFlag, checkOutLocationFlag) || other.checkOutLocationFlag == checkOutLocationFlag)&&(identical(other.workedMinutes, workedMinutes) || other.workedMinutes == workedMinutes)&&(identical(other.correctionNote, correctionNote) || other.correctionNote == correctionNote));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,workDate,status,staff,site,checkInAt,checkInLocationFlag,checkOutAt,checkOutLocationFlag,workedMinutes,correctionNote);
}

@override
String toString() {
    return 'AttendanceRecord(id: $id, workDate: $workDate, status: $status, staff: $staff, site: $site, checkInAt: $checkInAt, checkInLocationFlag: $checkInLocationFlag, checkOutAt: $checkOutAt, checkOutLocationFlag: $checkOutLocationFlag, workedMinutes: $workedMinutes, correctionNote: $correctionNote)';
}


}

/// @nodoc
abstract mixin class _$AttendanceRecordCopyWith<$Res> implements $AttendanceRecordCopyWith<$Res> {
  factory _$AttendanceRecordCopyWith(_AttendanceRecord value, $Res Function(_AttendanceRecord) _then) = __$AttendanceRecordCopyWithImpl;
@override @useResult
$Res call({
 String id, String workDate, AttendanceStatus status, IdName staff, IdName site, DateTime? checkInAt, LocationFlag? checkInLocationFlag, DateTime? checkOutAt, LocationFlag? checkOutLocationFlag, int? workedMinutes, String? correctionNote
});


@override $IdNameCopyWith<$Res> get staff;@override $IdNameCopyWith<$Res> get site;

}
/// @nodoc
class __$AttendanceRecordCopyWithImpl<$Res>
    implements _$AttendanceRecordCopyWith<$Res> {
  __$AttendanceRecordCopyWithImpl(this._self, this._then);

  final _AttendanceRecord _self;
  final $Res Function(_AttendanceRecord) _then;

/// Create a copy of AttendanceRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? workDate = null,Object? status = null,Object? staff = null,Object? site = null,Object? checkInAt = freezed,Object? checkInLocationFlag = freezed,Object? checkOutAt = freezed,Object? checkOutLocationFlag = freezed,Object? workedMinutes = freezed,Object? correctionNote = freezed,}) {
  return _then(_AttendanceRecord(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,workDate: null == workDate ? _self.workDate : workDate // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AttendanceStatus,staff: null == staff ? _self.staff : staff // ignore: cast_nullable_to_non_nullable
as IdName,site: null == site ? _self.site : site // ignore: cast_nullable_to_non_nullable
as IdName,checkInAt: freezed == checkInAt ? _self.checkInAt : checkInAt // ignore: cast_nullable_to_non_nullable
as DateTime?,checkInLocationFlag: freezed == checkInLocationFlag ? _self.checkInLocationFlag : checkInLocationFlag // ignore: cast_nullable_to_non_nullable
as LocationFlag?,checkOutAt: freezed == checkOutAt ? _self.checkOutAt : checkOutAt // ignore: cast_nullable_to_non_nullable
as DateTime?,checkOutLocationFlag: freezed == checkOutLocationFlag ? _self.checkOutLocationFlag : checkOutLocationFlag // ignore: cast_nullable_to_non_nullable
as LocationFlag?,workedMinutes: freezed == workedMinutes ? _self.workedMinutes : workedMinutes // ignore: cast_nullable_to_non_nullable
as int?,correctionNote: freezed == correctionNote ? _self.correctionNote : correctionNote // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of AttendanceRecord
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$IdNameCopyWith<$Res> get staff {
  
  return $IdNameCopyWith<$Res>(_self.staff, (value) {
    return _then(_self.copyWith(staff: value));
  });
}/// Create a copy of AttendanceRecord
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$IdNameCopyWith<$Res> get site {
  
  return $IdNameCopyWith<$Res>(_self.site, (value) {
    return _then(_self.copyWith(site: value));
  });
}
}

// dart format on
