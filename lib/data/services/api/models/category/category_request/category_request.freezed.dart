// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'category_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CategoryRequest {

 String get description; String? get icon;
/// Create a copy of CategoryRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CategoryRequestCopyWith<CategoryRequest> get copyWith => _$CategoryRequestCopyWithImpl<CategoryRequest>(this as CategoryRequest, _$identity);

  /// Serializes this CategoryRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CategoryRequest&&(identical(other.description, description) || other.description == description)&&(identical(other.icon, icon) || other.icon == icon));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,description,icon);

@override
String toString() {
  return 'CategoryRequest(description: $description, icon: $icon)';
}


}

/// @nodoc
abstract mixin class $CategoryRequestCopyWith<$Res>  {
  factory $CategoryRequestCopyWith(CategoryRequest value, $Res Function(CategoryRequest) _then) = _$CategoryRequestCopyWithImpl;
@useResult
$Res call({
 String description, String? icon
});




}
/// @nodoc
class _$CategoryRequestCopyWithImpl<$Res>
    implements $CategoryRequestCopyWith<$Res> {
  _$CategoryRequestCopyWithImpl(this._self, this._then);

  final CategoryRequest _self;
  final $Res Function(CategoryRequest) _then;

/// Create a copy of CategoryRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? description = null,Object? icon = freezed,}) {
  return _then(_self.copyWith(
description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,icon: freezed == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CategoryRequest].
extension CategoryRequestPatterns on CategoryRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CategoryRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CategoryRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CategoryRequest value)  $default,){
final _that = this;
switch (_that) {
case _CategoryRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CategoryRequest value)?  $default,){
final _that = this;
switch (_that) {
case _CategoryRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String description,  String? icon)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CategoryRequest() when $default != null:
return $default(_that.description,_that.icon);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String description,  String? icon)  $default,) {final _that = this;
switch (_that) {
case _CategoryRequest():
return $default(_that.description,_that.icon);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String description,  String? icon)?  $default,) {final _that = this;
switch (_that) {
case _CategoryRequest() when $default != null:
return $default(_that.description,_that.icon);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CategoryRequest implements CategoryRequest {
  const _CategoryRequest({required this.description, this.icon});
  factory _CategoryRequest.fromJson(Map<String, dynamic> json) => _$CategoryRequestFromJson(json);

@override final  String description;
@override final  String? icon;

/// Create a copy of CategoryRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CategoryRequestCopyWith<_CategoryRequest> get copyWith => __$CategoryRequestCopyWithImpl<_CategoryRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CategoryRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CategoryRequest&&(identical(other.description, description) || other.description == description)&&(identical(other.icon, icon) || other.icon == icon));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,description,icon);

@override
String toString() {
  return 'CategoryRequest(description: $description, icon: $icon)';
}


}

/// @nodoc
abstract mixin class _$CategoryRequestCopyWith<$Res> implements $CategoryRequestCopyWith<$Res> {
  factory _$CategoryRequestCopyWith(_CategoryRequest value, $Res Function(_CategoryRequest) _then) = __$CategoryRequestCopyWithImpl;
@override @useResult
$Res call({
 String description, String? icon
});




}
/// @nodoc
class __$CategoryRequestCopyWithImpl<$Res>
    implements _$CategoryRequestCopyWith<$Res> {
  __$CategoryRequestCopyWithImpl(this._self, this._then);

  final _CategoryRequest _self;
  final $Res Function(_CategoryRequest) _then;

/// Create a copy of CategoryRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? description = null,Object? icon = freezed,}) {
  return _then(_CategoryRequest(
description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,icon: freezed == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
