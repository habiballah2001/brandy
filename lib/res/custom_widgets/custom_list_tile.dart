import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../components/components.dart';
import 'custom_container.dart';
import 'custom_texts.dart';

class CustomListTile extends StatelessWidget {
  final IconData? leadingIcon;
  final String? leadingSvg;
  final IconData trailIcon;
  final double? iconSize;
  final String title;
  final Color? color;
  final Function() function;
  const CustomListTile({
    super.key,
    this.leadingIcon,
    this.leadingSvg,
    this.trailIcon = Icons.arrow_forward_ios,
    this.iconSize = 14,
    required this.title,
    required this.function,
    this.color = Colors.transparent,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: function,
      child: CustomContainer(
        padding: 4,
        color: color,
        height: 45,
        child: Row(
          children: [
            if (leadingIcon != null)
              Icon(
                leadingIcon,
                size: iconSize,
              ),
            if (leadingSvg != null)
              SvgPicture.asset(
                leadingSvg!,
                width: 60,
              ),
            const SpaceWidth(width: 10),
            BodyLargeText(
              title,
            ),
            const Spacer(),
            Icon(
              trailIcon,
              size: iconSize,
            ),
          ],
        ),
      ),
    );
  }
}
