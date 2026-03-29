import 'package:auto_route/auto_route.dart';
import 'package:diyar/common/components/bottom_sheets/address_confirm_bottom_sheet.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/core/di/injectable_config.dart';
import 'package:diyar/core/utils/storage/address_storage_service.dart';
import 'package:diyar/features/map/data/repositories/yandex_service.dart';
import 'package:diyar/features/map/presentation/widgets/coordinats_backup.dart';
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
    final locationService = sl<AppLocation>();

    if (!storage.isAddressSelected()) return;

    final address = storage.getAddress();
    if (address == null || !context.mounted) return;

    // Миграция: если snapshot зоны ещё не сохранен, инициализируем его
    // от текущего сохраненного адреса и не показываем диалог на этом заходе.
    if (storage.getConfirmedInServiceZone() == null) {
      final savedLat = storage.getLat();
      final savedLon = storage.getLon();
      if (savedLat != null && savedLon != null) {
        final savedInServiceZone = MapHelper.isPointInServiceZone(savedLat, savedLon);
        final savedZoneId = MapHelper.getYandexIdForCoordinate(
          savedLat,
          savedLon,
          polygons: Polygons.getPolygons(),
        );
        await storage.saveConfirmedZoneSnapshot(
          inServiceZone: savedInServiceZone,
          zoneId: savedZoneId,
        );
      }
      return;
    }

    final hasPermission = await locationService.checkPermission();
    if (!hasPermission) return;

    final position = await locationService.getCurrentLocation();
    final currentInServiceZone = MapHelper.isPointInServiceZone(
      position.latitude,
      position.longitude,
    );
    final currentZoneId = MapHelper.getYandexIdForCoordinate(
      position.latitude,
      position.longitude,
      polygons: Polygons.getPolygons(),
    );

    final shouldShow = storage.shouldShowAddressConfirmationForZone(
      currentInServiceZone: currentInServiceZone,
      currentZoneId: currentZoneId,
    );
    if (!shouldShow) return;
    if (!context.mounted) return;

    final result = await showAddressConfirmBottomSheet(context, address: address);

    if (!context.mounted) return;

    if (result == true) {
      await storage.confirmAddress();
      await storage.saveConfirmedZoneSnapshot(
        inServiceZone: currentInServiceZone,
        zoneId: currentZoneId,
      );
    } else if (result == false) {
      final router = context.router;
      await router.push(const AddressSelectionRoute());
      onAddressChanged();
    }
  }
}
