import 'package:diyar/core/components/input/phone_number.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/core/theme/theme_extenstion.dart';
import 'package:diyar/features/order/order.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class AddressSection extends StatelessWidget {
  final DeliveryFormControllers controllers;
  final GlobalKey<FormState> formKey;

  const AddressSection({
    super.key,
    required this.controllers,
    required this.formKey,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomInputWidget(
            titleColor: context.theme.colorScheme.onSurface,
            filledColor: context.theme.colorScheme.surface,
            controller: controllers.userName,
            hintText: context.l10n.yourName,
            onChanged: (value) {
              context.read<DeliveryFormCubit>().updateField(userName: value);
            },
            validator: (value) {
              if (value!.isEmpty) {
                return context.l10n.pleaseEnterName;
              } else if (value.length < 3) {
                return context.l10n.pleaseEnterCorrectName;
              }
              return null;
            },
          ),
          const SizedBox(height: 10),
          PhoneNumberMask(
            hintText: '+996 (___) __-__-__',
            textController: controllers.phoneController,
            hint: context.l10n.phone,
            formatter: MaskTextInputFormatter(mask: "+996 (###) ##-##-##"),
            textInputType: TextInputType.phone,
            onChanged: (value) {
              context.read<DeliveryFormCubit>().updateField(userPhone: value);
            },
            validator: (value) {
              if (value!.isEmpty) {
                return context.l10n.pleaseEnterPhone;
              } else if (value.length < 10) {
                return context.l10n.pleaseEnterCorrectPhone;
              }
              return null;
            },
          ),
          const SizedBox(height: 10),
          CustomInputWidget(
            titleColor: context.theme.colorScheme.onSurface,
            filledColor: context.theme.colorScheme.surface,
            inputType: TextInputType.text,
            hintText: context.l10n.adress,
            controller: controllers.addressController,
            isReadOnly: true,
            onChanged: (value) {
              context.read<DeliveryFormCubit>().updateField(address: value);
            },
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
            titleColor: context.theme.colorScheme.onSurface,
            filledColor: context.theme.colorScheme.surface,
            inputType: TextInputType.text,
            controller: controllers.houseController,
            hintText: context.l10n.houseNumber,
            onChanged: (value) {
              context.read<DeliveryFormCubit>().updateField(houseNumber: value);
            },
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
                  titleColor: context.theme.colorScheme.onSurface,
                  filledColor: context.theme.colorScheme.surface,
                  inputType: TextInputType.text,
                  controller: controllers.entranceController,
                  hintText: 'Подъезд',
                  onChanged: (value) {
                    context.read<DeliveryFormCubit>().updateField(entrance: value);
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: CustomInputWidget(
                  titleColor: context.theme.colorScheme.onSurface,
                  filledColor: context.theme.colorScheme.surface,
                  inputType: TextInputType.text,
                  controller: controllers.floorController,
                  hintText: context.l10n.floor,
                  onChanged: (value) {
                    context.read<DeliveryFormCubit>().updateField(floor: value);
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: CustomInputWidget(
                  titleColor: context.theme.colorScheme.onSurface,
                  filledColor: context.theme.colorScheme.surface,
                  inputType: TextInputType.text,
                  controller: controllers.apartmentController,
                  hintText: context.l10n.ofice,
                  onChanged: (value) {
                    context.read<DeliveryFormCubit>().updateField(apartment: value);
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: CustomInputWidget(
                  titleColor: context.theme.colorScheme.onSurface,
                  filledColor: context.theme.colorScheme.surface,
                  inputType: TextInputType.text,
                  controller: controllers.intercomController,
                  hintText: context.l10n.codeIntercom,
                  onChanged: (value) {
                    context.read<DeliveryFormCubit>().updateField(intercom: value);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
