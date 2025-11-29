import 'package:diyar/features/settings/domain/entities/timer_entites.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'timer_model.freezed.dart';
part 'timer_model.g.dart';

@freezed
class TimerModel with _$TimerModel {
  const factory TimerModel({
    String? startTime,
    String? endTime,
    bool? isTechnicalWork,
    String? serverTime,
  }) = _TimerModel;

  factory TimerModel.fromJson(Map<String, dynamic> json) =>
      _$TimerModelFromJson(json);

  factory TimerModel.fromEntity(TimerEntites entity) => TimerModel(
        startTime: entity.startTime,
        endTime: entity.endTime,
        isTechnicalWork: entity.isTechnicalWork,
        serverTime: entity.serverTime,
      );
}

extension TimerModelX on TimerModel {
  TimerEntites toEntity() => TimerEntites(
        startTime: startTime,
        endTime: endTime,
        isTechnicalWork: isTechnicalWork,
        serverTime: serverTime,
      );
}
