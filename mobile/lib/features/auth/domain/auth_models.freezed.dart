// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AuthTokens {

 String get accessToken; String get refreshToken;
/// Create a copy of AuthTokens
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthTokensCopyWith<AuthTokens> get copyWith => _$AuthTokensCopyWithImpl<AuthTokens>(this as AuthTokens, _$identity);

  /// Serializes this AuthTokens to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AuthTokens;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthTokens&&(identical(other.accessToken, _this.accessToken) || other.accessToken == _this.accessToken)&&(identical(other.refreshToken, _this.refreshToken) || other.refreshToken == _this.refreshToken));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AuthTokens;
  return Object.hash(runtimeType,_this.accessToken,_this.refreshToken);
}

@override
String toString() {
  final _this = this as AuthTokens;
  return 'AuthTokens(accessToken: ${_this.accessToken}, refreshToken: ${_this.refreshToken})';
}


}

/// @nodoc
abstract mixin class $AuthTokensCopyWith<$Res>  {
  factory $AuthTokensCopyWith(AuthTokens value, $Res Function(AuthTokens) _then) = _$AuthTokensCopyWithImpl;
@useResult
$Res call({
 String accessToken, String refreshToken
});




}
/// @nodoc
class _$AuthTokensCopyWithImpl<$Res>
    implements $AuthTokensCopyWith<$Res> {
  _$AuthTokensCopyWithImpl(this._self, this._then);

  final AuthTokens _self;
  final $Res Function(AuthTokens) _then;

/// Create a copy of AuthTokens
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? accessToken = null,Object? refreshToken = null,}) {
  return _then(AuthTokens(
accessToken: null == accessToken ? _self.accessToken : accessToken // ignore: cast_nullable_to_non_nullable
as String,refreshToken: null == refreshToken ? _self.refreshToken : refreshToken // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AuthTokens].
extension AuthTokensPatterns on AuthTokens {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AuthTokens value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AuthTokens() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AuthTokens value)  $default,){
final _that = this;
switch (_that) {
case _AuthTokens():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AuthTokens value)?  $default,){
final _that = this;
switch (_that) {
case _AuthTokens() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String accessToken,  String refreshToken)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AuthTokens() when $default != null:
return $default(_that.accessToken,_that.refreshToken);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String accessToken,  String refreshToken)  $default,) {final _that = this;
switch (_that) {
case _AuthTokens():
return $default(_that.accessToken,_that.refreshToken);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String accessToken,  String refreshToken)?  $default,) {final _that = this;
switch (_that) {
case _AuthTokens() when $default != null:
return $default(_that.accessToken,_that.refreshToken);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AuthTokens implements AuthTokens {
  const _AuthTokens({required this.accessToken, required this.refreshToken});
  factory _AuthTokens.fromJson(Map<String, dynamic> json) => _$AuthTokensFromJson(json);

@override final  String accessToken;
@override final  String refreshToken;

/// Create a copy of AuthTokens
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuthTokensCopyWith<_AuthTokens> get copyWith => __$AuthTokensCopyWithImpl<_AuthTokens>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AuthTokensToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuthTokens&&(identical(other.accessToken, accessToken) || other.accessToken == accessToken)&&(identical(other.refreshToken, refreshToken) || other.refreshToken == refreshToken));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,accessToken,refreshToken);
}

@override
String toString() {
    return 'AuthTokens(accessToken: $accessToken, refreshToken: $refreshToken)';
}


}

/// @nodoc
abstract mixin class _$AuthTokensCopyWith<$Res> implements $AuthTokensCopyWith<$Res> {
  factory _$AuthTokensCopyWith(_AuthTokens value, $Res Function(_AuthTokens) _then) = __$AuthTokensCopyWithImpl;
@override @useResult
$Res call({
 String accessToken, String refreshToken
});




}
/// @nodoc
class __$AuthTokensCopyWithImpl<$Res>
    implements _$AuthTokensCopyWith<$Res> {
  __$AuthTokensCopyWithImpl(this._self, this._then);

  final _AuthTokens _self;
  final $Res Function(_AuthTokens) _then;

/// Create a copy of AuthTokens
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? accessToken = null,Object? refreshToken = null,}) {
  return _then(_AuthTokens(
accessToken: null == accessToken ? _self.accessToken : accessToken // ignore: cast_nullable_to_non_nullable
as String,refreshToken: null == refreshToken ? _self.refreshToken : refreshToken // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$AuthResult {

 String get accessToken; String get refreshToken; AppSession get user;
/// Create a copy of AuthResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthResultCopyWith<AuthResult> get copyWith => _$AuthResultCopyWithImpl<AuthResult>(this as AuthResult, _$identity);

  /// Serializes this AuthResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AuthResult;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthResult&&(identical(other.accessToken, _this.accessToken) || other.accessToken == _this.accessToken)&&(identical(other.refreshToken, _this.refreshToken) || other.refreshToken == _this.refreshToken)&&(identical(other.user, _this.user) || other.user == _this.user));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AuthResult;
  return Object.hash(runtimeType,_this.accessToken,_this.refreshToken,_this.user);
}

@override
String toString() {
  final _this = this as AuthResult;
  return 'AuthResult(accessToken: ${_this.accessToken}, refreshToken: ${_this.refreshToken}, user: ${_this.user})';
}


}

/// @nodoc
abstract mixin class $AuthResultCopyWith<$Res>  {
  factory $AuthResultCopyWith(AuthResult value, $Res Function(AuthResult) _then) = _$AuthResultCopyWithImpl;
@useResult
$Res call({
 String accessToken, String refreshToken, AppSession user
});


$AppSessionCopyWith<$Res> get user;

}
/// @nodoc
class _$AuthResultCopyWithImpl<$Res>
    implements $AuthResultCopyWith<$Res> {
  _$AuthResultCopyWithImpl(this._self, this._then);

  final AuthResult _self;
  final $Res Function(AuthResult) _then;

/// Create a copy of AuthResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? accessToken = null,Object? refreshToken = null,Object? user = null,}) {
  return _then(AuthResult(
accessToken: null == accessToken ? _self.accessToken : accessToken // ignore: cast_nullable_to_non_nullable
as String,refreshToken: null == refreshToken ? _self.refreshToken : refreshToken // ignore: cast_nullable_to_non_nullable
as String,user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as AppSession,
  ));
}
/// Create a copy of AuthResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AppSessionCopyWith<$Res> get user {
  
  return $AppSessionCopyWith<$Res>(_self.user, (value) {
    return _then(_self.copyWith(user: value));
  });
}
}


/// Adds pattern-matching-related methods to [AuthResult].
extension AuthResultPatterns on AuthResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AuthResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AuthResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AuthResult value)  $default,){
final _that = this;
switch (_that) {
case _AuthResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AuthResult value)?  $default,){
final _that = this;
switch (_that) {
case _AuthResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String accessToken,  String refreshToken,  AppSession user)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AuthResult() when $default != null:
return $default(_that.accessToken,_that.refreshToken,_that.user);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String accessToken,  String refreshToken,  AppSession user)  $default,) {final _that = this;
switch (_that) {
case _AuthResult():
return $default(_that.accessToken,_that.refreshToken,_that.user);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String accessToken,  String refreshToken,  AppSession user)?  $default,) {final _that = this;
switch (_that) {
case _AuthResult() when $default != null:
return $default(_that.accessToken,_that.refreshToken,_that.user);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AuthResult extends AuthResult {
  const _AuthResult({required this.accessToken, required this.refreshToken, required this.user}): super._();
  factory _AuthResult.fromJson(Map<String, dynamic> json) => _$AuthResultFromJson(json);

@override final  String accessToken;
@override final  String refreshToken;
@override final  AppSession user;

/// Create a copy of AuthResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuthResultCopyWith<_AuthResult> get copyWith => __$AuthResultCopyWithImpl<_AuthResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AuthResultToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuthResult&&(identical(other.accessToken, accessToken) || other.accessToken == accessToken)&&(identical(other.refreshToken, refreshToken) || other.refreshToken == refreshToken)&&(identical(other.user, user) || other.user == user));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,accessToken,refreshToken,user);
}

@override
String toString() {
    return 'AuthResult(accessToken: $accessToken, refreshToken: $refreshToken, user: $user)';
}


}

/// @nodoc
abstract mixin class _$AuthResultCopyWith<$Res> implements $AuthResultCopyWith<$Res> {
  factory _$AuthResultCopyWith(_AuthResult value, $Res Function(_AuthResult) _then) = __$AuthResultCopyWithImpl;
@override @useResult
$Res call({
 String accessToken, String refreshToken, AppSession user
});


@override $AppSessionCopyWith<$Res> get user;

}
/// @nodoc
class __$AuthResultCopyWithImpl<$Res>
    implements _$AuthResultCopyWith<$Res> {
  __$AuthResultCopyWithImpl(this._self, this._then);

  final _AuthResult _self;
  final $Res Function(_AuthResult) _then;

/// Create a copy of AuthResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? accessToken = null,Object? refreshToken = null,Object? user = null,}) {
  return _then(_AuthResult(
accessToken: null == accessToken ? _self.accessToken : accessToken // ignore: cast_nullable_to_non_nullable
as String,refreshToken: null == refreshToken ? _self.refreshToken : refreshToken // ignore: cast_nullable_to_non_nullable
as String,user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as AppSession,
  ));
}

/// Create a copy of AuthResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AppSessionCopyWith<$Res> get user {
  
  return $AppSessionCopyWith<$Res>(_self.user, (value) {
    return _then(_self.copyWith(user: value));
  });
}
}


/// @nodoc
mixin _$StoredSession {

 AuthTokens get tokens; AppSession get user;
/// Create a copy of StoredSession
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StoredSessionCopyWith<StoredSession> get copyWith => _$StoredSessionCopyWithImpl<StoredSession>(this as StoredSession, _$identity);

  /// Serializes this StoredSession to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as StoredSession;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StoredSession&&(identical(other.tokens, _this.tokens) || other.tokens == _this.tokens)&&(identical(other.user, _this.user) || other.user == _this.user));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as StoredSession;
  return Object.hash(runtimeType,_this.tokens,_this.user);
}

@override
String toString() {
  final _this = this as StoredSession;
  return 'StoredSession(tokens: ${_this.tokens}, user: ${_this.user})';
}


}

/// @nodoc
abstract mixin class $StoredSessionCopyWith<$Res>  {
  factory $StoredSessionCopyWith(StoredSession value, $Res Function(StoredSession) _then) = _$StoredSessionCopyWithImpl;
@useResult
$Res call({
 AuthTokens tokens, AppSession user
});


$AuthTokensCopyWith<$Res> get tokens;$AppSessionCopyWith<$Res> get user;

}
/// @nodoc
class _$StoredSessionCopyWithImpl<$Res>
    implements $StoredSessionCopyWith<$Res> {
  _$StoredSessionCopyWithImpl(this._self, this._then);

  final StoredSession _self;
  final $Res Function(StoredSession) _then;

/// Create a copy of StoredSession
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? tokens = null,Object? user = null,}) {
  return _then(StoredSession(
tokens: null == tokens ? _self.tokens : tokens // ignore: cast_nullable_to_non_nullable
as AuthTokens,user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as AppSession,
  ));
}
/// Create a copy of StoredSession
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AuthTokensCopyWith<$Res> get tokens {
  
  return $AuthTokensCopyWith<$Res>(_self.tokens, (value) {
    return _then(_self.copyWith(tokens: value));
  });
}/// Create a copy of StoredSession
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AppSessionCopyWith<$Res> get user {
  
  return $AppSessionCopyWith<$Res>(_self.user, (value) {
    return _then(_self.copyWith(user: value));
  });
}
}


/// Adds pattern-matching-related methods to [StoredSession].
extension StoredSessionPatterns on StoredSession {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StoredSession value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StoredSession() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StoredSession value)  $default,){
final _that = this;
switch (_that) {
case _StoredSession():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StoredSession value)?  $default,){
final _that = this;
switch (_that) {
case _StoredSession() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AuthTokens tokens,  AppSession user)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StoredSession() when $default != null:
return $default(_that.tokens,_that.user);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AuthTokens tokens,  AppSession user)  $default,) {final _that = this;
switch (_that) {
case _StoredSession():
return $default(_that.tokens,_that.user);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AuthTokens tokens,  AppSession user)?  $default,) {final _that = this;
switch (_that) {
case _StoredSession() when $default != null:
return $default(_that.tokens,_that.user);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StoredSession implements StoredSession {
  const _StoredSession({required this.tokens, required this.user});
  factory _StoredSession.fromJson(Map<String, dynamic> json) => _$StoredSessionFromJson(json);

@override final  AuthTokens tokens;
@override final  AppSession user;

/// Create a copy of StoredSession
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StoredSessionCopyWith<_StoredSession> get copyWith => __$StoredSessionCopyWithImpl<_StoredSession>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StoredSessionToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _StoredSession&&(identical(other.tokens, tokens) || other.tokens == tokens)&&(identical(other.user, user) || other.user == user));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,tokens,user);
}

@override
String toString() {
    return 'StoredSession(tokens: $tokens, user: $user)';
}


}

/// @nodoc
abstract mixin class _$StoredSessionCopyWith<$Res> implements $StoredSessionCopyWith<$Res> {
  factory _$StoredSessionCopyWith(_StoredSession value, $Res Function(_StoredSession) _then) = __$StoredSessionCopyWithImpl;
@override @useResult
$Res call({
 AuthTokens tokens, AppSession user
});


@override $AuthTokensCopyWith<$Res> get tokens;@override $AppSessionCopyWith<$Res> get user;

}
/// @nodoc
class __$StoredSessionCopyWithImpl<$Res>
    implements _$StoredSessionCopyWith<$Res> {
  __$StoredSessionCopyWithImpl(this._self, this._then);

  final _StoredSession _self;
  final $Res Function(_StoredSession) _then;

/// Create a copy of StoredSession
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? tokens = null,Object? user = null,}) {
  return _then(_StoredSession(
tokens: null == tokens ? _self.tokens : tokens // ignore: cast_nullable_to_non_nullable
as AuthTokens,user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as AppSession,
  ));
}

/// Create a copy of StoredSession
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AuthTokensCopyWith<$Res> get tokens {
  
  return $AuthTokensCopyWith<$Res>(_self.tokens, (value) {
    return _then(_self.copyWith(tokens: value));
  });
}/// Create a copy of StoredSession
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AppSessionCopyWith<$Res> get user {
  
  return $AppSessionCopyWith<$Res>(_self.user, (value) {
    return _then(_self.copyWith(user: value));
  });
}
}


/// @nodoc
mixin _$StaffAssignmentInfo {

 SiteRef get site; PersonRef get engineer;
/// Create a copy of StaffAssignmentInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StaffAssignmentInfoCopyWith<StaffAssignmentInfo> get copyWith => _$StaffAssignmentInfoCopyWithImpl<StaffAssignmentInfo>(this as StaffAssignmentInfo, _$identity);

  /// Serializes this StaffAssignmentInfo to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as StaffAssignmentInfo;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StaffAssignmentInfo&&(identical(other.site, _this.site) || other.site == _this.site)&&(identical(other.engineer, _this.engineer) || other.engineer == _this.engineer));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as StaffAssignmentInfo;
  return Object.hash(runtimeType,_this.site,_this.engineer);
}

@override
String toString() {
  final _this = this as StaffAssignmentInfo;
  return 'StaffAssignmentInfo(site: ${_this.site}, engineer: ${_this.engineer})';
}


}

/// @nodoc
abstract mixin class $StaffAssignmentInfoCopyWith<$Res>  {
  factory $StaffAssignmentInfoCopyWith(StaffAssignmentInfo value, $Res Function(StaffAssignmentInfo) _then) = _$StaffAssignmentInfoCopyWithImpl;
@useResult
$Res call({
 SiteRef site, PersonRef engineer
});


$SiteRefCopyWith<$Res> get site;$PersonRefCopyWith<$Res> get engineer;

}
/// @nodoc
class _$StaffAssignmentInfoCopyWithImpl<$Res>
    implements $StaffAssignmentInfoCopyWith<$Res> {
  _$StaffAssignmentInfoCopyWithImpl(this._self, this._then);

  final StaffAssignmentInfo _self;
  final $Res Function(StaffAssignmentInfo) _then;

/// Create a copy of StaffAssignmentInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? site = null,Object? engineer = null,}) {
  return _then(StaffAssignmentInfo(
site: null == site ? _self.site : site // ignore: cast_nullable_to_non_nullable
as SiteRef,engineer: null == engineer ? _self.engineer : engineer // ignore: cast_nullable_to_non_nullable
as PersonRef,
  ));
}
/// Create a copy of StaffAssignmentInfo
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SiteRefCopyWith<$Res> get site {
  
  return $SiteRefCopyWith<$Res>(_self.site, (value) {
    return _then(_self.copyWith(site: value));
  });
}/// Create a copy of StaffAssignmentInfo
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PersonRefCopyWith<$Res> get engineer {
  
  return $PersonRefCopyWith<$Res>(_self.engineer, (value) {
    return _then(_self.copyWith(engineer: value));
  });
}
}


/// Adds pattern-matching-related methods to [StaffAssignmentInfo].
extension StaffAssignmentInfoPatterns on StaffAssignmentInfo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StaffAssignmentInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StaffAssignmentInfo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StaffAssignmentInfo value)  $default,){
final _that = this;
switch (_that) {
case _StaffAssignmentInfo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StaffAssignmentInfo value)?  $default,){
final _that = this;
switch (_that) {
case _StaffAssignmentInfo() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( SiteRef site,  PersonRef engineer)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StaffAssignmentInfo() when $default != null:
return $default(_that.site,_that.engineer);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( SiteRef site,  PersonRef engineer)  $default,) {final _that = this;
switch (_that) {
case _StaffAssignmentInfo():
return $default(_that.site,_that.engineer);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( SiteRef site,  PersonRef engineer)?  $default,) {final _that = this;
switch (_that) {
case _StaffAssignmentInfo() when $default != null:
return $default(_that.site,_that.engineer);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StaffAssignmentInfo implements StaffAssignmentInfo {
  const _StaffAssignmentInfo({required this.site, required this.engineer});
  factory _StaffAssignmentInfo.fromJson(Map<String, dynamic> json) => _$StaffAssignmentInfoFromJson(json);

@override final  SiteRef site;
@override final  PersonRef engineer;

/// Create a copy of StaffAssignmentInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StaffAssignmentInfoCopyWith<_StaffAssignmentInfo> get copyWith => __$StaffAssignmentInfoCopyWithImpl<_StaffAssignmentInfo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StaffAssignmentInfoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _StaffAssignmentInfo&&(identical(other.site, site) || other.site == site)&&(identical(other.engineer, engineer) || other.engineer == engineer));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,site,engineer);
}

@override
String toString() {
    return 'StaffAssignmentInfo(site: $site, engineer: $engineer)';
}


}

/// @nodoc
abstract mixin class _$StaffAssignmentInfoCopyWith<$Res> implements $StaffAssignmentInfoCopyWith<$Res> {
  factory _$StaffAssignmentInfoCopyWith(_StaffAssignmentInfo value, $Res Function(_StaffAssignmentInfo) _then) = __$StaffAssignmentInfoCopyWithImpl;
@override @useResult
$Res call({
 SiteRef site, PersonRef engineer
});


@override $SiteRefCopyWith<$Res> get site;@override $PersonRefCopyWith<$Res> get engineer;

}
/// @nodoc
class __$StaffAssignmentInfoCopyWithImpl<$Res>
    implements _$StaffAssignmentInfoCopyWith<$Res> {
  __$StaffAssignmentInfoCopyWithImpl(this._self, this._then);

  final _StaffAssignmentInfo _self;
  final $Res Function(_StaffAssignmentInfo) _then;

/// Create a copy of StaffAssignmentInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? site = null,Object? engineer = null,}) {
  return _then(_StaffAssignmentInfo(
site: null == site ? _self.site : site // ignore: cast_nullable_to_non_nullable
as SiteRef,engineer: null == engineer ? _self.engineer : engineer // ignore: cast_nullable_to_non_nullable
as PersonRef,
  ));
}

/// Create a copy of StaffAssignmentInfo
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SiteRefCopyWith<$Res> get site {
  
  return $SiteRefCopyWith<$Res>(_self.site, (value) {
    return _then(_self.copyWith(site: value));
  });
}/// Create a copy of StaffAssignmentInfo
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PersonRefCopyWith<$Res> get engineer {
  
  return $PersonRefCopyWith<$Res>(_self.engineer, (value) {
    return _then(_self.copyWith(engineer: value));
  });
}
}


/// @nodoc
mixin _$MeProfile {

 String get id; String get name; UserRole get role; String get phone; String? get email; String get employeeCode; Designation? get designation; String? get joiningDate; bool get mustChangePassword; StaffAssignmentInfo? get assignment; List<SiteRef> get sites;
/// Create a copy of MeProfile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MeProfileCopyWith<MeProfile> get copyWith => _$MeProfileCopyWithImpl<MeProfile>(this as MeProfile, _$identity);

  /// Serializes this MeProfile to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MeProfile;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MeProfile&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.role, _this.role) || other.role == _this.role)&&(identical(other.phone, _this.phone) || other.phone == _this.phone)&&(identical(other.email, _this.email) || other.email == _this.email)&&(identical(other.employeeCode, _this.employeeCode) || other.employeeCode == _this.employeeCode)&&(identical(other.designation, _this.designation) || other.designation == _this.designation)&&(identical(other.joiningDate, _this.joiningDate) || other.joiningDate == _this.joiningDate)&&(identical(other.mustChangePassword, _this.mustChangePassword) || other.mustChangePassword == _this.mustChangePassword)&&(identical(other.assignment, _this.assignment) || other.assignment == _this.assignment)&&const DeepCollectionEquality().equals(other.sites, _this.sites));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MeProfile;
  return Object.hash(runtimeType,_this.id,_this.name,_this.role,_this.phone,_this.email,_this.employeeCode,_this.designation,_this.joiningDate,_this.mustChangePassword,_this.assignment,const DeepCollectionEquality().hash(_this.sites));
}

@override
String toString() {
  final _this = this as MeProfile;
  return 'MeProfile(id: ${_this.id}, name: ${_this.name}, role: ${_this.role}, phone: ${_this.phone}, email: ${_this.email}, employeeCode: ${_this.employeeCode}, designation: ${_this.designation}, joiningDate: ${_this.joiningDate}, mustChangePassword: ${_this.mustChangePassword}, assignment: ${_this.assignment}, sites: ${_this.sites})';
}


}

/// @nodoc
abstract mixin class $MeProfileCopyWith<$Res>  {
  factory $MeProfileCopyWith(MeProfile value, $Res Function(MeProfile) _then) = _$MeProfileCopyWithImpl;
@useResult
$Res call({
 String id, String name, UserRole role, String phone, String? email, String employeeCode, Designation? designation, String? joiningDate, bool mustChangePassword, StaffAssignmentInfo? assignment, List<SiteRef> sites
});


$StaffAssignmentInfoCopyWith<$Res>? get assignment;

}
/// @nodoc
class _$MeProfileCopyWithImpl<$Res>
    implements $MeProfileCopyWith<$Res> {
  _$MeProfileCopyWithImpl(this._self, this._then);

  final MeProfile _self;
  final $Res Function(MeProfile) _then;

/// Create a copy of MeProfile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? role = null,Object? phone = null,Object? email = freezed,Object? employeeCode = null,Object? designation = freezed,Object? joiningDate = freezed,Object? mustChangePassword = null,Object? assignment = freezed,Object? sites = null,}) {
  return _then(MeProfile(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as UserRole,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,employeeCode: null == employeeCode ? _self.employeeCode : employeeCode // ignore: cast_nullable_to_non_nullable
as String,designation: freezed == designation ? _self.designation : designation // ignore: cast_nullable_to_non_nullable
as Designation?,joiningDate: freezed == joiningDate ? _self.joiningDate : joiningDate // ignore: cast_nullable_to_non_nullable
as String?,mustChangePassword: null == mustChangePassword ? _self.mustChangePassword : mustChangePassword // ignore: cast_nullable_to_non_nullable
as bool,assignment: freezed == assignment ? _self.assignment : assignment // ignore: cast_nullable_to_non_nullable
as StaffAssignmentInfo?,sites: null == sites ? _self.sites : sites // ignore: cast_nullable_to_non_nullable
as List<SiteRef>,
  ));
}
/// Create a copy of MeProfile
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


/// Adds pattern-matching-related methods to [MeProfile].
extension MeProfilePatterns on MeProfile {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MeProfile value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MeProfile() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MeProfile value)  $default,){
final _that = this;
switch (_that) {
case _MeProfile():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MeProfile value)?  $default,){
final _that = this;
switch (_that) {
case _MeProfile() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  UserRole role,  String phone,  String? email,  String employeeCode,  Designation? designation,  String? joiningDate,  bool mustChangePassword,  StaffAssignmentInfo? assignment,  List<SiteRef> sites)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MeProfile() when $default != null:
return $default(_that.id,_that.name,_that.role,_that.phone,_that.email,_that.employeeCode,_that.designation,_that.joiningDate,_that.mustChangePassword,_that.assignment,_that.sites);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  UserRole role,  String phone,  String? email,  String employeeCode,  Designation? designation,  String? joiningDate,  bool mustChangePassword,  StaffAssignmentInfo? assignment,  List<SiteRef> sites)  $default,) {final _that = this;
switch (_that) {
case _MeProfile():
return $default(_that.id,_that.name,_that.role,_that.phone,_that.email,_that.employeeCode,_that.designation,_that.joiningDate,_that.mustChangePassword,_that.assignment,_that.sites);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  UserRole role,  String phone,  String? email,  String employeeCode,  Designation? designation,  String? joiningDate,  bool mustChangePassword,  StaffAssignmentInfo? assignment,  List<SiteRef> sites)?  $default,) {final _that = this;
switch (_that) {
case _MeProfile() when $default != null:
return $default(_that.id,_that.name,_that.role,_that.phone,_that.email,_that.employeeCode,_that.designation,_that.joiningDate,_that.mustChangePassword,_that.assignment,_that.sites);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MeProfile extends MeProfile {
  const _MeProfile({required this.id, required this.name, required this.role, required this.phone, this.email, required this.employeeCode, this.designation, this.joiningDate, required this.mustChangePassword, this.assignment,  List<SiteRef> sites = const <SiteRef>[]}): _sites = sites,super._();
  factory _MeProfile.fromJson(Map<String, dynamic> json) => _$MeProfileFromJson(json);

@override final  String id;
@override final  String name;
@override final  UserRole role;
@override final  String phone;
@override final  String? email;
@override final  String employeeCode;
@override final  Designation? designation;
@override final  String? joiningDate;
@override final  bool mustChangePassword;
@override final  StaffAssignmentInfo? assignment;
 final  List<SiteRef> _sites;
@override@JsonKey() List<SiteRef> get sites {
  if (_sites is EqualUnmodifiableListView) return _sites;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sites);
}


/// Create a copy of MeProfile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MeProfileCopyWith<_MeProfile> get copyWith => __$MeProfileCopyWithImpl<_MeProfile>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MeProfileToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MeProfile&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.role, role) || other.role == role)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.email, email) || other.email == email)&&(identical(other.employeeCode, employeeCode) || other.employeeCode == employeeCode)&&(identical(other.designation, designation) || other.designation == designation)&&(identical(other.joiningDate, joiningDate) || other.joiningDate == joiningDate)&&(identical(other.mustChangePassword, mustChangePassword) || other.mustChangePassword == mustChangePassword)&&(identical(other.assignment, assignment) || other.assignment == assignment)&&const DeepCollectionEquality().equals(other.sites, _sites));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,role,phone,email,employeeCode,designation,joiningDate,mustChangePassword,assignment,const DeepCollectionEquality().hash(_sites));
}

@override
String toString() {
    return 'MeProfile(id: $id, name: $name, role: $role, phone: $phone, email: $email, employeeCode: $employeeCode, designation: $designation, joiningDate: $joiningDate, mustChangePassword: $mustChangePassword, assignment: $assignment, sites: $sites)';
}


}

/// @nodoc
abstract mixin class _$MeProfileCopyWith<$Res> implements $MeProfileCopyWith<$Res> {
  factory _$MeProfileCopyWith(_MeProfile value, $Res Function(_MeProfile) _then) = __$MeProfileCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, UserRole role, String phone, String? email, String employeeCode, Designation? designation, String? joiningDate, bool mustChangePassword, StaffAssignmentInfo? assignment, List<SiteRef> sites
});


@override $StaffAssignmentInfoCopyWith<$Res>? get assignment;

}
/// @nodoc
class __$MeProfileCopyWithImpl<$Res>
    implements _$MeProfileCopyWith<$Res> {
  __$MeProfileCopyWithImpl(this._self, this._then);

  final _MeProfile _self;
  final $Res Function(_MeProfile) _then;

/// Create a copy of MeProfile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? role = null,Object? phone = null,Object? email = freezed,Object? employeeCode = null,Object? designation = freezed,Object? joiningDate = freezed,Object? mustChangePassword = null,Object? assignment = freezed,Object? sites = null,}) {
  return _then(_MeProfile(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as UserRole,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,employeeCode: null == employeeCode ? _self.employeeCode : employeeCode // ignore: cast_nullable_to_non_nullable
as String,designation: freezed == designation ? _self.designation : designation // ignore: cast_nullable_to_non_nullable
as Designation?,joiningDate: freezed == joiningDate ? _self.joiningDate : joiningDate // ignore: cast_nullable_to_non_nullable
as String?,mustChangePassword: null == mustChangePassword ? _self.mustChangePassword : mustChangePassword // ignore: cast_nullable_to_non_nullable
as bool,assignment: freezed == assignment ? _self.assignment : assignment // ignore: cast_nullable_to_non_nullable
as StaffAssignmentInfo?,sites: null == sites ? _self._sites : sites // ignore: cast_nullable_to_non_nullable
as List<SiteRef>,
  ));
}

/// Create a copy of MeProfile
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

// dart format on
