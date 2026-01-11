// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bonus_transaction_response_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$BonusTransactionResponseModel {
  List<BonusTransactionModel> get transactions =>
      throw _privateConstructorUsedError;
  int get totalItems => throw _privateConstructorUsedError;
  int get totalPages => throw _privateConstructorUsedError;

  /// Create a copy of BonusTransactionResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BonusTransactionResponseModelCopyWith<BonusTransactionResponseModel>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BonusTransactionResponseModelCopyWith<$Res> {
  factory $BonusTransactionResponseModelCopyWith(
          BonusTransactionResponseModel value,
          $Res Function(BonusTransactionResponseModel) then) =
      _$BonusTransactionResponseModelCopyWithImpl<$Res,
          BonusTransactionResponseModel>;
  @useResult
  $Res call(
      {List<BonusTransactionModel> transactions,
      int totalItems,
      int totalPages});
}

/// @nodoc
class _$BonusTransactionResponseModelCopyWithImpl<$Res,
        $Val extends BonusTransactionResponseModel>
    implements $BonusTransactionResponseModelCopyWith<$Res> {
  _$BonusTransactionResponseModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BonusTransactionResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? transactions = null,
    Object? totalItems = null,
    Object? totalPages = null,
  }) {
    return _then(_value.copyWith(
      transactions: null == transactions
          ? _value.transactions
          : transactions // ignore: cast_nullable_to_non_nullable
              as List<BonusTransactionModel>,
      totalItems: null == totalItems
          ? _value.totalItems
          : totalItems // ignore: cast_nullable_to_non_nullable
              as int,
      totalPages: null == totalPages
          ? _value.totalPages
          : totalPages // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BonusTransactionResponseModelImplCopyWith<$Res>
    implements $BonusTransactionResponseModelCopyWith<$Res> {
  factory _$$BonusTransactionResponseModelImplCopyWith(
          _$BonusTransactionResponseModelImpl value,
          $Res Function(_$BonusTransactionResponseModelImpl) then) =
      __$$BonusTransactionResponseModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<BonusTransactionModel> transactions,
      int totalItems,
      int totalPages});
}

/// @nodoc
class __$$BonusTransactionResponseModelImplCopyWithImpl<$Res>
    extends _$BonusTransactionResponseModelCopyWithImpl<$Res,
        _$BonusTransactionResponseModelImpl>
    implements _$$BonusTransactionResponseModelImplCopyWith<$Res> {
  __$$BonusTransactionResponseModelImplCopyWithImpl(
      _$BonusTransactionResponseModelImpl _value,
      $Res Function(_$BonusTransactionResponseModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of BonusTransactionResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? transactions = null,
    Object? totalItems = null,
    Object? totalPages = null,
  }) {
    return _then(_$BonusTransactionResponseModelImpl(
      transactions: null == transactions
          ? _value._transactions
          : transactions // ignore: cast_nullable_to_non_nullable
              as List<BonusTransactionModel>,
      totalItems: null == totalItems
          ? _value.totalItems
          : totalItems // ignore: cast_nullable_to_non_nullable
              as int,
      totalPages: null == totalPages
          ? _value.totalPages
          : totalPages // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$BonusTransactionResponseModelImpl
    implements _BonusTransactionResponseModel {
  const _$BonusTransactionResponseModelImpl(
      {required final List<BonusTransactionModel> transactions,
      required this.totalItems,
      required this.totalPages})
      : _transactions = transactions;

  final List<BonusTransactionModel> _transactions;
  @override
  List<BonusTransactionModel> get transactions {
    if (_transactions is EqualUnmodifiableListView) return _transactions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_transactions);
  }

  @override
  final int totalItems;
  @override
  final int totalPages;

  @override
  String toString() {
    return 'BonusTransactionResponseModel(transactions: $transactions, totalItems: $totalItems, totalPages: $totalPages)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BonusTransactionResponseModelImpl &&
            const DeepCollectionEquality()
                .equals(other._transactions, _transactions) &&
            (identical(other.totalItems, totalItems) ||
                other.totalItems == totalItems) &&
            (identical(other.totalPages, totalPages) ||
                other.totalPages == totalPages));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_transactions),
      totalItems,
      totalPages);

  /// Create a copy of BonusTransactionResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BonusTransactionResponseModelImplCopyWith<
          _$BonusTransactionResponseModelImpl>
      get copyWith => __$$BonusTransactionResponseModelImplCopyWithImpl<
          _$BonusTransactionResponseModelImpl>(this, _$identity);
}

abstract class _BonusTransactionResponseModel
    implements BonusTransactionResponseModel {
  const factory _BonusTransactionResponseModel(
      {required final List<BonusTransactionModel> transactions,
      required final int totalItems,
      required final int totalPages}) = _$BonusTransactionResponseModelImpl;

  @override
  List<BonusTransactionModel> get transactions;
  @override
  int get totalItems;
  @override
  int get totalPages;

  /// Create a copy of BonusTransactionResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BonusTransactionResponseModelImplCopyWith<
          _$BonusTransactionResponseModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
