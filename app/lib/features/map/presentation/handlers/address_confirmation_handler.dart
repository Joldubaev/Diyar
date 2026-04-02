import 'package:auto_route/auto_route.dart';
import 'package:diyar/common/components/bottom_sheets/address_confirm_bottom_sheet.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/core/di/injectable_config.dart';
import 'package:diyar/core/utils/storage/address_storage_service.dart';
import 'package:diyar/features/map/data/repositories/yandex_service.dart';
import 'package:flutter/material.dart';

/// Handles address confirmation dialog display.
///
/// All logic (check, display, result handling) is centralized here.
/// Called from [HomeTabPage] on startup and when returning from background.
abstract class AddressConfirmationHandler {
  static Future<void> checkAndShow(
    BuildContext context, {
    required VoidCallback onAddressChanged,
  }) async {
    final storage = sl<AddressStorageService>();
    final locationService = sl<AppLocation>();

    if (!storage.isAddressSelected()) return;

    final address = storage.getAddress();
    if (address == null || !context.mounted) return;

    // Migration: initialize zone snapshot from saved address on first run.
    if (storage.getConfirmedInServiceZone() == null) {
      final savedLat = storage.getLat();
      final savedLon = storage.getLon();
      if (savedLat != null && savedLon != null) {
        final savedInServiceZone =
            await MapHelper.isPointInServiceZone(savedLat, savedLon);
        final savedZoneId =
            await MapHelper.getYandexIdForCoordinate(savedLat, savedLon);
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
    final currentInServiceZone = await MapHelper.isPointInServiceZone(
      position.latitude,
      position.longitude,
    );
    final currentZoneId = await MapHelper.getYandexIdForCoordinate(
      position.latitude,
      position.longitude,
    );

    final shouldShow = storage.shouldShowAddressConfirmationForZone(
      currentInServiceZone: currentInServiceZone,
      currentZoneId: currentZoneId,
    );
    if (!shouldShow) return;
    if (!context.mounted) return;

    final result = await showAddressConfirmBottomSheet(
      context,
      address: address,
    );

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
