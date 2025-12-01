// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ai_extracted_expense.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AiExtractedExpense {

 double? get amount; String? get transactionType; String? get paymentType; String? get transactionDate; String? get categoryId; String? get description;
/// Create a copy of AiExtractedExpense
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AiExtractedExpenseCopyWith<AiExtractedExpense> get copyWith => _$AiExtractedExpenseCopyWithImpl<AiExtractedExpense>(this as AiExtractedExpense, _$identity);

  /// Serializes this AiExtractedExpense to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AiExtractedExpense&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.transactionType, transactionType) || other.transactionType == transactionType)&&(identical(other.paymentType, paymentType) || other.paymentType == paymentType)&&(identical(other.transactionDate, transactionDate) || other.transactionDate == transactionDate)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,amount,transactionType,paymentType,transactionDate,categoryId,description);

@override
String toString() {
  return 'AiExtractedExpense(amount: $amount, transactionType: $transactionType, paymentType: $paymentType, transactionDate: $transactionDate, categoryId: $categoryId, description: $description)';
}


}

/// @nodoc
abstract mixin class $AiExtractedExpenseCopyWith<$Res>  {
  factory $AiExtractedExpenseCopyWith(AiExtractedExpense value, $Res Function(AiExtractedExpense) _then) = _$AiExtractedExpenseCopyWithImpl;
@useResult
$Res call({
 double? amount, String? transactionType, String? paymentType, String? transactionDate, String? categoryId, String? description
});




}
/// @nodoc
class _$AiExtractedExpenseCopyWithImpl<$Res>
    implements $AiExtractedExpenseCopyWith<$Res> {
  _$AiExtractedExpenseCopyWithImpl(this._self, this._then);

  final AiExtractedExpense _self;
  final $Res Function(AiExtractedExpense) _then;

/// Create a copy of AiExtractedExpense
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? amount = freezed,Object? transactionType = freezed,Object? paymentType = freezed,Object? transactionDate = freezed,Object? categoryId = freezed,Object? description = freezed,}) {
  return _then(_self.copyWith(
amount: freezed == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double?,transactionType: freezed == transactionType ? _self.transactionType : transactionType // ignore: cast_nullable_to_non_nullable
as String?,paymentType: freezed == paymentType ? _self.paymentType : paymentType // ignore: cast_nullable_to_non_nullable
as String?,transactionDate: freezed == transactionDate ? _self.transactionDate : transactionDate // ignore: cast_nullable_to_non_nullable
as String?,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AiExtractedExpense].
extension AiExtractedExpensePatterns on AiExtractedExpense {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AiExtractedExpense value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AiExtractedExpense() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AiExtractedExpense value)  $default,){
final _that = this;
switch (_that) {
case _AiExtractedExpense():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AiExtractedExpense value)?  $default,){
final _that = this;
switch (_that) {
case _AiExtractedExpense() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double? amount,  String? transactionType,  String? paymentType,  String? transactionDate,  String? categoryId,  String? description)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AiExtractedExpense() when $default != null:
return $default(_that.amount,_that.transactionType,_that.paymentType,_that.transactionDate,_that.categoryId,_that.description);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double? amount,  String? transactionType,  String? paymentType,  String? transactionDate,  String? categoryId,  String? description)  $default,) {final _that = this;
switch (_that) {
case _AiExtractedExpense():
return $default(_that.amount,_that.transactionType,_that.paymentType,_that.transactionDate,_that.categoryId,_that.description);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double? amount,  String? transactionType,  String? paymentType,  String? transactionDate,  String? categoryId,  String? description)?  $default,) {final _that = this;
switch (_that) {
case _AiExtractedExpense() when $default != null:
return $default(_that.amount,_that.transactionType,_that.paymentType,_that.transactionDate,_that.categoryId,_that.description);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AiExtractedExpense implements AiExtractedExpense {
  const _AiExtractedExpense({this.amount, this.transactionType, this.paymentType, this.transactionDate, this.categoryId, this.description});
  factory _AiExtractedExpense.fromJson(Map<String, dynamic> json) => _$AiExtractedExpenseFromJson(json);

@override final  double? amount;
@override final  String? transactionType;
@override final  String? paymentType;
@override final  String? transactionDate;
@override final  String? categoryId;
@override final  String? description;

/// Create a copy of AiExtractedExpense
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AiExtractedExpenseCopyWith<_AiExtractedExpense> get copyWith => __$AiExtractedExpenseCopyWithImpl<_AiExtractedExpense>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AiExtractedExpenseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AiExtractedExpense&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.transactionType, transactionType) || other.transactionType == transactionType)&&(identical(other.paymentType, paymentType) || other.paymentType == paymentType)&&(identical(other.transactionDate, transactionDate) || other.transactionDate == transactionDate)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,amount,transactionType,paymentType,transactionDate,categoryId,description);

@override
String toString() {
  return 'AiExtractedExpense(amount: $amount, transactionType: $transactionType, paymentType: $paymentType, transactionDate: $transactionDate, categoryId: $categoryId, description: $description)';
}


}

/// @nodoc
abstract mixin class _$AiExtractedExpenseCopyWith<$Res> implements $AiExtractedExpenseCopyWith<$Res> {
  factory _$AiExtractedExpenseCopyWith(_AiExtractedExpense value, $Res Function(_AiExtractedExpense) _then) = __$AiExtractedExpenseCopyWithImpl;
@override @useResult
$Res call({
 double? amount, String? transactionType, String? paymentType, String? transactionDate, String? categoryId, String? description
});




}
/// @nodoc
class __$AiExtractedExpenseCopyWithImpl<$Res>
    implements _$AiExtractedExpenseCopyWith<$Res> {
  __$AiExtractedExpenseCopyWithImpl(this._self, this._then);

  final _AiExtractedExpense _self;
  final $Res Function(_AiExtractedExpense) _then;

/// Create a copy of AiExtractedExpense
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? amount = freezed,Object? transactionType = freezed,Object? paymentType = freezed,Object? transactionDate = freezed,Object? categoryId = freezed,Object? description = freezed,}) {
  return _then(_AiExtractedExpense(
amount: freezed == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double?,transactionType: freezed == transactionType ? _self.transactionType : transactionType // ignore: cast_nullable_to_non_nullable
as String?,paymentType: freezed == paymentType ? _self.paymentType : paymentType // ignore: cast_nullable_to_non_nullable
as String?,transactionDate: freezed == transactionDate ? _self.transactionDate : transactionDate // ignore: cast_nullable_to_non_nullable
as String?,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
