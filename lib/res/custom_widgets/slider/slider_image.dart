import 'package:flutter/material.dart';

import '../custom_card.dart';
class SliderImage extends StatelessWidget {
  const SliderImage({super.key, required this.image});

  final String image;
  @override
  Widget build(BuildContext context) {
    return CustomCard(
      radius: 10,
      child: Image(
        image: AssetImage(image),
        fit: BoxFit.cover,
        width: double.infinity,
      ),
    );

  }
}
