// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pickup_history_response_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PickupHistoryResponseModel _$PickupHistoryResponseModelFromJson(
    Map<String, dynamic> json) {
  return _PickupHistoryResponseModel.fromJson(json);
}

/// @nodoc
mixin _$PickupHistoryResponseModel {
  List<UserPickupHistoryModel> get orders => throw _privateConstructorUsedError;
  int get totalCount => throw _privateConstructorUsedError;
  int get currentPage => throw _privateConstructorUsedError;
  int get pageSize => throw _privateConstructorUsedError;
  int get totalPages => throw _privateConstructorUsedError;

  /// Serializes this PickupHistoryResponseModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PickupHistoryResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PickupHistoryResponseModelCopyWith<PickupHistoryResponseModel>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PickupHistoryResponseModelCopyWith<$Res> {
  factory $PickupHistoryResponseModelCopyWith(PickupHistoryResponseModel value,
          $Res Function(PickupHistoryResponseModel) then) =
      _$PickupHistoryResponseModelCopyWithImpl<$Res,
          PickupHistoryResponseModel>;
  @useResult
  $Res call(
      {List<UserPickupHistoryModel> orders,
      int totalCount,
      int currentPage,
      int pageSize,
      int totalPages});
}

/// @nodoc
class _$PickupHistoryResponseModelCopyWithImpl<$Res,
        $Val extends PickupHistoryResponseModel>
    implements $PickupHistoryResponseModelCopyWith<$Res> {
  _$PickupHistoryResponseModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PickupHistoryResponseModel
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
              as List<UserPickupHistoryModel>,
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
abstract class _$$PickupHistoryResponseModelImplCopyWith<$Res>
    implements $PickupHistoryResponseModelCopyWith<$Res> {
  factory _$$PickupHistoryResponseModelImplCopyWith(
          _$PickupHistoryResponseModelImpl value,
          $Res Function(_$PickupHistoryResponseModelImpl) then) =
      __$$PickupHistoryResponseModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<UserPickupHistoryModel> orders,
      int totalCount,
      int currentPage,
      int pageSize,
      int totalPages});
}

/// @nodoc
class __$$PickupHistoryResponseModelImplCopyWithImpl<$Res>
    extends _$PickupHistoryResponseModelCopyWithImpl<$Res,
        _$PickupHistoryResponseModelImpl>
    implements _$$PickupHistoryResponseModelImplCopyWith<$Res> {
  __$$PickupHistoryResponseModelImplCopyWithImpl(
      _$PickupHistoryResponseModelImpl _value,
      $Res Function(_$PickupHistoryResponseModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of PickupHistoryResponseModel
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
    return _then(_$PickupHistoryResponseModelImpl(
      orders: null == orders
          ? _value._orders
          : orders // ignore: cast_nullable_to_non_nullable
              as List<UserPickupHistoryModel>,
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
@JsonSerializable()
class _$PickupHistoryResponseModelImpl implements _PickupHistoryResponseModel {
  const _$PickupHistoryResponseModelImpl(
      {required final List<UserPickupHistoryModel> orders,
      required this.totalCount,
      required this.currentPage,
      required this.pageSize,
      required this.totalPages})
      : _orders = orders;

  factory _$PickupHistoryResponseModelImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$PickupHistoryResponseModelImplFromJson(json);

  final List<UserPickupHistoryModel> _orders;
  @override
  List<UserPickupHistoryModel> get orders {
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
    return 'PickupHistoryResponseModel(orders: $orders, totalCount: $totalCount, currentPage: $currentPage, pageSize: $pageSize, totalPages: $totalPages)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PickupHistoryResponseModelImpl &&
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

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_orders),
      totalCount,
      currentPage,
      pageSize,
      totalPages);

  /// Create a copy of PickupHistoryResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PickupHistoryResponseModelImplCopyWith<_$PickupHistoryResponseModelImpl>
      get copyWith => __$$PickupHistoryResponseModelImplCopyWithImpl<
          _$PickupHistoryResponseModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PickupHistoryResponseModelImplToJson(
      this,
    );
  }
}

abstract class _PickupHistoryResponseModel
    implements PickupHistoryResponseModel {
  const factory _PickupHistoryResponseModel(
      {required final List<UserPickupHistoryModel> orders,
      required final int totalCount,
      required final int currentPage,
      required final int pageSize,
      required final int totalPages}) = _$PickupHistoryResponseModelImpl;

  factory _PickupHistoryResponseModel.fromJson(Map<String, dynamic> json) =
      _$PickupHistoryResponseModelImpl.fromJson;

  @override
  List<UserPickupHistoryModel> get orders;
  @override
  int get totalCount;
  @override
  int get currentPage;
  @override
  int get pageSize;
  @override
  int get totalPages;

  /// Create a copy of PickupHistoryResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PickupHistoryResponseModelImplCopyWith<_$PickupHistoryResponseModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
