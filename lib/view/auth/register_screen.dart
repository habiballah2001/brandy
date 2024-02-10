import 'dart:developer';

import 'package:brandy/res/constants/strings.dart';
import 'package:brandy/utils/app_locale.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../view_model/user_provider.dart';
import '../../res/components/components.dart';
import '../../res/custom_widgets/custom_button.dart';
import '../../utils/utils.dart';
import '../../res/custom_widgets/custom_text_field.dart';
import '../../res/custom_widgets/custom_texts.dart';
import 'login_screen.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher_string.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  //form
  final formKey = GlobalKey<FormState>();

  //text controllers
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  //address
  TextEditingController cityController = TextEditingController();
  TextEditingController stController = TextEditingController();
  TextEditingController otherController = TextEditingController();

  //focus node
  FocusNode nameFocusNode = FocusNode();
  FocusNode emailFocusNode = FocusNode();
  FocusNode phoneFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();
  //address
  FocusNode cityFocusNode = FocusNode();
  FocusNode stFocusNode = FocusNode();
  FocusNode otherFocusNode = FocusNode();

  @override
  void dispose() {
    if (mounted) {
      nameController.dispose();
      emailController.dispose();
      phoneController.dispose();
      passwordController.dispose();
      cityController.dispose();
      stController.dispose();
      otherController.dispose();
      //
      nameFocusNode.dispose();
      emailFocusNode.dispose();
      phoneFocusNode.dispose();
      passwordFocusNode.dispose();
      cityFocusNode.dispose();
      stFocusNode.dispose();
      otherFocusNode.dispose();
    }

    super.dispose();
  }

  bool _isLoading = false;
  Future<void> submitRegisterForm() async {
    FocusScope.of(context).unfocus();
    if (formKey.currentState!.validate()) {
      log('form valid');
      setState(() {
        _isLoading = true;
      });

      Provider.of<UserProvider>(context, listen: false)
          .register(
        email: emailController.text,
        password: passwordController.text,
        name: nameController.text,
        phone: phoneController.text,
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
      return log('form not valid');
    } else {
      setState(() {
        _isLoading = false;
      });
      log('form not valid');
    }
  }

  String? _currentAddress;
  Position? _currentPosition;

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Location services are disabled. Please enable the services',
            ),
          ),
        );
      }
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Location permissions are denied')));
        }
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
                'Location permissions are permanently denied, we cannot request permissions.')));
      }
      return false;
    }
    return true;
  }

  Future<void> openMap() async {
    String googleUrl =
        'http://www.google.com/maps/search/?api=1&query=${_currentPosition!.latitude},${_currentPosition!.longitude}';
    await canLaunchUrlString(googleUrl)
        ? await launchUrlString(googleUrl)
        : throw 'Couldn\'t launch';
  }

  Future<void> _getAddressFromLatLng() async {
    await placemarkFromCoordinates(
      _currentPosition!.latitude,
      _currentPosition!.longitude,
    ).then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      setState(() {
        _currentAddress =
            '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}';
        cityController.text = place.country.toString();
        stController.text = place.street.toString();
        otherController.text = place.locality.toString();
      });
    }).catchError((e) {
      log(e.toString());
    });
  }

  ///
  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();

    if (!hasPermission) return;
    await Geolocator.getCurrentPosition().then((Position position) async {
      setState(() {
        _currentPosition = position;
      });
      await openMap();
      await _getAddressFromLatLng();
    }).catchError((e) {
      log(e.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.all(8),
          children: [
            SpaceHeight(height: size.height * .1),
            HeadMediumText(
              LocaleKeys.register.tr(context),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                BodyLargeText(
                  LocaleKeys.haveAccount.tr(context),
                ),
                InkWell(
                  onTap: () => Utils.navigateTo(widget:const LoginScreen(), context:context),
                  child: Text(
                    LocaleKeys.login.tr(context),
                    style: const TextStyle(
                      decoration: TextDecoration.underline,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      height: 1,
                    ),
                  ),
                )
              ],
            ),
            const SpaceHeight(height: 30),
            CustomTextField(
              controller: nameController,
              focusNode: nameFocusNode,
              textInputAction: TextInputAction.next,
              hint: LocaleKeys.fullName.tr(context),
              onEditingComplete: () =>
                  FocusScope.of(context).requestFocus(emailFocusNode),
              type: TextInputType.text,
              validate: (value) {
                return Utils.stringValidator(
                  value: value!,
                  returnedString: LocaleKeys.validText.tr(context),
                );
              },
            ),
            CustomTextField(
              controller: emailController,
              textInputAction: TextInputAction.next,
              focusNode: emailFocusNode,
              hint: LocaleKeys.email.tr(context),
              onEditingComplete: () =>
                  FocusScope.of(context).requestFocus(passwordFocusNode),
              type: TextInputType.emailAddress,
              validate: (value) {
                if (value!.isEmpty ||
                    value.startsWith('_') ||
                    !value.contains('@') ||
                    !value.contains('.com')) {
                  return LocaleKeys.validText.tr(context);
                }
                return null;
              },
            ),
            PasswordTextField(
              textInputAction: TextInputAction.next,
              focusNode: passwordFocusNode,
              label: LocaleKeys.password.tr(context),
              onEditingComplete: () =>
                  FocusScope.of(context).requestFocus(phoneFocusNode),
              controller: passwordController,
              validate: (value) {
                return Utils.stringValidator(
                  value: value!,
                  returnedString: LocaleKeys.validText.tr(context),
                );
              },
            ),
            CustomTextField(
              controller: phoneController,
              focusNode: phoneFocusNode,
              type: TextInputType.phone,
              textInputAction: TextInputAction.next,
              maxLength: 11,
              hint: LocaleKeys.phone.tr(context),
              onEditingComplete: () =>
                  FocusScope.of(context).requestFocus(cityFocusNode),
              onSubmit: (p0) => submitRegisterForm,
              onChange: (p0) {
                log(phoneController.text);
              },
              validate: (value) {
                return Utils.stringValidator(
                  value: value!,
                  returnedString: LocaleKeys.validText.tr(context),
                );
              },
            ),
            CustomButton(
              title: 'Pick location',
              function: () {},
            ),
            const BodyLargeText('or add manually'),
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    controller: cityController,
                    focusNode: cityFocusNode,
                    type: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    hint: LocaleKeys.city.tr(context),
                    onEditingComplete: () =>
                        FocusScope.of(context).requestFocus(stFocusNode),
                    onSubmit: (p0) => submitRegisterForm,
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
                ),
                Expanded(
                  child: CustomTextField(
                    controller: stController,
                    focusNode: stFocusNode,
                    type: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    hint: LocaleKeys.st.tr(context),
                    onEditingComplete: () =>
                        FocusScope.of(context).requestFocus(otherFocusNode),
                    onSubmit: (p0) => submitRegisterForm,
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
                ),
              ],
            ),
            CustomTextField(
              controller: otherController,
              focusNode: otherFocusNode,
              type: TextInputType.text,
              textInputAction: TextInputAction.next,
              hint: LocaleKeys.other.tr(context),
              onEditingComplete: submitRegisterForm,
              onSubmit: (p0) => submitRegisterForm,
              onChange: (p0) {
                log(otherController.text);
              },
              validate: (value) {
                if (value!.isEmpty) {
                  return 'enter valid or N/A ';
                }else if(value.isNotEmpty)
                {
                  value = 'N/A';
                }
                return null;
              },
            ),
            const SpaceHeight(),
            CustomButton(
              title: LocaleKeys.register.tr(context),
              radius: 10,
              load: _isLoading,
              function: submitRegisterForm,
            ),
          ],
        ),
      ),
    );
  }
}
