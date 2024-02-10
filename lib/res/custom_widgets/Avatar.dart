
// ignore_for_file: file_names

import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {
  final Color aroundColor;
  final Color? bgColor;
  final double radius;
  final Function()? onTab;
  final Widget? child;
  final dynamic image;
  final bool around;

  const Avatar({
    super.key,
    this.aroundColor = Colors.green,
    this.onTab,
    required this.radius,
    this.child,
    this.image,
    this.around = true,
    this.bgColor = Colors.grey,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTab,
      child: around
          ? CircleAvatar(
              radius: radius + 4.5,
              backgroundColor: aroundColor,
              child: CircleAvatar(
                radius:  radius+2,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                child: CircleAvatar(
                  radius: radius,
                  backgroundColor: bgColor,
                  backgroundImage: image,
                  child: child,
                ),
              ),
            )
          : CircleAvatar(
              radius: radius,
              backgroundColor: Colors.white,
              backgroundImage: image,
              child: child,
            ),
    );
  }
}
