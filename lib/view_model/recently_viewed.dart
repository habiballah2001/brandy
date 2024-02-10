import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../models/recently_viewed.dart';
import '../utils/utils.dart';

class RecentlyViewedProvider with ChangeNotifier {
  static RecentlyViewedProvider get(context, {bool listen = true}) =>
      Provider.of<RecentlyViewedProvider>(context, listen: listen);

  //
  final Map<String, RecentlyViewedModel> _viewedItems = {};
  Map<String, RecentlyViewedModel> get getRecentlyViewedItems => _viewedItems;

  bool inRecentlyViewed({required String productId}) {
    return _viewedItems.containsKey(productId);
  }

  void addToRecentlyViewed({required String productId}) {
    _viewedItems.putIfAbsent(
      productId,
      () => RecentlyViewedModel(
        id: const Uuid().v4(),
        productId: productId,
      ),
    );

    notifyListeners();
  }

  void removeRecentlyViewed({required String productId}) {
    _viewedItems.remove(productId);
    notifyListeners();
  }

  Future<void> checkRecently({required String productId}) async {
    if (inRecentlyViewed(productId: productId)) {
      removeRecentlyViewed(productId: productId);
      addToRecentlyViewed(productId: productId);
    } else {
      addToRecentlyViewed(productId: productId);
    }
  }

  void clearRecentlyViewed() {
    _viewedItems.clear();

    Utils.toast(body: 'Cleared');

    notifyListeners();
  }
}
