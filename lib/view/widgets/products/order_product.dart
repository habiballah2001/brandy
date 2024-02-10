import 'package:brandy/res/constants/strings.dart';
import 'package:brandy/utils/app_locale.dart';
import 'package:flutter/material.dart';
import '../../../view_model/home_provider.dart';
import '../../../res/components/components.dart';
import '../../../res/custom_widgets/cached_image.dart';
import '../../../models/product_model.dart';
import '../../../res/custom_widgets/custom_card.dart';
import '../../../res/custom_widgets/custom_texts.dart';

class OrderProduct extends StatelessWidget {
  final String productId;
  final String quantity;
  const OrderProduct({
    super.key,
    required this.productId,
    required this.quantity,
  });
  @override
  Widget build(BuildContext context) {
    final ProductModel? orderProduct =
        HomeProvider.get(context).getProductById(productId: productId);

    return CustomCard(
      radius: 20,
      child: Row(
        children: [
          CustomCachedImage(
            img: orderProduct!.image,
            height: 80,
            width: 100,
          ),
          const SpaceWidth(),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BodyLargeText(
                  orderProduct.price.toString(),
                  overFlow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                if (orderProduct.discount > 0)
                  Text(
                    orderProduct.oldPrice.toString(),
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
          const Spacer(),
          BodyLargeText('${LocaleKeys.quantity.tr(context)}:'),
          BodyLargeText(quantity),
          const SpaceWidth(),
        ],
      ),
    );
  }
}
