import 'package:auto_route/auto_route.dart';
import 'package:diyar/features/home_features/presentation/pages/widgets/custom_widget.dart';
import 'package:diyar/l10n/l10n.dart';
import 'package:diyar/shared/theme/theme.dart';
import 'package:diyar/shared/utils/snackbar/snackbar_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import '../../cubit/home_features_cubit.dart';

@RoutePage()
class SalePage extends StatefulWidget {
  const SalePage({super.key});

  @override
  State<SalePage> createState() => _SalePageState();
}

class _SalePageState extends State<SalePage> {
  @override
  void initState() {
    context.read<HomeFeaturesCubit>().getSales();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.white),
          onPressed: () {
            context.router.maybePop();
          },
        ),
        title: Text(
          context.l10n.sales,
          style: theme.textTheme.titleSmall?.copyWith(
            color: AppColors.white,
          ),
        ),
      ),
      body: BlocConsumer<HomeFeaturesCubit, HomeFeaturesState>(
        listener: (context, state) {
          if (state is HomeFeaturesError) {
            SnackBarMessage().showErrorSnackBar(message: state.message, context: context);
          }
        },
        builder: (context, state) {
          if (state is HomeFeaturesLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is HomeFeaturesLoaded) {
            if (state.sales == null || state.sales!.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset('assets/icons/amico.svg', width: 200, height: 200),
                    const SizedBox(height: 20),
                    Text(
                      context.l10n.emptyText,
                      style: theme.textTheme.bodyLarge!.copyWith(color: AppColors.black1),
                    ),
                  ],
                ),
              );
            }
            return ListView.builder(
              itemCount: state.sales!.length,
              itemBuilder: (context, index) {
                final sale = state.sales![index];
                return CardWidget(
                  discount: sale.discount,
                  title: sale.name!,
                  description: sale.description!,
                  image: sale.photoLink!,
                );
              },
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
