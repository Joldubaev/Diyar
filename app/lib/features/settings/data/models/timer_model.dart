import '../../domain/entities/timer_entites.dart';

class TimerModel {
  final String? startTime;
  final String? endTime;
  final bool? isTechnicalWork;
  final String? serverTime;

  TimerModel({
    this.startTime,
    this.endTime,
    this.isTechnicalWork,
    this.serverTime,
  });

  TimerModel copyWith({
    String? startTime,
    String? endTime,
    bool? isTechnicalWork,
    String? serverTime,
  }) =>
      TimerModel(
        startTime: startTime ?? this.startTime,
        endTime: endTime ?? this.endTime,
        isTechnicalWork: isTechnicalWork ?? this.isTechnicalWork,
        serverTime: serverTime ?? this.serverTime,
      );

  factory TimerModel.fromJson(Map<String, dynamic> json) {
    return TimerModel(
      startTime: json['startTime'] as String?,
      endTime: json['endTime'] as String?,
      isTechnicalWork: json['isTechnicalWork'] as bool?,
      serverTime: json['serverTime'] as String?,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'startTime': startTime,
      'endTime': endTime,
      'isTechnicalWork': isTechnicalWork,
      'serverTime': serverTime,
    };
  }

  TimerModel fromEntity(TimerEntites entity) {
    return TimerModel(
      startTime: entity.startTime,
      endTime: entity.endTime,
      isTechnicalWork: entity.isTechnicalWork,
      serverTime: entity.serverTime,
    );
  }

  TimerEntites toEntity() {
    return TimerEntites(
      startTime: startTime,
      endTime: endTime,
      isTechnicalWork: isTechnicalWork,
      serverTime: serverTime,
    );
  }
}
