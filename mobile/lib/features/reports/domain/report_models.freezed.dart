// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'report_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UpdateCounts {

 int get submitted; int get missed; int get offline; int get locationFlagged;/// Submitted of (submitted + missed); null when nothing was due.
 int? get compliancePercent;
/// Create a copy of UpdateCounts
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateCountsCopyWith<UpdateCounts> get copyWith => _$UpdateCountsCopyWithImpl<UpdateCounts>(this as UpdateCounts, _$identity);

  /// Serializes this UpdateCounts to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as UpdateCounts;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateCounts&&(identical(other.submitted, _this.submitted) || other.submitted == _this.submitted)&&(identical(other.missed, _this.missed) || other.missed == _this.missed)&&(identical(other.offline, _this.offline) || other.offline == _this.offline)&&(identical(other.locationFlagged, _this.locationFlagged) || other.locationFlagged == _this.locationFlagged)&&(identical(other.compliancePercent, _this.compliancePercent) || other.compliancePercent == _this.compliancePercent));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as UpdateCounts;
  return Object.hash(runtimeType,_this.submitted,_this.missed,_this.offline,_this.locationFlagged,_this.compliancePercent);
}

@override
String toString() {
  final _this = this as UpdateCounts;
  return 'UpdateCounts(submitted: ${_this.submitted}, missed: ${_this.missed}, offline: ${_this.offline}, locationFlagged: ${_this.locationFlagged}, compliancePercent: ${_this.compliancePercent})';
}


}

/// @nodoc
abstract mixin class $UpdateCountsCopyWith<$Res>  {
  factory $UpdateCountsCopyWith(UpdateCounts value, $Res Function(UpdateCounts) _then) = _$UpdateCountsCopyWithImpl;
@useResult
$Res call({
 int submitted, int missed, int offline, int locationFlagged, int? compliancePercent
});




}
/// @nodoc
class _$UpdateCountsCopyWithImpl<$Res>
    implements $UpdateCountsCopyWith<$Res> {
  _$UpdateCountsCopyWithImpl(this._self, this._then);

  final UpdateCounts _self;
  final $Res Function(UpdateCounts) _then;

/// Create a copy of UpdateCounts
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? submitted = null,Object? missed = null,Object? offline = null,Object? locationFlagged = null,Object? compliancePercent = freezed,}) {
  return _then(UpdateCounts(
submitted: null == submitted ? _self.submitted : submitted // ignore: cast_nullable_to_non_nullable
as int,missed: null == missed ? _self.missed : missed // ignore: cast_nullable_to_non_nullable
as int,offline: null == offline ? _self.offline : offline // ignore: cast_nullable_to_non_nullable
as int,locationFlagged: null == locationFlagged ? _self.locationFlagged : locationFlagged // ignore: cast_nullable_to_non_nullable
as int,compliancePercent: freezed == compliancePercent ? _self.compliancePercent : compliancePercent // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [UpdateCounts].
extension UpdateCountsPatterns on UpdateCounts {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UpdateCounts value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UpdateCounts() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UpdateCounts value)  $default,){
final _that = this;
switch (_that) {
case _UpdateCounts():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UpdateCounts value)?  $default,){
final _that = this;
switch (_that) {
case _UpdateCounts() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int submitted,  int missed,  int offline,  int locationFlagged,  int? compliancePercent)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UpdateCounts() when $default != null:
return $default(_that.submitted,_that.missed,_that.offline,_that.locationFlagged,_that.compliancePercent);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int submitted,  int missed,  int offline,  int locationFlagged,  int? compliancePercent)  $default,) {final _that = this;
switch (_that) {
case _UpdateCounts():
return $default(_that.submitted,_that.missed,_that.offline,_that.locationFlagged,_that.compliancePercent);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int submitted,  int missed,  int offline,  int locationFlagged,  int? compliancePercent)?  $default,) {final _that = this;
switch (_that) {
case _UpdateCounts() when $default != null:
return $default(_that.submitted,_that.missed,_that.offline,_that.locationFlagged,_that.compliancePercent);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UpdateCounts implements UpdateCounts {
  const _UpdateCounts({required this.submitted, required this.missed, required this.offline, required this.locationFlagged, this.compliancePercent});
  factory _UpdateCounts.fromJson(Map<String, dynamic> json) => _$UpdateCountsFromJson(json);

@override final  int submitted;
@override final  int missed;
@override final  int offline;
@override final  int locationFlagged;
/// Submitted of (submitted + missed); null when nothing was due.
@override final  int? compliancePercent;

/// Create a copy of UpdateCounts
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateCountsCopyWith<_UpdateCounts> get copyWith => __$UpdateCountsCopyWithImpl<_UpdateCounts>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UpdateCountsToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateCounts&&(identical(other.submitted, submitted) || other.submitted == submitted)&&(identical(other.missed, missed) || other.missed == missed)&&(identical(other.offline, offline) || other.offline == offline)&&(identical(other.locationFlagged, locationFlagged) || other.locationFlagged == locationFlagged)&&(identical(other.compliancePercent, compliancePercent) || other.compliancePercent == compliancePercent));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,submitted,missed,offline,locationFlagged,compliancePercent);
}

@override
String toString() {
    return 'UpdateCounts(submitted: $submitted, missed: $missed, offline: $offline, locationFlagged: $locationFlagged, compliancePercent: $compliancePercent)';
}


}

/// @nodoc
abstract mixin class _$UpdateCountsCopyWith<$Res> implements $UpdateCountsCopyWith<$Res> {
  factory _$UpdateCountsCopyWith(_UpdateCounts value, $Res Function(_UpdateCounts) _then) = __$UpdateCountsCopyWithImpl;
@override @useResult
$Res call({
 int submitted, int missed, int offline, int locationFlagged, int? compliancePercent
});




}
/// @nodoc
class __$UpdateCountsCopyWithImpl<$Res>
    implements _$UpdateCountsCopyWith<$Res> {
  __$UpdateCountsCopyWithImpl(this._self, this._then);

  final _UpdateCounts _self;
  final $Res Function(_UpdateCounts) _then;

/// Create a copy of UpdateCounts
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? submitted = null,Object? missed = null,Object? offline = null,Object? locationFlagged = null,Object? compliancePercent = freezed,}) {
  return _then(_UpdateCounts(
submitted: null == submitted ? _self.submitted : submitted // ignore: cast_nullable_to_non_nullable
as int,missed: null == missed ? _self.missed : missed // ignore: cast_nullable_to_non_nullable
as int,offline: null == offline ? _self.offline : offline // ignore: cast_nullable_to_non_nullable
as int,locationFlagged: null == locationFlagged ? _self.locationFlagged : locationFlagged // ignore: cast_nullable_to_non_nullable
as int,compliancePercent: freezed == compliancePercent ? _self.compliancePercent : compliancePercent // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$AttendanceCounts {

 int get present; int get late; int get halfDay; int get absent;
/// Create a copy of AttendanceCounts
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AttendanceCountsCopyWith<AttendanceCounts> get copyWith => _$AttendanceCountsCopyWithImpl<AttendanceCounts>(this as AttendanceCounts, _$identity);

  /// Serializes this AttendanceCounts to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AttendanceCounts;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AttendanceCounts&&(identical(other.present, _this.present) || other.present == _this.present)&&(identical(other.late, _this.late) || other.late == _this.late)&&(identical(other.halfDay, _this.halfDay) || other.halfDay == _this.halfDay)&&(identical(other.absent, _this.absent) || other.absent == _this.absent));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AttendanceCounts;
  return Object.hash(runtimeType,_this.present,_this.late,_this.halfDay,_this.absent);
}

@override
String toString() {
  final _this = this as AttendanceCounts;
  return 'AttendanceCounts(present: ${_this.present}, late: ${_this.late}, halfDay: ${_this.halfDay}, absent: ${_this.absent})';
}


}

/// @nodoc
abstract mixin class $AttendanceCountsCopyWith<$Res>  {
  factory $AttendanceCountsCopyWith(AttendanceCounts value, $Res Function(AttendanceCounts) _then) = _$AttendanceCountsCopyWithImpl;
@useResult
$Res call({
 int present, int late, int halfDay, int absent
});




}
/// @nodoc
class _$AttendanceCountsCopyWithImpl<$Res>
    implements $AttendanceCountsCopyWith<$Res> {
  _$AttendanceCountsCopyWithImpl(this._self, this._then);

  final AttendanceCounts _self;
  final $Res Function(AttendanceCounts) _then;

/// Create a copy of AttendanceCounts
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? present = null,Object? late = null,Object? halfDay = null,Object? absent = null,}) {
  return _then(AttendanceCounts(
present: null == present ? _self.present : present // ignore: cast_nullable_to_non_nullable
as int,late: null == late ? _self.late : late // ignore: cast_nullable_to_non_nullable
as int,halfDay: null == halfDay ? _self.halfDay : halfDay // ignore: cast_nullable_to_non_nullable
as int,absent: null == absent ? _self.absent : absent // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [AttendanceCounts].
extension AttendanceCountsPatterns on AttendanceCounts {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AttendanceCounts value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AttendanceCounts() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AttendanceCounts value)  $default,){
final _that = this;
switch (_that) {
case _AttendanceCounts():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AttendanceCounts value)?  $default,){
final _that = this;
switch (_that) {
case _AttendanceCounts() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int present,  int late,  int halfDay,  int absent)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AttendanceCounts() when $default != null:
return $default(_that.present,_that.late,_that.halfDay,_that.absent);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int present,  int late,  int halfDay,  int absent)  $default,) {final _that = this;
switch (_that) {
case _AttendanceCounts():
return $default(_that.present,_that.late,_that.halfDay,_that.absent);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int present,  int late,  int halfDay,  int absent)?  $default,) {final _that = this;
switch (_that) {
case _AttendanceCounts() when $default != null:
return $default(_that.present,_that.late,_that.halfDay,_that.absent);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AttendanceCounts implements AttendanceCounts {
  const _AttendanceCounts({required this.present, required this.late, required this.halfDay, required this.absent});
  factory _AttendanceCounts.fromJson(Map<String, dynamic> json) => _$AttendanceCountsFromJson(json);

@override final  int present;
@override final  int late;
@override final  int halfDay;
@override final  int absent;

/// Create a copy of AttendanceCounts
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AttendanceCountsCopyWith<_AttendanceCounts> get copyWith => __$AttendanceCountsCopyWithImpl<_AttendanceCounts>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AttendanceCountsToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AttendanceCounts&&(identical(other.present, present) || other.present == present)&&(identical(other.late, late) || other.late == late)&&(identical(other.halfDay, halfDay) || other.halfDay == halfDay)&&(identical(other.absent, absent) || other.absent == absent));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,present,late,halfDay,absent);
}

@override
String toString() {
    return 'AttendanceCounts(present: $present, late: $late, halfDay: $halfDay, absent: $absent)';
}


}

/// @nodoc
abstract mixin class _$AttendanceCountsCopyWith<$Res> implements $AttendanceCountsCopyWith<$Res> {
  factory _$AttendanceCountsCopyWith(_AttendanceCounts value, $Res Function(_AttendanceCounts) _then) = __$AttendanceCountsCopyWithImpl;
@override @useResult
$Res call({
 int present, int late, int halfDay, int absent
});




}
/// @nodoc
class __$AttendanceCountsCopyWithImpl<$Res>
    implements _$AttendanceCountsCopyWith<$Res> {
  __$AttendanceCountsCopyWithImpl(this._self, this._then);

  final _AttendanceCounts _self;
  final $Res Function(_AttendanceCounts) _then;

/// Create a copy of AttendanceCounts
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? present = null,Object? late = null,Object? halfDay = null,Object? absent = null,}) {
  return _then(_AttendanceCounts(
present: null == present ? _self.present : present // ignore: cast_nullable_to_non_nullable
as int,late: null == late ? _self.late : late // ignore: cast_nullable_to_non_nullable
as int,halfDay: null == halfDay ? _self.halfDay : halfDay // ignore: cast_nullable_to_non_nullable
as int,absent: null == absent ? _self.absent : absent // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$ReportSite {

 String get id; String get code; String get name; SiteStatus? get status;
/// Create a copy of ReportSite
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReportSiteCopyWith<ReportSite> get copyWith => _$ReportSiteCopyWithImpl<ReportSite>(this as ReportSite, _$identity);

  /// Serializes this ReportSite to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ReportSite;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReportSite&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.code, _this.code) || other.code == _this.code)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.status, _this.status) || other.status == _this.status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ReportSite;
  return Object.hash(runtimeType,_this.id,_this.code,_this.name,_this.status);
}

@override
String toString() {
  final _this = this as ReportSite;
  return 'ReportSite(id: ${_this.id}, code: ${_this.code}, name: ${_this.name}, status: ${_this.status})';
}


}

/// @nodoc
abstract mixin class $ReportSiteCopyWith<$Res>  {
  factory $ReportSiteCopyWith(ReportSite value, $Res Function(ReportSite) _then) = _$ReportSiteCopyWithImpl;
@useResult
$Res call({
 String id, String code, String name, SiteStatus? status
});




}
/// @nodoc
class _$ReportSiteCopyWithImpl<$Res>
    implements $ReportSiteCopyWith<$Res> {
  _$ReportSiteCopyWithImpl(this._self, this._then);

  final ReportSite _self;
  final $Res Function(ReportSite) _then;

/// Create a copy of ReportSite
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? code = null,Object? name = null,Object? status = freezed,}) {
  return _then(ReportSite(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as SiteStatus?,
  ));
}

}


/// Adds pattern-matching-related methods to [ReportSite].
extension ReportSitePatterns on ReportSite {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReportSite value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReportSite() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReportSite value)  $default,){
final _that = this;
switch (_that) {
case _ReportSite():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReportSite value)?  $default,){
final _that = this;
switch (_that) {
case _ReportSite() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String code,  String name,  SiteStatus? status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReportSite() when $default != null:
return $default(_that.id,_that.code,_that.name,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String code,  String name,  SiteStatus? status)  $default,) {final _that = this;
switch (_that) {
case _ReportSite():
return $default(_that.id,_that.code,_that.name,_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String code,  String name,  SiteStatus? status)?  $default,) {final _that = this;
switch (_that) {
case _ReportSite() when $default != null:
return $default(_that.id,_that.code,_that.name,_that.status);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ReportSite implements ReportSite {
  const _ReportSite({required this.id, required this.code, required this.name, this.status});
  factory _ReportSite.fromJson(Map<String, dynamic> json) => _$ReportSiteFromJson(json);

@override final  String id;
@override final  String code;
@override final  String name;
@override final  SiteStatus? status;

/// Create a copy of ReportSite
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReportSiteCopyWith<_ReportSite> get copyWith => __$ReportSiteCopyWithImpl<_ReportSite>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReportSiteToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReportSite&&(identical(other.id, id) || other.id == id)&&(identical(other.code, code) || other.code == code)&&(identical(other.name, name) || other.name == name)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,code,name,status);
}

@override
String toString() {
    return 'ReportSite(id: $id, code: $code, name: $name, status: $status)';
}


}

/// @nodoc
abstract mixin class _$ReportSiteCopyWith<$Res> implements $ReportSiteCopyWith<$Res> {
  factory _$ReportSiteCopyWith(_ReportSite value, $Res Function(_ReportSite) _then) = __$ReportSiteCopyWithImpl;
@override @useResult
$Res call({
 String id, String code, String name, SiteStatus? status
});




}
/// @nodoc
class __$ReportSiteCopyWithImpl<$Res>
    implements _$ReportSiteCopyWith<$Res> {
  __$ReportSiteCopyWithImpl(this._self, this._then);

  final _ReportSite _self;
  final $Res Function(_ReportSite) _then;

/// Create a copy of ReportSite
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? code = null,Object? name = null,Object? status = freezed,}) {
  return _then(_ReportSite(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as SiteStatus?,
  ));
}


}


/// @nodoc
mixin _$SiteIssueCounts {

 int get opened; int get resolved; int get openNow;
/// Create a copy of SiteIssueCounts
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SiteIssueCountsCopyWith<SiteIssueCounts> get copyWith => _$SiteIssueCountsCopyWithImpl<SiteIssueCounts>(this as SiteIssueCounts, _$identity);

  /// Serializes this SiteIssueCounts to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as SiteIssueCounts;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SiteIssueCounts&&(identical(other.opened, _this.opened) || other.opened == _this.opened)&&(identical(other.resolved, _this.resolved) || other.resolved == _this.resolved)&&(identical(other.openNow, _this.openNow) || other.openNow == _this.openNow));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as SiteIssueCounts;
  return Object.hash(runtimeType,_this.opened,_this.resolved,_this.openNow);
}

@override
String toString() {
  final _this = this as SiteIssueCounts;
  return 'SiteIssueCounts(opened: ${_this.opened}, resolved: ${_this.resolved}, openNow: ${_this.openNow})';
}


}

/// @nodoc
abstract mixin class $SiteIssueCountsCopyWith<$Res>  {
  factory $SiteIssueCountsCopyWith(SiteIssueCounts value, $Res Function(SiteIssueCounts) _then) = _$SiteIssueCountsCopyWithImpl;
@useResult
$Res call({
 int opened, int resolved, int openNow
});




}
/// @nodoc
class _$SiteIssueCountsCopyWithImpl<$Res>
    implements $SiteIssueCountsCopyWith<$Res> {
  _$SiteIssueCountsCopyWithImpl(this._self, this._then);

  final SiteIssueCounts _self;
  final $Res Function(SiteIssueCounts) _then;

/// Create a copy of SiteIssueCounts
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? opened = null,Object? resolved = null,Object? openNow = null,}) {
  return _then(SiteIssueCounts(
opened: null == opened ? _self.opened : opened // ignore: cast_nullable_to_non_nullable
as int,resolved: null == resolved ? _self.resolved : resolved // ignore: cast_nullable_to_non_nullable
as int,openNow: null == openNow ? _self.openNow : openNow // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [SiteIssueCounts].
extension SiteIssueCountsPatterns on SiteIssueCounts {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SiteIssueCounts value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SiteIssueCounts() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SiteIssueCounts value)  $default,){
final _that = this;
switch (_that) {
case _SiteIssueCounts():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SiteIssueCounts value)?  $default,){
final _that = this;
switch (_that) {
case _SiteIssueCounts() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int opened,  int resolved,  int openNow)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SiteIssueCounts() when $default != null:
return $default(_that.opened,_that.resolved,_that.openNow);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int opened,  int resolved,  int openNow)  $default,) {final _that = this;
switch (_that) {
case _SiteIssueCounts():
return $default(_that.opened,_that.resolved,_that.openNow);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int opened,  int resolved,  int openNow)?  $default,) {final _that = this;
switch (_that) {
case _SiteIssueCounts() when $default != null:
return $default(_that.opened,_that.resolved,_that.openNow);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SiteIssueCounts implements SiteIssueCounts {
  const _SiteIssueCounts({required this.opened, required this.resolved, required this.openNow});
  factory _SiteIssueCounts.fromJson(Map<String, dynamic> json) => _$SiteIssueCountsFromJson(json);

@override final  int opened;
@override final  int resolved;
@override final  int openNow;

/// Create a copy of SiteIssueCounts
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SiteIssueCountsCopyWith<_SiteIssueCounts> get copyWith => __$SiteIssueCountsCopyWithImpl<_SiteIssueCounts>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SiteIssueCountsToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SiteIssueCounts&&(identical(other.opened, opened) || other.opened == opened)&&(identical(other.resolved, resolved) || other.resolved == resolved)&&(identical(other.openNow, openNow) || other.openNow == openNow));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,opened,resolved,openNow);
}

@override
String toString() {
    return 'SiteIssueCounts(opened: $opened, resolved: $resolved, openNow: $openNow)';
}


}

/// @nodoc
abstract mixin class _$SiteIssueCountsCopyWith<$Res> implements $SiteIssueCountsCopyWith<$Res> {
  factory _$SiteIssueCountsCopyWith(_SiteIssueCounts value, $Res Function(_SiteIssueCounts) _then) = __$SiteIssueCountsCopyWithImpl;
@override @useResult
$Res call({
 int opened, int resolved, int openNow
});




}
/// @nodoc
class __$SiteIssueCountsCopyWithImpl<$Res>
    implements _$SiteIssueCountsCopyWith<$Res> {
  __$SiteIssueCountsCopyWithImpl(this._self, this._then);

  final _SiteIssueCounts _self;
  final $Res Function(_SiteIssueCounts) _then;

/// Create a copy of SiteIssueCounts
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? opened = null,Object? resolved = null,Object? openNow = null,}) {
  return _then(_SiteIssueCounts(
opened: null == opened ? _self.opened : opened // ignore: cast_nullable_to_non_nullable
as int,resolved: null == resolved ? _self.resolved : resolved // ignore: cast_nullable_to_non_nullable
as int,openNow: null == openNow ? _self.openNow : openNow // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$SiteReportRow {

 ReportSite get site; IdName get client; UpdateCounts get updates; AttendanceCounts get attendance; int get engineerUpdates; SiteIssueCounts get issues;/// Received in the range; null for engineers, who don't see money.
 String? get received;
/// Create a copy of SiteReportRow
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SiteReportRowCopyWith<SiteReportRow> get copyWith => _$SiteReportRowCopyWithImpl<SiteReportRow>(this as SiteReportRow, _$identity);

  /// Serializes this SiteReportRow to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as SiteReportRow;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SiteReportRow&&(identical(other.site, _this.site) || other.site == _this.site)&&(identical(other.client, _this.client) || other.client == _this.client)&&(identical(other.updates, _this.updates) || other.updates == _this.updates)&&(identical(other.attendance, _this.attendance) || other.attendance == _this.attendance)&&(identical(other.engineerUpdates, _this.engineerUpdates) || other.engineerUpdates == _this.engineerUpdates)&&(identical(other.issues, _this.issues) || other.issues == _this.issues)&&(identical(other.received, _this.received) || other.received == _this.received));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as SiteReportRow;
  return Object.hash(runtimeType,_this.site,_this.client,_this.updates,_this.attendance,_this.engineerUpdates,_this.issues,_this.received);
}

@override
String toString() {
  final _this = this as SiteReportRow;
  return 'SiteReportRow(site: ${_this.site}, client: ${_this.client}, updates: ${_this.updates}, attendance: ${_this.attendance}, engineerUpdates: ${_this.engineerUpdates}, issues: ${_this.issues}, received: ${_this.received})';
}


}

/// @nodoc
abstract mixin class $SiteReportRowCopyWith<$Res>  {
  factory $SiteReportRowCopyWith(SiteReportRow value, $Res Function(SiteReportRow) _then) = _$SiteReportRowCopyWithImpl;
@useResult
$Res call({
 ReportSite site, IdName client, UpdateCounts updates, AttendanceCounts attendance, int engineerUpdates, SiteIssueCounts issues, String? received
});


$ReportSiteCopyWith<$Res> get site;$IdNameCopyWith<$Res> get client;$UpdateCountsCopyWith<$Res> get updates;$AttendanceCountsCopyWith<$Res> get attendance;$SiteIssueCountsCopyWith<$Res> get issues;

}
/// @nodoc
class _$SiteReportRowCopyWithImpl<$Res>
    implements $SiteReportRowCopyWith<$Res> {
  _$SiteReportRowCopyWithImpl(this._self, this._then);

  final SiteReportRow _self;
  final $Res Function(SiteReportRow) _then;

/// Create a copy of SiteReportRow
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? site = null,Object? client = null,Object? updates = null,Object? attendance = null,Object? engineerUpdates = null,Object? issues = null,Object? received = freezed,}) {
  return _then(SiteReportRow(
site: null == site ? _self.site : site // ignore: cast_nullable_to_non_nullable
as ReportSite,client: null == client ? _self.client : client // ignore: cast_nullable_to_non_nullable
as IdName,updates: null == updates ? _self.updates : updates // ignore: cast_nullable_to_non_nullable
as UpdateCounts,attendance: null == attendance ? _self.attendance : attendance // ignore: cast_nullable_to_non_nullable
as AttendanceCounts,engineerUpdates: null == engineerUpdates ? _self.engineerUpdates : engineerUpdates // ignore: cast_nullable_to_non_nullable
as int,issues: null == issues ? _self.issues : issues // ignore: cast_nullable_to_non_nullable
as SiteIssueCounts,received: freezed == received ? _self.received : received // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of SiteReportRow
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReportSiteCopyWith<$Res> get site {
  
  return $ReportSiteCopyWith<$Res>(_self.site, (value) {
    return _then(_self.copyWith(site: value));
  });
}/// Create a copy of SiteReportRow
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$IdNameCopyWith<$Res> get client {
  
  return $IdNameCopyWith<$Res>(_self.client, (value) {
    return _then(_self.copyWith(client: value));
  });
}/// Create a copy of SiteReportRow
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UpdateCountsCopyWith<$Res> get updates {
  
  return $UpdateCountsCopyWith<$Res>(_self.updates, (value) {
    return _then(_self.copyWith(updates: value));
  });
}/// Create a copy of SiteReportRow
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AttendanceCountsCopyWith<$Res> get attendance {
  
  return $AttendanceCountsCopyWith<$Res>(_self.attendance, (value) {
    return _then(_self.copyWith(attendance: value));
  });
}/// Create a copy of SiteReportRow
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SiteIssueCountsCopyWith<$Res> get issues {
  
  return $SiteIssueCountsCopyWith<$Res>(_self.issues, (value) {
    return _then(_self.copyWith(issues: value));
  });
}
}


/// Adds pattern-matching-related methods to [SiteReportRow].
extension SiteReportRowPatterns on SiteReportRow {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SiteReportRow value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SiteReportRow() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SiteReportRow value)  $default,){
final _that = this;
switch (_that) {
case _SiteReportRow():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SiteReportRow value)?  $default,){
final _that = this;
switch (_that) {
case _SiteReportRow() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ReportSite site,  IdName client,  UpdateCounts updates,  AttendanceCounts attendance,  int engineerUpdates,  SiteIssueCounts issues,  String? received)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SiteReportRow() when $default != null:
return $default(_that.site,_that.client,_that.updates,_that.attendance,_that.engineerUpdates,_that.issues,_that.received);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ReportSite site,  IdName client,  UpdateCounts updates,  AttendanceCounts attendance,  int engineerUpdates,  SiteIssueCounts issues,  String? received)  $default,) {final _that = this;
switch (_that) {
case _SiteReportRow():
return $default(_that.site,_that.client,_that.updates,_that.attendance,_that.engineerUpdates,_that.issues,_that.received);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ReportSite site,  IdName client,  UpdateCounts updates,  AttendanceCounts attendance,  int engineerUpdates,  SiteIssueCounts issues,  String? received)?  $default,) {final _that = this;
switch (_that) {
case _SiteReportRow() when $default != null:
return $default(_that.site,_that.client,_that.updates,_that.attendance,_that.engineerUpdates,_that.issues,_that.received);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SiteReportRow implements SiteReportRow {
  const _SiteReportRow({required this.site, required this.client, required this.updates, required this.attendance, required this.engineerUpdates, required this.issues, this.received});
  factory _SiteReportRow.fromJson(Map<String, dynamic> json) => _$SiteReportRowFromJson(json);

@override final  ReportSite site;
@override final  IdName client;
@override final  UpdateCounts updates;
@override final  AttendanceCounts attendance;
@override final  int engineerUpdates;
@override final  SiteIssueCounts issues;
/// Received in the range; null for engineers, who don't see money.
@override final  String? received;

/// Create a copy of SiteReportRow
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SiteReportRowCopyWith<_SiteReportRow> get copyWith => __$SiteReportRowCopyWithImpl<_SiteReportRow>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SiteReportRowToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SiteReportRow&&(identical(other.site, site) || other.site == site)&&(identical(other.client, client) || other.client == client)&&(identical(other.updates, updates) || other.updates == updates)&&(identical(other.attendance, attendance) || other.attendance == attendance)&&(identical(other.engineerUpdates, engineerUpdates) || other.engineerUpdates == engineerUpdates)&&(identical(other.issues, issues) || other.issues == issues)&&(identical(other.received, received) || other.received == received));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,site,client,updates,attendance,engineerUpdates,issues,received);
}

@override
String toString() {
    return 'SiteReportRow(site: $site, client: $client, updates: $updates, attendance: $attendance, engineerUpdates: $engineerUpdates, issues: $issues, received: $received)';
}


}

/// @nodoc
abstract mixin class _$SiteReportRowCopyWith<$Res> implements $SiteReportRowCopyWith<$Res> {
  factory _$SiteReportRowCopyWith(_SiteReportRow value, $Res Function(_SiteReportRow) _then) = __$SiteReportRowCopyWithImpl;
@override @useResult
$Res call({
 ReportSite site, IdName client, UpdateCounts updates, AttendanceCounts attendance, int engineerUpdates, SiteIssueCounts issues, String? received
});


@override $ReportSiteCopyWith<$Res> get site;@override $IdNameCopyWith<$Res> get client;@override $UpdateCountsCopyWith<$Res> get updates;@override $AttendanceCountsCopyWith<$Res> get attendance;@override $SiteIssueCountsCopyWith<$Res> get issues;

}
/// @nodoc
class __$SiteReportRowCopyWithImpl<$Res>
    implements _$SiteReportRowCopyWith<$Res> {
  __$SiteReportRowCopyWithImpl(this._self, this._then);

  final _SiteReportRow _self;
  final $Res Function(_SiteReportRow) _then;

/// Create a copy of SiteReportRow
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? site = null,Object? client = null,Object? updates = null,Object? attendance = null,Object? engineerUpdates = null,Object? issues = null,Object? received = freezed,}) {
  return _then(_SiteReportRow(
site: null == site ? _self.site : site // ignore: cast_nullable_to_non_nullable
as ReportSite,client: null == client ? _self.client : client // ignore: cast_nullable_to_non_nullable
as IdName,updates: null == updates ? _self.updates : updates // ignore: cast_nullable_to_non_nullable
as UpdateCounts,attendance: null == attendance ? _self.attendance : attendance // ignore: cast_nullable_to_non_nullable
as AttendanceCounts,engineerUpdates: null == engineerUpdates ? _self.engineerUpdates : engineerUpdates // ignore: cast_nullable_to_non_nullable
as int,issues: null == issues ? _self.issues : issues // ignore: cast_nullable_to_non_nullable
as SiteIssueCounts,received: freezed == received ? _self.received : received // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of SiteReportRow
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReportSiteCopyWith<$Res> get site {
  
  return $ReportSiteCopyWith<$Res>(_self.site, (value) {
    return _then(_self.copyWith(site: value));
  });
}/// Create a copy of SiteReportRow
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$IdNameCopyWith<$Res> get client {
  
  return $IdNameCopyWith<$Res>(_self.client, (value) {
    return _then(_self.copyWith(client: value));
  });
}/// Create a copy of SiteReportRow
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UpdateCountsCopyWith<$Res> get updates {
  
  return $UpdateCountsCopyWith<$Res>(_self.updates, (value) {
    return _then(_self.copyWith(updates: value));
  });
}/// Create a copy of SiteReportRow
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AttendanceCountsCopyWith<$Res> get attendance {
  
  return $AttendanceCountsCopyWith<$Res>(_self.attendance, (value) {
    return _then(_self.copyWith(attendance: value));
  });
}/// Create a copy of SiteReportRow
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SiteIssueCountsCopyWith<$Res> get issues {
  
  return $SiteIssueCountsCopyWith<$Res>(_self.issues, (value) {
    return _then(_self.copyWith(issues: value));
  });
}
}


/// @nodoc
mixin _$ReportPerson {

 String get id; String get name; String get employeeCode; Designation? get designation; bool get isActive;
/// Create a copy of ReportPerson
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReportPersonCopyWith<ReportPerson> get copyWith => _$ReportPersonCopyWithImpl<ReportPerson>(this as ReportPerson, _$identity);

  /// Serializes this ReportPerson to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ReportPerson;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReportPerson&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.employeeCode, _this.employeeCode) || other.employeeCode == _this.employeeCode)&&(identical(other.designation, _this.designation) || other.designation == _this.designation)&&(identical(other.isActive, _this.isActive) || other.isActive == _this.isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ReportPerson;
  return Object.hash(runtimeType,_this.id,_this.name,_this.employeeCode,_this.designation,_this.isActive);
}

@override
String toString() {
  final _this = this as ReportPerson;
  return 'ReportPerson(id: ${_this.id}, name: ${_this.name}, employeeCode: ${_this.employeeCode}, designation: ${_this.designation}, isActive: ${_this.isActive})';
}


}

/// @nodoc
abstract mixin class $ReportPersonCopyWith<$Res>  {
  factory $ReportPersonCopyWith(ReportPerson value, $Res Function(ReportPerson) _then) = _$ReportPersonCopyWithImpl;
@useResult
$Res call({
 String id, String name, String employeeCode, Designation? designation, bool isActive
});




}
/// @nodoc
class _$ReportPersonCopyWithImpl<$Res>
    implements $ReportPersonCopyWith<$Res> {
  _$ReportPersonCopyWithImpl(this._self, this._then);

  final ReportPerson _self;
  final $Res Function(ReportPerson) _then;

/// Create a copy of ReportPerson
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? employeeCode = null,Object? designation = freezed,Object? isActive = null,}) {
  return _then(ReportPerson(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,employeeCode: null == employeeCode ? _self.employeeCode : employeeCode // ignore: cast_nullable_to_non_nullable
as String,designation: freezed == designation ? _self.designation : designation // ignore: cast_nullable_to_non_nullable
as Designation?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ReportPerson].
extension ReportPersonPatterns on ReportPerson {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReportPerson value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReportPerson() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReportPerson value)  $default,){
final _that = this;
switch (_that) {
case _ReportPerson():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReportPerson value)?  $default,){
final _that = this;
switch (_that) {
case _ReportPerson() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String employeeCode,  Designation? designation,  bool isActive)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReportPerson() when $default != null:
return $default(_that.id,_that.name,_that.employeeCode,_that.designation,_that.isActive);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String employeeCode,  Designation? designation,  bool isActive)  $default,) {final _that = this;
switch (_that) {
case _ReportPerson():
return $default(_that.id,_that.name,_that.employeeCode,_that.designation,_that.isActive);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String employeeCode,  Designation? designation,  bool isActive)?  $default,) {final _that = this;
switch (_that) {
case _ReportPerson() when $default != null:
return $default(_that.id,_that.name,_that.employeeCode,_that.designation,_that.isActive);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ReportPerson implements ReportPerson {
  const _ReportPerson({required this.id, required this.name, required this.employeeCode, this.designation, required this.isActive});
  factory _ReportPerson.fromJson(Map<String, dynamic> json) => _$ReportPersonFromJson(json);

@override final  String id;
@override final  String name;
@override final  String employeeCode;
@override final  Designation? designation;
@override final  bool isActive;

/// Create a copy of ReportPerson
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReportPersonCopyWith<_ReportPerson> get copyWith => __$ReportPersonCopyWithImpl<_ReportPerson>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReportPersonToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReportPerson&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.employeeCode, employeeCode) || other.employeeCode == employeeCode)&&(identical(other.designation, designation) || other.designation == designation)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,employeeCode,designation,isActive);
}

@override
String toString() {
    return 'ReportPerson(id: $id, name: $name, employeeCode: $employeeCode, designation: $designation, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class _$ReportPersonCopyWith<$Res> implements $ReportPersonCopyWith<$Res> {
  factory _$ReportPersonCopyWith(_ReportPerson value, $Res Function(_ReportPerson) _then) = __$ReportPersonCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String employeeCode, Designation? designation, bool isActive
});




}
/// @nodoc
class __$ReportPersonCopyWithImpl<$Res>
    implements _$ReportPersonCopyWith<$Res> {
  __$ReportPersonCopyWithImpl(this._self, this._then);

  final _ReportPerson _self;
  final $Res Function(_ReportPerson) _then;

/// Create a copy of ReportPerson
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? employeeCode = null,Object? designation = freezed,Object? isActive = null,}) {
  return _then(_ReportPerson(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,employeeCode: null == employeeCode ? _self.employeeCode : employeeCode // ignore: cast_nullable_to_non_nullable
as String,designation: freezed == designation ? _self.designation : designation // ignore: cast_nullable_to_non_nullable
as Designation?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$StaffReportRow {

 ReportPerson get staff;/// Where they are assigned now.
 IdName? get site; AttendanceCounts get attendance; UpdateCounts get updates;
/// Create a copy of StaffReportRow
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StaffReportRowCopyWith<StaffReportRow> get copyWith => _$StaffReportRowCopyWithImpl<StaffReportRow>(this as StaffReportRow, _$identity);

  /// Serializes this StaffReportRow to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as StaffReportRow;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StaffReportRow&&(identical(other.staff, _this.staff) || other.staff == _this.staff)&&(identical(other.site, _this.site) || other.site == _this.site)&&(identical(other.attendance, _this.attendance) || other.attendance == _this.attendance)&&(identical(other.updates, _this.updates) || other.updates == _this.updates));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as StaffReportRow;
  return Object.hash(runtimeType,_this.staff,_this.site,_this.attendance,_this.updates);
}

@override
String toString() {
  final _this = this as StaffReportRow;
  return 'StaffReportRow(staff: ${_this.staff}, site: ${_this.site}, attendance: ${_this.attendance}, updates: ${_this.updates})';
}


}

/// @nodoc
abstract mixin class $StaffReportRowCopyWith<$Res>  {
  factory $StaffReportRowCopyWith(StaffReportRow value, $Res Function(StaffReportRow) _then) = _$StaffReportRowCopyWithImpl;
@useResult
$Res call({
 ReportPerson staff, IdName? site, AttendanceCounts attendance, UpdateCounts updates
});


$ReportPersonCopyWith<$Res> get staff;$IdNameCopyWith<$Res>? get site;$AttendanceCountsCopyWith<$Res> get attendance;$UpdateCountsCopyWith<$Res> get updates;

}
/// @nodoc
class _$StaffReportRowCopyWithImpl<$Res>
    implements $StaffReportRowCopyWith<$Res> {
  _$StaffReportRowCopyWithImpl(this._self, this._then);

  final StaffReportRow _self;
  final $Res Function(StaffReportRow) _then;

/// Create a copy of StaffReportRow
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? staff = null,Object? site = freezed,Object? attendance = null,Object? updates = null,}) {
  return _then(StaffReportRow(
staff: null == staff ? _self.staff : staff // ignore: cast_nullable_to_non_nullable
as ReportPerson,site: freezed == site ? _self.site : site // ignore: cast_nullable_to_non_nullable
as IdName?,attendance: null == attendance ? _self.attendance : attendance // ignore: cast_nullable_to_non_nullable
as AttendanceCounts,updates: null == updates ? _self.updates : updates // ignore: cast_nullable_to_non_nullable
as UpdateCounts,
  ));
}
/// Create a copy of StaffReportRow
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReportPersonCopyWith<$Res> get staff {
  
  return $ReportPersonCopyWith<$Res>(_self.staff, (value) {
    return _then(_self.copyWith(staff: value));
  });
}/// Create a copy of StaffReportRow
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$IdNameCopyWith<$Res>? get site {
    if (_self.site == null) {
    return null;
  }

  return $IdNameCopyWith<$Res>(_self.site!, (value) {
    return _then(_self.copyWith(site: value));
  });
}/// Create a copy of StaffReportRow
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AttendanceCountsCopyWith<$Res> get attendance {
  
  return $AttendanceCountsCopyWith<$Res>(_self.attendance, (value) {
    return _then(_self.copyWith(attendance: value));
  });
}/// Create a copy of StaffReportRow
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UpdateCountsCopyWith<$Res> get updates {
  
  return $UpdateCountsCopyWith<$Res>(_self.updates, (value) {
    return _then(_self.copyWith(updates: value));
  });
}
}


/// Adds pattern-matching-related methods to [StaffReportRow].
extension StaffReportRowPatterns on StaffReportRow {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StaffReportRow value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StaffReportRow() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StaffReportRow value)  $default,){
final _that = this;
switch (_that) {
case _StaffReportRow():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StaffReportRow value)?  $default,){
final _that = this;
switch (_that) {
case _StaffReportRow() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ReportPerson staff,  IdName? site,  AttendanceCounts attendance,  UpdateCounts updates)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StaffReportRow() when $default != null:
return $default(_that.staff,_that.site,_that.attendance,_that.updates);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ReportPerson staff,  IdName? site,  AttendanceCounts attendance,  UpdateCounts updates)  $default,) {final _that = this;
switch (_that) {
case _StaffReportRow():
return $default(_that.staff,_that.site,_that.attendance,_that.updates);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ReportPerson staff,  IdName? site,  AttendanceCounts attendance,  UpdateCounts updates)?  $default,) {final _that = this;
switch (_that) {
case _StaffReportRow() when $default != null:
return $default(_that.staff,_that.site,_that.attendance,_that.updates);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StaffReportRow implements StaffReportRow {
  const _StaffReportRow({required this.staff, this.site, required this.attendance, required this.updates});
  factory _StaffReportRow.fromJson(Map<String, dynamic> json) => _$StaffReportRowFromJson(json);

@override final  ReportPerson staff;
/// Where they are assigned now.
@override final  IdName? site;
@override final  AttendanceCounts attendance;
@override final  UpdateCounts updates;

/// Create a copy of StaffReportRow
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StaffReportRowCopyWith<_StaffReportRow> get copyWith => __$StaffReportRowCopyWithImpl<_StaffReportRow>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StaffReportRowToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _StaffReportRow&&(identical(other.staff, staff) || other.staff == staff)&&(identical(other.site, site) || other.site == site)&&(identical(other.attendance, attendance) || other.attendance == attendance)&&(identical(other.updates, updates) || other.updates == updates));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,staff,site,attendance,updates);
}

@override
String toString() {
    return 'StaffReportRow(staff: $staff, site: $site, attendance: $attendance, updates: $updates)';
}


}

/// @nodoc
abstract mixin class _$StaffReportRowCopyWith<$Res> implements $StaffReportRowCopyWith<$Res> {
  factory _$StaffReportRowCopyWith(_StaffReportRow value, $Res Function(_StaffReportRow) _then) = __$StaffReportRowCopyWithImpl;
@override @useResult
$Res call({
 ReportPerson staff, IdName? site, AttendanceCounts attendance, UpdateCounts updates
});


@override $ReportPersonCopyWith<$Res> get staff;@override $IdNameCopyWith<$Res>? get site;@override $AttendanceCountsCopyWith<$Res> get attendance;@override $UpdateCountsCopyWith<$Res> get updates;

}
/// @nodoc
class __$StaffReportRowCopyWithImpl<$Res>
    implements _$StaffReportRowCopyWith<$Res> {
  __$StaffReportRowCopyWithImpl(this._self, this._then);

  final _StaffReportRow _self;
  final $Res Function(_StaffReportRow) _then;

/// Create a copy of StaffReportRow
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? staff = null,Object? site = freezed,Object? attendance = null,Object? updates = null,}) {
  return _then(_StaffReportRow(
staff: null == staff ? _self.staff : staff // ignore: cast_nullable_to_non_nullable
as ReportPerson,site: freezed == site ? _self.site : site // ignore: cast_nullable_to_non_nullable
as IdName?,attendance: null == attendance ? _self.attendance : attendance // ignore: cast_nullable_to_non_nullable
as AttendanceCounts,updates: null == updates ? _self.updates : updates // ignore: cast_nullable_to_non_nullable
as UpdateCounts,
  ));
}

/// Create a copy of StaffReportRow
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReportPersonCopyWith<$Res> get staff {
  
  return $ReportPersonCopyWith<$Res>(_self.staff, (value) {
    return _then(_self.copyWith(staff: value));
  });
}/// Create a copy of StaffReportRow
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$IdNameCopyWith<$Res>? get site {
    if (_self.site == null) {
    return null;
  }

  return $IdNameCopyWith<$Res>(_self.site!, (value) {
    return _then(_self.copyWith(site: value));
  });
}/// Create a copy of StaffReportRow
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AttendanceCountsCopyWith<$Res> get attendance {
  
  return $AttendanceCountsCopyWith<$Res>(_self.attendance, (value) {
    return _then(_self.copyWith(attendance: value));
  });
}/// Create a copy of StaffReportRow
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UpdateCountsCopyWith<$Res> get updates {
  
  return $UpdateCountsCopyWith<$Res>(_self.updates, (value) {
    return _then(_self.copyWith(updates: value));
  });
}
}


/// @nodoc
mixin _$EngineerIssueCounts {

 int get reported; int get resolved;
/// Create a copy of EngineerIssueCounts
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EngineerIssueCountsCopyWith<EngineerIssueCounts> get copyWith => _$EngineerIssueCountsCopyWithImpl<EngineerIssueCounts>(this as EngineerIssueCounts, _$identity);

  /// Serializes this EngineerIssueCounts to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as EngineerIssueCounts;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EngineerIssueCounts&&(identical(other.reported, _this.reported) || other.reported == _this.reported)&&(identical(other.resolved, _this.resolved) || other.resolved == _this.resolved));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as EngineerIssueCounts;
  return Object.hash(runtimeType,_this.reported,_this.resolved);
}

@override
String toString() {
  final _this = this as EngineerIssueCounts;
  return 'EngineerIssueCounts(reported: ${_this.reported}, resolved: ${_this.resolved})';
}


}

/// @nodoc
abstract mixin class $EngineerIssueCountsCopyWith<$Res>  {
  factory $EngineerIssueCountsCopyWith(EngineerIssueCounts value, $Res Function(EngineerIssueCounts) _then) = _$EngineerIssueCountsCopyWithImpl;
@useResult
$Res call({
 int reported, int resolved
});




}
/// @nodoc
class _$EngineerIssueCountsCopyWithImpl<$Res>
    implements $EngineerIssueCountsCopyWith<$Res> {
  _$EngineerIssueCountsCopyWithImpl(this._self, this._then);

  final EngineerIssueCounts _self;
  final $Res Function(EngineerIssueCounts) _then;

/// Create a copy of EngineerIssueCounts
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? reported = null,Object? resolved = null,}) {
  return _then(EngineerIssueCounts(
reported: null == reported ? _self.reported : reported // ignore: cast_nullable_to_non_nullable
as int,resolved: null == resolved ? _self.resolved : resolved // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [EngineerIssueCounts].
extension EngineerIssueCountsPatterns on EngineerIssueCounts {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EngineerIssueCounts value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EngineerIssueCounts() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EngineerIssueCounts value)  $default,){
final _that = this;
switch (_that) {
case _EngineerIssueCounts():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EngineerIssueCounts value)?  $default,){
final _that = this;
switch (_that) {
case _EngineerIssueCounts() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int reported,  int resolved)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EngineerIssueCounts() when $default != null:
return $default(_that.reported,_that.resolved);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int reported,  int resolved)  $default,) {final _that = this;
switch (_that) {
case _EngineerIssueCounts():
return $default(_that.reported,_that.resolved);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int reported,  int resolved)?  $default,) {final _that = this;
switch (_that) {
case _EngineerIssueCounts() when $default != null:
return $default(_that.reported,_that.resolved);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EngineerIssueCounts implements EngineerIssueCounts {
  const _EngineerIssueCounts({required this.reported, required this.resolved});
  factory _EngineerIssueCounts.fromJson(Map<String, dynamic> json) => _$EngineerIssueCountsFromJson(json);

@override final  int reported;
@override final  int resolved;

/// Create a copy of EngineerIssueCounts
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EngineerIssueCountsCopyWith<_EngineerIssueCounts> get copyWith => __$EngineerIssueCountsCopyWithImpl<_EngineerIssueCounts>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EngineerIssueCountsToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _EngineerIssueCounts&&(identical(other.reported, reported) || other.reported == reported)&&(identical(other.resolved, resolved) || other.resolved == resolved));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,reported,resolved);
}

@override
String toString() {
    return 'EngineerIssueCounts(reported: $reported, resolved: $resolved)';
}


}

/// @nodoc
abstract mixin class _$EngineerIssueCountsCopyWith<$Res> implements $EngineerIssueCountsCopyWith<$Res> {
  factory _$EngineerIssueCountsCopyWith(_EngineerIssueCounts value, $Res Function(_EngineerIssueCounts) _then) = __$EngineerIssueCountsCopyWithImpl;
@override @useResult
$Res call({
 int reported, int resolved
});




}
/// @nodoc
class __$EngineerIssueCountsCopyWithImpl<$Res>
    implements _$EngineerIssueCountsCopyWith<$Res> {
  __$EngineerIssueCountsCopyWithImpl(this._self, this._then);

  final _EngineerIssueCounts _self;
  final $Res Function(_EngineerIssueCounts) _then;

/// Create a copy of EngineerIssueCounts
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? reported = null,Object? resolved = null,}) {
  return _then(_EngineerIssueCounts(
reported: null == reported ? _self.reported : reported // ignore: cast_nullable_to_non_nullable
as int,resolved: null == resolved ? _self.resolved : resolved // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$ReviewCounts {

 int get photos; int get reviewed; int? get reviewRatePercent;/// From the photo being sent to the engineer opening it.
 int? get averageMinutes;
/// Create a copy of ReviewCounts
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReviewCountsCopyWith<ReviewCounts> get copyWith => _$ReviewCountsCopyWithImpl<ReviewCounts>(this as ReviewCounts, _$identity);

  /// Serializes this ReviewCounts to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ReviewCounts;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReviewCounts&&(identical(other.photos, _this.photos) || other.photos == _this.photos)&&(identical(other.reviewed, _this.reviewed) || other.reviewed == _this.reviewed)&&(identical(other.reviewRatePercent, _this.reviewRatePercent) || other.reviewRatePercent == _this.reviewRatePercent)&&(identical(other.averageMinutes, _this.averageMinutes) || other.averageMinutes == _this.averageMinutes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ReviewCounts;
  return Object.hash(runtimeType,_this.photos,_this.reviewed,_this.reviewRatePercent,_this.averageMinutes);
}

@override
String toString() {
  final _this = this as ReviewCounts;
  return 'ReviewCounts(photos: ${_this.photos}, reviewed: ${_this.reviewed}, reviewRatePercent: ${_this.reviewRatePercent}, averageMinutes: ${_this.averageMinutes})';
}


}

/// @nodoc
abstract mixin class $ReviewCountsCopyWith<$Res>  {
  factory $ReviewCountsCopyWith(ReviewCounts value, $Res Function(ReviewCounts) _then) = _$ReviewCountsCopyWithImpl;
@useResult
$Res call({
 int photos, int reviewed, int? reviewRatePercent, int? averageMinutes
});




}
/// @nodoc
class _$ReviewCountsCopyWithImpl<$Res>
    implements $ReviewCountsCopyWith<$Res> {
  _$ReviewCountsCopyWithImpl(this._self, this._then);

  final ReviewCounts _self;
  final $Res Function(ReviewCounts) _then;

/// Create a copy of ReviewCounts
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? photos = null,Object? reviewed = null,Object? reviewRatePercent = freezed,Object? averageMinutes = freezed,}) {
  return _then(ReviewCounts(
photos: null == photos ? _self.photos : photos // ignore: cast_nullable_to_non_nullable
as int,reviewed: null == reviewed ? _self.reviewed : reviewed // ignore: cast_nullable_to_non_nullable
as int,reviewRatePercent: freezed == reviewRatePercent ? _self.reviewRatePercent : reviewRatePercent // ignore: cast_nullable_to_non_nullable
as int?,averageMinutes: freezed == averageMinutes ? _self.averageMinutes : averageMinutes // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [ReviewCounts].
extension ReviewCountsPatterns on ReviewCounts {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReviewCounts value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReviewCounts() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReviewCounts value)  $default,){
final _that = this;
switch (_that) {
case _ReviewCounts():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReviewCounts value)?  $default,){
final _that = this;
switch (_that) {
case _ReviewCounts() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int photos,  int reviewed,  int? reviewRatePercent,  int? averageMinutes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReviewCounts() when $default != null:
return $default(_that.photos,_that.reviewed,_that.reviewRatePercent,_that.averageMinutes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int photos,  int reviewed,  int? reviewRatePercent,  int? averageMinutes)  $default,) {final _that = this;
switch (_that) {
case _ReviewCounts():
return $default(_that.photos,_that.reviewed,_that.reviewRatePercent,_that.averageMinutes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int photos,  int reviewed,  int? reviewRatePercent,  int? averageMinutes)?  $default,) {final _that = this;
switch (_that) {
case _ReviewCounts() when $default != null:
return $default(_that.photos,_that.reviewed,_that.reviewRatePercent,_that.averageMinutes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ReviewCounts implements ReviewCounts {
  const _ReviewCounts({required this.photos, required this.reviewed, this.reviewRatePercent, this.averageMinutes});
  factory _ReviewCounts.fromJson(Map<String, dynamic> json) => _$ReviewCountsFromJson(json);

@override final  int photos;
@override final  int reviewed;
@override final  int? reviewRatePercent;
/// From the photo being sent to the engineer opening it.
@override final  int? averageMinutes;

/// Create a copy of ReviewCounts
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReviewCountsCopyWith<_ReviewCounts> get copyWith => __$ReviewCountsCopyWithImpl<_ReviewCounts>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReviewCountsToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReviewCounts&&(identical(other.photos, photos) || other.photos == photos)&&(identical(other.reviewed, reviewed) || other.reviewed == reviewed)&&(identical(other.reviewRatePercent, reviewRatePercent) || other.reviewRatePercent == reviewRatePercent)&&(identical(other.averageMinutes, averageMinutes) || other.averageMinutes == averageMinutes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,photos,reviewed,reviewRatePercent,averageMinutes);
}

@override
String toString() {
    return 'ReviewCounts(photos: $photos, reviewed: $reviewed, reviewRatePercent: $reviewRatePercent, averageMinutes: $averageMinutes)';
}


}

/// @nodoc
abstract mixin class _$ReviewCountsCopyWith<$Res> implements $ReviewCountsCopyWith<$Res> {
  factory _$ReviewCountsCopyWith(_ReviewCounts value, $Res Function(_ReviewCounts) _then) = __$ReviewCountsCopyWithImpl;
@override @useResult
$Res call({
 int photos, int reviewed, int? reviewRatePercent, int? averageMinutes
});




}
/// @nodoc
class __$ReviewCountsCopyWithImpl<$Res>
    implements _$ReviewCountsCopyWith<$Res> {
  __$ReviewCountsCopyWithImpl(this._self, this._then);

  final _ReviewCounts _self;
  final $Res Function(_ReviewCounts) _then;

/// Create a copy of ReviewCounts
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? photos = null,Object? reviewed = null,Object? reviewRatePercent = freezed,Object? averageMinutes = freezed,}) {
  return _then(_ReviewCounts(
photos: null == photos ? _self.photos : photos // ignore: cast_nullable_to_non_nullable
as int,reviewed: null == reviewed ? _self.reviewed : reviewed // ignore: cast_nullable_to_non_nullable
as int,reviewRatePercent: freezed == reviewRatePercent ? _self.reviewRatePercent : reviewRatePercent // ignore: cast_nullable_to_non_nullable
as int?,averageMinutes: freezed == averageMinutes ? _self.averageMinutes : averageMinutes // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$EngineerReportRow {

 ReportPerson get engineer; int get sites; int get engineerUpdates; EngineerIssueCounts get issues; ReviewCounts get reviews;
/// Create a copy of EngineerReportRow
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EngineerReportRowCopyWith<EngineerReportRow> get copyWith => _$EngineerReportRowCopyWithImpl<EngineerReportRow>(this as EngineerReportRow, _$identity);

  /// Serializes this EngineerReportRow to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as EngineerReportRow;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EngineerReportRow&&(identical(other.engineer, _this.engineer) || other.engineer == _this.engineer)&&(identical(other.sites, _this.sites) || other.sites == _this.sites)&&(identical(other.engineerUpdates, _this.engineerUpdates) || other.engineerUpdates == _this.engineerUpdates)&&(identical(other.issues, _this.issues) || other.issues == _this.issues)&&(identical(other.reviews, _this.reviews) || other.reviews == _this.reviews));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as EngineerReportRow;
  return Object.hash(runtimeType,_this.engineer,_this.sites,_this.engineerUpdates,_this.issues,_this.reviews);
}

@override
String toString() {
  final _this = this as EngineerReportRow;
  return 'EngineerReportRow(engineer: ${_this.engineer}, sites: ${_this.sites}, engineerUpdates: ${_this.engineerUpdates}, issues: ${_this.issues}, reviews: ${_this.reviews})';
}


}

/// @nodoc
abstract mixin class $EngineerReportRowCopyWith<$Res>  {
  factory $EngineerReportRowCopyWith(EngineerReportRow value, $Res Function(EngineerReportRow) _then) = _$EngineerReportRowCopyWithImpl;
@useResult
$Res call({
 ReportPerson engineer, int sites, int engineerUpdates, EngineerIssueCounts issues, ReviewCounts reviews
});


$ReportPersonCopyWith<$Res> get engineer;$EngineerIssueCountsCopyWith<$Res> get issues;$ReviewCountsCopyWith<$Res> get reviews;

}
/// @nodoc
class _$EngineerReportRowCopyWithImpl<$Res>
    implements $EngineerReportRowCopyWith<$Res> {
  _$EngineerReportRowCopyWithImpl(this._self, this._then);

  final EngineerReportRow _self;
  final $Res Function(EngineerReportRow) _then;

/// Create a copy of EngineerReportRow
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? engineer = null,Object? sites = null,Object? engineerUpdates = null,Object? issues = null,Object? reviews = null,}) {
  return _then(EngineerReportRow(
engineer: null == engineer ? _self.engineer : engineer // ignore: cast_nullable_to_non_nullable
as ReportPerson,sites: null == sites ? _self.sites : sites // ignore: cast_nullable_to_non_nullable
as int,engineerUpdates: null == engineerUpdates ? _self.engineerUpdates : engineerUpdates // ignore: cast_nullable_to_non_nullable
as int,issues: null == issues ? _self.issues : issues // ignore: cast_nullable_to_non_nullable
as EngineerIssueCounts,reviews: null == reviews ? _self.reviews : reviews // ignore: cast_nullable_to_non_nullable
as ReviewCounts,
  ));
}
/// Create a copy of EngineerReportRow
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReportPersonCopyWith<$Res> get engineer {
  
  return $ReportPersonCopyWith<$Res>(_self.engineer, (value) {
    return _then(_self.copyWith(engineer: value));
  });
}/// Create a copy of EngineerReportRow
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EngineerIssueCountsCopyWith<$Res> get issues {
  
  return $EngineerIssueCountsCopyWith<$Res>(_self.issues, (value) {
    return _then(_self.copyWith(issues: value));
  });
}/// Create a copy of EngineerReportRow
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReviewCountsCopyWith<$Res> get reviews {
  
  return $ReviewCountsCopyWith<$Res>(_self.reviews, (value) {
    return _then(_self.copyWith(reviews: value));
  });
}
}


/// Adds pattern-matching-related methods to [EngineerReportRow].
extension EngineerReportRowPatterns on EngineerReportRow {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EngineerReportRow value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EngineerReportRow() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EngineerReportRow value)  $default,){
final _that = this;
switch (_that) {
case _EngineerReportRow():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EngineerReportRow value)?  $default,){
final _that = this;
switch (_that) {
case _EngineerReportRow() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ReportPerson engineer,  int sites,  int engineerUpdates,  EngineerIssueCounts issues,  ReviewCounts reviews)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EngineerReportRow() when $default != null:
return $default(_that.engineer,_that.sites,_that.engineerUpdates,_that.issues,_that.reviews);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ReportPerson engineer,  int sites,  int engineerUpdates,  EngineerIssueCounts issues,  ReviewCounts reviews)  $default,) {final _that = this;
switch (_that) {
case _EngineerReportRow():
return $default(_that.engineer,_that.sites,_that.engineerUpdates,_that.issues,_that.reviews);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ReportPerson engineer,  int sites,  int engineerUpdates,  EngineerIssueCounts issues,  ReviewCounts reviews)?  $default,) {final _that = this;
switch (_that) {
case _EngineerReportRow() when $default != null:
return $default(_that.engineer,_that.sites,_that.engineerUpdates,_that.issues,_that.reviews);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EngineerReportRow implements EngineerReportRow {
  const _EngineerReportRow({required this.engineer, required this.sites, required this.engineerUpdates, required this.issues, required this.reviews});
  factory _EngineerReportRow.fromJson(Map<String, dynamic> json) => _$EngineerReportRowFromJson(json);

@override final  ReportPerson engineer;
@override final  int sites;
@override final  int engineerUpdates;
@override final  EngineerIssueCounts issues;
@override final  ReviewCounts reviews;

/// Create a copy of EngineerReportRow
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EngineerReportRowCopyWith<_EngineerReportRow> get copyWith => __$EngineerReportRowCopyWithImpl<_EngineerReportRow>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EngineerReportRowToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _EngineerReportRow&&(identical(other.engineer, engineer) || other.engineer == engineer)&&(identical(other.sites, sites) || other.sites == sites)&&(identical(other.engineerUpdates, engineerUpdates) || other.engineerUpdates == engineerUpdates)&&(identical(other.issues, issues) || other.issues == issues)&&(identical(other.reviews, reviews) || other.reviews == reviews));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,engineer,sites,engineerUpdates,issues,reviews);
}

@override
String toString() {
    return 'EngineerReportRow(engineer: $engineer, sites: $sites, engineerUpdates: $engineerUpdates, issues: $issues, reviews: $reviews)';
}


}

/// @nodoc
abstract mixin class _$EngineerReportRowCopyWith<$Res> implements $EngineerReportRowCopyWith<$Res> {
  factory _$EngineerReportRowCopyWith(_EngineerReportRow value, $Res Function(_EngineerReportRow) _then) = __$EngineerReportRowCopyWithImpl;
@override @useResult
$Res call({
 ReportPerson engineer, int sites, int engineerUpdates, EngineerIssueCounts issues, ReviewCounts reviews
});


@override $ReportPersonCopyWith<$Res> get engineer;@override $EngineerIssueCountsCopyWith<$Res> get issues;@override $ReviewCountsCopyWith<$Res> get reviews;

}
/// @nodoc
class __$EngineerReportRowCopyWithImpl<$Res>
    implements _$EngineerReportRowCopyWith<$Res> {
  __$EngineerReportRowCopyWithImpl(this._self, this._then);

  final _EngineerReportRow _self;
  final $Res Function(_EngineerReportRow) _then;

/// Create a copy of EngineerReportRow
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? engineer = null,Object? sites = null,Object? engineerUpdates = null,Object? issues = null,Object? reviews = null,}) {
  return _then(_EngineerReportRow(
engineer: null == engineer ? _self.engineer : engineer // ignore: cast_nullable_to_non_nullable
as ReportPerson,sites: null == sites ? _self.sites : sites // ignore: cast_nullable_to_non_nullable
as int,engineerUpdates: null == engineerUpdates ? _self.engineerUpdates : engineerUpdates // ignore: cast_nullable_to_non_nullable
as int,issues: null == issues ? _self.issues : issues // ignore: cast_nullable_to_non_nullable
as EngineerIssueCounts,reviews: null == reviews ? _self.reviews : reviews // ignore: cast_nullable_to_non_nullable
as ReviewCounts,
  ));
}

/// Create a copy of EngineerReportRow
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReportPersonCopyWith<$Res> get engineer {
  
  return $ReportPersonCopyWith<$Res>(_self.engineer, (value) {
    return _then(_self.copyWith(engineer: value));
  });
}/// Create a copy of EngineerReportRow
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EngineerIssueCountsCopyWith<$Res> get issues {
  
  return $EngineerIssueCountsCopyWith<$Res>(_self.issues, (value) {
    return _then(_self.copyWith(issues: value));
  });
}/// Create a copy of EngineerReportRow
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReviewCountsCopyWith<$Res> get reviews {
  
  return $ReviewCountsCopyWith<$Res>(_self.reviews, (value) {
    return _then(_self.copyWith(reviews: value));
  });
}
}


/// @nodoc
mixin _$PaymentReportTotals {

 String get received; int get count;/// Amount per method; methods with nothing received are left out.
 Map<String, String> get byMethod;
/// Create a copy of PaymentReportTotals
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaymentReportTotalsCopyWith<PaymentReportTotals> get copyWith => _$PaymentReportTotalsCopyWithImpl<PaymentReportTotals>(this as PaymentReportTotals, _$identity);

  /// Serializes this PaymentReportTotals to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PaymentReportTotals;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaymentReportTotals&&(identical(other.received, _this.received) || other.received == _this.received)&&(identical(other.count, _this.count) || other.count == _this.count)&&const DeepCollectionEquality().equals(other.byMethod, _this.byMethod));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PaymentReportTotals;
  return Object.hash(runtimeType,_this.received,_this.count,const DeepCollectionEquality().hash(_this.byMethod));
}

@override
String toString() {
  final _this = this as PaymentReportTotals;
  return 'PaymentReportTotals(received: ${_this.received}, count: ${_this.count}, byMethod: ${_this.byMethod})';
}


}

/// @nodoc
abstract mixin class $PaymentReportTotalsCopyWith<$Res>  {
  factory $PaymentReportTotalsCopyWith(PaymentReportTotals value, $Res Function(PaymentReportTotals) _then) = _$PaymentReportTotalsCopyWithImpl;
@useResult
$Res call({
 String received, int count, Map<String, String> byMethod
});




}
/// @nodoc
class _$PaymentReportTotalsCopyWithImpl<$Res>
    implements $PaymentReportTotalsCopyWith<$Res> {
  _$PaymentReportTotalsCopyWithImpl(this._self, this._then);

  final PaymentReportTotals _self;
  final $Res Function(PaymentReportTotals) _then;

/// Create a copy of PaymentReportTotals
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? received = null,Object? count = null,Object? byMethod = null,}) {
  return _then(PaymentReportTotals(
received: null == received ? _self.received : received // ignore: cast_nullable_to_non_nullable
as String,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,byMethod: null == byMethod ? _self.byMethod : byMethod // ignore: cast_nullable_to_non_nullable
as Map<String, String>,
  ));
}

}


/// Adds pattern-matching-related methods to [PaymentReportTotals].
extension PaymentReportTotalsPatterns on PaymentReportTotals {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PaymentReportTotals value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PaymentReportTotals() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PaymentReportTotals value)  $default,){
final _that = this;
switch (_that) {
case _PaymentReportTotals():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PaymentReportTotals value)?  $default,){
final _that = this;
switch (_that) {
case _PaymentReportTotals() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String received,  int count,  Map<String, String> byMethod)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PaymentReportTotals() when $default != null:
return $default(_that.received,_that.count,_that.byMethod);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String received,  int count,  Map<String, String> byMethod)  $default,) {final _that = this;
switch (_that) {
case _PaymentReportTotals():
return $default(_that.received,_that.count,_that.byMethod);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String received,  int count,  Map<String, String> byMethod)?  $default,) {final _that = this;
switch (_that) {
case _PaymentReportTotals() when $default != null:
return $default(_that.received,_that.count,_that.byMethod);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PaymentReportTotals implements PaymentReportTotals {
  const _PaymentReportTotals({required this.received, required this.count,  Map<String, String> byMethod = const <String, String>{}}): _byMethod = byMethod;
  factory _PaymentReportTotals.fromJson(Map<String, dynamic> json) => _$PaymentReportTotalsFromJson(json);

@override final  String received;
@override final  int count;
/// Amount per method; methods with nothing received are left out.
 final  Map<String, String> _byMethod;
/// Amount per method; methods with nothing received are left out.
@override@JsonKey() Map<String, String> get byMethod {
  if (_byMethod is EqualUnmodifiableMapView) return _byMethod;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_byMethod);
}


/// Create a copy of PaymentReportTotals
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PaymentReportTotalsCopyWith<_PaymentReportTotals> get copyWith => __$PaymentReportTotalsCopyWithImpl<_PaymentReportTotals>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PaymentReportTotalsToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PaymentReportTotals&&(identical(other.received, received) || other.received == received)&&(identical(other.count, count) || other.count == count)&&const DeepCollectionEquality().equals(other.byMethod, _byMethod));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,received,count,const DeepCollectionEquality().hash(_byMethod));
}

@override
String toString() {
    return 'PaymentReportTotals(received: $received, count: $count, byMethod: $byMethod)';
}


}

/// @nodoc
abstract mixin class _$PaymentReportTotalsCopyWith<$Res> implements $PaymentReportTotalsCopyWith<$Res> {
  factory _$PaymentReportTotalsCopyWith(_PaymentReportTotals value, $Res Function(_PaymentReportTotals) _then) = __$PaymentReportTotalsCopyWithImpl;
@override @useResult
$Res call({
 String received, int count, Map<String, String> byMethod
});




}
/// @nodoc
class __$PaymentReportTotalsCopyWithImpl<$Res>
    implements _$PaymentReportTotalsCopyWith<$Res> {
  __$PaymentReportTotalsCopyWithImpl(this._self, this._then);

  final _PaymentReportTotals _self;
  final $Res Function(_PaymentReportTotals) _then;

/// Create a copy of PaymentReportTotals
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? received = null,Object? count = null,Object? byMethod = null,}) {
  return _then(_PaymentReportTotals(
received: null == received ? _self.received : received // ignore: cast_nullable_to_non_nullable
as String,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,byMethod: null == byMethod ? _self._byMethod : byMethod // ignore: cast_nullable_to_non_nullable
as Map<String, String>,
  ));
}


}


/// @nodoc
mixin _$PaymentReportSite {

 ReportSite get site; IdName get client; String get receivedInRange; String get contract; String get receivedToDate; String get pending; String get overdue;
/// Create a copy of PaymentReportSite
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaymentReportSiteCopyWith<PaymentReportSite> get copyWith => _$PaymentReportSiteCopyWithImpl<PaymentReportSite>(this as PaymentReportSite, _$identity);

  /// Serializes this PaymentReportSite to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PaymentReportSite;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaymentReportSite&&(identical(other.site, _this.site) || other.site == _this.site)&&(identical(other.client, _this.client) || other.client == _this.client)&&(identical(other.receivedInRange, _this.receivedInRange) || other.receivedInRange == _this.receivedInRange)&&(identical(other.contract, _this.contract) || other.contract == _this.contract)&&(identical(other.receivedToDate, _this.receivedToDate) || other.receivedToDate == _this.receivedToDate)&&(identical(other.pending, _this.pending) || other.pending == _this.pending)&&(identical(other.overdue, _this.overdue) || other.overdue == _this.overdue));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PaymentReportSite;
  return Object.hash(runtimeType,_this.site,_this.client,_this.receivedInRange,_this.contract,_this.receivedToDate,_this.pending,_this.overdue);
}

@override
String toString() {
  final _this = this as PaymentReportSite;
  return 'PaymentReportSite(site: ${_this.site}, client: ${_this.client}, receivedInRange: ${_this.receivedInRange}, contract: ${_this.contract}, receivedToDate: ${_this.receivedToDate}, pending: ${_this.pending}, overdue: ${_this.overdue})';
}


}

/// @nodoc
abstract mixin class $PaymentReportSiteCopyWith<$Res>  {
  factory $PaymentReportSiteCopyWith(PaymentReportSite value, $Res Function(PaymentReportSite) _then) = _$PaymentReportSiteCopyWithImpl;
@useResult
$Res call({
 ReportSite site, IdName client, String receivedInRange, String contract, String receivedToDate, String pending, String overdue
});


$ReportSiteCopyWith<$Res> get site;$IdNameCopyWith<$Res> get client;

}
/// @nodoc
class _$PaymentReportSiteCopyWithImpl<$Res>
    implements $PaymentReportSiteCopyWith<$Res> {
  _$PaymentReportSiteCopyWithImpl(this._self, this._then);

  final PaymentReportSite _self;
  final $Res Function(PaymentReportSite) _then;

/// Create a copy of PaymentReportSite
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? site = null,Object? client = null,Object? receivedInRange = null,Object? contract = null,Object? receivedToDate = null,Object? pending = null,Object? overdue = null,}) {
  return _then(PaymentReportSite(
site: null == site ? _self.site : site // ignore: cast_nullable_to_non_nullable
as ReportSite,client: null == client ? _self.client : client // ignore: cast_nullable_to_non_nullable
as IdName,receivedInRange: null == receivedInRange ? _self.receivedInRange : receivedInRange // ignore: cast_nullable_to_non_nullable
as String,contract: null == contract ? _self.contract : contract // ignore: cast_nullable_to_non_nullable
as String,receivedToDate: null == receivedToDate ? _self.receivedToDate : receivedToDate // ignore: cast_nullable_to_non_nullable
as String,pending: null == pending ? _self.pending : pending // ignore: cast_nullable_to_non_nullable
as String,overdue: null == overdue ? _self.overdue : overdue // ignore: cast_nullable_to_non_nullable
as String,
  ));
}
/// Create a copy of PaymentReportSite
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReportSiteCopyWith<$Res> get site {
  
  return $ReportSiteCopyWith<$Res>(_self.site, (value) {
    return _then(_self.copyWith(site: value));
  });
}/// Create a copy of PaymentReportSite
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$IdNameCopyWith<$Res> get client {
  
  return $IdNameCopyWith<$Res>(_self.client, (value) {
    return _then(_self.copyWith(client: value));
  });
}
}


/// Adds pattern-matching-related methods to [PaymentReportSite].
extension PaymentReportSitePatterns on PaymentReportSite {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PaymentReportSite value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PaymentReportSite() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PaymentReportSite value)  $default,){
final _that = this;
switch (_that) {
case _PaymentReportSite():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PaymentReportSite value)?  $default,){
final _that = this;
switch (_that) {
case _PaymentReportSite() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ReportSite site,  IdName client,  String receivedInRange,  String contract,  String receivedToDate,  String pending,  String overdue)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PaymentReportSite() when $default != null:
return $default(_that.site,_that.client,_that.receivedInRange,_that.contract,_that.receivedToDate,_that.pending,_that.overdue);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ReportSite site,  IdName client,  String receivedInRange,  String contract,  String receivedToDate,  String pending,  String overdue)  $default,) {final _that = this;
switch (_that) {
case _PaymentReportSite():
return $default(_that.site,_that.client,_that.receivedInRange,_that.contract,_that.receivedToDate,_that.pending,_that.overdue);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ReportSite site,  IdName client,  String receivedInRange,  String contract,  String receivedToDate,  String pending,  String overdue)?  $default,) {final _that = this;
switch (_that) {
case _PaymentReportSite() when $default != null:
return $default(_that.site,_that.client,_that.receivedInRange,_that.contract,_that.receivedToDate,_that.pending,_that.overdue);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PaymentReportSite implements PaymentReportSite {
  const _PaymentReportSite({required this.site, required this.client, required this.receivedInRange, required this.contract, required this.receivedToDate, required this.pending, required this.overdue});
  factory _PaymentReportSite.fromJson(Map<String, dynamic> json) => _$PaymentReportSiteFromJson(json);

@override final  ReportSite site;
@override final  IdName client;
@override final  String receivedInRange;
@override final  String contract;
@override final  String receivedToDate;
@override final  String pending;
@override final  String overdue;

/// Create a copy of PaymentReportSite
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PaymentReportSiteCopyWith<_PaymentReportSite> get copyWith => __$PaymentReportSiteCopyWithImpl<_PaymentReportSite>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PaymentReportSiteToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PaymentReportSite&&(identical(other.site, site) || other.site == site)&&(identical(other.client, client) || other.client == client)&&(identical(other.receivedInRange, receivedInRange) || other.receivedInRange == receivedInRange)&&(identical(other.contract, contract) || other.contract == contract)&&(identical(other.receivedToDate, receivedToDate) || other.receivedToDate == receivedToDate)&&(identical(other.pending, pending) || other.pending == pending)&&(identical(other.overdue, overdue) || other.overdue == overdue));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,site,client,receivedInRange,contract,receivedToDate,pending,overdue);
}

@override
String toString() {
    return 'PaymentReportSite(site: $site, client: $client, receivedInRange: $receivedInRange, contract: $contract, receivedToDate: $receivedToDate, pending: $pending, overdue: $overdue)';
}


}

/// @nodoc
abstract mixin class _$PaymentReportSiteCopyWith<$Res> implements $PaymentReportSiteCopyWith<$Res> {
  factory _$PaymentReportSiteCopyWith(_PaymentReportSite value, $Res Function(_PaymentReportSite) _then) = __$PaymentReportSiteCopyWithImpl;
@override @useResult
$Res call({
 ReportSite site, IdName client, String receivedInRange, String contract, String receivedToDate, String pending, String overdue
});


@override $ReportSiteCopyWith<$Res> get site;@override $IdNameCopyWith<$Res> get client;

}
/// @nodoc
class __$PaymentReportSiteCopyWithImpl<$Res>
    implements _$PaymentReportSiteCopyWith<$Res> {
  __$PaymentReportSiteCopyWithImpl(this._self, this._then);

  final _PaymentReportSite _self;
  final $Res Function(_PaymentReportSite) _then;

/// Create a copy of PaymentReportSite
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? site = null,Object? client = null,Object? receivedInRange = null,Object? contract = null,Object? receivedToDate = null,Object? pending = null,Object? overdue = null,}) {
  return _then(_PaymentReportSite(
site: null == site ? _self.site : site // ignore: cast_nullable_to_non_nullable
as ReportSite,client: null == client ? _self.client : client // ignore: cast_nullable_to_non_nullable
as IdName,receivedInRange: null == receivedInRange ? _self.receivedInRange : receivedInRange // ignore: cast_nullable_to_non_nullable
as String,contract: null == contract ? _self.contract : contract // ignore: cast_nullable_to_non_nullable
as String,receivedToDate: null == receivedToDate ? _self.receivedToDate : receivedToDate // ignore: cast_nullable_to_non_nullable
as String,pending: null == pending ? _self.pending : pending // ignore: cast_nullable_to_non_nullable
as String,overdue: null == overdue ? _self.overdue : overdue // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

/// Create a copy of PaymentReportSite
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReportSiteCopyWith<$Res> get site {
  
  return $ReportSiteCopyWith<$Res>(_self.site, (value) {
    return _then(_self.copyWith(site: value));
  });
}/// Create a copy of PaymentReportSite
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$IdNameCopyWith<$Res> get client {
  
  return $IdNameCopyWith<$Res>(_self.client, (value) {
    return _then(_self.copyWith(client: value));
  });
}
}


/// @nodoc
mixin _$PaymentReportLine {

 String get id; String get paidOn; String get amount;@JsonKey(unknownEnumValue: PaymentMethod.other) PaymentMethod get method; String? get reference; IdName get site; IdName get client;
/// Create a copy of PaymentReportLine
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaymentReportLineCopyWith<PaymentReportLine> get copyWith => _$PaymentReportLineCopyWithImpl<PaymentReportLine>(this as PaymentReportLine, _$identity);

  /// Serializes this PaymentReportLine to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PaymentReportLine;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaymentReportLine&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.paidOn, _this.paidOn) || other.paidOn == _this.paidOn)&&(identical(other.amount, _this.amount) || other.amount == _this.amount)&&(identical(other.method, _this.method) || other.method == _this.method)&&(identical(other.reference, _this.reference) || other.reference == _this.reference)&&(identical(other.site, _this.site) || other.site == _this.site)&&(identical(other.client, _this.client) || other.client == _this.client));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PaymentReportLine;
  return Object.hash(runtimeType,_this.id,_this.paidOn,_this.amount,_this.method,_this.reference,_this.site,_this.client);
}

@override
String toString() {
  final _this = this as PaymentReportLine;
  return 'PaymentReportLine(id: ${_this.id}, paidOn: ${_this.paidOn}, amount: ${_this.amount}, method: ${_this.method}, reference: ${_this.reference}, site: ${_this.site}, client: ${_this.client})';
}


}

/// @nodoc
abstract mixin class $PaymentReportLineCopyWith<$Res>  {
  factory $PaymentReportLineCopyWith(PaymentReportLine value, $Res Function(PaymentReportLine) _then) = _$PaymentReportLineCopyWithImpl;
@useResult
$Res call({
 String id, String paidOn, String amount,@JsonKey(unknownEnumValue: PaymentMethod.other) PaymentMethod method, String? reference, IdName site, IdName client
});


$IdNameCopyWith<$Res> get site;$IdNameCopyWith<$Res> get client;

}
/// @nodoc
class _$PaymentReportLineCopyWithImpl<$Res>
    implements $PaymentReportLineCopyWith<$Res> {
  _$PaymentReportLineCopyWithImpl(this._self, this._then);

  final PaymentReportLine _self;
  final $Res Function(PaymentReportLine) _then;

/// Create a copy of PaymentReportLine
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? paidOn = null,Object? amount = null,Object? method = null,Object? reference = freezed,Object? site = null,Object? client = null,}) {
  return _then(PaymentReportLine(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,paidOn: null == paidOn ? _self.paidOn : paidOn // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as String,method: null == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as PaymentMethod,reference: freezed == reference ? _self.reference : reference // ignore: cast_nullable_to_non_nullable
as String?,site: null == site ? _self.site : site // ignore: cast_nullable_to_non_nullable
as IdName,client: null == client ? _self.client : client // ignore: cast_nullable_to_non_nullable
as IdName,
  ));
}
/// Create a copy of PaymentReportLine
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$IdNameCopyWith<$Res> get site {
  
  return $IdNameCopyWith<$Res>(_self.site, (value) {
    return _then(_self.copyWith(site: value));
  });
}/// Create a copy of PaymentReportLine
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$IdNameCopyWith<$Res> get client {
  
  return $IdNameCopyWith<$Res>(_self.client, (value) {
    return _then(_self.copyWith(client: value));
  });
}
}


/// Adds pattern-matching-related methods to [PaymentReportLine].
extension PaymentReportLinePatterns on PaymentReportLine {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PaymentReportLine value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PaymentReportLine() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PaymentReportLine value)  $default,){
final _that = this;
switch (_that) {
case _PaymentReportLine():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PaymentReportLine value)?  $default,){
final _that = this;
switch (_that) {
case _PaymentReportLine() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String paidOn,  String amount, @JsonKey(unknownEnumValue: PaymentMethod.other)  PaymentMethod method,  String? reference,  IdName site,  IdName client)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PaymentReportLine() when $default != null:
return $default(_that.id,_that.paidOn,_that.amount,_that.method,_that.reference,_that.site,_that.client);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String paidOn,  String amount, @JsonKey(unknownEnumValue: PaymentMethod.other)  PaymentMethod method,  String? reference,  IdName site,  IdName client)  $default,) {final _that = this;
switch (_that) {
case _PaymentReportLine():
return $default(_that.id,_that.paidOn,_that.amount,_that.method,_that.reference,_that.site,_that.client);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String paidOn,  String amount, @JsonKey(unknownEnumValue: PaymentMethod.other)  PaymentMethod method,  String? reference,  IdName site,  IdName client)?  $default,) {final _that = this;
switch (_that) {
case _PaymentReportLine() when $default != null:
return $default(_that.id,_that.paidOn,_that.amount,_that.method,_that.reference,_that.site,_that.client);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PaymentReportLine implements PaymentReportLine {
  const _PaymentReportLine({required this.id, required this.paidOn, required this.amount, @JsonKey(unknownEnumValue: PaymentMethod.other) required this.method, this.reference, required this.site, required this.client});
  factory _PaymentReportLine.fromJson(Map<String, dynamic> json) => _$PaymentReportLineFromJson(json);

@override final  String id;
@override final  String paidOn;
@override final  String amount;
@override@JsonKey(unknownEnumValue: PaymentMethod.other) final  PaymentMethod method;
@override final  String? reference;
@override final  IdName site;
@override final  IdName client;

/// Create a copy of PaymentReportLine
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PaymentReportLineCopyWith<_PaymentReportLine> get copyWith => __$PaymentReportLineCopyWithImpl<_PaymentReportLine>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PaymentReportLineToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PaymentReportLine&&(identical(other.id, id) || other.id == id)&&(identical(other.paidOn, paidOn) || other.paidOn == paidOn)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.method, method) || other.method == method)&&(identical(other.reference, reference) || other.reference == reference)&&(identical(other.site, site) || other.site == site)&&(identical(other.client, client) || other.client == client));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,paidOn,amount,method,reference,site,client);
}

@override
String toString() {
    return 'PaymentReportLine(id: $id, paidOn: $paidOn, amount: $amount, method: $method, reference: $reference, site: $site, client: $client)';
}


}

/// @nodoc
abstract mixin class _$PaymentReportLineCopyWith<$Res> implements $PaymentReportLineCopyWith<$Res> {
  factory _$PaymentReportLineCopyWith(_PaymentReportLine value, $Res Function(_PaymentReportLine) _then) = __$PaymentReportLineCopyWithImpl;
@override @useResult
$Res call({
 String id, String paidOn, String amount,@JsonKey(unknownEnumValue: PaymentMethod.other) PaymentMethod method, String? reference, IdName site, IdName client
});


@override $IdNameCopyWith<$Res> get site;@override $IdNameCopyWith<$Res> get client;

}
/// @nodoc
class __$PaymentReportLineCopyWithImpl<$Res>
    implements _$PaymentReportLineCopyWith<$Res> {
  __$PaymentReportLineCopyWithImpl(this._self, this._then);

  final _PaymentReportLine _self;
  final $Res Function(_PaymentReportLine) _then;

/// Create a copy of PaymentReportLine
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? paidOn = null,Object? amount = null,Object? method = null,Object? reference = freezed,Object? site = null,Object? client = null,}) {
  return _then(_PaymentReportLine(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,paidOn: null == paidOn ? _self.paidOn : paidOn // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as String,method: null == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as PaymentMethod,reference: freezed == reference ? _self.reference : reference // ignore: cast_nullable_to_non_nullable
as String?,site: null == site ? _self.site : site // ignore: cast_nullable_to_non_nullable
as IdName,client: null == client ? _self.client : client // ignore: cast_nullable_to_non_nullable
as IdName,
  ));
}

/// Create a copy of PaymentReportLine
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$IdNameCopyWith<$Res> get site {
  
  return $IdNameCopyWith<$Res>(_self.site, (value) {
    return _then(_self.copyWith(site: value));
  });
}/// Create a copy of PaymentReportLine
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$IdNameCopyWith<$Res> get client {
  
  return $IdNameCopyWith<$Res>(_self.client, (value) {
    return _then(_self.copyWith(client: value));
  });
}
}


/// @nodoc
mixin _$PaymentReport {

 PaymentReportTotals get totals; List<PaymentReportSite> get sites; List<PaymentReportLine> get payments;
/// Create a copy of PaymentReport
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaymentReportCopyWith<PaymentReport> get copyWith => _$PaymentReportCopyWithImpl<PaymentReport>(this as PaymentReport, _$identity);

  /// Serializes this PaymentReport to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PaymentReport;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaymentReport&&(identical(other.totals, _this.totals) || other.totals == _this.totals)&&const DeepCollectionEquality().equals(other.sites, _this.sites)&&const DeepCollectionEquality().equals(other.payments, _this.payments));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PaymentReport;
  return Object.hash(runtimeType,_this.totals,const DeepCollectionEquality().hash(_this.sites),const DeepCollectionEquality().hash(_this.payments));
}

@override
String toString() {
  final _this = this as PaymentReport;
  return 'PaymentReport(totals: ${_this.totals}, sites: ${_this.sites}, payments: ${_this.payments})';
}


}

/// @nodoc
abstract mixin class $PaymentReportCopyWith<$Res>  {
  factory $PaymentReportCopyWith(PaymentReport value, $Res Function(PaymentReport) _then) = _$PaymentReportCopyWithImpl;
@useResult
$Res call({
 PaymentReportTotals totals, List<PaymentReportSite> sites, List<PaymentReportLine> payments
});


$PaymentReportTotalsCopyWith<$Res> get totals;

}
/// @nodoc
class _$PaymentReportCopyWithImpl<$Res>
    implements $PaymentReportCopyWith<$Res> {
  _$PaymentReportCopyWithImpl(this._self, this._then);

  final PaymentReport _self;
  final $Res Function(PaymentReport) _then;

/// Create a copy of PaymentReport
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? totals = null,Object? sites = null,Object? payments = null,}) {
  return _then(PaymentReport(
totals: null == totals ? _self.totals : totals // ignore: cast_nullable_to_non_nullable
as PaymentReportTotals,sites: null == sites ? _self.sites : sites // ignore: cast_nullable_to_non_nullable
as List<PaymentReportSite>,payments: null == payments ? _self.payments : payments // ignore: cast_nullable_to_non_nullable
as List<PaymentReportLine>,
  ));
}
/// Create a copy of PaymentReport
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PaymentReportTotalsCopyWith<$Res> get totals {
  
  return $PaymentReportTotalsCopyWith<$Res>(_self.totals, (value) {
    return _then(_self.copyWith(totals: value));
  });
}
}


/// Adds pattern-matching-related methods to [PaymentReport].
extension PaymentReportPatterns on PaymentReport {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PaymentReport value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PaymentReport() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PaymentReport value)  $default,){
final _that = this;
switch (_that) {
case _PaymentReport():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PaymentReport value)?  $default,){
final _that = this;
switch (_that) {
case _PaymentReport() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( PaymentReportTotals totals,  List<PaymentReportSite> sites,  List<PaymentReportLine> payments)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PaymentReport() when $default != null:
return $default(_that.totals,_that.sites,_that.payments);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( PaymentReportTotals totals,  List<PaymentReportSite> sites,  List<PaymentReportLine> payments)  $default,) {final _that = this;
switch (_that) {
case _PaymentReport():
return $default(_that.totals,_that.sites,_that.payments);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( PaymentReportTotals totals,  List<PaymentReportSite> sites,  List<PaymentReportLine> payments)?  $default,) {final _that = this;
switch (_that) {
case _PaymentReport() when $default != null:
return $default(_that.totals,_that.sites,_that.payments);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PaymentReport implements PaymentReport {
  const _PaymentReport({required this.totals, required  List<PaymentReportSite> sites, required  List<PaymentReportLine> payments}): _sites = sites,_payments = payments;
  factory _PaymentReport.fromJson(Map<String, dynamic> json) => _$PaymentReportFromJson(json);

@override final  PaymentReportTotals totals;
 final  List<PaymentReportSite> _sites;
@override List<PaymentReportSite> get sites {
  if (_sites is EqualUnmodifiableListView) return _sites;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sites);
}

 final  List<PaymentReportLine> _payments;
@override List<PaymentReportLine> get payments {
  if (_payments is EqualUnmodifiableListView) return _payments;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_payments);
}


/// Create a copy of PaymentReport
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PaymentReportCopyWith<_PaymentReport> get copyWith => __$PaymentReportCopyWithImpl<_PaymentReport>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PaymentReportToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PaymentReport&&(identical(other.totals, totals) || other.totals == totals)&&const DeepCollectionEquality().equals(other.sites, _sites)&&const DeepCollectionEquality().equals(other.payments, _payments));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,totals,const DeepCollectionEquality().hash(_sites),const DeepCollectionEquality().hash(_payments));
}

@override
String toString() {
    return 'PaymentReport(totals: $totals, sites: $sites, payments: $payments)';
}


}

/// @nodoc
abstract mixin class _$PaymentReportCopyWith<$Res> implements $PaymentReportCopyWith<$Res> {
  factory _$PaymentReportCopyWith(_PaymentReport value, $Res Function(_PaymentReport) _then) = __$PaymentReportCopyWithImpl;
@override @useResult
$Res call({
 PaymentReportTotals totals, List<PaymentReportSite> sites, List<PaymentReportLine> payments
});


@override $PaymentReportTotalsCopyWith<$Res> get totals;

}
/// @nodoc
class __$PaymentReportCopyWithImpl<$Res>
    implements _$PaymentReportCopyWith<$Res> {
  __$PaymentReportCopyWithImpl(this._self, this._then);

  final _PaymentReport _self;
  final $Res Function(_PaymentReport) _then;

/// Create a copy of PaymentReport
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? totals = null,Object? sites = null,Object? payments = null,}) {
  return _then(_PaymentReport(
totals: null == totals ? _self.totals : totals // ignore: cast_nullable_to_non_nullable
as PaymentReportTotals,sites: null == sites ? _self._sites : sites // ignore: cast_nullable_to_non_nullable
as List<PaymentReportSite>,payments: null == payments ? _self._payments : payments // ignore: cast_nullable_to_non_nullable
as List<PaymentReportLine>,
  ));
}

/// Create a copy of PaymentReport
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PaymentReportTotalsCopyWith<$Res> get totals {
  
  return $PaymentReportTotalsCopyWith<$Res>(_self.totals, (value) {
    return _then(_self.copyWith(totals: value));
  });
}
}

// dart format on
