import 'package:brandy/res/constants/strings.dart';
import 'package:brandy/utils/app_locale.dart';
import 'package:flutter/material.dart';
import '../../../models/order_model.dart';
import '../../../res/custom_widgets/custom_container.dart';
import '../../../utils/utils.dart';
import '../../../res/custom_widgets/custom_texts.dart';
import '../../orders/order_details.dart';

class OrderItem extends StatelessWidget {
  final OrderModel orderModel;
  const OrderItem({
    super.key,
    required this.orderModel,
  });

  @override
  Widget build(BuildContext context) {
    String? orderDate = '${orderModel.date!.toDate().year}-'
        '${orderModel.date!.toDate().month}-'
        '${orderModel.date!.toDate().day} '
        '${orderModel.date!.toDate().hour}:'
        '${orderModel.date!.toDate().minute}';
    return InkWell(
      onTap: () {
        Utils.navigateTo(
            widget: OrderDetailsScreen(orderModel: orderModel),
            context: context);
      },
      child: Column(
        children: [
          CustomContainer(
            padding: 10,
            child: Column(
              children: [
                Row(
                  children: [
                    BodyLargeText(LocaleKeys.date.tr(context)),
                    const Spacer(),
                    BodyLargeText(orderDate),
                  ],
                ),
                Row(
                  children: [
                    BodyLargeText(LocaleKeys.cost.tr(context)),
                    const Spacer(),
                    BodyLargeText(orderModel.cost.toString()),
                  ],
                ),
                Row(
                  children: [
                    BodyLargeText(LocaleKeys.status.tr(context)),
                    const Spacer(),
                    BodyLargeText(orderModel.status!),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
