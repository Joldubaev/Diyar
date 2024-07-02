import 'dart:io';

import 'package:diyar/shared/theme/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Platform.isIOS
          ? const CupertinoActivityIndicator(color: AppColors.primary)
          : const CircularProgressIndicator(color: AppColors.primary),
    );
  }
}

class LoadingAdaptive extends StatelessWidget {
  const LoadingAdaptive({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator.adaptive(),
    );
  }
}
