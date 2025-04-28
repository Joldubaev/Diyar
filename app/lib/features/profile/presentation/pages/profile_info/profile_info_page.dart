import 'package:auto_route/auto_route.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/auth/auth.dart';
import 'package:diyar/features/profile/prof.dart';
import 'package:diyar/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

@RoutePage()
class ProfileInfoPage extends StatefulWidget {
  static const double _avatarRadius = 60.0;
  static const double _defaultSpacing = 20.0;
  static const double _largeSpacing = 40.0;

  final UserModel user;

  const ProfileInfoPage({
    super.key,
    required this.user,
  });

  @override
  State<ProfileInfoPage> createState() => _ProfileInfoPageState();
}

class _ProfileInfoPageState extends State<ProfileInfoPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _fullNameController;
  late final TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    _fullNameController = TextEditingController(text: widget.user.userName ?? '');
    _phoneController = TextEditingController(text: widget.user.phone);
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildBody(context),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.primary,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: AppColors.white),
        onPressed: () => context.router.maybePop(),
      ),
      title: Text(
        context.l10n.profile,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: AppColors.white,
            ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: ProfileInfoPage._defaultSpacing,
      ),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: ProfileInfoPage._largeSpacing),
              _buildProfileAvatar(),
              const SizedBox(height: 10),
              _buildUserName(context),
              const SizedBox(height: ProfileInfoPage._largeSpacing),
              _buildNameInput(context),
              const SizedBox(height: ProfileInfoPage._defaultSpacing),
              _buildPhoneInput(context),
              const SizedBox(height: ProfileInfoPage._largeSpacing),
              _buildDeleteAccountButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileAvatar() {
    return CircleAvatar(
      radius: ProfileInfoPage._avatarRadius,
      child: SvgPicture.asset(
        'assets/icons/profile_icon.svg',
        height: 100,
        colorFilter: const ColorFilter.mode(
          AppColors.white,
          BlendMode.srcIn,
        ),
      ),
    );
  }

  Widget _buildUserName(BuildContext context) {
    return Text(
      widget.user.userName ?? '',
      style: Theme.of(context).textTheme.titleMedium,
    );
  }

  Widget _buildNameInput(BuildContext context) {
    return CustomInputWidget(
      filledColor: Theme.of(context).colorScheme.surface,
      isReadOnly: true,
      title: context.l10n.name,
      hintText: context.l10n.yourName,
      controller: _fullNameController,
      validator: (value) {
        if (value?.isEmpty ?? true) {
          return context.l10n.pleaseEnterName;
        }
        return null;
      },
    );
  }

  Widget _buildPhoneInput(BuildContext context) {
    return CustomInputWidget(
      title: context.l10n.phone,
      hintText: '+996',
      filledColor: Theme.of(context).colorScheme.surface,
      controller: _phoneController,
      inputType: TextInputType.phone,
      inputFormatters: [phoneFormatter],
      validator: (value) {
        if (value?.isEmpty ?? true) {
          return context.l10n.pleaseEnterPhone;
        }
        if (value!.length < 10) {
          return context.l10n.pleaseEnterCorrectPhone;
        }
        return null;
      },
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
