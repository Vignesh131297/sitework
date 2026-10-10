// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'person_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PersonSummary {

 String get id; UserRole get role; String get name; String get phone; String? get email; String get employeeCode; Designation? get designation; String? get joiningDate; bool get isActive; DateTime? get lastLoginAt; List<SiteRef> get sites; int get staffCount; StaffAssignmentInfo? get assignment;/// Godown managers: the godowns they run.
 List<IdName> get godowns;
/// Create a copy of PersonSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PersonSummaryCopyWith<PersonSummary> get copyWith => _$PersonSummaryCopyWithImpl<PersonSummary>(this as PersonSummary, _$identity);

  /// Serializes this PersonSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PersonSummary;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PersonSummary&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.role, _this.role) || other.role == _this.role)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.phone, _this.phone) || other.phone == _this.phone)&&(identical(other.email, _this.email) || other.email == _this.email)&&(identical(other.employeeCode, _this.employeeCode) || other.employeeCode == _this.employeeCode)&&(identical(other.designation, _this.designation) || other.designation == _this.designation)&&(identical(other.joiningDate, _this.joiningDate) || other.joiningDate == _this.joiningDate)&&(identical(other.isActive, _this.isActive) || other.isActive == _this.isActive)&&(identical(other.lastLoginAt, _this.lastLoginAt) || other.lastLoginAt == _this.lastLoginAt)&&const DeepCollectionEquality().equals(other.sites, _this.sites)&&(identical(other.staffCount, _this.staffCount) || other.staffCount == _this.staffCount)&&(identical(other.assignment, _this.assignment) || other.assignment == _this.assignment)&&const DeepCollectionEquality().equals(other.godowns, _this.godowns));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PersonSummary;
  return Object.hash(runtimeType,_this.id,_this.role,_this.name,_this.phone,_this.email,_this.employeeCode,_this.designation,_this.joiningDate,_this.isActive,_this.lastLoginAt,const DeepCollectionEquality().hash(_this.sites),_this.staffCount,_this.assignment,const DeepCollectionEquality().hash(_this.godowns));
}

@override
String toString() {
  final _this = this as PersonSummary;
  return 'PersonSummary(id: ${_this.id}, role: ${_this.role}, name: ${_this.name}, phone: ${_this.phone}, email: ${_this.email}, employeeCode: ${_this.employeeCode}, designation: ${_this.designation}, joiningDate: ${_this.joiningDate}, isActive: ${_this.isActive}, lastLoginAt: ${_this.lastLoginAt}, sites: ${_this.sites}, staffCount: ${_this.staffCount}, assignment: ${_this.assignment}, godowns: ${_this.godowns})';
}


}

/// @nodoc
abstract mixin class $PersonSummaryCopyWith<$Res>  {
  factory $PersonSummaryCopyWith(PersonSummary value, $Res Function(PersonSummary) _then) = _$PersonSummaryCopyWithImpl;
@useResult
$Res call({
 String id, UserRole role, String name, String phone, String? email, String employeeCode, Designation? designation, String? joiningDate, bool isActive, DateTime? lastLoginAt, List<SiteRef> sites, int staffCount, StaffAssignmentInfo? assignment, List<IdName> godowns
});


$StaffAssignmentInfoCopyWith<$Res>? get assignment;

}
/// @nodoc
class _$PersonSummaryCopyWithImpl<$Res>
    implements $PersonSummaryCopyWith<$Res> {
  _$PersonSummaryCopyWithImpl(this._self, this._then);

  final PersonSummary _self;
  final $Res Function(PersonSummary) _then;

/// Create a copy of PersonSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? role = null,Object? name = null,Object? phone = null,Object? email = freezed,Object? employeeCode = null,Object? designation = freezed,Object? joiningDate = freezed,Object? isActive = null,Object? lastLoginAt = freezed,Object? sites = null,Object? staffCount = null,Object? assignment = freezed,Object? godowns = null,}) {
  return _then(PersonSummary(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as UserRole,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,employeeCode: null == employeeCode ? _self.employeeCode : employeeCode // ignore: cast_nullable_to_non_nullable
as String,designation: freezed == designation ? _self.designation : designation // ignore: cast_nullable_to_non_nullable
as Designation?,joiningDate: freezed == joiningDate ? _self.joiningDate : joiningDate // ignore: cast_nullable_to_non_nullable
as String?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,lastLoginAt: freezed == lastLoginAt ? _self.lastLoginAt : lastLoginAt // ignore: cast_nullable_to_non_nullable
as DateTime?,sites: null == sites ? _self.sites : sites // ignore: cast_nullable_to_non_nullable
as List<SiteRef>,staffCount: null == staffCount ? _self.staffCount : staffCount // ignore: cast_nullable_to_non_nullable
as int,assignment: freezed == assignment ? _self.assignment : assignment // ignore: cast_nullable_to_non_nullable
as StaffAssignmentInfo?,godowns: null == godowns ? _self.godowns : godowns // ignore: cast_nullable_to_non_nullable
as List<IdName>,
  ));
}
/// Create a copy of PersonSummary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StaffAssignmentInfoCopyWith<$Res>? get assignment {
    if (_self.assignment == null) {
    return null;
  }

  return $StaffAssignmentInfoCopyWith<$Res>(_self.assignment!, (value) {
    return _then(_self.copyWith(assignment: value));
  });
}
}


/// Adds pattern-matching-related methods to [PersonSummary].
extension PersonSummaryPatterns on PersonSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PersonSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PersonSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PersonSummary value)  $default,){
final _that = this;
switch (_that) {
case _PersonSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PersonSummary value)?  $default,){
final _that = this;
switch (_that) {
case _PersonSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  UserRole role,  String name,  String phone,  String? email,  String employeeCode,  Designation? designation,  String? joiningDate,  bool isActive,  DateTime? lastLoginAt,  List<SiteRef> sites,  int staffCount,  StaffAssignmentInfo? assignment,  List<IdName> godowns)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PersonSummary() when $default != null:
return $default(_that.id,_that.role,_that.name,_that.phone,_that.email,_that.employeeCode,_that.designation,_that.joiningDate,_that.isActive,_that.lastLoginAt,_that.sites,_that.staffCount,_that.assignment,_that.godowns);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  UserRole role,  String name,  String phone,  String? email,  String employeeCode,  Designation? designation,  String? joiningDate,  bool isActive,  DateTime? lastLoginAt,  List<SiteRef> sites,  int staffCount,  StaffAssignmentInfo? assignment,  List<IdName> godowns)  $default,) {final _that = this;
switch (_that) {
case _PersonSummary():
return $default(_that.id,_that.role,_that.name,_that.phone,_that.email,_that.employeeCode,_that.designation,_that.joiningDate,_that.isActive,_that.lastLoginAt,_that.sites,_that.staffCount,_that.assignment,_that.godowns);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  UserRole role,  String name,  String phone,  String? email,  String employeeCode,  Designation? designation,  String? joiningDate,  bool isActive,  DateTime? lastLoginAt,  List<SiteRef> sites,  int staffCount,  StaffAssignmentInfo? assignment,  List<IdName> godowns)?  $default,) {final _that = this;
switch (_that) {
case _PersonSummary() when $default != null:
return $default(_that.id,_that.role,_that.name,_that.phone,_that.email,_that.employeeCode,_that.designation,_that.joiningDate,_that.isActive,_that.lastLoginAt,_that.sites,_that.staffCount,_that.assignment,_that.godowns);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PersonSummary implements PersonSummary {
  const _PersonSummary({required this.id, required this.role, required this.name, required this.phone, this.email, required this.employeeCode, this.designation, this.joiningDate, required this.isActive, this.lastLoginAt,  List<SiteRef> sites = const <SiteRef>[], this.staffCount = 0, this.assignment,  List<IdName> godowns = const <IdName>[]}): _sites = sites,_godowns = godowns;
  factory _PersonSummary.fromJson(Map<String, dynamic> json) => _$PersonSummaryFromJson(json);

@override final  String id;
@override final  UserRole role;
@override final  String name;
@override final  String phone;
@override final  String? email;
@override final  String employeeCode;
@override final  Designation? designation;
@override final  String? joiningDate;
@override final  bool isActive;
@override final  DateTime? lastLoginAt;
 final  List<SiteRef> _sites;
@override@JsonKey() List<SiteRef> get sites {
  if (_sites is EqualUnmodifiableListView) return _sites;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sites);
}

@override@JsonKey() final  int staffCount;
@override final  StaffAssignmentInfo? assignment;
/// Godown managers: the godowns they run.
 final  List<IdName> _godowns;
/// Godown managers: the godowns they run.
@override@JsonKey() List<IdName> get godowns {
  if (_godowns is EqualUnmodifiableListView) return _godowns;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_godowns);
}


/// Create a copy of PersonSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PersonSummaryCopyWith<_PersonSummary> get copyWith => __$PersonSummaryCopyWithImpl<_PersonSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PersonSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PersonSummary&&(identical(other.id, id) || other.id == id)&&(identical(other.role, role) || other.role == role)&&(identical(other.name, name) || other.name == name)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.email, email) || other.email == email)&&(identical(other.employeeCode, employeeCode) || other.employeeCode == employeeCode)&&(identical(other.designation, designation) || other.designation == designation)&&(identical(other.joiningDate, joiningDate) || other.joiningDate == joiningDate)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.lastLoginAt, lastLoginAt) || other.lastLoginAt == lastLoginAt)&&const DeepCollectionEquality().equals(other.sites, _sites)&&(identical(other.staffCount, staffCount) || other.staffCount == staffCount)&&(identical(other.assignment, assignment) || other.assignment == assignment)&&const DeepCollectionEquality().equals(other.godowns, _godowns));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,role,name,phone,email,employeeCode,designation,joiningDate,isActive,lastLoginAt,const DeepCollectionEquality().hash(_sites),staffCount,assignment,const DeepCollectionEquality().hash(_godowns));
}

@override
String toString() {
    return 'PersonSummary(id: $id, role: $role, name: $name, phone: $phone, email: $email, employeeCode: $employeeCode, designation: $designation, joiningDate: $joiningDate, isActive: $isActive, lastLoginAt: $lastLoginAt, sites: $sites, staffCount: $staffCount, assignment: $assignment, godowns: $godowns)';
}


}

/// @nodoc
abstract mixin class _$PersonSummaryCopyWith<$Res> implements $PersonSummaryCopyWith<$Res> {
  factory _$PersonSummaryCopyWith(_PersonSummary value, $Res Function(_PersonSummary) _then) = __$PersonSummaryCopyWithImpl;
@override @useResult
$Res call({
 String id, UserRole role, String name, String phone, String? email, String employeeCode, Designation? designation, String? joiningDate, bool isActive, DateTime? lastLoginAt, List<SiteRef> sites, int staffCount, StaffAssignmentInfo? assignment, List<IdName> godowns
});


@override $StaffAssignmentInfoCopyWith<$Res>? get assignment;

}
/// @nodoc
class __$PersonSummaryCopyWithImpl<$Res>
    implements _$PersonSummaryCopyWith<$Res> {
  __$PersonSummaryCopyWithImpl(this._self, this._then);

  final _PersonSummary _self;
  final $Res Function(_PersonSummary) _then;

/// Create a copy of PersonSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? role = null,Object? name = null,Object? phone = null,Object? email = freezed,Object? employeeCode = null,Object? designation = freezed,Object? joiningDate = freezed,Object? isActive = null,Object? lastLoginAt = freezed,Object? sites = null,Object? staffCount = null,Object? assignment = freezed,Object? godowns = null,}) {
  return _then(_PersonSummary(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as UserRole,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,employeeCode: null == employeeCode ? _self.employeeCode : employeeCode // ignore: cast_nullable_to_non_nullable
as String,designation: freezed == designation ? _self.designation : designation // ignore: cast_nullable_to_non_nullable
as Designation?,joiningDate: freezed == joiningDate ? _self.joiningDate : joiningDate // ignore: cast_nullable_to_non_nullable
as String?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,lastLoginAt: freezed == lastLoginAt ? _self.lastLoginAt : lastLoginAt // ignore: cast_nullable_to_non_nullable
as DateTime?,sites: null == sites ? _self._sites : sites // ignore: cast_nullable_to_non_nullable
as List<SiteRef>,staffCount: null == staffCount ? _self.staffCount : staffCount // ignore: cast_nullable_to_non_nullable
as int,assignment: freezed == assignment ? _self.assignment : assignment // ignore: cast_nullable_to_non_nullable
as StaffAssignmentInfo?,godowns: null == godowns ? _self._godowns : godowns // ignore: cast_nullable_to_non_nullable
as List<IdName>,
  ));
}

/// Create a copy of PersonSummary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StaffAssignmentInfoCopyWith<$Res>? get assignment {
    if (_self.assignment == null) {
    return null;
  }

  return $StaffAssignmentInfoCopyWith<$Res>(_self.assignment!, (value) {
    return _then(_self.copyWith(assignment: value));
  });
}
}


/// @nodoc
mixin _$SupervisedStaff {

 String get id; String get name; Designation? get designation; IdName get site;
/// Create a copy of SupervisedStaff
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SupervisedStaffCopyWith<SupervisedStaff> get copyWith => _$SupervisedStaffCopyWithImpl<SupervisedStaff>(this as SupervisedStaff, _$identity);

  /// Serializes this SupervisedStaff to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as SupervisedStaff;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SupervisedStaff&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.designation, _this.designation) || other.designation == _this.designation)&&(identical(other.site, _this.site) || other.site == _this.site));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as SupervisedStaff;
  return Object.hash(runtimeType,_this.id,_this.name,_this.designation,_this.site);
}

@override
String toString() {
  final _this = this as SupervisedStaff;
  return 'SupervisedStaff(id: ${_this.id}, name: ${_this.name}, designation: ${_this.designation}, site: ${_this.site})';
}


}

/// @nodoc
abstract mixin class $SupervisedStaffCopyWith<$Res>  {
  factory $SupervisedStaffCopyWith(SupervisedStaff value, $Res Function(SupervisedStaff) _then) = _$SupervisedStaffCopyWithImpl;
@useResult
$Res call({
 String id, String name, Designation? designation, IdName site
});


$IdNameCopyWith<$Res> get site;

}
/// @nodoc
class _$SupervisedStaffCopyWithImpl<$Res>
    implements $SupervisedStaffCopyWith<$Res> {
  _$SupervisedStaffCopyWithImpl(this._self, this._then);

  final SupervisedStaff _self;
  final $Res Function(SupervisedStaff) _then;

/// Create a copy of SupervisedStaff
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? designation = freezed,Object? site = null,}) {
  return _then(SupervisedStaff(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,designation: freezed == designation ? _self.designation : designation // ignore: cast_nullable_to_non_nullable
as Designation?,site: null == site ? _self.site : site // ignore: cast_nullable_to_non_nullable
as IdName,
  ));
}
/// Create a copy of SupervisedStaff
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$IdNameCopyWith<$Res> get site {
  
  return $IdNameCopyWith<$Res>(_self.site, (value) {
    return _then(_self.copyWith(site: value));
  });
}
}


/// Adds pattern-matching-related methods to [SupervisedStaff].
extension SupervisedStaffPatterns on SupervisedStaff {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SupervisedStaff value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SupervisedStaff() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SupervisedStaff value)  $default,){
final _that = this;
switch (_that) {
case _SupervisedStaff():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SupervisedStaff value)?  $default,){
final _that = this;
switch (_that) {
case _SupervisedStaff() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  Designation? designation,  IdName site)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SupervisedStaff() when $default != null:
return $default(_that.id,_that.name,_that.designation,_that.site);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  Designation? designation,  IdName site)  $default,) {final _that = this;
switch (_that) {
case _SupervisedStaff():
return $default(_that.id,_that.name,_that.designation,_that.site);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  Designation? designation,  IdName site)?  $default,) {final _that = this;
switch (_that) {
case _SupervisedStaff() when $default != null:
return $default(_that.id,_that.name,_that.designation,_that.site);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SupervisedStaff implements SupervisedStaff {
  const _SupervisedStaff({required this.id, required this.name, this.designation, required this.site});
  factory _SupervisedStaff.fromJson(Map<String, dynamic> json) => _$SupervisedStaffFromJson(json);

@override final  String id;
@override final  String name;
@override final  Designation? designation;
@override final  IdName site;

/// Create a copy of SupervisedStaff
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SupervisedStaffCopyWith<_SupervisedStaff> get copyWith => __$SupervisedStaffCopyWithImpl<_SupervisedStaff>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SupervisedStaffToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SupervisedStaff&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.designation, designation) || other.designation == designation)&&(identical(other.site, site) || other.site == site));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,designation,site);
}

@override
String toString() {
    return 'SupervisedStaff(id: $id, name: $name, designation: $designation, site: $site)';
}


}

/// @nodoc
abstract mixin class _$SupervisedStaffCopyWith<$Res> implements $SupervisedStaffCopyWith<$Res> {
  factory _$SupervisedStaffCopyWith(_SupervisedStaff value, $Res Function(_SupervisedStaff) _then) = __$SupervisedStaffCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, Designation? designation, IdName site
});


@override $IdNameCopyWith<$Res> get site;

}
/// @nodoc
class __$SupervisedStaffCopyWithImpl<$Res>
    implements _$SupervisedStaffCopyWith<$Res> {
  __$SupervisedStaffCopyWithImpl(this._self, this._then);

  final _SupervisedStaff _self;
  final $Res Function(_SupervisedStaff) _then;

/// Create a copy of SupervisedStaff
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? designation = freezed,Object? site = null,}) {
  return _then(_SupervisedStaff(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,designation: freezed == designation ? _self.designation : designation // ignore: cast_nullable_to_non_nullable
as Designation?,site: null == site ? _self.site : site // ignore: cast_nullable_to_non_nullable
as IdName,
  ));
}

/// Create a copy of SupervisedStaff
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$IdNameCopyWith<$Res> get site {
  
  return $IdNameCopyWith<$Res>(_self.site, (value) {
    return _then(_self.copyWith(site: value));
  });
}
}


/// @nodoc
mixin _$PersonDetail {

 String get id; UserRole get role; String get name; String get phone; String? get email; String get employeeCode; Designation? get designation; String? get joiningDate; bool get isActive; DateTime? get lastLoginAt; List<SiteRef> get sites; int get staffCount; StaffAssignmentInfo? get assignment; bool get mustChangePassword; List<SupervisedStaff> get supervisedStaff;/// Godown managers: the godowns they run.
 List<IdName> get godowns;
/// Create a copy of PersonDetail
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PersonDetailCopyWith<PersonDetail> get copyWith => _$PersonDetailCopyWithImpl<PersonDetail>(this as PersonDetail, _$identity);

  /// Serializes this PersonDetail to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PersonDetail;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PersonDetail&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.role, _this.role) || other.role == _this.role)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.phone, _this.phone) || other.phone == _this.phone)&&(identical(other.email, _this.email) || other.email == _this.email)&&(identical(other.employeeCode, _this.employeeCode) || other.employeeCode == _this.employeeCode)&&(identical(other.designation, _this.designation) || other.designation == _this.designation)&&(identical(other.joiningDate, _this.joiningDate) || other.joiningDate == _this.joiningDate)&&(identical(other.isActive, _this.isActive) || other.isActive == _this.isActive)&&(identical(other.lastLoginAt, _this.lastLoginAt) || other.lastLoginAt == _this.lastLoginAt)&&const DeepCollectionEquality().equals(other.sites, _this.sites)&&(identical(other.staffCount, _this.staffCount) || other.staffCount == _this.staffCount)&&(identical(other.assignment, _this.assignment) || other.assignment == _this.assignment)&&(identical(other.mustChangePassword, _this.mustChangePassword) || other.mustChangePassword == _this.mustChangePassword)&&const DeepCollectionEquality().equals(other.supervisedStaff, _this.supervisedStaff)&&const DeepCollectionEquality().equals(other.godowns, _this.godowns));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PersonDetail;
  return Object.hash(runtimeType,_this.id,_this.role,_this.name,_this.phone,_this.email,_this.employeeCode,_this.designation,_this.joiningDate,_this.isActive,_this.lastLoginAt,const DeepCollectionEquality().hash(_this.sites),_this.staffCount,_this.assignment,_this.mustChangePassword,const DeepCollectionEquality().hash(_this.supervisedStaff),const DeepCollectionEquality().hash(_this.godowns));
}

@override
String toString() {
  final _this = this as PersonDetail;
  return 'PersonDetail(id: ${_this.id}, role: ${_this.role}, name: ${_this.name}, phone: ${_this.phone}, email: ${_this.email}, employeeCode: ${_this.employeeCode}, designation: ${_this.designation}, joiningDate: ${_this.joiningDate}, isActive: ${_this.isActive}, lastLoginAt: ${_this.lastLoginAt}, sites: ${_this.sites}, staffCount: ${_this.staffCount}, assignment: ${_this.assignment}, mustChangePassword: ${_this.mustChangePassword}, supervisedStaff: ${_this.supervisedStaff}, godowns: ${_this.godowns})';
}


}

/// @nodoc
abstract mixin class $PersonDetailCopyWith<$Res>  {
  factory $PersonDetailCopyWith(PersonDetail value, $Res Function(PersonDetail) _then) = _$PersonDetailCopyWithImpl;
@useResult
$Res call({
 String id, UserRole role, String name, String phone, String? email, String employeeCode, Designation? designation, String? joiningDate, bool isActive, DateTime? lastLoginAt, List<SiteRef> sites, int staffCount, StaffAssignmentInfo? assignment, bool mustChangePassword, List<SupervisedStaff> supervisedStaff, List<IdName> godowns
});


$StaffAssignmentInfoCopyWith<$Res>? get assignment;

}
/// @nodoc
class _$PersonDetailCopyWithImpl<$Res>
    implements $PersonDetailCopyWith<$Res> {
  _$PersonDetailCopyWithImpl(this._self, this._then);

  final PersonDetail _self;
  final $Res Function(PersonDetail) _then;

/// Create a copy of PersonDetail
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? role = null,Object? name = null,Object? phone = null,Object? email = freezed,Object? employeeCode = null,Object? designation = freezed,Object? joiningDate = freezed,Object? isActive = null,Object? lastLoginAt = freezed,Object? sites = null,Object? staffCount = null,Object? assignment = freezed,Object? mustChangePassword = null,Object? supervisedStaff = null,Object? godowns = null,}) {
  return _then(PersonDetail(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as UserRole,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,employeeCode: null == employeeCode ? _self.employeeCode : employeeCode // ignore: cast_nullable_to_non_nullable
as String,designation: freezed == designation ? _self.designation : designation // ignore: cast_nullable_to_non_nullable
as Designation?,joiningDate: freezed == joiningDate ? _self.joiningDate : joiningDate // ignore: cast_nullable_to_non_nullable
as String?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,lastLoginAt: freezed == lastLoginAt ? _self.lastLoginAt : lastLoginAt // ignore: cast_nullable_to_non_nullable
as DateTime?,sites: null == sites ? _self.sites : sites // ignore: cast_nullable_to_non_nullable
as List<SiteRef>,staffCount: null == staffCount ? _self.staffCount : staffCount // ignore: cast_nullable_to_non_nullable
as int,assignment: freezed == assignment ? _self.assignment : assignment // ignore: cast_nullable_to_non_nullable
as StaffAssignmentInfo?,mustChangePassword: null == mustChangePassword ? _self.mustChangePassword : mustChangePassword // ignore: cast_nullable_to_non_nullable
as bool,supervisedStaff: null == supervisedStaff ? _self.supervisedStaff : supervisedStaff // ignore: cast_nullable_to_non_nullable
as List<SupervisedStaff>,godowns: null == godowns ? _self.godowns : godowns // ignore: cast_nullable_to_non_nullable
as List<IdName>,
  ));
}
/// Create a copy of PersonDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StaffAssignmentInfoCopyWith<$Res>? get assignment {
    if (_self.assignment == null) {
    return null;
  }

  return $StaffAssignmentInfoCopyWith<$Res>(_self.assignment!, (value) {
    return _then(_self.copyWith(assignment: value));
  });
}
}


/// Adds pattern-matching-related methods to [PersonDetail].
extension PersonDetailPatterns on PersonDetail {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PersonDetail value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PersonDetail() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PersonDetail value)  $default,){
final _that = this;
switch (_that) {
case _PersonDetail():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PersonDetail value)?  $default,){
final _that = this;
switch (_that) {
case _PersonDetail() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  UserRole role,  String name,  String phone,  String? email,  String employeeCode,  Designation? designation,  String? joiningDate,  bool isActive,  DateTime? lastLoginAt,  List<SiteRef> sites,  int staffCount,  StaffAssignmentInfo? assignment,  bool mustChangePassword,  List<SupervisedStaff> supervisedStaff,  List<IdName> godowns)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PersonDetail() when $default != null:
return $default(_that.id,_that.role,_that.name,_that.phone,_that.email,_that.employeeCode,_that.designation,_that.joiningDate,_that.isActive,_that.lastLoginAt,_that.sites,_that.staffCount,_that.assignment,_that.mustChangePassword,_that.supervisedStaff,_that.godowns);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  UserRole role,  String name,  String phone,  String? email,  String employeeCode,  Designation? designation,  String? joiningDate,  bool isActive,  DateTime? lastLoginAt,  List<SiteRef> sites,  int staffCount,  StaffAssignmentInfo? assignment,  bool mustChangePassword,  List<SupervisedStaff> supervisedStaff,  List<IdName> godowns)  $default,) {final _that = this;
switch (_that) {
case _PersonDetail():
return $default(_that.id,_that.role,_that.name,_that.phone,_that.email,_that.employeeCode,_that.designation,_that.joiningDate,_that.isActive,_that.lastLoginAt,_that.sites,_that.staffCount,_that.assignment,_that.mustChangePassword,_that.supervisedStaff,_that.godowns);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  UserRole role,  String name,  String phone,  String? email,  String employeeCode,  Designation? designation,  String? joiningDate,  bool isActive,  DateTime? lastLoginAt,  List<SiteRef> sites,  int staffCount,  StaffAssignmentInfo? assignment,  bool mustChangePassword,  List<SupervisedStaff> supervisedStaff,  List<IdName> godowns)?  $default,) {final _that = this;
switch (_that) {
case _PersonDetail() when $default != null:
return $default(_that.id,_that.role,_that.name,_that.phone,_that.email,_that.employeeCode,_that.designation,_that.joiningDate,_that.isActive,_that.lastLoginAt,_that.sites,_that.staffCount,_that.assignment,_that.mustChangePassword,_that.supervisedStaff,_that.godowns);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PersonDetail implements PersonDetail {
  const _PersonDetail({required this.id, required this.role, required this.name, required this.phone, this.email, required this.employeeCode, this.designation, this.joiningDate, required this.isActive, this.lastLoginAt,  List<SiteRef> sites = const <SiteRef>[], this.staffCount = 0, this.assignment, required this.mustChangePassword,  List<SupervisedStaff> supervisedStaff = const <SupervisedStaff>[],  List<IdName> godowns = const <IdName>[]}): _sites = sites,_supervisedStaff = supervisedStaff,_godowns = godowns;
  factory _PersonDetail.fromJson(Map<String, dynamic> json) => _$PersonDetailFromJson(json);

@override final  String id;
@override final  UserRole role;
@override final  String name;
@override final  String phone;
@override final  String? email;
@override final  String employeeCode;
@override final  Designation? designation;
@override final  String? joiningDate;
@override final  bool isActive;
@override final  DateTime? lastLoginAt;
 final  List<SiteRef> _sites;
@override@JsonKey() List<SiteRef> get sites {
  if (_sites is EqualUnmodifiableListView) return _sites;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sites);
}

@override@JsonKey() final  int staffCount;
@override final  StaffAssignmentInfo? assignment;
@override final  bool mustChangePassword;
 final  List<SupervisedStaff> _supervisedStaff;
@override@JsonKey() List<SupervisedStaff> get supervisedStaff {
  if (_supervisedStaff is EqualUnmodifiableListView) return _supervisedStaff;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_supervisedStaff);
}

/// Godown managers: the godowns they run.
 final  List<IdName> _godowns;
/// Godown managers: the godowns they run.
@override@JsonKey() List<IdName> get godowns {
  if (_godowns is EqualUnmodifiableListView) return _godowns;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_godowns);
}


/// Create a copy of PersonDetail
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PersonDetailCopyWith<_PersonDetail> get copyWith => __$PersonDetailCopyWithImpl<_PersonDetail>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PersonDetailToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PersonDetail&&(identical(other.id, id) || other.id == id)&&(identical(other.role, role) || other.role == role)&&(identical(other.name, name) || other.name == name)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.email, email) || other.email == email)&&(identical(other.employeeCode, employeeCode) || other.employeeCode == employeeCode)&&(identical(other.designation, designation) || other.designation == designation)&&(identical(other.joiningDate, joiningDate) || other.joiningDate == joiningDate)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.lastLoginAt, lastLoginAt) || other.lastLoginAt == lastLoginAt)&&const DeepCollectionEquality().equals(other.sites, _sites)&&(identical(other.staffCount, staffCount) || other.staffCount == staffCount)&&(identical(other.assignment, assignment) || other.assignment == assignment)&&(identical(other.mustChangePassword, mustChangePassword) || other.mustChangePassword == mustChangePassword)&&const DeepCollectionEquality().equals(other.supervisedStaff, _supervisedStaff)&&const DeepCollectionEquality().equals(other.godowns, _godowns));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,role,name,phone,email,employeeCode,designation,joiningDate,isActive,lastLoginAt,const DeepCollectionEquality().hash(_sites),staffCount,assignment,mustChangePassword,const DeepCollectionEquality().hash(_supervisedStaff),const DeepCollectionEquality().hash(_godowns));
}

@override
String toString() {
    return 'PersonDetail(id: $id, role: $role, name: $name, phone: $phone, email: $email, employeeCode: $employeeCode, designation: $designation, joiningDate: $joiningDate, isActive: $isActive, lastLoginAt: $lastLoginAt, sites: $sites, staffCount: $staffCount, assignment: $assignment, mustChangePassword: $mustChangePassword, supervisedStaff: $supervisedStaff, godowns: $godowns)';
}


}

/// @nodoc
abstract mixin class _$PersonDetailCopyWith<$Res> implements $PersonDetailCopyWith<$Res> {
  factory _$PersonDetailCopyWith(_PersonDetail value, $Res Function(_PersonDetail) _then) = __$PersonDetailCopyWithImpl;
@override @useResult
$Res call({
 String id, UserRole role, String name, String phone, String? email, String employeeCode, Designation? designation, String? joiningDate, bool isActive, DateTime? lastLoginAt, List<SiteRef> sites, int staffCount, StaffAssignmentInfo? assignment, bool mustChangePassword, List<SupervisedStaff> supervisedStaff, List<IdName> godowns
});


@override $StaffAssignmentInfoCopyWith<$Res>? get assignment;

}
/// @nodoc
class __$PersonDetailCopyWithImpl<$Res>
    implements _$PersonDetailCopyWith<$Res> {
  __$PersonDetailCopyWithImpl(this._self, this._then);

  final _PersonDetail _self;
  final $Res Function(_PersonDetail) _then;

/// Create a copy of PersonDetail
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? role = null,Object? name = null,Object? phone = null,Object? email = freezed,Object? employeeCode = null,Object? designation = freezed,Object? joiningDate = freezed,Object? isActive = null,Object? lastLoginAt = freezed,Object? sites = null,Object? staffCount = null,Object? assignment = freezed,Object? mustChangePassword = null,Object? supervisedStaff = null,Object? godowns = null,}) {
  return _then(_PersonDetail(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as UserRole,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,employeeCode: null == employeeCode ? _self.employeeCode : employeeCode // ignore: cast_nullable_to_non_nullable
as String,designation: freezed == designation ? _self.designation : designation // ignore: cast_nullable_to_non_nullable
as Designation?,joiningDate: freezed == joiningDate ? _self.joiningDate : joiningDate // ignore: cast_nullable_to_non_nullable
as String?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,lastLoginAt: freezed == lastLoginAt ? _self.lastLoginAt : lastLoginAt // ignore: cast_nullable_to_non_nullable
as DateTime?,sites: null == sites ? _self._sites : sites // ignore: cast_nullable_to_non_nullable
as List<SiteRef>,staffCount: null == staffCount ? _self.staffCount : staffCount // ignore: cast_nullable_to_non_nullable
as int,assignment: freezed == assignment ? _self.assignment : assignment // ignore: cast_nullable_to_non_nullable
as StaffAssignmentInfo?,mustChangePassword: null == mustChangePassword ? _self.mustChangePassword : mustChangePassword // ignore: cast_nullable_to_non_nullable
as bool,supervisedStaff: null == supervisedStaff ? _self._supervisedStaff : supervisedStaff // ignore: cast_nullable_to_non_nullable
as List<SupervisedStaff>,godowns: null == godowns ? _self._godowns : godowns // ignore: cast_nullable_to_non_nullable
as List<IdName>,
  ));
}

/// Create a copy of PersonDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StaffAssignmentInfoCopyWith<$Res>? get assignment {
    if (_self.assignment == null) {
    return null;
  }

  return $StaffAssignmentInfoCopyWith<$Res>(_self.assignment!, (value) {
    return _then(_self.copyWith(assignment: value));
  });
}
}


/// @nodoc
mixin _$CreatedPerson {

 PersonDetail get person; String get temporaryPassword;
/// Create a copy of CreatedPerson
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreatedPersonCopyWith<CreatedPerson> get copyWith => _$CreatedPersonCopyWithImpl<CreatedPerson>(this as CreatedPerson, _$identity);

  /// Serializes this CreatedPerson to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as CreatedPerson;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreatedPerson&&(identical(other.person, _this.person) || other.person == _this.person)&&(identical(other.temporaryPassword, _this.temporaryPassword) || other.temporaryPassword == _this.temporaryPassword));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CreatedPerson;
  return Object.hash(runtimeType,_this.person,_this.temporaryPassword);
}

@override
String toString() {
  final _this = this as CreatedPerson;
  return 'CreatedPerson(person: ${_this.person}, temporaryPassword: ${_this.temporaryPassword})';
}


}

/// @nodoc
abstract mixin class $CreatedPersonCopyWith<$Res>  {
  factory $CreatedPersonCopyWith(CreatedPerson value, $Res Function(CreatedPerson) _then) = _$CreatedPersonCopyWithImpl;
@useResult
$Res call({
 PersonDetail person, String temporaryPassword
});


$PersonDetailCopyWith<$Res> get person;

}
/// @nodoc
class _$CreatedPersonCopyWithImpl<$Res>
    implements $CreatedPersonCopyWith<$Res> {
  _$CreatedPersonCopyWithImpl(this._self, this._then);

  final CreatedPerson _self;
  final $Res Function(CreatedPerson) _then;

/// Create a copy of CreatedPerson
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? person = null,Object? temporaryPassword = null,}) {
  return _then(CreatedPerson(
person: null == person ? _self.person : person // ignore: cast_nullable_to_non_nullable
as PersonDetail,temporaryPassword: null == temporaryPassword ? _self.temporaryPassword : temporaryPassword // ignore: cast_nullable_to_non_nullable
as String,
  ));
}
/// Create a copy of CreatedPerson
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PersonDetailCopyWith<$Res> get person {
  
  return $PersonDetailCopyWith<$Res>(_self.person, (value) {
    return _then(_self.copyWith(person: value));
  });
}
}


/// Adds pattern-matching-related methods to [CreatedPerson].
extension CreatedPersonPatterns on CreatedPerson {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreatedPerson value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreatedPerson() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreatedPerson value)  $default,){
final _that = this;
switch (_that) {
case _CreatedPerson():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreatedPerson value)?  $default,){
final _that = this;
switch (_that) {
case _CreatedPerson() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( PersonDetail person,  String temporaryPassword)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreatedPerson() when $default != null:
return $default(_that.person,_that.temporaryPassword);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( PersonDetail person,  String temporaryPassword)  $default,) {final _that = this;
switch (_that) {
case _CreatedPerson():
return $default(_that.person,_that.temporaryPassword);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( PersonDetail person,  String temporaryPassword)?  $default,) {final _that = this;
switch (_that) {
case _CreatedPerson() when $default != null:
return $default(_that.person,_that.temporaryPassword);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CreatedPerson implements CreatedPerson {
  const _CreatedPerson({required this.person, required this.temporaryPassword});
  factory _CreatedPerson.fromJson(Map<String, dynamic> json) => _$CreatedPersonFromJson(json);

@override final  PersonDetail person;
@override final  String temporaryPassword;

/// Create a copy of CreatedPerson
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreatedPersonCopyWith<_CreatedPerson> get copyWith => __$CreatedPersonCopyWithImpl<_CreatedPerson>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreatedPersonToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreatedPerson&&(identical(other.person, person) || other.person == person)&&(identical(other.temporaryPassword, temporaryPassword) || other.temporaryPassword == temporaryPassword));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,person,temporaryPassword);
}

@override
String toString() {
    return 'CreatedPerson(person: $person, temporaryPassword: $temporaryPassword)';
}


}

/// @nodoc
abstract mixin class _$CreatedPersonCopyWith<$Res> implements $CreatedPersonCopyWith<$Res> {
  factory _$CreatedPersonCopyWith(_CreatedPerson value, $Res Function(_CreatedPerson) _then) = __$CreatedPersonCopyWithImpl;
@override @useResult
$Res call({
 PersonDetail person, String temporaryPassword
});


@override $PersonDetailCopyWith<$Res> get person;

}
/// @nodoc
class __$CreatedPersonCopyWithImpl<$Res>
    implements _$CreatedPersonCopyWith<$Res> {
  __$CreatedPersonCopyWithImpl(this._self, this._then);

  final _CreatedPerson _self;
  final $Res Function(_CreatedPerson) _then;

/// Create a copy of CreatedPerson
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? person = null,Object? temporaryPassword = null,}) {
  return _then(_CreatedPerson(
person: null == person ? _self.person : person // ignore: cast_nullable_to_non_nullable
as PersonDetail,temporaryPassword: null == temporaryPassword ? _self.temporaryPassword : temporaryPassword // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

/// Create a copy of CreatedPerson
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PersonDetailCopyWith<$Res> get person {
  
  return $PersonDetailCopyWith<$Res>(_self.person, (value) {
    return _then(_self.copyWith(person: value));
  });
}
}

// dart format on
