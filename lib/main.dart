import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:isouq/home/viewmodels/app_bar_gradient_viewmodel.dart';
import 'package:isouq/home/viewmodels/home_viewmodel.dart';
import 'package:isouq/cart/viewmodels/cart_viewmodel.dart';
import 'package:isouq/home/viewmodels/item_details_viewmodel.dart';
import 'package:isouq/notification/viewmodels/notification_viewmodel.dart';
import 'package:isouq/profile/viewmodels/order_list_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:isouq/themes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'brands/viewmodels/brand_list_viewmodel.dart';
import 'login/viewmodels/login_viewmodel.dart';
import 'profile/viewmodels/order_details_viewmodel.dart';
import 'profile/viewmodels/profile_viewmodel.dart';
import 'sign_up/viewmodels/sign_up_viewmodel.dart';
import 'package:isouq/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseAdMob.instance.initialize(appId: 'ca-app-pub-2004979416587198~3399203318');
  // ignore: invalid_use_of_visible_for_testing_member
  SharedPreferences.setMockInitialValues({});
  runApp(EasyLocalization(
    child: MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => SignUpViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => LoginViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => ProfileViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => OrderListViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => OrderDetailsViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => NotificationViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => BrandListViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => CartViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => AppBarGradientViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => HomeViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => ItemDetailsViewModel(),
        ),
      ],
      child: MyApp(),
    ),
    path: 'assets/language',
    supportedLocales: [
      Locale('en', 'US'),
      Locale('ar', 'DZ'),
    ],
  )
  );
}


class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Colors.transparent, //or set color with: Color(0xFF0000FF)
    ));
    return MaterialApp(
      localizationsDelegates:[
        EasyLocalization.of(context).delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      debugShowCheckedModeBanner: false,
      supportedLocales: EasyLocalization.of(context).supportedLocales,
      locale: EasyLocalization.of(context).locale,
      title: 'iNative Coder',
      theme: Themes.defaultTheme,
      home: SplashScreen(),
    );
  }
}
