import 'package:diyar/core/network/error/failures.dart';
import 'package:diyar/features/auth/domain/domain.dart';
import 'package:diyar/features/auth/domain/usecases/refresh_token_if_needed_usecase.dart';
import 'package:diyar/features/auth/domain/usecases/verify_sms_code_and_handle_first_launch_usecase.dart';
import 'package:diyar/features/auth/presentation/cubit/sign_in/sign_in_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockVerifySmsCodeUseCase extends Mock
    implements VerifySmsCodeAndHandleFirstLaunchUseCase {}

class MockRefreshTokenUseCase extends Mock
    implements RefreshTokenIfNeededUseCase {}

class FakeResetPasswordEntity extends Fake implements ResetPasswordEntity {}

void main() {
  late SignInCubit cubit;
  late MockAuthRepository mockRepo;
  late MockVerifySmsCodeUseCase mockVerify;
  late MockRefreshTokenUseCase mockRefresh;

  setUpAll(() {
    registerFallbackValue(FakeResetPasswordEntity());
  });

  setUp(() {
    mockRepo = MockAuthRepository();
    mockVerify = MockVerifySmsCodeUseCase();
    mockRefresh = MockRefreshTokenUseCase();
    cubit = SignInCubit(mockRepo, mockVerify, mockRefresh);
  });

  tearDown(() => cubit.close());

  group('sendSmsCode', () {
    test('emits Loading then SmsCodeSentForLogin on success', () async {
      when(() => mockRepo.sendVerificationCode('996555123456'))
          .thenAnswer((_) async => const Right(null));

      final states = <SignInState>[];
      final sub = cubit.stream.listen(states.add);

      await cubit.sendSmsCode('996555123456');
      await Future.delayed(Duration.zero);
      await sub.cancel();

      expect(states, [
        isA<SignInLoading>(),
        isA<SmsCodeSentForLogin>(),
      ]);
      expect((states[1] as SmsCodeSentForLogin).phone, '996555123456');
    });

    test('emits Loading then SignInFailure on error', () async {
      when(() => mockRepo.sendVerificationCode(any()))
          .thenAnswer((_) async => Left(ServerFailure('SMS error')));

      final states = <SignInState>[];
      final sub = cubit.stream.listen(states.add);

      await cubit.sendSmsCode('996555000000');
      await Future.delayed(Duration.zero);
      await sub.cancel();

      expect(states, [
        isA<SignInLoading>(),
        isA<SignInFailure>(),
      ]);
      expect((states[1] as SignInFailure).message, 'SMS error');
    });
  });

  group('verifySmsCode', () {
    test('emits Loading then SignInSuccessWithUser on success', () async {
      when(() => mockVerify.call('996555123456', '123456'))
          .thenAnswer((_) async => const Right(null));

      final states = <SignInState>[];
      final sub = cubit.stream.listen(states.add);

      await cubit.verifySmsCode('996555123456', '123456');
      await Future.delayed(Duration.zero);
      await sub.cancel();

      expect(states, [
        isA<SignInLoading>(),
        isA<SignInSuccessWithUser>(),
      ]);
    });
  });

  group('logout', () {
    test('emits LogoutSuccess on success', () async {
      when(() => mockRepo.logout()).thenAnswer((_) async {});

      final states = <SignInState>[];
      final sub = cubit.stream.listen(states.add);

      await cubit.logout();
      await Future.delayed(Duration.zero);
      await sub.cancel();

      expect(states, [isA<LogoutSuccess>()]);
    });

    test('emits LogoutFailure on error', () async {
      when(() => mockRepo.logout()).thenThrow(Exception('fail'));

      final states = <SignInState>[];
      final sub = cubit.stream.listen(states.add);

      await cubit.logout();
      await Future.delayed(Duration.zero);
      await sub.cancel();

      expect(states, [isA<LogoutFailure>()]);
    });
  });

  group('refreshTokenIfNeeded', () {
    test('emits RefreshTokenLoaded on success', () async {
      when(() => mockRefresh.call())
          .thenAnswer((_) async => const Right(null));

      final states = <SignInState>[];
      final sub = cubit.stream.listen(states.add);

      await cubit.refreshTokenIfNeeded();
      await Future.delayed(Duration.zero);
      await sub.cancel();

      expect(states, [isA<RefreshTokenLoaded>()]);
    });

    test('emits RefreshTokenFailure on error', () async {
      when(() => mockRefresh.call())
          .thenAnswer((_) async => Left(ServerFailure('expired')));

      final states = <SignInState>[];
      final sub = cubit.stream.listen(states.add);

      await cubit.refreshTokenIfNeeded();
      await Future.delayed(Duration.zero);
      await sub.cancel();

      expect(states, [isA<RefreshTokenFailure>()]);
    });
  });

  group('unformatPhoneNumber', () {
    test('removes non-digit characters', () {
      expect(cubit.unformatPhoneNumber('+996 (555) 12 34 56'), '996555123456');
      expect(cubit.unformatPhoneNumber('996555123456'), '996555123456');
    });
  });
}
