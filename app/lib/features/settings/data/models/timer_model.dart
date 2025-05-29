import '../../domain/entities/timer_entites.dart';

class TimerModel {
    final String? startTime;
    final String? endTime;
    final bool? isTechnicalWork;

    TimerModel({
        this.startTime,
        this.endTime,
        this.isTechnicalWork,
    });

    TimerModel copyWith({
        String? startTime,
        String? endTime,
        bool? isTechnicalWork,
    }) => 
        TimerModel(
            startTime: startTime ?? this.startTime,
            endTime: endTime ?? this.endTime,
            isTechnicalWork: isTechnicalWork ?? this.isTechnicalWork,
        );

  factory TimerModel.fromJson(Map<String, dynamic> json) {
    return TimerModel(
      startTime: json['startTime'] as String?,
      endTime: json['endTime'] as String?,
      isTechnicalWork: json['isTechnicalWork'] as bool?,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'startTime': startTime,
      'endTime': endTime,
      'isTechnicalWork': isTechnicalWork,
    };
  }
  
  
  TimerModel fromEntity(TimerEntites entity) {
    return TimerModel(
      startTime: entity.startTime,
      endTime: entity.endTime,
      isTechnicalWork: entity.isTechnicalWork,
    );
  }

  TimerEntites toEntity() {
    return TimerEntites(
      startTime: startTime,
      endTime: endTime,
      isTechnicalWork: isTechnicalWork,
    );
  }
}
