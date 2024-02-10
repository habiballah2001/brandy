import 'package:flutter/material.dart';
import '../components/components.dart';
import '../styles/colors.dart';
import 'custom_container.dart';
import 'custom_texts.dart';

class CustomButton extends StatefulWidget {
  final double? width;
  final double height;
  final Color? color;
  final Color? textColor;
  final bool isUpperCase;
  final double? radius;
  final Function()? function;
  final String title;
  final IconData? icon;
  final bool load;
  const CustomButton({
    super.key,
    this.width,
    this.height = 50,
    this.color = secColor,
    this.textColor = Colors.white,
    this.isUpperCase = false,
    this.radius = 0,
    this.function,
    required this.title,
    this.icon,
    this.load = false,
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      function: widget.function,
      color: widget.color,
      padding: 8,
      margin: const EdgeInsets.all(8),
      radius: BorderRadius.circular(10),
      width: widget.width,
      height: widget.height,
      child: widget.load
          ? Center(
              child: SizedBox(
                width: widget.height - 15,
                height: widget.height - 15,
                child: const CircularProgressIndicator(),
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TitleMediumText(
                  widget.isUpperCase
                      ? widget.title.toUpperCase()
                      : widget.title,
                  color: widget.textColor,
                ),
                if (widget.icon != null) ...[
                  const SpaceWidth(),
                  Icon(
                    widget.icon,
                    color: Colors.white,
                  ),
                ],
              ],
            ),
    );
  }
}
