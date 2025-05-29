import 'package:equatable/equatable.dart';

class TimerEntites extends Equatable {
  const TimerEntites({
    this.startTime,
    this.endTime,
    this.isTechnicalWork,
  });

  final String? startTime;
  final String? endTime;
  final bool? isTechnicalWork;
  @override
  List<Object?> get props => [
        startTime,
        endTime,
        isTechnicalWork,
      ];
}
