import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  final IconData? icon;
  final Color? iconColor;
  final Color? color;
  final VoidCallback? function;
  final double? iconSize;
  final double? width;
  final double? height;
  final double padding;
  final double? elevation;
  final double? radius;
  final BoxBorder? boxBorder;
  const CustomIconButton({
    super.key,
    required this.icon,
    this.iconColor,
    this.color,
    this.function,
    this.iconSize = 22.0,
    this.radius = 20.0,
    this.elevation,
    this.width,
    this.height,
    this.padding = 7,
    this.boxBorder,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: function,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          border: boxBorder,
          borderRadius: BorderRadius.circular(radius!),
          color: color,
        ),
        padding: EdgeInsets.all(
          padding,
        ),
        child: Icon(
          icon,
          color: iconColor,
          size: iconSize,
        ),
      ),
    );
  }
}
