import 'package:auto_route/auto_route.dart';
import 'package:diyar/l10n/l10n.dart';
import 'package:diyar/shared/components/components.dart';
import 'package:diyar/features/auth/data/models/user_mpdel.dart';
import 'package:diyar/features/auth/presentation/widgets/phone_number.dart';
import 'package:diyar/shared/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
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
  final phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fullNameController.text = widget.user.name ?? '';
    phoneController.text = widget.user.phone ?? '';
  }

  @override
  dispose() {
    super.dispose();
    fullNameController.dispose();
    phoneController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: AppColors.primary,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: AppColors.white),
            onPressed: () {
              context.router.maybePop();
            },
          ),
          title: Text(
            context.l10n.profile,
            style: theme.textTheme.titleSmall?.copyWith(
              color: AppColors.white,
            ),
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
                      colorFilter:
                          const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text('${widget.user.name} ',
                    style: theme.textTheme.titleMedium),
                const SizedBox(height: 40),
                CustomInputWidget(
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
                PhoneNumberMask(
                  isReadOnly: true,
                  title: context.l10n.phone,
                  hintText: '+996 (___) __-__-__',
                  textController: phoneController,
                  hint: context.l10n.phone,
                  formatter:
                      MaskTextInputFormatter(mask: "+996 (###) ##-##-##"),
                  textInputType: TextInputType.phone,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return context.l10n.pleaseEnterPhone;
                    } else if (value.length < 10) {
                      return context.l10n.pleaseEnterCorrectPhone;
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
