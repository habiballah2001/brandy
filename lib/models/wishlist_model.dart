class WishlistModel {
  final String? wishlistId;
  final String? productId;
  WishlistModel({
    required this.wishlistId,
    required this.productId,
  });

  Map<String, dynamic> toFirestore() {
    return {'wishlistId': wishlistId, 'productId': productId};
  }

  factory WishlistModel.fromMap(doc) {
    return WishlistModel(
      wishlistId: doc['wishlistId'],
      productId: doc['productId'],
    );
  }
}
