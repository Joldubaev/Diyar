import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:diyar/core/router/routes.gr.dart';
import 'package:diyar/features/cart/cart.dart';
import 'package:diyar/shared/components/input/custom_input_widget.dart';
import 'package:diyar/shared/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:diyar/features/order/order.dart';
import 'package:diyar/features/order/data/models/distric_model.dart';

@RoutePage()
class SecondOrderPage extends StatefulWidget {
  final List<CartItemModel> cart;
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
  DistricModel? selectedDistrict;
  final TextEditingController addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<OrderCubit>().getDistricts();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.black,
        title: Text('Доставка',
            style:
                theme.textTheme.titleLarge?.copyWith(color: AppColors.black)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          child: BlocBuilder<OrderCubit, OrderState>(
            builder: (context, state) {
              if (state is DistricLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is DistricError) {
                log(state.message);
                return Center(child: Text(state.message));
              } else if (state is DistricLoaded) {
                final List<DistricModel> districts = state.districts;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Пожалуйста, выберите район и напишите адрес',
                      style: theme.textTheme.titleLarge,
                    ),
                    const SizedBox(height: 24),
                    Text('Район', style: theme.textTheme.bodyLarge?.copyWith()),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8)),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<DistricModel>(
                          isExpanded: true,
                          value: selectedDistrict,
                          hint: const Text('Выберите район'),
                          items: districts
                              .map(
                                (district) => DropdownMenuItem<DistricModel>(
                                  value: district,
                                  child: Text(
                                      '${district.name} (${district.price} сом)',
                                      style:
                                          theme.textTheme.bodyLarge!.copyWith(
                                        fontWeight: FontWeight.w600,
                                      )),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedDistrict = value;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Адрес',
                      style: theme.textTheme.bodyLarge?.copyWith(),
                    ),
                    const SizedBox(height: 8),
                    CustomInputWidget(
                      controller: addressController,
                      hintText: 'Введите адрес доставки',
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Пожалуйста, введите адрес доставки';
                        }
                        return null;
                      },
                    ),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: () {
                        if (selectedDistrict == null ||
                            addressController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Заполните все поля')),
                          );
                        } else {
                          context.router.push(DeliveryFormRoute(
                            cart: widget.cart,
                            dishCount: widget.dishCount,
                            totalPrice: widget.totalPrice,
                            distric: selectedDistrict!,
                            address: addressController.text,
                          ));
                          log('Selected District: ${selectedDistrict!.name}');
                          log('Delivery Price: ${selectedDistrict!.price}');
                          log('Address: ${addressController.text}');
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
                      child: Text('Сохранить',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: AppColors.white,
                            fontWeight: FontWeight.w600,
                          )),
                    ),
                  ],
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}
