import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../models/address_model.dart';
import '../utils/utils.dart';
import 'user_provider.dart';

class AddressProvider with ChangeNotifier {
  static AddressProvider get(context, {bool listen = true}) =>
      Provider.of<AddressProvider>(context, listen: listen);

  AddressProvider() {
    fetchAddressData();
  }
  static List<AddressModel> _addressList = [];
  List<AddressModel> get getAddressList => _addressList;
  final _usersCollection = FirebaseFirestore.instance.collection("users");
  static final User? _user = FirebaseAuth.instance.currentUser;

  Future<List<AddressModel>> fetchAddressData() async {
    if (_user != null) {
      try {
        await _usersCollection
            .doc(_user!.uid)
            .collection('addresses')
            .get()
            .then((value) {
          _addressList.clear();
          _addressList = value.docs.map((doc) {
            return AddressModel.fromFirestore(doc);
          }).toList();
        });
        log('fetchAddressData success : $_addressList');
      } catch (e) {
        log('Error fetching addresses: $e');
      }
    } else {
      log('no user fetchAddressData :$_user');
    }
    notifyListeners();
    return _addressList;
  }

  Stream<List<AddressModel>>? fetchAddressDataStream() {
    if (_user != null) {
      try {
        return _usersCollection
            .doc(_user!.uid)
            .collection('addresses')
            .snapshots()
            .map((doc) {
          _addressList.clear();
          _addressList = doc.docs.map((e) {
            return AddressModel.fromFirestore(e);
          }).toList();
          log('fetchAddressDataStream success : $_addressList');

          return _addressList;
        });
      } catch (e) {
        log('Error fetchAddressDataStream : $e');
        rethrow;
      }
    } else {
      return null;
    }
  }

  Future<void> addAddress({
    required String city,
    required String st,
    required String other,
    required BuildContext context,
  }) async {
    final String addressId = const Uuid().v4();
    AddressModel addressModel = AddressModel(
      city: city,
      st: st,
      other: other,
      addressId: addressId,
    );
    _usersCollection
        .doc(_user!.uid)
        .collection('addresses')
        .doc(addressId)
        .set(addressModel.toFirestore())
        .then((value) async {
      await UserProvider.get(context, listen: false).fetchUserData();

      Utils.toast(body: 'Item has been added to address');
    }).catchError((e) {
      log('ERROR IN ADD TO ADDRESS : ${e.toString()}');
    });
    notifyListeners();
  }

  Future<void> editAddress({
    required String city,
    required String st,
    required String other,
    required String addressId,
    required BuildContext context,
  }) async {
    _usersCollection
        .doc(_user!.uid)
        .collection('addresses')
        .doc(addressId)
        .update({
      'city': city,
      'st': st,
      'other': other,
    }).then((value) async {
      await UserProvider.get(context, listen: false).fetchUserData();

      Utils.toast(body: 'Item has been edited to address');
    }).catchError((e) {
      log('ERROR IN EDIT TO ADDRESS : ${e.toString()}');
    });
    notifyListeners();
  }
}
