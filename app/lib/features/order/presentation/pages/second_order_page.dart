import 'package:auto_route/auto_route.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/cart/domain/entities/cart_item_entity.dart';
import 'package:diyar/features/order/domain/entities/entities.dart';
import 'package:diyar/features/order/data/models/model.dart';
import 'package:diyar/features/order/presentation/cubit/order_cubit.dart';
import 'package:diyar/features/order/presentation/widgets/search_bottom_widget.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class SecondOrderPage extends StatefulWidget {
  final List<CartItemEntity> cart;
  final int dishCount;
  final int totalPrice;

  const SecondOrderPage({
    super.key,
    required this.cart,
    required this.dishCount,
    required this.totalPrice,
  });

  @override
  State<SecondOrderPage> createState() => _SecondOrderPageState();
}

class _SecondOrderPageState extends State<SecondOrderPage> {
  DistrictDataModel? selectedDistrict;
  final TextEditingController addressController = TextEditingController();
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.black,
        title: const Text('Доставка'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Выберите район и напишите адрес, чтобы мы знали, куда доставить ваш заказ.',
                style: theme.textTheme.bodyLarge,
              ),
              const SizedBox(height: 24),
              TextField(
                controller: searchController,
                decoration: const InputDecoration(
                  hintText: 'Введите район для поиска',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: Icon(Icons.search),
                  fillColor: AppColors.grey1,
                  filled: true,
                  contentPadding: EdgeInsets.symmetric(horizontal: 12),
                  constraints: BoxConstraints(maxHeight: 40),
                ),
                onTap: _openDistrictSearch,
              ),
              const SizedBox(height: 24),
              if (selectedDistrict != null)
                Text(
                  'Выбранный район: ${selectedDistrict!.name} (${selectedDistrict!.price} сом)',
                  style: theme.textTheme.bodyLarge,
                ),
              const SizedBox(height: 10),
              Text('Адрес', style: theme.textTheme.bodyLarge),
              const SizedBox(height: 8),
              CustomInputWidget(
                controller: addressController,
                hintText: 'Введите адрес доставки',
                titleColor: theme.colorScheme.onSurface,
                filledColor: theme.colorScheme.surface,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Пожалуйста, введите адрес доставки';
                  }
                  return null;
                },
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  if (selectedDistrict == null || addressController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Заполните все поля')),
                    );
                  } else {
                    final DistrictEntity? districtEntity = selectedDistrict?.toEntity();
                    context.router.push(DeliveryFormRoute(
                      cart: widget.cart,
                      dishCount: widget.dishCount,
                      totalPrice: widget.totalPrice,
                      distric: districtEntity,
                      address: addressController.text,
                    ));
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  minimumSize: const Size.fromHeight(50),
                ),
                child: Text(
                  'Сохранить',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openDistrictSearch() {
    showDistrictSearchBottom(
      context,
      onSearch: (query) async {
        context.read<OrderCubit>().getDistricts(search: query);
        return <DistrictDataModel>[];
      },
      onDistrictSelected: (DistrictDataModel district) {
        setState(() {
          selectedDistrict = district;
        });
      },
    );
  }
}
