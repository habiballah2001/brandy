import 'dart:developer';
import 'package:brandy/res/custom_widgets/custom_outlined_button.dart';
import 'package:brandy/utils/app_locale.dart';
import 'package:brandy/utils/utils.dart';
import 'package:brandy/view/widgets/paypal_checkout.dart';
import 'package:flutter/material.dart';
import '../../res/constants/strings.dart';
import '../../view_model/cart_provider.dart';
import '../../view_model/home_provider.dart';
import '../../view_model/order_provider.dart';
import '../../models/cart_model.dart';
import '../../res/components/components.dart';
import '../../res/custom_widgets/CustomAppBar.dart';
import '../../res/custom_widgets/custom_button.dart';
import '../../utils/dialogs.dart';
import '../../res/custom_widgets/custom_texts.dart';
import '../../view/widgets/address/delivery_address.dart';
import '../../view/widgets/products/order_product.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  bool _isCash = true;

  @override
  Widget build(BuildContext context) {
    CartProvider cartProvider = CartProvider.get(context);
    OrderProvider orderProvider = OrderProvider.get(context);
    HomeProvider homeProvider = HomeProvider.get(context, listen: false);

    return Scaffold(
      appBar: CustomAppBar(
        title: TitleMediumText(LocaleKeys.checkout.tr(context)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InfoWidget(
              label: LocaleKeys.total.tr(context),
              content:
                  '${cartProvider.getCost(homeProvider: homeProvider)} EGP',
            ),
            const Divider(),
            TitleMediumText(LocaleKeys.payment.tr(context)),
            CustomOutlinedButton(
              radius: 1,
              borderColor: _isCash == true ? Colors.green : Colors.grey,
              title: 'Cash',
              function: () {
                setState(() {
                  _isCash = true;
                });
                log(_isCash.toString());
              },
            ),
            CustomOutlinedButton(
              radius: 1,
              borderColor: _isCash == true ? Colors.grey : Colors.green,
              title: 'PayPal',
              leadIcon: Icons.paypal,
              iconColor: Colors.blue,
              function: () {
                setState(() {
                  _isCash = false;
                });
                log(_isCash.toString());
              },
            ),
            const Divider(),
            TitleMediumText(LocaleKeys.address.tr(context)),
            const SpaceHeight(height: 5),
            OrderAddressWidget(
              addressModel: orderProvider.addressModel,
              function: () {
                Dialogs.addressDialog(context);
              },
            ),
            const SizedBox(height: 16.0),
            TitleMediumText(
              LocaleKeys.products.tr(context),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: cartProvider.getCartMap.length,
                itemBuilder: (context, index) {
                  CartModel item = cartProvider.getCartMap.values
                      .toList()
                      .reversed
                      .toList()[index];
                  return OrderProduct(
                    productId: item.productId!,
                    quantity: cartProvider.getCartMap.values
                        .toList()[index]
                        .quantity
                        .toString(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomButton(
        title: LocaleKeys.checkout.tr(context),
        function: () {
          if (_isCash == true) {
            orderProvider.addressModel != null
                ? orderProvider.makeOrder(context: context)
                : Dialogs.warningDialog(
                    content: LocaleKeys.picAddress.tr(context),
                    context: context,
                  );
          } else {
            orderProvider.addressModel != null
                ? {
                    cartProvider.fetchCartProductsDetails(context),
                    Utils.navigateTo(
                        widget: const PaypalCheckoutWidget(), context: context)
                  }
                : Dialogs.warningDialog(
                    content: LocaleKeys.picAddress.tr(context),
                    context: context,
                  );
          }
        },
      ),
    );
  }
}
