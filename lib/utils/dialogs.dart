import 'dart:developer';
import 'package:brandy/res/constants/strings.dart';
import 'package:brandy/utils/app_locale.dart';
import 'package:brandy/view_model/order_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../res/constants/paths.dart';
import '../view_model/address_provider.dart';
import '../models/address_model.dart';
import '../view/setting/general/add_or_edit_adress_screen.dart';
import '../view/widgets/address/address_item.dart';
import '../res/components/components.dart';
import 'utils.dart';
import '../res/custom_widgets/custom_outlined_button.dart';
import '../res/custom_widgets/custom_texts.dart';

class Dialogs {
  static void errorDialog({
    required String content,
    required BuildContext context,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            children: [
              const Icon(Icons.error),
              const SpaceWidth(),
              Text(LocaleKeys.error.tr(context)),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                AppImages.error,
                height: 60,
              ),
              BodyLargeText(content)
            ],
          ),
        );
      },
    );
  }

  static void warningDialog({
    required String content,
    Function()? accept,
    required BuildContext context,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                AppImages.warning,
                height: 60,
              ),
              BodyLargeText(content),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('cancel'),
            ),
            if (accept != null)
              TextButton(
                onPressed: accept,
                child: Text(LocaleKeys.yes.tr(context)),
              ),
          ],
        );
      },
    );
  }

  static void logOutDialog({
    required String content,
    required Function() function,
    required BuildContext context,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            children: [
              const Icon(Icons.logout),
              const SpaceWidth(),
              Text(LocaleKeys.logOut.tr(context)),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                AppImages.warning,
                height: 60,
              ),
              BodyLargeText(content)
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Utils.popNavigate(context);
              },
              child: Text(LocaleKeys.cancel.tr(context)),
            ),
            TextButton(
              onPressed: function,
              child: Text(LocaleKeys.logOut.tr(context)),
            ),
          ],
        );
      },
    );
  }

  static void pickPicDialog(
    context, {
    Function()? cameraTap,
    Function()? galleryTap,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: () {},
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      const Icon(Icons.camera),
                      const SpaceWidth(),
                      TitleSmallText(LocaleKeys.camera.tr(context))
                    ],
                  ),
                ),
              ),
              const SpaceHeight(),
              InkWell(
                onTap: () {},
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      const Icon(Icons.image),
                      const SpaceWidth(),
                      TitleSmallText(LocaleKeys.gallery.tr(context))
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  static void addressDialog(context) {
    AddressProvider addressProvider =
        AddressProvider.get(context, listen: false);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: SizedBox(
            width: 200,
            child: ListView(
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              children: [
                FutureBuilder(
                  future: addressProvider.fetchAddressData(),
                  builder: (context, snapshot) {
                    if (snapshot.data != null) {
                      final List<AddressModel> addresses = snapshot.data!;
                      return ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: addresses.length,
                        itemBuilder: (context, index) {
                          AddressModel address = addresses[index];
                          return AddressItem(
                            function: () {
                              try {
                                OrderProvider.get(context, listen: false)
                                    .addressModel = AddressModel(
                                  city: address.city,
                                  st: address.st,
                                  other: address.other,
                                  addressId: address.addressId,
                                );
                                Utils.popNavigate(context);
                                log(LocaleKeys.address.tr(context));
                              } catch (e) {
                                log('address error');
                              }
                            },
                            addressModel: address,
                          );
                        },
                      );
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                ),
                CustomOutlinedButton(
                  title: 'Add address',
                  leadIcon: Icons.add,
                  function: () {
                    Utils.navigateTo(
                      widget: const AddOrEditAddressScreen(),
                      context: context,
                    );
                  },
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
