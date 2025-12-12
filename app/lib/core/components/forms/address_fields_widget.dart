import 'package:diyar/core/components/forms/address_form_controllers.dart';
import 'package:diyar/core/core.dart';
import 'package:flutter/material.dart';

/// Переиспользуемый виджет для полей адреса
class AddressFieldsWidget extends StatelessWidget {
  const AddressFieldsWidget({
    super.key,
    required this.theme,
    required this.controllers,
    this.isAddressReadOnly = false,
    this.showComment = true,
  });

  final ThemeData theme;
  final AddressFormControllers controllers;
  final bool isAddressReadOnly;
  final bool showComment;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomInputWidget(
          titleColor: theme.colorScheme.onSurface,
          filledColor: theme.colorScheme.surface,
          inputType: TextInputType.text,
          hintText: context.l10n.adress,
          controller: controllers.address,
          isReadOnly: isAddressReadOnly,
          validator: (value) {
            if (value == null || value.isEmpty) {
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
          controller: controllers.house,
          hintText: context.l10n.houseNumber,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return context.l10n.pleaseEnterHouseNumber;
            }
            return null;
          },
        ),
        const SizedBox(height: 10),
        // Ряд: Подъезд и Этаж
        Row(
          children: [
            Expanded(
              child: CustomInputWidget(
                titleColor: theme.colorScheme.onSurface,
                filledColor: theme.colorScheme.surface,
                inputType: TextInputType.text,
                controller: controllers.entrance,
                hintText: 'Подъезд',
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: CustomInputWidget(
                titleColor: theme.colorScheme.onSurface,
                filledColor: theme.colorScheme.surface,
                inputType: TextInputType.text,
                controller: controllers.floor,
                hintText: context.l10n.floor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        // Ряд: Квартира/Офис и Домофон
        Row(
          children: [
            Expanded(
              child: CustomInputWidget(
                titleColor: theme.colorScheme.onSurface,
                filledColor: theme.colorScheme.surface,
                inputType: TextInputType.text,
                controller: controllers.kvOffice,
                hintText: context.l10n.ofice,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: CustomInputWidget(
                titleColor: theme.colorScheme.onSurface,
                filledColor: theme.colorScheme.surface,
                inputType: TextInputType.text,
                controller: controllers.intercom,
                hintText: context.l10n.codeIntercom,
              ),
            ),
          ],
        ),
        if (showComment) ...[
          const SizedBox(height: 10),
          CustomInputWidget(
            titleColor: theme.colorScheme.onSurface,
            filledColor: theme.colorScheme.surface,
            controller: controllers.comment,
            hintText: context.l10n.comment,
            maxLines: 3,
          ),
        ],
      ],
    );
  }
}
