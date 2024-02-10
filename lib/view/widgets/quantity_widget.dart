import 'dart:developer';

import 'package:flutter/material.dart';
import '../../../res/custom_widgets/custom_container.dart';

import '../../view_model/cart_provider.dart';
import '../../models/cart_model.dart';
import '../../utils/utils.dart';
import '../../res/custom_widgets/custom_texts.dart';

class QuantityList extends StatefulWidget {
  final CartModel cartModel;
  const QuantityList({
    super.key,
    required this.cartModel,
  });

  @override
  State<QuantityList> createState() => _QuantityListState();
}

class _QuantityListState extends State<QuantityList> {
  @override
  Widget build(BuildContext context) {
    CartProvider cartProvider = CartProvider.get(context);

    return CustomContainer(
      radius: const BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
      child: ListView.builder(
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              log('${index + 1}');
              cartProvider.updateQuantity(
                cartId: widget.cartModel.cartId!,
                productId: widget.cartModel.productId!,
                quantity: index + 1,
              );
              setState(() {});
              Utils.popNavigate(context);
            },
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TitleLargeText('${index + 1}'),
              ),
            ),
          );
        },
        itemCount: 20,
      ),
    );
  }
}
