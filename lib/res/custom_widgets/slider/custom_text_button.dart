import 'package:flutter/material.dart';

import '../custom_texts.dart';

class CustomTextButton extends StatelessWidget {
  const CustomTextButton(
      {super.key, required this.text, this.icon, required this.function});

  final String text;
  final IconData? icon;
  final Function() function;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: function,
      child: Row(
        children: [
          TitleMediumText(text),
          if (icon != null) Icon(icon),
        ],
      ),
    );
  }
}
