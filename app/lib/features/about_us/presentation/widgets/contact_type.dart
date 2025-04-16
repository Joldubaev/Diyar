import '../../../../l10n/l10n.dart';
import 'package:flutter/material.dart';

enum ContactType {
  delivery,
  diyarExpress,
  diyarRestaurant,
  diyarBanketHall,
  versal;

  String getTitle(BuildContext context) {
    return switch (this) {
      delivery => context.l10n.deliveryService,
      diyarExpress => context.l10n.deliveryServiceD,
      diyarRestaurant => context.l10n.diyarRestoran,
      diyarBanketHall => context.l10n.diyarRestoranHall,
      versal => context.l10n.versal,
    };
  }

  String getNumber() {
    return switch (this) {
      delivery => '0559 69-47-77',
      diyarExpress => '0509 69-47-77',
      diyarRestaurant => '0550 55-59-99',
      diyarBanketHall => '0555 51-11-15',
      versal => '0555 55-55-08',
    };
  }

  String get getAsset {
    return switch (this) {
      delivery => 'assets/icons/delivery.svg',
      diyarExpress => 'assets/icons/clock.svg',
      diyarRestaurant => 'assets/icons/man_table.svg',
      diyarBanketHall => 'assets/icons/booking.svg',
      versal => 'assets/icons/hotel.svg',
    };
  }
}
