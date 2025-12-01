// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'category_api.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CategoryApi {

 String get id; String get userId; String get description; String? get icon; bool get isDefault; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of CategoryApi
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CategoryApiCopyWith<CategoryApi> get copyWith => _$CategoryApiCopyWithImpl<CategoryApi>(this as CategoryApi, _$identity);

  /// Serializes this CategoryApi to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CategoryApi&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.description, description) || other.description == description)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.isDefault, isDefault) || other.isDefault == isDefault)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,description,icon,isDefault,createdAt,updatedAt);

@override
String toString() {
  return 'CategoryApi(id: $id, userId: $userId, description: $description, icon: $icon, isDefault: $isDefault, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $CategoryApiCopyWith<$Res>  {
  factory $CategoryApiCopyWith(CategoryApi value, $Res Function(CategoryApi) _then) = _$CategoryApiCopyWithImpl;
@useResult
$Res call({
 String id, String userId, String description, String? icon, bool isDefault, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$CategoryApiCopyWithImpl<$Res>
    implements $CategoryApiCopyWith<$Res> {
  _$CategoryApiCopyWithImpl(this._self, this._then);

  final CategoryApi _self;
  final $Res Function(CategoryApi) _then;

/// Create a copy of CategoryApi
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? description = null,Object? icon = freezed,Object? isDefault = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,icon: freezed == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String?,isDefault: null == isDefault ? _self.isDefault : isDefault // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [CategoryApi].
extension CategoryApiPatterns on CategoryApi {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CategoryApi value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CategoryApi() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CategoryApi value)  $default,){
final _that = this;
switch (_that) {
case _CategoryApi():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CategoryApi value)?  $default,){
final _that = this;
switch (_that) {
case _CategoryApi() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userId,  String description,  String? icon,  bool isDefault,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CategoryApi() when $default != null:
return $default(_that.id,_that.userId,_that.description,_that.icon,_that.isDefault,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userId,  String description,  String? icon,  bool isDefault,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _CategoryApi():
return $default(_that.id,_that.userId,_that.description,_that.icon,_that.isDefault,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userId,  String description,  String? icon,  bool isDefault,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _CategoryApi() when $default != null:
return $default(_that.id,_that.userId,_that.description,_that.icon,_that.isDefault,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CategoryApi implements CategoryApi {
  const _CategoryApi({required this.id, required this.userId, required this.description, this.icon, required this.isDefault, required this.createdAt, required this.updatedAt});
  factory _CategoryApi.fromJson(Map<String, dynamic> json) => _$CategoryApiFromJson(json);

@override final  String id;
@override final  String userId;
@override final  String description;
@override final  String? icon;
@override final  bool isDefault;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of CategoryApi
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CategoryApiCopyWith<_CategoryApi> get copyWith => __$CategoryApiCopyWithImpl<_CategoryApi>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CategoryApiToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CategoryApi&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.description, description) || other.description == description)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.isDefault, isDefault) || other.isDefault == isDefault)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,description,icon,isDefault,createdAt,updatedAt);

@override
String toString() {
  return 'CategoryApi(id: $id, userId: $userId, description: $description, icon: $icon, isDefault: $isDefault, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$CategoryApiCopyWith<$Res> implements $CategoryApiCopyWith<$Res> {
  factory _$CategoryApiCopyWith(_CategoryApi value, $Res Function(_CategoryApi) _then) = __$CategoryApiCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, String description, String? icon, bool isDefault, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$CategoryApiCopyWithImpl<$Res>
    implements _$CategoryApiCopyWith<$Res> {
  __$CategoryApiCopyWithImpl(this._self, this._then);

  final _CategoryApi _self;
  final $Res Function(_CategoryApi) _then;

/// Create a copy of CategoryApi
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? description = null,Object? icon = freezed,Object? isDefault = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_CategoryApi(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,icon: freezed == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String?,isDefault: null == isDefault ? _self.isDefault : isDefault // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
