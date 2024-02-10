import 'package:flutter/material.dart';

import '../../../view_model/address_provider.dart';
import '../../../models/address_model.dart';
import '../../../res/custom_widgets/CustomAppBar.dart';
import '../../../utils/utils.dart';
import '../../../view/widgets/address/address_item.dart';
import 'add_or_edit_adress_screen.dart';

class AddressesScreen extends StatelessWidget {
  const AddressesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AddressProvider addressProvider = AddressProvider.get(context);
    return Scaffold(
      appBar: CustomAppBar(
        actions: [
          IconButton(
            onPressed: () {
              Utils.navigateTo(
                widget: const AddOrEditAddressScreen(),
                context: context,
              );
            },
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: StreamBuilder(
        stream: addressProvider.fetchAddressDataStream(),
        builder: (context, snapshot) {
          if (snapshot.data != null) {
            final List<AddressModel> addresses = snapshot.data!;
            return ListView.builder(
              itemCount: addresses.length,
              itemBuilder: (context, index) {
                return AddressItem(
                  addressModel: addresses[index],
                  function: () {
                    Utils.navigateTo(
                      widget: AddOrEditAddressScreen(
                        addressModel: addresses[index],
                      ),
                      context: context,
                    );
                  },
                );
              },
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}
