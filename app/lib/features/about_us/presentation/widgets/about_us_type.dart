import 'package:flutter/cupertino.dart';

enum AboutUsType {
  hall,
  vip,
  restoran,
  cafe,
  terasa;

  String get apiType {
    return switch (this) {
      hall => 'БАНКЕТ ХОЛЛ',
      vip => 'VIP ЗАЛЫ',
      restoran => 'РЕСТОРАН',
      cafe => 'ЭКСПРЕСС КАФЕ',
      terasa => 'ТЕРАССА',
    };
  }

  String getUIName(BuildContext context) {
    return switch (this) {
      hall => 'Banquet Hall',
      vip => 'VIP',
      restoran => 'Ресторан общий зал',
      cafe => 'Кафе',
      terasa => 'Терраса',
    };
  }

  String getTitle(BuildContext context) {
    return switch (this) {
      hall => '8 закрытых залов с живой музыкой',
      vip => 'Мы проводим торжества, той',
      restoran => 'Европейский стиль зала создаст для вас незабываемый отдых',
      cafe => 'Изящное переплетение востока и запада',
      terasa =>
        'Идеальная терасса для пасмурной погоды. Вне зависимости от времени года, у нас много зелени, всегда тепло и светло.',
    };
  }

  String get getAsset {
    return switch (this) {
      hall => 'assets/images/rest_hall.jpeg',
      vip => 'assets/images/vip_hall.jpeg',
      restoran => 'assets/images/coffee_hall.png',
      cafe => 'assets/images/rest_hall.png',
      terasa => 'assets/images/terrace_hall.jpg',
    };
  }

  /// Phone number for booking this hall/zone
  String get bookingPhone {
    return switch (this) {
      hall => '0555511115',
      vip => '0555511115',
      restoran => '0550555999',
      cafe => '0550555999',
      terasa => '0550555999',
    };
  }

  /// Capacity range, null if unknown
  String? get capacity {
    return switch (this) {
      hall => '70 – 180 гостей',
      vip => '10 – 55 гостей',
      restoran => null,
      cafe => null,
      terasa => null,
    };
  }

  /// Working hours, null if unknown
  String? get workingHours {
    return switch (this) {
      hall => '12:00 – 00:00',
      vip => '12:00 – 02:00',
      restoran => '10:00 – 00:00',
      cafe => '08:00 – 22:00',
      terasa => '10:00 – 23:00',
    };
  }
}
