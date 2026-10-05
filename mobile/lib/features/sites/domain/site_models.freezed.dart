// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'site_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SiteSummary {

 String get id; String get code; String get name; SiteStatus get status; int get progressPercent; String get address; IdName get client; List<IdName> get engineers; int get staffCount; String get startDate; String? get expectedCompletionDate;/// Null for staff, who never see money.
 String? get contractAmount;
/// Create a copy of SiteSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SiteSummaryCopyWith<SiteSummary> get copyWith => _$SiteSummaryCopyWithImpl<SiteSummary>(this as SiteSummary, _$identity);

  /// Serializes this SiteSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as SiteSummary;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SiteSummary&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.code, _this.code) || other.code == _this.code)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.progressPercent, _this.progressPercent) || other.progressPercent == _this.progressPercent)&&(identical(other.address, _this.address) || other.address == _this.address)&&(identical(other.client, _this.client) || other.client == _this.client)&&const DeepCollectionEquality().equals(other.engineers, _this.engineers)&&(identical(other.staffCount, _this.staffCount) || other.staffCount == _this.staffCount)&&(identical(other.startDate, _this.startDate) || other.startDate == _this.startDate)&&(identical(other.expectedCompletionDate, _this.expectedCompletionDate) || other.expectedCompletionDate == _this.expectedCompletionDate)&&(identical(other.contractAmount, _this.contractAmount) || other.contractAmount == _this.contractAmount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as SiteSummary;
  return Object.hash(runtimeType,_this.id,_this.code,_this.name,_this.status,_this.progressPercent,_this.address,_this.client,const DeepCollectionEquality().hash(_this.engineers),_this.staffCount,_this.startDate,_this.expectedCompletionDate,_this.contractAmount);
}

@override
String toString() {
  final _this = this as SiteSummary;
  return 'SiteSummary(id: ${_this.id}, code: ${_this.code}, name: ${_this.name}, status: ${_this.status}, progressPercent: ${_this.progressPercent}, address: ${_this.address}, client: ${_this.client}, engineers: ${_this.engineers}, staffCount: ${_this.staffCount}, startDate: ${_this.startDate}, expectedCompletionDate: ${_this.expectedCompletionDate}, contractAmount: ${_this.contractAmount})';
}


}

/// @nodoc
abstract mixin class $SiteSummaryCopyWith<$Res>  {
  factory $SiteSummaryCopyWith(SiteSummary value, $Res Function(SiteSummary) _then) = _$SiteSummaryCopyWithImpl;
@useResult
$Res call({
 String id, String code, String name, SiteStatus status, int progressPercent, String address, IdName client, List<IdName> engineers, int staffCount, String startDate, String? expectedCompletionDate, String? contractAmount
});


$IdNameCopyWith<$Res> get client;

}
/// @nodoc
class _$SiteSummaryCopyWithImpl<$Res>
    implements $SiteSummaryCopyWith<$Res> {
  _$SiteSummaryCopyWithImpl(this._self, this._then);

  final SiteSummary _self;
  final $Res Function(SiteSummary) _then;

/// Create a copy of SiteSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? code = null,Object? name = null,Object? status = null,Object? progressPercent = null,Object? address = null,Object? client = null,Object? engineers = null,Object? staffCount = null,Object? startDate = null,Object? expectedCompletionDate = freezed,Object? contractAmount = freezed,}) {
  return _then(SiteSummary(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as SiteStatus,progressPercent: null == progressPercent ? _self.progressPercent : progressPercent // ignore: cast_nullable_to_non_nullable
as int,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,client: null == client ? _self.client : client // ignore: cast_nullable_to_non_nullable
as IdName,engineers: null == engineers ? _self.engineers : engineers // ignore: cast_nullable_to_non_nullable
as List<IdName>,staffCount: null == staffCount ? _self.staffCount : staffCount // ignore: cast_nullable_to_non_nullable
as int,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as String,expectedCompletionDate: freezed == expectedCompletionDate ? _self.expectedCompletionDate : expectedCompletionDate // ignore: cast_nullable_to_non_nullable
as String?,contractAmount: freezed == contractAmount ? _self.contractAmount : contractAmount // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of SiteSummary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$IdNameCopyWith<$Res> get client {
  
  return $IdNameCopyWith<$Res>(_self.client, (value) {
    return _then(_self.copyWith(client: value));
  });
}
}


/// Adds pattern-matching-related methods to [SiteSummary].
extension SiteSummaryPatterns on SiteSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SiteSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SiteSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SiteSummary value)  $default,){
final _that = this;
switch (_that) {
case _SiteSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SiteSummary value)?  $default,){
final _that = this;
switch (_that) {
case _SiteSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String code,  String name,  SiteStatus status,  int progressPercent,  String address,  IdName client,  List<IdName> engineers,  int staffCount,  String startDate,  String? expectedCompletionDate,  String? contractAmount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SiteSummary() when $default != null:
return $default(_that.id,_that.code,_that.name,_that.status,_that.progressPercent,_that.address,_that.client,_that.engineers,_that.staffCount,_that.startDate,_that.expectedCompletionDate,_that.contractAmount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String code,  String name,  SiteStatus status,  int progressPercent,  String address,  IdName client,  List<IdName> engineers,  int staffCount,  String startDate,  String? expectedCompletionDate,  String? contractAmount)  $default,) {final _that = this;
switch (_that) {
case _SiteSummary():
return $default(_that.id,_that.code,_that.name,_that.status,_that.progressPercent,_that.address,_that.client,_that.engineers,_that.staffCount,_that.startDate,_that.expectedCompletionDate,_that.contractAmount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String code,  String name,  SiteStatus status,  int progressPercent,  String address,  IdName client,  List<IdName> engineers,  int staffCount,  String startDate,  String? expectedCompletionDate,  String? contractAmount)?  $default,) {final _that = this;
switch (_that) {
case _SiteSummary() when $default != null:
return $default(_that.id,_that.code,_that.name,_that.status,_that.progressPercent,_that.address,_that.client,_that.engineers,_that.staffCount,_that.startDate,_that.expectedCompletionDate,_that.contractAmount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SiteSummary implements SiteSummary {
  const _SiteSummary({required this.id, required this.code, required this.name, required this.status, required this.progressPercent, required this.address, required this.client,  List<IdName> engineers = const <IdName>[], required this.staffCount, required this.startDate, this.expectedCompletionDate, this.contractAmount}): _engineers = engineers;
  factory _SiteSummary.fromJson(Map<String, dynamic> json) => _$SiteSummaryFromJson(json);

@override final  String id;
@override final  String code;
@override final  String name;
@override final  SiteStatus status;
@override final  int progressPercent;
@override final  String address;
@override final  IdName client;
 final  List<IdName> _engineers;
@override@JsonKey() List<IdName> get engineers {
  if (_engineers is EqualUnmodifiableListView) return _engineers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_engineers);
}

@override final  int staffCount;
@override final  String startDate;
@override final  String? expectedCompletionDate;
/// Null for staff, who never see money.
@override final  String? contractAmount;

/// Create a copy of SiteSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SiteSummaryCopyWith<_SiteSummary> get copyWith => __$SiteSummaryCopyWithImpl<_SiteSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SiteSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SiteSummary&&(identical(other.id, id) || other.id == id)&&(identical(other.code, code) || other.code == code)&&(identical(other.name, name) || other.name == name)&&(identical(other.status, status) || other.status == status)&&(identical(other.progressPercent, progressPercent) || other.progressPercent == progressPercent)&&(identical(other.address, address) || other.address == address)&&(identical(other.client, client) || other.client == client)&&const DeepCollectionEquality().equals(other.engineers, _engineers)&&(identical(other.staffCount, staffCount) || other.staffCount == staffCount)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.expectedCompletionDate, expectedCompletionDate) || other.expectedCompletionDate == expectedCompletionDate)&&(identical(other.contractAmount, contractAmount) || other.contractAmount == contractAmount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,code,name,status,progressPercent,address,client,const DeepCollectionEquality().hash(_engineers),staffCount,startDate,expectedCompletionDate,contractAmount);
}

@override
String toString() {
    return 'SiteSummary(id: $id, code: $code, name: $name, status: $status, progressPercent: $progressPercent, address: $address, client: $client, engineers: $engineers, staffCount: $staffCount, startDate: $startDate, expectedCompletionDate: $expectedCompletionDate, contractAmount: $contractAmount)';
}


}

/// @nodoc
abstract mixin class _$SiteSummaryCopyWith<$Res> implements $SiteSummaryCopyWith<$Res> {
  factory _$SiteSummaryCopyWith(_SiteSummary value, $Res Function(_SiteSummary) _then) = __$SiteSummaryCopyWithImpl;
@override @useResult
$Res call({
 String id, String code, String name, SiteStatus status, int progressPercent, String address, IdName client, List<IdName> engineers, int staffCount, String startDate, String? expectedCompletionDate, String? contractAmount
});


@override $IdNameCopyWith<$Res> get client;

}
/// @nodoc
class __$SiteSummaryCopyWithImpl<$Res>
    implements _$SiteSummaryCopyWith<$Res> {
  __$SiteSummaryCopyWithImpl(this._self, this._then);

  final _SiteSummary _self;
  final $Res Function(_SiteSummary) _then;

/// Create a copy of SiteSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? code = null,Object? name = null,Object? status = null,Object? progressPercent = null,Object? address = null,Object? client = null,Object? engineers = null,Object? staffCount = null,Object? startDate = null,Object? expectedCompletionDate = freezed,Object? contractAmount = freezed,}) {
  return _then(_SiteSummary(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as SiteStatus,progressPercent: null == progressPercent ? _self.progressPercent : progressPercent // ignore: cast_nullable_to_non_nullable
as int,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,client: null == client ? _self.client : client // ignore: cast_nullable_to_non_nullable
as IdName,engineers: null == engineers ? _self._engineers : engineers // ignore: cast_nullable_to_non_nullable
as List<IdName>,staffCount: null == staffCount ? _self.staffCount : staffCount // ignore: cast_nullable_to_non_nullable
as int,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as String,expectedCompletionDate: freezed == expectedCompletionDate ? _self.expectedCompletionDate : expectedCompletionDate // ignore: cast_nullable_to_non_nullable
as String?,contractAmount: freezed == contractAmount ? _self.contractAmount : contractAmount // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of SiteSummary
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
mixin _$SiteClient {

 String get id; String get name;/// Staff get the client's name only.
 String? get phone; String? get email;
/// Create a copy of SiteClient
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SiteClientCopyWith<SiteClient> get copyWith => _$SiteClientCopyWithImpl<SiteClient>(this as SiteClient, _$identity);

  /// Serializes this SiteClient to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as SiteClient;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SiteClient&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.phone, _this.phone) || other.phone == _this.phone)&&(identical(other.email, _this.email) || other.email == _this.email));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as SiteClient;
  return Object.hash(runtimeType,_this.id,_this.name,_this.phone,_this.email);
}

@override
String toString() {
  final _this = this as SiteClient;
  return 'SiteClient(id: ${_this.id}, name: ${_this.name}, phone: ${_this.phone}, email: ${_this.email})';
}


}

/// @nodoc
abstract mixin class $SiteClientCopyWith<$Res>  {
  factory $SiteClientCopyWith(SiteClient value, $Res Function(SiteClient) _then) = _$SiteClientCopyWithImpl;
@useResult
$Res call({
 String id, String name, String? phone, String? email
});




}
/// @nodoc
class _$SiteClientCopyWithImpl<$Res>
    implements $SiteClientCopyWith<$Res> {
  _$SiteClientCopyWithImpl(this._self, this._then);

  final SiteClient _self;
  final $Res Function(SiteClient) _then;

/// Create a copy of SiteClient
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? phone = freezed,Object? email = freezed,}) {
  return _then(SiteClient(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [SiteClient].
extension SiteClientPatterns on SiteClient {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SiteClient value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SiteClient() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SiteClient value)  $default,){
final _that = this;
switch (_that) {
case _SiteClient():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SiteClient value)?  $default,){
final _that = this;
switch (_that) {
case _SiteClient() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String? phone,  String? email)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SiteClient() when $default != null:
return $default(_that.id,_that.name,_that.phone,_that.email);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String? phone,  String? email)  $default,) {final _that = this;
switch (_that) {
case _SiteClient():
return $default(_that.id,_that.name,_that.phone,_that.email);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String? phone,  String? email)?  $default,) {final _that = this;
switch (_that) {
case _SiteClient() when $default != null:
return $default(_that.id,_that.name,_that.phone,_that.email);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SiteClient implements SiteClient {
  const _SiteClient({required this.id, required this.name, this.phone, this.email});
  factory _SiteClient.fromJson(Map<String, dynamic> json) => _$SiteClientFromJson(json);

@override final  String id;
@override final  String name;
/// Staff get the client's name only.
@override final  String? phone;
@override final  String? email;

/// Create a copy of SiteClient
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SiteClientCopyWith<_SiteClient> get copyWith => __$SiteClientCopyWithImpl<_SiteClient>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SiteClientToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SiteClient&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.email, email) || other.email == email));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,phone,email);
}

@override
String toString() {
    return 'SiteClient(id: $id, name: $name, phone: $phone, email: $email)';
}


}

/// @nodoc
abstract mixin class _$SiteClientCopyWith<$Res> implements $SiteClientCopyWith<$Res> {
  factory _$SiteClientCopyWith(_SiteClient value, $Res Function(_SiteClient) _then) = __$SiteClientCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String? phone, String? email
});




}
/// @nodoc
class __$SiteClientCopyWithImpl<$Res>
    implements _$SiteClientCopyWith<$Res> {
  __$SiteClientCopyWithImpl(this._self, this._then);

  final _SiteClient _self;
  final $Res Function(_SiteClient) _then;

/// Create a copy of SiteClient
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? phone = freezed,Object? email = freezed,}) {
  return _then(_SiteClient(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$SiteStaffMember {

 String get id; String get name; String get phone; Designation? get designation; IdName get engineer;
/// Create a copy of SiteStaffMember
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SiteStaffMemberCopyWith<SiteStaffMember> get copyWith => _$SiteStaffMemberCopyWithImpl<SiteStaffMember>(this as SiteStaffMember, _$identity);

  /// Serializes this SiteStaffMember to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as SiteStaffMember;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SiteStaffMember&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.phone, _this.phone) || other.phone == _this.phone)&&(identical(other.designation, _this.designation) || other.designation == _this.designation)&&(identical(other.engineer, _this.engineer) || other.engineer == _this.engineer));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as SiteStaffMember;
  return Object.hash(runtimeType,_this.id,_this.name,_this.phone,_this.designation,_this.engineer);
}

@override
String toString() {
  final _this = this as SiteStaffMember;
  return 'SiteStaffMember(id: ${_this.id}, name: ${_this.name}, phone: ${_this.phone}, designation: ${_this.designation}, engineer: ${_this.engineer})';
}


}

/// @nodoc
abstract mixin class $SiteStaffMemberCopyWith<$Res>  {
  factory $SiteStaffMemberCopyWith(SiteStaffMember value, $Res Function(SiteStaffMember) _then) = _$SiteStaffMemberCopyWithImpl;
@useResult
$Res call({
 String id, String name, String phone, Designation? designation, IdName engineer
});


$IdNameCopyWith<$Res> get engineer;

}
/// @nodoc
class _$SiteStaffMemberCopyWithImpl<$Res>
    implements $SiteStaffMemberCopyWith<$Res> {
  _$SiteStaffMemberCopyWithImpl(this._self, this._then);

  final SiteStaffMember _self;
  final $Res Function(SiteStaffMember) _then;

/// Create a copy of SiteStaffMember
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? phone = null,Object? designation = freezed,Object? engineer = null,}) {
  return _then(SiteStaffMember(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,designation: freezed == designation ? _self.designation : designation // ignore: cast_nullable_to_non_nullable
as Designation?,engineer: null == engineer ? _self.engineer : engineer // ignore: cast_nullable_to_non_nullable
as IdName,
  ));
}
/// Create a copy of SiteStaffMember
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$IdNameCopyWith<$Res> get engineer {
  
  return $IdNameCopyWith<$Res>(_self.engineer, (value) {
    return _then(_self.copyWith(engineer: value));
  });
}
}


/// Adds pattern-matching-related methods to [SiteStaffMember].
extension SiteStaffMemberPatterns on SiteStaffMember {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SiteStaffMember value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SiteStaffMember() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SiteStaffMember value)  $default,){
final _that = this;
switch (_that) {
case _SiteStaffMember():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SiteStaffMember value)?  $default,){
final _that = this;
switch (_that) {
case _SiteStaffMember() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String phone,  Designation? designation,  IdName engineer)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SiteStaffMember() when $default != null:
return $default(_that.id,_that.name,_that.phone,_that.designation,_that.engineer);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String phone,  Designation? designation,  IdName engineer)  $default,) {final _that = this;
switch (_that) {
case _SiteStaffMember():
return $default(_that.id,_that.name,_that.phone,_that.designation,_that.engineer);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String phone,  Designation? designation,  IdName engineer)?  $default,) {final _that = this;
switch (_that) {
case _SiteStaffMember() when $default != null:
return $default(_that.id,_that.name,_that.phone,_that.designation,_that.engineer);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SiteStaffMember implements SiteStaffMember {
  const _SiteStaffMember({required this.id, required this.name, required this.phone, this.designation, required this.engineer});
  factory _SiteStaffMember.fromJson(Map<String, dynamic> json) => _$SiteStaffMemberFromJson(json);

@override final  String id;
@override final  String name;
@override final  String phone;
@override final  Designation? designation;
@override final  IdName engineer;

/// Create a copy of SiteStaffMember
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SiteStaffMemberCopyWith<_SiteStaffMember> get copyWith => __$SiteStaffMemberCopyWithImpl<_SiteStaffMember>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SiteStaffMemberToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SiteStaffMember&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.designation, designation) || other.designation == designation)&&(identical(other.engineer, engineer) || other.engineer == engineer));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,phone,designation,engineer);
}

@override
String toString() {
    return 'SiteStaffMember(id: $id, name: $name, phone: $phone, designation: $designation, engineer: $engineer)';
}


}

/// @nodoc
abstract mixin class _$SiteStaffMemberCopyWith<$Res> implements $SiteStaffMemberCopyWith<$Res> {
  factory _$SiteStaffMemberCopyWith(_SiteStaffMember value, $Res Function(_SiteStaffMember) _then) = __$SiteStaffMemberCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String phone, Designation? designation, IdName engineer
});


@override $IdNameCopyWith<$Res> get engineer;

}
/// @nodoc
class __$SiteStaffMemberCopyWithImpl<$Res>
    implements _$SiteStaffMemberCopyWith<$Res> {
  __$SiteStaffMemberCopyWithImpl(this._self, this._then);

  final _SiteStaffMember _self;
  final $Res Function(_SiteStaffMember) _then;

/// Create a copy of SiteStaffMember
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? phone = null,Object? designation = freezed,Object? engineer = null,}) {
  return _then(_SiteStaffMember(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,designation: freezed == designation ? _self.designation : designation // ignore: cast_nullable_to_non_nullable
as Designation?,engineer: null == engineer ? _self.engineer : engineer // ignore: cast_nullable_to_non_nullable
as IdName,
  ));
}

/// Create a copy of SiteStaffMember
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$IdNameCopyWith<$Res> get engineer {
  
  return $IdNameCopyWith<$Res>(_self.engineer, (value) {
    return _then(_self.copyWith(engineer: value));
  });
}
}


/// @nodoc
mixin _$MilestoneView {

 String get id; String get title; String get amount; String get dueDate; String get paid; String get outstanding; MilestoneStatus get status;
/// Create a copy of MilestoneView
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MilestoneViewCopyWith<MilestoneView> get copyWith => _$MilestoneViewCopyWithImpl<MilestoneView>(this as MilestoneView, _$identity);

  /// Serializes this MilestoneView to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MilestoneView;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MilestoneView&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.amount, _this.amount) || other.amount == _this.amount)&&(identical(other.dueDate, _this.dueDate) || other.dueDate == _this.dueDate)&&(identical(other.paid, _this.paid) || other.paid == _this.paid)&&(identical(other.outstanding, _this.outstanding) || other.outstanding == _this.outstanding)&&(identical(other.status, _this.status) || other.status == _this.status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MilestoneView;
  return Object.hash(runtimeType,_this.id,_this.title,_this.amount,_this.dueDate,_this.paid,_this.outstanding,_this.status);
}

@override
String toString() {
  final _this = this as MilestoneView;
  return 'MilestoneView(id: ${_this.id}, title: ${_this.title}, amount: ${_this.amount}, dueDate: ${_this.dueDate}, paid: ${_this.paid}, outstanding: ${_this.outstanding}, status: ${_this.status})';
}


}

/// @nodoc
abstract mixin class $MilestoneViewCopyWith<$Res>  {
  factory $MilestoneViewCopyWith(MilestoneView value, $Res Function(MilestoneView) _then) = _$MilestoneViewCopyWithImpl;
@useResult
$Res call({
 String id, String title, String amount, String dueDate, String paid, String outstanding, MilestoneStatus status
});




}
/// @nodoc
class _$MilestoneViewCopyWithImpl<$Res>
    implements $MilestoneViewCopyWith<$Res> {
  _$MilestoneViewCopyWithImpl(this._self, this._then);

  final MilestoneView _self;
  final $Res Function(MilestoneView) _then;

/// Create a copy of MilestoneView
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? amount = null,Object? dueDate = null,Object? paid = null,Object? outstanding = null,Object? status = null,}) {
  return _then(MilestoneView(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as String,dueDate: null == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as String,paid: null == paid ? _self.paid : paid // ignore: cast_nullable_to_non_nullable
as String,outstanding: null == outstanding ? _self.outstanding : outstanding // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as MilestoneStatus,
  ));
}

}


/// Adds pattern-matching-related methods to [MilestoneView].
extension MilestoneViewPatterns on MilestoneView {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MilestoneView value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MilestoneView() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MilestoneView value)  $default,){
final _that = this;
switch (_that) {
case _MilestoneView():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MilestoneView value)?  $default,){
final _that = this;
switch (_that) {
case _MilestoneView() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String amount,  String dueDate,  String paid,  String outstanding,  MilestoneStatus status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MilestoneView() when $default != null:
return $default(_that.id,_that.title,_that.amount,_that.dueDate,_that.paid,_that.outstanding,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String amount,  String dueDate,  String paid,  String outstanding,  MilestoneStatus status)  $default,) {final _that = this;
switch (_that) {
case _MilestoneView():
return $default(_that.id,_that.title,_that.amount,_that.dueDate,_that.paid,_that.outstanding,_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String amount,  String dueDate,  String paid,  String outstanding,  MilestoneStatus status)?  $default,) {final _that = this;
switch (_that) {
case _MilestoneView() when $default != null:
return $default(_that.id,_that.title,_that.amount,_that.dueDate,_that.paid,_that.outstanding,_that.status);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MilestoneView implements MilestoneView {
  const _MilestoneView({required this.id, required this.title, required this.amount, required this.dueDate, required this.paid, required this.outstanding, required this.status});
  factory _MilestoneView.fromJson(Map<String, dynamic> json) => _$MilestoneViewFromJson(json);

@override final  String id;
@override final  String title;
@override final  String amount;
@override final  String dueDate;
@override final  String paid;
@override final  String outstanding;
@override final  MilestoneStatus status;

/// Create a copy of MilestoneView
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MilestoneViewCopyWith<_MilestoneView> get copyWith => __$MilestoneViewCopyWithImpl<_MilestoneView>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MilestoneViewToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MilestoneView&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.dueDate, dueDate) || other.dueDate == dueDate)&&(identical(other.paid, paid) || other.paid == paid)&&(identical(other.outstanding, outstanding) || other.outstanding == outstanding)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,title,amount,dueDate,paid,outstanding,status);
}

@override
String toString() {
    return 'MilestoneView(id: $id, title: $title, amount: $amount, dueDate: $dueDate, paid: $paid, outstanding: $outstanding, status: $status)';
}


}

/// @nodoc
abstract mixin class _$MilestoneViewCopyWith<$Res> implements $MilestoneViewCopyWith<$Res> {
  factory _$MilestoneViewCopyWith(_MilestoneView value, $Res Function(_MilestoneView) _then) = __$MilestoneViewCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String amount, String dueDate, String paid, String outstanding, MilestoneStatus status
});




}
/// @nodoc
class __$MilestoneViewCopyWithImpl<$Res>
    implements _$MilestoneViewCopyWith<$Res> {
  __$MilestoneViewCopyWithImpl(this._self, this._then);

  final _MilestoneView _self;
  final $Res Function(_MilestoneView) _then;

/// Create a copy of MilestoneView
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? amount = null,Object? dueDate = null,Object? paid = null,Object? outstanding = null,Object? status = null,}) {
  return _then(_MilestoneView(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as String,dueDate: null == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as String,paid: null == paid ? _self.paid : paid // ignore: cast_nullable_to_non_nullable
as String,outstanding: null == outstanding ? _self.outstanding : outstanding // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as MilestoneStatus,
  ));
}


}


/// @nodoc
mixin _$SiteFinancials {

 String get contract; String get received; String get pending; String get overdue; int get overdueCount; List<MilestoneView> get milestones;
/// Create a copy of SiteFinancials
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SiteFinancialsCopyWith<SiteFinancials> get copyWith => _$SiteFinancialsCopyWithImpl<SiteFinancials>(this as SiteFinancials, _$identity);

  /// Serializes this SiteFinancials to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as SiteFinancials;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SiteFinancials&&(identical(other.contract, _this.contract) || other.contract == _this.contract)&&(identical(other.received, _this.received) || other.received == _this.received)&&(identical(other.pending, _this.pending) || other.pending == _this.pending)&&(identical(other.overdue, _this.overdue) || other.overdue == _this.overdue)&&(identical(other.overdueCount, _this.overdueCount) || other.overdueCount == _this.overdueCount)&&const DeepCollectionEquality().equals(other.milestones, _this.milestones));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as SiteFinancials;
  return Object.hash(runtimeType,_this.contract,_this.received,_this.pending,_this.overdue,_this.overdueCount,const DeepCollectionEquality().hash(_this.milestones));
}

@override
String toString() {
  final _this = this as SiteFinancials;
  return 'SiteFinancials(contract: ${_this.contract}, received: ${_this.received}, pending: ${_this.pending}, overdue: ${_this.overdue}, overdueCount: ${_this.overdueCount}, milestones: ${_this.milestones})';
}


}

/// @nodoc
abstract mixin class $SiteFinancialsCopyWith<$Res>  {
  factory $SiteFinancialsCopyWith(SiteFinancials value, $Res Function(SiteFinancials) _then) = _$SiteFinancialsCopyWithImpl;
@useResult
$Res call({
 String contract, String received, String pending, String overdue, int overdueCount, List<MilestoneView> milestones
});




}
/// @nodoc
class _$SiteFinancialsCopyWithImpl<$Res>
    implements $SiteFinancialsCopyWith<$Res> {
  _$SiteFinancialsCopyWithImpl(this._self, this._then);

  final SiteFinancials _self;
  final $Res Function(SiteFinancials) _then;

/// Create a copy of SiteFinancials
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? contract = null,Object? received = null,Object? pending = null,Object? overdue = null,Object? overdueCount = null,Object? milestones = null,}) {
  return _then(SiteFinancials(
contract: null == contract ? _self.contract : contract // ignore: cast_nullable_to_non_nullable
as String,received: null == received ? _self.received : received // ignore: cast_nullable_to_non_nullable
as String,pending: null == pending ? _self.pending : pending // ignore: cast_nullable_to_non_nullable
as String,overdue: null == overdue ? _self.overdue : overdue // ignore: cast_nullable_to_non_nullable
as String,overdueCount: null == overdueCount ? _self.overdueCount : overdueCount // ignore: cast_nullable_to_non_nullable
as int,milestones: null == milestones ? _self.milestones : milestones // ignore: cast_nullable_to_non_nullable
as List<MilestoneView>,
  ));
}

}


/// Adds pattern-matching-related methods to [SiteFinancials].
extension SiteFinancialsPatterns on SiteFinancials {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SiteFinancials value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SiteFinancials() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SiteFinancials value)  $default,){
final _that = this;
switch (_that) {
case _SiteFinancials():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SiteFinancials value)?  $default,){
final _that = this;
switch (_that) {
case _SiteFinancials() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String contract,  String received,  String pending,  String overdue,  int overdueCount,  List<MilestoneView> milestones)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SiteFinancials() when $default != null:
return $default(_that.contract,_that.received,_that.pending,_that.overdue,_that.overdueCount,_that.milestones);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String contract,  String received,  String pending,  String overdue,  int overdueCount,  List<MilestoneView> milestones)  $default,) {final _that = this;
switch (_that) {
case _SiteFinancials():
return $default(_that.contract,_that.received,_that.pending,_that.overdue,_that.overdueCount,_that.milestones);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String contract,  String received,  String pending,  String overdue,  int overdueCount,  List<MilestoneView> milestones)?  $default,) {final _that = this;
switch (_that) {
case _SiteFinancials() when $default != null:
return $default(_that.contract,_that.received,_that.pending,_that.overdue,_that.overdueCount,_that.milestones);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SiteFinancials implements SiteFinancials {
  const _SiteFinancials({required this.contract, required this.received, required this.pending, required this.overdue, required this.overdueCount,  List<MilestoneView> milestones = const <MilestoneView>[]}): _milestones = milestones;
  factory _SiteFinancials.fromJson(Map<String, dynamic> json) => _$SiteFinancialsFromJson(json);

@override final  String contract;
@override final  String received;
@override final  String pending;
@override final  String overdue;
@override final  int overdueCount;
 final  List<MilestoneView> _milestones;
@override@JsonKey() List<MilestoneView> get milestones {
  if (_milestones is EqualUnmodifiableListView) return _milestones;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_milestones);
}


/// Create a copy of SiteFinancials
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SiteFinancialsCopyWith<_SiteFinancials> get copyWith => __$SiteFinancialsCopyWithImpl<_SiteFinancials>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SiteFinancialsToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SiteFinancials&&(identical(other.contract, contract) || other.contract == contract)&&(identical(other.received, received) || other.received == received)&&(identical(other.pending, pending) || other.pending == pending)&&(identical(other.overdue, overdue) || other.overdue == overdue)&&(identical(other.overdueCount, overdueCount) || other.overdueCount == overdueCount)&&const DeepCollectionEquality().equals(other.milestones, _milestones));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,contract,received,pending,overdue,overdueCount,const DeepCollectionEquality().hash(_milestones));
}

@override
String toString() {
    return 'SiteFinancials(contract: $contract, received: $received, pending: $pending, overdue: $overdue, overdueCount: $overdueCount, milestones: $milestones)';
}


}

/// @nodoc
abstract mixin class _$SiteFinancialsCopyWith<$Res> implements $SiteFinancialsCopyWith<$Res> {
  factory _$SiteFinancialsCopyWith(_SiteFinancials value, $Res Function(_SiteFinancials) _then) = __$SiteFinancialsCopyWithImpl;
@override @useResult
$Res call({
 String contract, String received, String pending, String overdue, int overdueCount, List<MilestoneView> milestones
});




}
/// @nodoc
class __$SiteFinancialsCopyWithImpl<$Res>
    implements _$SiteFinancialsCopyWith<$Res> {
  __$SiteFinancialsCopyWithImpl(this._self, this._then);

  final _SiteFinancials _self;
  final $Res Function(_SiteFinancials) _then;

/// Create a copy of SiteFinancials
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? contract = null,Object? received = null,Object? pending = null,Object? overdue = null,Object? overdueCount = null,Object? milestones = null,}) {
  return _then(_SiteFinancials(
contract: null == contract ? _self.contract : contract // ignore: cast_nullable_to_non_nullable
as String,received: null == received ? _self.received : received // ignore: cast_nullable_to_non_nullable
as String,pending: null == pending ? _self.pending : pending // ignore: cast_nullable_to_non_nullable
as String,overdue: null == overdue ? _self.overdue : overdue // ignore: cast_nullable_to_non_nullable
as String,overdueCount: null == overdueCount ? _self.overdueCount : overdueCount // ignore: cast_nullable_to_non_nullable
as int,milestones: null == milestones ? _self._milestones : milestones // ignore: cast_nullable_to_non_nullable
as List<MilestoneView>,
  ));
}


}


/// @nodoc
mixin _$SiteDetail {

 String get id; String get code; String get name; SiteStatus get status; int get progressPercent; String get address; SiteClient get client; List<IdName> get engineers; int get staffCount; String get startDate; String? get expectedCompletionDate; String? get contractAmount; String? get contactName; String? get contactPhone; double? get latitude; double? get longitude; int? get geofenceRadiusM; List<SiteStaffMember> get staff; SiteFinancials? get financials; int get openIssues;
/// Create a copy of SiteDetail
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SiteDetailCopyWith<SiteDetail> get copyWith => _$SiteDetailCopyWithImpl<SiteDetail>(this as SiteDetail, _$identity);

  /// Serializes this SiteDetail to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as SiteDetail;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SiteDetail&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.code, _this.code) || other.code == _this.code)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.progressPercent, _this.progressPercent) || other.progressPercent == _this.progressPercent)&&(identical(other.address, _this.address) || other.address == _this.address)&&(identical(other.client, _this.client) || other.client == _this.client)&&const DeepCollectionEquality().equals(other.engineers, _this.engineers)&&(identical(other.staffCount, _this.staffCount) || other.staffCount == _this.staffCount)&&(identical(other.startDate, _this.startDate) || other.startDate == _this.startDate)&&(identical(other.expectedCompletionDate, _this.expectedCompletionDate) || other.expectedCompletionDate == _this.expectedCompletionDate)&&(identical(other.contractAmount, _this.contractAmount) || other.contractAmount == _this.contractAmount)&&(identical(other.contactName, _this.contactName) || other.contactName == _this.contactName)&&(identical(other.contactPhone, _this.contactPhone) || other.contactPhone == _this.contactPhone)&&(identical(other.latitude, _this.latitude) || other.latitude == _this.latitude)&&(identical(other.longitude, _this.longitude) || other.longitude == _this.longitude)&&(identical(other.geofenceRadiusM, _this.geofenceRadiusM) || other.geofenceRadiusM == _this.geofenceRadiusM)&&const DeepCollectionEquality().equals(other.staff, _this.staff)&&(identical(other.financials, _this.financials) || other.financials == _this.financials)&&(identical(other.openIssues, _this.openIssues) || other.openIssues == _this.openIssues));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as SiteDetail;
  return Object.hashAll([runtimeType,_this.id,_this.code,_this.name,_this.status,_this.progressPercent,_this.address,_this.client,const DeepCollectionEquality().hash(_this.engineers),_this.staffCount,_this.startDate,_this.expectedCompletionDate,_this.contractAmount,_this.contactName,_this.contactPhone,_this.latitude,_this.longitude,_this.geofenceRadiusM,const DeepCollectionEquality().hash(_this.staff),_this.financials,_this.openIssues]);
}

@override
String toString() {
  final _this = this as SiteDetail;
  return 'SiteDetail(id: ${_this.id}, code: ${_this.code}, name: ${_this.name}, status: ${_this.status}, progressPercent: ${_this.progressPercent}, address: ${_this.address}, client: ${_this.client}, engineers: ${_this.engineers}, staffCount: ${_this.staffCount}, startDate: ${_this.startDate}, expectedCompletionDate: ${_this.expectedCompletionDate}, contractAmount: ${_this.contractAmount}, contactName: ${_this.contactName}, contactPhone: ${_this.contactPhone}, latitude: ${_this.latitude}, longitude: ${_this.longitude}, geofenceRadiusM: ${_this.geofenceRadiusM}, staff: ${_this.staff}, financials: ${_this.financials}, openIssues: ${_this.openIssues})';
}


}

/// @nodoc
abstract mixin class $SiteDetailCopyWith<$Res>  {
  factory $SiteDetailCopyWith(SiteDetail value, $Res Function(SiteDetail) _then) = _$SiteDetailCopyWithImpl;
@useResult
$Res call({
 String id, String code, String name, SiteStatus status, int progressPercent, String address, SiteClient client, List<IdName> engineers, int staffCount, String startDate, String? expectedCompletionDate, String? contractAmount, String? contactName, String? contactPhone, double? latitude, double? longitude, int? geofenceRadiusM, List<SiteStaffMember> staff, SiteFinancials? financials, int openIssues
});


$SiteClientCopyWith<$Res> get client;$SiteFinancialsCopyWith<$Res>? get financials;

}
/// @nodoc
class _$SiteDetailCopyWithImpl<$Res>
    implements $SiteDetailCopyWith<$Res> {
  _$SiteDetailCopyWithImpl(this._self, this._then);

  final SiteDetail _self;
  final $Res Function(SiteDetail) _then;

/// Create a copy of SiteDetail
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? code = null,Object? name = null,Object? status = null,Object? progressPercent = null,Object? address = null,Object? client = null,Object? engineers = null,Object? staffCount = null,Object? startDate = null,Object? expectedCompletionDate = freezed,Object? contractAmount = freezed,Object? contactName = freezed,Object? contactPhone = freezed,Object? latitude = freezed,Object? longitude = freezed,Object? geofenceRadiusM = freezed,Object? staff = null,Object? financials = freezed,Object? openIssues = null,}) {
  return _then(SiteDetail(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as SiteStatus,progressPercent: null == progressPercent ? _self.progressPercent : progressPercent // ignore: cast_nullable_to_non_nullable
as int,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,client: null == client ? _self.client : client // ignore: cast_nullable_to_non_nullable
as SiteClient,engineers: null == engineers ? _self.engineers : engineers // ignore: cast_nullable_to_non_nullable
as List<IdName>,staffCount: null == staffCount ? _self.staffCount : staffCount // ignore: cast_nullable_to_non_nullable
as int,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as String,expectedCompletionDate: freezed == expectedCompletionDate ? _self.expectedCompletionDate : expectedCompletionDate // ignore: cast_nullable_to_non_nullable
as String?,contractAmount: freezed == contractAmount ? _self.contractAmount : contractAmount // ignore: cast_nullable_to_non_nullable
as String?,contactName: freezed == contactName ? _self.contactName : contactName // ignore: cast_nullable_to_non_nullable
as String?,contactPhone: freezed == contactPhone ? _self.contactPhone : contactPhone // ignore: cast_nullable_to_non_nullable
as String?,latitude: freezed == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double?,longitude: freezed == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double?,geofenceRadiusM: freezed == geofenceRadiusM ? _self.geofenceRadiusM : geofenceRadiusM // ignore: cast_nullable_to_non_nullable
as int?,staff: null == staff ? _self.staff : staff // ignore: cast_nullable_to_non_nullable
as List<SiteStaffMember>,financials: freezed == financials ? _self.financials : financials // ignore: cast_nullable_to_non_nullable
as SiteFinancials?,openIssues: null == openIssues ? _self.openIssues : openIssues // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of SiteDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SiteClientCopyWith<$Res> get client {
  
  return $SiteClientCopyWith<$Res>(_self.client, (value) {
    return _then(_self.copyWith(client: value));
  });
}/// Create a copy of SiteDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SiteFinancialsCopyWith<$Res>? get financials {
    if (_self.financials == null) {
    return null;
  }

  return $SiteFinancialsCopyWith<$Res>(_self.financials!, (value) {
    return _then(_self.copyWith(financials: value));
  });
}
}


/// Adds pattern-matching-related methods to [SiteDetail].
extension SiteDetailPatterns on SiteDetail {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SiteDetail value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SiteDetail() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SiteDetail value)  $default,){
final _that = this;
switch (_that) {
case _SiteDetail():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SiteDetail value)?  $default,){
final _that = this;
switch (_that) {
case _SiteDetail() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String code,  String name,  SiteStatus status,  int progressPercent,  String address,  SiteClient client,  List<IdName> engineers,  int staffCount,  String startDate,  String? expectedCompletionDate,  String? contractAmount,  String? contactName,  String? contactPhone,  double? latitude,  double? longitude,  int? geofenceRadiusM,  List<SiteStaffMember> staff,  SiteFinancials? financials,  int openIssues)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SiteDetail() when $default != null:
return $default(_that.id,_that.code,_that.name,_that.status,_that.progressPercent,_that.address,_that.client,_that.engineers,_that.staffCount,_that.startDate,_that.expectedCompletionDate,_that.contractAmount,_that.contactName,_that.contactPhone,_that.latitude,_that.longitude,_that.geofenceRadiusM,_that.staff,_that.financials,_that.openIssues);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String code,  String name,  SiteStatus status,  int progressPercent,  String address,  SiteClient client,  List<IdName> engineers,  int staffCount,  String startDate,  String? expectedCompletionDate,  String? contractAmount,  String? contactName,  String? contactPhone,  double? latitude,  double? longitude,  int? geofenceRadiusM,  List<SiteStaffMember> staff,  SiteFinancials? financials,  int openIssues)  $default,) {final _that = this;
switch (_that) {
case _SiteDetail():
return $default(_that.id,_that.code,_that.name,_that.status,_that.progressPercent,_that.address,_that.client,_that.engineers,_that.staffCount,_that.startDate,_that.expectedCompletionDate,_that.contractAmount,_that.contactName,_that.contactPhone,_that.latitude,_that.longitude,_that.geofenceRadiusM,_that.staff,_that.financials,_that.openIssues);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String code,  String name,  SiteStatus status,  int progressPercent,  String address,  SiteClient client,  List<IdName> engineers,  int staffCount,  String startDate,  String? expectedCompletionDate,  String? contractAmount,  String? contactName,  String? contactPhone,  double? latitude,  double? longitude,  int? geofenceRadiusM,  List<SiteStaffMember> staff,  SiteFinancials? financials,  int openIssues)?  $default,) {final _that = this;
switch (_that) {
case _SiteDetail() when $default != null:
return $default(_that.id,_that.code,_that.name,_that.status,_that.progressPercent,_that.address,_that.client,_that.engineers,_that.staffCount,_that.startDate,_that.expectedCompletionDate,_that.contractAmount,_that.contactName,_that.contactPhone,_that.latitude,_that.longitude,_that.geofenceRadiusM,_that.staff,_that.financials,_that.openIssues);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SiteDetail implements SiteDetail {
  const _SiteDetail({required this.id, required this.code, required this.name, required this.status, required this.progressPercent, required this.address, required this.client,  List<IdName> engineers = const <IdName>[], required this.staffCount, required this.startDate, this.expectedCompletionDate, this.contractAmount, this.contactName, this.contactPhone, this.latitude, this.longitude, this.geofenceRadiusM,  List<SiteStaffMember> staff = const <SiteStaffMember>[], this.financials, required this.openIssues}): _engineers = engineers,_staff = staff;
  factory _SiteDetail.fromJson(Map<String, dynamic> json) => _$SiteDetailFromJson(json);

@override final  String id;
@override final  String code;
@override final  String name;
@override final  SiteStatus status;
@override final  int progressPercent;
@override final  String address;
@override final  SiteClient client;
 final  List<IdName> _engineers;
@override@JsonKey() List<IdName> get engineers {
  if (_engineers is EqualUnmodifiableListView) return _engineers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_engineers);
}

@override final  int staffCount;
@override final  String startDate;
@override final  String? expectedCompletionDate;
@override final  String? contractAmount;
@override final  String? contactName;
@override final  String? contactPhone;
@override final  double? latitude;
@override final  double? longitude;
@override final  int? geofenceRadiusM;
 final  List<SiteStaffMember> _staff;
@override@JsonKey() List<SiteStaffMember> get staff {
  if (_staff is EqualUnmodifiableListView) return _staff;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_staff);
}

@override final  SiteFinancials? financials;
@override final  int openIssues;

/// Create a copy of SiteDetail
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SiteDetailCopyWith<_SiteDetail> get copyWith => __$SiteDetailCopyWithImpl<_SiteDetail>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SiteDetailToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SiteDetail&&(identical(other.id, id) || other.id == id)&&(identical(other.code, code) || other.code == code)&&(identical(other.name, name) || other.name == name)&&(identical(other.status, status) || other.status == status)&&(identical(other.progressPercent, progressPercent) || other.progressPercent == progressPercent)&&(identical(other.address, address) || other.address == address)&&(identical(other.client, client) || other.client == client)&&const DeepCollectionEquality().equals(other.engineers, _engineers)&&(identical(other.staffCount, staffCount) || other.staffCount == staffCount)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.expectedCompletionDate, expectedCompletionDate) || other.expectedCompletionDate == expectedCompletionDate)&&(identical(other.contractAmount, contractAmount) || other.contractAmount == contractAmount)&&(identical(other.contactName, contactName) || other.contactName == contactName)&&(identical(other.contactPhone, contactPhone) || other.contactPhone == contactPhone)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.geofenceRadiusM, geofenceRadiusM) || other.geofenceRadiusM == geofenceRadiusM)&&const DeepCollectionEquality().equals(other.staff, _staff)&&(identical(other.financials, financials) || other.financials == financials)&&(identical(other.openIssues, openIssues) || other.openIssues == openIssues));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hashAll([runtimeType,id,code,name,status,progressPercent,address,client,const DeepCollectionEquality().hash(_engineers),staffCount,startDate,expectedCompletionDate,contractAmount,contactName,contactPhone,latitude,longitude,geofenceRadiusM,const DeepCollectionEquality().hash(_staff),financials,openIssues]);
}

@override
String toString() {
    return 'SiteDetail(id: $id, code: $code, name: $name, status: $status, progressPercent: $progressPercent, address: $address, client: $client, engineers: $engineers, staffCount: $staffCount, startDate: $startDate, expectedCompletionDate: $expectedCompletionDate, contractAmount: $contractAmount, contactName: $contactName, contactPhone: $contactPhone, latitude: $latitude, longitude: $longitude, geofenceRadiusM: $geofenceRadiusM, staff: $staff, financials: $financials, openIssues: $openIssues)';
}


}

/// @nodoc
abstract mixin class _$SiteDetailCopyWith<$Res> implements $SiteDetailCopyWith<$Res> {
  factory _$SiteDetailCopyWith(_SiteDetail value, $Res Function(_SiteDetail) _then) = __$SiteDetailCopyWithImpl;
@override @useResult
$Res call({
 String id, String code, String name, SiteStatus status, int progressPercent, String address, SiteClient client, List<IdName> engineers, int staffCount, String startDate, String? expectedCompletionDate, String? contractAmount, String? contactName, String? contactPhone, double? latitude, double? longitude, int? geofenceRadiusM, List<SiteStaffMember> staff, SiteFinancials? financials, int openIssues
});


@override $SiteClientCopyWith<$Res> get client;@override $SiteFinancialsCopyWith<$Res>? get financials;

}
/// @nodoc
class __$SiteDetailCopyWithImpl<$Res>
    implements _$SiteDetailCopyWith<$Res> {
  __$SiteDetailCopyWithImpl(this._self, this._then);

  final _SiteDetail _self;
  final $Res Function(_SiteDetail) _then;

/// Create a copy of SiteDetail
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? code = null,Object? name = null,Object? status = null,Object? progressPercent = null,Object? address = null,Object? client = null,Object? engineers = null,Object? staffCount = null,Object? startDate = null,Object? expectedCompletionDate = freezed,Object? contractAmount = freezed,Object? contactName = freezed,Object? contactPhone = freezed,Object? latitude = freezed,Object? longitude = freezed,Object? geofenceRadiusM = freezed,Object? staff = null,Object? financials = freezed,Object? openIssues = null,}) {
  return _then(_SiteDetail(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as SiteStatus,progressPercent: null == progressPercent ? _self.progressPercent : progressPercent // ignore: cast_nullable_to_non_nullable
as int,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,client: null == client ? _self.client : client // ignore: cast_nullable_to_non_nullable
as SiteClient,engineers: null == engineers ? _self._engineers : engineers // ignore: cast_nullable_to_non_nullable
as List<IdName>,staffCount: null == staffCount ? _self.staffCount : staffCount // ignore: cast_nullable_to_non_nullable
as int,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as String,expectedCompletionDate: freezed == expectedCompletionDate ? _self.expectedCompletionDate : expectedCompletionDate // ignore: cast_nullable_to_non_nullable
as String?,contractAmount: freezed == contractAmount ? _self.contractAmount : contractAmount // ignore: cast_nullable_to_non_nullable
as String?,contactName: freezed == contactName ? _self.contactName : contactName // ignore: cast_nullable_to_non_nullable
as String?,contactPhone: freezed == contactPhone ? _self.contactPhone : contactPhone // ignore: cast_nullable_to_non_nullable
as String?,latitude: freezed == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double?,longitude: freezed == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double?,geofenceRadiusM: freezed == geofenceRadiusM ? _self.geofenceRadiusM : geofenceRadiusM // ignore: cast_nullable_to_non_nullable
as int?,staff: null == staff ? _self._staff : staff // ignore: cast_nullable_to_non_nullable
as List<SiteStaffMember>,financials: freezed == financials ? _self.financials : financials // ignore: cast_nullable_to_non_nullable
as SiteFinancials?,openIssues: null == openIssues ? _self.openIssues : openIssues // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of SiteDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SiteClientCopyWith<$Res> get client {
  
  return $SiteClientCopyWith<$Res>(_self.client, (value) {
    return _then(_self.copyWith(client: value));
  });
}/// Create a copy of SiteDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SiteFinancialsCopyWith<$Res>? get financials {
    if (_self.financials == null) {
    return null;
  }

  return $SiteFinancialsCopyWith<$Res>(_self.financials!, (value) {
    return _then(_self.copyWith(financials: value));
  });
}
}

// dart format on
