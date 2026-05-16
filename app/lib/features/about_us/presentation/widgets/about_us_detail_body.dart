import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:diyar/core/di/injectable_config.dart';
import 'package:diyar/features/about_us/domain/domain.dart';
import 'package:diyar/features/about_us/presentation/cubit/about_us_cubit.dart';
import 'package:diyar/features/about_us/presentation/widgets/custom_about_widget.dart';

class AboutUsDetailBody extends StatefulWidget {
  final String apiType;

  const AboutUsDetailBody({super.key, required this.apiType});

  @override
  State<AboutUsDetailBody> createState() => _AboutUsDetailBodyState();
}

class _AboutUsDetailBodyState extends State<AboutUsDetailBody> {
  late final AboutUsCubit _cubit;
  AboutUsEntity? _model;

  @override
  void initState() {
    super.initState();
    _cubit = sl<AboutUsCubit>()..getAboutUs(type: widget.apiType);
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: BlocConsumer<AboutUsCubit, AboutUsState>(
        listener: (context, state) {
          if (state is AboutUsError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          } else if (state is AboutUsLoaded) {
            setState(() => _model = state.aboutUsModel);
          }
        },
        builder: (context, state) {
          if (state is AboutUsLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (_model == null) {
            return const SizedBox.shrink();
          }
          return CustomAboutWidget(model: _model!);
        },
      ),
    );
  }
}
