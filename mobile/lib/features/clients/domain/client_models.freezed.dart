// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'client_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ClientSummary {

 String get id; String get name; String? get company; String get phone; String? get email; String? get address; String? get notes; int get siteCount;
/// Create a copy of ClientSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ClientSummaryCopyWith<ClientSummary> get copyWith => _$ClientSummaryCopyWithImpl<ClientSummary>(this as ClientSummary, _$identity);

  /// Serializes this ClientSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ClientSummary;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ClientSummary&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.company, _this.company) || other.company == _this.company)&&(identical(other.phone, _this.phone) || other.phone == _this.phone)&&(identical(other.email, _this.email) || other.email == _this.email)&&(identical(other.address, _this.address) || other.address == _this.address)&&(identical(other.notes, _this.notes) || other.notes == _this.notes)&&(identical(other.siteCount, _this.siteCount) || other.siteCount == _this.siteCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ClientSummary;
  return Object.hash(runtimeType,_this.id,_this.name,_this.company,_this.phone,_this.email,_this.address,_this.notes,_this.siteCount);
}

@override
String toString() {
  final _this = this as ClientSummary;
  return 'ClientSummary(id: ${_this.id}, name: ${_this.name}, company: ${_this.company}, phone: ${_this.phone}, email: ${_this.email}, address: ${_this.address}, notes: ${_this.notes}, siteCount: ${_this.siteCount})';
}


}

/// @nodoc
abstract mixin class $ClientSummaryCopyWith<$Res>  {
  factory $ClientSummaryCopyWith(ClientSummary value, $Res Function(ClientSummary) _then) = _$ClientSummaryCopyWithImpl;
@useResult
$Res call({
 String id, String name, String? company, String phone, String? email, String? address, String? notes, int siteCount
});




}
/// @nodoc
class _$ClientSummaryCopyWithImpl<$Res>
    implements $ClientSummaryCopyWith<$Res> {
  _$ClientSummaryCopyWithImpl(this._self, this._then);

  final ClientSummary _self;
  final $Res Function(ClientSummary) _then;

/// Create a copy of ClientSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? company = freezed,Object? phone = null,Object? email = freezed,Object? address = freezed,Object? notes = freezed,Object? siteCount = null,}) {
  return _then(ClientSummary(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,company: freezed == company ? _self.company : company // ignore: cast_nullable_to_non_nullable
as String?,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,siteCount: null == siteCount ? _self.siteCount : siteCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ClientSummary].
extension ClientSummaryPatterns on ClientSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ClientSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ClientSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ClientSummary value)  $default,){
final _that = this;
switch (_that) {
case _ClientSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ClientSummary value)?  $default,){
final _that = this;
switch (_that) {
case _ClientSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String? company,  String phone,  String? email,  String? address,  String? notes,  int siteCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ClientSummary() when $default != null:
return $default(_that.id,_that.name,_that.company,_that.phone,_that.email,_that.address,_that.notes,_that.siteCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String? company,  String phone,  String? email,  String? address,  String? notes,  int siteCount)  $default,) {final _that = this;
switch (_that) {
case _ClientSummary():
return $default(_that.id,_that.name,_that.company,_that.phone,_that.email,_that.address,_that.notes,_that.siteCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String? company,  String phone,  String? email,  String? address,  String? notes,  int siteCount)?  $default,) {final _that = this;
switch (_that) {
case _ClientSummary() when $default != null:
return $default(_that.id,_that.name,_that.company,_that.phone,_that.email,_that.address,_that.notes,_that.siteCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ClientSummary implements ClientSummary {
  const _ClientSummary({required this.id, required this.name, this.company, required this.phone, this.email, this.address, this.notes, required this.siteCount});
  factory _ClientSummary.fromJson(Map<String, dynamic> json) => _$ClientSummaryFromJson(json);

@override final  String id;
@override final  String name;
@override final  String? company;
@override final  String phone;
@override final  String? email;
@override final  String? address;
@override final  String? notes;
@override final  int siteCount;

/// Create a copy of ClientSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ClientSummaryCopyWith<_ClientSummary> get copyWith => __$ClientSummaryCopyWithImpl<_ClientSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ClientSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ClientSummary&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.company, company) || other.company == company)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.email, email) || other.email == email)&&(identical(other.address, address) || other.address == address)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.siteCount, siteCount) || other.siteCount == siteCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,company,phone,email,address,notes,siteCount);
}

@override
String toString() {
    return 'ClientSummary(id: $id, name: $name, company: $company, phone: $phone, email: $email, address: $address, notes: $notes, siteCount: $siteCount)';
}


}

/// @nodoc
abstract mixin class _$ClientSummaryCopyWith<$Res> implements $ClientSummaryCopyWith<$Res> {
  factory _$ClientSummaryCopyWith(_ClientSummary value, $Res Function(_ClientSummary) _then) = __$ClientSummaryCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String? company, String phone, String? email, String? address, String? notes, int siteCount
});




}
/// @nodoc
class __$ClientSummaryCopyWithImpl<$Res>
    implements _$ClientSummaryCopyWith<$Res> {
  __$ClientSummaryCopyWithImpl(this._self, this._then);

  final _ClientSummary _self;
  final $Res Function(_ClientSummary) _then;

/// Create a copy of ClientSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? company = freezed,Object? phone = null,Object? email = freezed,Object? address = freezed,Object? notes = freezed,Object? siteCount = null,}) {
  return _then(_ClientSummary(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,company: freezed == company ? _self.company : company // ignore: cast_nullable_to_non_nullable
as String?,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,siteCount: null == siteCount ? _self.siteCount : siteCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$ClientSite {

 String get id; String get code; String get name; SiteStatus get status; String get contractAmount;
/// Create a copy of ClientSite
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ClientSiteCopyWith<ClientSite> get copyWith => _$ClientSiteCopyWithImpl<ClientSite>(this as ClientSite, _$identity);

  /// Serializes this ClientSite to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ClientSite;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ClientSite&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.code, _this.code) || other.code == _this.code)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.contractAmount, _this.contractAmount) || other.contractAmount == _this.contractAmount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ClientSite;
  return Object.hash(runtimeType,_this.id,_this.code,_this.name,_this.status,_this.contractAmount);
}

@override
String toString() {
  final _this = this as ClientSite;
  return 'ClientSite(id: ${_this.id}, code: ${_this.code}, name: ${_this.name}, status: ${_this.status}, contractAmount: ${_this.contractAmount})';
}


}

/// @nodoc
abstract mixin class $ClientSiteCopyWith<$Res>  {
  factory $ClientSiteCopyWith(ClientSite value, $Res Function(ClientSite) _then) = _$ClientSiteCopyWithImpl;
@useResult
$Res call({
 String id, String code, String name, SiteStatus status, String contractAmount
});




}
/// @nodoc
class _$ClientSiteCopyWithImpl<$Res>
    implements $ClientSiteCopyWith<$Res> {
  _$ClientSiteCopyWithImpl(this._self, this._then);

  final ClientSite _self;
  final $Res Function(ClientSite) _then;

/// Create a copy of ClientSite
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? code = null,Object? name = null,Object? status = null,Object? contractAmount = null,}) {
  return _then(ClientSite(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as SiteStatus,contractAmount: null == contractAmount ? _self.contractAmount : contractAmount // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ClientSite].
extension ClientSitePatterns on ClientSite {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ClientSite value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ClientSite() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ClientSite value)  $default,){
final _that = this;
switch (_that) {
case _ClientSite():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ClientSite value)?  $default,){
final _that = this;
switch (_that) {
case _ClientSite() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String code,  String name,  SiteStatus status,  String contractAmount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ClientSite() when $default != null:
return $default(_that.id,_that.code,_that.name,_that.status,_that.contractAmount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String code,  String name,  SiteStatus status,  String contractAmount)  $default,) {final _that = this;
switch (_that) {
case _ClientSite():
return $default(_that.id,_that.code,_that.name,_that.status,_that.contractAmount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String code,  String name,  SiteStatus status,  String contractAmount)?  $default,) {final _that = this;
switch (_that) {
case _ClientSite() when $default != null:
return $default(_that.id,_that.code,_that.name,_that.status,_that.contractAmount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ClientSite implements ClientSite {
  const _ClientSite({required this.id, required this.code, required this.name, required this.status, required this.contractAmount});
  factory _ClientSite.fromJson(Map<String, dynamic> json) => _$ClientSiteFromJson(json);

@override final  String id;
@override final  String code;
@override final  String name;
@override final  SiteStatus status;
@override final  String contractAmount;

/// Create a copy of ClientSite
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ClientSiteCopyWith<_ClientSite> get copyWith => __$ClientSiteCopyWithImpl<_ClientSite>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ClientSiteToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ClientSite&&(identical(other.id, id) || other.id == id)&&(identical(other.code, code) || other.code == code)&&(identical(other.name, name) || other.name == name)&&(identical(other.status, status) || other.status == status)&&(identical(other.contractAmount, contractAmount) || other.contractAmount == contractAmount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,code,name,status,contractAmount);
}

@override
String toString() {
    return 'ClientSite(id: $id, code: $code, name: $name, status: $status, contractAmount: $contractAmount)';
}


}

/// @nodoc
abstract mixin class _$ClientSiteCopyWith<$Res> implements $ClientSiteCopyWith<$Res> {
  factory _$ClientSiteCopyWith(_ClientSite value, $Res Function(_ClientSite) _then) = __$ClientSiteCopyWithImpl;
@override @useResult
$Res call({
 String id, String code, String name, SiteStatus status, String contractAmount
});




}
/// @nodoc
class __$ClientSiteCopyWithImpl<$Res>
    implements _$ClientSiteCopyWith<$Res> {
  __$ClientSiteCopyWithImpl(this._self, this._then);

  final _ClientSite _self;
  final $Res Function(_ClientSite) _then;

/// Create a copy of ClientSite
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? code = null,Object? name = null,Object? status = null,Object? contractAmount = null,}) {
  return _then(_ClientSite(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as SiteStatus,contractAmount: null == contractAmount ? _self.contractAmount : contractAmount // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$ClientDetail {

 String get id; String get name; String? get company; String get phone; String? get email; String? get address; String? get notes; int get siteCount; List<ClientSite> get sites;
/// Create a copy of ClientDetail
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ClientDetailCopyWith<ClientDetail> get copyWith => _$ClientDetailCopyWithImpl<ClientDetail>(this as ClientDetail, _$identity);

  /// Serializes this ClientDetail to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ClientDetail;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ClientDetail&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.company, _this.company) || other.company == _this.company)&&(identical(other.phone, _this.phone) || other.phone == _this.phone)&&(identical(other.email, _this.email) || other.email == _this.email)&&(identical(other.address, _this.address) || other.address == _this.address)&&(identical(other.notes, _this.notes) || other.notes == _this.notes)&&(identical(other.siteCount, _this.siteCount) || other.siteCount == _this.siteCount)&&const DeepCollectionEquality().equals(other.sites, _this.sites));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ClientDetail;
  return Object.hash(runtimeType,_this.id,_this.name,_this.company,_this.phone,_this.email,_this.address,_this.notes,_this.siteCount,const DeepCollectionEquality().hash(_this.sites));
}

@override
String toString() {
  final _this = this as ClientDetail;
  return 'ClientDetail(id: ${_this.id}, name: ${_this.name}, company: ${_this.company}, phone: ${_this.phone}, email: ${_this.email}, address: ${_this.address}, notes: ${_this.notes}, siteCount: ${_this.siteCount}, sites: ${_this.sites})';
}


}

/// @nodoc
abstract mixin class $ClientDetailCopyWith<$Res>  {
  factory $ClientDetailCopyWith(ClientDetail value, $Res Function(ClientDetail) _then) = _$ClientDetailCopyWithImpl;
@useResult
$Res call({
 String id, String name, String? company, String phone, String? email, String? address, String? notes, int siteCount, List<ClientSite> sites
});




}
/// @nodoc
class _$ClientDetailCopyWithImpl<$Res>
    implements $ClientDetailCopyWith<$Res> {
  _$ClientDetailCopyWithImpl(this._self, this._then);

  final ClientDetail _self;
  final $Res Function(ClientDetail) _then;

/// Create a copy of ClientDetail
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? company = freezed,Object? phone = null,Object? email = freezed,Object? address = freezed,Object? notes = freezed,Object? siteCount = null,Object? sites = null,}) {
  return _then(ClientDetail(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,company: freezed == company ? _self.company : company // ignore: cast_nullable_to_non_nullable
as String?,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,siteCount: null == siteCount ? _self.siteCount : siteCount // ignore: cast_nullable_to_non_nullable
as int,sites: null == sites ? _self.sites : sites // ignore: cast_nullable_to_non_nullable
as List<ClientSite>,
  ));
}

}


/// Adds pattern-matching-related methods to [ClientDetail].
extension ClientDetailPatterns on ClientDetail {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ClientDetail value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ClientDetail() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ClientDetail value)  $default,){
final _that = this;
switch (_that) {
case _ClientDetail():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ClientDetail value)?  $default,){
final _that = this;
switch (_that) {
case _ClientDetail() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String? company,  String phone,  String? email,  String? address,  String? notes,  int siteCount,  List<ClientSite> sites)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ClientDetail() when $default != null:
return $default(_that.id,_that.name,_that.company,_that.phone,_that.email,_that.address,_that.notes,_that.siteCount,_that.sites);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String? company,  String phone,  String? email,  String? address,  String? notes,  int siteCount,  List<ClientSite> sites)  $default,) {final _that = this;
switch (_that) {
case _ClientDetail():
return $default(_that.id,_that.name,_that.company,_that.phone,_that.email,_that.address,_that.notes,_that.siteCount,_that.sites);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String? company,  String phone,  String? email,  String? address,  String? notes,  int siteCount,  List<ClientSite> sites)?  $default,) {final _that = this;
switch (_that) {
case _ClientDetail() when $default != null:
return $default(_that.id,_that.name,_that.company,_that.phone,_that.email,_that.address,_that.notes,_that.siteCount,_that.sites);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ClientDetail implements ClientDetail {
  const _ClientDetail({required this.id, required this.name, this.company, required this.phone, this.email, this.address, this.notes, required this.siteCount,  List<ClientSite> sites = const <ClientSite>[]}): _sites = sites;
  factory _ClientDetail.fromJson(Map<String, dynamic> json) => _$ClientDetailFromJson(json);

@override final  String id;
@override final  String name;
@override final  String? company;
@override final  String phone;
@override final  String? email;
@override final  String? address;
@override final  String? notes;
@override final  int siteCount;
 final  List<ClientSite> _sites;
@override@JsonKey() List<ClientSite> get sites {
  if (_sites is EqualUnmodifiableListView) return _sites;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sites);
}


/// Create a copy of ClientDetail
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ClientDetailCopyWith<_ClientDetail> get copyWith => __$ClientDetailCopyWithImpl<_ClientDetail>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ClientDetailToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ClientDetail&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.company, company) || other.company == company)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.email, email) || other.email == email)&&(identical(other.address, address) || other.address == address)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.siteCount, siteCount) || other.siteCount == siteCount)&&const DeepCollectionEquality().equals(other.sites, _sites));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,company,phone,email,address,notes,siteCount,const DeepCollectionEquality().hash(_sites));
}

@override
String toString() {
    return 'ClientDetail(id: $id, name: $name, company: $company, phone: $phone, email: $email, address: $address, notes: $notes, siteCount: $siteCount, sites: $sites)';
}


}

/// @nodoc
abstract mixin class _$ClientDetailCopyWith<$Res> implements $ClientDetailCopyWith<$Res> {
  factory _$ClientDetailCopyWith(_ClientDetail value, $Res Function(_ClientDetail) _then) = __$ClientDetailCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String? company, String phone, String? email, String? address, String? notes, int siteCount, List<ClientSite> sites
});




}
/// @nodoc
class __$ClientDetailCopyWithImpl<$Res>
    implements _$ClientDetailCopyWith<$Res> {
  __$ClientDetailCopyWithImpl(this._self, this._then);

  final _ClientDetail _self;
  final $Res Function(_ClientDetail) _then;

/// Create a copy of ClientDetail
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? company = freezed,Object? phone = null,Object? email = freezed,Object? address = freezed,Object? notes = freezed,Object? siteCount = null,Object? sites = null,}) {
  return _then(_ClientDetail(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,company: freezed == company ? _self.company : company // ignore: cast_nullable_to_non_nullable
as String?,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,siteCount: null == siteCount ? _self.siteCount : siteCount // ignore: cast_nullable_to_non_nullable
as int,sites: null == sites ? _self._sites : sites // ignore: cast_nullable_to_non_nullable
as List<ClientSite>,
  ));
}


}

// dart format on
