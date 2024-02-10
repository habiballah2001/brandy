import 'dart:developer';
import 'package:brandy/res/constants/strings.dart';
import 'package:brandy/utils/app_locale.dart';
import 'package:flutter/material.dart';
import '../../../view_model/address_provider.dart';
import '../../../res/custom_widgets/CustomAppBar.dart';
import '../../../res/custom_widgets/custom_texts.dart';
import '../../../models/address_model.dart';
import '../../../res/components/components.dart';
import '../../../res/custom_widgets/custom_button.dart';
import '../../../utils/utils.dart';
import '../../../res/custom_widgets/custom_text_field.dart';

class AddOrEditAddressScreen extends StatefulWidget {
  final AddressModel? addressModel;
  const AddOrEditAddressScreen({super.key, this.addressModel});

  @override
  State<AddOrEditAddressScreen> createState() => _AddOrEditAddressScreenState();
}

class _AddOrEditAddressScreenState extends State<AddOrEditAddressScreen> {
  //form
  final formKey = GlobalKey<FormState>();

  //text controllers
  late TextEditingController cityController;
  late TextEditingController stController;
  late TextEditingController otherController;

  //focus node
  FocusNode cityFocusNode = FocusNode();
  FocusNode stFocusNode = FocusNode();
  FocusNode otherFocusNode = FocusNode();

  bool _isLoading = true;

  @override
  void initState() {
    setState(() {
      _isLoading;
    });
    cityController =
        TextEditingController(text: widget.addressModel?.city ?? '');
    stController = TextEditingController(text: widget.addressModel?.st ?? '');
    otherController =
        TextEditingController(text: widget.addressModel?.other ?? '');
    super.initState();
  }

  @override
  void dispose() {
    if (mounted) {
      //
      cityController.dispose();
      stController.dispose();
      otherController.dispose();
      //
      cityFocusNode.dispose();
      stFocusNode.dispose();
      otherFocusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.all(8),
          children: [
            TitleSmallText(LocaleKeys.city.tr(context)),
            CustomTextField(
              controller: cityController,
              focusNode: cityFocusNode,
              type: TextInputType.text,
              textInputAction: TextInputAction.next,
              hint: LocaleKeys.city.tr(context),
              onEditingComplete: () =>
                  FocusScope.of(context).requestFocus(stFocusNode),
              onChange: (p0) {
                log(cityController.text);
              },
              validate: (value) {
                return Utils.stringValidator(
                  value: value!,
                  returnedString: LocaleKeys.validText.tr(context),
                );
              },
            ),
            const SpaceHeight(),
            TitleSmallText(LocaleKeys.st.tr(context)),
            CustomTextField(
              controller: stController,
              focusNode: stFocusNode,
              type: TextInputType.text,
              textInputAction: TextInputAction.next,
              hint: LocaleKeys.st.tr(context),
              onEditingComplete: () =>
                  FocusScope.of(context).requestFocus(otherFocusNode),
              onChange: (p0) {
                log(stController.text);
              },
              validate: (value) {
                return Utils.stringValidator(
                  value: value!,
                  returnedString: LocaleKeys.validText.tr(context),
                );
              },
            ),
            const SpaceHeight(),
            TitleSmallText(LocaleKeys.other.tr(context)),
            CustomTextField(
              controller: otherController,
              focusNode: otherFocusNode,
              type: TextInputType.text,
              textInputAction: TextInputAction.next,
              hint: LocaleKeys.other.tr(context),
              onEditingComplete: widget.addressModel != null
                  ? editAddressForm
                  : addAddressForm,
              onSubmit: (p0) => widget.addressModel != null
                  ? editAddressForm
                  : addAddressForm,
              onChange: (p0) {
                log(otherController.text);
              },
              validate: (value) {
                return Utils.stringValidator(
                  value: value ?? '',
                  returnedString: LocaleKeys.validText.tr(context),
                );
              },
            ),
            const SpaceHeight(),
            CustomButton(
              title: LocaleKeys.submit.tr(context),
              radius: 10,
              load: _isLoading,
              function: widget.addressModel != null
                  ? editAddressForm
                  : addAddressForm,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> addAddressForm() async {
    FocusScope.of(context).unfocus();
    if (formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      log('form valid');
      AddressProvider.get(context, listen: false)
          .addAddress(
        city: cityController.text,
        st: stController.text,
        other: otherController.text,
        context: context,
      )
          .then((value) {
        setState(() {
          _isLoading = false;
        });
      }).catchError((e) {
        setState(() {
          _isLoading = false;
        });
      });
    } else {
      return log('form not valid');
    }
  }

  Future<void> editAddressForm() async {
    FocusScope.of(context).unfocus();
    if (formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      log('form valid');
      AddressProvider.get(context, listen: false)
          .editAddress(
        city: cityController.text,
        st: stController.text,
        other: otherController.text,
        addressId: widget.addressModel!.addressId.toString(),
        context: context,
      )
          .then((value) {
        setState(() {
          _isLoading = false;
        });
      }).catchError((e) {
        setState(() {
          _isLoading = false;
        });
      });
    } else {
      return log('form not valid');
    }
  }
}
