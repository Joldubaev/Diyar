import '../../../auth/presentation/widgets/phone_number.dart';
import '../../../../l10n/l10n.dart';
import '../../../../shared/components/components.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class DeliveryFormWidget extends StatefulWidget {
  const DeliveryFormWidget({
    super.key,
    required this.theme,
    required this.totalOrderCost,
    required this.onConfirm,
    required this.formKey,
    required this.userName,
    required this.phoneController,
    required this.addressController,
    required this.houseController,
    required this.entranceController,
    required this.floorController,
    required this.apartmentController,
    required this.intercomController,
    required this.sdachaController,
    required this.commentController,
  });

  final ThemeData theme;
  final int totalOrderCost;
  final VoidCallback onConfirm;
  final GlobalKey<FormState> formKey;
  final TextEditingController userName;
  final TextEditingController phoneController;
  final TextEditingController addressController;
  final TextEditingController houseController;
  final TextEditingController entranceController;
  final TextEditingController floorController;
  final TextEditingController apartmentController;
  final TextEditingController intercomController;
  final TextEditingController sdachaController;
  final TextEditingController commentController;

  @override
  State<DeliveryFormWidget> createState() => _DeliveryFormWidgetState();
}

class _DeliveryFormWidgetState extends State<DeliveryFormWidget> {
  TextEditingController get _userName => widget.userName;
  TextEditingController get _phoneController => widget.phoneController;
  TextEditingController get _addressController => widget.addressController;
  TextEditingController get _houseController => widget.houseController;
  TextEditingController get _entranceController => widget.entranceController;
  TextEditingController get _floorController => widget.floorController;
  TextEditingController get _apartmentController => widget.apartmentController;
  TextEditingController get _intercomController => widget.intercomController;
  TextEditingController get _sdachaController => widget.sdachaController;
  TextEditingController get _commentController => widget.commentController;
  GlobalKey<FormState> get _formKey => widget.formKey;

  // @override
  // void initState() {
  //   super.initState();
  //   log("address2: ${_addressController.text}");
  // }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          CustomInputWidget(
              titleColor: widget.theme.colorScheme.onSurface,
              filledColor: widget.theme.colorScheme.surface,
              controller: _userName,
              hintText: context.l10n.yourName,
              validator: (value) {
                if (value!.isEmpty) {
                  return context.l10n.pleaseEnterName;
                } else if (value.length < 3) {
                  return context.l10n.pleaseEnterCorrectName;
                }
                return null;
              }),
          const SizedBox(height: 10),
          PhoneNumberMask(
            hintText: '+996 (___) __-__-__',
            textController: _phoneController,
            hint: context.l10n.phone,
            formatter: MaskTextInputFormatter(mask: "+996 (###) ##-##-##"),
            textInputType: TextInputType.phone,
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
            titleColor: widget.theme.colorScheme.onSurface,
            filledColor: widget.theme.colorScheme.surface,
            inputType: TextInputType.text,
            hintText: context.l10n.adress,
            controller: _addressController,
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
              titleColor: widget.theme.colorScheme.onSurface,
              filledColor: widget.theme.colorScheme.surface,
              inputType: TextInputType.text,
              controller: _houseController,
              hintText: context.l10n.houseNumber,
              validator: (value) {
                if (value!.isEmpty) {
                  return context.l10n.pleaseEnterHouseNumber;
                }
                return null;
              }),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: CustomInputWidget(
                  titleColor: widget.theme.colorScheme.onSurface,
                  filledColor: widget.theme.colorScheme.surface,
                  inputType: TextInputType.text,
                  controller: _entranceController,
                  hintText: 'Подъезд',
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: CustomInputWidget(
                  titleColor: widget.theme.colorScheme.onSurface,
                  filledColor: widget.theme.colorScheme.surface,
                  inputType: TextInputType.text,
                  controller: _floorController,
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
                  titleColor: widget.theme.colorScheme.onSurface,
                  filledColor: widget.theme.colorScheme.surface,
                  inputType: TextInputType.text,
                  controller: _apartmentController,
                  hintText: context.l10n.ofice,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: CustomInputWidget(
                  titleColor: widget.theme.colorScheme.onSurface,
                  filledColor: widget.theme.colorScheme.surface,
                  inputType: TextInputType.text,
                  controller: _intercomController,
                  hintText: context.l10n.codeIntercom,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          CustomInputWidget(
            titleColor: widget.theme.colorScheme.onSurface,
            filledColor: widget.theme.colorScheme.surface,
            inputType: TextInputType.number,
            controller: _sdachaController,
            hintText: context.l10n.change,
            validator: (value) {
              if (value!.isEmpty) {
                return context.l10n.confirmOrder;
              } else if (value.length < 2) {
                return context.l10n.confirmOrder;
              }
              return null;
            },
          ),
          const SizedBox(height: 10),
          CustomInputWidget(
              titleColor: widget.theme.colorScheme.onSurface,
              filledColor: widget.theme.colorScheme.surface,
              controller: _commentController,
              hintText: context.l10n.comment,
              validator: (val) => null,
              maxLines: 3),
          const SizedBox(height: 20),
          Card(
            color: widget.theme.colorScheme.primary,
            child: ListTile(
              title: Text('Сумма заказа ${widget.totalOrderCost} сом',
                  style: widget.theme.textTheme.bodyMedium?.copyWith(
                      color: widget.theme.colorScheme.onTertiaryFixed,
                      fontWeight: FontWeight.w500)),
              trailing: Icon(Icons.arrow_forward_ios,
                  color: widget.theme.colorScheme.onTertiaryFixed),
              onTap: widget.onConfirm,
            ),
          ),
        ],
      ),
    );
  }
}
