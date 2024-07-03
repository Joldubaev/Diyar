import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:diyar/core/router/routes.gr.dart';
import 'package:diyar/features/features.dart';
import 'package:diyar/l10n/l10n.dart';
import 'package:diyar/shared/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class AboutUsPage extends StatefulWidget {
  const AboutUsPage({super.key});

  @override
  State<AboutUsPage> createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {
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
            context.l10n.aboutUs,
            style: theme.textTheme.titleSmall?.copyWith(
              color: AppColors.white,
            ),
          )),
      body: const SafeArea(
        child: AboutUsBody(),
      ),
    );
  }
}

class AboutUsBody extends StatefulWidget {
  const AboutUsBody({super.key});

  @override
  State<AboutUsBody> createState() => _AboutUsBodyState();
}

class _AboutUsBodyState extends State<AboutUsBody> {
  final type = AboutUsType.values;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AboutUsCubit, AboutUsState>(
      listener: (context, state) {
        if (state is AboutUsError) {
          log('Error: ${state.message}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        } else if (state is AboutUsLoaded) {
          log('Loaded ${state.aboutUsModel}');
        }
      },
      builder: (context, state) {
        log('State: $state');
        if (state is AboutUsLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
          itemCount: type.length,
          itemBuilder: (context, index) {
            final type = AboutUsType.values[index];
            return HallCardWidget(
              hallName: type.getUIName(context),
              imagePath: type.getAsset,
              title: type.getTitle(context),
              onPressed: () {
                if (type == AboutUsType.cafe) {
                  context.router.push(const CofeRoute());
                } else if (type == AboutUsType.hall) {
                  context.router.push(const HallRoute());
                } else if (type == AboutUsType.restoran) {
                  context.router.push(const RestorantRoute());
                } else if (type == AboutUsType.vip) {
                  context.router.push(const VipRoute());
                }
              },
            );
          },
        );
      },
    );
  }
}
