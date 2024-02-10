import 'package:flutter/material.dart';
import '../../../res/custom_widgets/custom_card.dart';
import '../../../res/custom_widgets/custom_texts.dart';

import '../../../res/custom_widgets/cached_image.dart';

class FavoritesProduct extends StatelessWidget {
  const FavoritesProduct({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomCachedImage(
                img: '',
                height: 150,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const TitleSmallText(
                        'product!.name!',
                        maxLines: 2,
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          const BodyLargeText(
                            '500 LE',
                            maxLines: 1,
                          ),
                          const SizedBox(
                            width: 3,
                          ),
                          Text(
                            '10',
                            textAlign: TextAlign.end,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 9,
                                decoration: TextDecoration.lineThrough),
                          ),
                          const Spacer(),
                          IconButton(
                            icon: const Icon(
                              Icons.favorite,
                              size: 24,
                              color: Colors.red,
                            ),
                            onPressed: () {},
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            color: Colors.red,
            child: const Text(
              'DISCOUNT%',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
