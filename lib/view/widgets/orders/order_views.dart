import 'dart:developer';
import 'package:brandy/res/constants/strings.dart';
import 'package:brandy/res/custom_widgets/empty_widget.dart';
import 'package:brandy/utils/app_locale.dart';
import 'package:flutter/material.dart';
import '../../../models/order_model.dart';
import '../../../res/custom_widgets/custom_texts.dart';
import '../../../view_model/order_provider.dart';
import 'order_item.dart';

class WaitingOrders extends StatelessWidget {
  const WaitingOrders({super.key});

  @override
  Widget build(BuildContext context) {
    OrderProvider orderProvider = OrderProvider.get(context);
    return StreamBuilder(
      stream: orderProvider.fetchOrdersStream(status: 'waiting'),
      builder: orderViewWidget,
    );
  }
}

class ProcessingOrders extends StatelessWidget {
  const ProcessingOrders({super.key});

  @override
  Widget build(BuildContext context) {
    OrderProvider orderProvider = OrderProvider.get(context);
    return StreamBuilder(
      stream: orderProvider.fetchOrdersStream(status: 'inProcessing'),
      builder: orderViewWidget,
    );
  }
}

class DeliveredOrders extends StatelessWidget {
  const DeliveredOrders({super.key});

  @override
  Widget build(BuildContext context) {
    OrderProvider orderProvider = OrderProvider.get(context);
    return StreamBuilder(
      stream: orderProvider.fetchOrdersStream(status: 'delivered'),
      builder: orderViewWidget,
    );
  }
}

class AllOrders extends StatelessWidget {
  const AllOrders({super.key});

  @override
  Widget build(BuildContext context) {
    OrderProvider orderProvider = OrderProvider.get(context);
    return StreamBuilder(
      stream: orderProvider.fetchOrdersStream(),
      builder: orderViewWidget,
    );
  }
}

Widget orderViewWidget(context, AsyncSnapshot<List<OrderModel>> snapshot) {
  if (snapshot.data != null) {
    return snapshot.data!.isNotEmpty
        ? ListView.separated(
            itemBuilder: (context, index) => OrderItem(
              orderModel: snapshot.data![index],
            ),
            itemCount: snapshot.data!.length,
            separatorBuilder: (BuildContext context, int index) =>
                const Divider(),
          )
        : const EmptyWidget(
            icon: Icons.leave_bags_at_home_sharp,
            withExpanded: false,
          );
  } else if (snapshot.connectionState == ConnectionState.waiting) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  } else {
    log('Something wrong!${snapshot.error}');
    return Center(
      child: HeadLargeText(
          '${LocaleKeys.somethingWrong.tr(context)}!${snapshot.error}'),
    );
  }
}
