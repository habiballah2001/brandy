import 'package:flutter/material.dart';

import 'custom_texts.dart';

class PlusMinusButtons extends StatelessWidget {
  final VoidCallback removeQuantity;
  final VoidCallback delete;
  final VoidCallback addQuantity;
  final String text;
  const PlusMinusButtons(
      {super.key,
      required this.addQuantity,
      required this.removeQuantity,
      required this.text,
      required this.delete});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          int.parse(text) > 1
              ? InkWell(
                  onTap: removeQuantity,
                  child: const Icon(Icons.remove),
                )
              : InkWell(
                  onTap: delete,
                  child: const Icon(Icons.leave_bags_at_home),
                ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: TitleMediumText(text),
          ),
          InkWell(
            onTap: addQuantity,
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
