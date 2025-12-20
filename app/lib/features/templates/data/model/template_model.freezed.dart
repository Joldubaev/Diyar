// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'template_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$TemplateModel {
  String? get id => throw _privateConstructorUsedError;
  String get templateName => throw _privateConstructorUsedError;
  AddressModel get addressData => throw _privateConstructorUsedError;
  ContactInfoModel get contactInfo => throw _privateConstructorUsedError;
  int? get price => throw _privateConstructorUsedError;

  /// Create a copy of TemplateModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TemplateModelCopyWith<TemplateModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TemplateModelCopyWith<$Res> {
  factory $TemplateModelCopyWith(
          TemplateModel value, $Res Function(TemplateModel) then) =
      _$TemplateModelCopyWithImpl<$Res, TemplateModel>;
  @useResult
  $Res call(
      {String? id,
      String templateName,
      AddressModel addressData,
      ContactInfoModel contactInfo,
      int? price});

  $AddressModelCopyWith<$Res> get addressData;
  $ContactInfoModelCopyWith<$Res> get contactInfo;
}

/// @nodoc
class _$TemplateModelCopyWithImpl<$Res, $Val extends TemplateModel>
    implements $TemplateModelCopyWith<$Res> {
  _$TemplateModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TemplateModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? templateName = null,
    Object? addressData = null,
    Object? contactInfo = null,
    Object? price = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      templateName: null == templateName
          ? _value.templateName
          : templateName // ignore: cast_nullable_to_non_nullable
              as String,
      addressData: null == addressData
          ? _value.addressData
          : addressData // ignore: cast_nullable_to_non_nullable
              as AddressModel,
      contactInfo: null == contactInfo
          ? _value.contactInfo
          : contactInfo // ignore: cast_nullable_to_non_nullable
              as ContactInfoModel,
      price: freezed == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }

  /// Create a copy of TemplateModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AddressModelCopyWith<$Res> get addressData {
    return $AddressModelCopyWith<$Res>(_value.addressData, (value) {
      return _then(_value.copyWith(addressData: value) as $Val);
    });
  }

  /// Create a copy of TemplateModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ContactInfoModelCopyWith<$Res> get contactInfo {
    return $ContactInfoModelCopyWith<$Res>(_value.contactInfo, (value) {
      return _then(_value.copyWith(contactInfo: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$TemplateModelImplCopyWith<$Res>
    implements $TemplateModelCopyWith<$Res> {
  factory _$$TemplateModelImplCopyWith(
          _$TemplateModelImpl value, $Res Function(_$TemplateModelImpl) then) =
      __$$TemplateModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? id,
      String templateName,
      AddressModel addressData,
      ContactInfoModel contactInfo,
      int? price});

  @override
  $AddressModelCopyWith<$Res> get addressData;
  @override
  $ContactInfoModelCopyWith<$Res> get contactInfo;
}

/// @nodoc
class __$$TemplateModelImplCopyWithImpl<$Res>
    extends _$TemplateModelCopyWithImpl<$Res, _$TemplateModelImpl>
    implements _$$TemplateModelImplCopyWith<$Res> {
  __$$TemplateModelImplCopyWithImpl(
      _$TemplateModelImpl _value, $Res Function(_$TemplateModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of TemplateModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? templateName = null,
    Object? addressData = null,
    Object? contactInfo = null,
    Object? price = freezed,
  }) {
    return _then(_$TemplateModelImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      templateName: null == templateName
          ? _value.templateName
          : templateName // ignore: cast_nullable_to_non_nullable
              as String,
      addressData: null == addressData
          ? _value.addressData
          : addressData // ignore: cast_nullable_to_non_nullable
              as AddressModel,
      contactInfo: null == contactInfo
          ? _value.contactInfo
          : contactInfo // ignore: cast_nullable_to_non_nullable
              as ContactInfoModel,
      price: freezed == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc

class _$TemplateModelImpl implements _TemplateModel {
  const _$TemplateModelImpl(
      {this.id,
      required this.templateName,
      required this.addressData,
      required this.contactInfo,
      this.price});

  @override
  final String? id;
  @override
  final String templateName;
  @override
  final AddressModel addressData;
  @override
  final ContactInfoModel contactInfo;
  @override
  final int? price;

  @override
  String toString() {
    return 'TemplateModel(id: $id, templateName: $templateName, addressData: $addressData, contactInfo: $contactInfo, price: $price)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TemplateModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.templateName, templateName) ||
                other.templateName == templateName) &&
            (identical(other.addressData, addressData) ||
                other.addressData == addressData) &&
            (identical(other.contactInfo, contactInfo) ||
                other.contactInfo == contactInfo) &&
            (identical(other.price, price) || other.price == price));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, id, templateName, addressData, contactInfo, price);

  /// Create a copy of TemplateModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TemplateModelImplCopyWith<_$TemplateModelImpl> get copyWith =>
      __$$TemplateModelImplCopyWithImpl<_$TemplateModelImpl>(this, _$identity);
}

abstract class _TemplateModel implements TemplateModel {
  const factory _TemplateModel(
      {final String? id,
      required final String templateName,
      required final AddressModel addressData,
      required final ContactInfoModel contactInfo,
      final int? price}) = _$TemplateModelImpl;

  @override
  String? get id;
  @override
  String get templateName;
  @override
  AddressModel get addressData;
  @override
  ContactInfoModel get contactInfo;
  @override
  int? get price;

  /// Create a copy of TemplateModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TemplateModelImplCopyWith<_$TemplateModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
