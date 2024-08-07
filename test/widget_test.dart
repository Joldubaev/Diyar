// import 'dart:convert';

// import 'package:diyar/core/remote_config/diyar_remote_config.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:firebase_remote_config/firebase_remote_config.dart';
// import 'package:mocktail/mocktail.dart';

// class MockFirebaseRemoteConfig extends Mock implements FirebaseRemoteConfig {}

// void main() {
//   group('DiyarRemoteConfig', () {
//     late MockFirebaseRemoteConfig mockRemoteConfig;
//     late DiyarRemoteConfig diyarRemoteConfig;

//     setUp(() {
//       mockRemoteConfig = MockFirebaseRemoteConfig();
//       diyarRemoteConfig = DiyarRemoteConfig(
//         remoteConfig: mockRemoteConfig,
//         buildNumber: '100',
//       );

//       // Set up default return values for methods
//       when(() => mockRemoteConfig.getString(any())).thenReturn('{}');
//       when(() => mockRemoteConfig.getInt(any())).thenReturn(0);
//       when(() => mockRemoteConfig.getBool(any())).thenReturn(false);
//     });

//     test('get requiredBuildNumber returns correct value', () {
//       when(() => mockRemoteConfig.getInt('requiredBuildNumber'))
//           .thenReturn(101);

//       final requiredBuildNumber = diyarRemoteConfig.requiredBuildNumber;

//       expect(requiredBuildNumber, 101);
//     });

//     test('get version returns correct values', () {
//       // Mock the data
//       final mockData = jsonEncode({
//         'android': {
//           'requiredBuildNumber': 101,
//           'recommendedBuildNumber': 102,
//         },
//         'ios': {
//           'requiredBuildNumber': 103,
//           'recommendedBuildNumber': 104,
//         },
//       });
//       when(() => mockRemoteConfig.getString('appVersion')).thenReturn(mockData);

//       final version = diyarRemoteConfig.version;

//       expect(version.$1, 101);
//       expect(version.$2, 102);
//     });

//     test('hatimIsEnable returns correct value', () {
//       when(() => mockRemoteConfig.getBool('hatimIsEnable')).thenReturn(true);

//       final isEnabled = diyarRemoteConfig.hatimIsEnable;

//       expect(isEnabled, true);
//     });
//   });
// }
