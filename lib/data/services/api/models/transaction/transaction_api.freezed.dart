// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transaction_api.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TransactionApiModel {

 String get id; String get userId; double get amount; String get transactionType; String get paymentType; DateTime get transactionDate; DateTime get createdAt; String? get categoryId; String? get description;
/// Create a copy of TransactionApiModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TransactionApiModelCopyWith<TransactionApiModel> get copyWith => _$TransactionApiModelCopyWithImpl<TransactionApiModel>(this as TransactionApiModel, _$identity);

  /// Serializes this TransactionApiModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TransactionApiModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.transactionType, transactionType) || other.transactionType == transactionType)&&(identical(other.paymentType, paymentType) || other.paymentType == paymentType)&&(identical(other.transactionDate, transactionDate) || other.transactionDate == transactionDate)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,amount,transactionType,paymentType,transactionDate,createdAt,categoryId,description);

@override
String toString() {
  return 'TransactionApiModel(id: $id, userId: $userId, amount: $amount, transactionType: $transactionType, paymentType: $paymentType, transactionDate: $transactionDate, createdAt: $createdAt, categoryId: $categoryId, description: $description)';
}


}

/// @nodoc
abstract mixin class $TransactionApiModelCopyWith<$Res>  {
  factory $TransactionApiModelCopyWith(TransactionApiModel value, $Res Function(TransactionApiModel) _then) = _$TransactionApiModelCopyWithImpl;
@useResult
$Res call({
 String id, String userId, double amount, String transactionType, String paymentType, DateTime transactionDate, DateTime createdAt, String? categoryId, String? description
});




}
/// @nodoc
class _$TransactionApiModelCopyWithImpl<$Res>
    implements $TransactionApiModelCopyWith<$Res> {
  _$TransactionApiModelCopyWithImpl(this._self, this._then);

  final TransactionApiModel _self;
  final $Res Function(TransactionApiModel) _then;

/// Create a copy of TransactionApiModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? amount = null,Object? transactionType = null,Object? paymentType = null,Object? transactionDate = null,Object? createdAt = null,Object? categoryId = freezed,Object? description = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,transactionType: null == transactionType ? _self.transactionType : transactionType // ignore: cast_nullable_to_non_nullable
as String,paymentType: null == paymentType ? _self.paymentType : paymentType // ignore: cast_nullable_to_non_nullable
as String,transactionDate: null == transactionDate ? _self.transactionDate : transactionDate // ignore: cast_nullable_to_non_nullable
as DateTime,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [TransactionApiModel].
extension TransactionApiModelPatterns on TransactionApiModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TransactionApiModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TransactionApiModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TransactionApiModel value)  $default,){
final _that = this;
switch (_that) {
case _TransactionApiModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TransactionApiModel value)?  $default,){
final _that = this;
switch (_that) {
case _TransactionApiModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userId,  double amount,  String transactionType,  String paymentType,  DateTime transactionDate,  DateTime createdAt,  String? categoryId,  String? description)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TransactionApiModel() when $default != null:
return $default(_that.id,_that.userId,_that.amount,_that.transactionType,_that.paymentType,_that.transactionDate,_that.createdAt,_that.categoryId,_that.description);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userId,  double amount,  String transactionType,  String paymentType,  DateTime transactionDate,  DateTime createdAt,  String? categoryId,  String? description)  $default,) {final _that = this;
switch (_that) {
case _TransactionApiModel():
return $default(_that.id,_that.userId,_that.amount,_that.transactionType,_that.paymentType,_that.transactionDate,_that.createdAt,_that.categoryId,_that.description);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userId,  double amount,  String transactionType,  String paymentType,  DateTime transactionDate,  DateTime createdAt,  String? categoryId,  String? description)?  $default,) {final _that = this;
switch (_that) {
case _TransactionApiModel() when $default != null:
return $default(_that.id,_that.userId,_that.amount,_that.transactionType,_that.paymentType,_that.transactionDate,_that.createdAt,_that.categoryId,_that.description);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TransactionApiModel implements TransactionApiModel {
  const _TransactionApiModel({required this.id, required this.userId, required this.amount, required this.transactionType, required this.paymentType, required this.transactionDate, required this.createdAt, this.categoryId, this.description});
  factory _TransactionApiModel.fromJson(Map<String, dynamic> json) => _$TransactionApiModelFromJson(json);

@override final  String id;
@override final  String userId;
@override final  double amount;
@override final  String transactionType;
@override final  String paymentType;
@override final  DateTime transactionDate;
@override final  DateTime createdAt;
@override final  String? categoryId;
@override final  String? description;

/// Create a copy of TransactionApiModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TransactionApiModelCopyWith<_TransactionApiModel> get copyWith => __$TransactionApiModelCopyWithImpl<_TransactionApiModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TransactionApiModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TransactionApiModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.transactionType, transactionType) || other.transactionType == transactionType)&&(identical(other.paymentType, paymentType) || other.paymentType == paymentType)&&(identical(other.transactionDate, transactionDate) || other.transactionDate == transactionDate)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,amount,transactionType,paymentType,transactionDate,createdAt,categoryId,description);

@override
String toString() {
  return 'TransactionApiModel(id: $id, userId: $userId, amount: $amount, transactionType: $transactionType, paymentType: $paymentType, transactionDate: $transactionDate, createdAt: $createdAt, categoryId: $categoryId, description: $description)';
}


}

/// @nodoc
abstract mixin class _$TransactionApiModelCopyWith<$Res> implements $TransactionApiModelCopyWith<$Res> {
  factory _$TransactionApiModelCopyWith(_TransactionApiModel value, $Res Function(_TransactionApiModel) _then) = __$TransactionApiModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, double amount, String transactionType, String paymentType, DateTime transactionDate, DateTime createdAt, String? categoryId, String? description
});




}
/// @nodoc
class __$TransactionApiModelCopyWithImpl<$Res>
    implements _$TransactionApiModelCopyWith<$Res> {
  __$TransactionApiModelCopyWithImpl(this._self, this._then);

  final _TransactionApiModel _self;
  final $Res Function(_TransactionApiModel) _then;

/// Create a copy of TransactionApiModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? amount = null,Object? transactionType = null,Object? paymentType = null,Object? transactionDate = null,Object? createdAt = null,Object? categoryId = freezed,Object? description = freezed,}) {
  return _then(_TransactionApiModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,transactionType: null == transactionType ? _self.transactionType : transactionType // ignore: cast_nullable_to_non_nullable
as String,paymentType: null == paymentType ? _self.paymentType : paymentType // ignore: cast_nullable_to_non_nullable
as String,transactionDate: null == transactionDate ? _self.transactionDate : transactionDate // ignore: cast_nullable_to_non_nullable
as DateTime,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
