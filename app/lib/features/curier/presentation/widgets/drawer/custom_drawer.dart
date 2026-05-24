import 'package:diyar/features/curier/curier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'drawer_header.dart';
import 'drawer_navigation.dart';
import 'logout_section.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<CurierCubit, CurierState>(
      buildWhen: (p, c) => p.user != c.user,
      builder: (context, state) {
        final user = state.user;

        if (user == null) {
          return const Drawer(
            child: Center(child: CircularProgressIndicator()),
          );
        }

        return Drawer(
          backgroundColor: theme.scaffoldBackgroundColor,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              bottomLeft: Radius.circular(20),
            ),
          ),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                DrawerHeaderWidget(user: user),
                const SizedBox(height: 8),
                const DrawerNavigation(),
                const Spacer(),
                const Divider(height: 1),
                const LogoutSection(),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }
}
