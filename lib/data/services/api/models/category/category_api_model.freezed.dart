// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'category_api_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CategoryApiModel {

 String get id; String get userId; String get description; bool get isDefault; DateTime get createdAt; DateTime get updatedAt; String? get icon;
/// Create a copy of CategoryApiModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CategoryApiModelCopyWith<CategoryApiModel> get copyWith => _$CategoryApiModelCopyWithImpl<CategoryApiModel>(this as CategoryApiModel, _$identity);

  /// Serializes this CategoryApiModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CategoryApiModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.description, description) || other.description == description)&&(identical(other.isDefault, isDefault) || other.isDefault == isDefault)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.icon, icon) || other.icon == icon));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,description,isDefault,createdAt,updatedAt,icon);

@override
String toString() {
  return 'CategoryApiModel(id: $id, userId: $userId, description: $description, isDefault: $isDefault, createdAt: $createdAt, updatedAt: $updatedAt, icon: $icon)';
}


}

/// @nodoc
abstract mixin class $CategoryApiModelCopyWith<$Res>  {
  factory $CategoryApiModelCopyWith(CategoryApiModel value, $Res Function(CategoryApiModel) _then) = _$CategoryApiModelCopyWithImpl;
@useResult
$Res call({
 String id, String userId, String description, bool isDefault, DateTime createdAt, DateTime updatedAt, String? icon
});




}
/// @nodoc
class _$CategoryApiModelCopyWithImpl<$Res>
    implements $CategoryApiModelCopyWith<$Res> {
  _$CategoryApiModelCopyWithImpl(this._self, this._then);

  final CategoryApiModel _self;
  final $Res Function(CategoryApiModel) _then;

/// Create a copy of CategoryApiModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? description = null,Object? isDefault = null,Object? createdAt = null,Object? updatedAt = null,Object? icon = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,isDefault: null == isDefault ? _self.isDefault : isDefault // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,icon: freezed == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CategoryApiModel].
extension CategoryApiModelPatterns on CategoryApiModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CategoryApiModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CategoryApiModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CategoryApiModel value)  $default,){
final _that = this;
switch (_that) {
case _CategoryApiModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CategoryApiModel value)?  $default,){
final _that = this;
switch (_that) {
case _CategoryApiModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userId,  String description,  bool isDefault,  DateTime createdAt,  DateTime updatedAt,  String? icon)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CategoryApiModel() when $default != null:
return $default(_that.id,_that.userId,_that.description,_that.isDefault,_that.createdAt,_that.updatedAt,_that.icon);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userId,  String description,  bool isDefault,  DateTime createdAt,  DateTime updatedAt,  String? icon)  $default,) {final _that = this;
switch (_that) {
case _CategoryApiModel():
return $default(_that.id,_that.userId,_that.description,_that.isDefault,_that.createdAt,_that.updatedAt,_that.icon);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userId,  String description,  bool isDefault,  DateTime createdAt,  DateTime updatedAt,  String? icon)?  $default,) {final _that = this;
switch (_that) {
case _CategoryApiModel() when $default != null:
return $default(_that.id,_that.userId,_that.description,_that.isDefault,_that.createdAt,_that.updatedAt,_that.icon);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CategoryApiModel implements CategoryApiModel {
  const _CategoryApiModel({required this.id, required this.userId, required this.description, required this.isDefault, required this.createdAt, required this.updatedAt, this.icon});
  factory _CategoryApiModel.fromJson(Map<String, dynamic> json) => _$CategoryApiModelFromJson(json);

@override final  String id;
@override final  String userId;
@override final  String description;
@override final  bool isDefault;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;
@override final  String? icon;

/// Create a copy of CategoryApiModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CategoryApiModelCopyWith<_CategoryApiModel> get copyWith => __$CategoryApiModelCopyWithImpl<_CategoryApiModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CategoryApiModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CategoryApiModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.description, description) || other.description == description)&&(identical(other.isDefault, isDefault) || other.isDefault == isDefault)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.icon, icon) || other.icon == icon));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,description,isDefault,createdAt,updatedAt,icon);

@override
String toString() {
  return 'CategoryApiModel(id: $id, userId: $userId, description: $description, isDefault: $isDefault, createdAt: $createdAt, updatedAt: $updatedAt, icon: $icon)';
}


}

/// @nodoc
abstract mixin class _$CategoryApiModelCopyWith<$Res> implements $CategoryApiModelCopyWith<$Res> {
  factory _$CategoryApiModelCopyWith(_CategoryApiModel value, $Res Function(_CategoryApiModel) _then) = __$CategoryApiModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, String description, bool isDefault, DateTime createdAt, DateTime updatedAt, String? icon
});




}
/// @nodoc
class __$CategoryApiModelCopyWithImpl<$Res>
    implements _$CategoryApiModelCopyWith<$Res> {
  __$CategoryApiModelCopyWithImpl(this._self, this._then);

  final _CategoryApiModel _self;
  final $Res Function(_CategoryApiModel) _then;

/// Create a copy of CategoryApiModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? description = null,Object? isDefault = null,Object? createdAt = null,Object? updatedAt = null,Object? icon = freezed,}) {
  return _then(_CategoryApiModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,isDefault: null == isDefault ? _self.isDefault : isDefault // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,icon: freezed == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
