import 'package:diyar/core/core.dart';
import 'package:auto_route/auto_route.dart';
import 'package:diyar/features/auth/presentation/cubit/sign_in/sign_in_cubit.dart';
import 'package:diyar/features/auth/presentation/widgets/pin_numpad_widget.dart';
import 'package:diyar/injection_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:developer';

@RoutePage()
class SetNewPinCodePage extends StatefulWidget {
  const SetNewPinCodePage({super.key});

  @override
  State<SetNewPinCodePage> createState() => _SetNewPinCodePageState();
}

class _SetNewPinCodePageState extends State<SetNewPinCodePage> {
  String _enteredPin = '';
  String _confirmPin = '';
  bool _isConfirming = false;
  bool _isPinMismatch = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onNumberPressed(int number) {
    if ((_isConfirming ? _confirmPin : _enteredPin).length >= 4) return;

    setState(() {
      if (!_isConfirming) {
        _enteredPin += number.toString();
        if (_enteredPin.length == 4) {
          _isConfirming = true;
        }
      } else {
        _confirmPin += number.toString();
        if (_confirmPin.length == 4) {
          _validatePins();
        }
      }
    });
  }

  void _onBackspacePressed() {
    if (_isConfirming) {
      if (_confirmPin.isEmpty) return;
      setState(() {
        _confirmPin = _confirmPin.substring(0, _confirmPin.length - 1);
        _isPinMismatch = false;
      });
    } else {
      if (_enteredPin.isEmpty) return;
      setState(() {
        _enteredPin = _enteredPin.substring(0, _enteredPin.length - 1);
      });
    }
  }

  void _onBackPressed() {
    setState(() {
      _isConfirming = false;
      _confirmPin = '';
      _enteredPin = '';
      _isPinMismatch = false;
    });
  }

  void _validatePins() {
    if (_enteredPin != _confirmPin) {
      setState(() {
        _isPinMismatch = true;
      });
      showToast("PIN-коды не совпадают", isError: true);
      setState(() => _confirmPin = '');
    } else {
      log("PINs match. Setting PIN: $_confirmPin");
      context.read<SignInCubit>().setPinCode(_confirmPin);
    }
  }

  void _navigateToHome() {
    final role = sl<LocalStorage>().getString(AppConst.userRole);
    log("Navigating home with role: $role");

    PageRouteInfo targetRoute;
    if (role == "Courier") {
      targetRoute = const CurierRoute();
    } else {
      targetRoute = const MainRoute();
    }

    context.router.pushAndPopUntil(targetRoute, predicate: (_) => false);
  }

  Widget _buildPinDots(String pinToShow, bool isLoading, bool isMismatch) {
    final Color activeColor = isMismatch ? Colors.red : Theme.of(context).primaryColor;
    final Color inactiveColor = Colors.grey.shade300;
    final Color loadingColor = Colors.grey;

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
            color: isLoading
                ? loadingColor
                : index < pinToShow.length
                    ? activeColor
                    : inactiveColor,
          ),
        ),
      ),
    );
  }

  Widget _buildZeroButton(bool disabled) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: TextButton(
        onPressed: disabled ? null : () => _onNumberPressed(0),
        style: TextButton.styleFrom(
          foregroundColor: Colors.black,
          shape: const CircleBorder(),
          padding: const EdgeInsets.all(16),
          minimumSize: const Size(64, 64),
        ),
        child: const Text(
          "0",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildActionRow(bool disabled) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 64,
            child: Center(
              child: IconButton(
                iconSize: 24,
                icon: Icon(
                  Icons.arrow_back,
                  color: disabled ? Colors.grey : Colors.black54,
                ),
                onPressed: disabled ? null : _onBackPressed,
              ),
            ),
          ),
          _buildZeroButton(disabled),
          SizedBox(
            width: 64,
            child: Center(
              child: IconButton(
                iconSize: 24,
                icon: Icon(
                  Icons.backspace_outlined,
                  color: disabled ? Colors.grey : Colors.black54,
                ),
                onPressed: disabled ? null : _onBackspacePressed,
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
      body: BlocConsumer<SignInCubit, SignInState>(
        listener: (context, state) {
          log("SetNewPinCodePage Listener State: ${state.runtimeType}");
          if (state is PinCodeSetSuccess) {
            log("PIN code set successfully. Navigating home.");
            _navigateToHome();
          } else if (state is PinCodeSetFailure) {
            showToast("Ошибка установки PIN-кода: ${state.message}", isError: true);
            setState(() {
              _confirmPin = '';
              _isConfirming = true;
              _isPinMismatch = false;
            });
          }
        },
        builder: (context, state) {
          final isLoading = state is SignInLoading;
          final pinToShow = _isConfirming ? _confirmPin : _enteredPin;
          final bool isDisabled = isLoading;

          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Spacer(flex: 2),
                  Text(
                    isLoading
                        ? "Сохранение PIN-кода..."
                        : _isConfirming
                            ? "Подтвердите PIN-код"
                            : "Создайте новый PIN-код",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 30),
                  _buildPinDots(pinToShow, isLoading, _isConfirming && _isPinMismatch),
                  const SizedBox(height: 40),
                  PinNumpadWidget(
                    onNumberPressed: _onNumberPressed,
                    disabled: isDisabled,
                  ),
                  const SizedBox(height: 20),
                  _buildActionRow(isDisabled),
                  if (isLoading)
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
    );
  }
}
