import 'package:flutter/material.dart';
import '../../../res/custom_widgets/skeleton.dart';

import '../../../res/components/components.dart';
import '../../../res/custom_widgets/custom_card.dart';

class CartItemSkeleton extends StatelessWidget {
  final double? width;
  const CartItemSkeleton({
    super.key,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    const double height = 100;
    return CustomCard(
      height: height,
      width: width,
      child: const Row(
        children: [
          Skeleton(
            width: 100,
            height: height,
          ),
          SpaceWidth(),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  children: [
                    Skeleton(
                      width: 80,
                    ),
                    Spacer(),
                    Skeleton(
                      width: 30,
                      height: 30,
                      margin: 10,
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Skeleton(
                      width: 40,
                    ),
                    Spacer(),
                    Skeleton(
                      width: 60,
                      padding: 5,
                      height: 20,
                      margin: 5,
                    )
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
