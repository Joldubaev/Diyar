// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pickup_history_response_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$PickupHistoryResponseEntity {
  List<UserPickupHistoryEntity> get orders =>
      throw _privateConstructorUsedError;
  int get totalCount => throw _privateConstructorUsedError;
  int get currentPage => throw _privateConstructorUsedError;
  int get pageSize => throw _privateConstructorUsedError;
  int get totalPages => throw _privateConstructorUsedError;

  /// Create a copy of PickupHistoryResponseEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PickupHistoryResponseEntityCopyWith<PickupHistoryResponseEntity>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PickupHistoryResponseEntityCopyWith<$Res> {
  factory $PickupHistoryResponseEntityCopyWith(
          PickupHistoryResponseEntity value,
          $Res Function(PickupHistoryResponseEntity) then) =
      _$PickupHistoryResponseEntityCopyWithImpl<$Res,
          PickupHistoryResponseEntity>;
  @useResult
  $Res call(
      {List<UserPickupHistoryEntity> orders,
      int totalCount,
      int currentPage,
      int pageSize,
      int totalPages});
}

/// @nodoc
class _$PickupHistoryResponseEntityCopyWithImpl<$Res,
        $Val extends PickupHistoryResponseEntity>
    implements $PickupHistoryResponseEntityCopyWith<$Res> {
  _$PickupHistoryResponseEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PickupHistoryResponseEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? orders = null,
    Object? totalCount = null,
    Object? currentPage = null,
    Object? pageSize = null,
    Object? totalPages = null,
  }) {
    return _then(_value.copyWith(
      orders: null == orders
          ? _value.orders
          : orders // ignore: cast_nullable_to_non_nullable
              as List<UserPickupHistoryEntity>,
      totalCount: null == totalCount
          ? _value.totalCount
          : totalCount // ignore: cast_nullable_to_non_nullable
              as int,
      currentPage: null == currentPage
          ? _value.currentPage
          : currentPage // ignore: cast_nullable_to_non_nullable
              as int,
      pageSize: null == pageSize
          ? _value.pageSize
          : pageSize // ignore: cast_nullable_to_non_nullable
              as int,
      totalPages: null == totalPages
          ? _value.totalPages
          : totalPages // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PickupHistoryResponseEntityImplCopyWith<$Res>
    implements $PickupHistoryResponseEntityCopyWith<$Res> {
  factory _$$PickupHistoryResponseEntityImplCopyWith(
          _$PickupHistoryResponseEntityImpl value,
          $Res Function(_$PickupHistoryResponseEntityImpl) then) =
      __$$PickupHistoryResponseEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<UserPickupHistoryEntity> orders,
      int totalCount,
      int currentPage,
      int pageSize,
      int totalPages});
}

/// @nodoc
class __$$PickupHistoryResponseEntityImplCopyWithImpl<$Res>
    extends _$PickupHistoryResponseEntityCopyWithImpl<$Res,
        _$PickupHistoryResponseEntityImpl>
    implements _$$PickupHistoryResponseEntityImplCopyWith<$Res> {
  __$$PickupHistoryResponseEntityImplCopyWithImpl(
      _$PickupHistoryResponseEntityImpl _value,
      $Res Function(_$PickupHistoryResponseEntityImpl) _then)
      : super(_value, _then);

  /// Create a copy of PickupHistoryResponseEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? orders = null,
    Object? totalCount = null,
    Object? currentPage = null,
    Object? pageSize = null,
    Object? totalPages = null,
  }) {
    return _then(_$PickupHistoryResponseEntityImpl(
      orders: null == orders
          ? _value._orders
          : orders // ignore: cast_nullable_to_non_nullable
              as List<UserPickupHistoryEntity>,
      totalCount: null == totalCount
          ? _value.totalCount
          : totalCount // ignore: cast_nullable_to_non_nullable
              as int,
      currentPage: null == currentPage
          ? _value.currentPage
          : currentPage // ignore: cast_nullable_to_non_nullable
              as int,
      pageSize: null == pageSize
          ? _value.pageSize
          : pageSize // ignore: cast_nullable_to_non_nullable
              as int,
      totalPages: null == totalPages
          ? _value.totalPages
          : totalPages // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$PickupHistoryResponseEntityImpl
    implements _PickupHistoryResponseEntity {
  const _$PickupHistoryResponseEntityImpl(
      {required final List<UserPickupHistoryEntity> orders,
      required this.totalCount,
      required this.currentPage,
      required this.pageSize,
      required this.totalPages})
      : _orders = orders;

  final List<UserPickupHistoryEntity> _orders;
  @override
  List<UserPickupHistoryEntity> get orders {
    if (_orders is EqualUnmodifiableListView) return _orders;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_orders);
  }

  @override
  final int totalCount;
  @override
  final int currentPage;
  @override
  final int pageSize;
  @override
  final int totalPages;

  @override
  String toString() {
    return 'PickupHistoryResponseEntity(orders: $orders, totalCount: $totalCount, currentPage: $currentPage, pageSize: $pageSize, totalPages: $totalPages)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PickupHistoryResponseEntityImpl &&
            const DeepCollectionEquality().equals(other._orders, _orders) &&
            (identical(other.totalCount, totalCount) ||
                other.totalCount == totalCount) &&
            (identical(other.currentPage, currentPage) ||
                other.currentPage == currentPage) &&
            (identical(other.pageSize, pageSize) ||
                other.pageSize == pageSize) &&
            (identical(other.totalPages, totalPages) ||
                other.totalPages == totalPages));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_orders),
      totalCount,
      currentPage,
      pageSize,
      totalPages);

  /// Create a copy of PickupHistoryResponseEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PickupHistoryResponseEntityImplCopyWith<_$PickupHistoryResponseEntityImpl>
      get copyWith => __$$PickupHistoryResponseEntityImplCopyWithImpl<
          _$PickupHistoryResponseEntityImpl>(this, _$identity);
}

abstract class _PickupHistoryResponseEntity
    implements PickupHistoryResponseEntity {
  const factory _PickupHistoryResponseEntity(
      {required final List<UserPickupHistoryEntity> orders,
      required final int totalCount,
      required final int currentPage,
      required final int pageSize,
      required final int totalPages}) = _$PickupHistoryResponseEntityImpl;

  @override
  List<UserPickupHistoryEntity> get orders;
  @override
  int get totalCount;
  @override
  int get currentPage;
  @override
  int get pageSize;
  @override
  int get totalPages;

  /// Create a copy of PickupHistoryResponseEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PickupHistoryResponseEntityImplCopyWith<_$PickupHistoryResponseEntityImpl>
      get copyWith => throw _privateConstructorUsedError;
}
