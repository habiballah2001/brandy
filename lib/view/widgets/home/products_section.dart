import 'package:brandy/res/constants/strings.dart';
import 'package:brandy/utils/app_locale.dart';
import 'package:flutter/material.dart';

import '../../../models/product_model.dart';
import '../../../view_model/home_provider.dart';
import '../../../res/components/components.dart';
import '../../../res/custom_widgets/custom_texts.dart';
import '../products/product_item.dart';

class ProductsSection extends StatelessWidget {
  const ProductsSection({super.key});

  @override
  Widget build(BuildContext context) {
    HomeProvider homeProvider = HomeProvider.get(context);

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeadSmallText(
            LocaleKeys.products.tr(context),
          ),
          const SpaceHeight(
            height: 5,
          ),
          FutureBuilder<List<ProductModel>>(
            future: homeProvider.fetchProducts(),
            builder: (context, snapshot) {
              return GridView.count(
                mainAxisSpacing: 2,
                crossAxisSpacing: 1,
                childAspectRatio: 1 / 1.5,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                crossAxisCount: 2,
                children: List.generate(
                  homeProvider.getProducts.length,
                  (index) => ProductItem(
                    product: homeProvider.getProducts[index],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
/*          FutureBuilder<List<ProductModel>>(
            future: homeProvider.fetchProducts(),
            builder: (context, snapshot) {
              return GridView.count(
                mainAxisSpacing: 2,
                crossAxisSpacing: 1,
                childAspectRatio: 1 / 1.4,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                crossAxisCount: 2,
                children: List.generate(
                  homeProvider.getProducts.length,
                  (index) => ProductItem(
                    product: homeProvider.getProducts[index],
                  ),
                ),
              );
            },
          ),
*/
