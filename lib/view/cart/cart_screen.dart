import 'package:brandy/res/constants/strings.dart';
import 'package:brandy/utils/app_locale.dart';
import 'package:brandy/res/styles/colors.dart';
import 'package:flutter/material.dart';
import '../../view_model/cart_provider.dart';
import '../../view_model/home_provider.dart';
import '../../models/cart_model.dart';
import '../../res/components/components.dart';
import '../../res/constants/paths.dart';
import '../../res/custom_widgets/custom_button.dart';
import '../../res/custom_widgets/empty_widget.dart';
import '../../utils/utils.dart';
import '../../res/custom_widgets/custom_texts.dart';
import '../../view/widgets/products/cart_product.dart';
import 'payment_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    HomeProvider homeProvider = HomeProvider.get(context, listen: false);
    CartProvider cartProvider = CartProvider.get(context);

    return Column(
      children: [
        cartProvider.getCartMap.isNotEmpty
            ? Expanded(
                child: ListView.builder(
                  itemCount: cartProvider.getCartMap.length,
                  itemBuilder: (context, index) {
                    CartModel item = cartProvider.getCartMap.values
                        .toList()
                        .reversed
                        .toList()[index];
                    return CartProduct(
                      cartModel: item,
                    );
                  },
                ),
              )
            : EmptyWidget(
                title: LocaleKeys.empty.tr(context),
                buttonFunction: () {
                  HomeProvider.get(context, listen: false).changeTab(0);
                },
                showButton: true,
                buttonText: LocaleKeys.shopNow.tr(context),
                svg: AppImages.shoppingCart,
              ),
        Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TitleMediumText(
                '${LocaleKeys.products.tr(context)}(${cartProvider.getCartMap.length})'
                ' - ${LocaleKeys.items.tr(context)}(${cartProvider.getQuantity()})',
              ),
              InfoWidget(
                label: LocaleKeys.subTotal.tr(context),
                content:
                    '${cartProvider.getSubTotal(homeProvider: homeProvider)} EGP',
              ),
              InfoWidget(
                label: LocaleKeys.discount.tr(context),
                content:
                    '${cartProvider.getTotalDiscount(homeProvider: homeProvider)} EGP',
              ),
              if (cartProvider.getCartList.isNotEmpty)
                InfoWidget(
                  label: LocaleKeys.deliveryFee.tr(context),
                  content: '${cartProvider.getShipping.toString()} EGP',
                ),
              InfoWidget(
                label: LocaleKeys.total.tr(context),
                content:
                    '${cartProvider.getCost(homeProvider: homeProvider)} EGP',
              ),
              CustomButton(
                width: double.infinity,
                color: primaryColor,
                radius: 30,
                function: () {
                  //cartProvider.makeOrder(context: context);
                  if (cartProvider.getCartMap.isNotEmpty) {
                    Utils.navigateTo(
                        widget: const PaymentScreen(), context: context);
                  }
                },
                title: LocaleKeys.checkout.tr(context),
              ),
            ],
          ),
        )
      ],
    );
  }
}
