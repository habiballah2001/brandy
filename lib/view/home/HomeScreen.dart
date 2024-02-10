import 'package:brandy/res/constants/strings.dart';
import 'package:brandy/utils/app_locale.dart';
import 'package:flutter/material.dart';
import '../../view_model/home_provider.dart';
import '../../res/components/components.dart';
import '../../res/custom_widgets/cached_image.dart';
import '../../utils/utils.dart';
import '../../res/custom_widgets/custom_search_bar.dart';
import '../../res/custom_widgets/custom_texts.dart';
import '../../res/custom_widgets/slider/custom_carousel_slider.dart';
import '../search/search_screen.dart';
import '../widgets/home/categories_section.dart';
import '../widgets/home/last_arrival_section.dart';
import '../widgets/home/products_section.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    HomeProvider homeProvider = HomeProvider.get(context);
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomSearchBar(
            onTab: () {
              Utils.navigateTo(widget: const SearchScreen(), context: context);
            },
          ),
          const SpaceHeight(),
          SizedBox(
            height: 180,
            width: double.infinity,
            child: CustomCarouselSlider(
              items: homeProvider.getMainBannersList.map((url) {
                return CustomCachedImage(
                  img: url,
                  radius: 10,
                );
              }).toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, top: 20, bottom: 10),
            child: TitleLargeText(
              LocaleKeys.categories.tr(context),
            ),
          ),
          const CategoriesSection(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: HeadSmallText(
              LocaleKeys.latest.tr(context),
            ),
          ),
          const LastArrivalSection(),
          const SpaceHeight(
            height: 20,
          ),
          SizedBox(
            height: 100,
            width: double.infinity,
            child: CustomCarouselSlider(
              items: homeProvider.getSecBannersList.map((url) {
                return CustomCachedImage(
                  img: url,
                  radius: 10,
                );
              }).toList(),
            ),
          ),
          const SpaceHeight(),
          const ProductsSection(),
        ],
      ),
    );
  }
}
