import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../models/product_model.dart';

class HomeProvider with ChangeNotifier {
  static HomeProvider get(context, {bool listen = true}) =>
      Provider.of<HomeProvider>(context, listen: listen);

  HomeProvider() {
    fetchProducts();
    getMainBanners();
    getSecBanners();
    getModels();
  }
  //
  static List<ProductModel> _allProducts = [];
  List<ProductModel> get getProducts => _allProducts;
  ProductModel? getProductById({required String productId}) {
    return _allProducts.firstWhere((element) => element.productId == productId);
  }

  //products
  final _productsCollection = FirebaseFirestore.instance.collection("products");
  Future<List<ProductModel>> fetchProducts() async {
    await _productsCollection
        .orderBy("addedAt", descending: true)
        .get()
        .then((productsSnapshot) {
      _allProducts.clear();
      _allProducts = productsSnapshot.docs.map((e) {
        return ProductModel.fromFirestore(e);
      }).toList();
    }).catchError((e) {
      log('error in catch products  ');
    });
    notifyListeners();
    return _allProducts;
  }

  Stream<List<ProductModel>> fetchProductsStream() {
    try {
      return _productsCollection
          .orderBy('addedAt', descending: true)
          .snapshots()
          .map((productsSnapshot) {
        _allProducts.clear();
        _allProducts = productsSnapshot.docs.map((e) {
          return ProductModel.fromFirestore(e);
        }).toList();
        /*for (var element in productsSnapshot.docs) {
          _allProducts.insert(0, ProductModel.fromFirestore(element));
        }*/
        return _allProducts;
      });
    } catch (e) {
      rethrow;
    }
  }

  //category
  static List<ProductModel> _categoryProducts = [];
  List<ProductModel> get getCategoryProducts => _categoryProducts;

  List<ProductModel> categoryProduct({required String category}) {
    _categoryProducts = _allProducts
        .where(
          (element) => element.category.toLowerCase().contains(
                category.toLowerCase(),
              ),
        )
        .toList();
    return _categoryProducts;
  }

  //selectedTab
  int selectedTab = 0;
  int get getSelectedTab => selectedTab;

  void changeTab(index) {
    selectedTab = index;
    notifyListeners();
  }

  //search
  static List<ProductModel> _searchProducts = [];
  List<ProductModel> get getSearchProducts => _searchProducts;

  List<ProductModel> searchProduct({
    required String searchText,
    required List<ProductModel> productsList,
  }) {
    _searchProducts = productsList
        .where(
          (element) => element.title.toLowerCase().contains(
                searchText.toLowerCase(),
              ),
        )
        .toList();
    return _searchProducts;
  }

  //banners
  final storage = FirebaseStorage.instance.ref();

  final List<String> _mainBannerList = [];
  List<String> get getMainBannersList => _mainBannerList;
  Future<List<String>> getMainBanners() async {
    final ListResult bannerFolder =
        await storage.child('main_banners').listAll();
    for (final Reference ref in bannerFolder.items) {
      final String downloadUrl = await ref.getDownloadURL();
      _mainBannerList.add(downloadUrl);
    }
    return _mainBannerList;
  }

  final List<String> _secBannerList = [];
  List<String> get getSecBannersList => _secBannerList;
  Future<List<String>> getSecBanners() async {
    final ListResult bannerFolder =
        await storage.child('sec_banners').listAll();
    for (final Reference ref in bannerFolder.items) {
      final String downloadUrl = await ref.getDownloadURL();
      _secBannerList.add(downloadUrl);
    }
    return _secBannerList;
  }

  final List<String> _modelsList = [];
  List<String> get getModelsList => _modelsList;
  Future<List<String>> getModels() async {
    final ListResult bannerFolder = await storage.child('models').listAll();
    for (final Reference ref in bannerFolder.items) {
      final String downloadUrl = await ref.getDownloadURL();
      _modelsList.add(downloadUrl);
    }
    return _modelsList;
  }
}
