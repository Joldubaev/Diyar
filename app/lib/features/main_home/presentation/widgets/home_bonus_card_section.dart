import 'package:diyar/features/features.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeBonusCardSection extends StatelessWidget {
  const HomeBonusCardSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeContentCubit, HomeContentState>(
      buildWhen: (prev, curr) => curr is HomeContentLoading || curr is HomeContentLoaded,
      builder: (context, state) {
        final profile = state is HomeContentLoaded ? state.profile : null;
        return BonusCardWidget(profile: profile);
      },
    );
  }
}
