import 'package:auto_route/auto_route.dart';
import 'package:diyar/core/components/input/phone_number.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/cart/cart.dart';
import 'package:diyar/features/order/presentation/widgets/info_dialog_widget.dart';
import 'package:diyar/features/pick_up/pick_up.dart';
import 'package:diyar/l10n/l10n.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

@RoutePage()
class PickupFormPage extends StatefulWidget {
  final List<CartItemEntity> cart;
  final int totalPrice;
  const PickupFormPage({
    super.key,
    required this.cart,
    required this.totalPrice,
  });

  @override
  State<PickupFormPage> createState() => _PickupFormPageState();
}

class _PickupFormPageState extends State<PickupFormPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  late PickUpCubit _pickUpCubit;

  @override
  void initState() {
    super.initState();
    _pickUpCubit = context.read<PickUpCubit>();
    final initialFormState = _pickUpCubit.state;
    if (initialFormState is PickUpFormState) {
      _phoneController.text = initialFormState.phone.isNotEmpty ? initialFormState.phone : '+996';
      _userNameController.text = initialFormState.userName;
      _timeController.text = initialFormState.time;
      _commentController.text = initialFormState.comment;
    } else {
      _phoneController.text = '+996';
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _userNameController.dispose();
    _commentController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  void _selectTime(BuildContext context) async {
    final pickUpCubit = context.read<PickUpCubit>();
    DateTime now = DateTime.now();
    DateTime pickerInitialTime = now.add(const Duration(minutes: 15));

    final currentTimeFromState = _timeController.text;
    if (currentTimeFromState.isNotEmpty) {
      final parts = currentTimeFromState.split(':');
      if (parts.length == 2) {
        final hour = int.tryParse(parts[0]);
        final minute = int.tryParse(parts[1]);
        if (hour != null && minute != null) {
          final todaySelection = DateTime(now.year, now.month, now.day, hour, minute);
          if (todaySelection.isAfter(pickerInitialTime)) {
            pickerInitialTime = todaySelection;
          }
        }
      }
    }
    DateTime selectedTime = pickerInitialTime;

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(
            'Внимание! Время подготовки заказа займет не менее 15 минут',
            style: Theme.of(dialogContext)
                .textTheme
                .bodyMedium!
                .copyWith(fontSize: 16, color: Theme.of(dialogContext).colorScheme.error),
            textAlign: TextAlign.center,
          ),
          content: SizedBox(
              height: 240,
              child: Column(children: [
                SizedBox(
                    height: 160,
                    child: CupertinoDatePicker(
                      mode: CupertinoDatePickerMode.time,
                      initialDateTime: pickerInitialTime,
                      minuteInterval: 1,
                      use24hFormat: true,
                      onDateTimeChanged: (DateTime newTime) {
                        selectedTime = newTime;
                      },
                    )),
                Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  TextButton(
                    onPressed: () => Navigator.of(dialogContext).pop(),
                    child: Text(
                      'Отмена',
                      style: Theme.of(dialogContext).textTheme.bodyMedium!.copyWith(
                            fontSize: 16,
                            color: Theme.of(dialogContext).colorScheme.primary,
                          ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      final minSelectableTime = now.add(
                        const Duration(minutes: 15),
                      );
                      String timeToSet;
                      if (selectedTime.isAfter(minSelectableTime) || selectedTime.isAtSameMomentAs(minSelectableTime)) {
                        timeToSet =
                            '${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}';
                      } else {
                        timeToSet =
                            '${minSelectableTime.hour.toString().padLeft(2, '0')}:${minSelectableTime.minute.toString().padLeft(2, '0')}';
                      }
                      _timeController.text = timeToSet;
                      pickUpCubit.timeChanged(timeToSet);
                      Navigator.of(dialogContext).pop();
                    },
                    child: Text(
                      'Подтвердить',
                      style: Theme.of(dialogContext).textTheme.bodyMedium!.copyWith(
                            fontSize: 16,
                            color: Theme.of(dialogContext).colorScheme.primary,
                          ),
                    ),
                  ),
                ])
              ])),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return BlocConsumer<PickUpCubit, PickUpState>(
      listener: (context, state) {
        if (state is PickUpFormState) {
          if (_userNameController.text != state.userName && state.isProfileDataLoaded) {
            _userNameController.text = state.userName;
          }
          if (_phoneController.text != state.phone && state.isProfileDataLoaded) {
            if (state.phone.isNotEmpty &&
                (state.phone != '+996' || _phoneController.text == '+996' || _phoneController.text.isEmpty)) {
              _phoneController.text = state.phone;
            }
          }
          if (_timeController.text != state.time) {
            _timeController.text = state.time;
          }
          if (_commentController.text != state.comment) {
            _commentController.text = state.comment;
          }
        }
        if (state is CreatePickUpOrderLoaded) {
          context.read<CartBloc>().add(ClearCart());
          final currentRoute = ModalRoute.of(context);
          if (currentRoute is ModalBottomSheetRoute) {
            if (Navigator.canPop(context)) Navigator.of(context).pop();
          }
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (dialogContext) {
              return PopScope(
                canPop: false,
                child: AlertDialog(
                    title: Text(l10n.yourOrdersConfirm, style: theme.textTheme.bodyLarge!.copyWith(fontSize: 16)),
                    content:
                        Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(l10n.operatorContact,
                          style: theme.textTheme.bodyMedium!.copyWith(color: theme.colorScheme.onSurface)),
                      const SizedBox(height: 10),
                      SubmitButtonWidget(
                          textStyle: theme.textTheme.bodyMedium!.copyWith(color: theme.colorScheme.surface),
                          title: l10n.ok,
                          bgColor: AppColors.green,
                          onTap: () {
                            Navigator.of(dialogContext).pop();
                            context.router.pushAndPopUntil(const MainRoute(), predicate: (_) => false);
                          })
                    ])),
              );
            },
          );
        } else if (state is CreatePickUpOrderError) {
          final currentRoute = ModalRoute.of(context);
          if (currentRoute is ModalBottomSheetRoute) {
            if (Navigator.canPop(context)) Navigator.of(context).pop();
          }
          final errorMessage = state.message.isNotEmpty ? state.message : l10n.someThingIsWrong;
          showToast(errorMessage, isError: true);
        }
      },
      builder: (context, state) {
        PickUpFormState formState;
        if (state is PickUpFormState) {
          formState = state;
        } else if (state is CreatePickUpOrderLoading ||
            state is CreatePickUpOrderLoaded ||
            state is CreatePickUpOrderError) {
          if (_pickUpCubit.state is PickUpFormState) {
            formState = _pickUpCubit.state as PickUpFormState;
          } else {
            formState = PickUpFormState();
          }
        } else {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        return Scaffold(
          appBar: AppBar(
              backgroundColor: theme.colorScheme.primary,
              title: Text(l10n.pickup,
                  style: theme.textTheme.titleSmall!.copyWith(color: theme.colorScheme.onTertiaryFixed)),
              leading: IconButton(
                  icon: Icon(Icons.arrow_back_ios_sharp, color: theme.colorScheme.onTertiaryFixed),
                  onPressed: () => context.router.maybePop())),
          body: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                CustomInputWidget(
                  titleColor: theme.colorScheme.onSurface,
                  filledColor: theme.colorScheme.surface,
                  controller: _userNameController,
                  hintText: l10n.yourName,
                  onChanged: (value) => _pickUpCubit.userNameChanged(value),
                  validator: (_) => formState.validationErrors[PickUpFormField.userName],
                ),
                const SizedBox(height: 10),
                PhoneNumberMask(
                  hintText: '+996 (___) __-__-__',
                  textController: _phoneController,
                  hint: l10n.phone,
                  formatter: MaskTextInputFormatter(mask: "+996 (###) ##-##-##"),
                  textInputType: TextInputType.phone,
                  validator: (_) => formState.validationErrors[PickUpFormField.phone],
                ),
                const SizedBox(height: 10),
                CustomInputWidget(
                  titleColor: theme.colorScheme.onSurface,
                  filledColor: theme.colorScheme.surface,
                  controller: _commentController,
                  onChanged: (value) => _pickUpCubit.commentChanged(value),
                  hintText: l10n.comment,
                ),
                const SizedBox(height: 10),
                CustomInputWidget(
                  filledColor: theme.colorScheme.surface,
                  controller: _timeController,
                  isReadOnly: true,
                  onTap: () => _selectTime(context),
                  hintText: l10n.chooseTime,
                  validator: (_) => formState.validationErrors[PickUpFormField.time],
                ),
                const SizedBox(height: 10),
                Text(l10n.orderPickupAd, style: theme.textTheme.bodyMedium!.copyWith(fontSize: 16)),
                Text(l10n.address, style: theme.textTheme.bodyMedium!.copyWith(fontSize: 16)),
                const SizedBox(height: 10),
                SubmitButtonWidget(
                  title: l10n.confirmOrder,
                  bgColor: Theme.of(context).colorScheme.primary,
                  textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(color: theme.colorScheme.surface),
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      _pickUpCubit.userNameChanged(_userNameController.text);
                      _pickUpCubit.phoneChanged(_phoneController.text);
                      _pickUpCubit.timeChanged(_timeController.text);
                      _pickUpCubit.commentChanged(_commentController.text);

                      _showCustomBottomDialog(theme, context, widget.totalPrice, _pickUpCubit);
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<dynamic> _showCustomBottomDialog(ThemeData theme, BuildContext context, int totalPrice, PickUpCubit cubit) {
    final l10n = context.l10n;
    return showModalBottomSheet(
      backgroundColor: theme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (bottomSheetContext) {
        return DraggableScrollableSheet(
          initialChildSize: 0.3,
          minChildSize: 0.3,
          expand: false,
          maxChildSize: 0.3,
          builder: (__, scrollController) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  SizedBox(
                    height: 60,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                            child: Text('${l10n.orderPickupAd} ${l10n.address}',
                                style: theme.textTheme.bodyLarge!.copyWith(fontSize: 16))),
                        IconButton(
                            onPressed: () => Navigator.of(bottomSheetContext).pop(), icon: const Icon(Icons.close)),
                      ],
                    ),
                  ),
                  const Divider(),
                  const SizedBox(height: 10),
                  InfoDialogWidget(title: l10n.orderAmount, description: '$totalPrice сом'),
                  const SizedBox(height: 10),
                  BlocBuilder<PickUpCubit, PickUpState>(
                    buildWhen: (prev, curr) =>
                        curr is CreatePickUpOrderLoading ||
                        curr is PickUpFormState ||
                        curr is CreatePickUpOrderError ||
                        curr is CreatePickUpOrderLoaded,
                    builder: (context, state) {
                      bool isLoading = state is CreatePickUpOrderLoading;
                      return SubmitButtonWidget(
                          isLoading: isLoading,
                          textStyle: theme.textTheme.bodyMedium!.copyWith(color: theme.colorScheme.surface),
                          title: l10n.confirm,
                          bgColor: AppColors.green,
                          onTap: isLoading
                              ? null
                              : () {
                                  final int dishesCount =
                                      widget.cart.fold(0, (sum, item) => sum + (item.quantity ?? 1));
                                  cubit.submitPickupOrder(
                                      cart: widget.cart, totalPriceFromWidget: totalPrice, dishesCount: dishesCount);
                                });
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
