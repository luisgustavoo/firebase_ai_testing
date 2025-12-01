// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_transaction_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CreateTransactionRequest {

 String? get categoryId; double get amount; String? get description; String get transactionType; String get paymentType; DateTime get transactionDate;
/// Create a copy of CreateTransactionRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateTransactionRequestCopyWith<CreateTransactionRequest> get copyWith => _$CreateTransactionRequestCopyWithImpl<CreateTransactionRequest>(this as CreateTransactionRequest, _$identity);

  /// Serializes this CreateTransactionRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateTransactionRequest&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.description, description) || other.description == description)&&(identical(other.transactionType, transactionType) || other.transactionType == transactionType)&&(identical(other.paymentType, paymentType) || other.paymentType == paymentType)&&(identical(other.transactionDate, transactionDate) || other.transactionDate == transactionDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,categoryId,amount,description,transactionType,paymentType,transactionDate);

@override
String toString() {
  return 'CreateTransactionRequest(categoryId: $categoryId, amount: $amount, description: $description, transactionType: $transactionType, paymentType: $paymentType, transactionDate: $transactionDate)';
}


}

/// @nodoc
abstract mixin class $CreateTransactionRequestCopyWith<$Res>  {
  factory $CreateTransactionRequestCopyWith(CreateTransactionRequest value, $Res Function(CreateTransactionRequest) _then) = _$CreateTransactionRequestCopyWithImpl;
@useResult
$Res call({
 String? categoryId, double amount, String? description, String transactionType, String paymentType, DateTime transactionDate
});




}
/// @nodoc
class _$CreateTransactionRequestCopyWithImpl<$Res>
    implements $CreateTransactionRequestCopyWith<$Res> {
  _$CreateTransactionRequestCopyWithImpl(this._self, this._then);

  final CreateTransactionRequest _self;
  final $Res Function(CreateTransactionRequest) _then;

/// Create a copy of CreateTransactionRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? categoryId = freezed,Object? amount = null,Object? description = freezed,Object? transactionType = null,Object? paymentType = null,Object? transactionDate = null,}) {
  return _then(_self.copyWith(
categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,transactionType: null == transactionType ? _self.transactionType : transactionType // ignore: cast_nullable_to_non_nullable
as String,paymentType: null == paymentType ? _self.paymentType : paymentType // ignore: cast_nullable_to_non_nullable
as String,transactionDate: null == transactionDate ? _self.transactionDate : transactionDate // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [CreateTransactionRequest].
extension CreateTransactionRequestPatterns on CreateTransactionRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreateTransactionRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreateTransactionRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreateTransactionRequest value)  $default,){
final _that = this;
switch (_that) {
case _CreateTransactionRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreateTransactionRequest value)?  $default,){
final _that = this;
switch (_that) {
case _CreateTransactionRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? categoryId,  double amount,  String? description,  String transactionType,  String paymentType,  DateTime transactionDate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreateTransactionRequest() when $default != null:
return $default(_that.categoryId,_that.amount,_that.description,_that.transactionType,_that.paymentType,_that.transactionDate);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? categoryId,  double amount,  String? description,  String transactionType,  String paymentType,  DateTime transactionDate)  $default,) {final _that = this;
switch (_that) {
case _CreateTransactionRequest():
return $default(_that.categoryId,_that.amount,_that.description,_that.transactionType,_that.paymentType,_that.transactionDate);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? categoryId,  double amount,  String? description,  String transactionType,  String paymentType,  DateTime transactionDate)?  $default,) {final _that = this;
switch (_that) {
case _CreateTransactionRequest() when $default != null:
return $default(_that.categoryId,_that.amount,_that.description,_that.transactionType,_that.paymentType,_that.transactionDate);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CreateTransactionRequest implements CreateTransactionRequest {
  const _CreateTransactionRequest({this.categoryId, required this.amount, this.description, required this.transactionType, required this.paymentType, required this.transactionDate});
  factory _CreateTransactionRequest.fromJson(Map<String, dynamic> json) => _$CreateTransactionRequestFromJson(json);

@override final  String? categoryId;
@override final  double amount;
@override final  String? description;
@override final  String transactionType;
@override final  String paymentType;
@override final  DateTime transactionDate;

/// Create a copy of CreateTransactionRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateTransactionRequestCopyWith<_CreateTransactionRequest> get copyWith => __$CreateTransactionRequestCopyWithImpl<_CreateTransactionRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreateTransactionRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateTransactionRequest&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.description, description) || other.description == description)&&(identical(other.transactionType, transactionType) || other.transactionType == transactionType)&&(identical(other.paymentType, paymentType) || other.paymentType == paymentType)&&(identical(other.transactionDate, transactionDate) || other.transactionDate == transactionDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,categoryId,amount,description,transactionType,paymentType,transactionDate);

@override
String toString() {
  return 'CreateTransactionRequest(categoryId: $categoryId, amount: $amount, description: $description, transactionType: $transactionType, paymentType: $paymentType, transactionDate: $transactionDate)';
}


}

/// @nodoc
abstract mixin class _$CreateTransactionRequestCopyWith<$Res> implements $CreateTransactionRequestCopyWith<$Res> {
  factory _$CreateTransactionRequestCopyWith(_CreateTransactionRequest value, $Res Function(_CreateTransactionRequest) _then) = __$CreateTransactionRequestCopyWithImpl;
@override @useResult
$Res call({
 String? categoryId, double amount, String? description, String transactionType, String paymentType, DateTime transactionDate
});




}
/// @nodoc
class __$CreateTransactionRequestCopyWithImpl<$Res>
    implements _$CreateTransactionRequestCopyWith<$Res> {
  __$CreateTransactionRequestCopyWithImpl(this._self, this._then);

  final _CreateTransactionRequest _self;
  final $Res Function(_CreateTransactionRequest) _then;

/// Create a copy of CreateTransactionRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? categoryId = freezed,Object? amount = null,Object? description = freezed,Object? transactionType = null,Object? paymentType = null,Object? transactionDate = null,}) {
  return _then(_CreateTransactionRequest(
categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,transactionType: null == transactionType ? _self.transactionType : transactionType // ignore: cast_nullable_to_non_nullable
as String,paymentType: null == paymentType ? _self.paymentType : paymentType // ignore: cast_nullable_to_non_nullable
as String,transactionDate: null == transactionDate ? _self.transactionDate : transactionDate // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
