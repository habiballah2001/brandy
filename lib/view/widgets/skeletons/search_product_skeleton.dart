import 'package:flutter/material.dart';
import '../../../res/custom_widgets/skeleton.dart';
import '../../../res/custom_widgets/custom_card.dart';

class SearchProductSkeleton extends StatelessWidget {
  const SearchProductSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const CustomCard(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Skeleton(
            height: 100,
            width: 100,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Skeleton(),
                  Row(
                    children: [
                      Skeleton(),
                      Skeleton(),
                      Spacer(),
                      InkWell(
                        child: CircleAvatar(
                          radius: 15,
                          backgroundColor: Colors.grey,
                          child: Skeleton(),
                        ),
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
