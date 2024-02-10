import 'package:brandy/res/constants/strings.dart';
import 'package:brandy/utils/app_locale.dart';
import 'package:flutter/material.dart';
import '../../res/components/components.dart';
import '../../res/custom_widgets/CustomAppBar.dart';
import '../../res/custom_widgets/custom_button.dart';
import '../../res/custom_widgets/custom_text_field.dart';
import '../../res/custom_widgets/custom_texts.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../res/constants/paths.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  late final TextEditingController controller;
  @override
  void initState() {
    controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: TitleMediumText(LocaleKeys.rePassword.tr(context)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: SvgPicture.asset(
                AppImages.forgotPassword,
                height: 300,
              ),
            ),
            TitleLargeText(LocaleKeys.forgotPassword.tr(context)),
            BodyLargeText(LocaleKeys.verification.tr(context)),
            const SpaceHeight(),
            CustomTextField(
              controller: controller,
              type: TextInputType.text,
              validate: (p0) {
                if (p0!.isEmpty) {
                  return LocaleKeys.validText.tr(context);
                }
                return null;
              },
              hint: 'example@gmail.com',
            ),
            const SpaceHeight(
              height: 20,
            ),
            CustomButton(
              height: 40,
              width: double.infinity,
              radius: 10,
              title: LocaleKeys.submit.tr(context),
              function: () {},
            ),
          ],
        ),
      ),
    );
  }
}
