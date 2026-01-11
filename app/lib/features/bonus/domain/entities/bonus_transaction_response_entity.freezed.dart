// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bonus_transaction_response_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$BonusTransactionResponseEntity {
  List<BonusTransactionEntity> get transactions =>
      throw _privateConstructorUsedError;
  int get totalItems => throw _privateConstructorUsedError;
  int get totalPages => throw _privateConstructorUsedError;

  /// Create a copy of BonusTransactionResponseEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BonusTransactionResponseEntityCopyWith<BonusTransactionResponseEntity>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BonusTransactionResponseEntityCopyWith<$Res> {
  factory $BonusTransactionResponseEntityCopyWith(
          BonusTransactionResponseEntity value,
          $Res Function(BonusTransactionResponseEntity) then) =
      _$BonusTransactionResponseEntityCopyWithImpl<$Res,
          BonusTransactionResponseEntity>;
  @useResult
  $Res call(
      {List<BonusTransactionEntity> transactions,
      int totalItems,
      int totalPages});
}

/// @nodoc
class _$BonusTransactionResponseEntityCopyWithImpl<$Res,
        $Val extends BonusTransactionResponseEntity>
    implements $BonusTransactionResponseEntityCopyWith<$Res> {
  _$BonusTransactionResponseEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BonusTransactionResponseEntity
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
              as List<BonusTransactionEntity>,
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
abstract class _$$BonusTransactionResponseEntityImplCopyWith<$Res>
    implements $BonusTransactionResponseEntityCopyWith<$Res> {
  factory _$$BonusTransactionResponseEntityImplCopyWith(
          _$BonusTransactionResponseEntityImpl value,
          $Res Function(_$BonusTransactionResponseEntityImpl) then) =
      __$$BonusTransactionResponseEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<BonusTransactionEntity> transactions,
      int totalItems,
      int totalPages});
}

/// @nodoc
class __$$BonusTransactionResponseEntityImplCopyWithImpl<$Res>
    extends _$BonusTransactionResponseEntityCopyWithImpl<$Res,
        _$BonusTransactionResponseEntityImpl>
    implements _$$BonusTransactionResponseEntityImplCopyWith<$Res> {
  __$$BonusTransactionResponseEntityImplCopyWithImpl(
      _$BonusTransactionResponseEntityImpl _value,
      $Res Function(_$BonusTransactionResponseEntityImpl) _then)
      : super(_value, _then);

  /// Create a copy of BonusTransactionResponseEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? transactions = null,
    Object? totalItems = null,
    Object? totalPages = null,
  }) {
    return _then(_$BonusTransactionResponseEntityImpl(
      transactions: null == transactions
          ? _value._transactions
          : transactions // ignore: cast_nullable_to_non_nullable
              as List<BonusTransactionEntity>,
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

class _$BonusTransactionResponseEntityImpl
    implements _BonusTransactionResponseEntity {
  const _$BonusTransactionResponseEntityImpl(
      {required final List<BonusTransactionEntity> transactions,
      required this.totalItems,
      required this.totalPages})
      : _transactions = transactions;

  final List<BonusTransactionEntity> _transactions;
  @override
  List<BonusTransactionEntity> get transactions {
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
    return 'BonusTransactionResponseEntity(transactions: $transactions, totalItems: $totalItems, totalPages: $totalPages)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BonusTransactionResponseEntityImpl &&
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

  /// Create a copy of BonusTransactionResponseEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BonusTransactionResponseEntityImplCopyWith<
          _$BonusTransactionResponseEntityImpl>
      get copyWith => __$$BonusTransactionResponseEntityImplCopyWithImpl<
          _$BonusTransactionResponseEntityImpl>(this, _$identity);
}

abstract class _BonusTransactionResponseEntity
    implements BonusTransactionResponseEntity {
  const factory _BonusTransactionResponseEntity(
      {required final List<BonusTransactionEntity> transactions,
      required final int totalItems,
      required final int totalPages}) = _$BonusTransactionResponseEntityImpl;

  @override
  List<BonusTransactionEntity> get transactions;
  @override
  int get totalItems;
  @override
  int get totalPages;

  /// Create a copy of BonusTransactionResponseEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BonusTransactionResponseEntityImplCopyWith<
          _$BonusTransactionResponseEntityImpl>
      get copyWith => throw _privateConstructorUsedError;
}
