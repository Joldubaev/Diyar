import 'package:diyar/core/core.dart';
import 'package:diyar/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppWrapperConnectionPage extends StatefulWidget {
  final Widget child;

  const AppWrapperConnectionPage({super.key, required this.child});

  @override
  State<AppWrapperConnectionPage> createState() =>
      _AppWrapperConnectionPageState();
}

class _AppWrapperConnectionPageState extends State<AppWrapperConnectionPage> {
  bool isInternet = false;

  @override
  Widget build(BuildContext context) {
    return BlocListener<InternetBloc, InternetState>(
      listener: (context, state) {
        if (state is NetworkFailure) {
          setState(() => isInternet = false);

          showModalBottomSheet(
            context: appRoute.navigatorKey.currentContext!,
            isScrollControlled: true,
            isDismissible: true,
            backgroundColor: AppColors.transparent,
            constraints: const BoxConstraints(
              maxWidth: double.infinity,
              minHeight: 200,
              maxHeight: 200,
            ),
            useSafeArea: true,
            builder: (BuildContext context) {
              return Container(
                margin: const EdgeInsets.all(10),
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                child: const PopScope(
                  canPop: false,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.wifi_off, size: 50, color: AppColors.primary),
                      SizedBox(height: 10),
                      Text('Нет интернет соединения'),
                    ],
                  ),
                ),
              );
            },
          );
        } else {
          setState(() => isInternet = true);
          if (isInternet &&
              Navigator.canPop(appRoute.navigatorKey.currentContext!)) {
            Navigator.pop(appRoute.navigatorKey.currentContext!);
          }
        }
      },
      child: widget.child,
    );
  }
}
