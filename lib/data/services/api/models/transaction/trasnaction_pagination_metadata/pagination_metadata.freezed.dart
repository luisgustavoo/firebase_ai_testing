// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pagination_metadata.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PaginationMetadata {

 int get page;@JsonKey(name: 'page_size') int get pageSize; int get total;@JsonKey(name: 'total_pages') int get totalPages;@JsonKey(name: 'has_next') bool get hasNext;@JsonKey(name: 'has_previous') bool get hasPrevious;
/// Create a copy of PaginationMetadata
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaginationMetadataCopyWith<PaginationMetadata> get copyWith => _$PaginationMetadataCopyWithImpl<PaginationMetadata>(this as PaginationMetadata, _$identity);

  /// Serializes this PaginationMetadata to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaginationMetadata&&(identical(other.page, page) || other.page == page)&&(identical(other.pageSize, pageSize) || other.pageSize == pageSize)&&(identical(other.total, total) || other.total == total)&&(identical(other.totalPages, totalPages) || other.totalPages == totalPages)&&(identical(other.hasNext, hasNext) || other.hasNext == hasNext)&&(identical(other.hasPrevious, hasPrevious) || other.hasPrevious == hasPrevious));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,page,pageSize,total,totalPages,hasNext,hasPrevious);

@override
String toString() {
  return 'PaginationMetadata(page: $page, pageSize: $pageSize, total: $total, totalPages: $totalPages, hasNext: $hasNext, hasPrevious: $hasPrevious)';
}


}

/// @nodoc
abstract mixin class $PaginationMetadataCopyWith<$Res>  {
  factory $PaginationMetadataCopyWith(PaginationMetadata value, $Res Function(PaginationMetadata) _then) = _$PaginationMetadataCopyWithImpl;
@useResult
$Res call({
 int page,@JsonKey(name: 'page_size') int pageSize, int total,@JsonKey(name: 'total_pages') int totalPages,@JsonKey(name: 'has_next') bool hasNext,@JsonKey(name: 'has_previous') bool hasPrevious
});




}
/// @nodoc
class _$PaginationMetadataCopyWithImpl<$Res>
    implements $PaginationMetadataCopyWith<$Res> {
  _$PaginationMetadataCopyWithImpl(this._self, this._then);

  final PaginationMetadata _self;
  final $Res Function(PaginationMetadata) _then;

/// Create a copy of PaginationMetadata
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? page = null,Object? pageSize = null,Object? total = null,Object? totalPages = null,Object? hasNext = null,Object? hasPrevious = null,}) {
  return _then(_self.copyWith(
page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,pageSize: null == pageSize ? _self.pageSize : pageSize // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,totalPages: null == totalPages ? _self.totalPages : totalPages // ignore: cast_nullable_to_non_nullable
as int,hasNext: null == hasNext ? _self.hasNext : hasNext // ignore: cast_nullable_to_non_nullable
as bool,hasPrevious: null == hasPrevious ? _self.hasPrevious : hasPrevious // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [PaginationMetadata].
extension PaginationMetadataPatterns on PaginationMetadata {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PaginationMetadata value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PaginationMetadata() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PaginationMetadata value)  $default,){
final _that = this;
switch (_that) {
case _PaginationMetadata():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PaginationMetadata value)?  $default,){
final _that = this;
switch (_that) {
case _PaginationMetadata() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int page, @JsonKey(name: 'page_size')  int pageSize,  int total, @JsonKey(name: 'total_pages')  int totalPages, @JsonKey(name: 'has_next')  bool hasNext, @JsonKey(name: 'has_previous')  bool hasPrevious)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PaginationMetadata() when $default != null:
return $default(_that.page,_that.pageSize,_that.total,_that.totalPages,_that.hasNext,_that.hasPrevious);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int page, @JsonKey(name: 'page_size')  int pageSize,  int total, @JsonKey(name: 'total_pages')  int totalPages, @JsonKey(name: 'has_next')  bool hasNext, @JsonKey(name: 'has_previous')  bool hasPrevious)  $default,) {final _that = this;
switch (_that) {
case _PaginationMetadata():
return $default(_that.page,_that.pageSize,_that.total,_that.totalPages,_that.hasNext,_that.hasPrevious);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int page, @JsonKey(name: 'page_size')  int pageSize,  int total, @JsonKey(name: 'total_pages')  int totalPages, @JsonKey(name: 'has_next')  bool hasNext, @JsonKey(name: 'has_previous')  bool hasPrevious)?  $default,) {final _that = this;
switch (_that) {
case _PaginationMetadata() when $default != null:
return $default(_that.page,_that.pageSize,_that.total,_that.totalPages,_that.hasNext,_that.hasPrevious);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PaginationMetadata implements PaginationMetadata {
  const _PaginationMetadata({required this.page, @JsonKey(name: 'page_size') required this.pageSize, required this.total, @JsonKey(name: 'total_pages') required this.totalPages, @JsonKey(name: 'has_next') required this.hasNext, @JsonKey(name: 'has_previous') required this.hasPrevious});
  factory _PaginationMetadata.fromJson(Map<String, dynamic> json) => _$PaginationMetadataFromJson(json);

@override final  int page;
@override@JsonKey(name: 'page_size') final  int pageSize;
@override final  int total;
@override@JsonKey(name: 'total_pages') final  int totalPages;
@override@JsonKey(name: 'has_next') final  bool hasNext;
@override@JsonKey(name: 'has_previous') final  bool hasPrevious;

/// Create a copy of PaginationMetadata
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PaginationMetadataCopyWith<_PaginationMetadata> get copyWith => __$PaginationMetadataCopyWithImpl<_PaginationMetadata>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PaginationMetadataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PaginationMetadata&&(identical(other.page, page) || other.page == page)&&(identical(other.pageSize, pageSize) || other.pageSize == pageSize)&&(identical(other.total, total) || other.total == total)&&(identical(other.totalPages, totalPages) || other.totalPages == totalPages)&&(identical(other.hasNext, hasNext) || other.hasNext == hasNext)&&(identical(other.hasPrevious, hasPrevious) || other.hasPrevious == hasPrevious));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,page,pageSize,total,totalPages,hasNext,hasPrevious);

@override
String toString() {
  return 'PaginationMetadata(page: $page, pageSize: $pageSize, total: $total, totalPages: $totalPages, hasNext: $hasNext, hasPrevious: $hasPrevious)';
}


}

/// @nodoc
abstract mixin class _$PaginationMetadataCopyWith<$Res> implements $PaginationMetadataCopyWith<$Res> {
  factory _$PaginationMetadataCopyWith(_PaginationMetadata value, $Res Function(_PaginationMetadata) _then) = __$PaginationMetadataCopyWithImpl;
@override @useResult
$Res call({
 int page,@JsonKey(name: 'page_size') int pageSize, int total,@JsonKey(name: 'total_pages') int totalPages,@JsonKey(name: 'has_next') bool hasNext,@JsonKey(name: 'has_previous') bool hasPrevious
});




}
/// @nodoc
class __$PaginationMetadataCopyWithImpl<$Res>
    implements _$PaginationMetadataCopyWith<$Res> {
  __$PaginationMetadataCopyWithImpl(this._self, this._then);

  final _PaginationMetadata _self;
  final $Res Function(_PaginationMetadata) _then;

/// Create a copy of PaginationMetadata
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? page = null,Object? pageSize = null,Object? total = null,Object? totalPages = null,Object? hasNext = null,Object? hasPrevious = null,}) {
  return _then(_PaginationMetadata(
page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,pageSize: null == pageSize ? _self.pageSize : pageSize // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,totalPages: null == totalPages ? _self.totalPages : totalPages // ignore: cast_nullable_to_non_nullable
as int,hasNext: null == hasNext ? _self.hasNext : hasNext // ignore: cast_nullable_to_non_nullable
as bool,hasPrevious: null == hasPrevious ? _self.hasPrevious : hasPrevious // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
