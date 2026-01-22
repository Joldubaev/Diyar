// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_pickup_history_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UserPickupHistoryModel _$UserPickupHistoryModelFromJson(
    Map<String, dynamic> json) {
  return _UserPickupHistoryModel.fromJson(json);
}

/// @nodoc
mixin _$UserPickupHistoryModel {
  String? get comment => throw _privateConstructorUsedError;
  int? get dishesCount => throw _privateConstructorUsedError;
  List<FoodPickupModel>? get foods => throw _privateConstructorUsedError;
  String? get id => throw _privateConstructorUsedError;
  int? get orderNumber => throw _privateConstructorUsedError;
  String? get prepareFor => throw _privateConstructorUsedError;
  int? get price => throw _privateConstructorUsedError;
  String? get status => throw _privateConstructorUsedError;
  String? get timeRequest => throw _privateConstructorUsedError;
  String? get userId => throw _privateConstructorUsedError;
  String? get userName => throw _privateConstructorUsedError;
  String? get userPhone => throw _privateConstructorUsedError;
  String? get paymentMethod => throw _privateConstructorUsedError;
  double? get amountToReduce => throw _privateConstructorUsedError;

  /// Serializes this UserPickupHistoryModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserPickupHistoryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserPickupHistoryModelCopyWith<UserPickupHistoryModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserPickupHistoryModelCopyWith<$Res> {
  factory $UserPickupHistoryModelCopyWith(UserPickupHistoryModel value,
          $Res Function(UserPickupHistoryModel) then) =
      _$UserPickupHistoryModelCopyWithImpl<$Res, UserPickupHistoryModel>;
  @useResult
  $Res call(
      {String? comment,
      int? dishesCount,
      List<FoodPickupModel>? foods,
      String? id,
      int? orderNumber,
      String? prepareFor,
      int? price,
      String? status,
      String? timeRequest,
      String? userId,
      String? userName,
      String? userPhone,
      String? paymentMethod,
      double? amountToReduce});
}

/// @nodoc
class _$UserPickupHistoryModelCopyWithImpl<$Res,
        $Val extends UserPickupHistoryModel>
    implements $UserPickupHistoryModelCopyWith<$Res> {
  _$UserPickupHistoryModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserPickupHistoryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? comment = freezed,
    Object? dishesCount = freezed,
    Object? foods = freezed,
    Object? id = freezed,
    Object? orderNumber = freezed,
    Object? prepareFor = freezed,
    Object? price = freezed,
    Object? status = freezed,
    Object? timeRequest = freezed,
    Object? userId = freezed,
    Object? userName = freezed,
    Object? userPhone = freezed,
    Object? paymentMethod = freezed,
    Object? amountToReduce = freezed,
  }) {
    return _then(_value.copyWith(
      comment: freezed == comment
          ? _value.comment
          : comment // ignore: cast_nullable_to_non_nullable
              as String?,
      dishesCount: freezed == dishesCount
          ? _value.dishesCount
          : dishesCount // ignore: cast_nullable_to_non_nullable
              as int?,
      foods: freezed == foods
          ? _value.foods
          : foods // ignore: cast_nullable_to_non_nullable
              as List<FoodPickupModel>?,
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      orderNumber: freezed == orderNumber
          ? _value.orderNumber
          : orderNumber // ignore: cast_nullable_to_non_nullable
              as int?,
      prepareFor: freezed == prepareFor
          ? _value.prepareFor
          : prepareFor // ignore: cast_nullable_to_non_nullable
              as String?,
      price: freezed == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as int?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
      timeRequest: freezed == timeRequest
          ? _value.timeRequest
          : timeRequest // ignore: cast_nullable_to_non_nullable
              as String?,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String?,
      userName: freezed == userName
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String?,
      userPhone: freezed == userPhone
          ? _value.userPhone
          : userPhone // ignore: cast_nullable_to_non_nullable
              as String?,
      paymentMethod: freezed == paymentMethod
          ? _value.paymentMethod
          : paymentMethod // ignore: cast_nullable_to_non_nullable
              as String?,
      amountToReduce: freezed == amountToReduce
          ? _value.amountToReduce
          : amountToReduce // ignore: cast_nullable_to_non_nullable
              as double?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserPickupHistoryModelImplCopyWith<$Res>
    implements $UserPickupHistoryModelCopyWith<$Res> {
  factory _$$UserPickupHistoryModelImplCopyWith(
          _$UserPickupHistoryModelImpl value,
          $Res Function(_$UserPickupHistoryModelImpl) then) =
      __$$UserPickupHistoryModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? comment,
      int? dishesCount,
      List<FoodPickupModel>? foods,
      String? id,
      int? orderNumber,
      String? prepareFor,
      int? price,
      String? status,
      String? timeRequest,
      String? userId,
      String? userName,
      String? userPhone,
      String? paymentMethod,
      double? amountToReduce});
}

/// @nodoc
class __$$UserPickupHistoryModelImplCopyWithImpl<$Res>
    extends _$UserPickupHistoryModelCopyWithImpl<$Res,
        _$UserPickupHistoryModelImpl>
    implements _$$UserPickupHistoryModelImplCopyWith<$Res> {
  __$$UserPickupHistoryModelImplCopyWithImpl(
      _$UserPickupHistoryModelImpl _value,
      $Res Function(_$UserPickupHistoryModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of UserPickupHistoryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? comment = freezed,
    Object? dishesCount = freezed,
    Object? foods = freezed,
    Object? id = freezed,
    Object? orderNumber = freezed,
    Object? prepareFor = freezed,
    Object? price = freezed,
    Object? status = freezed,
    Object? timeRequest = freezed,
    Object? userId = freezed,
    Object? userName = freezed,
    Object? userPhone = freezed,
    Object? paymentMethod = freezed,
    Object? amountToReduce = freezed,
  }) {
    return _then(_$UserPickupHistoryModelImpl(
      comment: freezed == comment
          ? _value.comment
          : comment // ignore: cast_nullable_to_non_nullable
              as String?,
      dishesCount: freezed == dishesCount
          ? _value.dishesCount
          : dishesCount // ignore: cast_nullable_to_non_nullable
              as int?,
      foods: freezed == foods
          ? _value._foods
          : foods // ignore: cast_nullable_to_non_nullable
              as List<FoodPickupModel>?,
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      orderNumber: freezed == orderNumber
          ? _value.orderNumber
          : orderNumber // ignore: cast_nullable_to_non_nullable
              as int?,
      prepareFor: freezed == prepareFor
          ? _value.prepareFor
          : prepareFor // ignore: cast_nullable_to_non_nullable
              as String?,
      price: freezed == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as int?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
      timeRequest: freezed == timeRequest
          ? _value.timeRequest
          : timeRequest // ignore: cast_nullable_to_non_nullable
              as String?,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String?,
      userName: freezed == userName
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String?,
      userPhone: freezed == userPhone
          ? _value.userPhone
          : userPhone // ignore: cast_nullable_to_non_nullable
              as String?,
      paymentMethod: freezed == paymentMethod
          ? _value.paymentMethod
          : paymentMethod // ignore: cast_nullable_to_non_nullable
              as String?,
      amountToReduce: freezed == amountToReduce
          ? _value.amountToReduce
          : amountToReduce // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserPickupHistoryModelImpl implements _UserPickupHistoryModel {
  const _$UserPickupHistoryModelImpl(
      {this.comment,
      this.dishesCount,
      final List<FoodPickupModel>? foods,
      this.id,
      this.orderNumber,
      this.prepareFor,
      this.price,
      this.status,
      this.timeRequest,
      this.userId,
      this.userName,
      this.userPhone,
      this.paymentMethod,
      this.amountToReduce})
      : _foods = foods;

  factory _$UserPickupHistoryModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserPickupHistoryModelImplFromJson(json);

  @override
  final String? comment;
  @override
  final int? dishesCount;
  final List<FoodPickupModel>? _foods;
  @override
  List<FoodPickupModel>? get foods {
    final value = _foods;
    if (value == null) return null;
    if (_foods is EqualUnmodifiableListView) return _foods;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final String? id;
  @override
  final int? orderNumber;
  @override
  final String? prepareFor;
  @override
  final int? price;
  @override
  final String? status;
  @override
  final String? timeRequest;
  @override
  final String? userId;
  @override
  final String? userName;
  @override
  final String? userPhone;
  @override
  final String? paymentMethod;
  @override
  final double? amountToReduce;

  @override
  String toString() {
    return 'UserPickupHistoryModel(comment: $comment, dishesCount: $dishesCount, foods: $foods, id: $id, orderNumber: $orderNumber, prepareFor: $prepareFor, price: $price, status: $status, timeRequest: $timeRequest, userId: $userId, userName: $userName, userPhone: $userPhone, paymentMethod: $paymentMethod, amountToReduce: $amountToReduce)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserPickupHistoryModelImpl &&
            (identical(other.comment, comment) || other.comment == comment) &&
            (identical(other.dishesCount, dishesCount) ||
                other.dishesCount == dishesCount) &&
            const DeepCollectionEquality().equals(other._foods, _foods) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.orderNumber, orderNumber) ||
                other.orderNumber == orderNumber) &&
            (identical(other.prepareFor, prepareFor) ||
                other.prepareFor == prepareFor) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.timeRequest, timeRequest) ||
                other.timeRequest == timeRequest) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.userName, userName) ||
                other.userName == userName) &&
            (identical(other.userPhone, userPhone) ||
                other.userPhone == userPhone) &&
            (identical(other.paymentMethod, paymentMethod) ||
                other.paymentMethod == paymentMethod) &&
            (identical(other.amountToReduce, amountToReduce) ||
                other.amountToReduce == amountToReduce));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      comment,
      dishesCount,
      const DeepCollectionEquality().hash(_foods),
      id,
      orderNumber,
      prepareFor,
      price,
      status,
      timeRequest,
      userId,
      userName,
      userPhone,
      paymentMethod,
      amountToReduce);

  /// Create a copy of UserPickupHistoryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserPickupHistoryModelImplCopyWith<_$UserPickupHistoryModelImpl>
      get copyWith => __$$UserPickupHistoryModelImplCopyWithImpl<
          _$UserPickupHistoryModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserPickupHistoryModelImplToJson(
      this,
    );
  }
}

abstract class _UserPickupHistoryModel implements UserPickupHistoryModel {
  const factory _UserPickupHistoryModel(
      {final String? comment,
      final int? dishesCount,
      final List<FoodPickupModel>? foods,
      final String? id,
      final int? orderNumber,
      final String? prepareFor,
      final int? price,
      final String? status,
      final String? timeRequest,
      final String? userId,
      final String? userName,
      final String? userPhone,
      final String? paymentMethod,
      final double? amountToReduce}) = _$UserPickupHistoryModelImpl;

  factory _UserPickupHistoryModel.fromJson(Map<String, dynamic> json) =
      _$UserPickupHistoryModelImpl.fromJson;

  @override
  String? get comment;
  @override
  int? get dishesCount;
  @override
  List<FoodPickupModel>? get foods;
  @override
  String? get id;
  @override
  int? get orderNumber;
  @override
  String? get prepareFor;
  @override
  int? get price;
  @override
  String? get status;
  @override
  String? get timeRequest;
  @override
  String? get userId;
  @override
  String? get userName;
  @override
  String? get userPhone;
  @override
  String? get paymentMethod;
  @override
  double? get amountToReduce;

  /// Create a copy of UserPickupHistoryModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserPickupHistoryModelImplCopyWith<_$UserPickupHistoryModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
