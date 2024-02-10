import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../models/wishlist_model.dart';
import '../res/constants/constants.dart';
import '../utils/dialogs.dart';
import '../utils/utils.dart';

class WishlistProvider with ChangeNotifier {
  static WishlistProvider get(context, {bool listen = true}) =>
      Provider.of<WishlistProvider>(context, listen: listen);

  WishlistProvider() {
    fetchWishlist();
  }
  //
  static final Map<String, WishlistModel> _wishlistMap = {};
  Map<String, WishlistModel> get getWishlistMap => _wishlistMap;
  List _wishlist = [];
  List get getWishlist => _wishlist = [];

  final _usersCollection = FirebaseFirestore.instance.collection("users");
  //static final User? _user = FirebaseAuth.instance.currentUser;

  //firebase
  Future<void> addToWishlistFirebase({
    required String productId,
    required BuildContext context,
  }) async {
    if (Constants.user != null) {
      WishlistModel wishlist = WishlistModel(
        wishlistId: const Uuid().v4(),
        productId: productId,
      );
      _usersCollection.doc(Constants.user!.uid).update(
        {
          'wishlist': FieldValue.arrayUnion(
            [wishlist.toFirestore()],
          )
        },
      ).then(
        (value) async {
          await fetchWishlist();
          Utils.toast(body: 'Item has been added to WISHLIST');
        },
      ).catchError(
        (e) {
          log('ERROR IN ADD TO WISHLIST : ${e.toString()}');
        },
      );
    } else {
      Dialogs.warningDialog(content: 'pls, login first', context: context);
      return;
    }
    notifyListeners();
  }

  Future<List?> fetchWishlist() async {
    if (Constants.user != null) {
      try {
        DocumentSnapshot<Map<String, dynamic>> userDoc =
            await _usersCollection.doc(Constants.user!.uid).get();
        _wishlist = userDoc.get('wishlist');
        for (var element in _wishlist) {
          _wishlistMap.putIfAbsent(
            element['productId'],
            () {
              return WishlistModel.fromMap(element);
            },
          );
        }
      } catch (e) {
        log('Error fetching cart: $e');
      }
    } else {
      log('no user :${Constants.user}');
      return null;
    }
    //
    notifyListeners();
    return _wishlist;
  }

  Future<void> removeFromWishlist({
    required String wishlistId,
    required String productId,
    required BuildContext context,
  }) async {
    try {
      Dialogs.warningDialog(
        content: 'Sure to delete!',
        accept: () async {
          WishlistModel wishlist = WishlistModel(
            wishlistId: wishlistId,
            productId: productId,
          );
          await _usersCollection.doc(Constants.user!.uid).update({
            'wishlist': FieldValue.arrayRemove(
              [wishlist.toFirestore()],
            )
          }).then((value) async {
            _wishlistMap.remove(productId);
            await fetchWishlist();
            Utils.toast(body: 'removed');
            if (!context.mounted) return;
            Utils.popNavigate(context);
          }).catchError((e) {
            log('ERROR IN REMOVE ITEM : ${e.toString()}');
          });
        },
        context: context,
      );
    } catch (e) {
      log('err in remove from wishlist $e');
    }
    notifyListeners();
  }

  Future<void> clearWishlist(BuildContext context) async {
    Dialogs.warningDialog(
      content: 'Sure to delete!',
      accept: () async {
        await _usersCollection.doc(Constants.user!.uid).update(
          {'wishlist': []},
        ).then((value) async {
          _wishlistMap.clear();
          fetchWishlist();
          Utils.toast(body: 'cart cleared');
          Utils.popNavigate(context);
        }).catchError((e) {
          log('ERROR IN CLEAR CART${e.toString()}');
        });
      },
      context: context,
    );

    notifyListeners();
  }

  //local
  bool inWishlist({required String productId}) {
    return _wishlistMap.containsKey(productId);
  }

  Map<String, WishlistModel> clearLocalWishlist() {
    try {
      _wishlistMap.clear();
    } catch (e) {
      log('err un clear local cart $e');
    }
    notifyListeners();
    return _wishlistMap;
  }

  /*void removeFromWishlist({required String productId}) {
    _wishlistItems.remove(productId);
    CustomMethods.toast(body: 'Removed');
    notifyListeners();
  }
  */
}
