import 'dart:developer';

import 'package:brandy/view_model/cart_provider.dart';
import 'package:brandy/utils/dialogs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../models/address_model.dart';
import '../models/order_model.dart';
import '../models/user_data_model.dart';
import '../view/orders/orders_screen.dart';
import '../res/constants/constants.dart';
import '../utils/utils.dart';
import 'home_provider.dart';
import 'user_provider.dart';

class OrderProvider with ChangeNotifier {
  static OrderProvider get(context, {bool listen = true}) =>
      Provider.of<OrderProvider>(context, listen: listen);

  OrderProvider() {
    fetchAllOrders();
  }

  final User? _user = FirebaseAuth.instance.currentUser;
  final _ordersCollection = FirebaseFirestore.instance.collection("orders");
  final CollectionReference<Map<String, dynamic>> _usersCollection =
      FirebaseFirestore.instance.collection("users");
  //
  static List<OrderModel> _orders = [];
  List<OrderModel> get getOrdersList => _orders;
  Future<List<OrderModel>?> fetchAllOrders() async {
    if (_user != null) {
      _ordersCollection
          .orderBy('date', descending: true)
          .get()
          .then((orderSnapshot) {
        _orders.clear();
        _orders = orderSnapshot.docs.map((querySnapshot) {
          return OrderModel.fromFirestore(querySnapshot);
        }).toList();
      }).catchError((e) {
        log('err in fetchOrders : ${e.toString()}');
      });
    } else {
      log('no user :$_user');

      return null;
    }
    return _orders;
  }

  Stream<List<OrderModel>> fetchOrdersStream({String? status}) {
    if (_user != null) {
      try {
        return status != null
            ? _ordersCollection
                .orderBy('date', descending: true)
                .where('status', isEqualTo: status)
                .where('userId', isEqualTo: _user.uid)
                .snapshots()
                .map((productsSnapshot) {
                _orders.clear();
                _orders = productsSnapshot.docs.map((e) {
                  return OrderModel.fromFirestore(e);
                }).toList();
                return _orders;
              })
            : _ordersCollection
                .orderBy('date', descending: true)
                .where('userId', isEqualTo: _user.uid)
                .snapshots()
                .map((productsSnapshot) {
                _orders.clear();
                _orders = productsSnapshot.docs.map((e) {
                  return OrderModel.fromFirestore(e);
                }).toList();
                return _orders;
              });
      } catch (e) {
        log('error in fetch orders ${e.toString()}');
        rethrow;
      }
    } else {
      log('no user :$_user');
      return const Stream.empty();
    }
  }

  Future<List<OrderModel>?>? fetchOrdersFuture({String? status}) async {
    if (_user != null) {
      try {
        return status != null
            ? await _ordersCollection
                .orderBy('date', descending: true)
                .where('status', isEqualTo: status)
                .where('userId', isEqualTo: _user.uid)
                .get()
                .then((productsSnapshot) {
                _orders.clear();
                _orders = productsSnapshot.docs.map((e) {
                  return OrderModel.fromFirestore(e);
                }).toList();
                return _orders;
              })
            : await _ordersCollection
                .orderBy('date', descending: true)
                .where('userId', isEqualTo: _user.uid)
                .get()
                .then((productsSnapshot) {
                _orders.clear();
                _orders = productsSnapshot.docs.map((e) {
                  return OrderModel.fromFirestore(e);
                }).toList();
                return _orders;
              });
      } catch (e) {
        log('error in fetch orders ${e.toString()}');
        rethrow;
      }
    } else {
      log('no user :$_user');
      return [];
    }
  }

  //make order products list
  List<Map<String, dynamic>> _orderProductsList = [];
  List<Map<String, dynamic>> get getOrderProducts => _orderProductsList;

  Future<List<Map<String, dynamic>>> makeOrderProductsList() async {
    if (Constants.user != null) {
      await _usersCollection
          .doc(Constants.user!.uid)
          .collection('cartList')
          .get()
          .then((value) {
        _orderProductsList.clear();
        _orderProductsList =
            value.docs.map((DocumentSnapshot<Map<String, dynamic>> doc) {
          return {
            'productId': doc.get('productId'),
            'quantity': doc.get('quantity'),
          };
        }).toList();
      }).catchError((e) {
        log('Error fetching cart: $e');
      });
    } else {
      log('no user fetchCart :${Constants.user}');
    }
    notifyListeners();
    return _orderProductsList;
  }

  AddressModel? addressModel;
  Future<void> makeOrder({required BuildContext context}) async {
    String orderId = const Uuid().v4();
    UserProvider userProvider = UserProvider.get(context, listen: false);
    CartProvider cartProvider = CartProvider.get(context, listen: false);
    HomeProvider homeProvider = HomeProvider.get(context, listen: false);
    if (Constants.user != null) {
      UserModel? getUser = userProvider.getUserModel!;
      //
      OrderModel orderModel = OrderModel(
        orderId: orderId,
        userId: getUser.uId,
        userName: getUser.userName,
        userPhone: getUser.phone,
        vat: cartProvider.getShipping,
        subTotal: cartProvider.getSubTotal(homeProvider: homeProvider),
        totalDiscount:
            cartProvider.getTotalDiscount(homeProvider: homeProvider),
        cost: cartProvider.getCost(homeProvider: homeProvider),
        paymentMethod: 'Cash',
        date: Timestamp.now(),
        status: 'waiting',
        products: _orderProductsList,
        address: addressModel!,
      );
      await FirebaseFirestore.instance
          .collection('orders')
          .doc(orderId)
          .set(orderModel.toFirestore())
          .then((value) {
        cartProvider.deleteCartData(context);
        Utils.toast(body: 'Order sent');
      }).catchError((e) {
        log('err in makeOrder : $e');
      });
    } else {
      log('no user makeOrder :${Constants.user}');
      return;
    }
    notifyListeners();
  }

  //
  OrderModel? orderModel;
  OrderModel? get getOrderData => orderModel;
  Future<OrderModel?> fetchOrderDetails({required String orderId}) async {
    if (_user != null) {
      _ordersCollection.doc(orderId).get().then((value) {
        orderModel = OrderModel.fromFirestore(value);
      });
    } else {
      log('no user :$_user');
    }
    return orderModel;
  }

  Future<void> cancelOrder(
      {required String orderId, required BuildContext context}) async {
    Dialogs.warningDialog(
      content: 'Sure to delete!',
      accept: () async {
        await _ordersCollection.doc(orderId).delete().then((value) async {
          Utils.navigateAndFinish(
              widget: const OrdersScreen(), context: context);
        });
      },
      context: context,
    );
  }
}
