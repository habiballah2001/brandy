import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../models/cart_model.dart';
import '../models/product_model.dart';
import '../res/constants/constants.dart';
import '../utils/dialogs.dart';
import '../utils/utils.dart';
import 'home_provider.dart';
import 'order_provider.dart';

class CartProvider with ChangeNotifier {
  static CartProvider get(context, {bool listen = true}) =>
      Provider.of<CartProvider>(context, listen: listen);

  CartProvider() {
    fetchCart();
    fetchShipping();
  }

  static final Map<String, CartModel> _cartMap = {};
  Map<String, CartModel> get getCartMap => _cartMap;

  List<Map<String, dynamic>> _cartList = [];
  List<Map<String, dynamic>> get getCartList => _cartList;

  final CollectionReference<Map<String, dynamic>> _usersCollection =
      FirebaseFirestore.instance.collection("users");

  //firebase
  Future<void> addToCartFirebase({
    required String productId,
    required int quantity,
    required BuildContext context,
  }) async {
    if (Constants.user != null) {
      CartModel cartModel = CartModel(
        cartId: const Uuid().v4(),
        productId: productId,
        quantity: quantity,
      );
      _usersCollection
          .doc(Constants.user!.uid)
          .collection('cartList')
          .doc(productId)
          .set(cartModel.toFirestore())
          .then((value) async {
        await fetchCart();
        if (!context.mounted) return;
        await OrderProvider.get(context, listen: false).makeOrderProductsList();
        Utils.toast(body: 'Item has been added to cart');
      }).catchError((e) {
        Utils.printFullText('ERROR IN ADD TO CART : ${e.toString()}');
      });
    } else {
      Dialogs.warningDialog(content: 'pls,login first', context: context);
      return;
    }
    notifyListeners();
  }

  Future<List<Map<String, dynamic>>> fetchCart() async {
    if (Constants.user != null) {
      await _usersCollection
          .doc(Constants.user!.uid)
          .collection('cartList')
          .get()
          .then((value) {
        _cartList.clear();
        _cartList = value.docs.map((doc) => doc.data()).toList();
        for (var element in _cartList) {
          _cartMap.putIfAbsent(
            element['productId'],
            () {
              return CartModel.fromFirestore(element);
            },
          );
        }
        Utils.printFullText(
            'fetchCart success : ${_cartMap.values.toString()}');
      }).catchError((e) {
        Utils.printFullText('Error fetching cart: $e');
      });
    } else {
      Utils.printFullText('no user fetchCart :${Constants.user}');
    }
    notifyListeners();

    return _cartList;
  }

  List cartProductsDetails = [];
  List get getCartProductsDetails => cartProductsDetails;
  Future<List> fetchCartProductsDetails(context) async {
    if (Constants.user != null) {
      await _usersCollection
          .doc(Constants.user!.uid)
          .collection('cartList')
          .get()
          .then((value) {
        cartProductsDetails.clear();
        for (var element in _cartList) {
          cartProductsDetails.add(HomeProvider.get(context, listen: false)
              .getProductById(productId: element['productId'])!);
        }
      }).catchError((e) {
        Utils.printFullText('Error xx: $e');
      });
    } else {
      Utils.printFullText('no xx :${Constants.user}');
    }
    notifyListeners();
    Utils.printFullText(cartProductsDetails.length.toString());
    return cartProductsDetails;
  }

/*  Stream<List<CartModel>>? fetchCartStream() {
    List<CartModel> carts = [];
    if (Constants.user!= null) {
      try {
        return _usersCollection
            .doc(Constants.user!.uid)
            .collection('cartList')
            .snapshots()
            .map((event) {
          carts.clear();
          carts = event.docs.map((e) {
            return CartModel.fromFirestore(e);
          }).toList();
         Utils.printFullText('fetchCart success : ${_cartMap.values.toString()}');
          return carts;
        });
      } catch (e) {
       Utils.printFullText('Error fetching cart: $e');
        rethrow;
      }
    } else {
     Utils.printFullText('no user fetchCart :${Constants.user');
      return null;
    }
  }
*/
  Future<void> removeFromCart({
    required String productId,
    required BuildContext context,
  }) async {
    try {
      Dialogs.warningDialog(
        content: 'Sure to delete!',
        accept: () async {
          await _usersCollection
              .doc(Constants.user!.uid)
              .collection('cartList')
              .doc(productId)
              .delete()
              .then((value) async {
            Utils.popNavigate(context);
            Utils.toast(body: 'removed');
            _cartMap.remove(productId);
            await fetchCart();
          }).catchError((e) {
            Utils.printFullText('ERROR IN REMOVE ITEM : $e');
          });
          notifyListeners();
        },
        context: context,
      );
    } catch (e) {
      Utils.printFullText('err in removeFromCart : $e');
    }
  }

  Future<void> deleteCartData(BuildContext context) async {
    final CollectionReference<Map<String, dynamic>> subCollectionReference =
        _usersCollection.doc(Constants.user!.uid).collection('cartList');
    final QuerySnapshot<Map<String, dynamic>> subCollectionSnapshot =
        await subCollectionReference.get();
    final WriteBatch batch = FirebaseFirestore.instance.batch();

    try {
      for (var doc in subCollectionSnapshot.docs) {
        batch.delete(doc.reference);
      }
    } catch (e) {
      Utils.printFullText('err in deleteCartData : $e');
    }

    await batch.commit();
    _cartMap.clear();
    await fetchCart();
    if (!context.mounted) return;
    Utils.popNavigate(context);
  }

  Future<int> updateQuantity({
    required int quantity,
    required String productId,
    required String cartId,
  }) async {
    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(Constants.user!.uid)
          .collection("cartList")
          .doc(productId)
          .update({"quantity": quantity}).then((value) {
        updateLocalQuantity(
          cartId: cartId,
          productId: productId,
          quantity: quantity,
        );
        fetchCart();
      });
    } catch (e) {
      Utils.printFullText('err in increase quantity : $e');
    }
    notifyListeners();
    return quantity;
  }

  ///===========================================================================local
  bool inCart({required String productId}) {
    return _cartMap.containsKey(productId);
  }

  Future<Map<String, CartModel>> updateLocalQuantity({
    required String cartId,
    required String productId,
    required int quantity,
  }) async {
    try {
      _cartMap.update(
        productId,
        (item) => CartModel(
          cartId: item.cartId,
          productId: productId,
          quantity: quantity,
        ),
      );
      Utils.printFullText('quantity updated locally');
    } catch (e) {
      Utils.printFullText('err in updateLocalQuantity : $e');
    }
    notifyListeners();
    return _cartMap;
  }

  Map<String, CartModel> clearLocalCart() {
    try {
      _cartMap.clear();
    } catch (e) {
      Utils.printFullText('err un clear local cart $e');
    }
    notifyListeners();
    return _cartMap;
  }

  //information
  double getSubTotal({required HomeProvider homeProvider}) {
    double subTotal = 0.0;
    try {
      _cartMap.forEach((key, value) {
        ProductModel? product =
            homeProvider.getProductById(productId: value.productId!);
        product != null
            ? subTotal += product.oldPrice * value.quantity!.toDouble()
            : null;
      });
    } catch (e) {
      Utils.printFullText('err in getSubTotal : $e');
    }
    return subTotal;
  }

  int _shipping = 0;
  int get getShipping => _shipping;
  Future<int> fetchShipping() async {
    DocumentSnapshot<Map<String, dynamic>> userDoc =
        await FirebaseFirestore.instance.collection('vat').doc('vat').get();
    try {
      _shipping = userDoc.get('vat');
    } catch (e) {
      Utils.printFullText('err in vat $e');
    }
    notifyListeners();
    Utils.printFullText('_shipping : $_shipping');
    return _shipping;
  }

  double getTotalDiscount({required HomeProvider homeProvider}) {
    double totalDiscount = 0.0;
    try {
      _cartMap.forEach((key, value) {
        ProductModel? product =
            homeProvider.getProductById(productId: value.productId!);
        product != null
            ? totalDiscount += product.discount *
                (product.oldPrice / 100) *
                value.quantity!.toDouble()
            : null;
      });
    } catch (e) {
      Utils.printFullText('err in getTotalDiscount $e');
    }
    return totalDiscount;
  }

  double getCost({required HomeProvider homeProvider}) {
    double total = 0.0;
    try {
      _cartMap.forEach((key, value) {
        ProductModel? product =
            homeProvider.getProductById(productId: value.productId!);
        product != null
            ? total += product.price * value.quantity!.toDouble()
            : null;
      });
    } catch (e) {
      Utils.printFullText('err in getCost $e');
    }
    return _cartMap.isNotEmpty ? total + _shipping : total;
  }

  int getQuantity() {
    int totalQuantity = 0;
    try {
      _cartMap.forEach((key, value) {
        totalQuantity += value.quantity!;
      });
    } catch (e) {
      Utils.printFullText('err in getQuantity $e');
    }
    return totalQuantity;
  }
}
