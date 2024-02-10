import 'package:flutter/material.dart';
import '../../../res/components/components.dart';
import '../../../res/custom_widgets/skeleton.dart';

import '../../../res/custom_widgets/custom_card.dart';

class ProductCardSkeleton extends StatelessWidget {
  const ProductCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Skeleton(
            height: 150,
            width: double.infinity,
          ),
          Padding(
            padding: EdgeInsets.all(5.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Skeleton(
                  width: 100,
                ),
                SpaceHeight(
                  height: 5,
                ),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Skeleton(
                          width: 50,
                        ),
                        SpaceHeight(
                          height: 4,
                        ),
                        Skeleton(
                          width: 20,
                        ),
                      ],
                    ),
                    Spacer(),
                    Skeleton(
                      width: 30,
                      height: 30,
                      margin: 2,
                    ),
                    Skeleton(
                      width: 30,
                      height: 30,
                      margin: 2,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
