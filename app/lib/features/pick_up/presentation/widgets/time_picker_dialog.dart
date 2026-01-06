import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Виджет диалога выбора времени
class PickupTimePickerDialog extends StatelessWidget {
  final DateTime initialTime;
  final DateTime minimumTime;
  final Function(DateTime) onTimeSelected;

  const PickupTimePickerDialog({
    super.key,
    required this.initialTime,
    required this.minimumTime,
    required this.onTimeSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    DateTime selectedTime = initialTime;

    return AlertDialog(
      title: Text(
        'Внимание! Время подготовки заказа займет не менее 15 минут',
        style: theme.textTheme.bodyMedium!.copyWith(
          fontSize: 16,
          color: theme.colorScheme.error,
        ),
        textAlign: TextAlign.center,
      ),
      content: SizedBox(
        height: 240,
        child: Column(
          children: [
            SizedBox(
              height: 160,
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.time,
                initialDateTime: initialTime,
                minuteInterval: 1,
                use24hFormat: true,
                onDateTimeChanged: (DateTime newTime) {
                  selectedTime = newTime;
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'Отмена',
                    style: theme.textTheme.bodyMedium!.copyWith(
                      fontSize: 16,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    final validatedTime = selectedTime.isAfter(minimumTime) ||
                            selectedTime.isAtSameMomentAs(minimumTime)
                        ? selectedTime
                        : minimumTime;
                    onTimeSelected(validatedTime);
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Подтвердить',
                    style: theme.textTheme.bodyMedium!.copyWith(
                      fontSize: 16,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

