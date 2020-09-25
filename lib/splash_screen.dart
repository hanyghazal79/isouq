import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:isouq/Firebase/firebase_methods.dart';
import 'package:isouq/Helpers/app_tools.dart';
import 'package:isouq/Helpers/intro_tutorial/OnBoarding.dart';
import 'dart:async';
import 'package:isouq/login/views/ChooseLoginOrSignup.dart';
import 'common/widgets/BottomNavigationBar.dart';


/// Component UI
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

/// Component UI
class _SplashScreenState extends State<SplashScreen> {
  final firebaseSharedInstance = FirebaseMethods.sharedInstance;

  /// Check user
  bool _isUserFirstTimeLogin = true;

  _isUserLogin() async {
    bool isLogin =
    await getBoolDataLocally(key: firebaseSharedInstance.loggedIN);
    if (isLogin) {
      String id =
      await getStringDataLocally(key: firebaseSharedInstance.profileId);
      firebaseSharedInstance.currentProfileId = id;
      firebaseSharedInstance.streamProfile();

      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (BuildContext context) => new bottomNavigationBar()));
    } else {
      setState(() {
        if (getDataLocally(key: "username") != null) {
          print('true');
          _isUserFirstTimeLogin = true;
        } else {
          print('false');
          _isUserFirstTimeLogin = false;
        }
      });
      startTime();
    }
  }

  /// Setting duration in splash screen
  startTime() async {
    return new Timer(Duration(milliseconds: 4500), navigatorPage);
  }

  /// To navigate layout change
  void navigatorPage() {
    if (_isUserFirstTimeLogin) {
      /// if user has never been login
      Navigator.of(context).pushReplacement(
          PageRouteBuilder(pageBuilder: (_, __, ___) => OnBoarding()));
    } else {
      /// if user has ever been login
      Navigator.of(context).pushReplacement(
          PageRouteBuilder(pageBuilder: (_, __, ___) => ChooseLogin()));
    }
  }

  /// Declare startTime to InitState
  @override
  void initState() {
    _isUserLogin();
    super.initState();
  }

  /// Code Create UI Splash Screen
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow,
      body: Container(
        /// Set Background image in splash screen layout (Click to open code)
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/img/wood_games.jpg'), fit: BoxFit.cover)),
        child: Container(
          /// Set gradient black in image splash screen (Click to open code)
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [
                    Color.fromRGBO(0, 0, 0, 0.3),
                    Color.fromRGBO(0, 0, 0, 0.4)
                  ],
                  begin: FractionalOffset.topCenter,
                  end: FractionalOffset.bottomCenter)),
          child: Center(
            child: SingleChildScrollView(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 30.0),
                    ),

                    /// Text header "Welcome To" (Click to open code)
                    Text(
                      tr('welcomeTo'),
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w200,
                        fontFamily: "Sans",
                        fontSize: 19.0,
                      ),
                    ),

                    /// Animation text i-software Shop to choose Login with Hero Animation (Click to open code)
                    Hero(
                      tag: "i-software",
                      child: Text(
                        tr('title'),
                        style: TextStyle(
                          fontFamily: 'Sans',
                          fontWeight: FontWeight.w900,
                          fontSize: 35.0,
                          letterSpacing: 0.4,
                          color: Colors.black,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}