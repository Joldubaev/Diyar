part of 'remote_config_cubit.dart';

class RemoteConfigState extends Equatable {
  const RemoteConfigState({
    this.appVersionStatus = const NoNewVersion(),
    this.isHatimEnable = true,
    this.deviceId,
  });

  final AppVersionStatus appVersionStatus;
  final String? deviceId;
  final bool isHatimEnable;

  @override
  List<Object?> get props => [
        appVersionStatus,
        deviceId,
        isHatimEnable,
      ];

  RemoteConfigState copyWith({
    AppVersionStatus? appVersionStatus,
    String? deviceId,
    bool? isHatimEnable,
  }) {
    return RemoteConfigState(
      appVersionStatus: appVersionStatus ?? this.appVersionStatus,
      isHatimEnable: isHatimEnable ?? this.isHatimEnable,
      deviceId: deviceId ?? this.deviceId,
    );
  }
}

@immutable
sealed class AppVersionStatus {
  const AppVersionStatus();
}

final class NoNewVersion extends AppVersionStatus {
  const NoNewVersion();
}

final class YesRecommendedVersion extends AppVersionStatus {
  const YesRecommendedVersion(this.buildNumber);

  final int buildNumber;
}

final class YesRequiredVersion extends AppVersionStatus {
  const YesRequiredVersion(this.buildNumber);

  final int buildNumber;
}
