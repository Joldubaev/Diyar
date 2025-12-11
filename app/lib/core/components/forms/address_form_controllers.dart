import 'package:flutter/material.dart';

/// Класс-хелпер для группировки контроллеров адреса
class AddressFormControllers {
  final TextEditingController address;
  final TextEditingController house;
  final TextEditingController entrance;
  final TextEditingController floor;
  final TextEditingController intercom;
  final TextEditingController kvOffice;
  final TextEditingController comment;

  AddressFormControllers({
    TextEditingController? address,
    TextEditingController? house,
    TextEditingController? entrance,
    TextEditingController? floor,
    TextEditingController? intercom,
    TextEditingController? kvOffice,
    TextEditingController? comment,
  })  : address = address ?? TextEditingController(),
        house = house ?? TextEditingController(),
        entrance = entrance ?? TextEditingController(),
        floor = floor ?? TextEditingController(),
        intercom = intercom ?? TextEditingController(),
        kvOffice = kvOffice ?? TextEditingController(),
        comment = comment ?? TextEditingController();

  void dispose() {
    address.dispose();
    house.dispose();
    entrance.dispose();
    floor.dispose();
    intercom.dispose();
    kvOffice.dispose();
    comment.dispose();
  }
}
