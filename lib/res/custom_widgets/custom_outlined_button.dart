import 'package:flutter/material.dart';
import '../components/components.dart';
import '../styles/colors.dart';
import 'custom_texts.dart';

class CustomOutlinedButton extends StatelessWidget {
  final Function()? function;
  final String title;
  final double padding;
  final double? height;
  final double? width;
  final double? radius;
  final IconData? trailIcon;
  final IconData? leadIcon;
  final Color? iconColor;
  final Color? textColor;
  final Color borderColor;
  final Color? bgColor;

  const CustomOutlinedButton({
    super.key,
    this.function,
    required this.title,
    this.padding = 0,
    this.height,
    this.radius = 30,
    this.trailIcon,
    this.leadIcon,
    this.iconColor = secColor,
    this.width,
    this.textColor,
    this.borderColor = primaryColor,
    this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: OutlinedButton(
        onPressed: function,
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          padding: EdgeInsets.symmetric(horizontal: padding),
          backgroundColor: bgColor,
          side: BorderSide(color: borderColor, width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius!),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (leadIcon != null) ...[
              Row(
                children: [
                  Icon(
                    leadIcon,
                    color: iconColor,
                  ),
                  const SpaceWidth(),
                ],
              ),
            ],
            TitleLargeText(
              title,
              color: textColor,
            ),
            if (trailIcon != null) ...[
              const SpaceWidth(),
              Row(
                children: [
                  Icon(
                    trailIcon,
                    color: iconColor,
                  ),
                ],
              ),
            ]
          ],
        ),
      ),
    );
  }
}
