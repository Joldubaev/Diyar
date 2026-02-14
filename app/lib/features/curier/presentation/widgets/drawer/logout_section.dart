import 'package:auto_route/auto_route.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/auth/presentation/presentation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'drawer_item.dart';

class LogoutSection extends StatelessWidget {
  const LogoutSection({super.key});

  @override
  Widget build(BuildContext context) {
    return DrawerItem(
      icon: Icons.exit_to_app,
      title: 'Выход',
      color: Theme.of(context).colorScheme.error,
      onTap: () => _confirmLogout(context),
    );
  }

  void _confirmLogout(BuildContext context) {
    AppAlert.showConfirmDialog(
      context: context,
      title: 'Выход',
      content: const Text('Вы уверены, что хотите выйти?'),
      confirmText: 'Выйти',
      cancelText: 'Отмена',
      confirmPressed: () {
        context.read<SignInCubit>().logout();
        context.router.replaceAll([const SignInRoute()]);
      },
    );
  }
}
