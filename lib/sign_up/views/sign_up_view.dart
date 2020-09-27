import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:isouq/Helpers/app_tools.dart';
import 'package:isouq/common/animations/animations.dart';
import 'package:isouq/common/static_vars/static_vars.dart';
import 'package:isouq/common/ui_events/ui_events.dart';
import 'package:isouq/common/widgets/custom_text_field.dart';
import 'package:isouq/login/views/login_view.dart';
import 'package:isouq/sign_up/viewmodels/sign_up_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:isouq/common/widgets/button_black_bottom.dart';


// final _emailController = TextEditingController();
// final _passwordController = TextEditingController();
// final _rePasswordController = TextEditingController();
// final _nameController = TextEditingController();

var tap = 0;


AnimationController sanimationController;
AnimationController animationControllerScreen;
Animation animationScreen;

Future<Null> _playAnimation() async {
  try {
    await sanimationController.forward();
    await sanimationController.reverse();
  } on TickerCanceled {}
}

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> with TickerProviderStateMixin {

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  SignUpViewModel _viewModel;

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _rePasswordController = TextEditingController();
  TextEditingController _nameController = TextEditingController();

  //Animation Declaration
  /// Set AnimationController to initState
  @override
  void initState() {
    Universal.textOfButton = tr('signUp');
    sanimationController =
    AnimationController(vsync: this, duration: Duration(milliseconds: 800))
      ..addStatusListener((status) {
        if (status == AnimationStatus.dismissed) {
          setState(() {
            tap = 0;
          });
        }
      });
    _viewModel = Provider.of<SignUpViewModel>(context,listen: false);
    _initiateUiEvents(context);

    super.initState();
  }

  /// Dispose animationController
  @override
  void dispose() {
    sanimationController.dispose();
    // _rePasswordController.dispose();
    // _passwordController.dispose();
    // _emailController.dispose();
    // _nameController.dispose();
    // _viewModel.dispose();
    super.dispose();
  }


  _initiateUiEvents(BuildContext context) {

    _viewModel.eventsStream.stream.listen((event) {
      if (event == UiEvents.loading)
        displayProgressDialog(context);
      else if (event == UiEvents.completed)
        closeProgressDialog(context);
      else if (event == UiEvents.showMessage)
        _showSnackbarMessage(_viewModel.message);
      else if (event == UiEvents.runAnimation)
        _runAnimation();
      else if (event == UiEvents.requestFocus)
        _requestFocus();
    });
  }

  _showSnackbarMessage(String _message)
  {
    setState(() {
      _scaffoldKey.currentState
          .showSnackBar(SnackBar(content: Text(_message)));
    });
  }

  _requestFocus()
  {
    FocusScope.of(context).requestFocus(new FocusNode());
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

  /// Component Widget layout UI
  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    mediaQueryData.devicePixelRatio;
    mediaQueryData.size.height;
    mediaQueryData.size.width;

    return
//      Consumer<SignUpViewModel>(
//      builder: (context, signUpViewModel, child) =>
          Scaffold(
            key: _scaffoldKey,
      body: Stack(
        children: <Widget>[
          Container(
            /// Set Background image in layout
            decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/img/signup_background.jpg"),
                  fit: BoxFit.cover,
                )),
            child: Container(
              /// Set gradient color in image
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromRGBO(0, 0, 0, 0.2),
                    Color.fromRGBO(0, 0, 0, 0.3)
                  ],
                  begin: FractionalOffset.topCenter,
                  end: FractionalOffset.bottomCenter,
                ),
              ),

              /// Set component layout
              ///
              child: ListView(
                padding: EdgeInsets.all(0.0),
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
                                        top: mediaQueryData.padding.top +
                                            40.0)),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Image(
                                      image:
                                      AssetImage("assets/img/Logo.png"),
                                      height: 70.0,
                                    ),
                                    Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10.0)),

                                    /// Animation text i-software shop accept from login layout
                                    Hero(
                                      tag: "iNative Coder",
                                      child: Text(
                                        tr('title'),
                                        style: TextStyle(
                                            fontWeight: FontWeight.w900,
                                            letterSpacing: 0.6,
                                            fontFamily: "Sans",
                                            color: Colors.white,
                                            fontSize: 20.0),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                    padding:
                                    EdgeInsets.symmetric(vertical: 50.0)),

                                /// TextFromField Email
                                CustomTextField(
                                  icon: Icons.email,
                                  password: false,
                                  label:
                                  tr('email'),
                                  inputType: TextInputType.emailAddress,
                                  textEditingController: _emailController,
                                ),
                                Padding(
                                    padding:
                                    EdgeInsets.symmetric(vertical: 5.0)),
                                CustomTextField(
                                  icon: Icons.contacts,
                                  password: false,
                                  label:
                                  tr('name'),
                                  inputType: TextInputType.text,
                                  textEditingController: _nameController,
                                ),
                                Padding(
                                    padding:
                                    EdgeInsets.symmetric(vertical: 5.0)),

                                /// TextFromField Password
                                CustomTextField(
                                  icon: Icons.vpn_key,
                                  password: true,
                                  label: tr('password'),
                                  inputType: TextInputType.text,
                                  textEditingController: _passwordController,
                                ),
                                Padding(
                                    padding:
                                    EdgeInsets.symmetric(vertical: 5.0)),

                                /// TextFromField Password
                                CustomTextField(
                                  icon: Icons.vpn_key,
                                  password: true,
                                  label: tr('re-password'),
                                  inputType: TextInputType.text,
                                  textEditingController:
                                  _rePasswordController,
                                ),

                                /// Button Login
                                FlatButton(
                                    padding: EdgeInsets.only(top: 20.0),
                                    onPressed: () {
                                      Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                              builder:
                                                  (BuildContext context) =>
                                              new LoginScreen()));
                                    },
                                    child: Text(
                                      tr('notHaveLogin'),
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 13.0,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: "Sans"),
                                    )),
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: mediaQueryData.padding.top + 155.0,
                                      bottom: 0.0),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),

//                        _ButtonBlackBottom(this),

                      /// Set Animaion after user click buttonLogin
                      tap == 0
                          ? InkWell(
                        splashColor: Colors.yellow,
                        onTap: () {
                          _viewModel.registerSignUp(_nameController.value.text,_emailController.value.text,_passwordController.value.text,_rePasswordController.value.text);
                        print("clicked");
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
        ],
      ),
    )
//    )
    ;
  }
}