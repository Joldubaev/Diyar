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
      buildWhen: (p, c) => c is UserLoaded || p is UserLoaded,
      builder: (context, state) {
        final user = state is UserLoaded ? state.user : context.read<CurierCubit>().state.user;

        if (user == null) {
          return const Drawer(
            child: Center(child: CircularProgressIndicator()),
          );
        }

        return Drawer(
          backgroundColor: theme.scaffoldBackgroundColor,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                DrawerHeaderWidget(user: user),
                const Expanded(
                  child: DrawerNavigation(),
                ),
                const LogoutSection(),
              ],
            ),
          ),
        );
      },
    );
  }
}
