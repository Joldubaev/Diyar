import 'package:auto_route/auto_route.dart';
import 'package:diyar/common/components/bottom_sheets/address_confirm_bottom_sheet.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/core/di/injectable_config.dart';
import 'package:diyar/core/utils/storage/address_storage_service.dart';
import 'package:flutter/material.dart';

/// Отвечает за показ диалога подтверждения адреса.
///
/// Вся логика (проверка, показ, обработка результата) сосредоточена здесь.
/// Вызывается из [HomeTabPage] при старте и при возврате из фона.
abstract class AddressConfirmationHandler {
  /// Проверяет, нужно ли показать диалог, и если да — показывает его.
  ///
  /// [onAddressChanged] вызывается, если пользователь выбрал новый адрес.
  static Future<void> checkAndShow(
    BuildContext context, {
    required VoidCallback onAddressChanged,
  }) async {
    final storage = sl<AddressStorageService>();

    if (!storage.shouldShowAddressConfirmation()) return;

    final address = storage.getAddress();
    if (address == null || !context.mounted) return;

    final result = await showAddressConfirmBottomSheet(context, address: address);

    if (!context.mounted) return;

    if (result == true) {
      await storage.confirmAddress();
    } else if (result == false) {
      await context.router.push(const AddressSelectionRoute());
      onAddressChanged();
    }
  }
}
