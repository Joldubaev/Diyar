import 'package:auto_route/auto_route.dart';
import 'package:diyar/core/router/routes.gr.dart';
import 'package:diyar/l10n/l10n.dart';
import 'package:flutter/cupertino.dart';
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
          backgroundColor: Theme.of(context).primaryColor,
          automaticallyImplyLeading: false,
          title: Text(context.l10n.orderHistory,
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontWeight: FontWeight.bold)),
          // bottom: PreferredSize(
          //   preferredSize: const Size.fromHeight(40),
          //   child: ClipRRect(
          //     borderRadius: const BorderRadius.all(Radius.circular(10)),
          //     child: Container(
          //       height: 40,
          //       margin: const EdgeInsets.fromLTRB(20, 10, 20, 5),
          //       decoration: BoxDecoration(
          //         borderRadius: const BorderRadius.all(Radius.circular(20)),
          //         color: AppColors.grey.withOpacity(0.2),
          //       ),
          //       child: TabBar(
          //         indicatorSize: TabBarIndicatorSize.tab,
          //         dividerColor: Colors.transparent,
          //         indicator: const BoxDecoration(
          //           color: AppColors.primary,
          //           borderRadius: BorderRadius.all(Radius.circular(20)),
          //         ),
          //         labelColor: AppColors.white,
          //         unselectedLabelColor: Colors.black54,
          //         tabs: [
          //           TabItem(title: context.l10n.activeOrders),
          //           TabItem(title: context.l10n.orderHistory),
          //         ],
          //       ),
          //     ),
          //   ),
          // ),
        ),
        // body: PageStorage(
        //   bucket: PageStorageBucket(),
        //   child: const TabBarView(
        //     children: [ActiveOrderPage(), OrderHistory()],
        //   ),
        // ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OrderButton(
                text: context.l10n.activeOrders,
                icon: Icons.delivery_dining,
                onPressed: () {
                  context.router.push(const ActiveOrderRoute());
                },
              ),
              const SizedBox(height: 20),
              OrderButton(
                text: context.l10n.pickup,
                icon: CupertinoIcons.car_detailed,
                onPressed: () {
                  context.router.push(const UserPickupHistoryRoute());
                },
              ),
              const SizedBox(height: 20),
              OrderButton(
                text: context.l10n.orderHistory,
                icon: Icons.history,
                onPressed: () {
                  context.router.push(const UserOrderHistoryRoute());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OrderButton extends StatelessWidget {
  const OrderButton(
      {super.key,
      required this.text,
      required this.icon,
      required this.onPressed});

  final String text;
  final IconData icon;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          padding: EdgeInsets.zero,
          elevation: 3),
      child: Container(
        width: double.infinity,
        height: 100,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(icon, color: Theme.of(context).primaryColor),
            const SizedBox(width: 15),
            Expanded(
              child: Text(
                text,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: Colors.grey[500]),
          ],
        ),
      ),
    );
  }
}
