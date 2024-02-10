import 'package:brandy/res/constants/strings.dart';
import 'package:brandy/utils/app_locale.dart';
import 'package:brandy/view_model/home_provider.dart';
import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import '../../view_model/cart_provider.dart';
import '../../view_model/wishlist_provider.dart';
import '../../models/product_model.dart';
import '../../res/components/components.dart';
import '../../res/custom_widgets/CustomAppBar.dart';
import '../../res/custom_widgets/cached_image.dart';
import '../../res/custom_widgets/custom_button.dart';
import '../../res/custom_widgets/custom_card.dart';
import '../../res/custom_widgets/custom_container.dart';
import '../../res/custom_widgets/custom_icon_button.dart';
import '../../res/custom_widgets/custom_texts.dart';
import '../../res/styles/colors.dart';

class ProductDetailsScreen extends StatelessWidget {
  final ProductModel product;
  const ProductDetailsScreen({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    CartProvider cartProvider = CartProvider.get(context);
    WishlistProvider wishlistProvider = WishlistProvider.get(context);
    HomeProvider homeProvider = HomeProvider.get(context);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: CustomAppBar(
        title: TitleLargeText(
          LocaleKeys.details.tr(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: CustomContainer(
              width: double.infinity,
              child: Column(
                children: [
                  Expanded(
                    child: ModelViewer(
                      src: homeProvider.getModelsList[0],
                      alt: "A 3D model of an astronaut",
                      ar: true,
                      autoRotate: true,
                      cameraControls: true,
                    ),
                  ),
                  Expanded(
                    child: CircleAvatar(
                      backgroundColor: secColor,
                      radius: size.width * .44,
                      child: CustomCachedImage(
                        img: product.image,
                        width: 200,
                        radius: 30,
                        //fit: null,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: CustomCard(
              radius: 30,
              padding: 8,
              margin: const EdgeInsets.all(10),
              //color: LightColors.bgColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SpaceHeight(),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: HeadSmallText(
                      product.title,
                    ),
                  ),
                  HeadSmallText(
                    product.price.toString(),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: Container(
                      height: size.height * .24,
                      padding: const EdgeInsets.all(10),
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          children: [
                            Text(product.productId),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.grey.shade200,
                        radius: 25,
                        child: CustomIconButton(
                          function: () {
                            if (!wishlistProvider.inWishlist(
                                productId: product.productId)) {
                              wishlistProvider.addToWishlistFirebase(
                                productId: product.productId,
                                context: context,
                              );
                            }
                          },
                          icon: Icons.favorite,
                          iconColor: wishlistProvider.inWishlist(
                            productId: product.productId,
                          )
                              ? Colors.red
                              : Colors.grey,
                        ),
                      ),
                      if (product.quantity > 0) ...[
                        Expanded(
                          child: CustomButton(
                            width: double.infinity,
                            height: 50,
                            radius: 30,
                            function: () {
                              if (cartProvider.inCart(
                                      productId: product.productId) ==
                                  false) {
                                cartProvider.addToCartFirebase(
                                  productId: product.productId,
                                  quantity: 1,
                                  context: context,
                                );
                              }
                            },
                            icon: Icons.shopping_bag,
                            title: !cartProvider.inCart(
                                    productId: product.productId)
                                ? LocaleKeys.addToCart.tr(context)
                                : LocaleKeys.inCart.tr(context),
                          ),
                        ),
                      ] else ...[
                        Expanded(
                          child: Center(
                            child: TitleLargeText(
                              LocaleKeys.outOfStock.tr(context),
                              color: Colors.red,
                            ),
                          ),
                        )
                      ]
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
