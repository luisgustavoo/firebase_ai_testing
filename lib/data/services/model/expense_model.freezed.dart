// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'expense_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ExpenseModel {

 String? get estabelecimento; DateTime? get data; double? get valor; String? get categoria; String? get metodoPagamento;
/// Create a copy of ExpenseModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExpenseModelCopyWith<ExpenseModel> get copyWith => _$ExpenseModelCopyWithImpl<ExpenseModel>(this as ExpenseModel, _$identity);

  /// Serializes this ExpenseModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExpenseModel&&(identical(other.estabelecimento, estabelecimento) || other.estabelecimento == estabelecimento)&&(identical(other.data, data) || other.data == data)&&(identical(other.valor, valor) || other.valor == valor)&&(identical(other.categoria, categoria) || other.categoria == categoria)&&(identical(other.metodoPagamento, metodoPagamento) || other.metodoPagamento == metodoPagamento));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,estabelecimento,data,valor,categoria,metodoPagamento);

@override
String toString() {
  return 'ExpenseModel(estabelecimento: $estabelecimento, data: $data, valor: $valor, categoria: $categoria, metodoPagamento: $metodoPagamento)';
}


}

/// @nodoc
abstract mixin class $ExpenseModelCopyWith<$Res>  {
  factory $ExpenseModelCopyWith(ExpenseModel value, $Res Function(ExpenseModel) _then) = _$ExpenseModelCopyWithImpl;
@useResult
$Res call({
 String? estabelecimento, DateTime? data, double? valor, String? categoria, String? metodoPagamento
});




}
/// @nodoc
class _$ExpenseModelCopyWithImpl<$Res>
    implements $ExpenseModelCopyWith<$Res> {
  _$ExpenseModelCopyWithImpl(this._self, this._then);

  final ExpenseModel _self;
  final $Res Function(ExpenseModel) _then;

/// Create a copy of ExpenseModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? estabelecimento = freezed,Object? data = freezed,Object? valor = freezed,Object? categoria = freezed,Object? metodoPagamento = freezed,}) {
  return _then(_self.copyWith(
estabelecimento: freezed == estabelecimento ? _self.estabelecimento : estabelecimento // ignore: cast_nullable_to_non_nullable
as String?,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as DateTime?,valor: freezed == valor ? _self.valor : valor // ignore: cast_nullable_to_non_nullable
as double?,categoria: freezed == categoria ? _self.categoria : categoria // ignore: cast_nullable_to_non_nullable
as String?,metodoPagamento: freezed == metodoPagamento ? _self.metodoPagamento : metodoPagamento // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ExpenseModel].
extension ExpenseModelPatterns on ExpenseModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExpenseModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExpenseModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExpenseModel value)  $default,){
final _that = this;
switch (_that) {
case _ExpenseModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExpenseModel value)?  $default,){
final _that = this;
switch (_that) {
case _ExpenseModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? estabelecimento,  DateTime? data,  double? valor,  String? categoria,  String? metodoPagamento)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExpenseModel() when $default != null:
return $default(_that.estabelecimento,_that.data,_that.valor,_that.categoria,_that.metodoPagamento);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? estabelecimento,  DateTime? data,  double? valor,  String? categoria,  String? metodoPagamento)  $default,) {final _that = this;
switch (_that) {
case _ExpenseModel():
return $default(_that.estabelecimento,_that.data,_that.valor,_that.categoria,_that.metodoPagamento);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? estabelecimento,  DateTime? data,  double? valor,  String? categoria,  String? metodoPagamento)?  $default,) {final _that = this;
switch (_that) {
case _ExpenseModel() when $default != null:
return $default(_that.estabelecimento,_that.data,_that.valor,_that.categoria,_that.metodoPagamento);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ExpenseModel implements ExpenseModel {
  const _ExpenseModel({this.estabelecimento, this.data, this.valor, this.categoria, this.metodoPagamento});
  factory _ExpenseModel.fromJson(Map<String, dynamic> json) => _$ExpenseModelFromJson(json);

@override final  String? estabelecimento;
@override final  DateTime? data;
@override final  double? valor;
@override final  String? categoria;
@override final  String? metodoPagamento;

/// Create a copy of ExpenseModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExpenseModelCopyWith<_ExpenseModel> get copyWith => __$ExpenseModelCopyWithImpl<_ExpenseModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ExpenseModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExpenseModel&&(identical(other.estabelecimento, estabelecimento) || other.estabelecimento == estabelecimento)&&(identical(other.data, data) || other.data == data)&&(identical(other.valor, valor) || other.valor == valor)&&(identical(other.categoria, categoria) || other.categoria == categoria)&&(identical(other.metodoPagamento, metodoPagamento) || other.metodoPagamento == metodoPagamento));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,estabelecimento,data,valor,categoria,metodoPagamento);

@override
String toString() {
  return 'ExpenseModel(estabelecimento: $estabelecimento, data: $data, valor: $valor, categoria: $categoria, metodoPagamento: $metodoPagamento)';
}


}

/// @nodoc
abstract mixin class _$ExpenseModelCopyWith<$Res> implements $ExpenseModelCopyWith<$Res> {
  factory _$ExpenseModelCopyWith(_ExpenseModel value, $Res Function(_ExpenseModel) _then) = __$ExpenseModelCopyWithImpl;
@override @useResult
$Res call({
 String? estabelecimento, DateTime? data, double? valor, String? categoria, String? metodoPagamento
});




}
/// @nodoc
class __$ExpenseModelCopyWithImpl<$Res>
    implements _$ExpenseModelCopyWith<$Res> {
  __$ExpenseModelCopyWithImpl(this._self, this._then);

  final _ExpenseModel _self;
  final $Res Function(_ExpenseModel) _then;

/// Create a copy of ExpenseModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? estabelecimento = freezed,Object? data = freezed,Object? valor = freezed,Object? categoria = freezed,Object? metodoPagamento = freezed,}) {
  return _then(_ExpenseModel(
estabelecimento: freezed == estabelecimento ? _self.estabelecimento : estabelecimento // ignore: cast_nullable_to_non_nullable
as String?,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as DateTime?,valor: freezed == valor ? _self.valor : valor // ignore: cast_nullable_to_non_nullable
as double?,categoria: freezed == categoria ? _self.categoria : categoria // ignore: cast_nullable_to_non_nullable
as String?,metodoPagamento: freezed == metodoPagamento ? _self.metodoPagamento : metodoPagamento // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
