import 'dart:developer';
import 'package:brandy/res/constants/strings.dart';
import 'package:brandy/res/custom_widgets/custom_texts.dart';
import 'package:brandy/utils/app_locale.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../view_model/user_provider.dart';
import '../../res/custom_widgets/custom_button.dart';
import '../../utils/utils.dart';
import '../../res/custom_widgets/custom_text_field.dart';
import '../../res/styles/colors.dart';

// reusable components

// 1. timing
// 2. refactor
// 3. quality
// 4. clean code

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                HeadMediumText(
                  LocaleKeys.login.tr(context),
                ),
                const SizedBox(
                  height: 60.0,
                ),
                CustomTextField(
                  controller: emailController,
                  hint: LocaleKeys.email.tr(context),
                  prefix: const Icon(Icons.email),
                  type: TextInputType.emailAddress,
                  validate: (value) {
                    return Utils.stringValidator(
                      value: value!,
                      returnedString: LocaleKeys.validText.tr(context),
                    );
                  },
                ),
                const SizedBox(
                  height: 5.0,
                ),
                PasswordTextField(
                  controller: passwordController,
                  label: LocaleKeys.password.tr(context),
                  type: TextInputType.visiblePassword,
                  onSubmit: (p0) => submitLoginForm,
                  onEditingComplete: submitLoginForm,
                  validate: (value) {
                    return Utils.stringValidator(
                      value: value!,
                      returnedString: LocaleKeys.validText.tr(context),
                    );
                  },
                ),
                const SizedBox(
                  height: 30.0,
                ),
                Center(
                  child: CustomButton(
                    color: secColor,
                    width: double.infinity,
                    radius: 30,
                    title: LocaleKeys.login.tr(context),
                    load: _isLoading,
                    isUpperCase: true,
                    function: submitLoginForm,
                  ),
                ),
                Row(
                  children: [
                    const Spacer(),
                    TextButton(
                      onPressed: () {},
                      child: Text(LocaleKeys.forgotPassword.tr(context)),
                    ),
                  ],
                ),
/*
                Row(
                  children: [
                    Container(
                      color: Colors.grey[400],
                      height: 1,
                      width: 100,
                    ),
                    const Spacer(),
                    Text(LocaleKeys.or.tr(context)),
                    const Spacer(),
                    Container(
                      color: Colors.grey[400],
                      height: 1,
                      width: 100,
                    ),
                  ],
                ),
*/
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool _isLoading = false;

  Future<void> submitLoginForm() async {
    FocusScope.of(context).unfocus();
    if (formKey.currentState!.validate()) {
      log('form valid');
      setState(() {
        _isLoading = true;
      });
      Provider.of<UserProvider>(context, listen: false)
          .login(
        email: emailController.text.toLowerCase().trim(),
        password: passwordController.text.trim(),
        context: context,
      )
          .then((value) {
        setState(() {
          _isLoading = false;
        });
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      log('form not valid');
    }
  }

/*
  Future<void> googleSignIn() async {
    final googleAccount = await GoogleSignIn().signIn();
    if (googleAccount != null) {
      final googleAuth = await googleAccount.authentication;
      if (googleAuth.accessToken != null && googleAuth.idToken != null) {
        try {
          final authResults = await FirebaseAuth.instance
              .signInWithCredential(GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken,
            idToken: googleAuth.idToken,
          ));
          if (authResults.additionalUserInfo!.isNewUser) {
            if (mounted) {
              setState(() {
                _isLoading = true;
              });
            }

            await FirebaseFirestore.instance
                .collection("users")
                .doc(authResults.user!.uid)
                .set({
              'userId': authResults.user!.uid,
              'name': authResults.user!.displayName,
              'email': authResults.user!.email,
              'createdAt': Timestamp.now(),
              'userWishlist': [],
              'userCartList': [],
            }).then((value) {
              if (context.mounted) {
                CustomMethods.navigateAndFinish(const AppLayout(), context);
              }
            });
          }
          if (context.mounted) {
            CustomMethods.navigateAndFinish(const AppLayout(), context);
          }
        } on FirebaseException catch (error) {
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            Dialogs.errorDialog(
              content: error.toString(),
              context: context,
            );
          });
        } catch (error) {
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
            Dialogs.errorDialog(
              content: error.toString(),
              context: context,
            );
          });
        } finally {
          _isLoading = false;
        }
      }
    }
  }
*/
}
