import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? uId;
  String? email;
  String? userName;
  String? phone;
  Timestamp? createdAt;
  List<dynamic>? wishlist;
  UserModel({
    this.uId,
    this.email,
    this.userName,
    this.phone,
    this.createdAt,
    this.wishlist,
  });

  factory UserModel.fromJson(doc) {
    return UserModel(
      uId: doc['uId'],
      email: doc['email'],
      userName: doc['userName'],
      phone: doc['phone'],
      createdAt: doc['createdAt'],
      wishlist: doc['wishlist'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uId': uId,
      'email': email,
      'userName': userName,
      'phone': phone,
      'createdAt': createdAt,
      'wishlist': wishlist,
    };
  }
}
