import 'dart:developer';
import 'package:brandy/res/constants/strings.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/app_locale.dart';
import '../../view_model/theme_provider.dart';
import '../../view_model/user_provider.dart';
import '../../res/components/components.dart';
import '../../res/constants/constants.dart';
import '../../res/constants/paths.dart';
import '../../res/custom_widgets/custom_texts.dart';
import '../../res/custom_widgets/load.dart';
import '../../utils/dialogs.dart';
import '../../res/custom_widgets/custom_button.dart';
import '../../res/custom_widgets/custom_list_tile.dart';
import '../../utils/utils.dart';
import '../../res/styles/colors.dart';
import '../auth/login_screen.dart';
import '../auth/register_screen.dart';
import '../orders/orders_screen.dart';
import 'general/address_screen.dart';
import 'general/recently_viewed_screen.dart';
import 'general/wishlist_screen.dart';
import 'other/edit_profile.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  bool _isLoading = true;

  Future<void> fetchUserInfo() async {
    final userProvider = UserProvider.get(context, listen: false);

    if (Constants.user != null) {
      try {
        await userProvider.fetchUserData();
      } catch (error) {
        if (!context.mounted) return;
        Dialogs.errorDialog(
          context: context,
          content: "An error has been occurred : $error",
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> logOut() async {
    UserProvider userProvider = UserProvider.get(context, listen: false);
    setState(() {
      _isLoading;
    });
    if (Constants.user != null) {
      await userProvider.logOut(context).then((value) {
        fetchUserInfo();
        setState(() {
          _isLoading = false;
        });
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      log('no user :$User found');
    }
  }

  @override
  void initState() {
    fetchUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = UserProvider.get(context);
    //User? user = FirebaseAuth.instance.currentUser;
    super.build(context);
    return LoadingManager(
      isLoading: _isLoading,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (Constants.user != null)
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TitleMediumText(Constants.user!.displayName!),
                      BodyLargeText(Constants.user!.email!)
                    ],
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      Utils.navigateTo(
                        widget: EditProfile(
                          userModel: userProvider.getUserModel!,
                        ),
                        context: context,
                      );
                    },
                    icon: const Icon(Icons.edit),
                  )
                ],
              ),
            const Divider(),
            if (FirebaseAuth.instance.currentUser != null)
              Column(
                children: [
                  TitleMediumText(LocaleKeys.general.tr(context)),
                  const SpaceHeight(),
                  CustomListTile(
                    leadingSvg: AppImages.recent,
                    title: LocaleKeys.viewedRecently.tr(context),
                    function: () {
                      Utils.navigateTo(
                          widget: const RecentlyViewedScreen(),
                          context: context);
                    },
                  ),
                  CustomListTile(
                    leadingSvg: AppImages.order,
                    title: LocaleKeys.orders.tr(context),
                    function: () {
                      Utils.navigateTo(
                          widget: const OrdersScreen(), context: context);
                    },
                  ),
                  CustomListTile(
                    leadingSvg: AppImages.wishlist,
                    title: LocaleKeys.wishlist.tr(context),
                    function: () {
                      Utils.navigateTo(
                          widget: const WishlistScreen(), context: context);
                    },
                  ),
                  CustomListTile(
                    leadingSvg: AppImages.address,
                    title: LocaleKeys.address.tr(context),
                    function: () {
                      Utils.navigateTo(
                          widget: const AddressesScreen(), context: context);
                    },
                  ),
                  const Divider(),
                ],
              ),
            TitleMediumText(LocaleKeys.theme.tr(context)),
            const SpaceHeight(),
            Consumer<ThemeProvider>(
              builder: (context, provider, child) => SwitchListTile(
                title: provider.getIsDark
                    ? TitleMediumText(LocaleKeys.dark.tr(context))
                    : TitleMediumText(LocaleKeys.light.tr(context)),
                value: provider.getIsDark,
                onChanged: (value) {
                  provider.setDark(darkValue: value);
                },
              ),
            ),
            const Divider(),
            TitleMediumText(LocaleKeys.other.tr(context)),
            const SpaceHeight(),
            const Spacer(),
            FirebaseAuth.instance.currentUser == null
                ? Row(
                    children: [
                      Expanded(
                        child: CustomButton(
                          title: LocaleKeys.login.tr(context),
                          radius: 10,
                          function: () {
                            Utils.navigateTo(
                                widget: const LoginScreen(), context: context);
                          },
                        ),
                      ),
                      Expanded(
                        child: CustomButton(
                          title: LocaleKeys.register.tr(context),
                          radius: 10,
                          function: () {
                            Utils.navigateTo(
                              widget: const RegisterScreen(),
                              context: context,
                            );
                          },
                        ),
                      ),
                    ],
                  )
                : CustomButton(
                    width: double.infinity,
                    height: 50,
                    color: primaryColor,
                    radius: 30,
                    function: () {
                      Dialogs.logOutDialog(
                        content: LocaleKeys.logOut.tr(context),
                        function: () async {
                          await logOut();
                        },
                        context: context,
                      );
                    },
                    title: LocaleKeys.logOut.tr(context),
                  ),
          ],
        ),
      ),
    );
  }
}
