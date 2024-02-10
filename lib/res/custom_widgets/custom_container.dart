import 'package:flutter/material.dart';

class CustomContainer extends StatelessWidget {
  final double? padding;
  final EdgeInsetsGeometry? margin;
  final Widget child;
  final BorderRadiusGeometry? radius;
  final double? height;
  final double? width;
  final Color? color;
  final List<BoxShadow>? boxShadow;
  final BoxBorder? boxBorder;
  final Function()? function;
  const CustomContainer({
    super.key,
    this.padding = 0,
    required this.child,
    this.radius,
    this.height,
    this.width,
    this.color,
    this.margin,
    this.boxShadow,
    this.boxBorder,
    this.function,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: EdgeInsets.all(padding!),
      height: height,
      width: width,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      decoration: BoxDecoration(
        border: boxBorder,
        borderRadius: radius,
        color: color,
        boxShadow: boxShadow,
      ),
      child: InkWell(onTap: function, child: child),
    );
  }
}
