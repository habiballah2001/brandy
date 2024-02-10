import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../utils/local_storage/cache_helper.dart';
import '../../models/category_model.dart';
import '../../view/cart/cart_screen.dart';
import '../../view/categories/categories_screen.dart';
import '../../view/home/HomeScreen.dart';
import '../../view/setting/setting_screen.dart';
import '../../utils/app_locale.dart';
import 'paths.dart';
import 'strings.dart';

//include variables
class Constants {
  static User? user;
  static File? imageFile;
  static String appLang = CacheHelper.getData(key: 'lang') ?? '';

  static String image =
      'https://image.freepik.com/free-photo/skeptical-woman-has-unsure-questioned-expression-points-fingers-sideways_273609-40770.jpg';
  static const String productImageUrl =
      'https://i.ibb.co/8r1Ny2n/20-Nike-Air-Force-1-07.png';

  static String clientId =
      "AWiapXSc5You5Y8g31w4PDafDGT3QrlYzc1AnIYtAnyfSm6yCpxMMMimsAX4C4V3LdpoCwivgX6bRvgv";
  static String secretKey =
      "EGeUhKj5BjNjldw8vIpzYUUidAkqRzVkojhO3oudAWZrgmUiyKlD4mMCskNIFM8ExRoBygnWhgiQTCiD";
}

class Lists {
  static List<String> titles(context) => [
        LocaleKeys.home.tr(context),
        LocaleKeys.categories.tr(context),
        LocaleKeys.cart.tr(context),
        LocaleKeys.settings.tr(context),
      ];
  static List<Widget> screens = [
    const HomeScreen(),
    const CategoriesScreen(),
    const CartScreen(),
    const SettingScreen(),
  ];
  static List<CategoryModel> categoriesList({required BuildContext context}) =>
      [
        CategoryModel(
          id: LocaleKeys.phones.tr(context),
          img: AppImages.mobiles,
          title: LocaleKeys.phones.tr(context),
        ),
        CategoryModel(
          id: LocaleKeys.laptops.tr(context),
          img: AppImages.pc,
          title: LocaleKeys.laptops.tr(context),
        ),
        CategoryModel(
          id: LocaleKeys.electronics.tr(context),
          img: AppImages.electronics,
          title: LocaleKeys.electronics.tr(context),
        ),
        CategoryModel(
          id: LocaleKeys.watches.tr(context),
          img: AppImages.watch,
          title: LocaleKeys.watches.tr(context),
        ),
        CategoryModel(
          id: LocaleKeys.clothes.tr(context),
          img: AppImages.fashion,
          title: LocaleKeys.clothes.tr(context),
        ),
        CategoryModel(
          id: LocaleKeys.shoes.tr(context),
          img: AppImages.shoes,
          title: LocaleKeys.shoes.tr(context),
        ),
        CategoryModel(
          id: LocaleKeys.books.tr(context),
          img: AppImages.book,
          title: LocaleKeys.books.tr(context),
        ),
        CategoryModel(
          id: LocaleKeys.cosmetics.tr(context),
          img: AppImages.cosmetics,
          title: LocaleKeys.cosmetics.tr(context),
        ),
      ];
  static List<BottomNavigationBarItem> bottomItems({
    required String badgeText,
    required bool cartBadge,
    required BuildContext context,
  }) =>
      [
        BottomNavigationBarItem(
          icon: const Icon(Icons.home),
          label: LocaleKeys.home.tr(context),
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.category),
          label: LocaleKeys.categories.tr(context),
        ),
        BottomNavigationBarItem(
          icon: cartBadge
              ? Badge(
                  label: Text(badgeText),
                  child: const Icon(
                    Icons.shopping_bag,
                  ),
                )
              : const Icon(
                  Icons.shopping_bag,
                ),
          label: LocaleKeys.cart.tr(context),
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.settings),
          label: LocaleKeys.settings.tr(context),
        ),
      ];
}
