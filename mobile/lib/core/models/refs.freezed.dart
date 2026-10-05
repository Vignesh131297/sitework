// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'refs.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$IdName {

 String get id; String get name;
/// Create a copy of IdName
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$IdNameCopyWith<IdName> get copyWith => _$IdNameCopyWithImpl<IdName>(this as IdName, _$identity);

  /// Serializes this IdName to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as IdName;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is IdName&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as IdName;
  return Object.hash(runtimeType,_this.id,_this.name);
}

@override
String toString() {
  final _this = this as IdName;
  return 'IdName(id: ${_this.id}, name: ${_this.name})';
}


}

/// @nodoc
abstract mixin class $IdNameCopyWith<$Res>  {
  factory $IdNameCopyWith(IdName value, $Res Function(IdName) _then) = _$IdNameCopyWithImpl;
@useResult
$Res call({
 String id, String name
});




}
/// @nodoc
class _$IdNameCopyWithImpl<$Res>
    implements $IdNameCopyWith<$Res> {
  _$IdNameCopyWithImpl(this._self, this._then);

  final IdName _self;
  final $Res Function(IdName) _then;

/// Create a copy of IdName
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,}) {
  return _then(IdName(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [IdName].
extension IdNamePatterns on IdName {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _IdName value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _IdName() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _IdName value)  $default,){
final _that = this;
switch (_that) {
case _IdName():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _IdName value)?  $default,){
final _that = this;
switch (_that) {
case _IdName() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _IdName() when $default != null:
return $default(_that.id,_that.name);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name)  $default,) {final _that = this;
switch (_that) {
case _IdName():
return $default(_that.id,_that.name);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name)?  $default,) {final _that = this;
switch (_that) {
case _IdName() when $default != null:
return $default(_that.id,_that.name);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _IdName implements IdName {
  const _IdName({required this.id, required this.name});
  factory _IdName.fromJson(Map<String, dynamic> json) => _$IdNameFromJson(json);

@override final  String id;
@override final  String name;

/// Create a copy of IdName
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$IdNameCopyWith<_IdName> get copyWith => __$IdNameCopyWithImpl<_IdName>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$IdNameToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _IdName&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name);
}

@override
String toString() {
    return 'IdName(id: $id, name: $name)';
}


}

/// @nodoc
abstract mixin class _$IdNameCopyWith<$Res> implements $IdNameCopyWith<$Res> {
  factory _$IdNameCopyWith(_IdName value, $Res Function(_IdName) _then) = __$IdNameCopyWithImpl;
@override @useResult
$Res call({
 String id, String name
});




}
/// @nodoc
class __$IdNameCopyWithImpl<$Res>
    implements _$IdNameCopyWith<$Res> {
  __$IdNameCopyWithImpl(this._self, this._then);

  final _IdName _self;
  final $Res Function(_IdName) _then;

/// Create a copy of IdName
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,}) {
  return _then(_IdName(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$SiteRef {

 String get id; String get code; String get name; String? get address;
/// Create a copy of SiteRef
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SiteRefCopyWith<SiteRef> get copyWith => _$SiteRefCopyWithImpl<SiteRef>(this as SiteRef, _$identity);

  /// Serializes this SiteRef to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as SiteRef;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SiteRef&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.code, _this.code) || other.code == _this.code)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.address, _this.address) || other.address == _this.address));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as SiteRef;
  return Object.hash(runtimeType,_this.id,_this.code,_this.name,_this.address);
}

@override
String toString() {
  final _this = this as SiteRef;
  return 'SiteRef(id: ${_this.id}, code: ${_this.code}, name: ${_this.name}, address: ${_this.address})';
}


}

/// @nodoc
abstract mixin class $SiteRefCopyWith<$Res>  {
  factory $SiteRefCopyWith(SiteRef value, $Res Function(SiteRef) _then) = _$SiteRefCopyWithImpl;
@useResult
$Res call({
 String id, String code, String name, String? address
});




}
/// @nodoc
class _$SiteRefCopyWithImpl<$Res>
    implements $SiteRefCopyWith<$Res> {
  _$SiteRefCopyWithImpl(this._self, this._then);

  final SiteRef _self;
  final $Res Function(SiteRef) _then;

/// Create a copy of SiteRef
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? code = null,Object? name = null,Object? address = freezed,}) {
  return _then(SiteRef(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [SiteRef].
extension SiteRefPatterns on SiteRef {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SiteRef value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SiteRef() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SiteRef value)  $default,){
final _that = this;
switch (_that) {
case _SiteRef():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SiteRef value)?  $default,){
final _that = this;
switch (_that) {
case _SiteRef() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String code,  String name,  String? address)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SiteRef() when $default != null:
return $default(_that.id,_that.code,_that.name,_that.address);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String code,  String name,  String? address)  $default,) {final _that = this;
switch (_that) {
case _SiteRef():
return $default(_that.id,_that.code,_that.name,_that.address);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String code,  String name,  String? address)?  $default,) {final _that = this;
switch (_that) {
case _SiteRef() when $default != null:
return $default(_that.id,_that.code,_that.name,_that.address);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SiteRef implements SiteRef {
  const _SiteRef({required this.id, required this.code, required this.name, this.address});
  factory _SiteRef.fromJson(Map<String, dynamic> json) => _$SiteRefFromJson(json);

@override final  String id;
@override final  String code;
@override final  String name;
@override final  String? address;

/// Create a copy of SiteRef
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SiteRefCopyWith<_SiteRef> get copyWith => __$SiteRefCopyWithImpl<_SiteRef>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SiteRefToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SiteRef&&(identical(other.id, id) || other.id == id)&&(identical(other.code, code) || other.code == code)&&(identical(other.name, name) || other.name == name)&&(identical(other.address, address) || other.address == address));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,code,name,address);
}

@override
String toString() {
    return 'SiteRef(id: $id, code: $code, name: $name, address: $address)';
}


}

/// @nodoc
abstract mixin class _$SiteRefCopyWith<$Res> implements $SiteRefCopyWith<$Res> {
  factory _$SiteRefCopyWith(_SiteRef value, $Res Function(_SiteRef) _then) = __$SiteRefCopyWithImpl;
@override @useResult
$Res call({
 String id, String code, String name, String? address
});




}
/// @nodoc
class __$SiteRefCopyWithImpl<$Res>
    implements _$SiteRefCopyWith<$Res> {
  __$SiteRefCopyWithImpl(this._self, this._then);

  final _SiteRef _self;
  final $Res Function(_SiteRef) _then;

/// Create a copy of SiteRef
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? code = null,Object? name = null,Object? address = freezed,}) {
  return _then(_SiteRef(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$PersonRef {

 String get id; String get name; String? get phone;
/// Create a copy of PersonRef
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PersonRefCopyWith<PersonRef> get copyWith => _$PersonRefCopyWithImpl<PersonRef>(this as PersonRef, _$identity);

  /// Serializes this PersonRef to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PersonRef;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PersonRef&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.phone, _this.phone) || other.phone == _this.phone));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PersonRef;
  return Object.hash(runtimeType,_this.id,_this.name,_this.phone);
}

@override
String toString() {
  final _this = this as PersonRef;
  return 'PersonRef(id: ${_this.id}, name: ${_this.name}, phone: ${_this.phone})';
}


}

/// @nodoc
abstract mixin class $PersonRefCopyWith<$Res>  {
  factory $PersonRefCopyWith(PersonRef value, $Res Function(PersonRef) _then) = _$PersonRefCopyWithImpl;
@useResult
$Res call({
 String id, String name, String? phone
});




}
/// @nodoc
class _$PersonRefCopyWithImpl<$Res>
    implements $PersonRefCopyWith<$Res> {
  _$PersonRefCopyWithImpl(this._self, this._then);

  final PersonRef _self;
  final $Res Function(PersonRef) _then;

/// Create a copy of PersonRef
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? phone = freezed,}) {
  return _then(PersonRef(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [PersonRef].
extension PersonRefPatterns on PersonRef {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PersonRef value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PersonRef() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PersonRef value)  $default,){
final _that = this;
switch (_that) {
case _PersonRef():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PersonRef value)?  $default,){
final _that = this;
switch (_that) {
case _PersonRef() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String? phone)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PersonRef() when $default != null:
return $default(_that.id,_that.name,_that.phone);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String? phone)  $default,) {final _that = this;
switch (_that) {
case _PersonRef():
return $default(_that.id,_that.name,_that.phone);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String? phone)?  $default,) {final _that = this;
switch (_that) {
case _PersonRef() when $default != null:
return $default(_that.id,_that.name,_that.phone);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PersonRef implements PersonRef {
  const _PersonRef({required this.id, required this.name, this.phone});
  factory _PersonRef.fromJson(Map<String, dynamic> json) => _$PersonRefFromJson(json);

@override final  String id;
@override final  String name;
@override final  String? phone;

/// Create a copy of PersonRef
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PersonRefCopyWith<_PersonRef> get copyWith => __$PersonRefCopyWithImpl<_PersonRef>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PersonRefToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PersonRef&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.phone, phone) || other.phone == phone));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,phone);
}

@override
String toString() {
    return 'PersonRef(id: $id, name: $name, phone: $phone)';
}


}

/// @nodoc
abstract mixin class _$PersonRefCopyWith<$Res> implements $PersonRefCopyWith<$Res> {
  factory _$PersonRefCopyWith(_PersonRef value, $Res Function(_PersonRef) _then) = __$PersonRefCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String? phone
});




}
/// @nodoc
class __$PersonRefCopyWithImpl<$Res>
    implements _$PersonRefCopyWith<$Res> {
  __$PersonRefCopyWithImpl(this._self, this._then);

  final _PersonRef _self;
  final $Res Function(_PersonRef) _then;

/// Create a copy of PersonRef
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? phone = freezed,}) {
  return _then(_PersonRef(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$TitledRef {

 String get id; String get title;
/// Create a copy of TitledRef
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TitledRefCopyWith<TitledRef> get copyWith => _$TitledRefCopyWithImpl<TitledRef>(this as TitledRef, _$identity);

  /// Serializes this TitledRef to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TitledRef;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TitledRef&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.title, _this.title) || other.title == _this.title));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TitledRef;
  return Object.hash(runtimeType,_this.id,_this.title);
}

@override
String toString() {
  final _this = this as TitledRef;
  return 'TitledRef(id: ${_this.id}, title: ${_this.title})';
}


}

/// @nodoc
abstract mixin class $TitledRefCopyWith<$Res>  {
  factory $TitledRefCopyWith(TitledRef value, $Res Function(TitledRef) _then) = _$TitledRefCopyWithImpl;
@useResult
$Res call({
 String id, String title
});




}
/// @nodoc
class _$TitledRefCopyWithImpl<$Res>
    implements $TitledRefCopyWith<$Res> {
  _$TitledRefCopyWithImpl(this._self, this._then);

  final TitledRef _self;
  final $Res Function(TitledRef) _then;

/// Create a copy of TitledRef
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,}) {
  return _then(TitledRef(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [TitledRef].
extension TitledRefPatterns on TitledRef {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TitledRef value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TitledRef() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TitledRef value)  $default,){
final _that = this;
switch (_that) {
case _TitledRef():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TitledRef value)?  $default,){
final _that = this;
switch (_that) {
case _TitledRef() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TitledRef() when $default != null:
return $default(_that.id,_that.title);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title)  $default,) {final _that = this;
switch (_that) {
case _TitledRef():
return $default(_that.id,_that.title);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title)?  $default,) {final _that = this;
switch (_that) {
case _TitledRef() when $default != null:
return $default(_that.id,_that.title);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TitledRef implements TitledRef {
  const _TitledRef({required this.id, required this.title});
  factory _TitledRef.fromJson(Map<String, dynamic> json) => _$TitledRefFromJson(json);

@override final  String id;
@override final  String title;

/// Create a copy of TitledRef
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TitledRefCopyWith<_TitledRef> get copyWith => __$TitledRefCopyWithImpl<_TitledRef>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TitledRefToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TitledRef&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,title);
}

@override
String toString() {
    return 'TitledRef(id: $id, title: $title)';
}


}

/// @nodoc
abstract mixin class _$TitledRefCopyWith<$Res> implements $TitledRefCopyWith<$Res> {
  factory _$TitledRefCopyWith(_TitledRef value, $Res Function(_TitledRef) _then) = __$TitledRefCopyWithImpl;
@override @useResult
$Res call({
 String id, String title
});




}
/// @nodoc
class __$TitledRefCopyWithImpl<$Res>
    implements _$TitledRefCopyWith<$Res> {
  __$TitledRefCopyWithImpl(this._self, this._then);

  final _TitledRef _self;
  final $Res Function(_TitledRef) _then;

/// Create a copy of TitledRef
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,}) {
  return _then(_TitledRef(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
