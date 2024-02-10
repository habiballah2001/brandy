import 'package:cloud_firestore/cloud_firestore.dart';

import 'address_model.dart';

class OrderModel {
  String? orderId;
  String? userId;
  String? userName;
  String? userPhone;
  double? subTotal;
  double? totalDiscount;
  int? vat;
  double? cost;
  String? paymentMethod;
  Timestamp? date;
  String? status;
  List products;
  AddressModel address;

  OrderModel({
    required this.orderId,
    required this.userId,
    required this.userName,
    required this.userPhone,
    required this.cost,
    required this.totalDiscount,
    required this.vat,
    required this.subTotal,
    required this.paymentMethod,
    required this.date,
    required this.status,
    required this.products,
    required this.address,
  });

  factory OrderModel.fromFirestore(doc) {
    return OrderModel(
      orderId: doc['orderId'],
      userId: doc['userId'],
      userName: doc['userName'],
      userPhone: doc['userPhone'],
      cost: doc['cost'],
      totalDiscount: doc['discount'],
      vat: doc['vat'],
      subTotal: doc['total'],
      paymentMethod: doc['payment_method'],
      date: doc['date'],
      status: doc['status'],
      products: doc['products'],
      address: AddressModel.fromFirestore(doc['address']),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'orderId': orderId,
      'userId': userId,
      'userName': userName,
      'userPhone': userPhone,
      'cost': cost,
      'discount': totalDiscount,
      'vat': vat,
      'total': subTotal,
      'payment_method': paymentMethod,
      'date': date,
      'status': status,
      'products': products,
      'address': address.toFirestore()
    };
  }
}

class OrderProductModel {
  final String? productId;
  final int? quantity;

  OrderProductModel({required this.productId, required this.quantity});
  Map<String, dynamic> toFirestore() {
    return {
      'productId': productId,
      'quantity': quantity,
    };
  }

  factory OrderProductModel.fromFirestore(doc) {
    return OrderProductModel(
      productId: doc['productId'],
      quantity: doc['quantity'],
    );
  }
}
