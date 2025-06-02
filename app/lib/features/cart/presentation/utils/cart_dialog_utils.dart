import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:diyar/core/core.dart'; // Предполагается, что SubmitButtonWidget и маршруты доступны через это
import 'package:diyar/features/cart/domain/domain.dart';
import 'package:diyar/l10n/l10n.dart';
import 'package:flutter/material.dart';

// Вспомогательная функция для парсинга времени из строки "ЧЧ:ММ" или "ЧЧ:ММ:СС"
TimeOfDay _parseTimeOfDay(String timeString) {
  try {
    final parts = timeString.split(':');
    if (parts.length >= 2) {
      // Должно быть как минимум 2 части (часы и минуты)
      final hour = int.tryParse(parts[0]);
      final minute = int.tryParse(parts[1]);
      if (hour != null && minute != null && hour >= 0 && hour <= 23 && minute >= 0 && minute <= 59) {
        return TimeOfDay(hour: hour, minute: minute);
      }
    }
  } catch (e) {
    log("Ошибка парсинга времени: $timeString, $e");
  }
  // Возвращаем значение по умолчанию в случае ошибки
  log("Не удалось распарсить время '$timeString', используется полночь по умолчанию.");
  return const TimeOfDay(hour: 0, minute: 0);
}

// Основная функция, которую будет вызывать LoadedCartView
void showOrderDialogs({
  required BuildContext context,
  required List<CartItemEntity> cartItems,
  required int totalPrice,
  required String? startWorkTimeString,
  required String? endWorkTimeString,
  required String? serverTimeString, // Новое поле
}) {
  // // Сначала проверяем флаг технических работ
  // if (isTechnicalWork) {
  //   _showTechnicalWorkDialog(context);
  //   return;
  // }

  // Используем значения по умолчанию для строк времени, если они null
  final TimeOfDay startWorkTime = _parseTimeOfDay(startWorkTimeString ?? '10:00');
  final TimeOfDay endWorkTime = _parseTimeOfDay(endWorkTimeString ?? '22:00');

  // Парсим серверное время. Если оно null или некорректно, считаем магазин закрытым по умолчанию.
  final TimeOfDay currentTimeOfDay;
  if (serverTimeString != null) {
    currentTimeOfDay = _parseTimeOfDay(serverTimeString);
  } else {
    log("Ошибка: serverTimeString is null. Магазин будет считаться закрытым.");
    // Показываем диалог о закрытии, если серверное время недоступно
    _showClosedAlertDialog(context, startWorkTime, endWorkTime);
    return;
  }

  int timeOfDayToMinutes(TimeOfDay time) => time.hour * 60 + time.minute;

  final currentTimeInMinutes = timeOfDayToMinutes(currentTimeOfDay);
  final startWorkTimeInMinutes = timeOfDayToMinutes(startWorkTime);
  final endWorkTimeInMinutes = timeOfDayToMinutes(endWorkTime);

  bool isShopClosed;
  if (startWorkTimeInMinutes < endWorkTimeInMinutes) {
    // Обычный случай (например, 10:00 - 22:00)
    isShopClosed = currentTimeInMinutes < startWorkTimeInMinutes || currentTimeInMinutes >= endWorkTimeInMinutes;
  } else {
    // Случай, когда время работы переходит через полночь (например, 22:00 - 02:00)
    isShopClosed = currentTimeInMinutes < startWorkTimeInMinutes && currentTimeInMinutes >= endWorkTimeInMinutes;
  }

  if (isShopClosed) {
    _showClosedAlertDialog(context, startWorkTime, endWorkTime);
  } else {
    _showDeliveryOptionsBottomSheet(context, cartItems, totalPrice);
  }
}

// Диалоговое окно для технических работ
// Future<dynamic> _showTechnicalWorkDialog(BuildContext context) {
//   return showDialog(
//     context: context,
//     builder: (dialogContext) {
//       return AlertDialog(
//         contentPadding: const EdgeInsets.all(16),
//         titlePadding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
//         title: Text(
//           context.l10n.attention,
//           style: Theme.of(dialogContext).textTheme.titleMedium?.copyWith(
//                 color: Theme.of(dialogContext).colorScheme.error,
//                 fontWeight: FontWeight.bold,
//               ),
//           textAlign: TextAlign.center,
//         ),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text(
//               "Магазин временно закрыт на техническое обслуживание. Пожалуйста, попробуйте позже.", // TODO: Заменить на l10n
//               style: Theme.of(dialogContext).textTheme.bodyMedium,
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 15),
//             SubmitButtonWidget(
//               textStyle: Theme.of(dialogContext).textTheme.bodyLarge?.copyWith(
//                     color: Theme.of(dialogContext).colorScheme.onPrimary,
//                   ),
//               bgColor: Theme.of(dialogContext).colorScheme.primary,
//               title: context.l10n.close,
//               onTap: () => Navigator.of(dialogContext).pop(),
//             ),
//           ],
//         ),
//       );
//     },
//   );
// }

// Вспомогательные функции, сделаны приватными для этого файла
Future<dynamic> _showClosedAlertDialog(
  BuildContext context,
  TimeOfDay startWorkTime,
  TimeOfDay endWorkTime,
) {
  return showDialog(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        contentPadding: const EdgeInsets.all(16),
        titlePadding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        title: Text(
          'Внимание!', // Используйте l10n, если доступно: context.l10n.attention
          style: Theme.of(dialogContext).textTheme.titleMedium?.copyWith(
                color: Theme.of(dialogContext).colorScheme.error,
                fontWeight: FontWeight.bold,
              ),
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Мы работаем с${startWorkTime.hour.toString().padLeft(2, '0')}:${startWorkTime.minute.toString().padLeft(2, '0')} до ${endWorkTime.hour.toString().padLeft(2, '0')}:${endWorkTime.minute.toString().padLeft(2, '0')}. Пожалуйста, сделайте заказ позже.',
              style: Theme.of(dialogContext).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 15),
            SubmitButtonWidget(
              textStyle: Theme.of(dialogContext).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(dialogContext).colorScheme.onPrimary,
                  ),
              bgColor: Theme.of(dialogContext).colorScheme.primary,
              title: 'Закрыть', // Используйте l10n: context.l10n.close
              onTap: () => Navigator.of(dialogContext).pop(),
            ),
          ],
        ),
      );
    },
  );
}

Future<dynamic> _showDeliveryOptionsBottomSheet(
  BuildContext context,
  List<CartItemEntity> carts,
  int totalPrice,
) {
  final router = context.router;
  final l10n = context.l10n;

  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return DraggableScrollableSheet(
        initialChildSize: 0.38,
        minChildSize: 0.25,
        maxChildSize: 0.5,
        expand: false,
        builder: (context, scrollController) {
          return Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 16,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: ListView(
              controller: scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 5,
                    margin: const EdgeInsets.only(bottom: 18),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2.5),
                    ),
                  ),
                ),
                Text(
                  "Как оформить заказ?", // Замените на строковую заглушку, если l10n недоступен здесь
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  "Выберите удобный способ получения заказа", // Замените на строковую заглушку
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 28),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 6,
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          foregroundColor: Theme.of(context).colorScheme.onPrimary,
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                          router.push(OrderMapRoute(cart: carts, totalPrice: totalPrice));
                        },
                        child: Column(
                          children: [
                            Icon(Icons.delivery_dining, size: 32, color: Theme.of(context).colorScheme.onPrimary),
                            const SizedBox(height: 8),
                            Text(
                              l10n.delivery,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: Theme.of(context).colorScheme.onPrimary,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 18),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 6,
                          backgroundColor: Theme.of(context).colorScheme.secondary,
                          foregroundColor: Theme.of(context).colorScheme.onSecondary,
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                          router.push(PickupFormRoute(cart: carts, totalPrice: totalPrice));
                        },
                        child: Column(
                          children: [
                            Icon(Icons.store, size: 32, color: Theme.of(context).colorScheme.onSecondary),
                            const SizedBox(height: 8),
                            Text(
                              l10n.pickup,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: Theme.of(context).colorScheme.onSecondary,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
              ],
            ),
          );
        },
      );
    },
  );
}
