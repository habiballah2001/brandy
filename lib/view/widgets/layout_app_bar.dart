import 'package:brandy/res/constants/strings.dart';
import 'package:brandy/utils/app_locale.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shimmer/shimmer.dart';
import '../../view_model/home_provider.dart';
import '../../view_model/cart_provider.dart';
import '../../res/constants/paths.dart';
import '../../res/constants/constants.dart';
import '../../utils/dialogs.dart';
import '../../utils/utils.dart';
import '../../res/custom_widgets/custom_texts.dart';
import '../../res/styles/colors.dart';

class LayoutAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? leading;
  final Widget? title;
  final bool? centerTitle;
  final bool automaticallyImplyLeading;
  final List<Widget>? actions;
  final PreferredSizeWidget? bottom;
  final Color? color;
  const LayoutAppBar({
    super.key,
    this.leading,
    this.title,
    this.centerTitle,
    this.automaticallyImplyLeading = true,
    this.actions,
    this.bottom,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    /// This part is copied from AppBar class

    CartProvider cartProvider = CartProvider.get(context);
    HomeProvider homeProvider = HomeProvider.get(context);

    Color scaffoldColor = Theme.of(context).scaffoldBackgroundColor;
    return AppBar(
      leading: Padding(
        padding: const EdgeInsets.all(8),
        child: SvgPicture.asset(AppImages.logo),
      ),
      backgroundColor: scaffoldColor,
      title: Shimmer.fromColors(
        period: const Duration(seconds: 8),
        baseColor: secColor,
        highlightColor: thColor,
        child: TitleLargeText(
          Lists.titles(context)[homeProvider.getSelectedTab],
          color:
              homeProvider.getSelectedTab == 0 ? scaffoldColor : primaryColor,
        ),
      ),
      actions: [
        if (homeProvider.getSelectedTab == 2 &&
            cartProvider.getCartMap.isNotEmpty)
          IconButton(
            onPressed: () {
              Dialogs.warningDialog(
                content: LocaleKeys.sureToDelete.tr(context),
                accept: () async {
                  cartProvider.deleteCartData(context).then((value) {
                    Utils.toast(body: LocaleKeys.cartCleared.tr(context));
                  });
                },
                context: context,
              );
            },
            icon: const Icon(
              Icons.delete,
            ),
          ),
      ],
    );
  }

  @override
  Size get preferredSize {
    if (bottom != null) {
      return Size.fromHeight(kToolbarHeight + bottom!.preferredSize.height);
    } else {
      return const Size.fromHeight(kToolbarHeight);
    }
  }
}
