import 'package:diyar/core/core.dart';
import 'package:auto_route/auto_route.dart';
import 'package:diyar/features/auth/auth.dart';
import 'package:diyar/injection_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:developer';

@RoutePage()
class PinCodePage extends StatefulWidget {
  const PinCodePage({super.key});

  @override
  State<PinCodePage> createState() => _PinCodePageState();
}

class _PinCodePageState extends State<PinCodePage> {
  String _enteredPin = '';
  String? _correctPin;
  bool _isBiometricAvailable = false;
  bool _isBiometricEnabled = false;

  @override
  void initState() {
    super.initState();
    context.read<SignInCubit>().getPinCode();
    context.read<SignInCubit>().checkBiometricsAvailability();
  }

  void _onNumberPressed(int number, bool isLoadingPin, bool isAuthenticatingBiometric) {
    if (isLoadingPin || isAuthenticatingBiometric || _enteredPin.length >= 4) return;
    setState(() {
      _enteredPin += number.toString();
      if (_enteredPin.length == 4) {
        _validateEnteredPin();
      }
    });
  }

  void _onBackspacePressed(bool isLoadingPin, bool isAuthenticatingBiometric) {
    if (isLoadingPin || isAuthenticatingBiometric || _enteredPin.isEmpty) return;
    setState(() {
      _enteredPin = _enteredPin.substring(0, _enteredPin.length - 1);
    });
  }

  void _onBiometricPressed(bool isLoadingPin, bool isAuthenticatingBiometric) {
    if (isLoadingPin || isAuthenticatingBiometric) return;
    context.read<SignInCubit>().authenticateWithBiometrics();
  }

  void _onExitPressed(bool isLoadingPin, bool isAuthenticatingBiometric) {
    if (isLoadingPin || isAuthenticatingBiometric) return;
    AuthDialogs.showExitDialog(context, () {
      context.read<SignInCubit>().logout();
    });
  }

  void _validateEnteredPin() {
    if (_correctPin == null) {
      log("Error: Correct PIN is null during validation.");
      showToast("Не удалось загрузить PIN-код для проверки.", isError: true);
      context.read<SignInCubit>().getPinCode();
      setState(() => _enteredPin = '');
      return;
    }

    if (_enteredPin == _correctPin) {
      _navigateToHome();
    } else {
      showToast("Неверный PIN-код", isError: true);
      setState(() => _enteredPin = '');
    }
  }

  void _navigateToHome() {
    final role = sl<LocalStorage>().getString(AppConst.userRole);
    log("Navigating home with role: $role");

    PageRouteInfo targetRoute;
    if (role == "Courier") {
      targetRoute = const CurierRoute();
    } else {
      targetRoute = const MainHomeRoute();
    }

    context.router.pushAndPopUntil(targetRoute, predicate: (_) => false);
  }

  Widget _buildPinDots(bool isLoadingPin) {
    if (isLoadingPin) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 20.0),
        child: CupertinoActivityIndicator(),
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        4,
        (index) => Container(
          margin: const EdgeInsets.all(16.0),
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: index < _enteredPin.length ? Theme.of(context).primaryColor : Colors.grey.shade300,
          ),
        ),
      ),
    );
  }

  Widget _buildNumberButton(int number, bool disabled) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: TextButton(
        onPressed: disabled ? null : () => _onNumberPressed(number, disabled, disabled),
        style: TextButton.styleFrom(
          foregroundColor: Colors.black,
          shape: const CircleBorder(),
          padding: const EdgeInsets.all(16),
        ),
        child: Text(
          number.toString(),
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildNumpad(bool disabled) {
    return Column(
      children: [
        for (var i = 0; i < 3; i++)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                3,
                (index) => _buildNumberButton(1 + 3 * i + index, disabled),
              ).toList(),
            ),
          ),
      ],
    );
  }

  Widget _buildActionRow(bool disabled) {
    final buttonDisabled = disabled;

    Widget leftButton;
    if (_isBiometricAvailable && _isBiometricEnabled) {
      leftButton = IconButton(
        iconSize: 30,
        icon: Icon(
          Icons.fingerprint,
          color: buttonDisabled ? Colors.grey : Colors.blue,
        ),
        onPressed: buttonDisabled ? null : () => _onBiometricPressed(buttonDisabled, buttonDisabled),
      );
    } else {
      leftButton = TextButton(
        onPressed: buttonDisabled ? null : () => _onExitPressed(buttonDisabled, buttonDisabled),
        child: Text(
          "Выйти",
          style: TextStyle(
            color: buttonDisabled ? Colors.grey : Colors.red,
            fontSize: 12,
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(width: 64, child: Center(child: leftButton)),
          _buildNumberButton(0, buttonDisabled),
          SizedBox(
            width: 64,
            child: Center(
              child: IconButton(
                iconSize: 24,
                icon: Icon(
                  Icons.backspace_outlined,
                  color: buttonDisabled ? Colors.grey : Colors.black54,
                ),
                onPressed: buttonDisabled ? null : () => _onBackspacePressed(buttonDisabled, buttonDisabled),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocListener<SignInCubit, SignInState>(
        listener: (context, state) {
          log("PinCodePage Listener State: ${state.runtimeType}");
          if (state is PinCodeGetSuccess) {
            _correctPin = state.pinCode;
            log("Correct PIN loaded.");
          } else if (state is PinCodeGetFailure) {
            showToast("Ошибка загрузки PIN-кода: ${state.message}", isError: true);
          } else if (state is BiometricAvailable) {
            setState(() {
              _isBiometricAvailable = true;
              _isBiometricEnabled = state.isBiometricEnabled;
            });
            log("Biometrics Available: true, Enabled: ${state.isBiometricEnabled}");
            if (state.isBiometricEnabled) {
              context.read<SignInCubit>().authenticateWithBiometrics();
            }
          } else if (state is BiometricNotAvailable) {
            setState(() {
              _isBiometricAvailable = false;
              _isBiometricEnabled = false;
            });
            log("Biometrics Not Available");
          } else if (state is BiometricAuthenticationSuccess) {
            log("Biometric Authentication Success via Listener");
            _navigateToHome();
          } else if (state is BiometricAuthenticationFailure) {
            log("Biometric Authentication Failed: ${state.message}");
            showToast("Ошибка биометрии: ${state.message}", isError: true);
          } else if (state is LogoutSuccess) {
            context.router.replace(const SignInRoute());
          } else if (state is LogoutFailure) {
            showToast("Ошибка выхода: ${state.message}", isError: true);
          }
        },
        child: BlocBuilder<SignInCubit, SignInState>(
          builder: (context, state) {
            final bool isLoadingPin = state is SignInLoading;
            final bool isAuthenticatingBiometric = state is BiometricAuthenticating;
            final bool isDisabled = isLoadingPin || isAuthenticatingBiometric;

            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Spacer(flex: 2),
                    Text(
                      "Введите PIN-код",
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 30),
                    _buildPinDots(isLoadingPin),
                    const SizedBox(height: 40),
                    _buildNumpad(isDisabled),
                    const SizedBox(height: 20),
                    _buildActionRow(isDisabled),
                    if (isAuthenticatingBiometric)
                      const Padding(
                        padding: EdgeInsets.only(top: 20.0),
                        child: CupertinoActivityIndicator(),
                      ),
                    const Spacer(flex: 1),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
