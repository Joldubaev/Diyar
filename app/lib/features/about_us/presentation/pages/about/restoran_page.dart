import 'package:auto_route/auto_route.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/about_us/domain/domain.dart';
import 'package:diyar/features/features.dart';
import 'package:diyar/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class RestorantPage extends StatefulWidget {
  const RestorantPage({super.key});

  @override
  State<RestorantPage> createState() => _RestorantPageState();
}

class _RestorantPageState extends State<RestorantPage> {
  final type = AboutUsType.values;
  AboutUsEntities? model;

  @override
  void initState() {
    context.read<AboutUsCubit>().getAboutUs(type: 'restoran');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.primary,
        title: Text(context.l10n.restaurant,
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(color: AppColors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.white),
          onPressed: () {
            context.router.maybePop();
          },
        ),
      ),
      body: BlocConsumer<AboutUsCubit, AboutUsState>(
        listener: (context, state) {
          if (state is AboutUsError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
              ),
            );
          } else if (state is AboutUsLoaded) {
            model = state.aboutUsModel;
          }
        },
        builder: (context, state) {
          if (state is AboutUsLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return CustomAboutWidget(model: model!);
        },
      ),
    );
  }
}
