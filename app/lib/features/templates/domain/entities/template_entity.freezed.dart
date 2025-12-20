// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'template_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$TemplateEntity {
  String? get id => throw _privateConstructorUsedError;
  String get templateName => throw _privateConstructorUsedError;
  AddressEntity get addressData => throw _privateConstructorUsedError;
  ContactInfoEntity get contactInfo => throw _privateConstructorUsedError;
  int? get price => throw _privateConstructorUsedError;

  /// Create a copy of TemplateEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TemplateEntityCopyWith<TemplateEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TemplateEntityCopyWith<$Res> {
  factory $TemplateEntityCopyWith(
          TemplateEntity value, $Res Function(TemplateEntity) then) =
      _$TemplateEntityCopyWithImpl<$Res, TemplateEntity>;
  @useResult
  $Res call(
      {String? id,
      String templateName,
      AddressEntity addressData,
      ContactInfoEntity contactInfo,
      int? price});

  $AddressEntityCopyWith<$Res> get addressData;
  $ContactInfoEntityCopyWith<$Res> get contactInfo;
}

/// @nodoc
class _$TemplateEntityCopyWithImpl<$Res, $Val extends TemplateEntity>
    implements $TemplateEntityCopyWith<$Res> {
  _$TemplateEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TemplateEntity
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
              as AddressEntity,
      contactInfo: null == contactInfo
          ? _value.contactInfo
          : contactInfo // ignore: cast_nullable_to_non_nullable
              as ContactInfoEntity,
      price: freezed == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }

  /// Create a copy of TemplateEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AddressEntityCopyWith<$Res> get addressData {
    return $AddressEntityCopyWith<$Res>(_value.addressData, (value) {
      return _then(_value.copyWith(addressData: value) as $Val);
    });
  }

  /// Create a copy of TemplateEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ContactInfoEntityCopyWith<$Res> get contactInfo {
    return $ContactInfoEntityCopyWith<$Res>(_value.contactInfo, (value) {
      return _then(_value.copyWith(contactInfo: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$TemplateEntityImplCopyWith<$Res>
    implements $TemplateEntityCopyWith<$Res> {
  factory _$$TemplateEntityImplCopyWith(_$TemplateEntityImpl value,
          $Res Function(_$TemplateEntityImpl) then) =
      __$$TemplateEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? id,
      String templateName,
      AddressEntity addressData,
      ContactInfoEntity contactInfo,
      int? price});

  @override
  $AddressEntityCopyWith<$Res> get addressData;
  @override
  $ContactInfoEntityCopyWith<$Res> get contactInfo;
}

/// @nodoc
class __$$TemplateEntityImplCopyWithImpl<$Res>
    extends _$TemplateEntityCopyWithImpl<$Res, _$TemplateEntityImpl>
    implements _$$TemplateEntityImplCopyWith<$Res> {
  __$$TemplateEntityImplCopyWithImpl(
      _$TemplateEntityImpl _value, $Res Function(_$TemplateEntityImpl) _then)
      : super(_value, _then);

  /// Create a copy of TemplateEntity
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
    return _then(_$TemplateEntityImpl(
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
              as AddressEntity,
      contactInfo: null == contactInfo
          ? _value.contactInfo
          : contactInfo // ignore: cast_nullable_to_non_nullable
              as ContactInfoEntity,
      price: freezed == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc

class _$TemplateEntityImpl implements _TemplateEntity {
  const _$TemplateEntityImpl(
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
  final AddressEntity addressData;
  @override
  final ContactInfoEntity contactInfo;
  @override
  final int? price;

  @override
  String toString() {
    return 'TemplateEntity(id: $id, templateName: $templateName, addressData: $addressData, contactInfo: $contactInfo, price: $price)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TemplateEntityImpl &&
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

  /// Create a copy of TemplateEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TemplateEntityImplCopyWith<_$TemplateEntityImpl> get copyWith =>
      __$$TemplateEntityImplCopyWithImpl<_$TemplateEntityImpl>(
          this, _$identity);
}

abstract class _TemplateEntity implements TemplateEntity {
  const factory _TemplateEntity(
      {final String? id,
      required final String templateName,
      required final AddressEntity addressData,
      required final ContactInfoEntity contactInfo,
      final int? price}) = _$TemplateEntityImpl;

  @override
  String? get id;
  @override
  String get templateName;
  @override
  AddressEntity get addressData;
  @override
  ContactInfoEntity get contactInfo;
  @override
  int? get price;

  /// Create a copy of TemplateEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TemplateEntityImplCopyWith<_$TemplateEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
