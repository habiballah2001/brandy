import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_paypal_checkout/flutter_paypal_checkout.dart';
import '../../res/constants/constants.dart';
import '../../view_model/cart_provider.dart';
import '../../view_model/home_provider.dart';
import '../../view_model/order_provider.dart';

class PaypalCheckoutWidget extends StatelessWidget {
  const PaypalCheckoutWidget({super.key});

  @override
  Widget build(BuildContext context) {
    CartProvider cartProvider = CartProvider.get(context);
    OrderProvider orderProvider = OrderProvider.get(context);
    HomeProvider homeProvider = HomeProvider.get(context, listen: false);

    return PaypalCheckout(
      sandboxMode: true,
      clientId: Constants.clientId,
      secretKey: Constants.secretKey,
      returnURL: "success.snippetcoder.com",
      cancelURL: "cancel.snippetcoder.com",
      transactions: const [
        {
          "amount": {
            "total": '70',
            "currency": "USD",
            "details": {
              "subtotal": '70',
              "shipping": '0',
              "shipping_discount": 0
            }
          },
          "description": "The payment transaction description.",
          // "payment_options": {
          //   "allowed_payment_method":
          //       "INSTANT_FUNDING_SOURCE"
          // },
          "item_list": {
            "items": [
              {"name": "Apple", "quantity": 4, "price": '5', "currency": "USD"},
              {
                "name": "Pineapple",
                "quantity": 5,
                "price": '10',
                "currency": "USD"
              }
            ],

            // shipping address is not required though
            //   "shipping_address": {
            //     "recipient_name": "Raman Singh",
            //     "line1": "Delhi",
            //     "line2": "",
            //     "city": "Delhi",
            //     "country_code": "IN",
            //     "postal_code": "11001",
            //     "phone": "+00000000",
            //     "state": "Texas"
            //  },
          }
        }
      ],
      note: "Contact us for any questions on your order.",
      onSuccess: (Map params) async {
        print("onSuccess: $params");
      },
      onError: (error) {
        print("onError: $error");
        Navigator.pop(context);
      },
      onCancel: () {
        print('cancelled:');
      },
    );
  }
}
