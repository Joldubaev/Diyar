import 'package:auto_route/auto_route.dart';
import 'package:diyar/l10n/l10n.dart';
import 'package:diyar/shared/components/components.dart';
import 'package:diyar/features/auth/presentation/presentation.dart';
import 'package:diyar/shared/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

@RoutePage()
class CurierPrpfilePage extends StatefulWidget {
  const CurierPrpfilePage({super.key});

  @override
  State<CurierPrpfilePage> createState() => _CurierPrpfilePageState();
}

class _CurierPrpfilePageState extends State<CurierPrpfilePage> {
  final formKey = GlobalKey<FormState>();
  final fullNameController = TextEditingController();
  final phoneController = TextEditingController();

  @override
  dispose() {
    super.dispose();
    fullNameController.dispose();
    phoneController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.profile, style: theme.textTheme.titleSmall)),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Form(
            child: Column(
              children: [
                const SizedBox(height: 40),
                Center(
                  child: CircleAvatar(
                    radius: 60,
                    child: SvgPicture.asset(
                      'assets/icons/profile_icon.svg',
                      height: 100,
                      colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(context.l10n.name, style: theme.textTheme.titleMedium),
                const SizedBox(height: 40),
                CustomInputWidget(
                  title: context.l10n.yourName,
                  hintText: context.l10n.enterYourName,
                  controller: fullNameController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return context.l10n.pleaseEnterCorrectName;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                PhoneNumberMask(
                  title: context.l10n.phone,
                  hintText: '+996 (___) __-__-__',
                  textController: phoneController,
                  hint: context.l10n.phone,
                  formatter: MaskTextInputFormatter(mask: "+996 (###) ##-##-##"),
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
