import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  String productId;
  String title;
  double oldPrice;
  double discount;
  double price;
  String description;
  String category;
  String image;
  //String model;
  int quantity;
  Timestamp? addedAt;
  ProductModel({
    required this.productId,
    required this.title,
    required this.oldPrice,
    required this.discount,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
    //required this.model,
    required this.quantity,
    this.addedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': productId, //doc.get("id"),
      'title': title,
      'oldPrice': oldPrice,
      'discount': discount,
      'price': price,
      'category': category,
      'description': description,
      'image': image,
      //'model': model,
      'quantity': quantity,
      'addedAt': addedAt,
    };
  }

  factory ProductModel.fromFirestore(doc) {
    ///if list
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return ProductModel(
      productId: data['id'], //doc.get("id"),
      title: data['title'],
      oldPrice: data['oldPrice'],
      discount: data['discount'],
      price: data['price'],
      category: data['category'],
      description: data['description'],
      image: data['image'],
      //model: data['model'],
      quantity: data['quantity'],
      addedAt: data['addedAt'],
    );
  }
}
