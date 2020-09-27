import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:isouq/Helpers/app_tools.dart';
import 'package:isouq/common/animations/animations.dart';
import 'package:isouq/common/static_vars/static_vars.dart';
import 'package:isouq/common/ui_events/ui_events.dart';
import 'package:isouq/common/widgets/BottomNavigationBar.dart';
import 'package:isouq/common/widgets/button_black_bottom.dart';
import 'package:isouq/common/widgets/button_facebook.dart';
import 'package:isouq/common/widgets/button_google.dart';
import 'package:isouq/common/widgets/custom_text_field.dart';
import 'package:isouq/login/viewmodels/login_viewmodel.dart';
import 'package:isouq/sign_up/views/sign_up_view.dart';
import 'package:provider/provider.dart';

import '../../sign_up/views/sign_up_view.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

/// Component Widget this layout UI
class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {

  LoginViewModel _viewModel;
  String btnText;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  //Animation Declaration
  AnimationController sanimationController;

  var tap = 0;

  @override

  /// set state animation controller
  void initState() {
    Universal.textOfButton = tr('login');
    sanimationController =
    AnimationController(vsync: this, duration: Duration(milliseconds: 800))
      ..addStatusListener((statuss) {
        if (statuss == AnimationStatus.dismissed) {
          setState(() {
            tap = 0;
          });
        }
      });
    _viewModel = Provider.of<LoginViewModel>(context, listen: false);
    _initiateUiEvents(context);
    super.initState();
  }

  /// Dispose animation controller
  @override
  void dispose() {
    sanimationController.dispose();
    // _passwordController.dispose();
    // _emailController.dispose();
    // _viewModel.dispose();
    super.dispose();
  }

  _initiateUiEvents(BuildContext context)
  {
    _viewModel.eventsStreamController.stream.listen((event) {
      if (event == UiEvents.loading)
        displayProgressDialog(context);
      else if (event == UiEvents.completed)
        closeProgressDialog(context);
      else if (event == UiEvents.runAnimation)
        _runAnimation();
      else if (event == UiEvents.navigateToNavBar)
        _navigateToBotNavBar();
    });
  }

  _navigateToBotNavBar()
  {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (BuildContext context) => new bottomNavigationBar()));
  }
  _runAnimation()
  {
    setState(() {
      tap = 1;
    });
    new LoginAnimation(
      animationController: sanimationController.view,
    );
    _playAnimation();
    return tap;
  }
  /// Play animation set forward reverse
  Future<Null> _playAnimation() async {
    try {
      await sanimationController.forward();
      await sanimationController.reverse();
    } on TickerCanceled {}
  }

  /// Component Widget layout UI
  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    // mediaQueryData.devicePixelRatio;
    mediaQueryData.size.width;
    mediaQueryData.size.height;


    return Scaffold(
      backgroundColor: Colors.yellow,
      body: Container(
        /// Set Background image in layout (Click to open code)
        decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/img/loginscreenbackground.jpg"),
              fit: BoxFit.cover,
            )),
        child: Container(
          /// Set gradient color in image (Click to open code)
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromRGBO(0, 0, 0, 0.0),
                Color.fromRGBO(0, 0, 0, 0.3)
              ],
              begin: FractionalOffset.topCenter,
              end: FractionalOffset.bottomCenter,
            ),
          ),

          /// Set component layout
          child: ListView(
            children: <Widget>[
              Stack(
                alignment: AlignmentDirectional.bottomCenter,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Container(
                        alignment: AlignmentDirectional.topCenter,
                        child: Column(
                          children: <Widget>[
                            /// padding logo
                            Padding(
                                padding: EdgeInsets.only(
                                    top: mediaQueryData.padding.top + 40.0)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                CircleAvatar(
                                  child: Image(
                                    image: AssetImage("assets/img/logo.png"),
                                    height: 150.0,
                                  ),
                                ),
                                Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10.0)),

                                /// Animation text i-software shop accept from signup layout (Click to open code)
                                Hero(
                                  tag: "i-software",
                                  child: Text(
                                    tr('title'),
                                    style: TextStyle(
                                        fontWeight: FontWeight.w900,
                                        letterSpacing: 0.6,
                                        color: Colors.black,
                                        fontFamily: "Sans",
                                        fontSize: 20.0),
                                  ),
                                ),
                              ],
                            ),

                            /// ButtonCustomFacebook
                            Padding(
                                padding:
                                EdgeInsets.symmetric(vertical: 30.0)),
                            /// Set Animaion after user click buttonLogin
                            tap == 0
                                ? InkWell(
                              splashColor: Colors.yellow,
                              onTap: () {
                               _viewModel.loginWithFacebook();
                              },
                              child: ButtonCustomFacebook(),
                            )
                                : new LoginAnimation(
                              animationController: sanimationController.view,
                            ),

                            /// ButtonCustomGoogle
                            Padding(
                                padding: EdgeInsets.symmetric(vertical: 7.0)),
                            /// Set Animaion after user click buttonLogin
                            tap == 0
                                ? InkWell(
                              splashColor: Colors.yellow,
                              onTap: () {
                                 _viewModel.loginWithGoogle();
                              },
                              child: ButtonCustomGoogle(),
                            )
                                : new LoginAnimation(
                              animationController: sanimationController.view,
                            ),

                            /// Set Text
                            Padding(
                                padding:
                                EdgeInsets.symmetric(vertical: 10.0)),
                            Text(
                              tr('or'),
                              style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  color: Colors.black,
                                  letterSpacing: 0.2,
                                  fontFamily: 'Sans',
                                  fontSize: 17.0),
                            ),

                            /// TextFromField Email
                            Padding(
                                padding:
                                EdgeInsets.symmetric(vertical: 10.0)),
                            CustomTextField(
                              icon: Icons.email,
                              password: false,
                              label: tr('email'),
                              inputType: TextInputType.emailAddress,
                              textEditingController: _emailController,
                            ),

                            /// TextFromField Password
                            Padding(
                                padding: EdgeInsets.symmetric(vertical: 5.0)),
                            CustomTextField(
                              icon: Icons.vpn_key,
                              password: true,
                              label:
                              tr('password'),
                              inputType: TextInputType.emailAddress,
                              textEditingController: _passwordController,
                            ),

                            /// Button Signup
                            FlatButton(
                                padding: EdgeInsets.only(top: 20.0),
                                onPressed: () {
                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                          new Signup()
                                      ));
                                },
                                child: Text(
                                  tr('notHave'),
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 13.0,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: "Sans"),
                                )),
                            Padding(
                              padding: EdgeInsets.only(
                                  top: mediaQueryData.padding.top + 100.0,
                                  bottom: 0.0),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  //   _ButtonBlackBottom(this),

                  /// Set Animaion after user click buttonLogin
                  tap == 0
                      ? InkWell(
                    splashColor: Colors.yellow,
                    onTap: () {
                      firebaseSharedInstance.loginUser(email: _emailController.value.text, password: _passwordController.value.text);
                      // _viewModel.loginWithEmailAndPassword(_emailController.value.text, _passwordController.value.text);
                    },
                    child: ButtonBlackBottom(),
                  )
                      : new LoginAnimation(
                    animationController: sanimationController.view,
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

}