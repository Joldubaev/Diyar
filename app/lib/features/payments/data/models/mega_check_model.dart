import 'package:diyar/features/payments/domain/domain.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'mega_check_model.freezed.dart';
part 'mega_check_model.g.dart';

@freezed
class MegaCheckModel with _$MegaCheckModel {
  const factory MegaCheckModel({
    int? commission,
    int? amount,
  }) = _MegaCheckModel;

  factory MegaCheckModel.fromJson(Map<String, dynamic> json) =>
      _$MegaCheckModelFromJson(json);

  factory MegaCheckModel.fromEntity(MegaCheckEntity entity) => MegaCheckModel(
        commission: entity.commission,
        amount: entity.amount,
      );
}

extension MegaCheckModelX on MegaCheckModel {
  MegaCheckEntity toEntity() => MegaCheckEntity(
        commission: commission,
        amount: amount,
      );
}
