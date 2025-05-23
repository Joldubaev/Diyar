import 'package:auto_route/auto_route.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/features.dart';
import 'package:diyar/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';

@RoutePage()
class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: AppColors.white),
            onPressed: () {
              context.router.maybePop();
            }),
        title: Text(context.l10n.contact,
            style: Theme.of(context)
                .textTheme
                .titleSmall!
                .copyWith(color: AppColors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            const Expanded(child: ContactBody()),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    AppLaunch.launchURL(AppConst.instagram,
                        context: context,
                        snackBarText: context.l10n.someThingIsWrong);
                  },
                  icon: SvgPicture.asset('assets/icons/insta.svg',
                      width: 40, height: 40),
                ),
                const SizedBox(width: 40),
                IconButton(
                  onPressed: () {
                    AppLaunch.sendEmail(AppConst.email,
                        context: context,
                        snackBarText: context.l10n.someThingIsWrong);
                  },
                  icon: Image.asset('assets/images/mail.png',
                      width: 40, height: 40),
                ),
              ],
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class ContactBody extends StatefulWidget {
  const ContactBody({super.key});
  @override
  State<ContactBody> createState() => _ContactBodyState();
}

class _ContactBodyState extends State<ContactBody> {
  bool _hasCallSupport = false;

  @override
  void initState() {
    super.initState();
    canLaunchUrl(Uri(scheme: 'tel', path: '123')).then((bool result) {
      setState(() {
        _hasCallSupport = result;
      });
    });
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      itemCount: ContactType.values.length,
      itemBuilder: (context, index) {
        final contactType = ContactType.values[index];
        return ContactCardWidget(
            subtitle: contactType.getNumber(),
            imagePath: contactType.getAsset,
            title: contactType.getTitle(context),
            onPressed: _hasCallSupport
                ? () => _makePhoneCall(contactType.getNumber())
                : () {});
      },
    );
  }
}
