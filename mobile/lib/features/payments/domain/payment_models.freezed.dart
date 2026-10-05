// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'payment_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Payment {

 String get id; String get amount; String get paidOn; PaymentMethod get method; String? get reference; String? get remarks; SiteRef get site; IdName get client; IdName get recordedBy; DateTime get createdAt; DateTime? get voidedAt; IdName? get voidedBy; String? get voidReason;
/// Create a copy of Payment
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaymentCopyWith<Payment> get copyWith => _$PaymentCopyWithImpl<Payment>(this as Payment, _$identity);

  /// Serializes this Payment to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Payment;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Payment&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.amount, _this.amount) || other.amount == _this.amount)&&(identical(other.paidOn, _this.paidOn) || other.paidOn == _this.paidOn)&&(identical(other.method, _this.method) || other.method == _this.method)&&(identical(other.reference, _this.reference) || other.reference == _this.reference)&&(identical(other.remarks, _this.remarks) || other.remarks == _this.remarks)&&(identical(other.site, _this.site) || other.site == _this.site)&&(identical(other.client, _this.client) || other.client == _this.client)&&(identical(other.recordedBy, _this.recordedBy) || other.recordedBy == _this.recordedBy)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.voidedAt, _this.voidedAt) || other.voidedAt == _this.voidedAt)&&(identical(other.voidedBy, _this.voidedBy) || other.voidedBy == _this.voidedBy)&&(identical(other.voidReason, _this.voidReason) || other.voidReason == _this.voidReason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Payment;
  return Object.hash(runtimeType,_this.id,_this.amount,_this.paidOn,_this.method,_this.reference,_this.remarks,_this.site,_this.client,_this.recordedBy,_this.createdAt,_this.voidedAt,_this.voidedBy,_this.voidReason);
}

@override
String toString() {
  final _this = this as Payment;
  return 'Payment(id: ${_this.id}, amount: ${_this.amount}, paidOn: ${_this.paidOn}, method: ${_this.method}, reference: ${_this.reference}, remarks: ${_this.remarks}, site: ${_this.site}, client: ${_this.client}, recordedBy: ${_this.recordedBy}, createdAt: ${_this.createdAt}, voidedAt: ${_this.voidedAt}, voidedBy: ${_this.voidedBy}, voidReason: ${_this.voidReason})';
}


}

/// @nodoc
abstract mixin class $PaymentCopyWith<$Res>  {
  factory $PaymentCopyWith(Payment value, $Res Function(Payment) _then) = _$PaymentCopyWithImpl;
@useResult
$Res call({
 String id, String amount, String paidOn, PaymentMethod method, String? reference, String? remarks, SiteRef site, IdName client, IdName recordedBy, DateTime createdAt, DateTime? voidedAt, IdName? voidedBy, String? voidReason
});


$SiteRefCopyWith<$Res> get site;$IdNameCopyWith<$Res> get client;$IdNameCopyWith<$Res> get recordedBy;$IdNameCopyWith<$Res>? get voidedBy;

}
/// @nodoc
class _$PaymentCopyWithImpl<$Res>
    implements $PaymentCopyWith<$Res> {
  _$PaymentCopyWithImpl(this._self, this._then);

  final Payment _self;
  final $Res Function(Payment) _then;

/// Create a copy of Payment
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? amount = null,Object? paidOn = null,Object? method = null,Object? reference = freezed,Object? remarks = freezed,Object? site = null,Object? client = null,Object? recordedBy = null,Object? createdAt = null,Object? voidedAt = freezed,Object? voidedBy = freezed,Object? voidReason = freezed,}) {
  return _then(Payment(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as String,paidOn: null == paidOn ? _self.paidOn : paidOn // ignore: cast_nullable_to_non_nullable
as String,method: null == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as PaymentMethod,reference: freezed == reference ? _self.reference : reference // ignore: cast_nullable_to_non_nullable
as String?,remarks: freezed == remarks ? _self.remarks : remarks // ignore: cast_nullable_to_non_nullable
as String?,site: null == site ? _self.site : site // ignore: cast_nullable_to_non_nullable
as SiteRef,client: null == client ? _self.client : client // ignore: cast_nullable_to_non_nullable
as IdName,recordedBy: null == recordedBy ? _self.recordedBy : recordedBy // ignore: cast_nullable_to_non_nullable
as IdName,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,voidedAt: freezed == voidedAt ? _self.voidedAt : voidedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,voidedBy: freezed == voidedBy ? _self.voidedBy : voidedBy // ignore: cast_nullable_to_non_nullable
as IdName?,voidReason: freezed == voidReason ? _self.voidReason : voidReason // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of Payment
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SiteRefCopyWith<$Res> get site {
  
  return $SiteRefCopyWith<$Res>(_self.site, (value) {
    return _then(_self.copyWith(site: value));
  });
}/// Create a copy of Payment
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$IdNameCopyWith<$Res> get client {
  
  return $IdNameCopyWith<$Res>(_self.client, (value) {
    return _then(_self.copyWith(client: value));
  });
}/// Create a copy of Payment
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$IdNameCopyWith<$Res> get recordedBy {
  
  return $IdNameCopyWith<$Res>(_self.recordedBy, (value) {
    return _then(_self.copyWith(recordedBy: value));
  });
}/// Create a copy of Payment
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$IdNameCopyWith<$Res>? get voidedBy {
    if (_self.voidedBy == null) {
    return null;
  }

  return $IdNameCopyWith<$Res>(_self.voidedBy!, (value) {
    return _then(_self.copyWith(voidedBy: value));
  });
}
}


/// Adds pattern-matching-related methods to [Payment].
extension PaymentPatterns on Payment {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Payment value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Payment() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Payment value)  $default,){
final _that = this;
switch (_that) {
case _Payment():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Payment value)?  $default,){
final _that = this;
switch (_that) {
case _Payment() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String amount,  String paidOn,  PaymentMethod method,  String? reference,  String? remarks,  SiteRef site,  IdName client,  IdName recordedBy,  DateTime createdAt,  DateTime? voidedAt,  IdName? voidedBy,  String? voidReason)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Payment() when $default != null:
return $default(_that.id,_that.amount,_that.paidOn,_that.method,_that.reference,_that.remarks,_that.site,_that.client,_that.recordedBy,_that.createdAt,_that.voidedAt,_that.voidedBy,_that.voidReason);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String amount,  String paidOn,  PaymentMethod method,  String? reference,  String? remarks,  SiteRef site,  IdName client,  IdName recordedBy,  DateTime createdAt,  DateTime? voidedAt,  IdName? voidedBy,  String? voidReason)  $default,) {final _that = this;
switch (_that) {
case _Payment():
return $default(_that.id,_that.amount,_that.paidOn,_that.method,_that.reference,_that.remarks,_that.site,_that.client,_that.recordedBy,_that.createdAt,_that.voidedAt,_that.voidedBy,_that.voidReason);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String amount,  String paidOn,  PaymentMethod method,  String? reference,  String? remarks,  SiteRef site,  IdName client,  IdName recordedBy,  DateTime createdAt,  DateTime? voidedAt,  IdName? voidedBy,  String? voidReason)?  $default,) {final _that = this;
switch (_that) {
case _Payment() when $default != null:
return $default(_that.id,_that.amount,_that.paidOn,_that.method,_that.reference,_that.remarks,_that.site,_that.client,_that.recordedBy,_that.createdAt,_that.voidedAt,_that.voidedBy,_that.voidReason);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Payment extends Payment {
  const _Payment({required this.id, required this.amount, required this.paidOn, required this.method, this.reference, this.remarks, required this.site, required this.client, required this.recordedBy, required this.createdAt, this.voidedAt, this.voidedBy, this.voidReason}): super._();
  factory _Payment.fromJson(Map<String, dynamic> json) => _$PaymentFromJson(json);

@override final  String id;
@override final  String amount;
@override final  String paidOn;
@override final  PaymentMethod method;
@override final  String? reference;
@override final  String? remarks;
@override final  SiteRef site;
@override final  IdName client;
@override final  IdName recordedBy;
@override final  DateTime createdAt;
@override final  DateTime? voidedAt;
@override final  IdName? voidedBy;
@override final  String? voidReason;

/// Create a copy of Payment
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PaymentCopyWith<_Payment> get copyWith => __$PaymentCopyWithImpl<_Payment>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PaymentToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Payment&&(identical(other.id, id) || other.id == id)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.paidOn, paidOn) || other.paidOn == paidOn)&&(identical(other.method, method) || other.method == method)&&(identical(other.reference, reference) || other.reference == reference)&&(identical(other.remarks, remarks) || other.remarks == remarks)&&(identical(other.site, site) || other.site == site)&&(identical(other.client, client) || other.client == client)&&(identical(other.recordedBy, recordedBy) || other.recordedBy == recordedBy)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.voidedAt, voidedAt) || other.voidedAt == voidedAt)&&(identical(other.voidedBy, voidedBy) || other.voidedBy == voidedBy)&&(identical(other.voidReason, voidReason) || other.voidReason == voidReason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,amount,paidOn,method,reference,remarks,site,client,recordedBy,createdAt,voidedAt,voidedBy,voidReason);
}

@override
String toString() {
    return 'Payment(id: $id, amount: $amount, paidOn: $paidOn, method: $method, reference: $reference, remarks: $remarks, site: $site, client: $client, recordedBy: $recordedBy, createdAt: $createdAt, voidedAt: $voidedAt, voidedBy: $voidedBy, voidReason: $voidReason)';
}


}

/// @nodoc
abstract mixin class _$PaymentCopyWith<$Res> implements $PaymentCopyWith<$Res> {
  factory _$PaymentCopyWith(_Payment value, $Res Function(_Payment) _then) = __$PaymentCopyWithImpl;
@override @useResult
$Res call({
 String id, String amount, String paidOn, PaymentMethod method, String? reference, String? remarks, SiteRef site, IdName client, IdName recordedBy, DateTime createdAt, DateTime? voidedAt, IdName? voidedBy, String? voidReason
});


@override $SiteRefCopyWith<$Res> get site;@override $IdNameCopyWith<$Res> get client;@override $IdNameCopyWith<$Res> get recordedBy;@override $IdNameCopyWith<$Res>? get voidedBy;

}
/// @nodoc
class __$PaymentCopyWithImpl<$Res>
    implements _$PaymentCopyWith<$Res> {
  __$PaymentCopyWithImpl(this._self, this._then);

  final _Payment _self;
  final $Res Function(_Payment) _then;

/// Create a copy of Payment
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? amount = null,Object? paidOn = null,Object? method = null,Object? reference = freezed,Object? remarks = freezed,Object? site = null,Object? client = null,Object? recordedBy = null,Object? createdAt = null,Object? voidedAt = freezed,Object? voidedBy = freezed,Object? voidReason = freezed,}) {
  return _then(_Payment(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as String,paidOn: null == paidOn ? _self.paidOn : paidOn // ignore: cast_nullable_to_non_nullable
as String,method: null == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as PaymentMethod,reference: freezed == reference ? _self.reference : reference // ignore: cast_nullable_to_non_nullable
as String?,remarks: freezed == remarks ? _self.remarks : remarks // ignore: cast_nullable_to_non_nullable
as String?,site: null == site ? _self.site : site // ignore: cast_nullable_to_non_nullable
as SiteRef,client: null == client ? _self.client : client // ignore: cast_nullable_to_non_nullable
as IdName,recordedBy: null == recordedBy ? _self.recordedBy : recordedBy // ignore: cast_nullable_to_non_nullable
as IdName,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,voidedAt: freezed == voidedAt ? _self.voidedAt : voidedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,voidedBy: freezed == voidedBy ? _self.voidedBy : voidedBy // ignore: cast_nullable_to_non_nullable
as IdName?,voidReason: freezed == voidReason ? _self.voidReason : voidReason // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of Payment
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SiteRefCopyWith<$Res> get site {
  
  return $SiteRefCopyWith<$Res>(_self.site, (value) {
    return _then(_self.copyWith(site: value));
  });
}/// Create a copy of Payment
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$IdNameCopyWith<$Res> get client {
  
  return $IdNameCopyWith<$Res>(_self.client, (value) {
    return _then(_self.copyWith(client: value));
  });
}/// Create a copy of Payment
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$IdNameCopyWith<$Res> get recordedBy {
  
  return $IdNameCopyWith<$Res>(_self.recordedBy, (value) {
    return _then(_self.copyWith(recordedBy: value));
  });
}/// Create a copy of Payment
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$IdNameCopyWith<$Res>? get voidedBy {
    if (_self.voidedBy == null) {
    return null;
  }

  return $IdNameCopyWith<$Res>(_self.voidedBy!, (value) {
    return _then(_self.copyWith(voidedBy: value));
  });
}
}


/// @nodoc
mixin _$MoneySite {

 String get id; String get code; String get name; SiteStatus get status;
/// Create a copy of MoneySite
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MoneySiteCopyWith<MoneySite> get copyWith => _$MoneySiteCopyWithImpl<MoneySite>(this as MoneySite, _$identity);

  /// Serializes this MoneySite to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MoneySite;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MoneySite&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.code, _this.code) || other.code == _this.code)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.status, _this.status) || other.status == _this.status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MoneySite;
  return Object.hash(runtimeType,_this.id,_this.code,_this.name,_this.status);
}

@override
String toString() {
  final _this = this as MoneySite;
  return 'MoneySite(id: ${_this.id}, code: ${_this.code}, name: ${_this.name}, status: ${_this.status})';
}


}

/// @nodoc
abstract mixin class $MoneySiteCopyWith<$Res>  {
  factory $MoneySiteCopyWith(MoneySite value, $Res Function(MoneySite) _then) = _$MoneySiteCopyWithImpl;
@useResult
$Res call({
 String id, String code, String name, SiteStatus status
});




}
/// @nodoc
class _$MoneySiteCopyWithImpl<$Res>
    implements $MoneySiteCopyWith<$Res> {
  _$MoneySiteCopyWithImpl(this._self, this._then);

  final MoneySite _self;
  final $Res Function(MoneySite) _then;

/// Create a copy of MoneySite
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? code = null,Object? name = null,Object? status = null,}) {
  return _then(MoneySite(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as SiteStatus,
  ));
}

}


/// Adds pattern-matching-related methods to [MoneySite].
extension MoneySitePatterns on MoneySite {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MoneySite value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MoneySite() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MoneySite value)  $default,){
final _that = this;
switch (_that) {
case _MoneySite():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MoneySite value)?  $default,){
final _that = this;
switch (_that) {
case _MoneySite() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String code,  String name,  SiteStatus status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MoneySite() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String code,  String name,  SiteStatus status)  $default,) {final _that = this;
switch (_that) {
case _MoneySite():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String code,  String name,  SiteStatus status)?  $default,) {final _that = this;
switch (_that) {
case _MoneySite() when $default != null:
return $default(_that.id,_that.code,_that.name,_that.status);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MoneySite implements MoneySite {
  const _MoneySite({required this.id, required this.code, required this.name, required this.status});
  factory _MoneySite.fromJson(Map<String, dynamic> json) => _$MoneySiteFromJson(json);

@override final  String id;
@override final  String code;
@override final  String name;
@override final  SiteStatus status;

/// Create a copy of MoneySite
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MoneySiteCopyWith<_MoneySite> get copyWith => __$MoneySiteCopyWithImpl<_MoneySite>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MoneySiteToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MoneySite&&(identical(other.id, id) || other.id == id)&&(identical(other.code, code) || other.code == code)&&(identical(other.name, name) || other.name == name)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,code,name,status);
}

@override
String toString() {
    return 'MoneySite(id: $id, code: $code, name: $name, status: $status)';
}


}

/// @nodoc
abstract mixin class _$MoneySiteCopyWith<$Res> implements $MoneySiteCopyWith<$Res> {
  factory _$MoneySiteCopyWith(_MoneySite value, $Res Function(_MoneySite) _then) = __$MoneySiteCopyWithImpl;
@override @useResult
$Res call({
 String id, String code, String name, SiteStatus status
});




}
/// @nodoc
class __$MoneySiteCopyWithImpl<$Res>
    implements _$MoneySiteCopyWith<$Res> {
  __$MoneySiteCopyWithImpl(this._self, this._then);

  final _MoneySite _self;
  final $Res Function(_MoneySite) _then;

/// Create a copy of MoneySite
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? code = null,Object? name = null,Object? status = null,}) {
  return _then(_MoneySite(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as SiteStatus,
  ));
}


}


/// @nodoc
mixin _$SiteMoney {

 MoneySite get site; IdName get client; SiteFinancials get financials;
/// Create a copy of SiteMoney
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SiteMoneyCopyWith<SiteMoney> get copyWith => _$SiteMoneyCopyWithImpl<SiteMoney>(this as SiteMoney, _$identity);

  /// Serializes this SiteMoney to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as SiteMoney;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SiteMoney&&(identical(other.site, _this.site) || other.site == _this.site)&&(identical(other.client, _this.client) || other.client == _this.client)&&(identical(other.financials, _this.financials) || other.financials == _this.financials));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as SiteMoney;
  return Object.hash(runtimeType,_this.site,_this.client,_this.financials);
}

@override
String toString() {
  final _this = this as SiteMoney;
  return 'SiteMoney(site: ${_this.site}, client: ${_this.client}, financials: ${_this.financials})';
}


}

/// @nodoc
abstract mixin class $SiteMoneyCopyWith<$Res>  {
  factory $SiteMoneyCopyWith(SiteMoney value, $Res Function(SiteMoney) _then) = _$SiteMoneyCopyWithImpl;
@useResult
$Res call({
 MoneySite site, IdName client, SiteFinancials financials
});


$MoneySiteCopyWith<$Res> get site;$IdNameCopyWith<$Res> get client;$SiteFinancialsCopyWith<$Res> get financials;

}
/// @nodoc
class _$SiteMoneyCopyWithImpl<$Res>
    implements $SiteMoneyCopyWith<$Res> {
  _$SiteMoneyCopyWithImpl(this._self, this._then);

  final SiteMoney _self;
  final $Res Function(SiteMoney) _then;

/// Create a copy of SiteMoney
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? site = null,Object? client = null,Object? financials = null,}) {
  return _then(SiteMoney(
site: null == site ? _self.site : site // ignore: cast_nullable_to_non_nullable
as MoneySite,client: null == client ? _self.client : client // ignore: cast_nullable_to_non_nullable
as IdName,financials: null == financials ? _self.financials : financials // ignore: cast_nullable_to_non_nullable
as SiteFinancials,
  ));
}
/// Create a copy of SiteMoney
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MoneySiteCopyWith<$Res> get site {
  
  return $MoneySiteCopyWith<$Res>(_self.site, (value) {
    return _then(_self.copyWith(site: value));
  });
}/// Create a copy of SiteMoney
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$IdNameCopyWith<$Res> get client {
  
  return $IdNameCopyWith<$Res>(_self.client, (value) {
    return _then(_self.copyWith(client: value));
  });
}/// Create a copy of SiteMoney
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SiteFinancialsCopyWith<$Res> get financials {
  
  return $SiteFinancialsCopyWith<$Res>(_self.financials, (value) {
    return _then(_self.copyWith(financials: value));
  });
}
}


/// Adds pattern-matching-related methods to [SiteMoney].
extension SiteMoneyPatterns on SiteMoney {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SiteMoney value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SiteMoney() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SiteMoney value)  $default,){
final _that = this;
switch (_that) {
case _SiteMoney():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SiteMoney value)?  $default,){
final _that = this;
switch (_that) {
case _SiteMoney() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( MoneySite site,  IdName client,  SiteFinancials financials)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SiteMoney() when $default != null:
return $default(_that.site,_that.client,_that.financials);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( MoneySite site,  IdName client,  SiteFinancials financials)  $default,) {final _that = this;
switch (_that) {
case _SiteMoney():
return $default(_that.site,_that.client,_that.financials);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( MoneySite site,  IdName client,  SiteFinancials financials)?  $default,) {final _that = this;
switch (_that) {
case _SiteMoney() when $default != null:
return $default(_that.site,_that.client,_that.financials);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SiteMoney implements SiteMoney {
  const _SiteMoney({required this.site, required this.client, required this.financials});
  factory _SiteMoney.fromJson(Map<String, dynamic> json) => _$SiteMoneyFromJson(json);

@override final  MoneySite site;
@override final  IdName client;
@override final  SiteFinancials financials;

/// Create a copy of SiteMoney
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SiteMoneyCopyWith<_SiteMoney> get copyWith => __$SiteMoneyCopyWithImpl<_SiteMoney>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SiteMoneyToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SiteMoney&&(identical(other.site, site) || other.site == site)&&(identical(other.client, client) || other.client == client)&&(identical(other.financials, financials) || other.financials == financials));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,site,client,financials);
}

@override
String toString() {
    return 'SiteMoney(site: $site, client: $client, financials: $financials)';
}


}

/// @nodoc
abstract mixin class _$SiteMoneyCopyWith<$Res> implements $SiteMoneyCopyWith<$Res> {
  factory _$SiteMoneyCopyWith(_SiteMoney value, $Res Function(_SiteMoney) _then) = __$SiteMoneyCopyWithImpl;
@override @useResult
$Res call({
 MoneySite site, IdName client, SiteFinancials financials
});


@override $MoneySiteCopyWith<$Res> get site;@override $IdNameCopyWith<$Res> get client;@override $SiteFinancialsCopyWith<$Res> get financials;

}
/// @nodoc
class __$SiteMoneyCopyWithImpl<$Res>
    implements _$SiteMoneyCopyWith<$Res> {
  __$SiteMoneyCopyWithImpl(this._self, this._then);

  final _SiteMoney _self;
  final $Res Function(_SiteMoney) _then;

/// Create a copy of SiteMoney
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? site = null,Object? client = null,Object? financials = null,}) {
  return _then(_SiteMoney(
site: null == site ? _self.site : site // ignore: cast_nullable_to_non_nullable
as MoneySite,client: null == client ? _self.client : client // ignore: cast_nullable_to_non_nullable
as IdName,financials: null == financials ? _self.financials : financials // ignore: cast_nullable_to_non_nullable
as SiteFinancials,
  ));
}

/// Create a copy of SiteMoney
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MoneySiteCopyWith<$Res> get site {
  
  return $MoneySiteCopyWith<$Res>(_self.site, (value) {
    return _then(_self.copyWith(site: value));
  });
}/// Create a copy of SiteMoney
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$IdNameCopyWith<$Res> get client {
  
  return $IdNameCopyWith<$Res>(_self.client, (value) {
    return _then(_self.copyWith(client: value));
  });
}/// Create a copy of SiteMoney
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SiteFinancialsCopyWith<$Res> get financials {
  
  return $SiteFinancialsCopyWith<$Res>(_self.financials, (value) {
    return _then(_self.copyWith(financials: value));
  });
}
}


/// @nodoc
mixin _$SiteMoneyRow {

 MoneySite get site; IdName get client; SiteFinancials get financials;/// The earliest milestone not fully paid.
 MilestoneView? get nextDue;
/// Create a copy of SiteMoneyRow
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SiteMoneyRowCopyWith<SiteMoneyRow> get copyWith => _$SiteMoneyRowCopyWithImpl<SiteMoneyRow>(this as SiteMoneyRow, _$identity);

  /// Serializes this SiteMoneyRow to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as SiteMoneyRow;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SiteMoneyRow&&(identical(other.site, _this.site) || other.site == _this.site)&&(identical(other.client, _this.client) || other.client == _this.client)&&(identical(other.financials, _this.financials) || other.financials == _this.financials)&&(identical(other.nextDue, _this.nextDue) || other.nextDue == _this.nextDue));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as SiteMoneyRow;
  return Object.hash(runtimeType,_this.site,_this.client,_this.financials,_this.nextDue);
}

@override
String toString() {
  final _this = this as SiteMoneyRow;
  return 'SiteMoneyRow(site: ${_this.site}, client: ${_this.client}, financials: ${_this.financials}, nextDue: ${_this.nextDue})';
}


}

/// @nodoc
abstract mixin class $SiteMoneyRowCopyWith<$Res>  {
  factory $SiteMoneyRowCopyWith(SiteMoneyRow value, $Res Function(SiteMoneyRow) _then) = _$SiteMoneyRowCopyWithImpl;
@useResult
$Res call({
 MoneySite site, IdName client, SiteFinancials financials, MilestoneView? nextDue
});


$MoneySiteCopyWith<$Res> get site;$IdNameCopyWith<$Res> get client;$SiteFinancialsCopyWith<$Res> get financials;$MilestoneViewCopyWith<$Res>? get nextDue;

}
/// @nodoc
class _$SiteMoneyRowCopyWithImpl<$Res>
    implements $SiteMoneyRowCopyWith<$Res> {
  _$SiteMoneyRowCopyWithImpl(this._self, this._then);

  final SiteMoneyRow _self;
  final $Res Function(SiteMoneyRow) _then;

/// Create a copy of SiteMoneyRow
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? site = null,Object? client = null,Object? financials = null,Object? nextDue = freezed,}) {
  return _then(SiteMoneyRow(
site: null == site ? _self.site : site // ignore: cast_nullable_to_non_nullable
as MoneySite,client: null == client ? _self.client : client // ignore: cast_nullable_to_non_nullable
as IdName,financials: null == financials ? _self.financials : financials // ignore: cast_nullable_to_non_nullable
as SiteFinancials,nextDue: freezed == nextDue ? _self.nextDue : nextDue // ignore: cast_nullable_to_non_nullable
as MilestoneView?,
  ));
}
/// Create a copy of SiteMoneyRow
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MoneySiteCopyWith<$Res> get site {
  
  return $MoneySiteCopyWith<$Res>(_self.site, (value) {
    return _then(_self.copyWith(site: value));
  });
}/// Create a copy of SiteMoneyRow
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$IdNameCopyWith<$Res> get client {
  
  return $IdNameCopyWith<$Res>(_self.client, (value) {
    return _then(_self.copyWith(client: value));
  });
}/// Create a copy of SiteMoneyRow
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SiteFinancialsCopyWith<$Res> get financials {
  
  return $SiteFinancialsCopyWith<$Res>(_self.financials, (value) {
    return _then(_self.copyWith(financials: value));
  });
}/// Create a copy of SiteMoneyRow
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MilestoneViewCopyWith<$Res>? get nextDue {
    if (_self.nextDue == null) {
    return null;
  }

  return $MilestoneViewCopyWith<$Res>(_self.nextDue!, (value) {
    return _then(_self.copyWith(nextDue: value));
  });
}
}


/// Adds pattern-matching-related methods to [SiteMoneyRow].
extension SiteMoneyRowPatterns on SiteMoneyRow {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SiteMoneyRow value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SiteMoneyRow() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SiteMoneyRow value)  $default,){
final _that = this;
switch (_that) {
case _SiteMoneyRow():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SiteMoneyRow value)?  $default,){
final _that = this;
switch (_that) {
case _SiteMoneyRow() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( MoneySite site,  IdName client,  SiteFinancials financials,  MilestoneView? nextDue)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SiteMoneyRow() when $default != null:
return $default(_that.site,_that.client,_that.financials,_that.nextDue);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( MoneySite site,  IdName client,  SiteFinancials financials,  MilestoneView? nextDue)  $default,) {final _that = this;
switch (_that) {
case _SiteMoneyRow():
return $default(_that.site,_that.client,_that.financials,_that.nextDue);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( MoneySite site,  IdName client,  SiteFinancials financials,  MilestoneView? nextDue)?  $default,) {final _that = this;
switch (_that) {
case _SiteMoneyRow() when $default != null:
return $default(_that.site,_that.client,_that.financials,_that.nextDue);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SiteMoneyRow implements SiteMoneyRow {
  const _SiteMoneyRow({required this.site, required this.client, required this.financials, this.nextDue});
  factory _SiteMoneyRow.fromJson(Map<String, dynamic> json) => _$SiteMoneyRowFromJson(json);

@override final  MoneySite site;
@override final  IdName client;
@override final  SiteFinancials financials;
/// The earliest milestone not fully paid.
@override final  MilestoneView? nextDue;

/// Create a copy of SiteMoneyRow
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SiteMoneyRowCopyWith<_SiteMoneyRow> get copyWith => __$SiteMoneyRowCopyWithImpl<_SiteMoneyRow>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SiteMoneyRowToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SiteMoneyRow&&(identical(other.site, site) || other.site == site)&&(identical(other.client, client) || other.client == client)&&(identical(other.financials, financials) || other.financials == financials)&&(identical(other.nextDue, nextDue) || other.nextDue == nextDue));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,site,client,financials,nextDue);
}

@override
String toString() {
    return 'SiteMoneyRow(site: $site, client: $client, financials: $financials, nextDue: $nextDue)';
}


}

/// @nodoc
abstract mixin class _$SiteMoneyRowCopyWith<$Res> implements $SiteMoneyRowCopyWith<$Res> {
  factory _$SiteMoneyRowCopyWith(_SiteMoneyRow value, $Res Function(_SiteMoneyRow) _then) = __$SiteMoneyRowCopyWithImpl;
@override @useResult
$Res call({
 MoneySite site, IdName client, SiteFinancials financials, MilestoneView? nextDue
});


@override $MoneySiteCopyWith<$Res> get site;@override $IdNameCopyWith<$Res> get client;@override $SiteFinancialsCopyWith<$Res> get financials;@override $MilestoneViewCopyWith<$Res>? get nextDue;

}
/// @nodoc
class __$SiteMoneyRowCopyWithImpl<$Res>
    implements _$SiteMoneyRowCopyWith<$Res> {
  __$SiteMoneyRowCopyWithImpl(this._self, this._then);

  final _SiteMoneyRow _self;
  final $Res Function(_SiteMoneyRow) _then;

/// Create a copy of SiteMoneyRow
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? site = null,Object? client = null,Object? financials = null,Object? nextDue = freezed,}) {
  return _then(_SiteMoneyRow(
site: null == site ? _self.site : site // ignore: cast_nullable_to_non_nullable
as MoneySite,client: null == client ? _self.client : client // ignore: cast_nullable_to_non_nullable
as IdName,financials: null == financials ? _self.financials : financials // ignore: cast_nullable_to_non_nullable
as SiteFinancials,nextDue: freezed == nextDue ? _self.nextDue : nextDue // ignore: cast_nullable_to_non_nullable
as MilestoneView?,
  ));
}

/// Create a copy of SiteMoneyRow
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MoneySiteCopyWith<$Res> get site {
  
  return $MoneySiteCopyWith<$Res>(_self.site, (value) {
    return _then(_self.copyWith(site: value));
  });
}/// Create a copy of SiteMoneyRow
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$IdNameCopyWith<$Res> get client {
  
  return $IdNameCopyWith<$Res>(_self.client, (value) {
    return _then(_self.copyWith(client: value));
  });
}/// Create a copy of SiteMoneyRow
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SiteFinancialsCopyWith<$Res> get financials {
  
  return $SiteFinancialsCopyWith<$Res>(_self.financials, (value) {
    return _then(_self.copyWith(financials: value));
  });
}/// Create a copy of SiteMoneyRow
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MilestoneViewCopyWith<$Res>? get nextDue {
    if (_self.nextDue == null) {
    return null;
  }

  return $MilestoneViewCopyWith<$Res>(_self.nextDue!, (value) {
    return _then(_self.copyWith(nextDue: value));
  });
}
}


/// @nodoc
mixin _$PaymentsSummary {

 MoneyTotals get totals; List<SiteMoneyRow> get sites;
/// Create a copy of PaymentsSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaymentsSummaryCopyWith<PaymentsSummary> get copyWith => _$PaymentsSummaryCopyWithImpl<PaymentsSummary>(this as PaymentsSummary, _$identity);

  /// Serializes this PaymentsSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PaymentsSummary;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaymentsSummary&&(identical(other.totals, _this.totals) || other.totals == _this.totals)&&const DeepCollectionEquality().equals(other.sites, _this.sites));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PaymentsSummary;
  return Object.hash(runtimeType,_this.totals,const DeepCollectionEquality().hash(_this.sites));
}

@override
String toString() {
  final _this = this as PaymentsSummary;
  return 'PaymentsSummary(totals: ${_this.totals}, sites: ${_this.sites})';
}


}

/// @nodoc
abstract mixin class $PaymentsSummaryCopyWith<$Res>  {
  factory $PaymentsSummaryCopyWith(PaymentsSummary value, $Res Function(PaymentsSummary) _then) = _$PaymentsSummaryCopyWithImpl;
@useResult
$Res call({
 MoneyTotals totals, List<SiteMoneyRow> sites
});


$MoneyTotalsCopyWith<$Res> get totals;

}
/// @nodoc
class _$PaymentsSummaryCopyWithImpl<$Res>
    implements $PaymentsSummaryCopyWith<$Res> {
  _$PaymentsSummaryCopyWithImpl(this._self, this._then);

  final PaymentsSummary _self;
  final $Res Function(PaymentsSummary) _then;

/// Create a copy of PaymentsSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? totals = null,Object? sites = null,}) {
  return _then(PaymentsSummary(
totals: null == totals ? _self.totals : totals // ignore: cast_nullable_to_non_nullable
as MoneyTotals,sites: null == sites ? _self.sites : sites // ignore: cast_nullable_to_non_nullable
as List<SiteMoneyRow>,
  ));
}
/// Create a copy of PaymentsSummary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MoneyTotalsCopyWith<$Res> get totals {
  
  return $MoneyTotalsCopyWith<$Res>(_self.totals, (value) {
    return _then(_self.copyWith(totals: value));
  });
}
}


/// Adds pattern-matching-related methods to [PaymentsSummary].
extension PaymentsSummaryPatterns on PaymentsSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PaymentsSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PaymentsSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PaymentsSummary value)  $default,){
final _that = this;
switch (_that) {
case _PaymentsSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PaymentsSummary value)?  $default,){
final _that = this;
switch (_that) {
case _PaymentsSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( MoneyTotals totals,  List<SiteMoneyRow> sites)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PaymentsSummary() when $default != null:
return $default(_that.totals,_that.sites);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( MoneyTotals totals,  List<SiteMoneyRow> sites)  $default,) {final _that = this;
switch (_that) {
case _PaymentsSummary():
return $default(_that.totals,_that.sites);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( MoneyTotals totals,  List<SiteMoneyRow> sites)?  $default,) {final _that = this;
switch (_that) {
case _PaymentsSummary() when $default != null:
return $default(_that.totals,_that.sites);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PaymentsSummary implements PaymentsSummary {
  const _PaymentsSummary({required this.totals, required  List<SiteMoneyRow> sites}): _sites = sites;
  factory _PaymentsSummary.fromJson(Map<String, dynamic> json) => _$PaymentsSummaryFromJson(json);

@override final  MoneyTotals totals;
 final  List<SiteMoneyRow> _sites;
@override List<SiteMoneyRow> get sites {
  if (_sites is EqualUnmodifiableListView) return _sites;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sites);
}


/// Create a copy of PaymentsSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PaymentsSummaryCopyWith<_PaymentsSummary> get copyWith => __$PaymentsSummaryCopyWithImpl<_PaymentsSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PaymentsSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PaymentsSummary&&(identical(other.totals, totals) || other.totals == totals)&&const DeepCollectionEquality().equals(other.sites, _sites));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,totals,const DeepCollectionEquality().hash(_sites));
}

@override
String toString() {
    return 'PaymentsSummary(totals: $totals, sites: $sites)';
}


}

/// @nodoc
abstract mixin class _$PaymentsSummaryCopyWith<$Res> implements $PaymentsSummaryCopyWith<$Res> {
  factory _$PaymentsSummaryCopyWith(_PaymentsSummary value, $Res Function(_PaymentsSummary) _then) = __$PaymentsSummaryCopyWithImpl;
@override @useResult
$Res call({
 MoneyTotals totals, List<SiteMoneyRow> sites
});


@override $MoneyTotalsCopyWith<$Res> get totals;

}
/// @nodoc
class __$PaymentsSummaryCopyWithImpl<$Res>
    implements _$PaymentsSummaryCopyWith<$Res> {
  __$PaymentsSummaryCopyWithImpl(this._self, this._then);

  final _PaymentsSummary _self;
  final $Res Function(_PaymentsSummary) _then;

/// Create a copy of PaymentsSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? totals = null,Object? sites = null,}) {
  return _then(_PaymentsSummary(
totals: null == totals ? _self.totals : totals // ignore: cast_nullable_to_non_nullable
as MoneyTotals,sites: null == sites ? _self._sites : sites // ignore: cast_nullable_to_non_nullable
as List<SiteMoneyRow>,
  ));
}

/// Create a copy of PaymentsSummary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MoneyTotalsCopyWith<$Res> get totals {
  
  return $MoneyTotalsCopyWith<$Res>(_self.totals, (value) {
    return _then(_self.copyWith(totals: value));
  });
}
}

// dart format on
