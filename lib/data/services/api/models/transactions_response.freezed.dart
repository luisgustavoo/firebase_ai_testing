// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transactions_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TransactionsResponse {

 List<TransactionApi> get transactions; PaginationMetadata get pagination;
/// Create a copy of TransactionsResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TransactionsResponseCopyWith<TransactionsResponse> get copyWith => _$TransactionsResponseCopyWithImpl<TransactionsResponse>(this as TransactionsResponse, _$identity);

  /// Serializes this TransactionsResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TransactionsResponse&&const DeepCollectionEquality().equals(other.transactions, transactions)&&(identical(other.pagination, pagination) || other.pagination == pagination));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(transactions),pagination);

@override
String toString() {
  return 'TransactionsResponse(transactions: $transactions, pagination: $pagination)';
}


}

/// @nodoc
abstract mixin class $TransactionsResponseCopyWith<$Res>  {
  factory $TransactionsResponseCopyWith(TransactionsResponse value, $Res Function(TransactionsResponse) _then) = _$TransactionsResponseCopyWithImpl;
@useResult
$Res call({
 List<TransactionApi> transactions, PaginationMetadata pagination
});


$PaginationMetadataCopyWith<$Res> get pagination;

}
/// @nodoc
class _$TransactionsResponseCopyWithImpl<$Res>
    implements $TransactionsResponseCopyWith<$Res> {
  _$TransactionsResponseCopyWithImpl(this._self, this._then);

  final TransactionsResponse _self;
  final $Res Function(TransactionsResponse) _then;

/// Create a copy of TransactionsResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? transactions = null,Object? pagination = null,}) {
  return _then(_self.copyWith(
transactions: null == transactions ? _self.transactions : transactions // ignore: cast_nullable_to_non_nullable
as List<TransactionApi>,pagination: null == pagination ? _self.pagination : pagination // ignore: cast_nullable_to_non_nullable
as PaginationMetadata,
  ));
}
/// Create a copy of TransactionsResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PaginationMetadataCopyWith<$Res> get pagination {
  
  return $PaginationMetadataCopyWith<$Res>(_self.pagination, (value) {
    return _then(_self.copyWith(pagination: value));
  });
}
}


/// Adds pattern-matching-related methods to [TransactionsResponse].
extension TransactionsResponsePatterns on TransactionsResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TransactionsResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TransactionsResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TransactionsResponse value)  $default,){
final _that = this;
switch (_that) {
case _TransactionsResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TransactionsResponse value)?  $default,){
final _that = this;
switch (_that) {
case _TransactionsResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<TransactionApi> transactions,  PaginationMetadata pagination)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TransactionsResponse() when $default != null:
return $default(_that.transactions,_that.pagination);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<TransactionApi> transactions,  PaginationMetadata pagination)  $default,) {final _that = this;
switch (_that) {
case _TransactionsResponse():
return $default(_that.transactions,_that.pagination);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<TransactionApi> transactions,  PaginationMetadata pagination)?  $default,) {final _that = this;
switch (_that) {
case _TransactionsResponse() when $default != null:
return $default(_that.transactions,_that.pagination);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TransactionsResponse implements TransactionsResponse {
  const _TransactionsResponse({required final  List<TransactionApi> transactions, required this.pagination}): _transactions = transactions;
  factory _TransactionsResponse.fromJson(Map<String, dynamic> json) => _$TransactionsResponseFromJson(json);

 final  List<TransactionApi> _transactions;
@override List<TransactionApi> get transactions {
  if (_transactions is EqualUnmodifiableListView) return _transactions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_transactions);
}

@override final  PaginationMetadata pagination;

/// Create a copy of TransactionsResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TransactionsResponseCopyWith<_TransactionsResponse> get copyWith => __$TransactionsResponseCopyWithImpl<_TransactionsResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TransactionsResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TransactionsResponse&&const DeepCollectionEquality().equals(other._transactions, _transactions)&&(identical(other.pagination, pagination) || other.pagination == pagination));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_transactions),pagination);

@override
String toString() {
  return 'TransactionsResponse(transactions: $transactions, pagination: $pagination)';
}


}

/// @nodoc
abstract mixin class _$TransactionsResponseCopyWith<$Res> implements $TransactionsResponseCopyWith<$Res> {
  factory _$TransactionsResponseCopyWith(_TransactionsResponse value, $Res Function(_TransactionsResponse) _then) = __$TransactionsResponseCopyWithImpl;
@override @useResult
$Res call({
 List<TransactionApi> transactions, PaginationMetadata pagination
});


@override $PaginationMetadataCopyWith<$Res> get pagination;

}
/// @nodoc
class __$TransactionsResponseCopyWithImpl<$Res>
    implements _$TransactionsResponseCopyWith<$Res> {
  __$TransactionsResponseCopyWithImpl(this._self, this._then);

  final _TransactionsResponse _self;
  final $Res Function(_TransactionsResponse) _then;

/// Create a copy of TransactionsResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? transactions = null,Object? pagination = null,}) {
  return _then(_TransactionsResponse(
transactions: null == transactions ? _self._transactions : transactions // ignore: cast_nullable_to_non_nullable
as List<TransactionApi>,pagination: null == pagination ? _self.pagination : pagination // ignore: cast_nullable_to_non_nullable
as PaginationMetadata,
  ));
}

/// Create a copy of TransactionsResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PaginationMetadataCopyWith<$Res> get pagination {
  
  return $PaginationMetadataCopyWith<$Res>(_self.pagination, (value) {
    return _then(_self.copyWith(pagination: value));
  });
}
}

// dart format on
