import 'package:flutter/material.dart';

import '../../../res/custom_widgets/custom_card.dart';
import '../../../res/custom_widgets/skeleton.dart';

class OrderProductSkeleton extends StatelessWidget {
  const OrderProductSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    const double height = 100;

    return const CustomCard(
      height: height,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Skeleton(
            height: height,
            width: 100,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Skeleton(
                    width: 100,
                  ),
                  //Spacer(),
                  Row(
                    children: [
                      Skeleton(
                        width: 50,
                      ),
                      Spacer(),
                      Skeleton(
                        height: 30,
                        width: 30,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
