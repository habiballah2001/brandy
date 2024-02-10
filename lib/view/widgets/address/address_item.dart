import 'package:flutter/material.dart';
import '../../../models/address_model.dart';
import '../../../res/components/components.dart';
import '../../../res/custom_widgets/custom_container.dart';
import '../../../res/custom_widgets/custom_texts.dart';

class AddressItem extends StatelessWidget {
  final AddressModel addressModel;
  final Function()? function;
  const AddressItem({super.key, required this.addressModel, this.function});

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      function: function,
      padding: 10,
      child: Row(
        children: [
          const CircleAvatar(
            child: Icon(Icons.location_on_outlined),
          ),
          const SpaceWidth(),
          BodySmallText(
            addressModel.city,
          ),
          BodySmallText(
            addressModel.st,
          ),
          BodySmallText(
            addressModel.other,
          ),
        ],
      ),
    );
  }
}
