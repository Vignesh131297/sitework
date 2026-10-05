// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'issue_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$IssueReporter {

 String get id; String get name; UserRole get role;
/// Create a copy of IssueReporter
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$IssueReporterCopyWith<IssueReporter> get copyWith => _$IssueReporterCopyWithImpl<IssueReporter>(this as IssueReporter, _$identity);

  /// Serializes this IssueReporter to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as IssueReporter;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is IssueReporter&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.role, _this.role) || other.role == _this.role));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as IssueReporter;
  return Object.hash(runtimeType,_this.id,_this.name,_this.role);
}

@override
String toString() {
  final _this = this as IssueReporter;
  return 'IssueReporter(id: ${_this.id}, name: ${_this.name}, role: ${_this.role})';
}


}

/// @nodoc
abstract mixin class $IssueReporterCopyWith<$Res>  {
  factory $IssueReporterCopyWith(IssueReporter value, $Res Function(IssueReporter) _then) = _$IssueReporterCopyWithImpl;
@useResult
$Res call({
 String id, String name, UserRole role
});




}
/// @nodoc
class _$IssueReporterCopyWithImpl<$Res>
    implements $IssueReporterCopyWith<$Res> {
  _$IssueReporterCopyWithImpl(this._self, this._then);

  final IssueReporter _self;
  final $Res Function(IssueReporter) _then;

/// Create a copy of IssueReporter
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? role = null,}) {
  return _then(IssueReporter(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as UserRole,
  ));
}

}


/// Adds pattern-matching-related methods to [IssueReporter].
extension IssueReporterPatterns on IssueReporter {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _IssueReporter value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _IssueReporter() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _IssueReporter value)  $default,){
final _that = this;
switch (_that) {
case _IssueReporter():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _IssueReporter value)?  $default,){
final _that = this;
switch (_that) {
case _IssueReporter() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  UserRole role)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _IssueReporter() when $default != null:
return $default(_that.id,_that.name,_that.role);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  UserRole role)  $default,) {final _that = this;
switch (_that) {
case _IssueReporter():
return $default(_that.id,_that.name,_that.role);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  UserRole role)?  $default,) {final _that = this;
switch (_that) {
case _IssueReporter() when $default != null:
return $default(_that.id,_that.name,_that.role);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _IssueReporter implements IssueReporter {
  const _IssueReporter({required this.id, required this.name, required this.role});
  factory _IssueReporter.fromJson(Map<String, dynamic> json) => _$IssueReporterFromJson(json);

@override final  String id;
@override final  String name;
@override final  UserRole role;

/// Create a copy of IssueReporter
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$IssueReporterCopyWith<_IssueReporter> get copyWith => __$IssueReporterCopyWithImpl<_IssueReporter>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$IssueReporterToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _IssueReporter&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.role, role) || other.role == role));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,role);
}

@override
String toString() {
    return 'IssueReporter(id: $id, name: $name, role: $role)';
}


}

/// @nodoc
abstract mixin class _$IssueReporterCopyWith<$Res> implements $IssueReporterCopyWith<$Res> {
  factory _$IssueReporterCopyWith(_IssueReporter value, $Res Function(_IssueReporter) _then) = __$IssueReporterCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, UserRole role
});




}
/// @nodoc
class __$IssueReporterCopyWithImpl<$Res>
    implements _$IssueReporterCopyWith<$Res> {
  __$IssueReporterCopyWithImpl(this._self, this._then);

  final _IssueReporter _self;
  final $Res Function(_IssueReporter) _then;

/// Create a copy of IssueReporter
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? role = null,}) {
  return _then(_IssueReporter(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as UserRole,
  ));
}


}


/// @nodoc
mixin _$Issue {

 String get id; String get title; String get description; Priority get priority; IssueStatus get status; IdName get site; IssueReporter get reportedBy; DateTime get createdAt; DateTime? get resolvedAt; IdName? get resolvedBy; String? get resolutionNote; int get attachmentCount;/// Detail responses only.
 List<Attachment> get attachments;
/// Create a copy of Issue
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$IssueCopyWith<Issue> get copyWith => _$IssueCopyWithImpl<Issue>(this as Issue, _$identity);

  /// Serializes this Issue to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Issue;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Issue&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.description, _this.description) || other.description == _this.description)&&(identical(other.priority, _this.priority) || other.priority == _this.priority)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.site, _this.site) || other.site == _this.site)&&(identical(other.reportedBy, _this.reportedBy) || other.reportedBy == _this.reportedBy)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.resolvedAt, _this.resolvedAt) || other.resolvedAt == _this.resolvedAt)&&(identical(other.resolvedBy, _this.resolvedBy) || other.resolvedBy == _this.resolvedBy)&&(identical(other.resolutionNote, _this.resolutionNote) || other.resolutionNote == _this.resolutionNote)&&(identical(other.attachmentCount, _this.attachmentCount) || other.attachmentCount == _this.attachmentCount)&&const DeepCollectionEquality().equals(other.attachments, _this.attachments));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Issue;
  return Object.hash(runtimeType,_this.id,_this.title,_this.description,_this.priority,_this.status,_this.site,_this.reportedBy,_this.createdAt,_this.resolvedAt,_this.resolvedBy,_this.resolutionNote,_this.attachmentCount,const DeepCollectionEquality().hash(_this.attachments));
}

@override
String toString() {
  final _this = this as Issue;
  return 'Issue(id: ${_this.id}, title: ${_this.title}, description: ${_this.description}, priority: ${_this.priority}, status: ${_this.status}, site: ${_this.site}, reportedBy: ${_this.reportedBy}, createdAt: ${_this.createdAt}, resolvedAt: ${_this.resolvedAt}, resolvedBy: ${_this.resolvedBy}, resolutionNote: ${_this.resolutionNote}, attachmentCount: ${_this.attachmentCount}, attachments: ${_this.attachments})';
}


}

/// @nodoc
abstract mixin class $IssueCopyWith<$Res>  {
  factory $IssueCopyWith(Issue value, $Res Function(Issue) _then) = _$IssueCopyWithImpl;
@useResult
$Res call({
 String id, String title, String description, Priority priority, IssueStatus status, IdName site, IssueReporter reportedBy, DateTime createdAt, DateTime? resolvedAt, IdName? resolvedBy, String? resolutionNote, int attachmentCount, List<Attachment> attachments
});


$IdNameCopyWith<$Res> get site;$IssueReporterCopyWith<$Res> get reportedBy;$IdNameCopyWith<$Res>? get resolvedBy;

}
/// @nodoc
class _$IssueCopyWithImpl<$Res>
    implements $IssueCopyWith<$Res> {
  _$IssueCopyWithImpl(this._self, this._then);

  final Issue _self;
  final $Res Function(Issue) _then;

/// Create a copy of Issue
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? description = null,Object? priority = null,Object? status = null,Object? site = null,Object? reportedBy = null,Object? createdAt = null,Object? resolvedAt = freezed,Object? resolvedBy = freezed,Object? resolutionNote = freezed,Object? attachmentCount = null,Object? attachments = null,}) {
  return _then(Issue(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as Priority,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as IssueStatus,site: null == site ? _self.site : site // ignore: cast_nullable_to_non_nullable
as IdName,reportedBy: null == reportedBy ? _self.reportedBy : reportedBy // ignore: cast_nullable_to_non_nullable
as IssueReporter,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,resolvedAt: freezed == resolvedAt ? _self.resolvedAt : resolvedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,resolvedBy: freezed == resolvedBy ? _self.resolvedBy : resolvedBy // ignore: cast_nullable_to_non_nullable
as IdName?,resolutionNote: freezed == resolutionNote ? _self.resolutionNote : resolutionNote // ignore: cast_nullable_to_non_nullable
as String?,attachmentCount: null == attachmentCount ? _self.attachmentCount : attachmentCount // ignore: cast_nullable_to_non_nullable
as int,attachments: null == attachments ? _self.attachments : attachments // ignore: cast_nullable_to_non_nullable
as List<Attachment>,
  ));
}
/// Create a copy of Issue
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$IdNameCopyWith<$Res> get site {
  
  return $IdNameCopyWith<$Res>(_self.site, (value) {
    return _then(_self.copyWith(site: value));
  });
}/// Create a copy of Issue
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$IssueReporterCopyWith<$Res> get reportedBy {
  
  return $IssueReporterCopyWith<$Res>(_self.reportedBy, (value) {
    return _then(_self.copyWith(reportedBy: value));
  });
}/// Create a copy of Issue
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$IdNameCopyWith<$Res>? get resolvedBy {
    if (_self.resolvedBy == null) {
    return null;
  }

  return $IdNameCopyWith<$Res>(_self.resolvedBy!, (value) {
    return _then(_self.copyWith(resolvedBy: value));
  });
}
}


/// Adds pattern-matching-related methods to [Issue].
extension IssuePatterns on Issue {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Issue value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Issue() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Issue value)  $default,){
final _that = this;
switch (_that) {
case _Issue():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Issue value)?  $default,){
final _that = this;
switch (_that) {
case _Issue() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String description,  Priority priority,  IssueStatus status,  IdName site,  IssueReporter reportedBy,  DateTime createdAt,  DateTime? resolvedAt,  IdName? resolvedBy,  String? resolutionNote,  int attachmentCount,  List<Attachment> attachments)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Issue() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.priority,_that.status,_that.site,_that.reportedBy,_that.createdAt,_that.resolvedAt,_that.resolvedBy,_that.resolutionNote,_that.attachmentCount,_that.attachments);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String description,  Priority priority,  IssueStatus status,  IdName site,  IssueReporter reportedBy,  DateTime createdAt,  DateTime? resolvedAt,  IdName? resolvedBy,  String? resolutionNote,  int attachmentCount,  List<Attachment> attachments)  $default,) {final _that = this;
switch (_that) {
case _Issue():
return $default(_that.id,_that.title,_that.description,_that.priority,_that.status,_that.site,_that.reportedBy,_that.createdAt,_that.resolvedAt,_that.resolvedBy,_that.resolutionNote,_that.attachmentCount,_that.attachments);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String description,  Priority priority,  IssueStatus status,  IdName site,  IssueReporter reportedBy,  DateTime createdAt,  DateTime? resolvedAt,  IdName? resolvedBy,  String? resolutionNote,  int attachmentCount,  List<Attachment> attachments)?  $default,) {final _that = this;
switch (_that) {
case _Issue() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.priority,_that.status,_that.site,_that.reportedBy,_that.createdAt,_that.resolvedAt,_that.resolvedBy,_that.resolutionNote,_that.attachmentCount,_that.attachments);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Issue implements Issue {
  const _Issue({required this.id, required this.title, required this.description, required this.priority, required this.status, required this.site, required this.reportedBy, required this.createdAt, this.resolvedAt, this.resolvedBy, this.resolutionNote, required this.attachmentCount,  List<Attachment> attachments = const <Attachment>[]}): _attachments = attachments;
  factory _Issue.fromJson(Map<String, dynamic> json) => _$IssueFromJson(json);

@override final  String id;
@override final  String title;
@override final  String description;
@override final  Priority priority;
@override final  IssueStatus status;
@override final  IdName site;
@override final  IssueReporter reportedBy;
@override final  DateTime createdAt;
@override final  DateTime? resolvedAt;
@override final  IdName? resolvedBy;
@override final  String? resolutionNote;
@override final  int attachmentCount;
/// Detail responses only.
 final  List<Attachment> _attachments;
/// Detail responses only.
@override@JsonKey() List<Attachment> get attachments {
  if (_attachments is EqualUnmodifiableListView) return _attachments;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_attachments);
}


/// Create a copy of Issue
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$IssueCopyWith<_Issue> get copyWith => __$IssueCopyWithImpl<_Issue>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$IssueToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Issue&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.status, status) || other.status == status)&&(identical(other.site, site) || other.site == site)&&(identical(other.reportedBy, reportedBy) || other.reportedBy == reportedBy)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.resolvedAt, resolvedAt) || other.resolvedAt == resolvedAt)&&(identical(other.resolvedBy, resolvedBy) || other.resolvedBy == resolvedBy)&&(identical(other.resolutionNote, resolutionNote) || other.resolutionNote == resolutionNote)&&(identical(other.attachmentCount, attachmentCount) || other.attachmentCount == attachmentCount)&&const DeepCollectionEquality().equals(other.attachments, _attachments));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,title,description,priority,status,site,reportedBy,createdAt,resolvedAt,resolvedBy,resolutionNote,attachmentCount,const DeepCollectionEquality().hash(_attachments));
}

@override
String toString() {
    return 'Issue(id: $id, title: $title, description: $description, priority: $priority, status: $status, site: $site, reportedBy: $reportedBy, createdAt: $createdAt, resolvedAt: $resolvedAt, resolvedBy: $resolvedBy, resolutionNote: $resolutionNote, attachmentCount: $attachmentCount, attachments: $attachments)';
}


}

/// @nodoc
abstract mixin class _$IssueCopyWith<$Res> implements $IssueCopyWith<$Res> {
  factory _$IssueCopyWith(_Issue value, $Res Function(_Issue) _then) = __$IssueCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String description, Priority priority, IssueStatus status, IdName site, IssueReporter reportedBy, DateTime createdAt, DateTime? resolvedAt, IdName? resolvedBy, String? resolutionNote, int attachmentCount, List<Attachment> attachments
});


@override $IdNameCopyWith<$Res> get site;@override $IssueReporterCopyWith<$Res> get reportedBy;@override $IdNameCopyWith<$Res>? get resolvedBy;

}
/// @nodoc
class __$IssueCopyWithImpl<$Res>
    implements _$IssueCopyWith<$Res> {
  __$IssueCopyWithImpl(this._self, this._then);

  final _Issue _self;
  final $Res Function(_Issue) _then;

/// Create a copy of Issue
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? description = null,Object? priority = null,Object? status = null,Object? site = null,Object? reportedBy = null,Object? createdAt = null,Object? resolvedAt = freezed,Object? resolvedBy = freezed,Object? resolutionNote = freezed,Object? attachmentCount = null,Object? attachments = null,}) {
  return _then(_Issue(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as Priority,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as IssueStatus,site: null == site ? _self.site : site // ignore: cast_nullable_to_non_nullable
as IdName,reportedBy: null == reportedBy ? _self.reportedBy : reportedBy // ignore: cast_nullable_to_non_nullable
as IssueReporter,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,resolvedAt: freezed == resolvedAt ? _self.resolvedAt : resolvedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,resolvedBy: freezed == resolvedBy ? _self.resolvedBy : resolvedBy // ignore: cast_nullable_to_non_nullable
as IdName?,resolutionNote: freezed == resolutionNote ? _self.resolutionNote : resolutionNote // ignore: cast_nullable_to_non_nullable
as String?,attachmentCount: null == attachmentCount ? _self.attachmentCount : attachmentCount // ignore: cast_nullable_to_non_nullable
as int,attachments: null == attachments ? _self._attachments : attachments // ignore: cast_nullable_to_non_nullable
as List<Attachment>,
  ));
}

/// Create a copy of Issue
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$IdNameCopyWith<$Res> get site {
  
  return $IdNameCopyWith<$Res>(_self.site, (value) {
    return _then(_self.copyWith(site: value));
  });
}/// Create a copy of Issue
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$IssueReporterCopyWith<$Res> get reportedBy {
  
  return $IssueReporterCopyWith<$Res>(_self.reportedBy, (value) {
    return _then(_self.copyWith(reportedBy: value));
  });
}/// Create a copy of Issue
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$IdNameCopyWith<$Res>? get resolvedBy {
    if (_self.resolvedBy == null) {
    return null;
  }

  return $IdNameCopyWith<$Res>(_self.resolvedBy!, (value) {
    return _then(_self.copyWith(resolvedBy: value));
  });
}
}

// dart format on
