import 'package:flutter/material.dart';
import '../../../res/custom_widgets/custom_icon_button.dart';
import '../../../view_model/cart_provider.dart';
import '../../../view_model/home_provider.dart';
import '../../../models/cart_model.dart';
import '../../../models/product_model.dart';
import '../../../res/components/components.dart';
import '../../../res/custom_widgets/cached_image.dart';
import '../../../res/custom_widgets/custom_card.dart';
import '../../../res/custom_widgets/custom_outlined_button.dart';
import '../../../res/custom_widgets/custom_texts.dart';
import '../quantity_widget.dart';
import '../skeletons/cart_item_skeleton.dart';

class CartProduct extends StatelessWidget {
  final CartModel cartModel;
  const CartProduct({
    super.key,
    required this.cartModel,
  });

  @override
  Widget build(BuildContext context) {
    const double height = 100;
    HomeProvider homeProvider = HomeProvider.get(context);
    CartProvider cartProvider = CartProvider.get(context);

    ProductModel? cartProduct =
        homeProvider.getProductById(productId: cartModel.productId!);
    return cartProduct == null
        ? const CartItemSkeleton()
        : CustomCard(
            height: height,
            child: Row(
              children: [
                CustomCachedImage(
                  height: height,
                  width: 100,
                  img: cartProduct.image,
                ),
                const SpaceWidth(),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TitleMediumText(
                        cartProduct.title.toString(),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: BodyMediumText(
                              'EGP ${cartProduct.price}',
                              overFlow: TextOverflow.ellipsis,
                            ),
                          ),
                          //const Spacer(),
                          CustomIconButton(
                            icon: Icons.leave_bags_at_home,
                            function: () {
                              cartProvider.removeFromCart(
                                productId: cartModel.productId!,
                                context: context,
                              );
                            },
                          ),
                          CustomOutlinedButton(
                            function: () async {
                              showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  return QuantityList(
                                    cartModel: cartModel,
                                  );
                                },
                              );
                            },
                            title: cartModel.quantity.toString(),
                            trailIcon: Icons.keyboard_arrow_down_sharp,
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
  }
}
