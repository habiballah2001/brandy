import 'package:flutter/material.dart';
import '../styles/colors.dart';
import 'custom_texts.dart';

class MySearchBar extends StatelessWidget {
  const MySearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Row(
      children: [
        InkWell(
          onTap: () {},
          child: Container(
            width: size.width * .849,
            margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color:  secColor,
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(13.0),
                bottomLeft: Radius.circular(13.0),
                topLeft: Radius.circular(13.0),
                topRight: Radius.circular(13.0),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: size.height*.02,
                    child:  const Icon(
                      Icons.search,
                  color:  primaryColor,
                )),
                const VerticalDivider(),
                const BodyMediumText(
                   'Search here',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
