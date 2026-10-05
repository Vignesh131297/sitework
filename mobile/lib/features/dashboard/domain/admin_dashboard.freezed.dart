// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'admin_dashboard.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DayTotals {

 int get expected; int get submitted; int get missing; int get pending; int get upcoming; int get notCheckedIn;
/// Create a copy of DayTotals
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DayTotalsCopyWith<DayTotals> get copyWith => _$DayTotalsCopyWithImpl<DayTotals>(this as DayTotals, _$identity);

  /// Serializes this DayTotals to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as DayTotals;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DayTotals&&(identical(other.expected, _this.expected) || other.expected == _this.expected)&&(identical(other.submitted, _this.submitted) || other.submitted == _this.submitted)&&(identical(other.missing, _this.missing) || other.missing == _this.missing)&&(identical(other.pending, _this.pending) || other.pending == _this.pending)&&(identical(other.upcoming, _this.upcoming) || other.upcoming == _this.upcoming)&&(identical(other.notCheckedIn, _this.notCheckedIn) || other.notCheckedIn == _this.notCheckedIn));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as DayTotals;
  return Object.hash(runtimeType,_this.expected,_this.submitted,_this.missing,_this.pending,_this.upcoming,_this.notCheckedIn);
}

@override
String toString() {
  final _this = this as DayTotals;
  return 'DayTotals(expected: ${_this.expected}, submitted: ${_this.submitted}, missing: ${_this.missing}, pending: ${_this.pending}, upcoming: ${_this.upcoming}, notCheckedIn: ${_this.notCheckedIn})';
}


}

/// @nodoc
abstract mixin class $DayTotalsCopyWith<$Res>  {
  factory $DayTotalsCopyWith(DayTotals value, $Res Function(DayTotals) _then) = _$DayTotalsCopyWithImpl;
@useResult
$Res call({
 int expected, int submitted, int missing, int pending, int upcoming, int notCheckedIn
});




}
/// @nodoc
class _$DayTotalsCopyWithImpl<$Res>
    implements $DayTotalsCopyWith<$Res> {
  _$DayTotalsCopyWithImpl(this._self, this._then);

  final DayTotals _self;
  final $Res Function(DayTotals) _then;

/// Create a copy of DayTotals
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? expected = null,Object? submitted = null,Object? missing = null,Object? pending = null,Object? upcoming = null,Object? notCheckedIn = null,}) {
  return _then(DayTotals(
expected: null == expected ? _self.expected : expected // ignore: cast_nullable_to_non_nullable
as int,submitted: null == submitted ? _self.submitted : submitted // ignore: cast_nullable_to_non_nullable
as int,missing: null == missing ? _self.missing : missing // ignore: cast_nullable_to_non_nullable
as int,pending: null == pending ? _self.pending : pending // ignore: cast_nullable_to_non_nullable
as int,upcoming: null == upcoming ? _self.upcoming : upcoming // ignore: cast_nullable_to_non_nullable
as int,notCheckedIn: null == notCheckedIn ? _self.notCheckedIn : notCheckedIn // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [DayTotals].
extension DayTotalsPatterns on DayTotals {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DayTotals value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DayTotals() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DayTotals value)  $default,){
final _that = this;
switch (_that) {
case _DayTotals():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DayTotals value)?  $default,){
final _that = this;
switch (_that) {
case _DayTotals() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int expected,  int submitted,  int missing,  int pending,  int upcoming,  int notCheckedIn)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DayTotals() when $default != null:
return $default(_that.expected,_that.submitted,_that.missing,_that.pending,_that.upcoming,_that.notCheckedIn);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int expected,  int submitted,  int missing,  int pending,  int upcoming,  int notCheckedIn)  $default,) {final _that = this;
switch (_that) {
case _DayTotals():
return $default(_that.expected,_that.submitted,_that.missing,_that.pending,_that.upcoming,_that.notCheckedIn);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int expected,  int submitted,  int missing,  int pending,  int upcoming,  int notCheckedIn)?  $default,) {final _that = this;
switch (_that) {
case _DayTotals() when $default != null:
return $default(_that.expected,_that.submitted,_that.missing,_that.pending,_that.upcoming,_that.notCheckedIn);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DayTotals implements DayTotals {
  const _DayTotals({required this.expected, required this.submitted, required this.missing, required this.pending, required this.upcoming, required this.notCheckedIn});
  factory _DayTotals.fromJson(Map<String, dynamic> json) => _$DayTotalsFromJson(json);

@override final  int expected;
@override final  int submitted;
@override final  int missing;
@override final  int pending;
@override final  int upcoming;
@override final  int notCheckedIn;

/// Create a copy of DayTotals
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DayTotalsCopyWith<_DayTotals> get copyWith => __$DayTotalsCopyWithImpl<_DayTotals>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DayTotalsToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DayTotals&&(identical(other.expected, expected) || other.expected == expected)&&(identical(other.submitted, submitted) || other.submitted == submitted)&&(identical(other.missing, missing) || other.missing == missing)&&(identical(other.pending, pending) || other.pending == pending)&&(identical(other.upcoming, upcoming) || other.upcoming == upcoming)&&(identical(other.notCheckedIn, notCheckedIn) || other.notCheckedIn == notCheckedIn));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,expected,submitted,missing,pending,upcoming,notCheckedIn);
}

@override
String toString() {
    return 'DayTotals(expected: $expected, submitted: $submitted, missing: $missing, pending: $pending, upcoming: $upcoming, notCheckedIn: $notCheckedIn)';
}


}

/// @nodoc
abstract mixin class _$DayTotalsCopyWith<$Res> implements $DayTotalsCopyWith<$Res> {
  factory _$DayTotalsCopyWith(_DayTotals value, $Res Function(_DayTotals) _then) = __$DayTotalsCopyWithImpl;
@override @useResult
$Res call({
 int expected, int submitted, int missing, int pending, int upcoming, int notCheckedIn
});




}
/// @nodoc
class __$DayTotalsCopyWithImpl<$Res>
    implements _$DayTotalsCopyWith<$Res> {
  __$DayTotalsCopyWithImpl(this._self, this._then);

  final _DayTotals _self;
  final $Res Function(_DayTotals) _then;

/// Create a copy of DayTotals
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? expected = null,Object? submitted = null,Object? missing = null,Object? pending = null,Object? upcoming = null,Object? notCheckedIn = null,}) {
  return _then(_DayTotals(
expected: null == expected ? _self.expected : expected // ignore: cast_nullable_to_non_nullable
as int,submitted: null == submitted ? _self.submitted : submitted // ignore: cast_nullable_to_non_nullable
as int,missing: null == missing ? _self.missing : missing // ignore: cast_nullable_to_non_nullable
as int,pending: null == pending ? _self.pending : pending // ignore: cast_nullable_to_non_nullable
as int,upcoming: null == upcoming ? _self.upcoming : upcoming // ignore: cast_nullable_to_non_nullable
as int,notCheckedIn: null == notCheckedIn ? _self.notCheckedIn : notCheckedIn // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$MoneyTotals {

 String get contract; String get received; String get pending; String get overdue; int get overdueCount;
/// Create a copy of MoneyTotals
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MoneyTotalsCopyWith<MoneyTotals> get copyWith => _$MoneyTotalsCopyWithImpl<MoneyTotals>(this as MoneyTotals, _$identity);

  /// Serializes this MoneyTotals to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MoneyTotals;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MoneyTotals&&(identical(other.contract, _this.contract) || other.contract == _this.contract)&&(identical(other.received, _this.received) || other.received == _this.received)&&(identical(other.pending, _this.pending) || other.pending == _this.pending)&&(identical(other.overdue, _this.overdue) || other.overdue == _this.overdue)&&(identical(other.overdueCount, _this.overdueCount) || other.overdueCount == _this.overdueCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MoneyTotals;
  return Object.hash(runtimeType,_this.contract,_this.received,_this.pending,_this.overdue,_this.overdueCount);
}

@override
String toString() {
  final _this = this as MoneyTotals;
  return 'MoneyTotals(contract: ${_this.contract}, received: ${_this.received}, pending: ${_this.pending}, overdue: ${_this.overdue}, overdueCount: ${_this.overdueCount})';
}


}

/// @nodoc
abstract mixin class $MoneyTotalsCopyWith<$Res>  {
  factory $MoneyTotalsCopyWith(MoneyTotals value, $Res Function(MoneyTotals) _then) = _$MoneyTotalsCopyWithImpl;
@useResult
$Res call({
 String contract, String received, String pending, String overdue, int overdueCount
});




}
/// @nodoc
class _$MoneyTotalsCopyWithImpl<$Res>
    implements $MoneyTotalsCopyWith<$Res> {
  _$MoneyTotalsCopyWithImpl(this._self, this._then);

  final MoneyTotals _self;
  final $Res Function(MoneyTotals) _then;

/// Create a copy of MoneyTotals
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? contract = null,Object? received = null,Object? pending = null,Object? overdue = null,Object? overdueCount = null,}) {
  return _then(MoneyTotals(
contract: null == contract ? _self.contract : contract // ignore: cast_nullable_to_non_nullable
as String,received: null == received ? _self.received : received // ignore: cast_nullable_to_non_nullable
as String,pending: null == pending ? _self.pending : pending // ignore: cast_nullable_to_non_nullable
as String,overdue: null == overdue ? _self.overdue : overdue // ignore: cast_nullable_to_non_nullable
as String,overdueCount: null == overdueCount ? _self.overdueCount : overdueCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [MoneyTotals].
extension MoneyTotalsPatterns on MoneyTotals {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MoneyTotals value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MoneyTotals() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MoneyTotals value)  $default,){
final _that = this;
switch (_that) {
case _MoneyTotals():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MoneyTotals value)?  $default,){
final _that = this;
switch (_that) {
case _MoneyTotals() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String contract,  String received,  String pending,  String overdue,  int overdueCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MoneyTotals() when $default != null:
return $default(_that.contract,_that.received,_that.pending,_that.overdue,_that.overdueCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String contract,  String received,  String pending,  String overdue,  int overdueCount)  $default,) {final _that = this;
switch (_that) {
case _MoneyTotals():
return $default(_that.contract,_that.received,_that.pending,_that.overdue,_that.overdueCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String contract,  String received,  String pending,  String overdue,  int overdueCount)?  $default,) {final _that = this;
switch (_that) {
case _MoneyTotals() when $default != null:
return $default(_that.contract,_that.received,_that.pending,_that.overdue,_that.overdueCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MoneyTotals implements MoneyTotals {
  const _MoneyTotals({required this.contract, required this.received, required this.pending, required this.overdue, required this.overdueCount});
  factory _MoneyTotals.fromJson(Map<String, dynamic> json) => _$MoneyTotalsFromJson(json);

@override final  String contract;
@override final  String received;
@override final  String pending;
@override final  String overdue;
@override final  int overdueCount;

/// Create a copy of MoneyTotals
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MoneyTotalsCopyWith<_MoneyTotals> get copyWith => __$MoneyTotalsCopyWithImpl<_MoneyTotals>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MoneyTotalsToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MoneyTotals&&(identical(other.contract, contract) || other.contract == contract)&&(identical(other.received, received) || other.received == received)&&(identical(other.pending, pending) || other.pending == pending)&&(identical(other.overdue, overdue) || other.overdue == overdue)&&(identical(other.overdueCount, overdueCount) || other.overdueCount == overdueCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,contract,received,pending,overdue,overdueCount);
}

@override
String toString() {
    return 'MoneyTotals(contract: $contract, received: $received, pending: $pending, overdue: $overdue, overdueCount: $overdueCount)';
}


}

/// @nodoc
abstract mixin class _$MoneyTotalsCopyWith<$Res> implements $MoneyTotalsCopyWith<$Res> {
  factory _$MoneyTotalsCopyWith(_MoneyTotals value, $Res Function(_MoneyTotals) _then) = __$MoneyTotalsCopyWithImpl;
@override @useResult
$Res call({
 String contract, String received, String pending, String overdue, int overdueCount
});




}
/// @nodoc
class __$MoneyTotalsCopyWithImpl<$Res>
    implements _$MoneyTotalsCopyWith<$Res> {
  __$MoneyTotalsCopyWithImpl(this._self, this._then);

  final _MoneyTotals _self;
  final $Res Function(_MoneyTotals) _then;

/// Create a copy of MoneyTotals
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? contract = null,Object? received = null,Object? pending = null,Object? overdue = null,Object? overdueCount = null,}) {
  return _then(_MoneyTotals(
contract: null == contract ? _self.contract : contract // ignore: cast_nullable_to_non_nullable
as String,received: null == received ? _self.received : received // ignore: cast_nullable_to_non_nullable
as String,pending: null == pending ? _self.pending : pending // ignore: cast_nullable_to_non_nullable
as String,overdue: null == overdue ? _self.overdue : overdue // ignore: cast_nullable_to_non_nullable
as String,overdueCount: null == overdueCount ? _self.overdueCount : overdueCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$DashboardCounts {

 int get activeSites; int get clients; int get engineers; int get staff;
/// Create a copy of DashboardCounts
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DashboardCountsCopyWith<DashboardCounts> get copyWith => _$DashboardCountsCopyWithImpl<DashboardCounts>(this as DashboardCounts, _$identity);

  /// Serializes this DashboardCounts to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as DashboardCounts;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DashboardCounts&&(identical(other.activeSites, _this.activeSites) || other.activeSites == _this.activeSites)&&(identical(other.clients, _this.clients) || other.clients == _this.clients)&&(identical(other.engineers, _this.engineers) || other.engineers == _this.engineers)&&(identical(other.staff, _this.staff) || other.staff == _this.staff));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as DashboardCounts;
  return Object.hash(runtimeType,_this.activeSites,_this.clients,_this.engineers,_this.staff);
}

@override
String toString() {
  final _this = this as DashboardCounts;
  return 'DashboardCounts(activeSites: ${_this.activeSites}, clients: ${_this.clients}, engineers: ${_this.engineers}, staff: ${_this.staff})';
}


}

/// @nodoc
abstract mixin class $DashboardCountsCopyWith<$Res>  {
  factory $DashboardCountsCopyWith(DashboardCounts value, $Res Function(DashboardCounts) _then) = _$DashboardCountsCopyWithImpl;
@useResult
$Res call({
 int activeSites, int clients, int engineers, int staff
});




}
/// @nodoc
class _$DashboardCountsCopyWithImpl<$Res>
    implements $DashboardCountsCopyWith<$Res> {
  _$DashboardCountsCopyWithImpl(this._self, this._then);

  final DashboardCounts _self;
  final $Res Function(DashboardCounts) _then;

/// Create a copy of DashboardCounts
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? activeSites = null,Object? clients = null,Object? engineers = null,Object? staff = null,}) {
  return _then(DashboardCounts(
activeSites: null == activeSites ? _self.activeSites : activeSites // ignore: cast_nullable_to_non_nullable
as int,clients: null == clients ? _self.clients : clients // ignore: cast_nullable_to_non_nullable
as int,engineers: null == engineers ? _self.engineers : engineers // ignore: cast_nullable_to_non_nullable
as int,staff: null == staff ? _self.staff : staff // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [DashboardCounts].
extension DashboardCountsPatterns on DashboardCounts {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DashboardCounts value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DashboardCounts() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DashboardCounts value)  $default,){
final _that = this;
switch (_that) {
case _DashboardCounts():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DashboardCounts value)?  $default,){
final _that = this;
switch (_that) {
case _DashboardCounts() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int activeSites,  int clients,  int engineers,  int staff)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DashboardCounts() when $default != null:
return $default(_that.activeSites,_that.clients,_that.engineers,_that.staff);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int activeSites,  int clients,  int engineers,  int staff)  $default,) {final _that = this;
switch (_that) {
case _DashboardCounts():
return $default(_that.activeSites,_that.clients,_that.engineers,_that.staff);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int activeSites,  int clients,  int engineers,  int staff)?  $default,) {final _that = this;
switch (_that) {
case _DashboardCounts() when $default != null:
return $default(_that.activeSites,_that.clients,_that.engineers,_that.staff);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DashboardCounts implements DashboardCounts {
  const _DashboardCounts({required this.activeSites, required this.clients, required this.engineers, required this.staff});
  factory _DashboardCounts.fromJson(Map<String, dynamic> json) => _$DashboardCountsFromJson(json);

@override final  int activeSites;
@override final  int clients;
@override final  int engineers;
@override final  int staff;

/// Create a copy of DashboardCounts
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DashboardCountsCopyWith<_DashboardCounts> get copyWith => __$DashboardCountsCopyWithImpl<_DashboardCounts>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DashboardCountsToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DashboardCounts&&(identical(other.activeSites, activeSites) || other.activeSites == activeSites)&&(identical(other.clients, clients) || other.clients == clients)&&(identical(other.engineers, engineers) || other.engineers == engineers)&&(identical(other.staff, staff) || other.staff == staff));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,activeSites,clients,engineers,staff);
}

@override
String toString() {
    return 'DashboardCounts(activeSites: $activeSites, clients: $clients, engineers: $engineers, staff: $staff)';
}


}

/// @nodoc
abstract mixin class _$DashboardCountsCopyWith<$Res> implements $DashboardCountsCopyWith<$Res> {
  factory _$DashboardCountsCopyWith(_DashboardCounts value, $Res Function(_DashboardCounts) _then) = __$DashboardCountsCopyWithImpl;
@override @useResult
$Res call({
 int activeSites, int clients, int engineers, int staff
});




}
/// @nodoc
class __$DashboardCountsCopyWithImpl<$Res>
    implements _$DashboardCountsCopyWith<$Res> {
  __$DashboardCountsCopyWithImpl(this._self, this._then);

  final _DashboardCounts _self;
  final $Res Function(_DashboardCounts) _then;

/// Create a copy of DashboardCounts
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? activeSites = null,Object? clients = null,Object? engineers = null,Object? staff = null,}) {
  return _then(_DashboardCounts(
activeSites: null == activeSites ? _self.activeSites : activeSites // ignore: cast_nullable_to_non_nullable
as int,clients: null == clients ? _self.clients : clients // ignore: cast_nullable_to_non_nullable
as int,engineers: null == engineers ? _self.engineers : engineers // ignore: cast_nullable_to_non_nullable
as int,staff: null == staff ? _self.staff : staff // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$IssueCounts {

 int get open; int get critical;
/// Create a copy of IssueCounts
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$IssueCountsCopyWith<IssueCounts> get copyWith => _$IssueCountsCopyWithImpl<IssueCounts>(this as IssueCounts, _$identity);

  /// Serializes this IssueCounts to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as IssueCounts;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is IssueCounts&&(identical(other.open, _this.open) || other.open == _this.open)&&(identical(other.critical, _this.critical) || other.critical == _this.critical));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as IssueCounts;
  return Object.hash(runtimeType,_this.open,_this.critical);
}

@override
String toString() {
  final _this = this as IssueCounts;
  return 'IssueCounts(open: ${_this.open}, critical: ${_this.critical})';
}


}

/// @nodoc
abstract mixin class $IssueCountsCopyWith<$Res>  {
  factory $IssueCountsCopyWith(IssueCounts value, $Res Function(IssueCounts) _then) = _$IssueCountsCopyWithImpl;
@useResult
$Res call({
 int open, int critical
});




}
/// @nodoc
class _$IssueCountsCopyWithImpl<$Res>
    implements $IssueCountsCopyWith<$Res> {
  _$IssueCountsCopyWithImpl(this._self, this._then);

  final IssueCounts _self;
  final $Res Function(IssueCounts) _then;

/// Create a copy of IssueCounts
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? open = null,Object? critical = null,}) {
  return _then(IssueCounts(
open: null == open ? _self.open : open // ignore: cast_nullable_to_non_nullable
as int,critical: null == critical ? _self.critical : critical // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [IssueCounts].
extension IssueCountsPatterns on IssueCounts {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _IssueCounts value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _IssueCounts() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _IssueCounts value)  $default,){
final _that = this;
switch (_that) {
case _IssueCounts():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _IssueCounts value)?  $default,){
final _that = this;
switch (_that) {
case _IssueCounts() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int open,  int critical)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _IssueCounts() when $default != null:
return $default(_that.open,_that.critical);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int open,  int critical)  $default,) {final _that = this;
switch (_that) {
case _IssueCounts():
return $default(_that.open,_that.critical);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int open,  int critical)?  $default,) {final _that = this;
switch (_that) {
case _IssueCounts() when $default != null:
return $default(_that.open,_that.critical);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _IssueCounts implements IssueCounts {
  const _IssueCounts({required this.open, required this.critical});
  factory _IssueCounts.fromJson(Map<String, dynamic> json) => _$IssueCountsFromJson(json);

@override final  int open;
@override final  int critical;

/// Create a copy of IssueCounts
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$IssueCountsCopyWith<_IssueCounts> get copyWith => __$IssueCountsCopyWithImpl<_IssueCounts>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$IssueCountsToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _IssueCounts&&(identical(other.open, open) || other.open == open)&&(identical(other.critical, critical) || other.critical == critical));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,open,critical);
}

@override
String toString() {
    return 'IssueCounts(open: $open, critical: $critical)';
}


}

/// @nodoc
abstract mixin class _$IssueCountsCopyWith<$Res> implements $IssueCountsCopyWith<$Res> {
  factory _$IssueCountsCopyWith(_IssueCounts value, $Res Function(_IssueCounts) _then) = __$IssueCountsCopyWithImpl;
@override @useResult
$Res call({
 int open, int critical
});




}
/// @nodoc
class __$IssueCountsCopyWithImpl<$Res>
    implements _$IssueCountsCopyWith<$Res> {
  __$IssueCountsCopyWithImpl(this._self, this._then);

  final _IssueCounts _self;
  final $Res Function(_IssueCounts) _then;

/// Create a copy of IssueCounts
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? open = null,Object? critical = null,}) {
  return _then(_IssueCounts(
open: null == open ? _self.open : open // ignore: cast_nullable_to_non_nullable
as int,critical: null == critical ? _self.critical : critical // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

AttentionItem _$AttentionItemFromJson(
  Map<String, dynamic> json
) {
        switch (json['type']) {
                  case 'MISSING_UPDATES':
          return MissingUpdatesItem.fromJson(
            json
          );
                case 'NOT_CHECKED_IN':
          return NotCheckedInItem.fromJson(
            json
          );
                case 'OVERDUE_PAYMENT':
          return OverduePaymentItem.fromJson(
            json
          );
                case 'CRITICAL_ISSUE':
          return CriticalIssueItem.fromJson(
            json
          );
        
          default:
            return UnknownAttentionItem.fromJson(
  json
);
        }
      
}

/// @nodoc
mixin _$AttentionItem {



  /// Serializes this AttentionItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is AttentionItem);
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'AttentionItem()';
}


}

/// @nodoc
class $AttentionItemCopyWith<$Res>  {
$AttentionItemCopyWith(AttentionItem _, $Res Function(AttentionItem) __);
}


/// Adds pattern-matching-related methods to [AttentionItem].
extension AttentionItemPatterns on AttentionItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( MissingUpdatesItem value)?  missingUpdates,TResult Function( NotCheckedInItem value)?  notCheckedIn,TResult Function( OverduePaymentItem value)?  overduePayment,TResult Function( CriticalIssueItem value)?  criticalIssue,TResult Function( UnknownAttentionItem value)?  unknown,required TResult orElse(),}){
final _that = this;
switch (_that) {
case MissingUpdatesItem() when missingUpdates != null:
return missingUpdates(_that);case NotCheckedInItem() when notCheckedIn != null:
return notCheckedIn(_that);case OverduePaymentItem() when overduePayment != null:
return overduePayment(_that);case CriticalIssueItem() when criticalIssue != null:
return criticalIssue(_that);case UnknownAttentionItem() when unknown != null:
return unknown(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( MissingUpdatesItem value)  missingUpdates,required TResult Function( NotCheckedInItem value)  notCheckedIn,required TResult Function( OverduePaymentItem value)  overduePayment,required TResult Function( CriticalIssueItem value)  criticalIssue,required TResult Function( UnknownAttentionItem value)  unknown,}){
final _that = this;
switch (_that) {
case MissingUpdatesItem():
return missingUpdates(_that);case NotCheckedInItem():
return notCheckedIn(_that);case OverduePaymentItem():
return overduePayment(_that);case CriticalIssueItem():
return criticalIssue(_that);case UnknownAttentionItem():
return unknown(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( MissingUpdatesItem value)?  missingUpdates,TResult? Function( NotCheckedInItem value)?  notCheckedIn,TResult? Function( OverduePaymentItem value)?  overduePayment,TResult? Function( CriticalIssueItem value)?  criticalIssue,TResult? Function( UnknownAttentionItem value)?  unknown,}){
final _that = this;
switch (_that) {
case MissingUpdatesItem() when missingUpdates != null:
return missingUpdates(_that);case NotCheckedInItem() when notCheckedIn != null:
return notCheckedIn(_that);case OverduePaymentItem() when overduePayment != null:
return overduePayment(_that);case CriticalIssueItem() when criticalIssue != null:
return criticalIssue(_that);case UnknownAttentionItem() when unknown != null:
return unknown(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( IdName site,  int count,  List<String> staffNames)?  missingUpdates,TResult Function( IdName site,  int count,  List<String> staffNames)?  notCheckedIn,TResult Function( IdName site,  TitledRef milestone,  String outstanding,  String dueDate)?  overduePayment,TResult Function( IdName site,  TitledRef issue)?  criticalIssue,TResult Function()?  unknown,required TResult orElse(),}) {final _that = this;
switch (_that) {
case MissingUpdatesItem() when missingUpdates != null:
return missingUpdates(_that.site,_that.count,_that.staffNames);case NotCheckedInItem() when notCheckedIn != null:
return notCheckedIn(_that.site,_that.count,_that.staffNames);case OverduePaymentItem() when overduePayment != null:
return overduePayment(_that.site,_that.milestone,_that.outstanding,_that.dueDate);case CriticalIssueItem() when criticalIssue != null:
return criticalIssue(_that.site,_that.issue);case UnknownAttentionItem() when unknown != null:
return unknown();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( IdName site,  int count,  List<String> staffNames)  missingUpdates,required TResult Function( IdName site,  int count,  List<String> staffNames)  notCheckedIn,required TResult Function( IdName site,  TitledRef milestone,  String outstanding,  String dueDate)  overduePayment,required TResult Function( IdName site,  TitledRef issue)  criticalIssue,required TResult Function()  unknown,}) {final _that = this;
switch (_that) {
case MissingUpdatesItem():
return missingUpdates(_that.site,_that.count,_that.staffNames);case NotCheckedInItem():
return notCheckedIn(_that.site,_that.count,_that.staffNames);case OverduePaymentItem():
return overduePayment(_that.site,_that.milestone,_that.outstanding,_that.dueDate);case CriticalIssueItem():
return criticalIssue(_that.site,_that.issue);case UnknownAttentionItem():
return unknown();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( IdName site,  int count,  List<String> staffNames)?  missingUpdates,TResult? Function( IdName site,  int count,  List<String> staffNames)?  notCheckedIn,TResult? Function( IdName site,  TitledRef milestone,  String outstanding,  String dueDate)?  overduePayment,TResult? Function( IdName site,  TitledRef issue)?  criticalIssue,TResult? Function()?  unknown,}) {final _that = this;
switch (_that) {
case MissingUpdatesItem() when missingUpdates != null:
return missingUpdates(_that.site,_that.count,_that.staffNames);case NotCheckedInItem() when notCheckedIn != null:
return notCheckedIn(_that.site,_that.count,_that.staffNames);case OverduePaymentItem() when overduePayment != null:
return overduePayment(_that.site,_that.milestone,_that.outstanding,_that.dueDate);case CriticalIssueItem() when criticalIssue != null:
return criticalIssue(_that.site,_that.issue);case UnknownAttentionItem() when unknown != null:
return unknown();case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class MissingUpdatesItem implements AttentionItem {
  const MissingUpdatesItem({required this.site, required this.count, required  List<String> staffNames,  String? $type}): _staffNames = staffNames,$type = $type ?? 'MISSING_UPDATES';
  factory MissingUpdatesItem.fromJson(Map<String, dynamic> json) => _$MissingUpdatesItemFromJson(json);

 final  IdName site;
 final  int count;
 final  List<String> _staffNames;
 List<String> get staffNames {
  if (_staffNames is EqualUnmodifiableListView) return _staffNames;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_staffNames);
}


@JsonKey(name: 'type')
final String $type;


/// Create a copy of AttentionItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MissingUpdatesItemCopyWith<MissingUpdatesItem> get copyWith => _$MissingUpdatesItemCopyWithImpl<MissingUpdatesItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MissingUpdatesItemToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is MissingUpdatesItem&&(identical(other.site, site) || other.site == site)&&(identical(other.count, count) || other.count == count)&&const DeepCollectionEquality().equals(other.staffNames, _staffNames));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,site,count,const DeepCollectionEquality().hash(_staffNames));
}

@override
String toString() {
    return 'AttentionItem.missingUpdates(site: $site, count: $count, staffNames: $staffNames)';
}


}

/// @nodoc
abstract mixin class $MissingUpdatesItemCopyWith<$Res> implements $AttentionItemCopyWith<$Res> {
  factory $MissingUpdatesItemCopyWith(MissingUpdatesItem value, $Res Function(MissingUpdatesItem) _then) = _$MissingUpdatesItemCopyWithImpl;
@useResult
$Res call({
 IdName site, int count, List<String> staffNames
});


$IdNameCopyWith<$Res> get site;

}
/// @nodoc
class _$MissingUpdatesItemCopyWithImpl<$Res>
    implements $MissingUpdatesItemCopyWith<$Res> {
  _$MissingUpdatesItemCopyWithImpl(this._self, this._then);

  final MissingUpdatesItem _self;
  final $Res Function(MissingUpdatesItem) _then;

/// Create a copy of AttentionItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? site = null,Object? count = null,Object? staffNames = null,}) {
  return _then(MissingUpdatesItem(
site: null == site ? _self.site : site // ignore: cast_nullable_to_non_nullable
as IdName,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,staffNames: null == staffNames ? _self._staffNames : staffNames // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

/// Create a copy of AttentionItem
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
@JsonSerializable()

class NotCheckedInItem implements AttentionItem {
  const NotCheckedInItem({required this.site, required this.count, required  List<String> staffNames,  String? $type}): _staffNames = staffNames,$type = $type ?? 'NOT_CHECKED_IN';
  factory NotCheckedInItem.fromJson(Map<String, dynamic> json) => _$NotCheckedInItemFromJson(json);

 final  IdName site;
 final  int count;
 final  List<String> _staffNames;
 List<String> get staffNames {
  if (_staffNames is EqualUnmodifiableListView) return _staffNames;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_staffNames);
}


@JsonKey(name: 'type')
final String $type;


/// Create a copy of AttentionItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NotCheckedInItemCopyWith<NotCheckedInItem> get copyWith => _$NotCheckedInItemCopyWithImpl<NotCheckedInItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NotCheckedInItemToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is NotCheckedInItem&&(identical(other.site, site) || other.site == site)&&(identical(other.count, count) || other.count == count)&&const DeepCollectionEquality().equals(other.staffNames, _staffNames));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,site,count,const DeepCollectionEquality().hash(_staffNames));
}

@override
String toString() {
    return 'AttentionItem.notCheckedIn(site: $site, count: $count, staffNames: $staffNames)';
}


}

/// @nodoc
abstract mixin class $NotCheckedInItemCopyWith<$Res> implements $AttentionItemCopyWith<$Res> {
  factory $NotCheckedInItemCopyWith(NotCheckedInItem value, $Res Function(NotCheckedInItem) _then) = _$NotCheckedInItemCopyWithImpl;
@useResult
$Res call({
 IdName site, int count, List<String> staffNames
});


$IdNameCopyWith<$Res> get site;

}
/// @nodoc
class _$NotCheckedInItemCopyWithImpl<$Res>
    implements $NotCheckedInItemCopyWith<$Res> {
  _$NotCheckedInItemCopyWithImpl(this._self, this._then);

  final NotCheckedInItem _self;
  final $Res Function(NotCheckedInItem) _then;

/// Create a copy of AttentionItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? site = null,Object? count = null,Object? staffNames = null,}) {
  return _then(NotCheckedInItem(
site: null == site ? _self.site : site // ignore: cast_nullable_to_non_nullable
as IdName,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,staffNames: null == staffNames ? _self._staffNames : staffNames // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

/// Create a copy of AttentionItem
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
@JsonSerializable()

class OverduePaymentItem implements AttentionItem {
  const OverduePaymentItem({required this.site, required this.milestone, required this.outstanding, required this.dueDate,  String? $type}): $type = $type ?? 'OVERDUE_PAYMENT';
  factory OverduePaymentItem.fromJson(Map<String, dynamic> json) => _$OverduePaymentItemFromJson(json);

 final  IdName site;
 final  TitledRef milestone;
 final  String outstanding;
 final  String dueDate;

@JsonKey(name: 'type')
final String $type;


/// Create a copy of AttentionItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OverduePaymentItemCopyWith<OverduePaymentItem> get copyWith => _$OverduePaymentItemCopyWithImpl<OverduePaymentItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OverduePaymentItemToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is OverduePaymentItem&&(identical(other.site, site) || other.site == site)&&(identical(other.milestone, milestone) || other.milestone == milestone)&&(identical(other.outstanding, outstanding) || other.outstanding == outstanding)&&(identical(other.dueDate, dueDate) || other.dueDate == dueDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,site,milestone,outstanding,dueDate);
}

@override
String toString() {
    return 'AttentionItem.overduePayment(site: $site, milestone: $milestone, outstanding: $outstanding, dueDate: $dueDate)';
}


}

/// @nodoc
abstract mixin class $OverduePaymentItemCopyWith<$Res> implements $AttentionItemCopyWith<$Res> {
  factory $OverduePaymentItemCopyWith(OverduePaymentItem value, $Res Function(OverduePaymentItem) _then) = _$OverduePaymentItemCopyWithImpl;
@useResult
$Res call({
 IdName site, TitledRef milestone, String outstanding, String dueDate
});


$IdNameCopyWith<$Res> get site;$TitledRefCopyWith<$Res> get milestone;

}
/// @nodoc
class _$OverduePaymentItemCopyWithImpl<$Res>
    implements $OverduePaymentItemCopyWith<$Res> {
  _$OverduePaymentItemCopyWithImpl(this._self, this._then);

  final OverduePaymentItem _self;
  final $Res Function(OverduePaymentItem) _then;

/// Create a copy of AttentionItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? site = null,Object? milestone = null,Object? outstanding = null,Object? dueDate = null,}) {
  return _then(OverduePaymentItem(
site: null == site ? _self.site : site // ignore: cast_nullable_to_non_nullable
as IdName,milestone: null == milestone ? _self.milestone : milestone // ignore: cast_nullable_to_non_nullable
as TitledRef,outstanding: null == outstanding ? _self.outstanding : outstanding // ignore: cast_nullable_to_non_nullable
as String,dueDate: null == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

/// Create a copy of AttentionItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$IdNameCopyWith<$Res> get site {
  
  return $IdNameCopyWith<$Res>(_self.site, (value) {
    return _then(_self.copyWith(site: value));
  });
}/// Create a copy of AttentionItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TitledRefCopyWith<$Res> get milestone {
  
  return $TitledRefCopyWith<$Res>(_self.milestone, (value) {
    return _then(_self.copyWith(milestone: value));
  });
}
}

/// @nodoc
@JsonSerializable()

class CriticalIssueItem implements AttentionItem {
  const CriticalIssueItem({required this.site, required this.issue,  String? $type}): $type = $type ?? 'CRITICAL_ISSUE';
  factory CriticalIssueItem.fromJson(Map<String, dynamic> json) => _$CriticalIssueItemFromJson(json);

 final  IdName site;
 final  TitledRef issue;

@JsonKey(name: 'type')
final String $type;


/// Create a copy of AttentionItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CriticalIssueItemCopyWith<CriticalIssueItem> get copyWith => _$CriticalIssueItemCopyWithImpl<CriticalIssueItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CriticalIssueItemToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is CriticalIssueItem&&(identical(other.site, site) || other.site == site)&&(identical(other.issue, issue) || other.issue == issue));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,site,issue);
}

@override
String toString() {
    return 'AttentionItem.criticalIssue(site: $site, issue: $issue)';
}


}

/// @nodoc
abstract mixin class $CriticalIssueItemCopyWith<$Res> implements $AttentionItemCopyWith<$Res> {
  factory $CriticalIssueItemCopyWith(CriticalIssueItem value, $Res Function(CriticalIssueItem) _then) = _$CriticalIssueItemCopyWithImpl;
@useResult
$Res call({
 IdName site, TitledRef issue
});


$IdNameCopyWith<$Res> get site;$TitledRefCopyWith<$Res> get issue;

}
/// @nodoc
class _$CriticalIssueItemCopyWithImpl<$Res>
    implements $CriticalIssueItemCopyWith<$Res> {
  _$CriticalIssueItemCopyWithImpl(this._self, this._then);

  final CriticalIssueItem _self;
  final $Res Function(CriticalIssueItem) _then;

/// Create a copy of AttentionItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? site = null,Object? issue = null,}) {
  return _then(CriticalIssueItem(
site: null == site ? _self.site : site // ignore: cast_nullable_to_non_nullable
as IdName,issue: null == issue ? _self.issue : issue // ignore: cast_nullable_to_non_nullable
as TitledRef,
  ));
}

/// Create a copy of AttentionItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$IdNameCopyWith<$Res> get site {
  
  return $IdNameCopyWith<$Res>(_self.site, (value) {
    return _then(_self.copyWith(site: value));
  });
}/// Create a copy of AttentionItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TitledRefCopyWith<$Res> get issue {
  
  return $TitledRefCopyWith<$Res>(_self.issue, (value) {
    return _then(_self.copyWith(issue: value));
  });
}
}

/// @nodoc
@JsonSerializable()

class UnknownAttentionItem implements AttentionItem {
  const UnknownAttentionItem({ String? $type}): $type = $type ?? 'UNKNOWN';
  factory UnknownAttentionItem.fromJson(Map<String, dynamic> json) => _$UnknownAttentionItemFromJson(json);



@JsonKey(name: 'type')
final String $type;



@override
Map<String, dynamic> toJson() {
  return _$UnknownAttentionItemToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is UnknownAttentionItem);
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'AttentionItem.unknown()';
}


}





/// @nodoc
mixin _$ActivitySite {

 String get id; String get code; String get name; SiteStatus get status;
/// Create a copy of ActivitySite
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ActivitySiteCopyWith<ActivitySite> get copyWith => _$ActivitySiteCopyWithImpl<ActivitySite>(this as ActivitySite, _$identity);

  /// Serializes this ActivitySite to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ActivitySite;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ActivitySite&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.code, _this.code) || other.code == _this.code)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.status, _this.status) || other.status == _this.status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ActivitySite;
  return Object.hash(runtimeType,_this.id,_this.code,_this.name,_this.status);
}

@override
String toString() {
  final _this = this as ActivitySite;
  return 'ActivitySite(id: ${_this.id}, code: ${_this.code}, name: ${_this.name}, status: ${_this.status})';
}


}

/// @nodoc
abstract mixin class $ActivitySiteCopyWith<$Res>  {
  factory $ActivitySiteCopyWith(ActivitySite value, $Res Function(ActivitySite) _then) = _$ActivitySiteCopyWithImpl;
@useResult
$Res call({
 String id, String code, String name, SiteStatus status
});




}
/// @nodoc
class _$ActivitySiteCopyWithImpl<$Res>
    implements $ActivitySiteCopyWith<$Res> {
  _$ActivitySiteCopyWithImpl(this._self, this._then);

  final ActivitySite _self;
  final $Res Function(ActivitySite) _then;

/// Create a copy of ActivitySite
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? code = null,Object? name = null,Object? status = null,}) {
  return _then(ActivitySite(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as SiteStatus,
  ));
}

}


/// Adds pattern-matching-related methods to [ActivitySite].
extension ActivitySitePatterns on ActivitySite {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ActivitySite value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ActivitySite() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ActivitySite value)  $default,){
final _that = this;
switch (_that) {
case _ActivitySite():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ActivitySite value)?  $default,){
final _that = this;
switch (_that) {
case _ActivitySite() when $default != null:
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
case _ActivitySite() when $default != null:
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
case _ActivitySite():
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
case _ActivitySite() when $default != null:
return $default(_that.id,_that.code,_that.name,_that.status);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ActivitySite implements ActivitySite {
  const _ActivitySite({required this.id, required this.code, required this.name, required this.status});
  factory _ActivitySite.fromJson(Map<String, dynamic> json) => _$ActivitySiteFromJson(json);

@override final  String id;
@override final  String code;
@override final  String name;
@override final  SiteStatus status;

/// Create a copy of ActivitySite
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ActivitySiteCopyWith<_ActivitySite> get copyWith => __$ActivitySiteCopyWithImpl<_ActivitySite>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ActivitySiteToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ActivitySite&&(identical(other.id, id) || other.id == id)&&(identical(other.code, code) || other.code == code)&&(identical(other.name, name) || other.name == name)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,code,name,status);
}

@override
String toString() {
    return 'ActivitySite(id: $id, code: $code, name: $name, status: $status)';
}


}

/// @nodoc
abstract mixin class _$ActivitySiteCopyWith<$Res> implements $ActivitySiteCopyWith<$Res> {
  factory _$ActivitySiteCopyWith(_ActivitySite value, $Res Function(_ActivitySite) _then) = __$ActivitySiteCopyWithImpl;
@override @useResult
$Res call({
 String id, String code, String name, SiteStatus status
});




}
/// @nodoc
class __$ActivitySiteCopyWithImpl<$Res>
    implements _$ActivitySiteCopyWith<$Res> {
  __$ActivitySiteCopyWithImpl(this._self, this._then);

  final _ActivitySite _self;
  final $Res Function(_ActivitySite) _then;

/// Create a copy of ActivitySite
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? code = null,Object? name = null,Object? status = null,}) {
  return _then(_ActivitySite(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as SiteStatus,
  ));
}


}


/// @nodoc
mixin _$SiteActivity {

 ActivitySite get site; List<String> get engineers; int get staffCount; DayTotals get updates; DateTime? get lastActivityAt;
/// Create a copy of SiteActivity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SiteActivityCopyWith<SiteActivity> get copyWith => _$SiteActivityCopyWithImpl<SiteActivity>(this as SiteActivity, _$identity);

  /// Serializes this SiteActivity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as SiteActivity;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SiteActivity&&(identical(other.site, _this.site) || other.site == _this.site)&&const DeepCollectionEquality().equals(other.engineers, _this.engineers)&&(identical(other.staffCount, _this.staffCount) || other.staffCount == _this.staffCount)&&(identical(other.updates, _this.updates) || other.updates == _this.updates)&&(identical(other.lastActivityAt, _this.lastActivityAt) || other.lastActivityAt == _this.lastActivityAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as SiteActivity;
  return Object.hash(runtimeType,_this.site,const DeepCollectionEquality().hash(_this.engineers),_this.staffCount,_this.updates,_this.lastActivityAt);
}

@override
String toString() {
  final _this = this as SiteActivity;
  return 'SiteActivity(site: ${_this.site}, engineers: ${_this.engineers}, staffCount: ${_this.staffCount}, updates: ${_this.updates}, lastActivityAt: ${_this.lastActivityAt})';
}


}

/// @nodoc
abstract mixin class $SiteActivityCopyWith<$Res>  {
  factory $SiteActivityCopyWith(SiteActivity value, $Res Function(SiteActivity) _then) = _$SiteActivityCopyWithImpl;
@useResult
$Res call({
 ActivitySite site, List<String> engineers, int staffCount, DayTotals updates, DateTime? lastActivityAt
});


$ActivitySiteCopyWith<$Res> get site;$DayTotalsCopyWith<$Res> get updates;

}
/// @nodoc
class _$SiteActivityCopyWithImpl<$Res>
    implements $SiteActivityCopyWith<$Res> {
  _$SiteActivityCopyWithImpl(this._self, this._then);

  final SiteActivity _self;
  final $Res Function(SiteActivity) _then;

/// Create a copy of SiteActivity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? site = null,Object? engineers = null,Object? staffCount = null,Object? updates = null,Object? lastActivityAt = freezed,}) {
  return _then(SiteActivity(
site: null == site ? _self.site : site // ignore: cast_nullable_to_non_nullable
as ActivitySite,engineers: null == engineers ? _self.engineers : engineers // ignore: cast_nullable_to_non_nullable
as List<String>,staffCount: null == staffCount ? _self.staffCount : staffCount // ignore: cast_nullable_to_non_nullable
as int,updates: null == updates ? _self.updates : updates // ignore: cast_nullable_to_non_nullable
as DayTotals,lastActivityAt: freezed == lastActivityAt ? _self.lastActivityAt : lastActivityAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}
/// Create a copy of SiteActivity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ActivitySiteCopyWith<$Res> get site {
  
  return $ActivitySiteCopyWith<$Res>(_self.site, (value) {
    return _then(_self.copyWith(site: value));
  });
}/// Create a copy of SiteActivity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DayTotalsCopyWith<$Res> get updates {
  
  return $DayTotalsCopyWith<$Res>(_self.updates, (value) {
    return _then(_self.copyWith(updates: value));
  });
}
}


/// Adds pattern-matching-related methods to [SiteActivity].
extension SiteActivityPatterns on SiteActivity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SiteActivity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SiteActivity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SiteActivity value)  $default,){
final _that = this;
switch (_that) {
case _SiteActivity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SiteActivity value)?  $default,){
final _that = this;
switch (_that) {
case _SiteActivity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ActivitySite site,  List<String> engineers,  int staffCount,  DayTotals updates,  DateTime? lastActivityAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SiteActivity() when $default != null:
return $default(_that.site,_that.engineers,_that.staffCount,_that.updates,_that.lastActivityAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ActivitySite site,  List<String> engineers,  int staffCount,  DayTotals updates,  DateTime? lastActivityAt)  $default,) {final _that = this;
switch (_that) {
case _SiteActivity():
return $default(_that.site,_that.engineers,_that.staffCount,_that.updates,_that.lastActivityAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ActivitySite site,  List<String> engineers,  int staffCount,  DayTotals updates,  DateTime? lastActivityAt)?  $default,) {final _that = this;
switch (_that) {
case _SiteActivity() when $default != null:
return $default(_that.site,_that.engineers,_that.staffCount,_that.updates,_that.lastActivityAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SiteActivity implements SiteActivity {
  const _SiteActivity({required this.site, required  List<String> engineers, required this.staffCount, required this.updates, this.lastActivityAt}): _engineers = engineers;
  factory _SiteActivity.fromJson(Map<String, dynamic> json) => _$SiteActivityFromJson(json);

@override final  ActivitySite site;
 final  List<String> _engineers;
@override List<String> get engineers {
  if (_engineers is EqualUnmodifiableListView) return _engineers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_engineers);
}

@override final  int staffCount;
@override final  DayTotals updates;
@override final  DateTime? lastActivityAt;

/// Create a copy of SiteActivity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SiteActivityCopyWith<_SiteActivity> get copyWith => __$SiteActivityCopyWithImpl<_SiteActivity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SiteActivityToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SiteActivity&&(identical(other.site, site) || other.site == site)&&const DeepCollectionEquality().equals(other.engineers, _engineers)&&(identical(other.staffCount, staffCount) || other.staffCount == staffCount)&&(identical(other.updates, updates) || other.updates == updates)&&(identical(other.lastActivityAt, lastActivityAt) || other.lastActivityAt == lastActivityAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,site,const DeepCollectionEquality().hash(_engineers),staffCount,updates,lastActivityAt);
}

@override
String toString() {
    return 'SiteActivity(site: $site, engineers: $engineers, staffCount: $staffCount, updates: $updates, lastActivityAt: $lastActivityAt)';
}


}

/// @nodoc
abstract mixin class _$SiteActivityCopyWith<$Res> implements $SiteActivityCopyWith<$Res> {
  factory _$SiteActivityCopyWith(_SiteActivity value, $Res Function(_SiteActivity) _then) = __$SiteActivityCopyWithImpl;
@override @useResult
$Res call({
 ActivitySite site, List<String> engineers, int staffCount, DayTotals updates, DateTime? lastActivityAt
});


@override $ActivitySiteCopyWith<$Res> get site;@override $DayTotalsCopyWith<$Res> get updates;

}
/// @nodoc
class __$SiteActivityCopyWithImpl<$Res>
    implements _$SiteActivityCopyWith<$Res> {
  __$SiteActivityCopyWithImpl(this._self, this._then);

  final _SiteActivity _self;
  final $Res Function(_SiteActivity) _then;

/// Create a copy of SiteActivity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? site = null,Object? engineers = null,Object? staffCount = null,Object? updates = null,Object? lastActivityAt = freezed,}) {
  return _then(_SiteActivity(
site: null == site ? _self.site : site // ignore: cast_nullable_to_non_nullable
as ActivitySite,engineers: null == engineers ? _self._engineers : engineers // ignore: cast_nullable_to_non_nullable
as List<String>,staffCount: null == staffCount ? _self.staffCount : staffCount // ignore: cast_nullable_to_non_nullable
as int,updates: null == updates ? _self.updates : updates // ignore: cast_nullable_to_non_nullable
as DayTotals,lastActivityAt: freezed == lastActivityAt ? _self.lastActivityAt : lastActivityAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

/// Create a copy of SiteActivity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ActivitySiteCopyWith<$Res> get site {
  
  return $ActivitySiteCopyWith<$Res>(_self.site, (value) {
    return _then(_self.copyWith(site: value));
  });
}/// Create a copy of SiteActivity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DayTotalsCopyWith<$Res> get updates {
  
  return $DayTotalsCopyWith<$Res>(_self.updates, (value) {
    return _then(_self.copyWith(updates: value));
  });
}
}


/// @nodoc
mixin _$AdminDashboard {

 String get date; bool get isWorkingDay; String? get holiday; DashboardCounts get counts; MoneyTotals get payments; DayTotals get updates;/// Staff photos no admin has looked at yet.
 int get toReview; IssueCounts get issues; List<AttentionItem> get attention; List<SiteActivity> get sites;
/// Create a copy of AdminDashboard
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdminDashboardCopyWith<AdminDashboard> get copyWith => _$AdminDashboardCopyWithImpl<AdminDashboard>(this as AdminDashboard, _$identity);

  /// Serializes this AdminDashboard to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AdminDashboard;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdminDashboard&&(identical(other.date, _this.date) || other.date == _this.date)&&(identical(other.isWorkingDay, _this.isWorkingDay) || other.isWorkingDay == _this.isWorkingDay)&&(identical(other.holiday, _this.holiday) || other.holiday == _this.holiday)&&(identical(other.counts, _this.counts) || other.counts == _this.counts)&&(identical(other.payments, _this.payments) || other.payments == _this.payments)&&(identical(other.updates, _this.updates) || other.updates == _this.updates)&&(identical(other.toReview, _this.toReview) || other.toReview == _this.toReview)&&(identical(other.issues, _this.issues) || other.issues == _this.issues)&&const DeepCollectionEquality().equals(other.attention, _this.attention)&&const DeepCollectionEquality().equals(other.sites, _this.sites));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AdminDashboard;
  return Object.hash(runtimeType,_this.date,_this.isWorkingDay,_this.holiday,_this.counts,_this.payments,_this.updates,_this.toReview,_this.issues,const DeepCollectionEquality().hash(_this.attention),const DeepCollectionEquality().hash(_this.sites));
}

@override
String toString() {
  final _this = this as AdminDashboard;
  return 'AdminDashboard(date: ${_this.date}, isWorkingDay: ${_this.isWorkingDay}, holiday: ${_this.holiday}, counts: ${_this.counts}, payments: ${_this.payments}, updates: ${_this.updates}, toReview: ${_this.toReview}, issues: ${_this.issues}, attention: ${_this.attention}, sites: ${_this.sites})';
}


}

/// @nodoc
abstract mixin class $AdminDashboardCopyWith<$Res>  {
  factory $AdminDashboardCopyWith(AdminDashboard value, $Res Function(AdminDashboard) _then) = _$AdminDashboardCopyWithImpl;
@useResult
$Res call({
 String date, bool isWorkingDay, String? holiday, DashboardCounts counts, MoneyTotals payments, DayTotals updates, int toReview, IssueCounts issues, List<AttentionItem> attention, List<SiteActivity> sites
});


$DashboardCountsCopyWith<$Res> get counts;$MoneyTotalsCopyWith<$Res> get payments;$DayTotalsCopyWith<$Res> get updates;$IssueCountsCopyWith<$Res> get issues;

}
/// @nodoc
class _$AdminDashboardCopyWithImpl<$Res>
    implements $AdminDashboardCopyWith<$Res> {
  _$AdminDashboardCopyWithImpl(this._self, this._then);

  final AdminDashboard _self;
  final $Res Function(AdminDashboard) _then;

/// Create a copy of AdminDashboard
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? date = null,Object? isWorkingDay = null,Object? holiday = freezed,Object? counts = null,Object? payments = null,Object? updates = null,Object? toReview = null,Object? issues = null,Object? attention = null,Object? sites = null,}) {
  return _then(AdminDashboard(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,isWorkingDay: null == isWorkingDay ? _self.isWorkingDay : isWorkingDay // ignore: cast_nullable_to_non_nullable
as bool,holiday: freezed == holiday ? _self.holiday : holiday // ignore: cast_nullable_to_non_nullable
as String?,counts: null == counts ? _self.counts : counts // ignore: cast_nullable_to_non_nullable
as DashboardCounts,payments: null == payments ? _self.payments : payments // ignore: cast_nullable_to_non_nullable
as MoneyTotals,updates: null == updates ? _self.updates : updates // ignore: cast_nullable_to_non_nullable
as DayTotals,toReview: null == toReview ? _self.toReview : toReview // ignore: cast_nullable_to_non_nullable
as int,issues: null == issues ? _self.issues : issues // ignore: cast_nullable_to_non_nullable
as IssueCounts,attention: null == attention ? _self.attention : attention // ignore: cast_nullable_to_non_nullable
as List<AttentionItem>,sites: null == sites ? _self.sites : sites // ignore: cast_nullable_to_non_nullable
as List<SiteActivity>,
  ));
}
/// Create a copy of AdminDashboard
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DashboardCountsCopyWith<$Res> get counts {
  
  return $DashboardCountsCopyWith<$Res>(_self.counts, (value) {
    return _then(_self.copyWith(counts: value));
  });
}/// Create a copy of AdminDashboard
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MoneyTotalsCopyWith<$Res> get payments {
  
  return $MoneyTotalsCopyWith<$Res>(_self.payments, (value) {
    return _then(_self.copyWith(payments: value));
  });
}/// Create a copy of AdminDashboard
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DayTotalsCopyWith<$Res> get updates {
  
  return $DayTotalsCopyWith<$Res>(_self.updates, (value) {
    return _then(_self.copyWith(updates: value));
  });
}/// Create a copy of AdminDashboard
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$IssueCountsCopyWith<$Res> get issues {
  
  return $IssueCountsCopyWith<$Res>(_self.issues, (value) {
    return _then(_self.copyWith(issues: value));
  });
}
}


/// Adds pattern-matching-related methods to [AdminDashboard].
extension AdminDashboardPatterns on AdminDashboard {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdminDashboard value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdminDashboard() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdminDashboard value)  $default,){
final _that = this;
switch (_that) {
case _AdminDashboard():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdminDashboard value)?  $default,){
final _that = this;
switch (_that) {
case _AdminDashboard() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String date,  bool isWorkingDay,  String? holiday,  DashboardCounts counts,  MoneyTotals payments,  DayTotals updates,  int toReview,  IssueCounts issues,  List<AttentionItem> attention,  List<SiteActivity> sites)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdminDashboard() when $default != null:
return $default(_that.date,_that.isWorkingDay,_that.holiday,_that.counts,_that.payments,_that.updates,_that.toReview,_that.issues,_that.attention,_that.sites);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String date,  bool isWorkingDay,  String? holiday,  DashboardCounts counts,  MoneyTotals payments,  DayTotals updates,  int toReview,  IssueCounts issues,  List<AttentionItem> attention,  List<SiteActivity> sites)  $default,) {final _that = this;
switch (_that) {
case _AdminDashboard():
return $default(_that.date,_that.isWorkingDay,_that.holiday,_that.counts,_that.payments,_that.updates,_that.toReview,_that.issues,_that.attention,_that.sites);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String date,  bool isWorkingDay,  String? holiday,  DashboardCounts counts,  MoneyTotals payments,  DayTotals updates,  int toReview,  IssueCounts issues,  List<AttentionItem> attention,  List<SiteActivity> sites)?  $default,) {final _that = this;
switch (_that) {
case _AdminDashboard() when $default != null:
return $default(_that.date,_that.isWorkingDay,_that.holiday,_that.counts,_that.payments,_that.updates,_that.toReview,_that.issues,_that.attention,_that.sites);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AdminDashboard implements AdminDashboard {
  const _AdminDashboard({required this.date, required this.isWorkingDay, this.holiday, required this.counts, required this.payments, required this.updates, this.toReview = 0, required this.issues, required  List<AttentionItem> attention, required  List<SiteActivity> sites}): _attention = attention,_sites = sites;
  factory _AdminDashboard.fromJson(Map<String, dynamic> json) => _$AdminDashboardFromJson(json);

@override final  String date;
@override final  bool isWorkingDay;
@override final  String? holiday;
@override final  DashboardCounts counts;
@override final  MoneyTotals payments;
@override final  DayTotals updates;
/// Staff photos no admin has looked at yet.
@override@JsonKey() final  int toReview;
@override final  IssueCounts issues;
 final  List<AttentionItem> _attention;
@override List<AttentionItem> get attention {
  if (_attention is EqualUnmodifiableListView) return _attention;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_attention);
}

 final  List<SiteActivity> _sites;
@override List<SiteActivity> get sites {
  if (_sites is EqualUnmodifiableListView) return _sites;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sites);
}


/// Create a copy of AdminDashboard
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdminDashboardCopyWith<_AdminDashboard> get copyWith => __$AdminDashboardCopyWithImpl<_AdminDashboard>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AdminDashboardToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdminDashboard&&(identical(other.date, date) || other.date == date)&&(identical(other.isWorkingDay, isWorkingDay) || other.isWorkingDay == isWorkingDay)&&(identical(other.holiday, holiday) || other.holiday == holiday)&&(identical(other.counts, counts) || other.counts == counts)&&(identical(other.payments, payments) || other.payments == payments)&&(identical(other.updates, updates) || other.updates == updates)&&(identical(other.toReview, toReview) || other.toReview == toReview)&&(identical(other.issues, issues) || other.issues == issues)&&const DeepCollectionEquality().equals(other.attention, _attention)&&const DeepCollectionEquality().equals(other.sites, _sites));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,date,isWorkingDay,holiday,counts,payments,updates,toReview,issues,const DeepCollectionEquality().hash(_attention),const DeepCollectionEquality().hash(_sites));
}

@override
String toString() {
    return 'AdminDashboard(date: $date, isWorkingDay: $isWorkingDay, holiday: $holiday, counts: $counts, payments: $payments, updates: $updates, toReview: $toReview, issues: $issues, attention: $attention, sites: $sites)';
}


}

/// @nodoc
abstract mixin class _$AdminDashboardCopyWith<$Res> implements $AdminDashboardCopyWith<$Res> {
  factory _$AdminDashboardCopyWith(_AdminDashboard value, $Res Function(_AdminDashboard) _then) = __$AdminDashboardCopyWithImpl;
@override @useResult
$Res call({
 String date, bool isWorkingDay, String? holiday, DashboardCounts counts, MoneyTotals payments, DayTotals updates, int toReview, IssueCounts issues, List<AttentionItem> attention, List<SiteActivity> sites
});


@override $DashboardCountsCopyWith<$Res> get counts;@override $MoneyTotalsCopyWith<$Res> get payments;@override $DayTotalsCopyWith<$Res> get updates;@override $IssueCountsCopyWith<$Res> get issues;

}
/// @nodoc
class __$AdminDashboardCopyWithImpl<$Res>
    implements _$AdminDashboardCopyWith<$Res> {
  __$AdminDashboardCopyWithImpl(this._self, this._then);

  final _AdminDashboard _self;
  final $Res Function(_AdminDashboard) _then;

/// Create a copy of AdminDashboard
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? date = null,Object? isWorkingDay = null,Object? holiday = freezed,Object? counts = null,Object? payments = null,Object? updates = null,Object? toReview = null,Object? issues = null,Object? attention = null,Object? sites = null,}) {
  return _then(_AdminDashboard(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,isWorkingDay: null == isWorkingDay ? _self.isWorkingDay : isWorkingDay // ignore: cast_nullable_to_non_nullable
as bool,holiday: freezed == holiday ? _self.holiday : holiday // ignore: cast_nullable_to_non_nullable
as String?,counts: null == counts ? _self.counts : counts // ignore: cast_nullable_to_non_nullable
as DashboardCounts,payments: null == payments ? _self.payments : payments // ignore: cast_nullable_to_non_nullable
as MoneyTotals,updates: null == updates ? _self.updates : updates // ignore: cast_nullable_to_non_nullable
as DayTotals,toReview: null == toReview ? _self.toReview : toReview // ignore: cast_nullable_to_non_nullable
as int,issues: null == issues ? _self.issues : issues // ignore: cast_nullable_to_non_nullable
as IssueCounts,attention: null == attention ? _self._attention : attention // ignore: cast_nullable_to_non_nullable
as List<AttentionItem>,sites: null == sites ? _self._sites : sites // ignore: cast_nullable_to_non_nullable
as List<SiteActivity>,
  ));
}

/// Create a copy of AdminDashboard
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DashboardCountsCopyWith<$Res> get counts {
  
  return $DashboardCountsCopyWith<$Res>(_self.counts, (value) {
    return _then(_self.copyWith(counts: value));
  });
}/// Create a copy of AdminDashboard
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MoneyTotalsCopyWith<$Res> get payments {
  
  return $MoneyTotalsCopyWith<$Res>(_self.payments, (value) {
    return _then(_self.copyWith(payments: value));
  });
}/// Create a copy of AdminDashboard
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DayTotalsCopyWith<$Res> get updates {
  
  return $DayTotalsCopyWith<$Res>(_self.updates, (value) {
    return _then(_self.copyWith(updates: value));
  });
}/// Create a copy of AdminDashboard
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$IssueCountsCopyWith<$Res> get issues {
  
  return $IssueCountsCopyWith<$Res>(_self.issues, (value) {
    return _then(_self.copyWith(issues: value));
  });
}
}


/// @nodoc
mixin _$EngineerDashboard {

 String get date; bool get isWorkingDay; String? get holiday; DayTotals get updates;/// Their staff's photos still waiting for their review.
 int get toReview; IssueCounts get issues; List<AttentionItem> get attention; List<SiteActivity> get sites;
/// Create a copy of EngineerDashboard
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EngineerDashboardCopyWith<EngineerDashboard> get copyWith => _$EngineerDashboardCopyWithImpl<EngineerDashboard>(this as EngineerDashboard, _$identity);

  /// Serializes this EngineerDashboard to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as EngineerDashboard;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EngineerDashboard&&(identical(other.date, _this.date) || other.date == _this.date)&&(identical(other.isWorkingDay, _this.isWorkingDay) || other.isWorkingDay == _this.isWorkingDay)&&(identical(other.holiday, _this.holiday) || other.holiday == _this.holiday)&&(identical(other.updates, _this.updates) || other.updates == _this.updates)&&(identical(other.toReview, _this.toReview) || other.toReview == _this.toReview)&&(identical(other.issues, _this.issues) || other.issues == _this.issues)&&const DeepCollectionEquality().equals(other.attention, _this.attention)&&const DeepCollectionEquality().equals(other.sites, _this.sites));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as EngineerDashboard;
  return Object.hash(runtimeType,_this.date,_this.isWorkingDay,_this.holiday,_this.updates,_this.toReview,_this.issues,const DeepCollectionEquality().hash(_this.attention),const DeepCollectionEquality().hash(_this.sites));
}

@override
String toString() {
  final _this = this as EngineerDashboard;
  return 'EngineerDashboard(date: ${_this.date}, isWorkingDay: ${_this.isWorkingDay}, holiday: ${_this.holiday}, updates: ${_this.updates}, toReview: ${_this.toReview}, issues: ${_this.issues}, attention: ${_this.attention}, sites: ${_this.sites})';
}


}

/// @nodoc
abstract mixin class $EngineerDashboardCopyWith<$Res>  {
  factory $EngineerDashboardCopyWith(EngineerDashboard value, $Res Function(EngineerDashboard) _then) = _$EngineerDashboardCopyWithImpl;
@useResult
$Res call({
 String date, bool isWorkingDay, String? holiday, DayTotals updates, int toReview, IssueCounts issues, List<AttentionItem> attention, List<SiteActivity> sites
});


$DayTotalsCopyWith<$Res> get updates;$IssueCountsCopyWith<$Res> get issues;

}
/// @nodoc
class _$EngineerDashboardCopyWithImpl<$Res>
    implements $EngineerDashboardCopyWith<$Res> {
  _$EngineerDashboardCopyWithImpl(this._self, this._then);

  final EngineerDashboard _self;
  final $Res Function(EngineerDashboard) _then;

/// Create a copy of EngineerDashboard
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? date = null,Object? isWorkingDay = null,Object? holiday = freezed,Object? updates = null,Object? toReview = null,Object? issues = null,Object? attention = null,Object? sites = null,}) {
  return _then(EngineerDashboard(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,isWorkingDay: null == isWorkingDay ? _self.isWorkingDay : isWorkingDay // ignore: cast_nullable_to_non_nullable
as bool,holiday: freezed == holiday ? _self.holiday : holiday // ignore: cast_nullable_to_non_nullable
as String?,updates: null == updates ? _self.updates : updates // ignore: cast_nullable_to_non_nullable
as DayTotals,toReview: null == toReview ? _self.toReview : toReview // ignore: cast_nullable_to_non_nullable
as int,issues: null == issues ? _self.issues : issues // ignore: cast_nullable_to_non_nullable
as IssueCounts,attention: null == attention ? _self.attention : attention // ignore: cast_nullable_to_non_nullable
as List<AttentionItem>,sites: null == sites ? _self.sites : sites // ignore: cast_nullable_to_non_nullable
as List<SiteActivity>,
  ));
}
/// Create a copy of EngineerDashboard
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DayTotalsCopyWith<$Res> get updates {
  
  return $DayTotalsCopyWith<$Res>(_self.updates, (value) {
    return _then(_self.copyWith(updates: value));
  });
}/// Create a copy of EngineerDashboard
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$IssueCountsCopyWith<$Res> get issues {
  
  return $IssueCountsCopyWith<$Res>(_self.issues, (value) {
    return _then(_self.copyWith(issues: value));
  });
}
}


/// Adds pattern-matching-related methods to [EngineerDashboard].
extension EngineerDashboardPatterns on EngineerDashboard {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EngineerDashboard value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EngineerDashboard() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EngineerDashboard value)  $default,){
final _that = this;
switch (_that) {
case _EngineerDashboard():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EngineerDashboard value)?  $default,){
final _that = this;
switch (_that) {
case _EngineerDashboard() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String date,  bool isWorkingDay,  String? holiday,  DayTotals updates,  int toReview,  IssueCounts issues,  List<AttentionItem> attention,  List<SiteActivity> sites)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EngineerDashboard() when $default != null:
return $default(_that.date,_that.isWorkingDay,_that.holiday,_that.updates,_that.toReview,_that.issues,_that.attention,_that.sites);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String date,  bool isWorkingDay,  String? holiday,  DayTotals updates,  int toReview,  IssueCounts issues,  List<AttentionItem> attention,  List<SiteActivity> sites)  $default,) {final _that = this;
switch (_that) {
case _EngineerDashboard():
return $default(_that.date,_that.isWorkingDay,_that.holiday,_that.updates,_that.toReview,_that.issues,_that.attention,_that.sites);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String date,  bool isWorkingDay,  String? holiday,  DayTotals updates,  int toReview,  IssueCounts issues,  List<AttentionItem> attention,  List<SiteActivity> sites)?  $default,) {final _that = this;
switch (_that) {
case _EngineerDashboard() when $default != null:
return $default(_that.date,_that.isWorkingDay,_that.holiday,_that.updates,_that.toReview,_that.issues,_that.attention,_that.sites);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EngineerDashboard implements EngineerDashboard {
  const _EngineerDashboard({required this.date, required this.isWorkingDay, this.holiday, required this.updates, required this.toReview, required this.issues, required  List<AttentionItem> attention, required  List<SiteActivity> sites}): _attention = attention,_sites = sites;
  factory _EngineerDashboard.fromJson(Map<String, dynamic> json) => _$EngineerDashboardFromJson(json);

@override final  String date;
@override final  bool isWorkingDay;
@override final  String? holiday;
@override final  DayTotals updates;
/// Their staff's photos still waiting for their review.
@override final  int toReview;
@override final  IssueCounts issues;
 final  List<AttentionItem> _attention;
@override List<AttentionItem> get attention {
  if (_attention is EqualUnmodifiableListView) return _attention;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_attention);
}

 final  List<SiteActivity> _sites;
@override List<SiteActivity> get sites {
  if (_sites is EqualUnmodifiableListView) return _sites;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sites);
}


/// Create a copy of EngineerDashboard
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EngineerDashboardCopyWith<_EngineerDashboard> get copyWith => __$EngineerDashboardCopyWithImpl<_EngineerDashboard>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EngineerDashboardToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _EngineerDashboard&&(identical(other.date, date) || other.date == date)&&(identical(other.isWorkingDay, isWorkingDay) || other.isWorkingDay == isWorkingDay)&&(identical(other.holiday, holiday) || other.holiday == holiday)&&(identical(other.updates, updates) || other.updates == updates)&&(identical(other.toReview, toReview) || other.toReview == toReview)&&(identical(other.issues, issues) || other.issues == issues)&&const DeepCollectionEquality().equals(other.attention, _attention)&&const DeepCollectionEquality().equals(other.sites, _sites));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,date,isWorkingDay,holiday,updates,toReview,issues,const DeepCollectionEquality().hash(_attention),const DeepCollectionEquality().hash(_sites));
}

@override
String toString() {
    return 'EngineerDashboard(date: $date, isWorkingDay: $isWorkingDay, holiday: $holiday, updates: $updates, toReview: $toReview, issues: $issues, attention: $attention, sites: $sites)';
}


}

/// @nodoc
abstract mixin class _$EngineerDashboardCopyWith<$Res> implements $EngineerDashboardCopyWith<$Res> {
  factory _$EngineerDashboardCopyWith(_EngineerDashboard value, $Res Function(_EngineerDashboard) _then) = __$EngineerDashboardCopyWithImpl;
@override @useResult
$Res call({
 String date, bool isWorkingDay, String? holiday, DayTotals updates, int toReview, IssueCounts issues, List<AttentionItem> attention, List<SiteActivity> sites
});


@override $DayTotalsCopyWith<$Res> get updates;@override $IssueCountsCopyWith<$Res> get issues;

}
/// @nodoc
class __$EngineerDashboardCopyWithImpl<$Res>
    implements _$EngineerDashboardCopyWith<$Res> {
  __$EngineerDashboardCopyWithImpl(this._self, this._then);

  final _EngineerDashboard _self;
  final $Res Function(_EngineerDashboard) _then;

/// Create a copy of EngineerDashboard
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? date = null,Object? isWorkingDay = null,Object? holiday = freezed,Object? updates = null,Object? toReview = null,Object? issues = null,Object? attention = null,Object? sites = null,}) {
  return _then(_EngineerDashboard(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,isWorkingDay: null == isWorkingDay ? _self.isWorkingDay : isWorkingDay // ignore: cast_nullable_to_non_nullable
as bool,holiday: freezed == holiday ? _self.holiday : holiday // ignore: cast_nullable_to_non_nullable
as String?,updates: null == updates ? _self.updates : updates // ignore: cast_nullable_to_non_nullable
as DayTotals,toReview: null == toReview ? _self.toReview : toReview // ignore: cast_nullable_to_non_nullable
as int,issues: null == issues ? _self.issues : issues // ignore: cast_nullable_to_non_nullable
as IssueCounts,attention: null == attention ? _self._attention : attention // ignore: cast_nullable_to_non_nullable
as List<AttentionItem>,sites: null == sites ? _self._sites : sites // ignore: cast_nullable_to_non_nullable
as List<SiteActivity>,
  ));
}

/// Create a copy of EngineerDashboard
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DayTotalsCopyWith<$Res> get updates {
  
  return $DayTotalsCopyWith<$Res>(_self.updates, (value) {
    return _then(_self.copyWith(updates: value));
  });
}/// Create a copy of EngineerDashboard
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$IssueCountsCopyWith<$Res> get issues {
  
  return $IssueCountsCopyWith<$Res>(_self.issues, (value) {
    return _then(_self.copyWith(issues: value));
  });
}
}

// dart format on
