import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:isouq/Firebase/firebase_methods.dart';
import 'package:isouq/Helpers/Library/carousel_pro/carousel_pro.dart';
import 'package:isouq/Helpers/app_tools.dart';
import 'package:isouq/common/animations/animations.dart';
import 'package:isouq/common/ui_events/ui_events.dart';
import 'package:isouq/common/widgets/BottomNavigationBar.dart';
import 'package:isouq/common/widgets/custom_button.dart';
import 'package:isouq/login/viewmodels/login_viewmodel.dart';
import 'package:provider/provider.dart';

var firebase = FirebaseMethods.sharedInstance;

class ChooseLogin extends StatefulWidget {
  @override
  _ChooseLoginState createState() => _ChooseLoginState();
}

/// Component Widget this layout UI
class _ChooseLoginState extends State<ChooseLogin> with TickerProviderStateMixin {
  final firebaseSharedInstance = FirebaseMethods.sharedInstance;

  LoginViewModel _viewModel;


  /// Declare Animation
  AnimationController animationController;
  var tapLogin = 0;
  var tapSignup = 0;
  var tap = 0;

  @override

  /// Declare animation in initState
  void initState() {
    // TODO: implement initState
    /// Animation proses duration
    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300))
          ..addStatusListener((statuss) {
            if (statuss == AnimationStatus.dismissed) {
              setState(() {
                tapLogin = 0;
                tapSignup = 0;
                tap = 0;
              });
            }
          });
    _viewModel = Provider.of<LoginViewModel>(context,listen: false);
    _initiateUiEvents(context);
    super.initState();
  }

  /// To dispose animation controller
  @override
  void dispose() {
    animationController.dispose();
//    _viewModel.dispose();
    super.dispose();
    // TODO: implement dispose
  }

  _initiateUiEvents(BuildContext context)
  {
    _viewModel.eventsStreamController.stream.listen((event) {
      if (event == UiEvents.loading)
        displayProgressDialog(context);
      else if (event == UiEvents.completed)
        closeProgressDialog(context);
      else if (event == UiEvents.navigateToNavBar)
        _navigateToBotNavBar();
      else if (event == UiEvents.runAnimation)
        _runAnimation();

    });
  }

  _runAnimation()
  {
    setState(() {
      tap = 1;
    });
    new LoginAnimation(
      animationController: animationController.view,
    );
    _playAnimation();
    return tap;
  }

  _navigateToBotNavBar()
  {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (BuildContext context) => new bottomNavigationBar()));
  }

  /// Play animation set forward reverse
  Future<Null> _playAnimation() async {

    try {
      await animationController.forward();
      await animationController.reverse();
    } on TickerCanceled {}
  }

  /// Component Widget layout UI
  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    mediaQuery.devicePixelRatio;
    mediaQuery.size.height;
    mediaQuery.size.width;

    return Scaffold(
      backgroundColor: Colors.yellow,
      body: Stack(
        children: <Widget>[
          ///
          /// Set background image slider
          ///
          Container(
            color: Colors.yellow,
            child: new Carousel(
              boxFit: BoxFit.cover,
              autoplay: true,
              animationDuration: Duration(milliseconds: 300),
              dotSize: 0.0,
              dotSpacing: 16.0,
              dotBgColor: Colors.transparent,
              showIndicator: false,
              overlayShadow: false,
              images: [
                AssetImage('assets/img/girl.jpg'),
                AssetImage("assets/img/SliderLogin2.jpg"),
                AssetImage('assets/img/SliderLogin3.jpg'),
                AssetImage("assets/img/SliderLogin4.jpg"),
              ],
            ),
          ),
          Container(
            /// Set Background image in layout (Click to open code)
            decoration: BoxDecoration(
//              image: DecorationImage(
//                  image: AssetImage('assets/img/girl.png'), fit: BoxFit.cover)
                ),
            child: Container(
              /// Set gradient color in image (Click to open code)
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [
                    Color.fromRGBO(0, 0, 0, 0.3),
                    Color.fromRGBO(0, 0, 0, 0.4)
                  ],
                      begin: FractionalOffset.topCenter,
                      end: FractionalOffset.bottomCenter)),

              /// Set component layout
              child: ListView(
                padding: EdgeInsets.all(0.0),
                children: <Widget>[
                  Stack(
                    alignment: AlignmentDirectional.bottomCenter,
                    children: <Widget>[
                      Stack(
                        alignment: AlignmentDirectional.bottomCenter,
                        children: <Widget>[
                          Container(
                            alignment: AlignmentDirectional.center,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: mediaQuery.padding.top + 50.0),
                                ),
                                Center(
                                  /// Animation text i-software shop accept from splashscreen layout (Click to open code)
                                  child: Hero(
                                    tag: "i-software",
                                    child: Text(
                                      tr('title'),
                                      style: TextStyle(
                                        fontFamily: 'Sans',
                                        fontWeight: FontWeight.w900,
                                        fontSize: 32.0,
                                        letterSpacing: 0.4,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),

                                /// Padding Text "Get best product in i-software shop" (Click to open code)
                                Padding(
                                    padding: EdgeInsets.only(
                                        left: 160.0,
                                        right: 160.0,
                                        top: mediaQuery.padding.top + 190.0,
                                        bottom: 10.0),
                                    child: Container(
                                      color: Colors.black,
                                      height: 0.5,
                                    )),

                                /// to set Text "get best product...." (Click to open code)
                                Text(
                                  tr('hintChoseLogin'),
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 17.0,
                                      fontWeight: FontWeight.w200,
                                      fontFamily: "Sans",
                                      letterSpacing: 1.3),
                                ),
                                Padding(padding: EdgeInsets.only(top: 250.0)),
                              ],
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              /// To create animation if user tap == animation play (Click to open code)
                              tapLogin == 0
                                  ? Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        splashColor: Colors.black,
                                        onTap: () {
                                          setState(() {
                                            tapLogin = 1;
                                          });
                                          _playAnimation();
                                          return tapLogin;
                                        },
                                        child: ButtonCustom(txt: tr('signUp')),
                                      ),
                                    )
                                  : AnimationSplashSignup(
                                      animationController:
                                          animationController.view,
                                    ),
                              Padding(padding: EdgeInsets.only(top: 15.0)),
                              Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    /// To set black line (Click to open code)
                                    Container(
                                      color: Colors.black,
                                      height: 0.2,
                                      width: 80.0,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: 10.0, right: 10.0),

                                      /// navigation to home screen if user click "OR SKIP" (Click to open code)
                                      child: InkWell(
                                        onTap: () {
                                          // signInAnonymously to firebase
                                          _viewModel.loginAnonymously();
                                        },
                                        child: Text(
                                          tr('orSkip'),
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w100,
                                              fontFamily: "Sans",
                                              fontSize: 15.0),
                                        ),
                                      ),
                                    ),

                                    /// To set black line (Click to open code)
                                    Container(
                                      color: Colors.black,
                                      height: 0.2,
                                      width: 80.0,
                                    )
                                  ],
                                ),
                              ),
                              Padding(padding: EdgeInsets.only(top: 70.0)),
                            ],
                          ),

                          /// To create animation if user tap == animation play (Click to open code)
                          tapSignup == 0
                              ? Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    splashColor: Colors.yellow,
                                    onTap: () {
                                      setState(() {
                                        tapSignup = 1;
                                      });
                                      _playAnimation();
                                      return tapSignup;
                                    },
                                    child: ButtonCustom(txt: tr('login')),
                                  ),
                                )
                              : AnimationSplashLogin(
                                  animationController: animationController.view,
                                ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
