import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../res/custom_widgets/custom_container.dart';
import '../../res/custom_widgets/skeleton.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../res/constants//paths.dart';

class CustomCachedImage extends StatelessWidget {
  final String img;
  final double? height;
  final double? width;
  final double radius;
  final BoxFit? fit;
  const CustomCachedImage({
    super.key,
    required this.img,
    this.height,
    this.width = double.infinity,
    this.fit = BoxFit.cover,
    this.radius = 0,
  });

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      radius: BorderRadius.circular(radius),
      child: CachedNetworkImage(
        imageUrl: img,
        height: height,
        width: width,
        fit: fit,
        progressIndicatorBuilder: (context, url, progress) =>
            const Center(child: Skeleton()),
        errorWidget: (context, url, error) => Center(
          child: SvgPicture.asset(
            AppImages.error,
          ),
        ),
      ),
    );
  }
}
