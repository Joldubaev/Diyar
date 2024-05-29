import 'package:diyar/shared/constants/constant.dart';
import 'package:diyar/shared/theme/theme.dart';
import 'package:flutter/material.dart';

class AppLanguagesList extends StatelessWidget {
  const AppLanguagesList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: AppConst.locales.length,
      itemBuilder: (BuildContext context, int index) {
        final locale = AppConst.locales[index];
        final langName = AppConst.getName(locale.toLanguageTag());
        return Card(
          child: ListTile(
              title: Text(langName, locale: locale),
              onTap: () {},
              trailing: const Icon(Icons.check, color: AppColors.primary)),
        );
      },
    );
  }
}
