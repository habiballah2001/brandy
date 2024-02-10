import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../view/layout/shop_layout.dart';
import '../models/user_data_model.dart';
import '../view/auth/login_screen.dart';
import '../res/constants/constants.dart';
import '../utils/dialogs.dart';
import '../utils/utils.dart';
import 'address_provider.dart';
import 'cart_provider.dart';
import 'wishlist_provider.dart';

class UserProvider with ChangeNotifier {
  static UserProvider get(context, {bool listen = true}) =>
      Provider.of<UserProvider>(context, listen: listen);

  //user data
  UserModel? _userModel;
  UserModel? get getUserModel => _userModel;

  //firebase_auth
  /*User? _user;
  User? get getUser => _user;*/

  final _usersCollection = FirebaseFirestore.instance.collection('users');
  UserProvider() {
    fetchUserData();
  }

  Future<User?> register({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String city,
    required String st,
    required String other,
    required BuildContext context,
  }) async {
    //create user auth
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
      email: email.toLowerCase().trim(),
      password: password.trim(),
    )
        .then((value) async {
      Constants.user = value.user;
      await Constants.user!.updateDisplayName(name);
      //create user database
      if (!context.mounted) return;
      await createUserData(
        uId: value.user!.uid,
        name: name,
        email: Constants.user!.email!,
        password: password,
        phone: phone,
        city: city,
        st: st,
        other: other,
        context: context,
      );
      await Constants.user!.reload();
      log('register success : ${value.toString()}');
    }).catchError((e) {
      Dialogs.errorDialog(context: context, content: e.code.toString());
      log('Error in register: ${e.code.toString()}');
    });
    notifyListeners();
    return Constants.user;
  }

  Future<UserModel?> createUserData({
    required String uId,
    required String name,
    required String email,
    required String password,
    required String phone,
    required String city,
    required String st,
    required String other,
    required BuildContext context,
  }) async {
    UserModel userModel = UserModel(
      uId: uId,
      email: email.toLowerCase().trim(),
      userName: name,
      phone: phone,
      createdAt: Timestamp.now(),
      wishlist: [],
    );

    //create user database
    await _usersCollection.doc(uId).set(userModel.toMap()).then((value) async {
      await AddressProvider.get(context, listen: false).addAddress(
        city: city,
        st: st,
        other: other,
        context: context,
      );
      if (!context.mounted) return;

      Utils.navigateAndFinish(widget: const AppLayout(), context: context);
      Utils.toast(body: 'user created successfully');
      log('createUserData success');
    }).catchError((e) {
      Dialogs.errorDialog(context: context, content: e.code.toString());
      log('Error in create user: ${e.code.toString()}');
    });

    notifyListeners();
    return userModel;
  }

  Future<User?> login({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(
      email: email.toLowerCase().trim(),
      password: password.trim(),
    )
        .then((value) async {
      Constants.user = value.user;
      if (!context.mounted) return;
      Utils.navigateAndFinish(widget: const AppLayout(), context: context);
      await Utils.toast(body: 'Login successful');
      await Constants.user!.reload();
      log('Login success : ${value.toString()}');
    }).catchError((e) {
      Dialogs.errorDialog(context: context, content: e.toString());
      log('Error in login: ${e.toString()}');
    });
    notifyListeners();
    return Constants.user;
  }

  Future<UserModel?> fetchUserData() async {
    Constants.user = FirebaseAuth.instance.currentUser;
    if (Constants.user != null) {
      await _usersCollection.doc(Constants.user!.uid).get().then((value) {
        _userModel = UserModel.fromJson(value.data()!);
        log('fetchUserData : ${value.data().toString()}');
      }).catchError((e) {
        log('error in fetch user :${e.toString()}');
      });
      return _userModel;
    } else {
      log('fetchUserData : no user :${Constants.user}');
      return null;
    }
  }

/*
  Stream<UserModel?>? fetchUserDataStream() {
    Constants.user = FirebaseAuth.instance.currentUser;
    if (Constants.user != null) {
      try {
        return FirebaseFirestore.instance
            .collection('users')
            .doc(Constants.user!.uid)
            .snapshots()
            .map((event) {
          _userModel = UserModel.fromJson(event);
          log('fetchUserDataStream : ${event.data().toString()}');
          return _userModel;
        });
      } catch (e) {
        log('err in fetchUserDataStream $e');
      }
    } else {
      log('fetchUserDataStream : no user :${Constants.user}');
      return null;
    }
    return null;
  }
*/

  Future<UserModel?> editUserData({
    required String name,
    required String phone,
    required BuildContext context,
  }) async {
    if (Constants.user != null) {
      await _usersCollection.doc(Constants.user!.uid).update({
        'userName': name,
        'phone': phone,
      }).then((value) async {
        await Constants.user!.updateDisplayName(name);
        await fetchUserData();

        if (!context.mounted) return;
        Utils.navigateAndFinish(widget: const AppLayout(), context: context);
        Utils.toast(body: 'user edited successfully');
        log('editUserData success');
      }).catchError((e) {
        Dialogs.errorDialog(context: context, content: e.code.toString());
        log('Error in edit user: ${e.code.toString()}');
      });
    }
    //create user database

    notifyListeners();
    return _userModel;
  }

  Future<void> logOut(BuildContext context) async {
    CartProvider cartProvider = CartProvider.get(context, listen: false);
    WishlistProvider wishlistProvider =
        WishlistProvider.get(context, listen: false);

    if (Constants.user != null) {
      await FirebaseAuth.instance.signOut().then((value) async {
        await fetchUserData().then((value) {
          cartProvider.clearLocalCart();
          wishlistProvider.clearLocalWishlist();
        });
        if (!context.mounted) return;
        Utils.navigateAndFinish(widget: const LoginScreen(), context: context);
        log('logout success');
      }).catchError((e) {
        log('err in logout $e');
        if (!context.mounted) return;
        Dialogs.errorDialog(
          context: context,
          content: "An error has been occurred when logout : $e",
        );
      });
    }
    notifyListeners();
  }
}
