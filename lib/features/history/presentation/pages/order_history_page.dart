import 'package:auto_route/auto_route.dart';
import 'package:diyar/features/features.dart';
import 'package:diyar/l10n/l10n.dart';
import 'package:diyar/shared/theme/theme.dart';
import 'package:flutter/material.dart';

@RoutePage()
class OrderHistoryPage extends StatelessWidget {
  const OrderHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            context.l10n.orderHistory,
            style: theme.textTheme.bodyLarge,
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(40),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              child: Container(
                height: 40,
                margin: const EdgeInsets.fromLTRB(20, 10, 20, 5),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  color: AppColors.grey.withOpacity(0.2),
                ),
                child: TabBar(
                  indicatorSize: TabBarIndicatorSize.tab,
                  dividerColor: Colors.transparent,
                  indicator: const BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  labelColor: AppColors.white,
                  unselectedLabelColor: Colors.black54,
                  tabs: [
                    TabItem(title: context.l10n.activeOrders),
                    TabItem(title: context.l10n.orderHistory),
                  ],
                ),
              ),
            ),
          ),
        ),
        body: PageStorage(
          bucket: PageStorageBucket(),
          child: const TabBarView(
            children: [ActiveOrderPage(), OrderHistory()],
          ),
        ),
      ),
    );
  }
}
