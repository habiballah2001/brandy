import 'dart:io';
import 'package:brandy/view/layout/shop_layout.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'utils/local_storage/cache_helper.dart';
import 'view_model/address_provider.dart';
import 'view_model/cart_provider.dart';
import 'view_model/home_provider.dart';
import 'view_model/order_provider.dart';
import 'view_model/recently_viewed.dart';
import 'view_model/theme_provider.dart';
import 'view_model/user_provider.dart';
import 'view_model/wishlist_provider.dart';
import 'res/constants/constants.dart';
import 'utils/app_locale.dart';
import 'res/styles/themes.dart';

Future<void> main() async {
  //to sure (all in main method is done)then(run app).
  WidgetsFlutterBinding.ensureInitialized();
  Platform.isAndroid
      ? await Firebase.initializeApp(
          options: const FirebaseOptions(
            apiKey: 'AIzaSyB1sS3fo2good5uEIUMoxu-uWAjpq7heLw',
            appId: '1:773208576678:android:750a2d13a7fff51cab1a67',
            messagingSenderId: '773208576678',
            projectId: 'brandy-6e4ff',
            storageBucket: 'brandy-6e4ff.appspot.com',
          ),
        )
      : await Firebase.initializeApp();
  if (Constants.user != null) {
    await FirebaseAppCheck.instance
        // Your personal reCaptcha public key goes here:
        .activate(
      androidProvider: AndroidProvider.debug,
      appleProvider: AppleProvider.debug,
      webProvider: ReCaptchaV3Provider('recaptcha-v3-site-key'),
    );
  }
  await CacheHelper.init();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({
    super.key,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ThemeProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => HomeProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => CartProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => WishlistProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => RecentlyViewedProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => UserProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => OrderProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => AddressProvider(),
        ),
      ],
      child: Consumer<ThemeProvider>(builder: (context, value, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: value.getIsDark ? AppTheme.darkTheme : AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: value.getIsDark ? ThemeMode.dark : ThemeMode.light,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          localeResolutionCallback: (locale, supportedLocales) {
            return AppLocalizations.localeResolutionCallback(
                locale, supportedLocales);
          },
          home: const AppLayout(),
        );
      }),
    );
  }
}
