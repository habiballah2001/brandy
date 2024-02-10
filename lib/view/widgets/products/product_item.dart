import 'package:brandy/res/constants/strings.dart';
import 'package:brandy/utils/app_locale.dart';
import 'package:flutter/material.dart';
import '../../../view_model/cart_provider.dart';
import '../../../view_model/recently_viewed.dart';
import '../../../view_model/wishlist_provider.dart';
import '../../../view/home/product_details_screen.dart';
import '../../../res/components/components.dart';
import '../../../res/custom_widgets/custom_texts.dart';
import '../../../models/product_model.dart';
import '../../../res/custom_widgets/cached_image.dart';
import '../../../res/custom_widgets/custom_card.dart';
import '../../../res/custom_widgets/custom_container.dart';
import '../../../res/custom_widgets/custom_icon_button.dart';
import '../../../utils/utils.dart';
import '../not_found_product.dart';

class ProductItem extends StatelessWidget {
  final ProductModel product;
  final Function()? press;
  const ProductItem({
    super.key,
    this.press,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    CartProvider cartProvider = CartProvider.get(context);
    WishlistProvider wishlistProvider = WishlistProvider.get(context);
    RecentlyViewedProvider recentlyViewedProvider =
        RecentlyViewedProvider.get(context);
    return CustomCard(
      function: () {
        recentlyViewedProvider.checkRecently(productId: product.productId);
        Utils.navigateTo(
            widget: ProductDetailsScreen(
              product: product,
            ),
            context: context);
      },
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 5,
                child: CustomCachedImage(
                  img: product.image,
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      BodyLargeText(
                        product.title,
                        maxLines: 2,
                      ),
                      //const Spacer(),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                BodyLargeText(
                                  product.price.toString(),
                                  overFlow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                                if (product.discount > 0)
                                  Text(
                                    product.oldPrice.toString(),
                                    textAlign: TextAlign.end,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 7,
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          //const Spacer(),
                          CustomIconButton(
                            function: () {
                              if (!cartProvider.inCart(
                                      productId: product.productId) &&
                                  product.quantity > 0) {
                                cartProvider.addToCartFirebase(
                                  productId: product.productId,
                                  quantity: 1,
                                  context: context,
                                );
                              }
                            },
                            icon: Icons.shopping_cart_rounded,
                            iconColor: cartProvider.inCart(
                                    productId: product.productId)
                                ? Colors.red
                                : Colors.grey,
                          ),
                          const SpaceWidth(
                            width: 10,
                          ),
                          CustomIconButton(
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
                                    productId: product.productId)
                                ? Colors.red
                                : Colors.grey,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (product.discount > 0)
            Positioned(
              right: 0,
              top: 0,
              child: Banner(
                message: LocaleKeys.discount.tr(context),
                location: BannerLocation.topEnd,
              ),
            ),
          Positioned(
            left: 5,
            top: 5,
            child: CustomContainer(
              padding: 3,
              color: Colors.black45,
              radius: BorderRadius.circular(5),
              child: const Row(
                children: [
                  Text(
                    '5.0',
                    style: TextStyle(color: Colors.white, height: 1),
                  ),
                  Icon(
                    Icons.star,
                    size: 14,
                    color: Colors.yellow,
                  )
                ],
              ),
            ),
          ),
          if (product.quantity == 0) const NotFoundProduct(),
        ],
      ),
    );
  }
}
