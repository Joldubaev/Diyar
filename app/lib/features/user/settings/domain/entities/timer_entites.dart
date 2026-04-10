import 'package:equatable/equatable.dart';

class TimerEntity extends Equatable {
  const TimerEntity({
    this.startTime,
    this.endTime,
    this.isTechnicalWork,
    this.serverTime,
  });

  final String? startTime;
  final String? endTime;
  final bool? isTechnicalWork;
  final String? serverTime;

  @override
  List<Object?> get props => [
        startTime,
        endTime,
        isTechnicalWork,
        serverTime,
      ];
}

/// Backward compatibility alias
typedef TimerEntites = TimerEntity;
