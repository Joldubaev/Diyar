import 'package:diyar/core/core.dart';
import 'package:flutter/material.dart';

/// Поля адреса формы доставки
class DeliveryFormAddressFields extends StatelessWidget {
  final ThemeData theme;
  final TextEditingController addressController;
  final TextEditingController houseController;
  final TextEditingController entranceController;
  final TextEditingController floorController;
  final TextEditingController apartmentController;
  final TextEditingController intercomController;

  const DeliveryFormAddressFields({
    super.key,
    required this.theme,
    required this.addressController,
    required this.houseController,
    required this.entranceController,
    required this.floorController,
    required this.apartmentController,
    required this.intercomController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomInputWidget(
          titleColor: theme.colorScheme.onSurface,
          filledColor: theme.colorScheme.surface,
          inputType: TextInputType.text,
          hintText: context.l10n.adress,
          controller: addressController,
          isReadOnly: true,
          validator: (value) {
            if (value!.isEmpty) {
              return context.l10n.pleaseEnterAddress;
            } else if (value.length < 3) {
              return context.l10n.pleaseEnterCorrectAddress;
            }
            return null;
          },
        ),
        const SizedBox(height: 10),
        CustomInputWidget(
          titleColor: theme.colorScheme.onSurface,
          filledColor: theme.colorScheme.surface,
          inputType: TextInputType.text,
          controller: houseController,
          hintText: context.l10n.houseNumber,
          validator: (value) {
            if (value!.isEmpty) {
              return context.l10n.pleaseEnterHouseNumber;
            }
            return null;
          },
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: CustomInputWidget(
                titleColor: theme.colorScheme.onSurface,
                filledColor: theme.colorScheme.surface,
                inputType: TextInputType.text,
                controller: entranceController,
                hintText: 'Подъезд',
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: CustomInputWidget(
                titleColor: theme.colorScheme.onSurface,
                filledColor: theme.colorScheme.surface,
                inputType: TextInputType.text,
                controller: floorController,
                hintText: context.l10n.floor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: CustomInputWidget(
                titleColor: theme.colorScheme.onSurface,
                filledColor: theme.colorScheme.surface,
                inputType: TextInputType.text,
                controller: apartmentController,
                hintText: context.l10n.ofice,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: CustomInputWidget(
                titleColor: theme.colorScheme.onSurface,
                filledColor: theme.colorScheme.surface,
                inputType: TextInputType.text,
                controller: intercomController,
                hintText: context.l10n.codeIntercom,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}

