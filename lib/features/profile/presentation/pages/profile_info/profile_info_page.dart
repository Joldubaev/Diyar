import 'package:auto_route/auto_route.dart';
import 'package:diyar/features/profile/prof.dart';
import 'package:diyar/l10n/l10n.dart';
import 'package:diyar/shared/components/components.dart';
import 'package:diyar/features/auth/data/models/user_model.dart';
import 'package:diyar/shared/theme/app_colors.dart';
import 'package:diyar/shared/utils/fmt/show_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

@RoutePage()
class ProfileInfoPage extends StatefulWidget {
  final UserModel user;
  const ProfileInfoPage({super.key, required this.user});

  @override
  State<ProfileInfoPage> createState() => _ProfileInfoPageState();
}

class _ProfileInfoPageState extends State<ProfileInfoPage> {
  final formKey = GlobalKey<FormState>();
  final fullNameController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fullNameController.text = widget.user.name ?? '';
    _phoneController.text = widget.user.phone ?? '';
  }

  @override
  dispose() {
    super.dispose();
    fullNameController.dispose();
    _phoneController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: AppColors.white),
            onPressed: () {
              context.router.maybePop();
            },
          ),
          title: Text(
            context.l10n.profile,
            style: Theme.of(context)
                .textTheme
                .titleSmall
                ?.copyWith(color: AppColors.white),
          )),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                const SizedBox(height: 40),
                Center(
                  child: CircleAvatar(
                    radius: 60,
                    child: SvgPicture.asset(
                      'assets/icons/profile_icon.svg',
                      height: 100,
                      colorFilter: const ColorFilter.mode(
                          AppColors.white, BlendMode.srcIn),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text('${widget.user.name} ',
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 40),
                CustomInputWidget(
                  filledColor: Theme.of(context).colorScheme.surface,
                  isReadOnly: true,
                  title: context.l10n.name,
                  hintText: context.l10n.yourName,
                  controller: fullNameController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return context.l10n.pleaseEnterName;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                CustomInputWidget(
                  hintText: '+996',
                  filledColor: Theme.of(context).colorScheme.surface,
                  controller: _phoneController,
                  inputType: TextInputType.phone,
                  inputFormatters: [phoneFormatter],
                  validator: (value) {
                    if (value!.isEmpty) {
                      return context.l10n.pleaseEnterPhone;
                    } else if (value.length < 10) {
                      return context.l10n.pleaseEnterCorrectPhone;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 40),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
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
                    onPressed: () {
                      AppAlert.showConfirmDialog(
                        context: context,
                        title: 'Удалить',
                        content: const Text(
                            'Вы уверены что хотите удалить аккаунт?'),
                        cancelText: context.l10n.no,
                        confirmText: context.l10n.yes,
                        cancelPressed: () => Navigator.pop(context),
                        confirmPressed: () =>
                            context.read<ProfileCubit>().deleteUser(),
                      );
                    },
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
