import 'package:auto_route/auto_route.dart';
import 'package:diyar/features/features.dart';
import 'package:diyar/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class VipPage extends StatefulWidget {
  const VipPage({super.key});

  @override
  State<VipPage> createState() => _VipPageState();
}

class _VipPageState extends State<VipPage> {
  final type = AboutUsType.values;
  AboutUsModel? model;

  @override
  void initState() {
    context.read<AboutUsCubit>().getAboutUs(type: 'VIP');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.primary,
        title: Text(context.l10n.vip,
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(color: theme.colorScheme.surface)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: theme.colorScheme.surface),
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
