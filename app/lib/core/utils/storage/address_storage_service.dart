import 'package:diyar/core/constants/app_const/app_const.dart';
import 'package:diyar/core/utils/storage/local_storage.dart';

class AddressStorageService {
  final LocalStorage _localStorage;

  AddressStorageService(this._localStorage);

  Future<void> saveAddress(
    String address,
    double lat,
    double lon, {
    required double deliveryPrice,
  }) async {
    await _localStorage.setString(AppConst.savedAddress, address);
    await _localStorage.setDouble(AppConst.savedAddressLat, lat);
    await _localStorage.setDouble(AppConst.savedAddressLon, lon);
    await _localStorage.setDouble(AppConst.savedDeliveryPrice, deliveryPrice);
    await _localStorage.setBool(AppConst.addressSelected, true);
    await _confirmAddress();
  }

  String? getAddress() => _localStorage.getString(AppConst.savedAddress);

  double? getLat() => _localStorage.getDouble(AppConst.savedAddressLat);

  double? getLon() => _localStorage.getDouble(AppConst.savedAddressLon);

  double? getDeliveryPrice() =>
      _localStorage.getDouble(AppConst.savedDeliveryPrice);

  bool isAddressSelected() =>
      _localStorage.getBool(AppConst.addressSelected) ?? false;

  bool shouldShowAddressConfirmation() {
    return isAddressSelected();
  }

  Future<void> confirmAddress() async => _confirmAddress();

  bool? getConfirmedInServiceZone() {
    return _localStorage.getBool(AppConst.addressConfirmedInServiceZone);
  }

  int? getConfirmedZoneId() {
    final value = _localStorage.getInt(AppConst.addressConfirmedZoneId);
    return value == null || value <= 0 ? null : value;
  }

  Future<void> saveConfirmedZoneSnapshot({
    required bool inServiceZone,
    int? zoneId,
  }) async {
    await _localStorage.setBool(
      AppConst.addressConfirmedInServiceZone,
      inServiceZone,
    );
    await _localStorage.setInt(
      AppConst.addressConfirmedZoneId,
      zoneId ?? 0,
    );
  }

  bool shouldShowAddressConfirmationForZone({
    required bool currentInServiceZone,
    required int? currentZoneId,
  }) {
    if (!isAddressSelected()) return false;

    final confirmedInServiceZone = getConfirmedInServiceZone();
    final confirmedZoneId = getConfirmedZoneId();

    // Миграция старых данных: если слепка зоны нет, нужно однократное уточнение.
    if (confirmedInServiceZone == null) return true;

    if (currentInServiceZone != confirmedInServiceZone) return true;

    if (currentInServiceZone && confirmedInServiceZone) {
      return currentZoneId != confirmedZoneId;
    }

    return false;
  }

  Future<void> _confirmAddress() async {
    await _localStorage.setString(
      AppConst.addressConfirmDate,
      DateTime.now().toIso8601String(),
    );
  }
}
