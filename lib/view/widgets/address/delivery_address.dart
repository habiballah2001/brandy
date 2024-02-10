import 'package:brandy/res/constants/strings.dart';
import 'package:brandy/utils/app_locale.dart';
import 'package:flutter/material.dart';
import '../../../models/address_model.dart';
import '../../../res/components/components.dart';
import '../../../res/custom_widgets/custom_texts.dart';

class OrderAddressWidget extends StatelessWidget {
  final AddressModel? addressModel;
  final Function()? function;
  const OrderAddressWidget(
      {super.key, required this.addressModel, this.function});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: function,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey, width: 2),
          borderRadius: const BorderRadius.all(
            Radius.circular(5),
          ),
        ),
        child: Row(
          children: [
            const CircleAvatar(
              child: Icon(Icons.location_on),
            ),
            const SpaceWidth(),
            addressModel != null
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BodyLargeText(addressModel!.city),
                      BodyMediumText(
                        '${addressModel!.st}, '
                        '${addressModel!.other}',
                      ),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BodyLargeText(LocaleKeys.city.tr(context)),
                      BodyMediumText(
                          '${LocaleKeys.st.tr(context)}, ${LocaleKeys.other.tr(context)}'),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
