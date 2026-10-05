// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'engineer_update_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Attachment {

 String get id; String get mime; String get url; DateTime get expiresAt;
/// Create a copy of Attachment
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AttachmentCopyWith<Attachment> get copyWith => _$AttachmentCopyWithImpl<Attachment>(this as Attachment, _$identity);

  /// Serializes this Attachment to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Attachment;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Attachment&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.mime, _this.mime) || other.mime == _this.mime)&&(identical(other.url, _this.url) || other.url == _this.url)&&(identical(other.expiresAt, _this.expiresAt) || other.expiresAt == _this.expiresAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Attachment;
  return Object.hash(runtimeType,_this.id,_this.mime,_this.url,_this.expiresAt);
}

@override
String toString() {
  final _this = this as Attachment;
  return 'Attachment(id: ${_this.id}, mime: ${_this.mime}, url: ${_this.url}, expiresAt: ${_this.expiresAt})';
}


}

/// @nodoc
abstract mixin class $AttachmentCopyWith<$Res>  {
  factory $AttachmentCopyWith(Attachment value, $Res Function(Attachment) _then) = _$AttachmentCopyWithImpl;
@useResult
$Res call({
 String id, String mime, String url, DateTime expiresAt
});




}
/// @nodoc
class _$AttachmentCopyWithImpl<$Res>
    implements $AttachmentCopyWith<$Res> {
  _$AttachmentCopyWithImpl(this._self, this._then);

  final Attachment _self;
  final $Res Function(Attachment) _then;

/// Create a copy of Attachment
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? mime = null,Object? url = null,Object? expiresAt = null,}) {
  return _then(Attachment(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,mime: null == mime ? _self.mime : mime // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [Attachment].
extension AttachmentPatterns on Attachment {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Attachment value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Attachment() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Attachment value)  $default,){
final _that = this;
switch (_that) {
case _Attachment():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Attachment value)?  $default,){
final _that = this;
switch (_that) {
case _Attachment() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String mime,  String url,  DateTime expiresAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Attachment() when $default != null:
return $default(_that.id,_that.mime,_that.url,_that.expiresAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String mime,  String url,  DateTime expiresAt)  $default,) {final _that = this;
switch (_that) {
case _Attachment():
return $default(_that.id,_that.mime,_that.url,_that.expiresAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String mime,  String url,  DateTime expiresAt)?  $default,) {final _that = this;
switch (_that) {
case _Attachment() when $default != null:
return $default(_that.id,_that.mime,_that.url,_that.expiresAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Attachment implements Attachment {
  const _Attachment({required this.id, required this.mime, required this.url, required this.expiresAt});
  factory _Attachment.fromJson(Map<String, dynamic> json) => _$AttachmentFromJson(json);

@override final  String id;
@override final  String mime;
@override final  String url;
@override final  DateTime expiresAt;

/// Create a copy of Attachment
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AttachmentCopyWith<_Attachment> get copyWith => __$AttachmentCopyWithImpl<_Attachment>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AttachmentToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Attachment&&(identical(other.id, id) || other.id == id)&&(identical(other.mime, mime) || other.mime == mime)&&(identical(other.url, url) || other.url == url)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,mime,url,expiresAt);
}

@override
String toString() {
    return 'Attachment(id: $id, mime: $mime, url: $url, expiresAt: $expiresAt)';
}


}

/// @nodoc
abstract mixin class _$AttachmentCopyWith<$Res> implements $AttachmentCopyWith<$Res> {
  factory _$AttachmentCopyWith(_Attachment value, $Res Function(_Attachment) _then) = __$AttachmentCopyWithImpl;
@override @useResult
$Res call({
 String id, String mime, String url, DateTime expiresAt
});




}
/// @nodoc
class __$AttachmentCopyWithImpl<$Res>
    implements _$AttachmentCopyWith<$Res> {
  __$AttachmentCopyWithImpl(this._self, this._then);

  final _Attachment _self;
  final $Res Function(_Attachment) _then;

/// Create a copy of Attachment
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? mime = null,Object? url = null,Object? expiresAt = null,}) {
  return _then(_Attachment(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,mime: null == mime ? _self.mime : mime // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$EngineerUpdate {

 String get id; EngineerUpdateType get type; Priority get priority; String? get title; String get description; int? get progressPercent; IdName get site; IdName get engineer; DateTime get createdAt; DateTime? get adminViewedAt; int get attachmentCount;/// Detail responses only.
 List<Attachment> get attachments;
/// Create a copy of EngineerUpdate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EngineerUpdateCopyWith<EngineerUpdate> get copyWith => _$EngineerUpdateCopyWithImpl<EngineerUpdate>(this as EngineerUpdate, _$identity);

  /// Serializes this EngineerUpdate to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as EngineerUpdate;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EngineerUpdate&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.priority, _this.priority) || other.priority == _this.priority)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.description, _this.description) || other.description == _this.description)&&(identical(other.progressPercent, _this.progressPercent) || other.progressPercent == _this.progressPercent)&&(identical(other.site, _this.site) || other.site == _this.site)&&(identical(other.engineer, _this.engineer) || other.engineer == _this.engineer)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.adminViewedAt, _this.adminViewedAt) || other.adminViewedAt == _this.adminViewedAt)&&(identical(other.attachmentCount, _this.attachmentCount) || other.attachmentCount == _this.attachmentCount)&&const DeepCollectionEquality().equals(other.attachments, _this.attachments));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as EngineerUpdate;
  return Object.hash(runtimeType,_this.id,_this.type,_this.priority,_this.title,_this.description,_this.progressPercent,_this.site,_this.engineer,_this.createdAt,_this.adminViewedAt,_this.attachmentCount,const DeepCollectionEquality().hash(_this.attachments));
}

@override
String toString() {
  final _this = this as EngineerUpdate;
  return 'EngineerUpdate(id: ${_this.id}, type: ${_this.type}, priority: ${_this.priority}, title: ${_this.title}, description: ${_this.description}, progressPercent: ${_this.progressPercent}, site: ${_this.site}, engineer: ${_this.engineer}, createdAt: ${_this.createdAt}, adminViewedAt: ${_this.adminViewedAt}, attachmentCount: ${_this.attachmentCount}, attachments: ${_this.attachments})';
}


}

/// @nodoc
abstract mixin class $EngineerUpdateCopyWith<$Res>  {
  factory $EngineerUpdateCopyWith(EngineerUpdate value, $Res Function(EngineerUpdate) _then) = _$EngineerUpdateCopyWithImpl;
@useResult
$Res call({
 String id, EngineerUpdateType type, Priority priority, String? title, String description, int? progressPercent, IdName site, IdName engineer, DateTime createdAt, DateTime? adminViewedAt, int attachmentCount, List<Attachment> attachments
});


$IdNameCopyWith<$Res> get site;$IdNameCopyWith<$Res> get engineer;

}
/// @nodoc
class _$EngineerUpdateCopyWithImpl<$Res>
    implements $EngineerUpdateCopyWith<$Res> {
  _$EngineerUpdateCopyWithImpl(this._self, this._then);

  final EngineerUpdate _self;
  final $Res Function(EngineerUpdate) _then;

/// Create a copy of EngineerUpdate
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? type = null,Object? priority = null,Object? title = freezed,Object? description = null,Object? progressPercent = freezed,Object? site = null,Object? engineer = null,Object? createdAt = null,Object? adminViewedAt = freezed,Object? attachmentCount = null,Object? attachments = null,}) {
  return _then(EngineerUpdate(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as EngineerUpdateType,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as Priority,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,progressPercent: freezed == progressPercent ? _self.progressPercent : progressPercent // ignore: cast_nullable_to_non_nullable
as int?,site: null == site ? _self.site : site // ignore: cast_nullable_to_non_nullable
as IdName,engineer: null == engineer ? _self.engineer : engineer // ignore: cast_nullable_to_non_nullable
as IdName,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,adminViewedAt: freezed == adminViewedAt ? _self.adminViewedAt : adminViewedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,attachmentCount: null == attachmentCount ? _self.attachmentCount : attachmentCount // ignore: cast_nullable_to_non_nullable
as int,attachments: null == attachments ? _self.attachments : attachments // ignore: cast_nullable_to_non_nullable
as List<Attachment>,
  ));
}
/// Create a copy of EngineerUpdate
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$IdNameCopyWith<$Res> get site {
  
  return $IdNameCopyWith<$Res>(_self.site, (value) {
    return _then(_self.copyWith(site: value));
  });
}/// Create a copy of EngineerUpdate
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$IdNameCopyWith<$Res> get engineer {
  
  return $IdNameCopyWith<$Res>(_self.engineer, (value) {
    return _then(_self.copyWith(engineer: value));
  });
}
}


/// Adds pattern-matching-related methods to [EngineerUpdate].
extension EngineerUpdatePatterns on EngineerUpdate {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EngineerUpdate value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EngineerUpdate() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EngineerUpdate value)  $default,){
final _that = this;
switch (_that) {
case _EngineerUpdate():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EngineerUpdate value)?  $default,){
final _that = this;
switch (_that) {
case _EngineerUpdate() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  EngineerUpdateType type,  Priority priority,  String? title,  String description,  int? progressPercent,  IdName site,  IdName engineer,  DateTime createdAt,  DateTime? adminViewedAt,  int attachmentCount,  List<Attachment> attachments)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EngineerUpdate() when $default != null:
return $default(_that.id,_that.type,_that.priority,_that.title,_that.description,_that.progressPercent,_that.site,_that.engineer,_that.createdAt,_that.adminViewedAt,_that.attachmentCount,_that.attachments);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  EngineerUpdateType type,  Priority priority,  String? title,  String description,  int? progressPercent,  IdName site,  IdName engineer,  DateTime createdAt,  DateTime? adminViewedAt,  int attachmentCount,  List<Attachment> attachments)  $default,) {final _that = this;
switch (_that) {
case _EngineerUpdate():
return $default(_that.id,_that.type,_that.priority,_that.title,_that.description,_that.progressPercent,_that.site,_that.engineer,_that.createdAt,_that.adminViewedAt,_that.attachmentCount,_that.attachments);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  EngineerUpdateType type,  Priority priority,  String? title,  String description,  int? progressPercent,  IdName site,  IdName engineer,  DateTime createdAt,  DateTime? adminViewedAt,  int attachmentCount,  List<Attachment> attachments)?  $default,) {final _that = this;
switch (_that) {
case _EngineerUpdate() when $default != null:
return $default(_that.id,_that.type,_that.priority,_that.title,_that.description,_that.progressPercent,_that.site,_that.engineer,_that.createdAt,_that.adminViewedAt,_that.attachmentCount,_that.attachments);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EngineerUpdate implements EngineerUpdate {
  const _EngineerUpdate({required this.id, required this.type, required this.priority, this.title, required this.description, this.progressPercent, required this.site, required this.engineer, required this.createdAt, this.adminViewedAt, required this.attachmentCount,  List<Attachment> attachments = const <Attachment>[]}): _attachments = attachments;
  factory _EngineerUpdate.fromJson(Map<String, dynamic> json) => _$EngineerUpdateFromJson(json);

@override final  String id;
@override final  EngineerUpdateType type;
@override final  Priority priority;
@override final  String? title;
@override final  String description;
@override final  int? progressPercent;
@override final  IdName site;
@override final  IdName engineer;
@override final  DateTime createdAt;
@override final  DateTime? adminViewedAt;
@override final  int attachmentCount;
/// Detail responses only.
 final  List<Attachment> _attachments;
/// Detail responses only.
@override@JsonKey() List<Attachment> get attachments {
  if (_attachments is EqualUnmodifiableListView) return _attachments;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_attachments);
}


/// Create a copy of EngineerUpdate
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EngineerUpdateCopyWith<_EngineerUpdate> get copyWith => __$EngineerUpdateCopyWithImpl<_EngineerUpdate>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EngineerUpdateToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _EngineerUpdate&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.progressPercent, progressPercent) || other.progressPercent == progressPercent)&&(identical(other.site, site) || other.site == site)&&(identical(other.engineer, engineer) || other.engineer == engineer)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.adminViewedAt, adminViewedAt) || other.adminViewedAt == adminViewedAt)&&(identical(other.attachmentCount, attachmentCount) || other.attachmentCount == attachmentCount)&&const DeepCollectionEquality().equals(other.attachments, _attachments));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,type,priority,title,description,progressPercent,site,engineer,createdAt,adminViewedAt,attachmentCount,const DeepCollectionEquality().hash(_attachments));
}

@override
String toString() {
    return 'EngineerUpdate(id: $id, type: $type, priority: $priority, title: $title, description: $description, progressPercent: $progressPercent, site: $site, engineer: $engineer, createdAt: $createdAt, adminViewedAt: $adminViewedAt, attachmentCount: $attachmentCount, attachments: $attachments)';
}


}

/// @nodoc
abstract mixin class _$EngineerUpdateCopyWith<$Res> implements $EngineerUpdateCopyWith<$Res> {
  factory _$EngineerUpdateCopyWith(_EngineerUpdate value, $Res Function(_EngineerUpdate) _then) = __$EngineerUpdateCopyWithImpl;
@override @useResult
$Res call({
 String id, EngineerUpdateType type, Priority priority, String? title, String description, int? progressPercent, IdName site, IdName engineer, DateTime createdAt, DateTime? adminViewedAt, int attachmentCount, List<Attachment> attachments
});


@override $IdNameCopyWith<$Res> get site;@override $IdNameCopyWith<$Res> get engineer;

}
/// @nodoc
class __$EngineerUpdateCopyWithImpl<$Res>
    implements _$EngineerUpdateCopyWith<$Res> {
  __$EngineerUpdateCopyWithImpl(this._self, this._then);

  final _EngineerUpdate _self;
  final $Res Function(_EngineerUpdate) _then;

/// Create a copy of EngineerUpdate
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? type = null,Object? priority = null,Object? title = freezed,Object? description = null,Object? progressPercent = freezed,Object? site = null,Object? engineer = null,Object? createdAt = null,Object? adminViewedAt = freezed,Object? attachmentCount = null,Object? attachments = null,}) {
  return _then(_EngineerUpdate(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as EngineerUpdateType,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as Priority,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,progressPercent: freezed == progressPercent ? _self.progressPercent : progressPercent // ignore: cast_nullable_to_non_nullable
as int?,site: null == site ? _self.site : site // ignore: cast_nullable_to_non_nullable
as IdName,engineer: null == engineer ? _self.engineer : engineer // ignore: cast_nullable_to_non_nullable
as IdName,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,adminViewedAt: freezed == adminViewedAt ? _self.adminViewedAt : adminViewedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,attachmentCount: null == attachmentCount ? _self.attachmentCount : attachmentCount // ignore: cast_nullable_to_non_nullable
as int,attachments: null == attachments ? _self._attachments : attachments // ignore: cast_nullable_to_non_nullable
as List<Attachment>,
  ));
}

/// Create a copy of EngineerUpdate
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$IdNameCopyWith<$Res> get site {
  
  return $IdNameCopyWith<$Res>(_self.site, (value) {
    return _then(_self.copyWith(site: value));
  });
}/// Create a copy of EngineerUpdate
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$IdNameCopyWith<$Res> get engineer {
  
  return $IdNameCopyWith<$Res>(_self.engineer, (value) {
    return _then(_self.copyWith(engineer: value));
  });
}
}

// dart format on
