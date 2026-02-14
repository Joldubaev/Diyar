import 'package:auto_route/annotations.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/features.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

@RoutePage()
class SecurityPage extends StatelessWidget {
  const SecurityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Безопасность'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDeleteAccountButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildDeleteAccountButton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
      child: SettingsTile(
        leading: SvgPicture.asset(
          'assets/icons/delete_a.svg',
          height: 40,
        ),
        text: 'Удалить аккаунт',
        onPressed: () => _showDeleteConfirmation(context),
        color: Theme.of(context).colorScheme.error,
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    AppAlert.showConfirmDialog(
      context: context,
      title: 'Удалить',
      content: const Text('Вы уверены что хотите удалить аккаунт?'),
      cancelText: context.l10n.no,
      confirmText: context.l10n.yes,
      cancelPressed: () => Navigator.pop(context),
      confirmPressed: () => context.read<ProfileCubit>().deleteUser(),
    );
  }
}
