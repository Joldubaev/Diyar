import 'package:diyar/core/core.dart';
import 'package:diyar/features/active_order/active_order.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OrderStepper extends StatefulWidget {
  final OrderStatusEntity orderStatus;

  const OrderStepper({
    super.key,
    required this.orderStatus,
  });

  @override
  State<OrderStepper> createState() => _OrderStepperState();
}

class _OrderStepperState extends State<OrderStepper> {
  int activeStep = 0;

  @override
  void initState() {
    super.initState();
    _updateStep();
  }

  @override
  void didUpdateWidget(covariant OrderStepper oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.orderStatus != widget.orderStatus) {
      _updateStep();
    }
  }

  void _updateStep() {
    setState(() {
      activeStep = _mapStatusToStep(widget.orderStatus.status ?? AppConst.awaits);
    });
  }

  final List<StepData> _steps = [
    StepData(icon: Icons.timer, title: 'Ожидает'),
    StepData(icon: Icons.restaurant_menu, title: 'Готовится'),
    StepData(icon: CupertinoIcons.car, title: 'В пути'),
    StepData(icon: Icons.check_circle_outline, title: 'Доставлен'),
  ];

  int _mapStatusToStep(String status) {
    switch (status) {
      case 'Awaits':
        return 0;
      case 'Processing':
        return 1;
      case 'OnTheWay':
        return 2;
      case 'Delivered':
        return 3;

      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Адаптивные размеры в зависимости от ширины экрана
        final screenWidth = constraints.maxWidth;
        final isSmallScreen = screenWidth < 360;

        final iconSize = isSmallScreen ? 32.0 : 40.0;
        final fontSize = isSmallScreen ? 10.0 : 12.0;
        final spacing = isSmallScreen ? 2.0 : 4.0;

        return SizedBox(
          height: isSmallScreen ? 80 : 100,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: List.generate(_steps.length, (index) {
              final isActive = index == activeStep;
              final isCompleted = index < activeStep;
              return Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      width: iconSize,
                      height: iconSize,
                      decoration: BoxDecoration(
                        color: isActive
                            ? AppColors.green
                            : isCompleted
                                ? AppColors.primary
                                : AppColors.grey.withValues(alpha: 0.5),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _steps[index].icon,
                        color: Colors.white,
                        size: iconSize * 0.6,
                      ),
                    ),
                    SizedBox(height: spacing),
                    Flexible(
                      child: Text(
                        _steps[index].title,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: fontSize,
                          color: isActive || isCompleted ? AppColors.primary : AppColors.grey.withValues(alpha: 0.5),
                          fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        );
      },
    );
  }
}

class StepData {
  final IconData icon;
  final String title;

  StepData({
    required this.icon,
    required this.title,
  });
}
