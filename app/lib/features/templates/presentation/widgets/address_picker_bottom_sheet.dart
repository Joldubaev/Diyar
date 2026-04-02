import 'package:auto_route/auto_route.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/core/di/injectable_config.dart';
import 'package:diyar/core/utils/storage/address_storage_service.dart';
import 'package:diyar/features/cart/cart.dart';
import 'package:diyar/features/features.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'address_option_tile.dart';

sealed class _Option {}

class _SavedOption extends _Option {
  final String address;
  final double deliveryPrice;
  _SavedOption({required this.address, required this.deliveryPrice});
}

class _TemplateOption extends _Option {
  final TemplateEntity template;
  _TemplateOption(this.template);
}

class AddressPickerBottomSheet extends StatefulWidget {
  final List<CartItemEntity> cartItems;
  final int totalPrice;
  final int dishCount;

  const AddressPickerBottomSheet({
    super.key,
    required this.cartItems,
    required this.totalPrice,
    required this.dishCount,
  });

  static Future<void> show(
    BuildContext context, {
    required List<CartItemEntity> cartItems,
    required int totalPrice,
    required int dishCount,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AddressPickerBottomSheet(
        cartItems: cartItems,
        totalPrice: totalPrice,
        dishCount: dishCount,
      ),
    );
  }

  @override
  State<AddressPickerBottomSheet> createState() => _AddressPickerBottomSheetState();
}

class _AddressPickerBottomSheetState extends State<AddressPickerBottomSheet> {
  List<TemplateEntity> _templates = [];
  bool _loading = true;
  _Option? _selected;
  _SavedOption? _savedOption;

  @override
  void initState() {
    super.initState();
    final storage = sl<AddressStorageService>();
    final address = storage.getAddress();
    final deliveryPrice = storage.getDeliveryPrice();
    if (storage.isAddressSelected() && address != null) {
      _savedOption = _SavedOption(
        address: address,
        deliveryPrice: deliveryPrice ?? 0.0,
      );
      _selected = _savedOption;
    }
    _loadTemplates();
  }

  Future<void> _loadTemplates() async {
    final result = await sl<TemplateRepository>().getAllTemplates();
    if (!mounted) return;
    setState(() {
      _loading = false;
      result.fold(
        (_) => _templates = [],
        (list) {
          _templates = list;
          if (_selected == null && list.isNotEmpty) {
            _selected = _TemplateOption(list.first);
          }
        },
      );
    });
  }

  void _onContinue() {
    final selected = _selected;
    if (selected == null) return;

    final router = context.router;
    final user = context.read<ProfileCubit>().user;
    router.maybePop();

    if (selected is _SavedOption) {
      router.push(DeliveryFormRoute(
        cart: widget.cartItems,
        totalPrice: widget.totalPrice,
        dishCount: widget.dishCount,
        address: selected.address,
        deliveryPrice: selected.deliveryPrice,
        initialUserName: user?.userName,
        initialUserPhone: user?.phone,
      ));
    } else if (selected is _TemplateOption) {
      final t = selected.template;
      final address = t.addressData.houseNumber.isNotEmpty
          ? '${t.addressData.address}, д. ${t.addressData.houseNumber}'
          : t.addressData.address;
      router.push(DeliveryFormRoute(
        cart: widget.cartItems,
        totalPrice: widget.totalPrice,
        dishCount: widget.dishCount,
        address: address,
        deliveryPrice: t.price?.toDouble() ?? 0.0,
        initialUserName: t.contactInfo.userName,
        initialUserPhone: t.contactInfo.userPhone,
        initialEntrance: t.addressData.entrance,
        initialFloor: t.addressData.floor,
        initialApartment: t.addressData.kvOffice,
        initialIntercom: t.addressData.intercom,
        initialComment: t.addressData.comment,
      ));
    }
  }

  Future<void> _onSelectMap() async {
    await context.router.push(const AddressSelectionRoute());
    if (!mounted) return;
    // Перечитываем адрес из хранилища после возврата с карты
    final storage = sl<AddressStorageService>();
    final address = storage.getAddress();
    final deliveryPrice = storage.getDeliveryPrice();
    if (storage.isAddressSelected() && address != null) {
      setState(() {
        _savedOption = _SavedOption(
          address: address,
          deliveryPrice: deliveryPrice ?? 0.0,
        );
        _selected = _savedOption;
      });
    }
  }

  String _buildSubtitle(TemplateEntity t) {
    return t.addressData.houseNumber.isNotEmpty
        ? '${t.addressData.address}, д. ${t.addressData.houseNumber}'
        : t.addressData.address;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: colors.onSurface.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Выберите адрес доставки',
            style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          if (_loading)
            const Center(
                child: Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: CircularProgressIndicator(),
            ))
          else
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.4,
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    if (_savedOption != null) ...[
                      AddressOptionTile(
                        icon: Icons.location_on_outlined,
                        title: 'Сохранённый адрес',
                        subtitle: _savedOption!.address,
                        isSelected: _selected is _SavedOption,
                        onTap: () => setState(() => _selected = _savedOption),
                      ),
                      if (_templates.isNotEmpty) const SizedBox(height: 8),
                    ],
                    ..._templates.map((t) {
                      final isSelected =
                          _selected is _TemplateOption && (_selected as _TemplateOption).template.id == t.id;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: AddressOptionTile(
                          icon: Icons.bookmark_outline,
                          title: t.templateName,
                          subtitle: _buildSubtitle(t),
                          isSelected: isSelected,
                          onTap: () => setState(() => _selected = _TemplateOption(t)),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 12),
          InkWell(
            onTap: _onSelectMap,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                border: Border.all(color: colors.primary.withValues(alpha: 0.4)),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.add_location_alt_outlined, color: colors.primary),
                  const SizedBox(width: 12),
                  Text(
                    'Выбрать новый адрес на карте',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colors.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _selected != null ? _onContinue : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.primary,
                foregroundColor: colors.onPrimary,
                disabledBackgroundColor: colors.onSurface.withValues(alpha: 0.12),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: Text(
                'Продолжить',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: colors.onPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
