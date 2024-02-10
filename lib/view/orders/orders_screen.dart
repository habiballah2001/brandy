import 'package:brandy/res/constants/strings.dart';
import 'package:brandy/utils/app_locale.dart';
import 'package:flutter/material.dart';

import '../../res/custom_widgets/CustomAppBar.dart';
import '../../view/widgets/orders/order_views.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({
    super.key,
  });

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () {
      //your code goes here
    });
    return DefaultTabController(
      length: 4,
      child: Scaffold(
          appBar: CustomAppBar(
            title: const Text('My Orders'),
            bottom: TabBar(
              tabs: [
                Tab(
                  text: LocaleKeys.waiting.tr(context),
                ),
                Tab(
                  text: LocaleKeys.inProcess.tr(context),
                ),
                Tab(
                  text: LocaleKeys.delivered.tr(context),
                ),
                Tab(
                  text: LocaleKeys.all.tr(context),
                ),
              ],
            ),
          ),
          body: const TabBarView(
            children: [
              WaitingOrders(),
              ProcessingOrders(),
              DeliveredOrders(),
              AllOrders(),
            ],
          )),
    );
  }
}
