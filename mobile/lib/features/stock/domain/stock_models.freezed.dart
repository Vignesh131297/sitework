// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stock_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StockMaterial {

 String get id; String get name; String get unit; String? get category;/// Admins are alerted when all godowns together drop below this.
 String? get minStock; bool get isActive;
/// Create a copy of StockMaterial
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StockMaterialCopyWith<StockMaterial> get copyWith => _$StockMaterialCopyWithImpl<StockMaterial>(this as StockMaterial, _$identity);

  /// Serializes this StockMaterial to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as StockMaterial;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StockMaterial&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.unit, _this.unit) || other.unit == _this.unit)&&(identical(other.category, _this.category) || other.category == _this.category)&&(identical(other.minStock, _this.minStock) || other.minStock == _this.minStock)&&(identical(other.isActive, _this.isActive) || other.isActive == _this.isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as StockMaterial;
  return Object.hash(runtimeType,_this.id,_this.name,_this.unit,_this.category,_this.minStock,_this.isActive);
}

@override
String toString() {
  final _this = this as StockMaterial;
  return 'StockMaterial(id: ${_this.id}, name: ${_this.name}, unit: ${_this.unit}, category: ${_this.category}, minStock: ${_this.minStock}, isActive: ${_this.isActive})';
}


}

/// @nodoc
abstract mixin class $StockMaterialCopyWith<$Res>  {
  factory $StockMaterialCopyWith(StockMaterial value, $Res Function(StockMaterial) _then) = _$StockMaterialCopyWithImpl;
@useResult
$Res call({
 String id, String name, String unit, String? category, String? minStock, bool isActive
});




}
/// @nodoc
class _$StockMaterialCopyWithImpl<$Res>
    implements $StockMaterialCopyWith<$Res> {
  _$StockMaterialCopyWithImpl(this._self, this._then);

  final StockMaterial _self;
  final $Res Function(StockMaterial) _then;

/// Create a copy of StockMaterial
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? unit = null,Object? category = freezed,Object? minStock = freezed,Object? isActive = null,}) {
  return _then(StockMaterial(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,minStock: freezed == minStock ? _self.minStock : minStock // ignore: cast_nullable_to_non_nullable
as String?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [StockMaterial].
extension StockMaterialPatterns on StockMaterial {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StockMaterial value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StockMaterial() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StockMaterial value)  $default,){
final _that = this;
switch (_that) {
case _StockMaterial():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StockMaterial value)?  $default,){
final _that = this;
switch (_that) {
case _StockMaterial() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String unit,  String? category,  String? minStock,  bool isActive)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StockMaterial() when $default != null:
return $default(_that.id,_that.name,_that.unit,_that.category,_that.minStock,_that.isActive);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String unit,  String? category,  String? minStock,  bool isActive)  $default,) {final _that = this;
switch (_that) {
case _StockMaterial():
return $default(_that.id,_that.name,_that.unit,_that.category,_that.minStock,_that.isActive);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String unit,  String? category,  String? minStock,  bool isActive)?  $default,) {final _that = this;
switch (_that) {
case _StockMaterial() when $default != null:
return $default(_that.id,_that.name,_that.unit,_that.category,_that.minStock,_that.isActive);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StockMaterial implements StockMaterial {
  const _StockMaterial({required this.id, required this.name, required this.unit, this.category, this.minStock, required this.isActive});
  factory _StockMaterial.fromJson(Map<String, dynamic> json) => _$StockMaterialFromJson(json);

@override final  String id;
@override final  String name;
@override final  String unit;
@override final  String? category;
/// Admins are alerted when all godowns together drop below this.
@override final  String? minStock;
@override final  bool isActive;

/// Create a copy of StockMaterial
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StockMaterialCopyWith<_StockMaterial> get copyWith => __$StockMaterialCopyWithImpl<_StockMaterial>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StockMaterialToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _StockMaterial&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.category, category) || other.category == category)&&(identical(other.minStock, minStock) || other.minStock == minStock)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,unit,category,minStock,isActive);
}

@override
String toString() {
    return 'StockMaterial(id: $id, name: $name, unit: $unit, category: $category, minStock: $minStock, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class _$StockMaterialCopyWith<$Res> implements $StockMaterialCopyWith<$Res> {
  factory _$StockMaterialCopyWith(_StockMaterial value, $Res Function(_StockMaterial) _then) = __$StockMaterialCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String unit, String? category, String? minStock, bool isActive
});




}
/// @nodoc
class __$StockMaterialCopyWithImpl<$Res>
    implements _$StockMaterialCopyWith<$Res> {
  __$StockMaterialCopyWithImpl(this._self, this._then);

  final _StockMaterial _self;
  final $Res Function(_StockMaterial) _then;

/// Create a copy of StockMaterial
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? unit = null,Object? category = freezed,Object? minStock = freezed,Object? isActive = null,}) {
  return _then(_StockMaterial(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,minStock: freezed == minStock ? _self.minStock : minStock // ignore: cast_nullable_to_non_nullable
as String?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$MaterialRef {

 String get id; String get name; String get unit;
/// Create a copy of MaterialRef
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MaterialRefCopyWith<MaterialRef> get copyWith => _$MaterialRefCopyWithImpl<MaterialRef>(this as MaterialRef, _$identity);

  /// Serializes this MaterialRef to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MaterialRef;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MaterialRef&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.unit, _this.unit) || other.unit == _this.unit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MaterialRef;
  return Object.hash(runtimeType,_this.id,_this.name,_this.unit);
}

@override
String toString() {
  final _this = this as MaterialRef;
  return 'MaterialRef(id: ${_this.id}, name: ${_this.name}, unit: ${_this.unit})';
}


}

/// @nodoc
abstract mixin class $MaterialRefCopyWith<$Res>  {
  factory $MaterialRefCopyWith(MaterialRef value, $Res Function(MaterialRef) _then) = _$MaterialRefCopyWithImpl;
@useResult
$Res call({
 String id, String name, String unit
});




}
/// @nodoc
class _$MaterialRefCopyWithImpl<$Res>
    implements $MaterialRefCopyWith<$Res> {
  _$MaterialRefCopyWithImpl(this._self, this._then);

  final MaterialRef _self;
  final $Res Function(MaterialRef) _then;

/// Create a copy of MaterialRef
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? unit = null,}) {
  return _then(MaterialRef(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [MaterialRef].
extension MaterialRefPatterns on MaterialRef {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MaterialRef value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MaterialRef() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MaterialRef value)  $default,){
final _that = this;
switch (_that) {
case _MaterialRef():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MaterialRef value)?  $default,){
final _that = this;
switch (_that) {
case _MaterialRef() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String unit)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MaterialRef() when $default != null:
return $default(_that.id,_that.name,_that.unit);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String unit)  $default,) {final _that = this;
switch (_that) {
case _MaterialRef():
return $default(_that.id,_that.name,_that.unit);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String unit)?  $default,) {final _that = this;
switch (_that) {
case _MaterialRef() when $default != null:
return $default(_that.id,_that.name,_that.unit);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MaterialRef implements MaterialRef {
  const _MaterialRef({required this.id, required this.name, required this.unit});
  factory _MaterialRef.fromJson(Map<String, dynamic> json) => _$MaterialRefFromJson(json);

@override final  String id;
@override final  String name;
@override final  String unit;

/// Create a copy of MaterialRef
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MaterialRefCopyWith<_MaterialRef> get copyWith => __$MaterialRefCopyWithImpl<_MaterialRef>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MaterialRefToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MaterialRef&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.unit, unit) || other.unit == unit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,unit);
}

@override
String toString() {
    return 'MaterialRef(id: $id, name: $name, unit: $unit)';
}


}

/// @nodoc
abstract mixin class _$MaterialRefCopyWith<$Res> implements $MaterialRefCopyWith<$Res> {
  factory _$MaterialRefCopyWith(_MaterialRef value, $Res Function(_MaterialRef) _then) = __$MaterialRefCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String unit
});




}
/// @nodoc
class __$MaterialRefCopyWithImpl<$Res>
    implements _$MaterialRefCopyWith<$Res> {
  __$MaterialRefCopyWithImpl(this._self, this._then);

  final _MaterialRef _self;
  final $Res Function(_MaterialRef) _then;

/// Create a copy of MaterialRef
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? unit = null,}) {
  return _then(_MaterialRef(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$Godown {

 String get id; String get name; String? get address; bool get isActive;
/// Create a copy of Godown
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GodownCopyWith<Godown> get copyWith => _$GodownCopyWithImpl<Godown>(this as Godown, _$identity);

  /// Serializes this Godown to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Godown;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Godown&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.address, _this.address) || other.address == _this.address)&&(identical(other.isActive, _this.isActive) || other.isActive == _this.isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Godown;
  return Object.hash(runtimeType,_this.id,_this.name,_this.address,_this.isActive);
}

@override
String toString() {
  final _this = this as Godown;
  return 'Godown(id: ${_this.id}, name: ${_this.name}, address: ${_this.address}, isActive: ${_this.isActive})';
}


}

/// @nodoc
abstract mixin class $GodownCopyWith<$Res>  {
  factory $GodownCopyWith(Godown value, $Res Function(Godown) _then) = _$GodownCopyWithImpl;
@useResult
$Res call({
 String id, String name, String? address, bool isActive
});




}
/// @nodoc
class _$GodownCopyWithImpl<$Res>
    implements $GodownCopyWith<$Res> {
  _$GodownCopyWithImpl(this._self, this._then);

  final Godown _self;
  final $Res Function(Godown) _then;

/// Create a copy of Godown
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? address = freezed,Object? isActive = null,}) {
  return _then(Godown(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [Godown].
extension GodownPatterns on Godown {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Godown value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Godown() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Godown value)  $default,){
final _that = this;
switch (_that) {
case _Godown():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Godown value)?  $default,){
final _that = this;
switch (_that) {
case _Godown() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String? address,  bool isActive)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Godown() when $default != null:
return $default(_that.id,_that.name,_that.address,_that.isActive);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String? address,  bool isActive)  $default,) {final _that = this;
switch (_that) {
case _Godown():
return $default(_that.id,_that.name,_that.address,_that.isActive);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String? address,  bool isActive)?  $default,) {final _that = this;
switch (_that) {
case _Godown() when $default != null:
return $default(_that.id,_that.name,_that.address,_that.isActive);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Godown implements Godown {
  const _Godown({required this.id, required this.name, this.address, required this.isActive});
  factory _Godown.fromJson(Map<String, dynamic> json) => _$GodownFromJson(json);

@override final  String id;
@override final  String name;
@override final  String? address;
@override final  bool isActive;

/// Create a copy of Godown
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GodownCopyWith<_Godown> get copyWith => __$GodownCopyWithImpl<_Godown>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GodownToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Godown&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.address, address) || other.address == address)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,address,isActive);
}

@override
String toString() {
    return 'Godown(id: $id, name: $name, address: $address, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class _$GodownCopyWith<$Res> implements $GodownCopyWith<$Res> {
  factory _$GodownCopyWith(_Godown value, $Res Function(_Godown) _then) = __$GodownCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String? address, bool isActive
});




}
/// @nodoc
class __$GodownCopyWithImpl<$Res>
    implements _$GodownCopyWith<$Res> {
  __$GodownCopyWithImpl(this._self, this._then);

  final _Godown _self;
  final $Res Function(_Godown) _then;

/// Create a copy of Godown
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? address = freezed,Object? isActive = null,}) {
  return _then(_Godown(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$StockPlaceRef {

 StockPlace get place; SiteRef? get site; IdName? get godown;
/// Create a copy of StockPlaceRef
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StockPlaceRefCopyWith<StockPlaceRef> get copyWith => _$StockPlaceRefCopyWithImpl<StockPlaceRef>(this as StockPlaceRef, _$identity);

  /// Serializes this StockPlaceRef to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as StockPlaceRef;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StockPlaceRef&&(identical(other.place, _this.place) || other.place == _this.place)&&(identical(other.site, _this.site) || other.site == _this.site)&&(identical(other.godown, _this.godown) || other.godown == _this.godown));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as StockPlaceRef;
  return Object.hash(runtimeType,_this.place,_this.site,_this.godown);
}

@override
String toString() {
  final _this = this as StockPlaceRef;
  return 'StockPlaceRef(place: ${_this.place}, site: ${_this.site}, godown: ${_this.godown})';
}


}

/// @nodoc
abstract mixin class $StockPlaceRefCopyWith<$Res>  {
  factory $StockPlaceRefCopyWith(StockPlaceRef value, $Res Function(StockPlaceRef) _then) = _$StockPlaceRefCopyWithImpl;
@useResult
$Res call({
 StockPlace place, SiteRef? site, IdName? godown
});


$SiteRefCopyWith<$Res>? get site;$IdNameCopyWith<$Res>? get godown;

}
/// @nodoc
class _$StockPlaceRefCopyWithImpl<$Res>
    implements $StockPlaceRefCopyWith<$Res> {
  _$StockPlaceRefCopyWithImpl(this._self, this._then);

  final StockPlaceRef _self;
  final $Res Function(StockPlaceRef) _then;

/// Create a copy of StockPlaceRef
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? place = null,Object? site = freezed,Object? godown = freezed,}) {
  return _then(StockPlaceRef(
place: null == place ? _self.place : place // ignore: cast_nullable_to_non_nullable
as StockPlace,site: freezed == site ? _self.site : site // ignore: cast_nullable_to_non_nullable
as SiteRef?,godown: freezed == godown ? _self.godown : godown // ignore: cast_nullable_to_non_nullable
as IdName?,
  ));
}
/// Create a copy of StockPlaceRef
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SiteRefCopyWith<$Res>? get site {
    if (_self.site == null) {
    return null;
  }

  return $SiteRefCopyWith<$Res>(_self.site!, (value) {
    return _then(_self.copyWith(site: value));
  });
}/// Create a copy of StockPlaceRef
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$IdNameCopyWith<$Res>? get godown {
    if (_self.godown == null) {
    return null;
  }

  return $IdNameCopyWith<$Res>(_self.godown!, (value) {
    return _then(_self.copyWith(godown: value));
  });
}
}


/// Adds pattern-matching-related methods to [StockPlaceRef].
extension StockPlaceRefPatterns on StockPlaceRef {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StockPlaceRef value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StockPlaceRef() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StockPlaceRef value)  $default,){
final _that = this;
switch (_that) {
case _StockPlaceRef():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StockPlaceRef value)?  $default,){
final _that = this;
switch (_that) {
case _StockPlaceRef() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( StockPlace place,  SiteRef? site,  IdName? godown)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StockPlaceRef() when $default != null:
return $default(_that.place,_that.site,_that.godown);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( StockPlace place,  SiteRef? site,  IdName? godown)  $default,) {final _that = this;
switch (_that) {
case _StockPlaceRef():
return $default(_that.place,_that.site,_that.godown);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( StockPlace place,  SiteRef? site,  IdName? godown)?  $default,) {final _that = this;
switch (_that) {
case _StockPlaceRef() when $default != null:
return $default(_that.place,_that.site,_that.godown);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StockPlaceRef implements StockPlaceRef {
  const _StockPlaceRef({required this.place, this.site, this.godown});
  factory _StockPlaceRef.fromJson(Map<String, dynamic> json) => _$StockPlaceRefFromJson(json);

@override final  StockPlace place;
@override final  SiteRef? site;
@override final  IdName? godown;

/// Create a copy of StockPlaceRef
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StockPlaceRefCopyWith<_StockPlaceRef> get copyWith => __$StockPlaceRefCopyWithImpl<_StockPlaceRef>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StockPlaceRefToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _StockPlaceRef&&(identical(other.place, place) || other.place == place)&&(identical(other.site, site) || other.site == site)&&(identical(other.godown, godown) || other.godown == godown));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,place,site,godown);
}

@override
String toString() {
    return 'StockPlaceRef(place: $place, site: $site, godown: $godown)';
}


}

/// @nodoc
abstract mixin class _$StockPlaceRefCopyWith<$Res> implements $StockPlaceRefCopyWith<$Res> {
  factory _$StockPlaceRefCopyWith(_StockPlaceRef value, $Res Function(_StockPlaceRef) _then) = __$StockPlaceRefCopyWithImpl;
@override @useResult
$Res call({
 StockPlace place, SiteRef? site, IdName? godown
});


@override $SiteRefCopyWith<$Res>? get site;@override $IdNameCopyWith<$Res>? get godown;

}
/// @nodoc
class __$StockPlaceRefCopyWithImpl<$Res>
    implements _$StockPlaceRefCopyWith<$Res> {
  __$StockPlaceRefCopyWithImpl(this._self, this._then);

  final _StockPlaceRef _self;
  final $Res Function(_StockPlaceRef) _then;

/// Create a copy of StockPlaceRef
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? place = null,Object? site = freezed,Object? godown = freezed,}) {
  return _then(_StockPlaceRef(
place: null == place ? _self.place : place // ignore: cast_nullable_to_non_nullable
as StockPlace,site: freezed == site ? _self.site : site // ignore: cast_nullable_to_non_nullable
as SiteRef?,godown: freezed == godown ? _self.godown : godown // ignore: cast_nullable_to_non_nullable
as IdName?,
  ));
}

/// Create a copy of StockPlaceRef
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SiteRefCopyWith<$Res>? get site {
    if (_self.site == null) {
    return null;
  }

  return $SiteRefCopyWith<$Res>(_self.site!, (value) {
    return _then(_self.copyWith(site: value));
  });
}/// Create a copy of StockPlaceRef
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$IdNameCopyWith<$Res>? get godown {
    if (_self.godown == null) {
    return null;
  }

  return $IdNameCopyWith<$Res>(_self.godown!, (value) {
    return _then(_self.copyWith(godown: value));
  });
}
}


/// @nodoc
mixin _$StockLine {

 String get id; MaterialRef get material; String get quantity; String? get receivedQuantity;/// Sent but never arrived, on a delivery that came up short.
 String? get shortQuantity;/// Purchases, admins only.
 String? get rate; String? get amount;
/// Create a copy of StockLine
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StockLineCopyWith<StockLine> get copyWith => _$StockLineCopyWithImpl<StockLine>(this as StockLine, _$identity);

  /// Serializes this StockLine to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as StockLine;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StockLine&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.material, _this.material) || other.material == _this.material)&&(identical(other.quantity, _this.quantity) || other.quantity == _this.quantity)&&(identical(other.receivedQuantity, _this.receivedQuantity) || other.receivedQuantity == _this.receivedQuantity)&&(identical(other.shortQuantity, _this.shortQuantity) || other.shortQuantity == _this.shortQuantity)&&(identical(other.rate, _this.rate) || other.rate == _this.rate)&&(identical(other.amount, _this.amount) || other.amount == _this.amount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as StockLine;
  return Object.hash(runtimeType,_this.id,_this.material,_this.quantity,_this.receivedQuantity,_this.shortQuantity,_this.rate,_this.amount);
}

@override
String toString() {
  final _this = this as StockLine;
  return 'StockLine(id: ${_this.id}, material: ${_this.material}, quantity: ${_this.quantity}, receivedQuantity: ${_this.receivedQuantity}, shortQuantity: ${_this.shortQuantity}, rate: ${_this.rate}, amount: ${_this.amount})';
}


}

/// @nodoc
abstract mixin class $StockLineCopyWith<$Res>  {
  factory $StockLineCopyWith(StockLine value, $Res Function(StockLine) _then) = _$StockLineCopyWithImpl;
@useResult
$Res call({
 String id, MaterialRef material, String quantity, String? receivedQuantity, String? shortQuantity, String? rate, String? amount
});


$MaterialRefCopyWith<$Res> get material;

}
/// @nodoc
class _$StockLineCopyWithImpl<$Res>
    implements $StockLineCopyWith<$Res> {
  _$StockLineCopyWithImpl(this._self, this._then);

  final StockLine _self;
  final $Res Function(StockLine) _then;

/// Create a copy of StockLine
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? material = null,Object? quantity = null,Object? receivedQuantity = freezed,Object? shortQuantity = freezed,Object? rate = freezed,Object? amount = freezed,}) {
  return _then(StockLine(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,material: null == material ? _self.material : material // ignore: cast_nullable_to_non_nullable
as MaterialRef,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as String,receivedQuantity: freezed == receivedQuantity ? _self.receivedQuantity : receivedQuantity // ignore: cast_nullable_to_non_nullable
as String?,shortQuantity: freezed == shortQuantity ? _self.shortQuantity : shortQuantity // ignore: cast_nullable_to_non_nullable
as String?,rate: freezed == rate ? _self.rate : rate // ignore: cast_nullable_to_non_nullable
as String?,amount: freezed == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of StockLine
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MaterialRefCopyWith<$Res> get material {
  
  return $MaterialRefCopyWith<$Res>(_self.material, (value) {
    return _then(_self.copyWith(material: value));
  });
}
}


/// Adds pattern-matching-related methods to [StockLine].
extension StockLinePatterns on StockLine {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StockLine value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StockLine() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StockLine value)  $default,){
final _that = this;
switch (_that) {
case _StockLine():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StockLine value)?  $default,){
final _that = this;
switch (_that) {
case _StockLine() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  MaterialRef material,  String quantity,  String? receivedQuantity,  String? shortQuantity,  String? rate,  String? amount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StockLine() when $default != null:
return $default(_that.id,_that.material,_that.quantity,_that.receivedQuantity,_that.shortQuantity,_that.rate,_that.amount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  MaterialRef material,  String quantity,  String? receivedQuantity,  String? shortQuantity,  String? rate,  String? amount)  $default,) {final _that = this;
switch (_that) {
case _StockLine():
return $default(_that.id,_that.material,_that.quantity,_that.receivedQuantity,_that.shortQuantity,_that.rate,_that.amount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  MaterialRef material,  String quantity,  String? receivedQuantity,  String? shortQuantity,  String? rate,  String? amount)?  $default,) {final _that = this;
switch (_that) {
case _StockLine() when $default != null:
return $default(_that.id,_that.material,_that.quantity,_that.receivedQuantity,_that.shortQuantity,_that.rate,_that.amount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StockLine implements StockLine {
  const _StockLine({required this.id, required this.material, required this.quantity, this.receivedQuantity, this.shortQuantity, this.rate, this.amount});
  factory _StockLine.fromJson(Map<String, dynamic> json) => _$StockLineFromJson(json);

@override final  String id;
@override final  MaterialRef material;
@override final  String quantity;
@override final  String? receivedQuantity;
/// Sent but never arrived, on a delivery that came up short.
@override final  String? shortQuantity;
/// Purchases, admins only.
@override final  String? rate;
@override final  String? amount;

/// Create a copy of StockLine
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StockLineCopyWith<_StockLine> get copyWith => __$StockLineCopyWithImpl<_StockLine>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StockLineToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _StockLine&&(identical(other.id, id) || other.id == id)&&(identical(other.material, material) || other.material == material)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.receivedQuantity, receivedQuantity) || other.receivedQuantity == receivedQuantity)&&(identical(other.shortQuantity, shortQuantity) || other.shortQuantity == shortQuantity)&&(identical(other.rate, rate) || other.rate == rate)&&(identical(other.amount, amount) || other.amount == amount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,material,quantity,receivedQuantity,shortQuantity,rate,amount);
}

@override
String toString() {
    return 'StockLine(id: $id, material: $material, quantity: $quantity, receivedQuantity: $receivedQuantity, shortQuantity: $shortQuantity, rate: $rate, amount: $amount)';
}


}

/// @nodoc
abstract mixin class _$StockLineCopyWith<$Res> implements $StockLineCopyWith<$Res> {
  factory _$StockLineCopyWith(_StockLine value, $Res Function(_StockLine) _then) = __$StockLineCopyWithImpl;
@override @useResult
$Res call({
 String id, MaterialRef material, String quantity, String? receivedQuantity, String? shortQuantity, String? rate, String? amount
});


@override $MaterialRefCopyWith<$Res> get material;

}
/// @nodoc
class __$StockLineCopyWithImpl<$Res>
    implements _$StockLineCopyWith<$Res> {
  __$StockLineCopyWithImpl(this._self, this._then);

  final _StockLine _self;
  final $Res Function(_StockLine) _then;

/// Create a copy of StockLine
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? material = null,Object? quantity = null,Object? receivedQuantity = freezed,Object? shortQuantity = freezed,Object? rate = freezed,Object? amount = freezed,}) {
  return _then(_StockLine(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,material: null == material ? _self.material : material // ignore: cast_nullable_to_non_nullable
as MaterialRef,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as String,receivedQuantity: freezed == receivedQuantity ? _self.receivedQuantity : receivedQuantity // ignore: cast_nullable_to_non_nullable
as String?,shortQuantity: freezed == shortQuantity ? _self.shortQuantity : shortQuantity // ignore: cast_nullable_to_non_nullable
as String?,rate: freezed == rate ? _self.rate : rate // ignore: cast_nullable_to_non_nullable
as String?,amount: freezed == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of StockLine
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MaterialRefCopyWith<$Res> get material {
  
  return $MaterialRefCopyWith<$Res>(_self.material, (value) {
    return _then(_self.copyWith(material: value));
  });
}
}


/// @nodoc
mixin _$StockPhoto {

 String get id; String get mime; String get url; DateTime get expiresAt; StockPhotoStage get stage;
/// Create a copy of StockPhoto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StockPhotoCopyWith<StockPhoto> get copyWith => _$StockPhotoCopyWithImpl<StockPhoto>(this as StockPhoto, _$identity);

  /// Serializes this StockPhoto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as StockPhoto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StockPhoto&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.mime, _this.mime) || other.mime == _this.mime)&&(identical(other.url, _this.url) || other.url == _this.url)&&(identical(other.expiresAt, _this.expiresAt) || other.expiresAt == _this.expiresAt)&&(identical(other.stage, _this.stage) || other.stage == _this.stage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as StockPhoto;
  return Object.hash(runtimeType,_this.id,_this.mime,_this.url,_this.expiresAt,_this.stage);
}

@override
String toString() {
  final _this = this as StockPhoto;
  return 'StockPhoto(id: ${_this.id}, mime: ${_this.mime}, url: ${_this.url}, expiresAt: ${_this.expiresAt}, stage: ${_this.stage})';
}


}

/// @nodoc
abstract mixin class $StockPhotoCopyWith<$Res>  {
  factory $StockPhotoCopyWith(StockPhoto value, $Res Function(StockPhoto) _then) = _$StockPhotoCopyWithImpl;
@useResult
$Res call({
 String id, String mime, String url, DateTime expiresAt, StockPhotoStage stage
});




}
/// @nodoc
class _$StockPhotoCopyWithImpl<$Res>
    implements $StockPhotoCopyWith<$Res> {
  _$StockPhotoCopyWithImpl(this._self, this._then);

  final StockPhoto _self;
  final $Res Function(StockPhoto) _then;

/// Create a copy of StockPhoto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? mime = null,Object? url = null,Object? expiresAt = null,Object? stage = null,}) {
  return _then(StockPhoto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,mime: null == mime ? _self.mime : mime // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,stage: null == stage ? _self.stage : stage // ignore: cast_nullable_to_non_nullable
as StockPhotoStage,
  ));
}

}


/// Adds pattern-matching-related methods to [StockPhoto].
extension StockPhotoPatterns on StockPhoto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StockPhoto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StockPhoto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StockPhoto value)  $default,){
final _that = this;
switch (_that) {
case _StockPhoto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StockPhoto value)?  $default,){
final _that = this;
switch (_that) {
case _StockPhoto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String mime,  String url,  DateTime expiresAt,  StockPhotoStage stage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StockPhoto() when $default != null:
return $default(_that.id,_that.mime,_that.url,_that.expiresAt,_that.stage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String mime,  String url,  DateTime expiresAt,  StockPhotoStage stage)  $default,) {final _that = this;
switch (_that) {
case _StockPhoto():
return $default(_that.id,_that.mime,_that.url,_that.expiresAt,_that.stage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String mime,  String url,  DateTime expiresAt,  StockPhotoStage stage)?  $default,) {final _that = this;
switch (_that) {
case _StockPhoto() when $default != null:
return $default(_that.id,_that.mime,_that.url,_that.expiresAt,_that.stage);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StockPhoto implements StockPhoto {
  const _StockPhoto({required this.id, required this.mime, required this.url, required this.expiresAt, required this.stage});
  factory _StockPhoto.fromJson(Map<String, dynamic> json) => _$StockPhotoFromJson(json);

@override final  String id;
@override final  String mime;
@override final  String url;
@override final  DateTime expiresAt;
@override final  StockPhotoStage stage;

/// Create a copy of StockPhoto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StockPhotoCopyWith<_StockPhoto> get copyWith => __$StockPhotoCopyWithImpl<_StockPhoto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StockPhotoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _StockPhoto&&(identical(other.id, id) || other.id == id)&&(identical(other.mime, mime) || other.mime == mime)&&(identical(other.url, url) || other.url == url)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&(identical(other.stage, stage) || other.stage == stage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,mime,url,expiresAt,stage);
}

@override
String toString() {
    return 'StockPhoto(id: $id, mime: $mime, url: $url, expiresAt: $expiresAt, stage: $stage)';
}


}

/// @nodoc
abstract mixin class _$StockPhotoCopyWith<$Res> implements $StockPhotoCopyWith<$Res> {
  factory _$StockPhotoCopyWith(_StockPhoto value, $Res Function(_StockPhoto) _then) = __$StockPhotoCopyWithImpl;
@override @useResult
$Res call({
 String id, String mime, String url, DateTime expiresAt, StockPhotoStage stage
});




}
/// @nodoc
class __$StockPhotoCopyWithImpl<$Res>
    implements _$StockPhotoCopyWith<$Res> {
  __$StockPhotoCopyWithImpl(this._self, this._then);

  final _StockPhoto _self;
  final $Res Function(_StockPhoto) _then;

/// Create a copy of StockPhoto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? mime = null,Object? url = null,Object? expiresAt = null,Object? stage = null,}) {
  return _then(_StockPhoto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,mime: null == mime ? _self.mime : mime // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,stage: null == stage ? _self.stage : stage // ignore: cast_nullable_to_non_nullable
as StockPhotoStage,
  ));
}


}


/// @nodoc
mixin _$RequestRef {

 String get id; String get code;
/// Create a copy of RequestRef
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RequestRefCopyWith<RequestRef> get copyWith => _$RequestRefCopyWithImpl<RequestRef>(this as RequestRef, _$identity);

  /// Serializes this RequestRef to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as RequestRef;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RequestRef&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.code, _this.code) || other.code == _this.code));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as RequestRef;
  return Object.hash(runtimeType,_this.id,_this.code);
}

@override
String toString() {
  final _this = this as RequestRef;
  return 'RequestRef(id: ${_this.id}, code: ${_this.code})';
}


}

/// @nodoc
abstract mixin class $RequestRefCopyWith<$Res>  {
  factory $RequestRefCopyWith(RequestRef value, $Res Function(RequestRef) _then) = _$RequestRefCopyWithImpl;
@useResult
$Res call({
 String id, String code
});




}
/// @nodoc
class _$RequestRefCopyWithImpl<$Res>
    implements $RequestRefCopyWith<$Res> {
  _$RequestRefCopyWithImpl(this._self, this._then);

  final RequestRef _self;
  final $Res Function(RequestRef) _then;

/// Create a copy of RequestRef
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? code = null,}) {
  return _then(RequestRef(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [RequestRef].
extension RequestRefPatterns on RequestRef {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RequestRef value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RequestRef() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RequestRef value)  $default,){
final _that = this;
switch (_that) {
case _RequestRef():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RequestRef value)?  $default,){
final _that = this;
switch (_that) {
case _RequestRef() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String code)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RequestRef() when $default != null:
return $default(_that.id,_that.code);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String code)  $default,) {final _that = this;
switch (_that) {
case _RequestRef():
return $default(_that.id,_that.code);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String code)?  $default,) {final _that = this;
switch (_that) {
case _RequestRef() when $default != null:
return $default(_that.id,_that.code);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RequestRef implements RequestRef {
  const _RequestRef({required this.id, required this.code});
  factory _RequestRef.fromJson(Map<String, dynamic> json) => _$RequestRefFromJson(json);

@override final  String id;
@override final  String code;

/// Create a copy of RequestRef
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RequestRefCopyWith<_RequestRef> get copyWith => __$RequestRefCopyWithImpl<_RequestRef>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RequestRefToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RequestRef&&(identical(other.id, id) || other.id == id)&&(identical(other.code, code) || other.code == code));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,code);
}

@override
String toString() {
    return 'RequestRef(id: $id, code: $code)';
}


}

/// @nodoc
abstract mixin class _$RequestRefCopyWith<$Res> implements $RequestRefCopyWith<$Res> {
  factory _$RequestRefCopyWith(_RequestRef value, $Res Function(_RequestRef) _then) = __$RequestRefCopyWithImpl;
@override @useResult
$Res call({
 String id, String code
});




}
/// @nodoc
class __$RequestRefCopyWithImpl<$Res>
    implements _$RequestRefCopyWith<$Res> {
  __$RequestRefCopyWithImpl(this._self, this._then);

  final _RequestRef _self;
  final $Res Function(_RequestRef) _then;

/// Create a copy of RequestRef
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? code = null,}) {
  return _then(_RequestRef(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$StockEntry {

 String get id; String get requestId; StockKind get kind; StockPlaceRef get from; StockPlaceRef get to; StockMovementStatus get status; String get movedOn; String? get dcNumber; String? get supplier; String? get billNo; String? get note; List<StockLine> get lines;/// Purchases, admins only.
 String? get totalAmount; String? get receivedOn; DateTime? get receivedAt; IdName? get receivedBy; String? get receiveNote; IdName get createdBy; DateTime get createdAt; DateTime? get voidedAt; IdName? get voidedBy; String? get voidReason; int get photoCount;/// The material request it was sent against (or returned on).
 RequestRef? get request;/// Detail responses only.
 List<StockPhoto> get photos;/// What the signed-in user may do with it now (the server decides).
 bool get canReceive; bool get canVoid;
/// Create a copy of StockEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StockEntryCopyWith<StockEntry> get copyWith => _$StockEntryCopyWithImpl<StockEntry>(this as StockEntry, _$identity);

  /// Serializes this StockEntry to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as StockEntry;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StockEntry&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.requestId, _this.requestId) || other.requestId == _this.requestId)&&(identical(other.kind, _this.kind) || other.kind == _this.kind)&&(identical(other.from, _this.from) || other.from == _this.from)&&(identical(other.to, _this.to) || other.to == _this.to)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.movedOn, _this.movedOn) || other.movedOn == _this.movedOn)&&(identical(other.dcNumber, _this.dcNumber) || other.dcNumber == _this.dcNumber)&&(identical(other.supplier, _this.supplier) || other.supplier == _this.supplier)&&(identical(other.billNo, _this.billNo) || other.billNo == _this.billNo)&&(identical(other.note, _this.note) || other.note == _this.note)&&const DeepCollectionEquality().equals(other.lines, _this.lines)&&(identical(other.totalAmount, _this.totalAmount) || other.totalAmount == _this.totalAmount)&&(identical(other.receivedOn, _this.receivedOn) || other.receivedOn == _this.receivedOn)&&(identical(other.receivedAt, _this.receivedAt) || other.receivedAt == _this.receivedAt)&&(identical(other.receivedBy, _this.receivedBy) || other.receivedBy == _this.receivedBy)&&(identical(other.receiveNote, _this.receiveNote) || other.receiveNote == _this.receiveNote)&&(identical(other.createdBy, _this.createdBy) || other.createdBy == _this.createdBy)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.voidedAt, _this.voidedAt) || other.voidedAt == _this.voidedAt)&&(identical(other.voidedBy, _this.voidedBy) || other.voidedBy == _this.voidedBy)&&(identical(other.voidReason, _this.voidReason) || other.voidReason == _this.voidReason)&&(identical(other.photoCount, _this.photoCount) || other.photoCount == _this.photoCount)&&(identical(other.request, _this.request) || other.request == _this.request)&&const DeepCollectionEquality().equals(other.photos, _this.photos)&&(identical(other.canReceive, _this.canReceive) || other.canReceive == _this.canReceive)&&(identical(other.canVoid, _this.canVoid) || other.canVoid == _this.canVoid));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as StockEntry;
  return Object.hashAll([runtimeType,_this.id,_this.requestId,_this.kind,_this.from,_this.to,_this.status,_this.movedOn,_this.dcNumber,_this.supplier,_this.billNo,_this.note,const DeepCollectionEquality().hash(_this.lines),_this.totalAmount,_this.receivedOn,_this.receivedAt,_this.receivedBy,_this.receiveNote,_this.createdBy,_this.createdAt,_this.voidedAt,_this.voidedBy,_this.voidReason,_this.photoCount,_this.request,const DeepCollectionEquality().hash(_this.photos),_this.canReceive,_this.canVoid]);
}

@override
String toString() {
  final _this = this as StockEntry;
  return 'StockEntry(id: ${_this.id}, requestId: ${_this.requestId}, kind: ${_this.kind}, from: ${_this.from}, to: ${_this.to}, status: ${_this.status}, movedOn: ${_this.movedOn}, dcNumber: ${_this.dcNumber}, supplier: ${_this.supplier}, billNo: ${_this.billNo}, note: ${_this.note}, lines: ${_this.lines}, totalAmount: ${_this.totalAmount}, receivedOn: ${_this.receivedOn}, receivedAt: ${_this.receivedAt}, receivedBy: ${_this.receivedBy}, receiveNote: ${_this.receiveNote}, createdBy: ${_this.createdBy}, createdAt: ${_this.createdAt}, voidedAt: ${_this.voidedAt}, voidedBy: ${_this.voidedBy}, voidReason: ${_this.voidReason}, photoCount: ${_this.photoCount}, request: ${_this.request}, photos: ${_this.photos}, canReceive: ${_this.canReceive}, canVoid: ${_this.canVoid})';
}


}

/// @nodoc
abstract mixin class $StockEntryCopyWith<$Res>  {
  factory $StockEntryCopyWith(StockEntry value, $Res Function(StockEntry) _then) = _$StockEntryCopyWithImpl;
@useResult
$Res call({
 String id, String requestId, StockKind kind, StockPlaceRef from, StockPlaceRef to, StockMovementStatus status, String movedOn, String? dcNumber, String? supplier, String? billNo, String? note, List<StockLine> lines, String? totalAmount, String? receivedOn, DateTime? receivedAt, IdName? receivedBy, String? receiveNote, IdName createdBy, DateTime createdAt, DateTime? voidedAt, IdName? voidedBy, String? voidReason, int photoCount, RequestRef? request, List<StockPhoto> photos, bool canReceive, bool canVoid
});


$StockPlaceRefCopyWith<$Res> get from;$StockPlaceRefCopyWith<$Res> get to;$IdNameCopyWith<$Res>? get receivedBy;$IdNameCopyWith<$Res> get createdBy;$IdNameCopyWith<$Res>? get voidedBy;$RequestRefCopyWith<$Res>? get request;

}
/// @nodoc
class _$StockEntryCopyWithImpl<$Res>
    implements $StockEntryCopyWith<$Res> {
  _$StockEntryCopyWithImpl(this._self, this._then);

  final StockEntry _self;
  final $Res Function(StockEntry) _then;

/// Create a copy of StockEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? requestId = null,Object? kind = null,Object? from = null,Object? to = null,Object? status = null,Object? movedOn = null,Object? dcNumber = freezed,Object? supplier = freezed,Object? billNo = freezed,Object? note = freezed,Object? lines = null,Object? totalAmount = freezed,Object? receivedOn = freezed,Object? receivedAt = freezed,Object? receivedBy = freezed,Object? receiveNote = freezed,Object? createdBy = null,Object? createdAt = null,Object? voidedAt = freezed,Object? voidedBy = freezed,Object? voidReason = freezed,Object? photoCount = null,Object? request = freezed,Object? photos = null,Object? canReceive = null,Object? canVoid = null,}) {
  return _then(StockEntry(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,requestId: null == requestId ? _self.requestId : requestId // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as StockKind,from: null == from ? _self.from : from // ignore: cast_nullable_to_non_nullable
as StockPlaceRef,to: null == to ? _self.to : to // ignore: cast_nullable_to_non_nullable
as StockPlaceRef,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as StockMovementStatus,movedOn: null == movedOn ? _self.movedOn : movedOn // ignore: cast_nullable_to_non_nullable
as String,dcNumber: freezed == dcNumber ? _self.dcNumber : dcNumber // ignore: cast_nullable_to_non_nullable
as String?,supplier: freezed == supplier ? _self.supplier : supplier // ignore: cast_nullable_to_non_nullable
as String?,billNo: freezed == billNo ? _self.billNo : billNo // ignore: cast_nullable_to_non_nullable
as String?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,lines: null == lines ? _self.lines : lines // ignore: cast_nullable_to_non_nullable
as List<StockLine>,totalAmount: freezed == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as String?,receivedOn: freezed == receivedOn ? _self.receivedOn : receivedOn // ignore: cast_nullable_to_non_nullable
as String?,receivedAt: freezed == receivedAt ? _self.receivedAt : receivedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,receivedBy: freezed == receivedBy ? _self.receivedBy : receivedBy // ignore: cast_nullable_to_non_nullable
as IdName?,receiveNote: freezed == receiveNote ? _self.receiveNote : receiveNote // ignore: cast_nullable_to_non_nullable
as String?,createdBy: null == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as IdName,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,voidedAt: freezed == voidedAt ? _self.voidedAt : voidedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,voidedBy: freezed == voidedBy ? _self.voidedBy : voidedBy // ignore: cast_nullable_to_non_nullable
as IdName?,voidReason: freezed == voidReason ? _self.voidReason : voidReason // ignore: cast_nullable_to_non_nullable
as String?,photoCount: null == photoCount ? _self.photoCount : photoCount // ignore: cast_nullable_to_non_nullable
as int,request: freezed == request ? _self.request : request // ignore: cast_nullable_to_non_nullable
as RequestRef?,photos: null == photos ? _self.photos : photos // ignore: cast_nullable_to_non_nullable
as List<StockPhoto>,canReceive: null == canReceive ? _self.canReceive : canReceive // ignore: cast_nullable_to_non_nullable
as bool,canVoid: null == canVoid ? _self.canVoid : canVoid // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of StockEntry
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StockPlaceRefCopyWith<$Res> get from {
  
  return $StockPlaceRefCopyWith<$Res>(_self.from, (value) {
    return _then(_self.copyWith(from: value));
  });
}/// Create a copy of StockEntry
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StockPlaceRefCopyWith<$Res> get to {
  
  return $StockPlaceRefCopyWith<$Res>(_self.to, (value) {
    return _then(_self.copyWith(to: value));
  });
}/// Create a copy of StockEntry
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$IdNameCopyWith<$Res>? get receivedBy {
    if (_self.receivedBy == null) {
    return null;
  }

  return $IdNameCopyWith<$Res>(_self.receivedBy!, (value) {
    return _then(_self.copyWith(receivedBy: value));
  });
}/// Create a copy of StockEntry
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$IdNameCopyWith<$Res> get createdBy {
  
  return $IdNameCopyWith<$Res>(_self.createdBy, (value) {
    return _then(_self.copyWith(createdBy: value));
  });
}/// Create a copy of StockEntry
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
}/// Create a copy of StockEntry
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RequestRefCopyWith<$Res>? get request {
    if (_self.request == null) {
    return null;
  }

  return $RequestRefCopyWith<$Res>(_self.request!, (value) {
    return _then(_self.copyWith(request: value));
  });
}
}


/// Adds pattern-matching-related methods to [StockEntry].
extension StockEntryPatterns on StockEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StockEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StockEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StockEntry value)  $default,){
final _that = this;
switch (_that) {
case _StockEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StockEntry value)?  $default,){
final _that = this;
switch (_that) {
case _StockEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String requestId,  StockKind kind,  StockPlaceRef from,  StockPlaceRef to,  StockMovementStatus status,  String movedOn,  String? dcNumber,  String? supplier,  String? billNo,  String? note,  List<StockLine> lines,  String? totalAmount,  String? receivedOn,  DateTime? receivedAt,  IdName? receivedBy,  String? receiveNote,  IdName createdBy,  DateTime createdAt,  DateTime? voidedAt,  IdName? voidedBy,  String? voidReason,  int photoCount,  RequestRef? request,  List<StockPhoto> photos,  bool canReceive,  bool canVoid)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StockEntry() when $default != null:
return $default(_that.id,_that.requestId,_that.kind,_that.from,_that.to,_that.status,_that.movedOn,_that.dcNumber,_that.supplier,_that.billNo,_that.note,_that.lines,_that.totalAmount,_that.receivedOn,_that.receivedAt,_that.receivedBy,_that.receiveNote,_that.createdBy,_that.createdAt,_that.voidedAt,_that.voidedBy,_that.voidReason,_that.photoCount,_that.request,_that.photos,_that.canReceive,_that.canVoid);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String requestId,  StockKind kind,  StockPlaceRef from,  StockPlaceRef to,  StockMovementStatus status,  String movedOn,  String? dcNumber,  String? supplier,  String? billNo,  String? note,  List<StockLine> lines,  String? totalAmount,  String? receivedOn,  DateTime? receivedAt,  IdName? receivedBy,  String? receiveNote,  IdName createdBy,  DateTime createdAt,  DateTime? voidedAt,  IdName? voidedBy,  String? voidReason,  int photoCount,  RequestRef? request,  List<StockPhoto> photos,  bool canReceive,  bool canVoid)  $default,) {final _that = this;
switch (_that) {
case _StockEntry():
return $default(_that.id,_that.requestId,_that.kind,_that.from,_that.to,_that.status,_that.movedOn,_that.dcNumber,_that.supplier,_that.billNo,_that.note,_that.lines,_that.totalAmount,_that.receivedOn,_that.receivedAt,_that.receivedBy,_that.receiveNote,_that.createdBy,_that.createdAt,_that.voidedAt,_that.voidedBy,_that.voidReason,_that.photoCount,_that.request,_that.photos,_that.canReceive,_that.canVoid);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String requestId,  StockKind kind,  StockPlaceRef from,  StockPlaceRef to,  StockMovementStatus status,  String movedOn,  String? dcNumber,  String? supplier,  String? billNo,  String? note,  List<StockLine> lines,  String? totalAmount,  String? receivedOn,  DateTime? receivedAt,  IdName? receivedBy,  String? receiveNote,  IdName createdBy,  DateTime createdAt,  DateTime? voidedAt,  IdName? voidedBy,  String? voidReason,  int photoCount,  RequestRef? request,  List<StockPhoto> photos,  bool canReceive,  bool canVoid)?  $default,) {final _that = this;
switch (_that) {
case _StockEntry() when $default != null:
return $default(_that.id,_that.requestId,_that.kind,_that.from,_that.to,_that.status,_that.movedOn,_that.dcNumber,_that.supplier,_that.billNo,_that.note,_that.lines,_that.totalAmount,_that.receivedOn,_that.receivedAt,_that.receivedBy,_that.receiveNote,_that.createdBy,_that.createdAt,_that.voidedAt,_that.voidedBy,_that.voidReason,_that.photoCount,_that.request,_that.photos,_that.canReceive,_that.canVoid);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StockEntry extends StockEntry {
  const _StockEntry({required this.id, required this.requestId, required this.kind, required this.from, required this.to, required this.status, required this.movedOn, this.dcNumber, this.supplier, this.billNo, this.note, required  List<StockLine> lines, this.totalAmount, this.receivedOn, this.receivedAt, this.receivedBy, this.receiveNote, required this.createdBy, required this.createdAt, this.voidedAt, this.voidedBy, this.voidReason, this.photoCount = 0, this.request,  List<StockPhoto> photos = const <StockPhoto>[], this.canReceive = false, this.canVoid = false}): _lines = lines,_photos = photos,super._();
  factory _StockEntry.fromJson(Map<String, dynamic> json) => _$StockEntryFromJson(json);

@override final  String id;
@override final  String requestId;
@override final  StockKind kind;
@override final  StockPlaceRef from;
@override final  StockPlaceRef to;
@override final  StockMovementStatus status;
@override final  String movedOn;
@override final  String? dcNumber;
@override final  String? supplier;
@override final  String? billNo;
@override final  String? note;
 final  List<StockLine> _lines;
@override List<StockLine> get lines {
  if (_lines is EqualUnmodifiableListView) return _lines;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_lines);
}

/// Purchases, admins only.
@override final  String? totalAmount;
@override final  String? receivedOn;
@override final  DateTime? receivedAt;
@override final  IdName? receivedBy;
@override final  String? receiveNote;
@override final  IdName createdBy;
@override final  DateTime createdAt;
@override final  DateTime? voidedAt;
@override final  IdName? voidedBy;
@override final  String? voidReason;
@override@JsonKey() final  int photoCount;
/// The material request it was sent against (or returned on).
@override final  RequestRef? request;
/// Detail responses only.
 final  List<StockPhoto> _photos;
/// Detail responses only.
@override@JsonKey() List<StockPhoto> get photos {
  if (_photos is EqualUnmodifiableListView) return _photos;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_photos);
}

/// What the signed-in user may do with it now (the server decides).
@override@JsonKey() final  bool canReceive;
@override@JsonKey() final  bool canVoid;

/// Create a copy of StockEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StockEntryCopyWith<_StockEntry> get copyWith => __$StockEntryCopyWithImpl<_StockEntry>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StockEntryToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _StockEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.requestId, requestId) || other.requestId == requestId)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.from, from) || other.from == from)&&(identical(other.to, to) || other.to == to)&&(identical(other.status, status) || other.status == status)&&(identical(other.movedOn, movedOn) || other.movedOn == movedOn)&&(identical(other.dcNumber, dcNumber) || other.dcNumber == dcNumber)&&(identical(other.supplier, supplier) || other.supplier == supplier)&&(identical(other.billNo, billNo) || other.billNo == billNo)&&(identical(other.note, note) || other.note == note)&&const DeepCollectionEquality().equals(other.lines, _lines)&&(identical(other.totalAmount, totalAmount) || other.totalAmount == totalAmount)&&(identical(other.receivedOn, receivedOn) || other.receivedOn == receivedOn)&&(identical(other.receivedAt, receivedAt) || other.receivedAt == receivedAt)&&(identical(other.receivedBy, receivedBy) || other.receivedBy == receivedBy)&&(identical(other.receiveNote, receiveNote) || other.receiveNote == receiveNote)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.voidedAt, voidedAt) || other.voidedAt == voidedAt)&&(identical(other.voidedBy, voidedBy) || other.voidedBy == voidedBy)&&(identical(other.voidReason, voidReason) || other.voidReason == voidReason)&&(identical(other.photoCount, photoCount) || other.photoCount == photoCount)&&(identical(other.request, request) || other.request == request)&&const DeepCollectionEquality().equals(other.photos, _photos)&&(identical(other.canReceive, canReceive) || other.canReceive == canReceive)&&(identical(other.canVoid, canVoid) || other.canVoid == canVoid));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hashAll([runtimeType,id,requestId,kind,from,to,status,movedOn,dcNumber,supplier,billNo,note,const DeepCollectionEquality().hash(_lines),totalAmount,receivedOn,receivedAt,receivedBy,receiveNote,createdBy,createdAt,voidedAt,voidedBy,voidReason,photoCount,request,const DeepCollectionEquality().hash(_photos),canReceive,canVoid]);
}

@override
String toString() {
    return 'StockEntry(id: $id, requestId: $requestId, kind: $kind, from: $from, to: $to, status: $status, movedOn: $movedOn, dcNumber: $dcNumber, supplier: $supplier, billNo: $billNo, note: $note, lines: $lines, totalAmount: $totalAmount, receivedOn: $receivedOn, receivedAt: $receivedAt, receivedBy: $receivedBy, receiveNote: $receiveNote, createdBy: $createdBy, createdAt: $createdAt, voidedAt: $voidedAt, voidedBy: $voidedBy, voidReason: $voidReason, photoCount: $photoCount, request: $request, photos: $photos, canReceive: $canReceive, canVoid: $canVoid)';
}


}

/// @nodoc
abstract mixin class _$StockEntryCopyWith<$Res> implements $StockEntryCopyWith<$Res> {
  factory _$StockEntryCopyWith(_StockEntry value, $Res Function(_StockEntry) _then) = __$StockEntryCopyWithImpl;
@override @useResult
$Res call({
 String id, String requestId, StockKind kind, StockPlaceRef from, StockPlaceRef to, StockMovementStatus status, String movedOn, String? dcNumber, String? supplier, String? billNo, String? note, List<StockLine> lines, String? totalAmount, String? receivedOn, DateTime? receivedAt, IdName? receivedBy, String? receiveNote, IdName createdBy, DateTime createdAt, DateTime? voidedAt, IdName? voidedBy, String? voidReason, int photoCount, RequestRef? request, List<StockPhoto> photos, bool canReceive, bool canVoid
});


@override $StockPlaceRefCopyWith<$Res> get from;@override $StockPlaceRefCopyWith<$Res> get to;@override $IdNameCopyWith<$Res>? get receivedBy;@override $IdNameCopyWith<$Res> get createdBy;@override $IdNameCopyWith<$Res>? get voidedBy;@override $RequestRefCopyWith<$Res>? get request;

}
/// @nodoc
class __$StockEntryCopyWithImpl<$Res>
    implements _$StockEntryCopyWith<$Res> {
  __$StockEntryCopyWithImpl(this._self, this._then);

  final _StockEntry _self;
  final $Res Function(_StockEntry) _then;

/// Create a copy of StockEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? requestId = null,Object? kind = null,Object? from = null,Object? to = null,Object? status = null,Object? movedOn = null,Object? dcNumber = freezed,Object? supplier = freezed,Object? billNo = freezed,Object? note = freezed,Object? lines = null,Object? totalAmount = freezed,Object? receivedOn = freezed,Object? receivedAt = freezed,Object? receivedBy = freezed,Object? receiveNote = freezed,Object? createdBy = null,Object? createdAt = null,Object? voidedAt = freezed,Object? voidedBy = freezed,Object? voidReason = freezed,Object? photoCount = null,Object? request = freezed,Object? photos = null,Object? canReceive = null,Object? canVoid = null,}) {
  return _then(_StockEntry(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,requestId: null == requestId ? _self.requestId : requestId // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as StockKind,from: null == from ? _self.from : from // ignore: cast_nullable_to_non_nullable
as StockPlaceRef,to: null == to ? _self.to : to // ignore: cast_nullable_to_non_nullable
as StockPlaceRef,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as StockMovementStatus,movedOn: null == movedOn ? _self.movedOn : movedOn // ignore: cast_nullable_to_non_nullable
as String,dcNumber: freezed == dcNumber ? _self.dcNumber : dcNumber // ignore: cast_nullable_to_non_nullable
as String?,supplier: freezed == supplier ? _self.supplier : supplier // ignore: cast_nullable_to_non_nullable
as String?,billNo: freezed == billNo ? _self.billNo : billNo // ignore: cast_nullable_to_non_nullable
as String?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,lines: null == lines ? _self._lines : lines // ignore: cast_nullable_to_non_nullable
as List<StockLine>,totalAmount: freezed == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as String?,receivedOn: freezed == receivedOn ? _self.receivedOn : receivedOn // ignore: cast_nullable_to_non_nullable
as String?,receivedAt: freezed == receivedAt ? _self.receivedAt : receivedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,receivedBy: freezed == receivedBy ? _self.receivedBy : receivedBy // ignore: cast_nullable_to_non_nullable
as IdName?,receiveNote: freezed == receiveNote ? _self.receiveNote : receiveNote // ignore: cast_nullable_to_non_nullable
as String?,createdBy: null == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as IdName,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,voidedAt: freezed == voidedAt ? _self.voidedAt : voidedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,voidedBy: freezed == voidedBy ? _self.voidedBy : voidedBy // ignore: cast_nullable_to_non_nullable
as IdName?,voidReason: freezed == voidReason ? _self.voidReason : voidReason // ignore: cast_nullable_to_non_nullable
as String?,photoCount: null == photoCount ? _self.photoCount : photoCount // ignore: cast_nullable_to_non_nullable
as int,request: freezed == request ? _self.request : request // ignore: cast_nullable_to_non_nullable
as RequestRef?,photos: null == photos ? _self._photos : photos // ignore: cast_nullable_to_non_nullable
as List<StockPhoto>,canReceive: null == canReceive ? _self.canReceive : canReceive // ignore: cast_nullable_to_non_nullable
as bool,canVoid: null == canVoid ? _self.canVoid : canVoid // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of StockEntry
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StockPlaceRefCopyWith<$Res> get from {
  
  return $StockPlaceRefCopyWith<$Res>(_self.from, (value) {
    return _then(_self.copyWith(from: value));
  });
}/// Create a copy of StockEntry
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StockPlaceRefCopyWith<$Res> get to {
  
  return $StockPlaceRefCopyWith<$Res>(_self.to, (value) {
    return _then(_self.copyWith(to: value));
  });
}/// Create a copy of StockEntry
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$IdNameCopyWith<$Res>? get receivedBy {
    if (_self.receivedBy == null) {
    return null;
  }

  return $IdNameCopyWith<$Res>(_self.receivedBy!, (value) {
    return _then(_self.copyWith(receivedBy: value));
  });
}/// Create a copy of StockEntry
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$IdNameCopyWith<$Res> get createdBy {
  
  return $IdNameCopyWith<$Res>(_self.createdBy, (value) {
    return _then(_self.copyWith(createdBy: value));
  });
}/// Create a copy of StockEntry
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
}/// Create a copy of StockEntry
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RequestRefCopyWith<$Res>? get request {
    if (_self.request == null) {
    return null;
  }

  return $RequestRefCopyWith<$Res>(_self.request!, (value) {
    return _then(_self.copyWith(request: value));
  });
}
}


/// @nodoc
mixin _$HolderStockRow {

 StockMaterial get material; String get onHand; String get received; String get used; String get sentOut; String get wasted; String get adjusted; String? get usedValue; String? get onHandValue;
/// Create a copy of HolderStockRow
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HolderStockRowCopyWith<HolderStockRow> get copyWith => _$HolderStockRowCopyWithImpl<HolderStockRow>(this as HolderStockRow, _$identity);

  /// Serializes this HolderStockRow to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as HolderStockRow;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HolderStockRow&&(identical(other.material, _this.material) || other.material == _this.material)&&(identical(other.onHand, _this.onHand) || other.onHand == _this.onHand)&&(identical(other.received, _this.received) || other.received == _this.received)&&(identical(other.used, _this.used) || other.used == _this.used)&&(identical(other.sentOut, _this.sentOut) || other.sentOut == _this.sentOut)&&(identical(other.wasted, _this.wasted) || other.wasted == _this.wasted)&&(identical(other.adjusted, _this.adjusted) || other.adjusted == _this.adjusted)&&(identical(other.usedValue, _this.usedValue) || other.usedValue == _this.usedValue)&&(identical(other.onHandValue, _this.onHandValue) || other.onHandValue == _this.onHandValue));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as HolderStockRow;
  return Object.hash(runtimeType,_this.material,_this.onHand,_this.received,_this.used,_this.sentOut,_this.wasted,_this.adjusted,_this.usedValue,_this.onHandValue);
}

@override
String toString() {
  final _this = this as HolderStockRow;
  return 'HolderStockRow(material: ${_this.material}, onHand: ${_this.onHand}, received: ${_this.received}, used: ${_this.used}, sentOut: ${_this.sentOut}, wasted: ${_this.wasted}, adjusted: ${_this.adjusted}, usedValue: ${_this.usedValue}, onHandValue: ${_this.onHandValue})';
}


}

/// @nodoc
abstract mixin class $HolderStockRowCopyWith<$Res>  {
  factory $HolderStockRowCopyWith(HolderStockRow value, $Res Function(HolderStockRow) _then) = _$HolderStockRowCopyWithImpl;
@useResult
$Res call({
 StockMaterial material, String onHand, String received, String used, String sentOut, String wasted, String adjusted, String? usedValue, String? onHandValue
});


$StockMaterialCopyWith<$Res> get material;

}
/// @nodoc
class _$HolderStockRowCopyWithImpl<$Res>
    implements $HolderStockRowCopyWith<$Res> {
  _$HolderStockRowCopyWithImpl(this._self, this._then);

  final HolderStockRow _self;
  final $Res Function(HolderStockRow) _then;

/// Create a copy of HolderStockRow
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? material = null,Object? onHand = null,Object? received = null,Object? used = null,Object? sentOut = null,Object? wasted = null,Object? adjusted = null,Object? usedValue = freezed,Object? onHandValue = freezed,}) {
  return _then(HolderStockRow(
material: null == material ? _self.material : material // ignore: cast_nullable_to_non_nullable
as StockMaterial,onHand: null == onHand ? _self.onHand : onHand // ignore: cast_nullable_to_non_nullable
as String,received: null == received ? _self.received : received // ignore: cast_nullable_to_non_nullable
as String,used: null == used ? _self.used : used // ignore: cast_nullable_to_non_nullable
as String,sentOut: null == sentOut ? _self.sentOut : sentOut // ignore: cast_nullable_to_non_nullable
as String,wasted: null == wasted ? _self.wasted : wasted // ignore: cast_nullable_to_non_nullable
as String,adjusted: null == adjusted ? _self.adjusted : adjusted // ignore: cast_nullable_to_non_nullable
as String,usedValue: freezed == usedValue ? _self.usedValue : usedValue // ignore: cast_nullable_to_non_nullable
as String?,onHandValue: freezed == onHandValue ? _self.onHandValue : onHandValue // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of HolderStockRow
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StockMaterialCopyWith<$Res> get material {
  
  return $StockMaterialCopyWith<$Res>(_self.material, (value) {
    return _then(_self.copyWith(material: value));
  });
}
}


/// Adds pattern-matching-related methods to [HolderStockRow].
extension HolderStockRowPatterns on HolderStockRow {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HolderStockRow value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HolderStockRow() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HolderStockRow value)  $default,){
final _that = this;
switch (_that) {
case _HolderStockRow():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HolderStockRow value)?  $default,){
final _that = this;
switch (_that) {
case _HolderStockRow() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( StockMaterial material,  String onHand,  String received,  String used,  String sentOut,  String wasted,  String adjusted,  String? usedValue,  String? onHandValue)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HolderStockRow() when $default != null:
return $default(_that.material,_that.onHand,_that.received,_that.used,_that.sentOut,_that.wasted,_that.adjusted,_that.usedValue,_that.onHandValue);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( StockMaterial material,  String onHand,  String received,  String used,  String sentOut,  String wasted,  String adjusted,  String? usedValue,  String? onHandValue)  $default,) {final _that = this;
switch (_that) {
case _HolderStockRow():
return $default(_that.material,_that.onHand,_that.received,_that.used,_that.sentOut,_that.wasted,_that.adjusted,_that.usedValue,_that.onHandValue);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( StockMaterial material,  String onHand,  String received,  String used,  String sentOut,  String wasted,  String adjusted,  String? usedValue,  String? onHandValue)?  $default,) {final _that = this;
switch (_that) {
case _HolderStockRow() when $default != null:
return $default(_that.material,_that.onHand,_that.received,_that.used,_that.sentOut,_that.wasted,_that.adjusted,_that.usedValue,_that.onHandValue);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HolderStockRow extends HolderStockRow {
  const _HolderStockRow({required this.material, required this.onHand, required this.received, required this.used, required this.sentOut, required this.wasted, required this.adjusted, this.usedValue, this.onHandValue}): super._();
  factory _HolderStockRow.fromJson(Map<String, dynamic> json) => _$HolderStockRowFromJson(json);

@override final  StockMaterial material;
@override final  String onHand;
@override final  String received;
@override final  String used;
@override final  String sentOut;
@override final  String wasted;
@override final  String adjusted;
@override final  String? usedValue;
@override final  String? onHandValue;

/// Create a copy of HolderStockRow
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HolderStockRowCopyWith<_HolderStockRow> get copyWith => __$HolderStockRowCopyWithImpl<_HolderStockRow>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HolderStockRowToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _HolderStockRow&&(identical(other.material, material) || other.material == material)&&(identical(other.onHand, onHand) || other.onHand == onHand)&&(identical(other.received, received) || other.received == received)&&(identical(other.used, used) || other.used == used)&&(identical(other.sentOut, sentOut) || other.sentOut == sentOut)&&(identical(other.wasted, wasted) || other.wasted == wasted)&&(identical(other.adjusted, adjusted) || other.adjusted == adjusted)&&(identical(other.usedValue, usedValue) || other.usedValue == usedValue)&&(identical(other.onHandValue, onHandValue) || other.onHandValue == onHandValue));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,material,onHand,received,used,sentOut,wasted,adjusted,usedValue,onHandValue);
}

@override
String toString() {
    return 'HolderStockRow(material: $material, onHand: $onHand, received: $received, used: $used, sentOut: $sentOut, wasted: $wasted, adjusted: $adjusted, usedValue: $usedValue, onHandValue: $onHandValue)';
}


}

/// @nodoc
abstract mixin class _$HolderStockRowCopyWith<$Res> implements $HolderStockRowCopyWith<$Res> {
  factory _$HolderStockRowCopyWith(_HolderStockRow value, $Res Function(_HolderStockRow) _then) = __$HolderStockRowCopyWithImpl;
@override @useResult
$Res call({
 StockMaterial material, String onHand, String received, String used, String sentOut, String wasted, String adjusted, String? usedValue, String? onHandValue
});


@override $StockMaterialCopyWith<$Res> get material;

}
/// @nodoc
class __$HolderStockRowCopyWithImpl<$Res>
    implements _$HolderStockRowCopyWith<$Res> {
  __$HolderStockRowCopyWithImpl(this._self, this._then);

  final _HolderStockRow _self;
  final $Res Function(_HolderStockRow) _then;

/// Create a copy of HolderStockRow
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? material = null,Object? onHand = null,Object? received = null,Object? used = null,Object? sentOut = null,Object? wasted = null,Object? adjusted = null,Object? usedValue = freezed,Object? onHandValue = freezed,}) {
  return _then(_HolderStockRow(
material: null == material ? _self.material : material // ignore: cast_nullable_to_non_nullable
as StockMaterial,onHand: null == onHand ? _self.onHand : onHand // ignore: cast_nullable_to_non_nullable
as String,received: null == received ? _self.received : received // ignore: cast_nullable_to_non_nullable
as String,used: null == used ? _self.used : used // ignore: cast_nullable_to_non_nullable
as String,sentOut: null == sentOut ? _self.sentOut : sentOut // ignore: cast_nullable_to_non_nullable
as String,wasted: null == wasted ? _self.wasted : wasted // ignore: cast_nullable_to_non_nullable
as String,adjusted: null == adjusted ? _self.adjusted : adjusted // ignore: cast_nullable_to_non_nullable
as String,usedValue: freezed == usedValue ? _self.usedValue : usedValue // ignore: cast_nullable_to_non_nullable
as String?,onHandValue: freezed == onHandValue ? _self.onHandValue : onHandValue // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of HolderStockRow
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StockMaterialCopyWith<$Res> get material {
  
  return $StockMaterialCopyWith<$Res>(_self.material, (value) {
    return _then(_self.copyWith(material: value));
  });
}
}


/// @nodoc
mixin _$StockSite {

 String get id; String get code; String get name; SiteStatus get status;
/// Create a copy of StockSite
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StockSiteCopyWith<StockSite> get copyWith => _$StockSiteCopyWithImpl<StockSite>(this as StockSite, _$identity);

  /// Serializes this StockSite to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as StockSite;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StockSite&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.code, _this.code) || other.code == _this.code)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.status, _this.status) || other.status == _this.status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as StockSite;
  return Object.hash(runtimeType,_this.id,_this.code,_this.name,_this.status);
}

@override
String toString() {
  final _this = this as StockSite;
  return 'StockSite(id: ${_this.id}, code: ${_this.code}, name: ${_this.name}, status: ${_this.status})';
}


}

/// @nodoc
abstract mixin class $StockSiteCopyWith<$Res>  {
  factory $StockSiteCopyWith(StockSite value, $Res Function(StockSite) _then) = _$StockSiteCopyWithImpl;
@useResult
$Res call({
 String id, String code, String name, SiteStatus status
});




}
/// @nodoc
class _$StockSiteCopyWithImpl<$Res>
    implements $StockSiteCopyWith<$Res> {
  _$StockSiteCopyWithImpl(this._self, this._then);

  final StockSite _self;
  final $Res Function(StockSite) _then;

/// Create a copy of StockSite
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? code = null,Object? name = null,Object? status = null,}) {
  return _then(StockSite(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as SiteStatus,
  ));
}

}


/// Adds pattern-matching-related methods to [StockSite].
extension StockSitePatterns on StockSite {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StockSite value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StockSite() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StockSite value)  $default,){
final _that = this;
switch (_that) {
case _StockSite():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StockSite value)?  $default,){
final _that = this;
switch (_that) {
case _StockSite() when $default != null:
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
case _StockSite() when $default != null:
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
case _StockSite():
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
case _StockSite() when $default != null:
return $default(_that.id,_that.code,_that.name,_that.status);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StockSite implements StockSite {
  const _StockSite({required this.id, required this.code, required this.name, required this.status});
  factory _StockSite.fromJson(Map<String, dynamic> json) => _$StockSiteFromJson(json);

@override final  String id;
@override final  String code;
@override final  String name;
@override final  SiteStatus status;

/// Create a copy of StockSite
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StockSiteCopyWith<_StockSite> get copyWith => __$StockSiteCopyWithImpl<_StockSite>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StockSiteToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _StockSite&&(identical(other.id, id) || other.id == id)&&(identical(other.code, code) || other.code == code)&&(identical(other.name, name) || other.name == name)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,code,name,status);
}

@override
String toString() {
    return 'StockSite(id: $id, code: $code, name: $name, status: $status)';
}


}

/// @nodoc
abstract mixin class _$StockSiteCopyWith<$Res> implements $StockSiteCopyWith<$Res> {
  factory _$StockSiteCopyWith(_StockSite value, $Res Function(_StockSite) _then) = __$StockSiteCopyWithImpl;
@override @useResult
$Res call({
 String id, String code, String name, SiteStatus status
});




}
/// @nodoc
class __$StockSiteCopyWithImpl<$Res>
    implements _$StockSiteCopyWith<$Res> {
  __$StockSiteCopyWithImpl(this._self, this._then);

  final _StockSite _self;
  final $Res Function(_StockSite) _then;

/// Create a copy of StockSite
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? code = null,Object? name = null,Object? status = null,}) {
  return _then(_StockSite(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as SiteStatus,
  ));
}


}


/// @nodoc
mixin _$StockValue {

 String? get used; String get onHand;
/// Create a copy of StockValue
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StockValueCopyWith<StockValue> get copyWith => _$StockValueCopyWithImpl<StockValue>(this as StockValue, _$identity);

  /// Serializes this StockValue to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as StockValue;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StockValue&&(identical(other.used, _this.used) || other.used == _this.used)&&(identical(other.onHand, _this.onHand) || other.onHand == _this.onHand));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as StockValue;
  return Object.hash(runtimeType,_this.used,_this.onHand);
}

@override
String toString() {
  final _this = this as StockValue;
  return 'StockValue(used: ${_this.used}, onHand: ${_this.onHand})';
}


}

/// @nodoc
abstract mixin class $StockValueCopyWith<$Res>  {
  factory $StockValueCopyWith(StockValue value, $Res Function(StockValue) _then) = _$StockValueCopyWithImpl;
@useResult
$Res call({
 String? used, String onHand
});




}
/// @nodoc
class _$StockValueCopyWithImpl<$Res>
    implements $StockValueCopyWith<$Res> {
  _$StockValueCopyWithImpl(this._self, this._then);

  final StockValue _self;
  final $Res Function(StockValue) _then;

/// Create a copy of StockValue
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? used = freezed,Object? onHand = null,}) {
  return _then(StockValue(
used: freezed == used ? _self.used : used // ignore: cast_nullable_to_non_nullable
as String?,onHand: null == onHand ? _self.onHand : onHand // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [StockValue].
extension StockValuePatterns on StockValue {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StockValue value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StockValue() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StockValue value)  $default,){
final _that = this;
switch (_that) {
case _StockValue():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StockValue value)?  $default,){
final _that = this;
switch (_that) {
case _StockValue() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? used,  String onHand)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StockValue() when $default != null:
return $default(_that.used,_that.onHand);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? used,  String onHand)  $default,) {final _that = this;
switch (_that) {
case _StockValue():
return $default(_that.used,_that.onHand);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? used,  String onHand)?  $default,) {final _that = this;
switch (_that) {
case _StockValue() when $default != null:
return $default(_that.used,_that.onHand);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StockValue implements StockValue {
  const _StockValue({this.used, required this.onHand});
  factory _StockValue.fromJson(Map<String, dynamic> json) => _$StockValueFromJson(json);

@override final  String? used;
@override final  String onHand;

/// Create a copy of StockValue
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StockValueCopyWith<_StockValue> get copyWith => __$StockValueCopyWithImpl<_StockValue>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StockValueToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _StockValue&&(identical(other.used, used) || other.used == used)&&(identical(other.onHand, onHand) || other.onHand == onHand));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,used,onHand);
}

@override
String toString() {
    return 'StockValue(used: $used, onHand: $onHand)';
}


}

/// @nodoc
abstract mixin class _$StockValueCopyWith<$Res> implements $StockValueCopyWith<$Res> {
  factory _$StockValueCopyWith(_StockValue value, $Res Function(_StockValue) _then) = __$StockValueCopyWithImpl;
@override @useResult
$Res call({
 String? used, String onHand
});




}
/// @nodoc
class __$StockValueCopyWithImpl<$Res>
    implements _$StockValueCopyWith<$Res> {
  __$StockValueCopyWithImpl(this._self, this._then);

  final _StockValue _self;
  final $Res Function(_StockValue) _then;

/// Create a copy of StockValue
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? used = freezed,Object? onHand = null,}) {
  return _then(_StockValue(
used: freezed == used ? _self.used : used // ignore: cast_nullable_to_non_nullable
as String?,onHand: null == onHand ? _self.onHand : onHand // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$SiteStock {

 StockSite get site;/// Every material the site has held, those on hand first.
 List<HolderStockRow> get items;/// Deliveries on the way, waiting for the site to confirm.
 List<StockEntry> get arriving;/// Sent from the site, not yet confirmed by the receiver.
 List<StockEntry> get leaving; bool get usedToday;/// Admins only.
 StockValue? get value;
/// Create a copy of SiteStock
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SiteStockCopyWith<SiteStock> get copyWith => _$SiteStockCopyWithImpl<SiteStock>(this as SiteStock, _$identity);

  /// Serializes this SiteStock to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as SiteStock;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SiteStock&&(identical(other.site, _this.site) || other.site == _this.site)&&const DeepCollectionEquality().equals(other.items, _this.items)&&const DeepCollectionEquality().equals(other.arriving, _this.arriving)&&const DeepCollectionEquality().equals(other.leaving, _this.leaving)&&(identical(other.usedToday, _this.usedToday) || other.usedToday == _this.usedToday)&&(identical(other.value, _this.value) || other.value == _this.value));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as SiteStock;
  return Object.hash(runtimeType,_this.site,const DeepCollectionEquality().hash(_this.items),const DeepCollectionEquality().hash(_this.arriving),const DeepCollectionEquality().hash(_this.leaving),_this.usedToday,_this.value);
}

@override
String toString() {
  final _this = this as SiteStock;
  return 'SiteStock(site: ${_this.site}, items: ${_this.items}, arriving: ${_this.arriving}, leaving: ${_this.leaving}, usedToday: ${_this.usedToday}, value: ${_this.value})';
}


}

/// @nodoc
abstract mixin class $SiteStockCopyWith<$Res>  {
  factory $SiteStockCopyWith(SiteStock value, $Res Function(SiteStock) _then) = _$SiteStockCopyWithImpl;
@useResult
$Res call({
 StockSite site, List<HolderStockRow> items, List<StockEntry> arriving, List<StockEntry> leaving, bool usedToday, StockValue? value
});


$StockSiteCopyWith<$Res> get site;$StockValueCopyWith<$Res>? get value;

}
/// @nodoc
class _$SiteStockCopyWithImpl<$Res>
    implements $SiteStockCopyWith<$Res> {
  _$SiteStockCopyWithImpl(this._self, this._then);

  final SiteStock _self;
  final $Res Function(SiteStock) _then;

/// Create a copy of SiteStock
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? site = null,Object? items = null,Object? arriving = null,Object? leaving = null,Object? usedToday = null,Object? value = freezed,}) {
  return _then(SiteStock(
site: null == site ? _self.site : site // ignore: cast_nullable_to_non_nullable
as StockSite,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<HolderStockRow>,arriving: null == arriving ? _self.arriving : arriving // ignore: cast_nullable_to_non_nullable
as List<StockEntry>,leaving: null == leaving ? _self.leaving : leaving // ignore: cast_nullable_to_non_nullable
as List<StockEntry>,usedToday: null == usedToday ? _self.usedToday : usedToday // ignore: cast_nullable_to_non_nullable
as bool,value: freezed == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as StockValue?,
  ));
}
/// Create a copy of SiteStock
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StockSiteCopyWith<$Res> get site {
  
  return $StockSiteCopyWith<$Res>(_self.site, (value) {
    return _then(_self.copyWith(site: value));
  });
}/// Create a copy of SiteStock
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StockValueCopyWith<$Res>? get value {
    if (_self.value == null) {
    return null;
  }

  return $StockValueCopyWith<$Res>(_self.value!, (value) {
    return _then(_self.copyWith(value: value));
  });
}
}


/// Adds pattern-matching-related methods to [SiteStock].
extension SiteStockPatterns on SiteStock {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SiteStock value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SiteStock() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SiteStock value)  $default,){
final _that = this;
switch (_that) {
case _SiteStock():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SiteStock value)?  $default,){
final _that = this;
switch (_that) {
case _SiteStock() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( StockSite site,  List<HolderStockRow> items,  List<StockEntry> arriving,  List<StockEntry> leaving,  bool usedToday,  StockValue? value)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SiteStock() when $default != null:
return $default(_that.site,_that.items,_that.arriving,_that.leaving,_that.usedToday,_that.value);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( StockSite site,  List<HolderStockRow> items,  List<StockEntry> arriving,  List<StockEntry> leaving,  bool usedToday,  StockValue? value)  $default,) {final _that = this;
switch (_that) {
case _SiteStock():
return $default(_that.site,_that.items,_that.arriving,_that.leaving,_that.usedToday,_that.value);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( StockSite site,  List<HolderStockRow> items,  List<StockEntry> arriving,  List<StockEntry> leaving,  bool usedToday,  StockValue? value)?  $default,) {final _that = this;
switch (_that) {
case _SiteStock() when $default != null:
return $default(_that.site,_that.items,_that.arriving,_that.leaving,_that.usedToday,_that.value);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SiteStock implements SiteStock {
  const _SiteStock({required this.site, required  List<HolderStockRow> items, required  List<StockEntry> arriving, required  List<StockEntry> leaving, this.usedToday = false, this.value}): _items = items,_arriving = arriving,_leaving = leaving;
  factory _SiteStock.fromJson(Map<String, dynamic> json) => _$SiteStockFromJson(json);

@override final  StockSite site;
/// Every material the site has held, those on hand first.
 final  List<HolderStockRow> _items;
/// Every material the site has held, those on hand first.
@override List<HolderStockRow> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

/// Deliveries on the way, waiting for the site to confirm.
 final  List<StockEntry> _arriving;
/// Deliveries on the way, waiting for the site to confirm.
@override List<StockEntry> get arriving {
  if (_arriving is EqualUnmodifiableListView) return _arriving;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_arriving);
}

/// Sent from the site, not yet confirmed by the receiver.
 final  List<StockEntry> _leaving;
/// Sent from the site, not yet confirmed by the receiver.
@override List<StockEntry> get leaving {
  if (_leaving is EqualUnmodifiableListView) return _leaving;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_leaving);
}

@override@JsonKey() final  bool usedToday;
/// Admins only.
@override final  StockValue? value;

/// Create a copy of SiteStock
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SiteStockCopyWith<_SiteStock> get copyWith => __$SiteStockCopyWithImpl<_SiteStock>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SiteStockToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SiteStock&&(identical(other.site, site) || other.site == site)&&const DeepCollectionEquality().equals(other.items, _items)&&const DeepCollectionEquality().equals(other.arriving, _arriving)&&const DeepCollectionEquality().equals(other.leaving, _leaving)&&(identical(other.usedToday, usedToday) || other.usedToday == usedToday)&&(identical(other.value, value) || other.value == value));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,site,const DeepCollectionEquality().hash(_items),const DeepCollectionEquality().hash(_arriving),const DeepCollectionEquality().hash(_leaving),usedToday,value);
}

@override
String toString() {
    return 'SiteStock(site: $site, items: $items, arriving: $arriving, leaving: $leaving, usedToday: $usedToday, value: $value)';
}


}

/// @nodoc
abstract mixin class _$SiteStockCopyWith<$Res> implements $SiteStockCopyWith<$Res> {
  factory _$SiteStockCopyWith(_SiteStock value, $Res Function(_SiteStock) _then) = __$SiteStockCopyWithImpl;
@override @useResult
$Res call({
 StockSite site, List<HolderStockRow> items, List<StockEntry> arriving, List<StockEntry> leaving, bool usedToday, StockValue? value
});


@override $StockSiteCopyWith<$Res> get site;@override $StockValueCopyWith<$Res>? get value;

}
/// @nodoc
class __$SiteStockCopyWithImpl<$Res>
    implements _$SiteStockCopyWith<$Res> {
  __$SiteStockCopyWithImpl(this._self, this._then);

  final _SiteStock _self;
  final $Res Function(_SiteStock) _then;

/// Create a copy of SiteStock
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? site = null,Object? items = null,Object? arriving = null,Object? leaving = null,Object? usedToday = null,Object? value = freezed,}) {
  return _then(_SiteStock(
site: null == site ? _self.site : site // ignore: cast_nullable_to_non_nullable
as StockSite,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<HolderStockRow>,arriving: null == arriving ? _self._arriving : arriving // ignore: cast_nullable_to_non_nullable
as List<StockEntry>,leaving: null == leaving ? _self._leaving : leaving // ignore: cast_nullable_to_non_nullable
as List<StockEntry>,usedToday: null == usedToday ? _self.usedToday : usedToday // ignore: cast_nullable_to_non_nullable
as bool,value: freezed == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as StockValue?,
  ));
}

/// Create a copy of SiteStock
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StockSiteCopyWith<$Res> get site {
  
  return $StockSiteCopyWith<$Res>(_self.site, (value) {
    return _then(_self.copyWith(site: value));
  });
}/// Create a copy of SiteStock
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StockValueCopyWith<$Res>? get value {
    if (_self.value == null) {
    return null;
  }

  return $StockValueCopyWith<$Res>(_self.value!, (value) {
    return _then(_self.copyWith(value: value));
  });
}
}


/// @nodoc
mixin _$GodownStock {

 Godown get godown; List<HolderStockRow> get items; List<StockEntry> get arriving; List<StockEntry> get leaving;/// Admins only.
 StockValue? get value;/// Who runs it: they send its stock and confirm what arrives.
 List<PersonRef> get managers;
/// Create a copy of GodownStock
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GodownStockCopyWith<GodownStock> get copyWith => _$GodownStockCopyWithImpl<GodownStock>(this as GodownStock, _$identity);

  /// Serializes this GodownStock to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as GodownStock;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GodownStock&&(identical(other.godown, _this.godown) || other.godown == _this.godown)&&const DeepCollectionEquality().equals(other.items, _this.items)&&const DeepCollectionEquality().equals(other.arriving, _this.arriving)&&const DeepCollectionEquality().equals(other.leaving, _this.leaving)&&(identical(other.value, _this.value) || other.value == _this.value)&&const DeepCollectionEquality().equals(other.managers, _this.managers));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as GodownStock;
  return Object.hash(runtimeType,_this.godown,const DeepCollectionEquality().hash(_this.items),const DeepCollectionEquality().hash(_this.arriving),const DeepCollectionEquality().hash(_this.leaving),_this.value,const DeepCollectionEquality().hash(_this.managers));
}

@override
String toString() {
  final _this = this as GodownStock;
  return 'GodownStock(godown: ${_this.godown}, items: ${_this.items}, arriving: ${_this.arriving}, leaving: ${_this.leaving}, value: ${_this.value}, managers: ${_this.managers})';
}


}

/// @nodoc
abstract mixin class $GodownStockCopyWith<$Res>  {
  factory $GodownStockCopyWith(GodownStock value, $Res Function(GodownStock) _then) = _$GodownStockCopyWithImpl;
@useResult
$Res call({
 Godown godown, List<HolderStockRow> items, List<StockEntry> arriving, List<StockEntry> leaving, StockValue? value, List<PersonRef> managers
});


$GodownCopyWith<$Res> get godown;$StockValueCopyWith<$Res>? get value;

}
/// @nodoc
class _$GodownStockCopyWithImpl<$Res>
    implements $GodownStockCopyWith<$Res> {
  _$GodownStockCopyWithImpl(this._self, this._then);

  final GodownStock _self;
  final $Res Function(GodownStock) _then;

/// Create a copy of GodownStock
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? godown = null,Object? items = null,Object? arriving = null,Object? leaving = null,Object? value = freezed,Object? managers = null,}) {
  return _then(GodownStock(
godown: null == godown ? _self.godown : godown // ignore: cast_nullable_to_non_nullable
as Godown,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<HolderStockRow>,arriving: null == arriving ? _self.arriving : arriving // ignore: cast_nullable_to_non_nullable
as List<StockEntry>,leaving: null == leaving ? _self.leaving : leaving // ignore: cast_nullable_to_non_nullable
as List<StockEntry>,value: freezed == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as StockValue?,managers: null == managers ? _self.managers : managers // ignore: cast_nullable_to_non_nullable
as List<PersonRef>,
  ));
}
/// Create a copy of GodownStock
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GodownCopyWith<$Res> get godown {
  
  return $GodownCopyWith<$Res>(_self.godown, (value) {
    return _then(_self.copyWith(godown: value));
  });
}/// Create a copy of GodownStock
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StockValueCopyWith<$Res>? get value {
    if (_self.value == null) {
    return null;
  }

  return $StockValueCopyWith<$Res>(_self.value!, (value) {
    return _then(_self.copyWith(value: value));
  });
}
}


/// Adds pattern-matching-related methods to [GodownStock].
extension GodownStockPatterns on GodownStock {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GodownStock value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GodownStock() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GodownStock value)  $default,){
final _that = this;
switch (_that) {
case _GodownStock():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GodownStock value)?  $default,){
final _that = this;
switch (_that) {
case _GodownStock() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Godown godown,  List<HolderStockRow> items,  List<StockEntry> arriving,  List<StockEntry> leaving,  StockValue? value,  List<PersonRef> managers)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GodownStock() when $default != null:
return $default(_that.godown,_that.items,_that.arriving,_that.leaving,_that.value,_that.managers);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Godown godown,  List<HolderStockRow> items,  List<StockEntry> arriving,  List<StockEntry> leaving,  StockValue? value,  List<PersonRef> managers)  $default,) {final _that = this;
switch (_that) {
case _GodownStock():
return $default(_that.godown,_that.items,_that.arriving,_that.leaving,_that.value,_that.managers);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Godown godown,  List<HolderStockRow> items,  List<StockEntry> arriving,  List<StockEntry> leaving,  StockValue? value,  List<PersonRef> managers)?  $default,) {final _that = this;
switch (_that) {
case _GodownStock() when $default != null:
return $default(_that.godown,_that.items,_that.arriving,_that.leaving,_that.value,_that.managers);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GodownStock implements GodownStock {
  const _GodownStock({required this.godown, required  List<HolderStockRow> items, required  List<StockEntry> arriving, required  List<StockEntry> leaving, this.value,  List<PersonRef> managers = const <PersonRef>[]}): _items = items,_arriving = arriving,_leaving = leaving,_managers = managers;
  factory _GodownStock.fromJson(Map<String, dynamic> json) => _$GodownStockFromJson(json);

@override final  Godown godown;
 final  List<HolderStockRow> _items;
@override List<HolderStockRow> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

 final  List<StockEntry> _arriving;
@override List<StockEntry> get arriving {
  if (_arriving is EqualUnmodifiableListView) return _arriving;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_arriving);
}

 final  List<StockEntry> _leaving;
@override List<StockEntry> get leaving {
  if (_leaving is EqualUnmodifiableListView) return _leaving;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_leaving);
}

/// Admins only.
@override final  StockValue? value;
/// Who runs it: they send its stock and confirm what arrives.
 final  List<PersonRef> _managers;
/// Who runs it: they send its stock and confirm what arrives.
@override@JsonKey() List<PersonRef> get managers {
  if (_managers is EqualUnmodifiableListView) return _managers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_managers);
}


/// Create a copy of GodownStock
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GodownStockCopyWith<_GodownStock> get copyWith => __$GodownStockCopyWithImpl<_GodownStock>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GodownStockToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _GodownStock&&(identical(other.godown, godown) || other.godown == godown)&&const DeepCollectionEquality().equals(other.items, _items)&&const DeepCollectionEquality().equals(other.arriving, _arriving)&&const DeepCollectionEquality().equals(other.leaving, _leaving)&&(identical(other.value, value) || other.value == value)&&const DeepCollectionEquality().equals(other.managers, _managers));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,godown,const DeepCollectionEquality().hash(_items),const DeepCollectionEquality().hash(_arriving),const DeepCollectionEquality().hash(_leaving),value,const DeepCollectionEquality().hash(_managers));
}

@override
String toString() {
    return 'GodownStock(godown: $godown, items: $items, arriving: $arriving, leaving: $leaving, value: $value, managers: $managers)';
}


}

/// @nodoc
abstract mixin class _$GodownStockCopyWith<$Res> implements $GodownStockCopyWith<$Res> {
  factory _$GodownStockCopyWith(_GodownStock value, $Res Function(_GodownStock) _then) = __$GodownStockCopyWithImpl;
@override @useResult
$Res call({
 Godown godown, List<HolderStockRow> items, List<StockEntry> arriving, List<StockEntry> leaving, StockValue? value, List<PersonRef> managers
});


@override $GodownCopyWith<$Res> get godown;@override $StockValueCopyWith<$Res>? get value;

}
/// @nodoc
class __$GodownStockCopyWithImpl<$Res>
    implements _$GodownStockCopyWith<$Res> {
  __$GodownStockCopyWithImpl(this._self, this._then);

  final _GodownStock _self;
  final $Res Function(_GodownStock) _then;

/// Create a copy of GodownStock
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? godown = null,Object? items = null,Object? arriving = null,Object? leaving = null,Object? value = freezed,Object? managers = null,}) {
  return _then(_GodownStock(
godown: null == godown ? _self.godown : godown // ignore: cast_nullable_to_non_nullable
as Godown,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<HolderStockRow>,arriving: null == arriving ? _self._arriving : arriving // ignore: cast_nullable_to_non_nullable
as List<StockEntry>,leaving: null == leaving ? _self._leaving : leaving // ignore: cast_nullable_to_non_nullable
as List<StockEntry>,value: freezed == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as StockValue?,managers: null == managers ? _self._managers : managers // ignore: cast_nullable_to_non_nullable
as List<PersonRef>,
  ));
}

/// Create a copy of GodownStock
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GodownCopyWith<$Res> get godown {
  
  return $GodownCopyWith<$Res>(_self.godown, (value) {
    return _then(_self.copyWith(godown: value));
  });
}/// Create a copy of GodownStock
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StockValueCopyWith<$Res>? get value {
    if (_self.value == null) {
    return null;
  }

  return $StockValueCopyWith<$Res>(_self.value!, (value) {
    return _then(_self.copyWith(value: value));
  });
}
}


/// @nodoc
mixin _$GodownSummary {

 Godown get godown; int get arriving;
/// Create a copy of GodownSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GodownSummaryCopyWith<GodownSummary> get copyWith => _$GodownSummaryCopyWithImpl<GodownSummary>(this as GodownSummary, _$identity);

  /// Serializes this GodownSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as GodownSummary;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GodownSummary&&(identical(other.godown, _this.godown) || other.godown == _this.godown)&&(identical(other.arriving, _this.arriving) || other.arriving == _this.arriving));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as GodownSummary;
  return Object.hash(runtimeType,_this.godown,_this.arriving);
}

@override
String toString() {
  final _this = this as GodownSummary;
  return 'GodownSummary(godown: ${_this.godown}, arriving: ${_this.arriving})';
}


}

/// @nodoc
abstract mixin class $GodownSummaryCopyWith<$Res>  {
  factory $GodownSummaryCopyWith(GodownSummary value, $Res Function(GodownSummary) _then) = _$GodownSummaryCopyWithImpl;
@useResult
$Res call({
 Godown godown, int arriving
});


$GodownCopyWith<$Res> get godown;

}
/// @nodoc
class _$GodownSummaryCopyWithImpl<$Res>
    implements $GodownSummaryCopyWith<$Res> {
  _$GodownSummaryCopyWithImpl(this._self, this._then);

  final GodownSummary _self;
  final $Res Function(GodownSummary) _then;

/// Create a copy of GodownSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? godown = null,Object? arriving = null,}) {
  return _then(GodownSummary(
godown: null == godown ? _self.godown : godown // ignore: cast_nullable_to_non_nullable
as Godown,arriving: null == arriving ? _self.arriving : arriving // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of GodownSummary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GodownCopyWith<$Res> get godown {
  
  return $GodownCopyWith<$Res>(_self.godown, (value) {
    return _then(_self.copyWith(godown: value));
  });
}
}


/// Adds pattern-matching-related methods to [GodownSummary].
extension GodownSummaryPatterns on GodownSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GodownSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GodownSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GodownSummary value)  $default,){
final _that = this;
switch (_that) {
case _GodownSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GodownSummary value)?  $default,){
final _that = this;
switch (_that) {
case _GodownSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Godown godown,  int arriving)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GodownSummary() when $default != null:
return $default(_that.godown,_that.arriving);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Godown godown,  int arriving)  $default,) {final _that = this;
switch (_that) {
case _GodownSummary():
return $default(_that.godown,_that.arriving);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Godown godown,  int arriving)?  $default,) {final _that = this;
switch (_that) {
case _GodownSummary() when $default != null:
return $default(_that.godown,_that.arriving);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GodownSummary implements GodownSummary {
  const _GodownSummary({required this.godown, required this.arriving});
  factory _GodownSummary.fromJson(Map<String, dynamic> json) => _$GodownSummaryFromJson(json);

@override final  Godown godown;
@override final  int arriving;

/// Create a copy of GodownSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GodownSummaryCopyWith<_GodownSummary> get copyWith => __$GodownSummaryCopyWithImpl<_GodownSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GodownSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _GodownSummary&&(identical(other.godown, godown) || other.godown == godown)&&(identical(other.arriving, arriving) || other.arriving == arriving));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,godown,arriving);
}

@override
String toString() {
    return 'GodownSummary(godown: $godown, arriving: $arriving)';
}


}

/// @nodoc
abstract mixin class _$GodownSummaryCopyWith<$Res> implements $GodownSummaryCopyWith<$Res> {
  factory _$GodownSummaryCopyWith(_GodownSummary value, $Res Function(_GodownSummary) _then) = __$GodownSummaryCopyWithImpl;
@override @useResult
$Res call({
 Godown godown, int arriving
});


@override $GodownCopyWith<$Res> get godown;

}
/// @nodoc
class __$GodownSummaryCopyWithImpl<$Res>
    implements _$GodownSummaryCopyWith<$Res> {
  __$GodownSummaryCopyWithImpl(this._self, this._then);

  final _GodownSummary _self;
  final $Res Function(_GodownSummary) _then;

/// Create a copy of GodownSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? godown = null,Object? arriving = null,}) {
  return _then(_GodownSummary(
godown: null == godown ? _self.godown : godown // ignore: cast_nullable_to_non_nullable
as Godown,arriving: null == arriving ? _self.arriving : arriving // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of GodownSummary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GodownCopyWith<$Res> get godown {
  
  return $GodownCopyWith<$Res>(_self.godown, (value) {
    return _then(_self.copyWith(godown: value));
  });
}
}


/// @nodoc
mixin _$MaterialTotals {

 StockMaterial get material; String get inGodowns; String get onSites;/// All godowns together are below the material's minimum.
 bool get low;
/// Create a copy of MaterialTotals
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MaterialTotalsCopyWith<MaterialTotals> get copyWith => _$MaterialTotalsCopyWithImpl<MaterialTotals>(this as MaterialTotals, _$identity);

  /// Serializes this MaterialTotals to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MaterialTotals;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MaterialTotals&&(identical(other.material, _this.material) || other.material == _this.material)&&(identical(other.inGodowns, _this.inGodowns) || other.inGodowns == _this.inGodowns)&&(identical(other.onSites, _this.onSites) || other.onSites == _this.onSites)&&(identical(other.low, _this.low) || other.low == _this.low));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MaterialTotals;
  return Object.hash(runtimeType,_this.material,_this.inGodowns,_this.onSites,_this.low);
}

@override
String toString() {
  final _this = this as MaterialTotals;
  return 'MaterialTotals(material: ${_this.material}, inGodowns: ${_this.inGodowns}, onSites: ${_this.onSites}, low: ${_this.low})';
}


}

/// @nodoc
abstract mixin class $MaterialTotalsCopyWith<$Res>  {
  factory $MaterialTotalsCopyWith(MaterialTotals value, $Res Function(MaterialTotals) _then) = _$MaterialTotalsCopyWithImpl;
@useResult
$Res call({
 StockMaterial material, String inGodowns, String onSites, bool low
});


$StockMaterialCopyWith<$Res> get material;

}
/// @nodoc
class _$MaterialTotalsCopyWithImpl<$Res>
    implements $MaterialTotalsCopyWith<$Res> {
  _$MaterialTotalsCopyWithImpl(this._self, this._then);

  final MaterialTotals _self;
  final $Res Function(MaterialTotals) _then;

/// Create a copy of MaterialTotals
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? material = null,Object? inGodowns = null,Object? onSites = null,Object? low = null,}) {
  return _then(MaterialTotals(
material: null == material ? _self.material : material // ignore: cast_nullable_to_non_nullable
as StockMaterial,inGodowns: null == inGodowns ? _self.inGodowns : inGodowns // ignore: cast_nullable_to_non_nullable
as String,onSites: null == onSites ? _self.onSites : onSites // ignore: cast_nullable_to_non_nullable
as String,low: null == low ? _self.low : low // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of MaterialTotals
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StockMaterialCopyWith<$Res> get material {
  
  return $StockMaterialCopyWith<$Res>(_self.material, (value) {
    return _then(_self.copyWith(material: value));
  });
}
}


/// Adds pattern-matching-related methods to [MaterialTotals].
extension MaterialTotalsPatterns on MaterialTotals {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MaterialTotals value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MaterialTotals() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MaterialTotals value)  $default,){
final _that = this;
switch (_that) {
case _MaterialTotals():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MaterialTotals value)?  $default,){
final _that = this;
switch (_that) {
case _MaterialTotals() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( StockMaterial material,  String inGodowns,  String onSites,  bool low)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MaterialTotals() when $default != null:
return $default(_that.material,_that.inGodowns,_that.onSites,_that.low);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( StockMaterial material,  String inGodowns,  String onSites,  bool low)  $default,) {final _that = this;
switch (_that) {
case _MaterialTotals():
return $default(_that.material,_that.inGodowns,_that.onSites,_that.low);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( StockMaterial material,  String inGodowns,  String onSites,  bool low)?  $default,) {final _that = this;
switch (_that) {
case _MaterialTotals() when $default != null:
return $default(_that.material,_that.inGodowns,_that.onSites,_that.low);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MaterialTotals implements MaterialTotals {
  const _MaterialTotals({required this.material, required this.inGodowns, required this.onSites, required this.low});
  factory _MaterialTotals.fromJson(Map<String, dynamic> json) => _$MaterialTotalsFromJson(json);

@override final  StockMaterial material;
@override final  String inGodowns;
@override final  String onSites;
/// All godowns together are below the material's minimum.
@override final  bool low;

/// Create a copy of MaterialTotals
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MaterialTotalsCopyWith<_MaterialTotals> get copyWith => __$MaterialTotalsCopyWithImpl<_MaterialTotals>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MaterialTotalsToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MaterialTotals&&(identical(other.material, material) || other.material == material)&&(identical(other.inGodowns, inGodowns) || other.inGodowns == inGodowns)&&(identical(other.onSites, onSites) || other.onSites == onSites)&&(identical(other.low, low) || other.low == low));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,material,inGodowns,onSites,low);
}

@override
String toString() {
    return 'MaterialTotals(material: $material, inGodowns: $inGodowns, onSites: $onSites, low: $low)';
}


}

/// @nodoc
abstract mixin class _$MaterialTotalsCopyWith<$Res> implements $MaterialTotalsCopyWith<$Res> {
  factory _$MaterialTotalsCopyWith(_MaterialTotals value, $Res Function(_MaterialTotals) _then) = __$MaterialTotalsCopyWithImpl;
@override @useResult
$Res call({
 StockMaterial material, String inGodowns, String onSites, bool low
});


@override $StockMaterialCopyWith<$Res> get material;

}
/// @nodoc
class __$MaterialTotalsCopyWithImpl<$Res>
    implements _$MaterialTotalsCopyWith<$Res> {
  __$MaterialTotalsCopyWithImpl(this._self, this._then);

  final _MaterialTotals _self;
  final $Res Function(_MaterialTotals) _then;

/// Create a copy of MaterialTotals
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? material = null,Object? inGodowns = null,Object? onSites = null,Object? low = null,}) {
  return _then(_MaterialTotals(
material: null == material ? _self.material : material // ignore: cast_nullable_to_non_nullable
as StockMaterial,inGodowns: null == inGodowns ? _self.inGodowns : inGodowns // ignore: cast_nullable_to_non_nullable
as String,onSites: null == onSites ? _self.onSites : onSites // ignore: cast_nullable_to_non_nullable
as String,low: null == low ? _self.low : low // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of MaterialTotals
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StockMaterialCopyWith<$Res> get material {
  
  return $StockMaterialCopyWith<$Res>(_self.material, (value) {
    return _then(_self.copyWith(material: value));
  });
}
}


/// @nodoc
mixin _$StockOverview {

 List<GodownSummary> get godowns; List<MaterialTotals> get materials;/// Entries on the way that the user can confirm.
 int get toReceive;/// Sites the user can request material for (not completed): all of them
/// for admins, their own for engineers.
 List<SiteRef> get sites;
/// Create a copy of StockOverview
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StockOverviewCopyWith<StockOverview> get copyWith => _$StockOverviewCopyWithImpl<StockOverview>(this as StockOverview, _$identity);

  /// Serializes this StockOverview to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as StockOverview;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StockOverview&&const DeepCollectionEquality().equals(other.godowns, _this.godowns)&&const DeepCollectionEquality().equals(other.materials, _this.materials)&&(identical(other.toReceive, _this.toReceive) || other.toReceive == _this.toReceive)&&const DeepCollectionEquality().equals(other.sites, _this.sites));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as StockOverview;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.godowns),const DeepCollectionEquality().hash(_this.materials),_this.toReceive,const DeepCollectionEquality().hash(_this.sites));
}

@override
String toString() {
  final _this = this as StockOverview;
  return 'StockOverview(godowns: ${_this.godowns}, materials: ${_this.materials}, toReceive: ${_this.toReceive}, sites: ${_this.sites})';
}


}

/// @nodoc
abstract mixin class $StockOverviewCopyWith<$Res>  {
  factory $StockOverviewCopyWith(StockOverview value, $Res Function(StockOverview) _then) = _$StockOverviewCopyWithImpl;
@useResult
$Res call({
 List<GodownSummary> godowns, List<MaterialTotals> materials, int toReceive, List<SiteRef> sites
});




}
/// @nodoc
class _$StockOverviewCopyWithImpl<$Res>
    implements $StockOverviewCopyWith<$Res> {
  _$StockOverviewCopyWithImpl(this._self, this._then);

  final StockOverview _self;
  final $Res Function(StockOverview) _then;

/// Create a copy of StockOverview
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? godowns = null,Object? materials = null,Object? toReceive = null,Object? sites = null,}) {
  return _then(StockOverview(
godowns: null == godowns ? _self.godowns : godowns // ignore: cast_nullable_to_non_nullable
as List<GodownSummary>,materials: null == materials ? _self.materials : materials // ignore: cast_nullable_to_non_nullable
as List<MaterialTotals>,toReceive: null == toReceive ? _self.toReceive : toReceive // ignore: cast_nullable_to_non_nullable
as int,sites: null == sites ? _self.sites : sites // ignore: cast_nullable_to_non_nullable
as List<SiteRef>,
  ));
}

}


/// Adds pattern-matching-related methods to [StockOverview].
extension StockOverviewPatterns on StockOverview {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StockOverview value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StockOverview() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StockOverview value)  $default,){
final _that = this;
switch (_that) {
case _StockOverview():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StockOverview value)?  $default,){
final _that = this;
switch (_that) {
case _StockOverview() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<GodownSummary> godowns,  List<MaterialTotals> materials,  int toReceive,  List<SiteRef> sites)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StockOverview() when $default != null:
return $default(_that.godowns,_that.materials,_that.toReceive,_that.sites);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<GodownSummary> godowns,  List<MaterialTotals> materials,  int toReceive,  List<SiteRef> sites)  $default,) {final _that = this;
switch (_that) {
case _StockOverview():
return $default(_that.godowns,_that.materials,_that.toReceive,_that.sites);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<GodownSummary> godowns,  List<MaterialTotals> materials,  int toReceive,  List<SiteRef> sites)?  $default,) {final _that = this;
switch (_that) {
case _StockOverview() when $default != null:
return $default(_that.godowns,_that.materials,_that.toReceive,_that.sites);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StockOverview implements StockOverview {
  const _StockOverview({required  List<GodownSummary> godowns, required  List<MaterialTotals> materials, required this.toReceive,  List<SiteRef> sites = const <SiteRef>[]}): _godowns = godowns,_materials = materials,_sites = sites;
  factory _StockOverview.fromJson(Map<String, dynamic> json) => _$StockOverviewFromJson(json);

 final  List<GodownSummary> _godowns;
@override List<GodownSummary> get godowns {
  if (_godowns is EqualUnmodifiableListView) return _godowns;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_godowns);
}

 final  List<MaterialTotals> _materials;
@override List<MaterialTotals> get materials {
  if (_materials is EqualUnmodifiableListView) return _materials;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_materials);
}

/// Entries on the way that the user can confirm.
@override final  int toReceive;
/// Sites the user can request material for (not completed): all of them
/// for admins, their own for engineers.
 final  List<SiteRef> _sites;
/// Sites the user can request material for (not completed): all of them
/// for admins, their own for engineers.
@override@JsonKey() List<SiteRef> get sites {
  if (_sites is EqualUnmodifiableListView) return _sites;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sites);
}


/// Create a copy of StockOverview
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StockOverviewCopyWith<_StockOverview> get copyWith => __$StockOverviewCopyWithImpl<_StockOverview>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StockOverviewToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _StockOverview&&const DeepCollectionEquality().equals(other.godowns, _godowns)&&const DeepCollectionEquality().equals(other.materials, _materials)&&(identical(other.toReceive, toReceive) || other.toReceive == toReceive)&&const DeepCollectionEquality().equals(other.sites, _sites));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_godowns),const DeepCollectionEquality().hash(_materials),toReceive,const DeepCollectionEquality().hash(_sites));
}

@override
String toString() {
    return 'StockOverview(godowns: $godowns, materials: $materials, toReceive: $toReceive, sites: $sites)';
}


}

/// @nodoc
abstract mixin class _$StockOverviewCopyWith<$Res> implements $StockOverviewCopyWith<$Res> {
  factory _$StockOverviewCopyWith(_StockOverview value, $Res Function(_StockOverview) _then) = __$StockOverviewCopyWithImpl;
@override @useResult
$Res call({
 List<GodownSummary> godowns, List<MaterialTotals> materials, int toReceive, List<SiteRef> sites
});




}
/// @nodoc
class __$StockOverviewCopyWithImpl<$Res>
    implements _$StockOverviewCopyWith<$Res> {
  __$StockOverviewCopyWithImpl(this._self, this._then);

  final _StockOverview _self;
  final $Res Function(_StockOverview) _then;

/// Create a copy of StockOverview
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? godowns = null,Object? materials = null,Object? toReceive = null,Object? sites = null,}) {
  return _then(_StockOverview(
godowns: null == godowns ? _self._godowns : godowns // ignore: cast_nullable_to_non_nullable
as List<GodownSummary>,materials: null == materials ? _self._materials : materials // ignore: cast_nullable_to_non_nullable
as List<MaterialTotals>,toReceive: null == toReceive ? _self.toReceive : toReceive // ignore: cast_nullable_to_non_nullable
as int,sites: null == sites ? _self._sites : sites // ignore: cast_nullable_to_non_nullable
as List<SiteRef>,
  ));
}


}


/// @nodoc
mixin _$GodownHolding {

 IdName get godown; String get onHand;
/// Create a copy of GodownHolding
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GodownHoldingCopyWith<GodownHolding> get copyWith => _$GodownHoldingCopyWithImpl<GodownHolding>(this as GodownHolding, _$identity);

  /// Serializes this GodownHolding to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as GodownHolding;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GodownHolding&&(identical(other.godown, _this.godown) || other.godown == _this.godown)&&(identical(other.onHand, _this.onHand) || other.onHand == _this.onHand));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as GodownHolding;
  return Object.hash(runtimeType,_this.godown,_this.onHand);
}

@override
String toString() {
  final _this = this as GodownHolding;
  return 'GodownHolding(godown: ${_this.godown}, onHand: ${_this.onHand})';
}


}

/// @nodoc
abstract mixin class $GodownHoldingCopyWith<$Res>  {
  factory $GodownHoldingCopyWith(GodownHolding value, $Res Function(GodownHolding) _then) = _$GodownHoldingCopyWithImpl;
@useResult
$Res call({
 IdName godown, String onHand
});


$IdNameCopyWith<$Res> get godown;

}
/// @nodoc
class _$GodownHoldingCopyWithImpl<$Res>
    implements $GodownHoldingCopyWith<$Res> {
  _$GodownHoldingCopyWithImpl(this._self, this._then);

  final GodownHolding _self;
  final $Res Function(GodownHolding) _then;

/// Create a copy of GodownHolding
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? godown = null,Object? onHand = null,}) {
  return _then(GodownHolding(
godown: null == godown ? _self.godown : godown // ignore: cast_nullable_to_non_nullable
as IdName,onHand: null == onHand ? _self.onHand : onHand // ignore: cast_nullable_to_non_nullable
as String,
  ));
}
/// Create a copy of GodownHolding
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$IdNameCopyWith<$Res> get godown {
  
  return $IdNameCopyWith<$Res>(_self.godown, (value) {
    return _then(_self.copyWith(godown: value));
  });
}
}


/// Adds pattern-matching-related methods to [GodownHolding].
extension GodownHoldingPatterns on GodownHolding {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GodownHolding value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GodownHolding() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GodownHolding value)  $default,){
final _that = this;
switch (_that) {
case _GodownHolding():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GodownHolding value)?  $default,){
final _that = this;
switch (_that) {
case _GodownHolding() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( IdName godown,  String onHand)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GodownHolding() when $default != null:
return $default(_that.godown,_that.onHand);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( IdName godown,  String onHand)  $default,) {final _that = this;
switch (_that) {
case _GodownHolding():
return $default(_that.godown,_that.onHand);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( IdName godown,  String onHand)?  $default,) {final _that = this;
switch (_that) {
case _GodownHolding() when $default != null:
return $default(_that.godown,_that.onHand);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GodownHolding implements GodownHolding {
  const _GodownHolding({required this.godown, required this.onHand});
  factory _GodownHolding.fromJson(Map<String, dynamic> json) => _$GodownHoldingFromJson(json);

@override final  IdName godown;
@override final  String onHand;

/// Create a copy of GodownHolding
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GodownHoldingCopyWith<_GodownHolding> get copyWith => __$GodownHoldingCopyWithImpl<_GodownHolding>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GodownHoldingToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _GodownHolding&&(identical(other.godown, godown) || other.godown == godown)&&(identical(other.onHand, onHand) || other.onHand == onHand));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,godown,onHand);
}

@override
String toString() {
    return 'GodownHolding(godown: $godown, onHand: $onHand)';
}


}

/// @nodoc
abstract mixin class _$GodownHoldingCopyWith<$Res> implements $GodownHoldingCopyWith<$Res> {
  factory _$GodownHoldingCopyWith(_GodownHolding value, $Res Function(_GodownHolding) _then) = __$GodownHoldingCopyWithImpl;
@override @useResult
$Res call({
 IdName godown, String onHand
});


@override $IdNameCopyWith<$Res> get godown;

}
/// @nodoc
class __$GodownHoldingCopyWithImpl<$Res>
    implements _$GodownHoldingCopyWith<$Res> {
  __$GodownHoldingCopyWithImpl(this._self, this._then);

  final _GodownHolding _self;
  final $Res Function(_GodownHolding) _then;

/// Create a copy of GodownHolding
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? godown = null,Object? onHand = null,}) {
  return _then(_GodownHolding(
godown: null == godown ? _self.godown : godown // ignore: cast_nullable_to_non_nullable
as IdName,onHand: null == onHand ? _self.onHand : onHand // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

/// Create a copy of GodownHolding
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$IdNameCopyWith<$Res> get godown {
  
  return $IdNameCopyWith<$Res>(_self.godown, (value) {
    return _then(_self.copyWith(godown: value));
  });
}
}


/// @nodoc
mixin _$SiteHolding {

 StockSite get site; String get onHand;
/// Create a copy of SiteHolding
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SiteHoldingCopyWith<SiteHolding> get copyWith => _$SiteHoldingCopyWithImpl<SiteHolding>(this as SiteHolding, _$identity);

  /// Serializes this SiteHolding to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as SiteHolding;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SiteHolding&&(identical(other.site, _this.site) || other.site == _this.site)&&(identical(other.onHand, _this.onHand) || other.onHand == _this.onHand));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as SiteHolding;
  return Object.hash(runtimeType,_this.site,_this.onHand);
}

@override
String toString() {
  final _this = this as SiteHolding;
  return 'SiteHolding(site: ${_this.site}, onHand: ${_this.onHand})';
}


}

/// @nodoc
abstract mixin class $SiteHoldingCopyWith<$Res>  {
  factory $SiteHoldingCopyWith(SiteHolding value, $Res Function(SiteHolding) _then) = _$SiteHoldingCopyWithImpl;
@useResult
$Res call({
 StockSite site, String onHand
});


$StockSiteCopyWith<$Res> get site;

}
/// @nodoc
class _$SiteHoldingCopyWithImpl<$Res>
    implements $SiteHoldingCopyWith<$Res> {
  _$SiteHoldingCopyWithImpl(this._self, this._then);

  final SiteHolding _self;
  final $Res Function(SiteHolding) _then;

/// Create a copy of SiteHolding
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? site = null,Object? onHand = null,}) {
  return _then(SiteHolding(
site: null == site ? _self.site : site // ignore: cast_nullable_to_non_nullable
as StockSite,onHand: null == onHand ? _self.onHand : onHand // ignore: cast_nullable_to_non_nullable
as String,
  ));
}
/// Create a copy of SiteHolding
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StockSiteCopyWith<$Res> get site {
  
  return $StockSiteCopyWith<$Res>(_self.site, (value) {
    return _then(_self.copyWith(site: value));
  });
}
}


/// Adds pattern-matching-related methods to [SiteHolding].
extension SiteHoldingPatterns on SiteHolding {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SiteHolding value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SiteHolding() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SiteHolding value)  $default,){
final _that = this;
switch (_that) {
case _SiteHolding():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SiteHolding value)?  $default,){
final _that = this;
switch (_that) {
case _SiteHolding() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( StockSite site,  String onHand)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SiteHolding() when $default != null:
return $default(_that.site,_that.onHand);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( StockSite site,  String onHand)  $default,) {final _that = this;
switch (_that) {
case _SiteHolding():
return $default(_that.site,_that.onHand);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( StockSite site,  String onHand)?  $default,) {final _that = this;
switch (_that) {
case _SiteHolding() when $default != null:
return $default(_that.site,_that.onHand);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SiteHolding implements SiteHolding {
  const _SiteHolding({required this.site, required this.onHand});
  factory _SiteHolding.fromJson(Map<String, dynamic> json) => _$SiteHoldingFromJson(json);

@override final  StockSite site;
@override final  String onHand;

/// Create a copy of SiteHolding
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SiteHoldingCopyWith<_SiteHolding> get copyWith => __$SiteHoldingCopyWithImpl<_SiteHolding>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SiteHoldingToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SiteHolding&&(identical(other.site, site) || other.site == site)&&(identical(other.onHand, onHand) || other.onHand == onHand));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,site,onHand);
}

@override
String toString() {
    return 'SiteHolding(site: $site, onHand: $onHand)';
}


}

/// @nodoc
abstract mixin class _$SiteHoldingCopyWith<$Res> implements $SiteHoldingCopyWith<$Res> {
  factory _$SiteHoldingCopyWith(_SiteHolding value, $Res Function(_SiteHolding) _then) = __$SiteHoldingCopyWithImpl;
@override @useResult
$Res call({
 StockSite site, String onHand
});


@override $StockSiteCopyWith<$Res> get site;

}
/// @nodoc
class __$SiteHoldingCopyWithImpl<$Res>
    implements _$SiteHoldingCopyWith<$Res> {
  __$SiteHoldingCopyWithImpl(this._self, this._then);

  final _SiteHolding _self;
  final $Res Function(_SiteHolding) _then;

/// Create a copy of SiteHolding
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? site = null,Object? onHand = null,}) {
  return _then(_SiteHolding(
site: null == site ? _self.site : site // ignore: cast_nullable_to_non_nullable
as StockSite,onHand: null == onHand ? _self.onHand : onHand // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

/// Create a copy of SiteHolding
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StockSiteCopyWith<$Res> get site {
  
  return $StockSiteCopyWith<$Res>(_self.site, (value) {
    return _then(_self.copyWith(site: value));
  });
}
}


/// @nodoc
mixin _$MaterialDetail {

 StockMaterial get material;/// Weighted average purchase price.
 String? get averageRate; List<GodownHolding> get godowns; List<SiteHolding> get sites; String get inGodowns; String get onSites; String get inTransit;
/// Create a copy of MaterialDetail
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MaterialDetailCopyWith<MaterialDetail> get copyWith => _$MaterialDetailCopyWithImpl<MaterialDetail>(this as MaterialDetail, _$identity);

  /// Serializes this MaterialDetail to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MaterialDetail;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MaterialDetail&&(identical(other.material, _this.material) || other.material == _this.material)&&(identical(other.averageRate, _this.averageRate) || other.averageRate == _this.averageRate)&&const DeepCollectionEquality().equals(other.godowns, _this.godowns)&&const DeepCollectionEquality().equals(other.sites, _this.sites)&&(identical(other.inGodowns, _this.inGodowns) || other.inGodowns == _this.inGodowns)&&(identical(other.onSites, _this.onSites) || other.onSites == _this.onSites)&&(identical(other.inTransit, _this.inTransit) || other.inTransit == _this.inTransit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MaterialDetail;
  return Object.hash(runtimeType,_this.material,_this.averageRate,const DeepCollectionEquality().hash(_this.godowns),const DeepCollectionEquality().hash(_this.sites),_this.inGodowns,_this.onSites,_this.inTransit);
}

@override
String toString() {
  final _this = this as MaterialDetail;
  return 'MaterialDetail(material: ${_this.material}, averageRate: ${_this.averageRate}, godowns: ${_this.godowns}, sites: ${_this.sites}, inGodowns: ${_this.inGodowns}, onSites: ${_this.onSites}, inTransit: ${_this.inTransit})';
}


}

/// @nodoc
abstract mixin class $MaterialDetailCopyWith<$Res>  {
  factory $MaterialDetailCopyWith(MaterialDetail value, $Res Function(MaterialDetail) _then) = _$MaterialDetailCopyWithImpl;
@useResult
$Res call({
 StockMaterial material, String? averageRate, List<GodownHolding> godowns, List<SiteHolding> sites, String inGodowns, String onSites, String inTransit
});


$StockMaterialCopyWith<$Res> get material;

}
/// @nodoc
class _$MaterialDetailCopyWithImpl<$Res>
    implements $MaterialDetailCopyWith<$Res> {
  _$MaterialDetailCopyWithImpl(this._self, this._then);

  final MaterialDetail _self;
  final $Res Function(MaterialDetail) _then;

/// Create a copy of MaterialDetail
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? material = null,Object? averageRate = freezed,Object? godowns = null,Object? sites = null,Object? inGodowns = null,Object? onSites = null,Object? inTransit = null,}) {
  return _then(MaterialDetail(
material: null == material ? _self.material : material // ignore: cast_nullable_to_non_nullable
as StockMaterial,averageRate: freezed == averageRate ? _self.averageRate : averageRate // ignore: cast_nullable_to_non_nullable
as String?,godowns: null == godowns ? _self.godowns : godowns // ignore: cast_nullable_to_non_nullable
as List<GodownHolding>,sites: null == sites ? _self.sites : sites // ignore: cast_nullable_to_non_nullable
as List<SiteHolding>,inGodowns: null == inGodowns ? _self.inGodowns : inGodowns // ignore: cast_nullable_to_non_nullable
as String,onSites: null == onSites ? _self.onSites : onSites // ignore: cast_nullable_to_non_nullable
as String,inTransit: null == inTransit ? _self.inTransit : inTransit // ignore: cast_nullable_to_non_nullable
as String,
  ));
}
/// Create a copy of MaterialDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StockMaterialCopyWith<$Res> get material {
  
  return $StockMaterialCopyWith<$Res>(_self.material, (value) {
    return _then(_self.copyWith(material: value));
  });
}
}


/// Adds pattern-matching-related methods to [MaterialDetail].
extension MaterialDetailPatterns on MaterialDetail {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MaterialDetail value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MaterialDetail() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MaterialDetail value)  $default,){
final _that = this;
switch (_that) {
case _MaterialDetail():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MaterialDetail value)?  $default,){
final _that = this;
switch (_that) {
case _MaterialDetail() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( StockMaterial material,  String? averageRate,  List<GodownHolding> godowns,  List<SiteHolding> sites,  String inGodowns,  String onSites,  String inTransit)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MaterialDetail() when $default != null:
return $default(_that.material,_that.averageRate,_that.godowns,_that.sites,_that.inGodowns,_that.onSites,_that.inTransit);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( StockMaterial material,  String? averageRate,  List<GodownHolding> godowns,  List<SiteHolding> sites,  String inGodowns,  String onSites,  String inTransit)  $default,) {final _that = this;
switch (_that) {
case _MaterialDetail():
return $default(_that.material,_that.averageRate,_that.godowns,_that.sites,_that.inGodowns,_that.onSites,_that.inTransit);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( StockMaterial material,  String? averageRate,  List<GodownHolding> godowns,  List<SiteHolding> sites,  String inGodowns,  String onSites,  String inTransit)?  $default,) {final _that = this;
switch (_that) {
case _MaterialDetail() when $default != null:
return $default(_that.material,_that.averageRate,_that.godowns,_that.sites,_that.inGodowns,_that.onSites,_that.inTransit);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MaterialDetail implements MaterialDetail {
  const _MaterialDetail({required this.material, this.averageRate, required  List<GodownHolding> godowns, required  List<SiteHolding> sites, required this.inGodowns, required this.onSites, required this.inTransit}): _godowns = godowns,_sites = sites;
  factory _MaterialDetail.fromJson(Map<String, dynamic> json) => _$MaterialDetailFromJson(json);

@override final  StockMaterial material;
/// Weighted average purchase price.
@override final  String? averageRate;
 final  List<GodownHolding> _godowns;
@override List<GodownHolding> get godowns {
  if (_godowns is EqualUnmodifiableListView) return _godowns;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_godowns);
}

 final  List<SiteHolding> _sites;
@override List<SiteHolding> get sites {
  if (_sites is EqualUnmodifiableListView) return _sites;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sites);
}

@override final  String inGodowns;
@override final  String onSites;
@override final  String inTransit;

/// Create a copy of MaterialDetail
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MaterialDetailCopyWith<_MaterialDetail> get copyWith => __$MaterialDetailCopyWithImpl<_MaterialDetail>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MaterialDetailToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MaterialDetail&&(identical(other.material, material) || other.material == material)&&(identical(other.averageRate, averageRate) || other.averageRate == averageRate)&&const DeepCollectionEquality().equals(other.godowns, _godowns)&&const DeepCollectionEquality().equals(other.sites, _sites)&&(identical(other.inGodowns, inGodowns) || other.inGodowns == inGodowns)&&(identical(other.onSites, onSites) || other.onSites == onSites)&&(identical(other.inTransit, inTransit) || other.inTransit == inTransit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,material,averageRate,const DeepCollectionEquality().hash(_godowns),const DeepCollectionEquality().hash(_sites),inGodowns,onSites,inTransit);
}

@override
String toString() {
    return 'MaterialDetail(material: $material, averageRate: $averageRate, godowns: $godowns, sites: $sites, inGodowns: $inGodowns, onSites: $onSites, inTransit: $inTransit)';
}


}

/// @nodoc
abstract mixin class _$MaterialDetailCopyWith<$Res> implements $MaterialDetailCopyWith<$Res> {
  factory _$MaterialDetailCopyWith(_MaterialDetail value, $Res Function(_MaterialDetail) _then) = __$MaterialDetailCopyWithImpl;
@override @useResult
$Res call({
 StockMaterial material, String? averageRate, List<GodownHolding> godowns, List<SiteHolding> sites, String inGodowns, String onSites, String inTransit
});


@override $StockMaterialCopyWith<$Res> get material;

}
/// @nodoc
class __$MaterialDetailCopyWithImpl<$Res>
    implements _$MaterialDetailCopyWith<$Res> {
  __$MaterialDetailCopyWithImpl(this._self, this._then);

  final _MaterialDetail _self;
  final $Res Function(_MaterialDetail) _then;

/// Create a copy of MaterialDetail
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? material = null,Object? averageRate = freezed,Object? godowns = null,Object? sites = null,Object? inGodowns = null,Object? onSites = null,Object? inTransit = null,}) {
  return _then(_MaterialDetail(
material: null == material ? _self.material : material // ignore: cast_nullable_to_non_nullable
as StockMaterial,averageRate: freezed == averageRate ? _self.averageRate : averageRate // ignore: cast_nullable_to_non_nullable
as String?,godowns: null == godowns ? _self._godowns : godowns // ignore: cast_nullable_to_non_nullable
as List<GodownHolding>,sites: null == sites ? _self._sites : sites // ignore: cast_nullable_to_non_nullable
as List<SiteHolding>,inGodowns: null == inGodowns ? _self.inGodowns : inGodowns // ignore: cast_nullable_to_non_nullable
as String,onSites: null == onSites ? _self.onSites : onSites // ignore: cast_nullable_to_non_nullable
as String,inTransit: null == inTransit ? _self.inTransit : inTransit // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

/// Create a copy of MaterialDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StockMaterialCopyWith<$Res> get material {
  
  return $StockMaterialCopyWith<$Res>(_self.material, (value) {
    return _then(_self.copyWith(material: value));
  });
}
}


/// @nodoc
mixin _$StockReportRow {

 StockPlace get place; SiteRef? get site; IdName? get godown; MaterialRef get material; String get opening; String get received; String get used; String get sentOut; String get wasted;/// Stock-count corrections; negative when the count came up short.
 String get adjusted; String get closing;/// Admins only: what was used, at the average purchase price.
 String? get usedValue;
/// Create a copy of StockReportRow
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StockReportRowCopyWith<StockReportRow> get copyWith => _$StockReportRowCopyWithImpl<StockReportRow>(this as StockReportRow, _$identity);

  /// Serializes this StockReportRow to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as StockReportRow;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StockReportRow&&(identical(other.place, _this.place) || other.place == _this.place)&&(identical(other.site, _this.site) || other.site == _this.site)&&(identical(other.godown, _this.godown) || other.godown == _this.godown)&&(identical(other.material, _this.material) || other.material == _this.material)&&(identical(other.opening, _this.opening) || other.opening == _this.opening)&&(identical(other.received, _this.received) || other.received == _this.received)&&(identical(other.used, _this.used) || other.used == _this.used)&&(identical(other.sentOut, _this.sentOut) || other.sentOut == _this.sentOut)&&(identical(other.wasted, _this.wasted) || other.wasted == _this.wasted)&&(identical(other.adjusted, _this.adjusted) || other.adjusted == _this.adjusted)&&(identical(other.closing, _this.closing) || other.closing == _this.closing)&&(identical(other.usedValue, _this.usedValue) || other.usedValue == _this.usedValue));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as StockReportRow;
  return Object.hash(runtimeType,_this.place,_this.site,_this.godown,_this.material,_this.opening,_this.received,_this.used,_this.sentOut,_this.wasted,_this.adjusted,_this.closing,_this.usedValue);
}

@override
String toString() {
  final _this = this as StockReportRow;
  return 'StockReportRow(place: ${_this.place}, site: ${_this.site}, godown: ${_this.godown}, material: ${_this.material}, opening: ${_this.opening}, received: ${_this.received}, used: ${_this.used}, sentOut: ${_this.sentOut}, wasted: ${_this.wasted}, adjusted: ${_this.adjusted}, closing: ${_this.closing}, usedValue: ${_this.usedValue})';
}


}

/// @nodoc
abstract mixin class $StockReportRowCopyWith<$Res>  {
  factory $StockReportRowCopyWith(StockReportRow value, $Res Function(StockReportRow) _then) = _$StockReportRowCopyWithImpl;
@useResult
$Res call({
 StockPlace place, SiteRef? site, IdName? godown, MaterialRef material, String opening, String received, String used, String sentOut, String wasted, String adjusted, String closing, String? usedValue
});


$SiteRefCopyWith<$Res>? get site;$IdNameCopyWith<$Res>? get godown;$MaterialRefCopyWith<$Res> get material;

}
/// @nodoc
class _$StockReportRowCopyWithImpl<$Res>
    implements $StockReportRowCopyWith<$Res> {
  _$StockReportRowCopyWithImpl(this._self, this._then);

  final StockReportRow _self;
  final $Res Function(StockReportRow) _then;

/// Create a copy of StockReportRow
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? place = null,Object? site = freezed,Object? godown = freezed,Object? material = null,Object? opening = null,Object? received = null,Object? used = null,Object? sentOut = null,Object? wasted = null,Object? adjusted = null,Object? closing = null,Object? usedValue = freezed,}) {
  return _then(StockReportRow(
place: null == place ? _self.place : place // ignore: cast_nullable_to_non_nullable
as StockPlace,site: freezed == site ? _self.site : site // ignore: cast_nullable_to_non_nullable
as SiteRef?,godown: freezed == godown ? _self.godown : godown // ignore: cast_nullable_to_non_nullable
as IdName?,material: null == material ? _self.material : material // ignore: cast_nullable_to_non_nullable
as MaterialRef,opening: null == opening ? _self.opening : opening // ignore: cast_nullable_to_non_nullable
as String,received: null == received ? _self.received : received // ignore: cast_nullable_to_non_nullable
as String,used: null == used ? _self.used : used // ignore: cast_nullable_to_non_nullable
as String,sentOut: null == sentOut ? _self.sentOut : sentOut // ignore: cast_nullable_to_non_nullable
as String,wasted: null == wasted ? _self.wasted : wasted // ignore: cast_nullable_to_non_nullable
as String,adjusted: null == adjusted ? _self.adjusted : adjusted // ignore: cast_nullable_to_non_nullable
as String,closing: null == closing ? _self.closing : closing // ignore: cast_nullable_to_non_nullable
as String,usedValue: freezed == usedValue ? _self.usedValue : usedValue // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of StockReportRow
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SiteRefCopyWith<$Res>? get site {
    if (_self.site == null) {
    return null;
  }

  return $SiteRefCopyWith<$Res>(_self.site!, (value) {
    return _then(_self.copyWith(site: value));
  });
}/// Create a copy of StockReportRow
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$IdNameCopyWith<$Res>? get godown {
    if (_self.godown == null) {
    return null;
  }

  return $IdNameCopyWith<$Res>(_self.godown!, (value) {
    return _then(_self.copyWith(godown: value));
  });
}/// Create a copy of StockReportRow
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MaterialRefCopyWith<$Res> get material {
  
  return $MaterialRefCopyWith<$Res>(_self.material, (value) {
    return _then(_self.copyWith(material: value));
  });
}
}


/// Adds pattern-matching-related methods to [StockReportRow].
extension StockReportRowPatterns on StockReportRow {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StockReportRow value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StockReportRow() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StockReportRow value)  $default,){
final _that = this;
switch (_that) {
case _StockReportRow():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StockReportRow value)?  $default,){
final _that = this;
switch (_that) {
case _StockReportRow() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( StockPlace place,  SiteRef? site,  IdName? godown,  MaterialRef material,  String opening,  String received,  String used,  String sentOut,  String wasted,  String adjusted,  String closing,  String? usedValue)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StockReportRow() when $default != null:
return $default(_that.place,_that.site,_that.godown,_that.material,_that.opening,_that.received,_that.used,_that.sentOut,_that.wasted,_that.adjusted,_that.closing,_that.usedValue);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( StockPlace place,  SiteRef? site,  IdName? godown,  MaterialRef material,  String opening,  String received,  String used,  String sentOut,  String wasted,  String adjusted,  String closing,  String? usedValue)  $default,) {final _that = this;
switch (_that) {
case _StockReportRow():
return $default(_that.place,_that.site,_that.godown,_that.material,_that.opening,_that.received,_that.used,_that.sentOut,_that.wasted,_that.adjusted,_that.closing,_that.usedValue);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( StockPlace place,  SiteRef? site,  IdName? godown,  MaterialRef material,  String opening,  String received,  String used,  String sentOut,  String wasted,  String adjusted,  String closing,  String? usedValue)?  $default,) {final _that = this;
switch (_that) {
case _StockReportRow() when $default != null:
return $default(_that.place,_that.site,_that.godown,_that.material,_that.opening,_that.received,_that.used,_that.sentOut,_that.wasted,_that.adjusted,_that.closing,_that.usedValue);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StockReportRow implements StockReportRow {
  const _StockReportRow({required this.place, this.site, this.godown, required this.material, required this.opening, required this.received, required this.used, required this.sentOut, required this.wasted, required this.adjusted, required this.closing, this.usedValue});
  factory _StockReportRow.fromJson(Map<String, dynamic> json) => _$StockReportRowFromJson(json);

@override final  StockPlace place;
@override final  SiteRef? site;
@override final  IdName? godown;
@override final  MaterialRef material;
@override final  String opening;
@override final  String received;
@override final  String used;
@override final  String sentOut;
@override final  String wasted;
/// Stock-count corrections; negative when the count came up short.
@override final  String adjusted;
@override final  String closing;
/// Admins only: what was used, at the average purchase price.
@override final  String? usedValue;

/// Create a copy of StockReportRow
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StockReportRowCopyWith<_StockReportRow> get copyWith => __$StockReportRowCopyWithImpl<_StockReportRow>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StockReportRowToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _StockReportRow&&(identical(other.place, place) || other.place == place)&&(identical(other.site, site) || other.site == site)&&(identical(other.godown, godown) || other.godown == godown)&&(identical(other.material, material) || other.material == material)&&(identical(other.opening, opening) || other.opening == opening)&&(identical(other.received, received) || other.received == received)&&(identical(other.used, used) || other.used == used)&&(identical(other.sentOut, sentOut) || other.sentOut == sentOut)&&(identical(other.wasted, wasted) || other.wasted == wasted)&&(identical(other.adjusted, adjusted) || other.adjusted == adjusted)&&(identical(other.closing, closing) || other.closing == closing)&&(identical(other.usedValue, usedValue) || other.usedValue == usedValue));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,place,site,godown,material,opening,received,used,sentOut,wasted,adjusted,closing,usedValue);
}

@override
String toString() {
    return 'StockReportRow(place: $place, site: $site, godown: $godown, material: $material, opening: $opening, received: $received, used: $used, sentOut: $sentOut, wasted: $wasted, adjusted: $adjusted, closing: $closing, usedValue: $usedValue)';
}


}

/// @nodoc
abstract mixin class _$StockReportRowCopyWith<$Res> implements $StockReportRowCopyWith<$Res> {
  factory _$StockReportRowCopyWith(_StockReportRow value, $Res Function(_StockReportRow) _then) = __$StockReportRowCopyWithImpl;
@override @useResult
$Res call({
 StockPlace place, SiteRef? site, IdName? godown, MaterialRef material, String opening, String received, String used, String sentOut, String wasted, String adjusted, String closing, String? usedValue
});


@override $SiteRefCopyWith<$Res>? get site;@override $IdNameCopyWith<$Res>? get godown;@override $MaterialRefCopyWith<$Res> get material;

}
/// @nodoc
class __$StockReportRowCopyWithImpl<$Res>
    implements _$StockReportRowCopyWith<$Res> {
  __$StockReportRowCopyWithImpl(this._self, this._then);

  final _StockReportRow _self;
  final $Res Function(_StockReportRow) _then;

/// Create a copy of StockReportRow
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? place = null,Object? site = freezed,Object? godown = freezed,Object? material = null,Object? opening = null,Object? received = null,Object? used = null,Object? sentOut = null,Object? wasted = null,Object? adjusted = null,Object? closing = null,Object? usedValue = freezed,}) {
  return _then(_StockReportRow(
place: null == place ? _self.place : place // ignore: cast_nullable_to_non_nullable
as StockPlace,site: freezed == site ? _self.site : site // ignore: cast_nullable_to_non_nullable
as SiteRef?,godown: freezed == godown ? _self.godown : godown // ignore: cast_nullable_to_non_nullable
as IdName?,material: null == material ? _self.material : material // ignore: cast_nullable_to_non_nullable
as MaterialRef,opening: null == opening ? _self.opening : opening // ignore: cast_nullable_to_non_nullable
as String,received: null == received ? _self.received : received // ignore: cast_nullable_to_non_nullable
as String,used: null == used ? _self.used : used // ignore: cast_nullable_to_non_nullable
as String,sentOut: null == sentOut ? _self.sentOut : sentOut // ignore: cast_nullable_to_non_nullable
as String,wasted: null == wasted ? _self.wasted : wasted // ignore: cast_nullable_to_non_nullable
as String,adjusted: null == adjusted ? _self.adjusted : adjusted // ignore: cast_nullable_to_non_nullable
as String,closing: null == closing ? _self.closing : closing // ignore: cast_nullable_to_non_nullable
as String,usedValue: freezed == usedValue ? _self.usedValue : usedValue // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of StockReportRow
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SiteRefCopyWith<$Res>? get site {
    if (_self.site == null) {
    return null;
  }

  return $SiteRefCopyWith<$Res>(_self.site!, (value) {
    return _then(_self.copyWith(site: value));
  });
}/// Create a copy of StockReportRow
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$IdNameCopyWith<$Res>? get godown {
    if (_self.godown == null) {
    return null;
  }

  return $IdNameCopyWith<$Res>(_self.godown!, (value) {
    return _then(_self.copyWith(godown: value));
  });
}/// Create a copy of StockReportRow
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MaterialRefCopyWith<$Res> get material {
  
  return $MaterialRefCopyWith<$Res>(_self.material, (value) {
    return _then(_self.copyWith(material: value));
  });
}
}


/// @nodoc
mixin _$MaterialRequestLine {

 MaterialRef get material; String get quantity;/// Set once approved; "0" when it won't be supplied.
 String? get approvedQuantity; String get sent; String get received; String get onTheWay; String? get leftToSend;
/// Create a copy of MaterialRequestLine
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MaterialRequestLineCopyWith<MaterialRequestLine> get copyWith => _$MaterialRequestLineCopyWithImpl<MaterialRequestLine>(this as MaterialRequestLine, _$identity);

  /// Serializes this MaterialRequestLine to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MaterialRequestLine;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MaterialRequestLine&&(identical(other.material, _this.material) || other.material == _this.material)&&(identical(other.quantity, _this.quantity) || other.quantity == _this.quantity)&&(identical(other.approvedQuantity, _this.approvedQuantity) || other.approvedQuantity == _this.approvedQuantity)&&(identical(other.sent, _this.sent) || other.sent == _this.sent)&&(identical(other.received, _this.received) || other.received == _this.received)&&(identical(other.onTheWay, _this.onTheWay) || other.onTheWay == _this.onTheWay)&&(identical(other.leftToSend, _this.leftToSend) || other.leftToSend == _this.leftToSend));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MaterialRequestLine;
  return Object.hash(runtimeType,_this.material,_this.quantity,_this.approvedQuantity,_this.sent,_this.received,_this.onTheWay,_this.leftToSend);
}

@override
String toString() {
  final _this = this as MaterialRequestLine;
  return 'MaterialRequestLine(material: ${_this.material}, quantity: ${_this.quantity}, approvedQuantity: ${_this.approvedQuantity}, sent: ${_this.sent}, received: ${_this.received}, onTheWay: ${_this.onTheWay}, leftToSend: ${_this.leftToSend})';
}


}

/// @nodoc
abstract mixin class $MaterialRequestLineCopyWith<$Res>  {
  factory $MaterialRequestLineCopyWith(MaterialRequestLine value, $Res Function(MaterialRequestLine) _then) = _$MaterialRequestLineCopyWithImpl;
@useResult
$Res call({
 MaterialRef material, String quantity, String? approvedQuantity, String sent, String received, String onTheWay, String? leftToSend
});


$MaterialRefCopyWith<$Res> get material;

}
/// @nodoc
class _$MaterialRequestLineCopyWithImpl<$Res>
    implements $MaterialRequestLineCopyWith<$Res> {
  _$MaterialRequestLineCopyWithImpl(this._self, this._then);

  final MaterialRequestLine _self;
  final $Res Function(MaterialRequestLine) _then;

/// Create a copy of MaterialRequestLine
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? material = null,Object? quantity = null,Object? approvedQuantity = freezed,Object? sent = null,Object? received = null,Object? onTheWay = null,Object? leftToSend = freezed,}) {
  return _then(MaterialRequestLine(
material: null == material ? _self.material : material // ignore: cast_nullable_to_non_nullable
as MaterialRef,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as String,approvedQuantity: freezed == approvedQuantity ? _self.approvedQuantity : approvedQuantity // ignore: cast_nullable_to_non_nullable
as String?,sent: null == sent ? _self.sent : sent // ignore: cast_nullable_to_non_nullable
as String,received: null == received ? _self.received : received // ignore: cast_nullable_to_non_nullable
as String,onTheWay: null == onTheWay ? _self.onTheWay : onTheWay // ignore: cast_nullable_to_non_nullable
as String,leftToSend: freezed == leftToSend ? _self.leftToSend : leftToSend // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of MaterialRequestLine
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MaterialRefCopyWith<$Res> get material {
  
  return $MaterialRefCopyWith<$Res>(_self.material, (value) {
    return _then(_self.copyWith(material: value));
  });
}
}


/// Adds pattern-matching-related methods to [MaterialRequestLine].
extension MaterialRequestLinePatterns on MaterialRequestLine {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MaterialRequestLine value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MaterialRequestLine() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MaterialRequestLine value)  $default,){
final _that = this;
switch (_that) {
case _MaterialRequestLine():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MaterialRequestLine value)?  $default,){
final _that = this;
switch (_that) {
case _MaterialRequestLine() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( MaterialRef material,  String quantity,  String? approvedQuantity,  String sent,  String received,  String onTheWay,  String? leftToSend)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MaterialRequestLine() when $default != null:
return $default(_that.material,_that.quantity,_that.approvedQuantity,_that.sent,_that.received,_that.onTheWay,_that.leftToSend);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( MaterialRef material,  String quantity,  String? approvedQuantity,  String sent,  String received,  String onTheWay,  String? leftToSend)  $default,) {final _that = this;
switch (_that) {
case _MaterialRequestLine():
return $default(_that.material,_that.quantity,_that.approvedQuantity,_that.sent,_that.received,_that.onTheWay,_that.leftToSend);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( MaterialRef material,  String quantity,  String? approvedQuantity,  String sent,  String received,  String onTheWay,  String? leftToSend)?  $default,) {final _that = this;
switch (_that) {
case _MaterialRequestLine() when $default != null:
return $default(_that.material,_that.quantity,_that.approvedQuantity,_that.sent,_that.received,_that.onTheWay,_that.leftToSend);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MaterialRequestLine extends MaterialRequestLine {
  const _MaterialRequestLine({required this.material, required this.quantity, this.approvedQuantity, required this.sent, required this.received, required this.onTheWay, this.leftToSend}): super._();
  factory _MaterialRequestLine.fromJson(Map<String, dynamic> json) => _$MaterialRequestLineFromJson(json);

@override final  MaterialRef material;
@override final  String quantity;
/// Set once approved; "0" when it won't be supplied.
@override final  String? approvedQuantity;
@override final  String sent;
@override final  String received;
@override final  String onTheWay;
@override final  String? leftToSend;

/// Create a copy of MaterialRequestLine
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MaterialRequestLineCopyWith<_MaterialRequestLine> get copyWith => __$MaterialRequestLineCopyWithImpl<_MaterialRequestLine>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MaterialRequestLineToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MaterialRequestLine&&(identical(other.material, material) || other.material == material)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.approvedQuantity, approvedQuantity) || other.approvedQuantity == approvedQuantity)&&(identical(other.sent, sent) || other.sent == sent)&&(identical(other.received, received) || other.received == received)&&(identical(other.onTheWay, onTheWay) || other.onTheWay == onTheWay)&&(identical(other.leftToSend, leftToSend) || other.leftToSend == leftToSend));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,material,quantity,approvedQuantity,sent,received,onTheWay,leftToSend);
}

@override
String toString() {
    return 'MaterialRequestLine(material: $material, quantity: $quantity, approvedQuantity: $approvedQuantity, sent: $sent, received: $received, onTheWay: $onTheWay, leftToSend: $leftToSend)';
}


}

/// @nodoc
abstract mixin class _$MaterialRequestLineCopyWith<$Res> implements $MaterialRequestLineCopyWith<$Res> {
  factory _$MaterialRequestLineCopyWith(_MaterialRequestLine value, $Res Function(_MaterialRequestLine) _then) = __$MaterialRequestLineCopyWithImpl;
@override @useResult
$Res call({
 MaterialRef material, String quantity, String? approvedQuantity, String sent, String received, String onTheWay, String? leftToSend
});


@override $MaterialRefCopyWith<$Res> get material;

}
/// @nodoc
class __$MaterialRequestLineCopyWithImpl<$Res>
    implements _$MaterialRequestLineCopyWith<$Res> {
  __$MaterialRequestLineCopyWithImpl(this._self, this._then);

  final _MaterialRequestLine _self;
  final $Res Function(_MaterialRequestLine) _then;

/// Create a copy of MaterialRequestLine
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? material = null,Object? quantity = null,Object? approvedQuantity = freezed,Object? sent = null,Object? received = null,Object? onTheWay = null,Object? leftToSend = freezed,}) {
  return _then(_MaterialRequestLine(
material: null == material ? _self.material : material // ignore: cast_nullable_to_non_nullable
as MaterialRef,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as String,approvedQuantity: freezed == approvedQuantity ? _self.approvedQuantity : approvedQuantity // ignore: cast_nullable_to_non_nullable
as String?,sent: null == sent ? _self.sent : sent // ignore: cast_nullable_to_non_nullable
as String,received: null == received ? _self.received : received // ignore: cast_nullable_to_non_nullable
as String,onTheWay: null == onTheWay ? _self.onTheWay : onTheWay // ignore: cast_nullable_to_non_nullable
as String,leftToSend: freezed == leftToSend ? _self.leftToSend : leftToSend // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of MaterialRequestLine
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MaterialRefCopyWith<$Res> get material {
  
  return $MaterialRefCopyWith<$Res>(_self.material, (value) {
    return _then(_self.copyWith(material: value));
  });
}
}


/// @nodoc
mixin _$MaterialRequest {

 String get id;/// "MR-0012"
 String get code; SiteRef get site; IdName get requestedBy; MaterialRequestStatus get status; String? get neededBy; String? get note; DateTime get createdAt; IdName? get godown; IdName? get reviewedBy; DateTime? get reviewedAt; String? get reviewNote; MaterialRequestOutcome? get outcome; IdName? get closedBy; DateTime? get closedAt; String? get closeNote; List<MaterialRequestLine> get lines; bool get sentInFull;/// Detail responses only: deliveries and returns made against it.
 List<StockEntry> get entries;/// What the signed-in user may do with it now (the server decides).
 bool get canApprove; bool get canCancel; bool get canSend; bool get canClose;
/// Create a copy of MaterialRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MaterialRequestCopyWith<MaterialRequest> get copyWith => _$MaterialRequestCopyWithImpl<MaterialRequest>(this as MaterialRequest, _$identity);

  /// Serializes this MaterialRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MaterialRequest;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MaterialRequest&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.code, _this.code) || other.code == _this.code)&&(identical(other.site, _this.site) || other.site == _this.site)&&(identical(other.requestedBy, _this.requestedBy) || other.requestedBy == _this.requestedBy)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.neededBy, _this.neededBy) || other.neededBy == _this.neededBy)&&(identical(other.note, _this.note) || other.note == _this.note)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.godown, _this.godown) || other.godown == _this.godown)&&(identical(other.reviewedBy, _this.reviewedBy) || other.reviewedBy == _this.reviewedBy)&&(identical(other.reviewedAt, _this.reviewedAt) || other.reviewedAt == _this.reviewedAt)&&(identical(other.reviewNote, _this.reviewNote) || other.reviewNote == _this.reviewNote)&&(identical(other.outcome, _this.outcome) || other.outcome == _this.outcome)&&(identical(other.closedBy, _this.closedBy) || other.closedBy == _this.closedBy)&&(identical(other.closedAt, _this.closedAt) || other.closedAt == _this.closedAt)&&(identical(other.closeNote, _this.closeNote) || other.closeNote == _this.closeNote)&&const DeepCollectionEquality().equals(other.lines, _this.lines)&&(identical(other.sentInFull, _this.sentInFull) || other.sentInFull == _this.sentInFull)&&const DeepCollectionEquality().equals(other.entries, _this.entries)&&(identical(other.canApprove, _this.canApprove) || other.canApprove == _this.canApprove)&&(identical(other.canCancel, _this.canCancel) || other.canCancel == _this.canCancel)&&(identical(other.canSend, _this.canSend) || other.canSend == _this.canSend)&&(identical(other.canClose, _this.canClose) || other.canClose == _this.canClose));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MaterialRequest;
  return Object.hashAll([runtimeType,_this.id,_this.code,_this.site,_this.requestedBy,_this.status,_this.neededBy,_this.note,_this.createdAt,_this.godown,_this.reviewedBy,_this.reviewedAt,_this.reviewNote,_this.outcome,_this.closedBy,_this.closedAt,_this.closeNote,const DeepCollectionEquality().hash(_this.lines),_this.sentInFull,const DeepCollectionEquality().hash(_this.entries),_this.canApprove,_this.canCancel,_this.canSend,_this.canClose]);
}

@override
String toString() {
  final _this = this as MaterialRequest;
  return 'MaterialRequest(id: ${_this.id}, code: ${_this.code}, site: ${_this.site}, requestedBy: ${_this.requestedBy}, status: ${_this.status}, neededBy: ${_this.neededBy}, note: ${_this.note}, createdAt: ${_this.createdAt}, godown: ${_this.godown}, reviewedBy: ${_this.reviewedBy}, reviewedAt: ${_this.reviewedAt}, reviewNote: ${_this.reviewNote}, outcome: ${_this.outcome}, closedBy: ${_this.closedBy}, closedAt: ${_this.closedAt}, closeNote: ${_this.closeNote}, lines: ${_this.lines}, sentInFull: ${_this.sentInFull}, entries: ${_this.entries}, canApprove: ${_this.canApprove}, canCancel: ${_this.canCancel}, canSend: ${_this.canSend}, canClose: ${_this.canClose})';
}


}

/// @nodoc
abstract mixin class $MaterialRequestCopyWith<$Res>  {
  factory $MaterialRequestCopyWith(MaterialRequest value, $Res Function(MaterialRequest) _then) = _$MaterialRequestCopyWithImpl;
@useResult
$Res call({
 String id, String code, SiteRef site, IdName requestedBy, MaterialRequestStatus status, String? neededBy, String? note, DateTime createdAt, IdName? godown, IdName? reviewedBy, DateTime? reviewedAt, String? reviewNote, MaterialRequestOutcome? outcome, IdName? closedBy, DateTime? closedAt, String? closeNote, List<MaterialRequestLine> lines, bool sentInFull, List<StockEntry> entries, bool canApprove, bool canCancel, bool canSend, bool canClose
});


$SiteRefCopyWith<$Res> get site;$IdNameCopyWith<$Res> get requestedBy;$IdNameCopyWith<$Res>? get godown;$IdNameCopyWith<$Res>? get reviewedBy;$IdNameCopyWith<$Res>? get closedBy;

}
/// @nodoc
class _$MaterialRequestCopyWithImpl<$Res>
    implements $MaterialRequestCopyWith<$Res> {
  _$MaterialRequestCopyWithImpl(this._self, this._then);

  final MaterialRequest _self;
  final $Res Function(MaterialRequest) _then;

/// Create a copy of MaterialRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? code = null,Object? site = null,Object? requestedBy = null,Object? status = null,Object? neededBy = freezed,Object? note = freezed,Object? createdAt = null,Object? godown = freezed,Object? reviewedBy = freezed,Object? reviewedAt = freezed,Object? reviewNote = freezed,Object? outcome = freezed,Object? closedBy = freezed,Object? closedAt = freezed,Object? closeNote = freezed,Object? lines = null,Object? sentInFull = null,Object? entries = null,Object? canApprove = null,Object? canCancel = null,Object? canSend = null,Object? canClose = null,}) {
  return _then(MaterialRequest(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,site: null == site ? _self.site : site // ignore: cast_nullable_to_non_nullable
as SiteRef,requestedBy: null == requestedBy ? _self.requestedBy : requestedBy // ignore: cast_nullable_to_non_nullable
as IdName,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as MaterialRequestStatus,neededBy: freezed == neededBy ? _self.neededBy : neededBy // ignore: cast_nullable_to_non_nullable
as String?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,godown: freezed == godown ? _self.godown : godown // ignore: cast_nullable_to_non_nullable
as IdName?,reviewedBy: freezed == reviewedBy ? _self.reviewedBy : reviewedBy // ignore: cast_nullable_to_non_nullable
as IdName?,reviewedAt: freezed == reviewedAt ? _self.reviewedAt : reviewedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,reviewNote: freezed == reviewNote ? _self.reviewNote : reviewNote // ignore: cast_nullable_to_non_nullable
as String?,outcome: freezed == outcome ? _self.outcome : outcome // ignore: cast_nullable_to_non_nullable
as MaterialRequestOutcome?,closedBy: freezed == closedBy ? _self.closedBy : closedBy // ignore: cast_nullable_to_non_nullable
as IdName?,closedAt: freezed == closedAt ? _self.closedAt : closedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,closeNote: freezed == closeNote ? _self.closeNote : closeNote // ignore: cast_nullable_to_non_nullable
as String?,lines: null == lines ? _self.lines : lines // ignore: cast_nullable_to_non_nullable
as List<MaterialRequestLine>,sentInFull: null == sentInFull ? _self.sentInFull : sentInFull // ignore: cast_nullable_to_non_nullable
as bool,entries: null == entries ? _self.entries : entries // ignore: cast_nullable_to_non_nullable
as List<StockEntry>,canApprove: null == canApprove ? _self.canApprove : canApprove // ignore: cast_nullable_to_non_nullable
as bool,canCancel: null == canCancel ? _self.canCancel : canCancel // ignore: cast_nullable_to_non_nullable
as bool,canSend: null == canSend ? _self.canSend : canSend // ignore: cast_nullable_to_non_nullable
as bool,canClose: null == canClose ? _self.canClose : canClose // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of MaterialRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SiteRefCopyWith<$Res> get site {
  
  return $SiteRefCopyWith<$Res>(_self.site, (value) {
    return _then(_self.copyWith(site: value));
  });
}/// Create a copy of MaterialRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$IdNameCopyWith<$Res> get requestedBy {
  
  return $IdNameCopyWith<$Res>(_self.requestedBy, (value) {
    return _then(_self.copyWith(requestedBy: value));
  });
}/// Create a copy of MaterialRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$IdNameCopyWith<$Res>? get godown {
    if (_self.godown == null) {
    return null;
  }

  return $IdNameCopyWith<$Res>(_self.godown!, (value) {
    return _then(_self.copyWith(godown: value));
  });
}/// Create a copy of MaterialRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$IdNameCopyWith<$Res>? get reviewedBy {
    if (_self.reviewedBy == null) {
    return null;
  }

  return $IdNameCopyWith<$Res>(_self.reviewedBy!, (value) {
    return _then(_self.copyWith(reviewedBy: value));
  });
}/// Create a copy of MaterialRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$IdNameCopyWith<$Res>? get closedBy {
    if (_self.closedBy == null) {
    return null;
  }

  return $IdNameCopyWith<$Res>(_self.closedBy!, (value) {
    return _then(_self.copyWith(closedBy: value));
  });
}
}


/// Adds pattern-matching-related methods to [MaterialRequest].
extension MaterialRequestPatterns on MaterialRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MaterialRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MaterialRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MaterialRequest value)  $default,){
final _that = this;
switch (_that) {
case _MaterialRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MaterialRequest value)?  $default,){
final _that = this;
switch (_that) {
case _MaterialRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String code,  SiteRef site,  IdName requestedBy,  MaterialRequestStatus status,  String? neededBy,  String? note,  DateTime createdAt,  IdName? godown,  IdName? reviewedBy,  DateTime? reviewedAt,  String? reviewNote,  MaterialRequestOutcome? outcome,  IdName? closedBy,  DateTime? closedAt,  String? closeNote,  List<MaterialRequestLine> lines,  bool sentInFull,  List<StockEntry> entries,  bool canApprove,  bool canCancel,  bool canSend,  bool canClose)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MaterialRequest() when $default != null:
return $default(_that.id,_that.code,_that.site,_that.requestedBy,_that.status,_that.neededBy,_that.note,_that.createdAt,_that.godown,_that.reviewedBy,_that.reviewedAt,_that.reviewNote,_that.outcome,_that.closedBy,_that.closedAt,_that.closeNote,_that.lines,_that.sentInFull,_that.entries,_that.canApprove,_that.canCancel,_that.canSend,_that.canClose);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String code,  SiteRef site,  IdName requestedBy,  MaterialRequestStatus status,  String? neededBy,  String? note,  DateTime createdAt,  IdName? godown,  IdName? reviewedBy,  DateTime? reviewedAt,  String? reviewNote,  MaterialRequestOutcome? outcome,  IdName? closedBy,  DateTime? closedAt,  String? closeNote,  List<MaterialRequestLine> lines,  bool sentInFull,  List<StockEntry> entries,  bool canApprove,  bool canCancel,  bool canSend,  bool canClose)  $default,) {final _that = this;
switch (_that) {
case _MaterialRequest():
return $default(_that.id,_that.code,_that.site,_that.requestedBy,_that.status,_that.neededBy,_that.note,_that.createdAt,_that.godown,_that.reviewedBy,_that.reviewedAt,_that.reviewNote,_that.outcome,_that.closedBy,_that.closedAt,_that.closeNote,_that.lines,_that.sentInFull,_that.entries,_that.canApprove,_that.canCancel,_that.canSend,_that.canClose);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String code,  SiteRef site,  IdName requestedBy,  MaterialRequestStatus status,  String? neededBy,  String? note,  DateTime createdAt,  IdName? godown,  IdName? reviewedBy,  DateTime? reviewedAt,  String? reviewNote,  MaterialRequestOutcome? outcome,  IdName? closedBy,  DateTime? closedAt,  String? closeNote,  List<MaterialRequestLine> lines,  bool sentInFull,  List<StockEntry> entries,  bool canApprove,  bool canCancel,  bool canSend,  bool canClose)?  $default,) {final _that = this;
switch (_that) {
case _MaterialRequest() when $default != null:
return $default(_that.id,_that.code,_that.site,_that.requestedBy,_that.status,_that.neededBy,_that.note,_that.createdAt,_that.godown,_that.reviewedBy,_that.reviewedAt,_that.reviewNote,_that.outcome,_that.closedBy,_that.closedAt,_that.closeNote,_that.lines,_that.sentInFull,_that.entries,_that.canApprove,_that.canCancel,_that.canSend,_that.canClose);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MaterialRequest extends MaterialRequest {
  const _MaterialRequest({required this.id, required this.code, required this.site, required this.requestedBy, required this.status, this.neededBy, this.note, required this.createdAt, this.godown, this.reviewedBy, this.reviewedAt, this.reviewNote, this.outcome, this.closedBy, this.closedAt, this.closeNote, required  List<MaterialRequestLine> lines, this.sentInFull = false,  List<StockEntry> entries = const <StockEntry>[], this.canApprove = false, this.canCancel = false, this.canSend = false, this.canClose = false}): _lines = lines,_entries = entries,super._();
  factory _MaterialRequest.fromJson(Map<String, dynamic> json) => _$MaterialRequestFromJson(json);

@override final  String id;
/// "MR-0012"
@override final  String code;
@override final  SiteRef site;
@override final  IdName requestedBy;
@override final  MaterialRequestStatus status;
@override final  String? neededBy;
@override final  String? note;
@override final  DateTime createdAt;
@override final  IdName? godown;
@override final  IdName? reviewedBy;
@override final  DateTime? reviewedAt;
@override final  String? reviewNote;
@override final  MaterialRequestOutcome? outcome;
@override final  IdName? closedBy;
@override final  DateTime? closedAt;
@override final  String? closeNote;
 final  List<MaterialRequestLine> _lines;
@override List<MaterialRequestLine> get lines {
  if (_lines is EqualUnmodifiableListView) return _lines;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_lines);
}

@override@JsonKey() final  bool sentInFull;
/// Detail responses only: deliveries and returns made against it.
 final  List<StockEntry> _entries;
/// Detail responses only: deliveries and returns made against it.
@override@JsonKey() List<StockEntry> get entries {
  if (_entries is EqualUnmodifiableListView) return _entries;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_entries);
}

/// What the signed-in user may do with it now (the server decides).
@override@JsonKey() final  bool canApprove;
@override@JsonKey() final  bool canCancel;
@override@JsonKey() final  bool canSend;
@override@JsonKey() final  bool canClose;

/// Create a copy of MaterialRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MaterialRequestCopyWith<_MaterialRequest> get copyWith => __$MaterialRequestCopyWithImpl<_MaterialRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MaterialRequestToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MaterialRequest&&(identical(other.id, id) || other.id == id)&&(identical(other.code, code) || other.code == code)&&(identical(other.site, site) || other.site == site)&&(identical(other.requestedBy, requestedBy) || other.requestedBy == requestedBy)&&(identical(other.status, status) || other.status == status)&&(identical(other.neededBy, neededBy) || other.neededBy == neededBy)&&(identical(other.note, note) || other.note == note)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.godown, godown) || other.godown == godown)&&(identical(other.reviewedBy, reviewedBy) || other.reviewedBy == reviewedBy)&&(identical(other.reviewedAt, reviewedAt) || other.reviewedAt == reviewedAt)&&(identical(other.reviewNote, reviewNote) || other.reviewNote == reviewNote)&&(identical(other.outcome, outcome) || other.outcome == outcome)&&(identical(other.closedBy, closedBy) || other.closedBy == closedBy)&&(identical(other.closedAt, closedAt) || other.closedAt == closedAt)&&(identical(other.closeNote, closeNote) || other.closeNote == closeNote)&&const DeepCollectionEquality().equals(other.lines, _lines)&&(identical(other.sentInFull, sentInFull) || other.sentInFull == sentInFull)&&const DeepCollectionEquality().equals(other.entries, _entries)&&(identical(other.canApprove, canApprove) || other.canApprove == canApprove)&&(identical(other.canCancel, canCancel) || other.canCancel == canCancel)&&(identical(other.canSend, canSend) || other.canSend == canSend)&&(identical(other.canClose, canClose) || other.canClose == canClose));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hashAll([runtimeType,id,code,site,requestedBy,status,neededBy,note,createdAt,godown,reviewedBy,reviewedAt,reviewNote,outcome,closedBy,closedAt,closeNote,const DeepCollectionEquality().hash(_lines),sentInFull,const DeepCollectionEquality().hash(_entries),canApprove,canCancel,canSend,canClose]);
}

@override
String toString() {
    return 'MaterialRequest(id: $id, code: $code, site: $site, requestedBy: $requestedBy, status: $status, neededBy: $neededBy, note: $note, createdAt: $createdAt, godown: $godown, reviewedBy: $reviewedBy, reviewedAt: $reviewedAt, reviewNote: $reviewNote, outcome: $outcome, closedBy: $closedBy, closedAt: $closedAt, closeNote: $closeNote, lines: $lines, sentInFull: $sentInFull, entries: $entries, canApprove: $canApprove, canCancel: $canCancel, canSend: $canSend, canClose: $canClose)';
}


}

/// @nodoc
abstract mixin class _$MaterialRequestCopyWith<$Res> implements $MaterialRequestCopyWith<$Res> {
  factory _$MaterialRequestCopyWith(_MaterialRequest value, $Res Function(_MaterialRequest) _then) = __$MaterialRequestCopyWithImpl;
@override @useResult
$Res call({
 String id, String code, SiteRef site, IdName requestedBy, MaterialRequestStatus status, String? neededBy, String? note, DateTime createdAt, IdName? godown, IdName? reviewedBy, DateTime? reviewedAt, String? reviewNote, MaterialRequestOutcome? outcome, IdName? closedBy, DateTime? closedAt, String? closeNote, List<MaterialRequestLine> lines, bool sentInFull, List<StockEntry> entries, bool canApprove, bool canCancel, bool canSend, bool canClose
});


@override $SiteRefCopyWith<$Res> get site;@override $IdNameCopyWith<$Res> get requestedBy;@override $IdNameCopyWith<$Res>? get godown;@override $IdNameCopyWith<$Res>? get reviewedBy;@override $IdNameCopyWith<$Res>? get closedBy;

}
/// @nodoc
class __$MaterialRequestCopyWithImpl<$Res>
    implements _$MaterialRequestCopyWith<$Res> {
  __$MaterialRequestCopyWithImpl(this._self, this._then);

  final _MaterialRequest _self;
  final $Res Function(_MaterialRequest) _then;

/// Create a copy of MaterialRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? code = null,Object? site = null,Object? requestedBy = null,Object? status = null,Object? neededBy = freezed,Object? note = freezed,Object? createdAt = null,Object? godown = freezed,Object? reviewedBy = freezed,Object? reviewedAt = freezed,Object? reviewNote = freezed,Object? outcome = freezed,Object? closedBy = freezed,Object? closedAt = freezed,Object? closeNote = freezed,Object? lines = null,Object? sentInFull = null,Object? entries = null,Object? canApprove = null,Object? canCancel = null,Object? canSend = null,Object? canClose = null,}) {
  return _then(_MaterialRequest(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,site: null == site ? _self.site : site // ignore: cast_nullable_to_non_nullable
as SiteRef,requestedBy: null == requestedBy ? _self.requestedBy : requestedBy // ignore: cast_nullable_to_non_nullable
as IdName,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as MaterialRequestStatus,neededBy: freezed == neededBy ? _self.neededBy : neededBy // ignore: cast_nullable_to_non_nullable
as String?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,godown: freezed == godown ? _self.godown : godown // ignore: cast_nullable_to_non_nullable
as IdName?,reviewedBy: freezed == reviewedBy ? _self.reviewedBy : reviewedBy // ignore: cast_nullable_to_non_nullable
as IdName?,reviewedAt: freezed == reviewedAt ? _self.reviewedAt : reviewedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,reviewNote: freezed == reviewNote ? _self.reviewNote : reviewNote // ignore: cast_nullable_to_non_nullable
as String?,outcome: freezed == outcome ? _self.outcome : outcome // ignore: cast_nullable_to_non_nullable
as MaterialRequestOutcome?,closedBy: freezed == closedBy ? _self.closedBy : closedBy // ignore: cast_nullable_to_non_nullable
as IdName?,closedAt: freezed == closedAt ? _self.closedAt : closedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,closeNote: freezed == closeNote ? _self.closeNote : closeNote // ignore: cast_nullable_to_non_nullable
as String?,lines: null == lines ? _self._lines : lines // ignore: cast_nullable_to_non_nullable
as List<MaterialRequestLine>,sentInFull: null == sentInFull ? _self.sentInFull : sentInFull // ignore: cast_nullable_to_non_nullable
as bool,entries: null == entries ? _self._entries : entries // ignore: cast_nullable_to_non_nullable
as List<StockEntry>,canApprove: null == canApprove ? _self.canApprove : canApprove // ignore: cast_nullable_to_non_nullable
as bool,canCancel: null == canCancel ? _self.canCancel : canCancel // ignore: cast_nullable_to_non_nullable
as bool,canSend: null == canSend ? _self.canSend : canSend // ignore: cast_nullable_to_non_nullable
as bool,canClose: null == canClose ? _self.canClose : canClose // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of MaterialRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SiteRefCopyWith<$Res> get site {
  
  return $SiteRefCopyWith<$Res>(_self.site, (value) {
    return _then(_self.copyWith(site: value));
  });
}/// Create a copy of MaterialRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$IdNameCopyWith<$Res> get requestedBy {
  
  return $IdNameCopyWith<$Res>(_self.requestedBy, (value) {
    return _then(_self.copyWith(requestedBy: value));
  });
}/// Create a copy of MaterialRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$IdNameCopyWith<$Res>? get godown {
    if (_self.godown == null) {
    return null;
  }

  return $IdNameCopyWith<$Res>(_self.godown!, (value) {
    return _then(_self.copyWith(godown: value));
  });
}/// Create a copy of MaterialRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$IdNameCopyWith<$Res>? get reviewedBy {
    if (_self.reviewedBy == null) {
    return null;
  }

  return $IdNameCopyWith<$Res>(_self.reviewedBy!, (value) {
    return _then(_self.copyWith(reviewedBy: value));
  });
}/// Create a copy of MaterialRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$IdNameCopyWith<$Res>? get closedBy {
    if (_self.closedBy == null) {
    return null;
  }

  return $IdNameCopyWith<$Res>(_self.closedBy!, (value) {
    return _then(_self.copyWith(closedBy: value));
  });
}
}

// dart format on
