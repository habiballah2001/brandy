/*
class A {
  final double? subTotal;
  final double? discount;
  final double? vat;
  final double? cost;
  final List<CartModel>? cartItems;

  A({this.subTotal, this.discount, this.vat, this.cost, this.cartItems});

  Map<String, dynamic> toMap() {
    return {
      'subTotal': subTotal,
      'discount': discount,
      'vat': vat,
      'cost': cost,
      'cartItems': cartItems,
    };
  }

  factory A.fromMap(doc) {
    //Map<String, dynamic> data = doc as Map<String, dynamic>;
    return A(
      subTotal: doc['subTotal'],
      discount: doc['discount'],
      vat: doc['vat'],
      cost: doc['cost'],
      cartItems: doc['cartItems'],
    );
  }
}
*/

class CartModel {
  final String? cartId;
  final String? productId;
  final int? quantity;

  CartModel({
    required this.cartId,
    required this.productId,
    required this.quantity,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'cartId': cartId,
      'productId': productId,
      'quantity': quantity,
    };
  }

  factory CartModel.fromFirestore(doc) {
    return CartModel(
      cartId: doc['cartId'],
      productId: doc['productId'],
      quantity: doc['quantity'],
    );
  }
}
