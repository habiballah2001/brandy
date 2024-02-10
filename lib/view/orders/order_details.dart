import 'package:brandy/res/constants/strings.dart';
import 'package:brandy/utils/app_locale.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../view_model/order_provider.dart';
import '../../models/order_model.dart';
import '../../res/components/components.dart';
import '../../res/custom_widgets/CustomAppBar.dart';
import '../../res/custom_widgets/custom_button.dart';
import '../../res/custom_widgets/custom_texts.dart';
import '../../view/widgets/address/delivery_address.dart';
import '../../view/widgets/products/order_product.dart';

class OrderDetailsScreen extends StatefulWidget {
  final OrderModel orderModel;
  const OrderDetailsScreen({
    super.key,
    required this.orderModel,
  });

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  //bool _isLoad = true;
  Future<void> fetchOrderData() async {
    final orderProvider = Provider.of<OrderProvider>(
      context,
      listen: false,
    );

    await orderProvider.fetchOrderDetails(
      orderId: widget.orderModel.orderId!,
    );
  }

  @override
  void initState() {
    super.initState();
    Provider.of<OrderProvider>(
      context,
      listen: false,
    ).fetchOrderDetails(
      orderId: widget.orderModel.orderId!,
    );
  }

  @override
  Widget build(BuildContext context) {
    OrderProvider orderProvider = OrderProvider.get(context);
    String? orderDate = '${widget.orderModel.date!.toDate().year}-'
        '${widget.orderModel.date!.toDate().month}-'
        '${widget.orderModel.date!.toDate().day} '
        '${widget.orderModel.date!.toDate().hour}:'
        '${widget.orderModel.date!.toDate().minute}';
    return Scaffold(
      appBar: CustomAppBar(
        title: const TitleLargeText('Order Details'),
        actions: [
          if (widget.orderModel.status == 'waiting')
            CustomButton(
              title: LocaleKeys.cancelOrder.tr(context),
              radius: 30,
              function: () {
                orderProvider.cancelOrder(
                  orderId: widget.orderModel.orderId!,
                  context: context,
                );
              },
            )
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                OrderAddressWidget(addressModel: widget.orderModel.address),
                const SpaceHeight(),
                InfoWidget(
                  label: LocaleKeys.cost.tr(context),
                  content: widget.orderModel.cost.toString(),
                ),
                InfoWidget(
                  label: LocaleKeys.products.tr(context),
                  content: widget.orderModel.products.length.toString(),
                ),
                InfoWidget(
                  label: LocaleKeys.orderDate.tr(context),
                  content: orderDate,
                ),
                InfoWidget(
                  label: LocaleKeys.status.tr(context),
                  content: widget.orderModel.status!,
                )
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) {
                return OrderProduct(
                  productId: widget.orderModel.products[index]['productId'],
                  quantity:
                      widget.orderModel.products[index]['quantity'].toString(),
                );
              },
              itemCount: widget.orderModel.products.length,
            ),
          ),
          if (widget.orderModel.status == 'inProcessing')
            CustomButton(
              title: LocaleKeys.delivered.tr(context),
              color: Colors.green,
            ),
        ],
      ),
    );
  }
}
