import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../res/custom_widgets/CustomAppBar.dart';
import '../../../view_model/user_provider.dart';
import '../../../models/user_data_model.dart';
import '../../../res/components/components.dart';
import '../../../res/custom_widgets/custom_button.dart';
import '../../../utils/utils.dart';
import '../../../res/custom_widgets/custom_text_field.dart';
import '../../../res/custom_widgets/custom_texts.dart';

class EditProfile extends StatefulWidget {
  final UserModel userModel;

  const EditProfile({super.key, required this.userModel});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final formKey = GlobalKey<FormState>();

  //text controllers
  late TextEditingController nameController;

  late TextEditingController emailController;

  late TextEditingController phoneController;

  //focus node
  FocusNode nameFocusNode = FocusNode();

  FocusNode emailFocusNode = FocusNode();

  FocusNode phoneFocusNode = FocusNode();

  @override
  void initState() {
    nameController =
        TextEditingController(text: widget.userModel.userName ?? '');
    emailController = TextEditingController(text: widget.userModel.email ?? '');
    phoneController = TextEditingController(text: widget.userModel.phone);
    super.initState();
  }

  @override
  void dispose() {
    if (mounted) {
      nameController.dispose();
      emailController.dispose();
      phoneController.dispose();

      //
      nameFocusNode.dispose();
      emailFocusNode.dispose();
      phoneFocusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: TitleMediumText(
          'Edit',
        ),
      ),
      body: Form(
        key: formKey,
        child: Center(
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.all(8),
            children: [
              const SpaceHeight(height: 30),
              const TitleSmallText('User name'),
              CustomTextField(
                controller: nameController,
                focusNode: nameFocusNode,
                textInputAction: TextInputAction.next,
                hint: 'Full Name',
                onEditingComplete: () =>
                    FocusScope.of(context).requestFocus(emailFocusNode),
                type: TextInputType.text,
                validate: (value) {
                  return Utils.stringValidator(
                    value: value!,
                    returnedString: ' must be filled',
                  );
                },
              ),
              const SpaceHeight(),
              const TitleSmallText('Phone'),
              CustomTextField(
                controller: phoneController,
                focusNode: phoneFocusNode,
                type: TextInputType.phone,
                textInputAction: TextInputAction.next,
                maxLength: 11,
                hint: 'phone',
                onEditingComplete: submitRegisterForm,
                onSubmit: (p0) => submitRegisterForm,
                onChange: (p0) {
                  log(phoneController.text);
                },
                validate: (value) {
                  return Utils.stringValidator(
                    value: value!,
                    returnedString: ' must be filled',
                  );
                },
              ),
              const SpaceHeight(),
              CustomButton(
                title: 'Edit',
                radius: 10,
                load: isLoading,
                function: submitRegisterForm,
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool isLoading = false;
  Future<void> submitRegisterForm() async {
    FocusScope.of(context).unfocus();
    if (formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      log('form valid');
      Provider.of<UserProvider>(context, listen: false)
          .editUserData(
        name: nameController.text,
        phone: phoneController.text,
        context: context,
      )
          .then((value) {
        setState(() {
          isLoading = false;
        });
      }).catchError((e) {
        setState(() {
          isLoading = false;
        });
      });
    } else {
      return log('form not valid');
    }
  }
}
