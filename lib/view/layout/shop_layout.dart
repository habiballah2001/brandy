import 'dart:async';
import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../view_model/cart_provider.dart';
import '../../view_model/home_provider.dart';
import '../../view_model/user_provider.dart';
import '../../view_model/wishlist_provider.dart';
import '../../res/constants/constants.dart';
import '../../view/widgets/layout_app_bar.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class AppLayout extends StatefulWidget {
  const AppLayout({super.key});

  @override
  State<AppLayout> createState() => _AppLayoutState();
}

class _AppLayoutState extends State<AppLayout> {
  Future<void> fetchFCT() async {
    final homeProvider = Provider.of<HomeProvider>(
      context,
      listen: false,
    );
    final userProvider = Provider.of<UserProvider>(
      context,
      listen: false,
    );
    final cartProvider = Provider.of<CartProvider>(
      context,
      listen: false,
    );
    final wishlistProvider = Provider.of<WishlistProvider>(
      context,
      listen: false,
    );

    try {
      FirebaseAuth.instance.authStateChanges().listen((User? user) async {
        if (user == null) {
          log('User is currently signed out!');
        } else {
          await userProvider.fetchUserData();
          await homeProvider.fetchProducts();
          await cartProvider.fetchCart();
          await cartProvider.fetchShipping();
          await wishlistProvider.fetchWishlist();
          log('User is signed in!');
        }
      });
    } catch (error) {
      log('err fetching ${error.toString()}');
    }
  }

  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    fetchFCT();
    initConnectivity();

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      log('Couldn\'t check connectivity status', error: e);
      return;
    }
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      _connectionStatus = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    CartProvider cartProvider = CartProvider.get(context);
    HomeProvider homeProvider = HomeProvider.get(context);
    String connectionStatus = "";

    switch (_connectionStatus) {
      case ConnectivityResult.mobile:
        connectionStatus = "Mobile data connection is being used.";
        break;
      case ConnectivityResult.wifi:
        connectionStatus = "Wi-Fi connection is being used.";
        break;
      case ConnectivityResult.bluetooth:
        connectionStatus = "Bluetooth connection is being used.";
        break;
      case ConnectivityResult.ethernet:
        connectionStatus = "Ethernet connection is being used.";
        break;
      case ConnectivityResult.vpn:
        connectionStatus = "Vpn connection is being used.";
        break;
      case ConnectivityResult.other:
        connectionStatus = "Other connection is being used.";
        break;
      case ConnectivityResult.none:
        connectionStatus = "No connection.";
        break;
    }

    return Scaffold(
      appBar: const LayoutAppBar(),
      body: Lists.screens[homeProvider.getSelectedTab],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: homeProvider.getSelectedTab,
        onTap: (value) {
          homeProvider.changeTab(value);
        },
        items: Lists.bottomItems(
            cartBadge: cartProvider.getCartMap.isNotEmpty,
            badgeText: cartProvider.getCartMap.length.toString(),
            context: context),
      ),
    );
  }
}
