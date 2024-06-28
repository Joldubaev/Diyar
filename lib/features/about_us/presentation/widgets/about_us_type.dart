import 'package:flutter/cupertino.dart';

enum AboutUsType {
  hall,
  vip,
  restoran,
  cafe;

  String getUIName(BuildContext context) {
    return switch (this) {
      hall => 'Зал',
      vip => 'VIP',
      restoran => 'Ресторан',
      cafe => 'Кафе',
    };
  }

  String getTitle(BuildContext context) {
    return switch (this) {
      hall => 'Изящное переплетение востока и запада',
      vip => 'Мы проводим торжества, той,',
      restoran => 'Европейский стиль зала создаст для вас незабываемый отдых',
      cafe => 'Кафе',
    };
  }

  String get getAsset {
    return switch (this) {
      hall => 'assets/images/rest_hall.png',
      vip => 'assets/images/vip_hall.png',
      restoran => 'assets/images/rest_hall.png',
      cafe => 'assets/images/coffee_hall.png',
    };
  }

  String get getApi {
    return switch (this) {
      hall => 'hall',
      vip => 'VIP',
      restoran => 'restoran',
      cafe => 'cafe',
    };
  }
}
