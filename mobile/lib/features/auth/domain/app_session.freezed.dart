// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_session.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AppSession {

@JsonKey(name: 'id') String get userId; String get name; UserRole get role; bool get mustChangePassword;
/// Create a copy of AppSession
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppSessionCopyWith<AppSession> get copyWith => _$AppSessionCopyWithImpl<AppSession>(this as AppSession, _$identity);

  /// Serializes this AppSession to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AppSession;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppSession&&(identical(other.userId, _this.userId) || other.userId == _this.userId)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.role, _this.role) || other.role == _this.role)&&(identical(other.mustChangePassword, _this.mustChangePassword) || other.mustChangePassword == _this.mustChangePassword));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AppSession;
  return Object.hash(runtimeType,_this.userId,_this.name,_this.role,_this.mustChangePassword);
}

@override
String toString() {
  final _this = this as AppSession;
  return 'AppSession(userId: ${_this.userId}, name: ${_this.name}, role: ${_this.role}, mustChangePassword: ${_this.mustChangePassword})';
}


}

/// @nodoc
abstract mixin class $AppSessionCopyWith<$Res>  {
  factory $AppSessionCopyWith(AppSession value, $Res Function(AppSession) _then) = _$AppSessionCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'id') String userId, String name, UserRole role, bool mustChangePassword
});




}
/// @nodoc
class _$AppSessionCopyWithImpl<$Res>
    implements $AppSessionCopyWith<$Res> {
  _$AppSessionCopyWithImpl(this._self, this._then);

  final AppSession _self;
  final $Res Function(AppSession) _then;

/// Create a copy of AppSession
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? name = null,Object? role = null,Object? mustChangePassword = null,}) {
  return _then(AppSession(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as UserRole,mustChangePassword: null == mustChangePassword ? _self.mustChangePassword : mustChangePassword // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [AppSession].
extension AppSessionPatterns on AppSession {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppSession value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppSession() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppSession value)  $default,){
final _that = this;
switch (_that) {
case _AppSession():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppSession value)?  $default,){
final _that = this;
switch (_that) {
case _AppSession() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'id')  String userId,  String name,  UserRole role,  bool mustChangePassword)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppSession() when $default != null:
return $default(_that.userId,_that.name,_that.role,_that.mustChangePassword);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'id')  String userId,  String name,  UserRole role,  bool mustChangePassword)  $default,) {final _that = this;
switch (_that) {
case _AppSession():
return $default(_that.userId,_that.name,_that.role,_that.mustChangePassword);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'id')  String userId,  String name,  UserRole role,  bool mustChangePassword)?  $default,) {final _that = this;
switch (_that) {
case _AppSession() when $default != null:
return $default(_that.userId,_that.name,_that.role,_that.mustChangePassword);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AppSession implements AppSession {
  const _AppSession({@JsonKey(name: 'id') required this.userId, required this.name, required this.role, this.mustChangePassword = false});
  factory _AppSession.fromJson(Map<String, dynamic> json) => _$AppSessionFromJson(json);

@override@JsonKey(name: 'id') final  String userId;
@override final  String name;
@override final  UserRole role;
@override@JsonKey() final  bool mustChangePassword;

/// Create a copy of AppSession
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppSessionCopyWith<_AppSession> get copyWith => __$AppSessionCopyWithImpl<_AppSession>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AppSessionToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppSession&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.name, name) || other.name == name)&&(identical(other.role, role) || other.role == role)&&(identical(other.mustChangePassword, mustChangePassword) || other.mustChangePassword == mustChangePassword));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,userId,name,role,mustChangePassword);
}

@override
String toString() {
    return 'AppSession(userId: $userId, name: $name, role: $role, mustChangePassword: $mustChangePassword)';
}


}

/// @nodoc
abstract mixin class _$AppSessionCopyWith<$Res> implements $AppSessionCopyWith<$Res> {
  factory _$AppSessionCopyWith(_AppSession value, $Res Function(_AppSession) _then) = __$AppSessionCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'id') String userId, String name, UserRole role, bool mustChangePassword
});




}
/// @nodoc
class __$AppSessionCopyWithImpl<$Res>
    implements _$AppSessionCopyWith<$Res> {
  __$AppSessionCopyWithImpl(this._self, this._then);

  final _AppSession _self;
  final $Res Function(_AppSession) _then;

/// Create a copy of AppSession
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? name = null,Object? role = null,Object? mustChangePassword = null,}) {
  return _then(_AppSession(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as UserRole,mustChangePassword: null == mustChangePassword ? _self.mustChangePassword : mustChangePassword // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
