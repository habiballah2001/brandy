import 'package:brandy/res/constants/strings.dart';
import 'package:brandy/utils/app_locale.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../components/components.dart';
import 'custom_button.dart';
import 'custom_texts.dart';

class EmptyWidget extends StatelessWidget {
  final String? title;
  final String? buttonText;
  final bool? showButton;
  final String? body;
  final String? svg;
  //final String? svg;
  final IconData? icon;
  final bool withExpanded;
  final Function()? buttonFunction;
  const EmptyWidget({
    super.key,
    this.title,
    this.buttonText,
    this.showButton = false,
    this.body,
    this.svg,
    this.buttonFunction,
    //this.svg,
    this.icon,
    this.withExpanded = true,
  });

  @override
  Widget build(BuildContext context) {
    return withExpanded == true
        ? Expanded(
            child: FittedBox(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (svg != null)
                      SvgPicture.asset(
                        svg!,
                      ),
                    if (icon != null)
                      Icon(
                        icon,
                        size: 300,
                      ),
                    TitleLargeText(title ?? LocaleKeys.empty.tr(context)),
                    if (body != null) BodyLargeText(body!),
                    if (showButton == true) ...[
                      const SpaceHeight(),
                      CustomButton(
                        function: buttonFunction,
                        title: buttonText ?? LocaleKeys.shopNow.tr(context),
                      )
                    ]
                  ],
                ),
              ),
            ),
          )
        : FittedBox(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (svg != null)
                    SvgPicture.asset(
                      svg!,
                    ),
                  if (icon != null)
                    Icon(
                      icon,
                      size: 300,
                    ),
                  TitleLargeText(title ?? LocaleKeys.empty.tr(context)),
                  if (body != null) BodyLargeText(body!),
                  if (showButton == true) ...[
                    const SpaceHeight(),
                    CustomButton(
                      function: buttonFunction,
                      title: buttonText ?? LocaleKeys.shopNow.tr(context),
                    )
                  ]
                ],
              ),
            ),
          );
  }
}
