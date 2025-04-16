import 'package:flutter/cupertino.dart';

enum AboutUsType {
  hall,
  vip,
  restoran,
  cafe,
  terasa;

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
      vip => 'Мы проводим торжества,той',
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

  String get getApi {
    return switch (this) {
      hall => 'hall',
      vip => 'VIP',
      restoran => 'restoran',
      cafe => 'cafe',
      terasa => 'terrace',
    };
  }
}
