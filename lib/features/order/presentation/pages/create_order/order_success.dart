import 'package:auto_route/auto_route.dart';
import 'package:diyar/core/router/routes.gr.dart';
import 'package:diyar/l10n/l10n.dart';
import 'package:diyar/shared/components/components.dart';
import 'package:diyar/shared/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

@RoutePage()
class OrderSuccess extends StatelessWidget {
  const OrderSuccess({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_sharp),
              onPressed: () => context.router.back())),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/icons/check.svg',
                height: 150,
                width: 150,
              ),
              const SizedBox(height: 30),
              Text(context.l10n.yourOrdersConfirm,
                  style: theme.textTheme.titleSmall,
                  textAlign: TextAlign.center),
              FittedBox(
                child: Text(
                  context.l10n.orderTime,
                  style: theme.textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: SubmitButtonWidget(
          title: context.l10n.createTemplate,
          bgColor: AppColors.primary,
          textStyle: theme.textTheme.bodyMedium!.copyWith(
            color: AppColors.white,
          ),
          onTap: () {
            showAdaptiveDialog(
                barrierColor: Colors.black.withOpacity(0.5),
                context: context,
                builder: (context) {
                  return const CreateOrderDialog();
                });
          },
        ),
      ),
    );
  }
}

class CreateOrderDialog extends StatefulWidget {
  const CreateOrderDialog({super.key});

  @override
  State<CreateOrderDialog> createState() => _CreateOrderDialogState();
}

class _CreateOrderDialogState extends State<CreateOrderDialog> {
  final TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title:
          Text(context.l10n.createTemplate, style: theme.textTheme.titleSmall),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            context.l10n.templateDescription,
            style: theme.textTheme.bodySmall!.copyWith(color: AppColors.grey),
          ),
          const SizedBox(height: 20),
          CustomInputWidget(
            hintText: context.l10n.templateName,
            controller: _controller,
            validator: (value) {
              if (value!.isEmpty) {
                return context.l10n.pleaseEnterTemplateName;
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          SubmitButtonWidget(
            title: context.l10n.create,
            bgColor: AppColors.primary,
            textStyle: theme.textTheme.bodyMedium!.copyWith(
              color: AppColors.white,
            ),
            onTap: () {
              if (_controller.text.isEmpty) {
                return;
              }
              context.router.push(const MainRoute());
            },
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              context.l10n.edit,
              style:
                  theme.textTheme.bodyMedium!.copyWith(color: AppColors.blue),
            ),
          )
        ],
      ),
    );
  }
}
