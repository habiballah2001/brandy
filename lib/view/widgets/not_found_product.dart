import 'package:brandy/res/constants/strings.dart';
import 'package:brandy/utils/app_locale.dart';
import 'package:flutter/material.dart';

import '../../res/custom_widgets/custom_texts.dart';

class NotFoundProduct extends StatelessWidget {
  const NotFoundProduct({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.7),
      child: Center(
          child: TitleMediumText(
        LocaleKeys.outOfStock.tr(context),
        color: Colors.red,
      )),
    );
  }
}
