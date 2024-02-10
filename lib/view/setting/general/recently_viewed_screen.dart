import 'package:brandy/res/constants/strings.dart';
import 'package:brandy/utils/app_locale.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../view_model/recently_viewed.dart';
import '../../../res/constants/paths.dart';
import '../../../res/custom_widgets/CustomAppBar.dart';
import '../../../res/custom_widgets/custom_texts.dart';
import '../../../res/custom_widgets/empty_widget.dart';
import '../../../view/widgets/products/recently_viewed_product.dart';

class RecentlyViewedScreen extends StatelessWidget {
  const RecentlyViewedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    RecentlyViewedProvider recentlyViewedProvider =
        Provider.of<RecentlyViewedProvider>(context);

    return Scaffold(
      appBar: CustomAppBar(
        title: TitleMediumText(LocaleKeys.recently.tr(context)),
      ),
      body: recentlyViewedProvider.getRecentlyViewedItems.isNotEmpty
          ? ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: recentlyViewedProvider.getRecentlyViewedItems.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(5),
                  child: RecentlyViewedProduct(
                    recentlyViewedModel: recentlyViewedProvider
                        .getRecentlyViewedItems.values
                        .toList()
                        .reversed
                        .toList()[index],
                  ),
                );
              },
            )
          : Column(
              children: [
                EmptyWidget(
                  svg: AppImages.recent,
                ),
              ],
            ),
    );
  }
}
