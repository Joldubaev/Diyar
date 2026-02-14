import 'package:flutter/material.dart';

class AppConst {
  const AppConst._();

  static const locales = <Locale>[
    Locale('ru'),
    Locale('en'),
    Locale('ky'),
  ];

  static String getName(String code) {
    return switch (code) {
      'en' => 'English',
      'ru' => 'Русский',
      'ky' => 'Кыргыз',
      _ => 'Russian',
    };
  }

  static bool isLocalSupport(String deviceLocal) {
    return switch (deviceLocal) { 'en' || 'ru' || 'ky' => true, _ => false };
  }

  static const refreshToken = 'REFRESH_TOKEN';
  static const accessToken = 'ACCESS_TOKEN';
  static const langCode = 'LANGUAGE_CODE';
  static const userInfo = 'USER_INFORMATION';
  static const userId = 'USER_ID';
  static const userRole = 'USER_ROLE';
  static const prefs = 'PREFS';

  // Map
  static const getLocations = "6d9fa3b5-2a2b-46fa-838b-ce4e9fc4e4f8";
  static const email = 'Diyarcafe1996@mail.ru';
  static const phone = 'USER_PHONE';

  // terms and conditions
  static const terms =
      'https://docs.google.com/document/d/1jww3-H3VeV0l_zYQS7zmlKGzQYwOwFisOb3MaIo5bsQ/edit?usp=sharing';

  // instagram
  static const instagram = 'https://www.instagram.com/diyar.kg/';

  // order statuses

  static const awaits = "awaiting confirmation from the operator";
  static const cooked = "the order is being prepared";
  static const delivered = "order is being delivered";
  static const finished = "Finished";
  static const cancel = "canceled order";

  static const String kCachedCategories = 'cached_categories';
  static const String kCachedFoods = 'cached_foods';
  static const String kCachedPopularFoods = 'cached_popular_foods';

  // pin code
  static const pinCode = 'PIN_CODE';
  static const setPinCode = 'SET_PIN_CODE';
  static const biometricEnabled = 'BIOMETRIC_ENABLED';

  // first launch
  static const firstLaunch = 'FIRST_LAUNCH';

  // saved delivery address
  static const savedAddress = 'SAVED_ADDRESS';
  static const savedAddressLat = 'SAVED_ADDRESS_LAT';
  static const savedAddressLon = 'SAVED_ADDRESS_LON';
  static const addressConfirmDate = 'ADDRESS_CONFIRM_DATE';
  static const addressSelected = 'ADDRESS_SELECTED';

  // yandex map key
  static const yandexMapKey = '1d3a039d-6ce6-44a2-9ad1-209ee24e3eb1';

  //
 static  const  biometricPrefKey = 'biometric_enabled';
}

String generateOtpCode() {
  final now = DateTime.now();
  final timestamp = now.millisecondsSinceEpoch;
  return timestamp.toString().substring(timestamp.toString().length - 6);
}
