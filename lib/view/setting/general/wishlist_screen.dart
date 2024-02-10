import 'package:brandy/res/constants/strings.dart';
import 'package:brandy/utils/app_locale.dart';
import 'package:flutter/material.dart';
import '../../../res/constants/paths.dart';
import '../../../res/custom_widgets/CustomAppBar.dart';
import '../../../res/custom_widgets/custom_texts.dart';
import '../../../res/custom_widgets/empty_widget.dart';

import '../../../view_model/wishlist_provider.dart';
import '../../../models/wishlist_model.dart';
import '../../../view/widgets/products/wishlist_product.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  @override
  Widget build(BuildContext context) {
    WishlistProvider wishlistProvider = WishlistProvider.get(context);
    return Scaffold(
      appBar: CustomAppBar(
        title: TitleMediumText(LocaleKeys.wishlist.tr(context)),
        actions: [
          IconButton(
            onPressed: () {
              if (wishlistProvider.getWishlistMap.isNotEmpty) {
                wishlistProvider.clearWishlist(context);
              }
            },
            icon: const Icon(Icons.delete),
          )
        ],
      ),
      body: wishlistProvider.getWishlistMap.isNotEmpty
          ? ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: wishlistProvider.getWishlistMap.length,
              itemBuilder: (context, index) {
                WishlistModel item = wishlistProvider.getWishlistMap.values
                    .toList()
                    .reversed
                    .toList()[index];
                return WishlistItem(
                  wishlistModel: item,
                );
              },
            )
          : Column(
              children: [
                EmptyWidget(
                  svg: AppImages.bagWish,
                ),
              ],
            ),
    );
  }
}
