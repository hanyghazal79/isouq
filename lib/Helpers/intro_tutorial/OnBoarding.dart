import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:isouq/login/views/ChoseLoginOrSignup.dart';
import 'package:isouq/common/text_styles/text_styles.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:isouq/Helpers/Library/intro_views_flutter-2.4.0/lib/Models/page_view_model.dart';
import 'package:isouq/Helpers/Library/intro_views_flutter-2.4.0/lib/intro_views_flutter.dart';


class onBoarding extends StatefulWidget {
  @override
  _onBoardingState createState() => _onBoardingState();
}


///
/// Page View Model for on boarding
///
final pages = [
  new PageViewModel(
      pageColor:  Colors.yellow,
      iconColor: Colors.black,
      bubbleBackgroundColor: Colors.black,
      title: Text(
        tr('e-commerce'),style: fontHeaderStyle(),
      ),
      body: Container(
        height: 250.0,
        child: Text(
          tr('slogan'),textAlign: TextAlign.center,
          style: fontDescriptionStyle()
        ),
      ),
      mainImage: Image.asset(
        'assets/imgIllustration/IlustrasiOnBoarding1.png',
        height: 285.0,
        width: 285.0,
        alignment: Alignment.center,
      )),

  new PageViewModel(
      pageColor:  Colors.yellow,
      iconColor: Colors.black,
      bubbleBackgroundColor: Colors.black,
      title: Text(
        tr('choose_item'),style: fontHeaderStyle(),
      ),
      body: Container(
        height: 250.0,
        child: Text(
            tr('choose'),textAlign: TextAlign.center,
            style: fontDescriptionStyle()
        ),
      ),
      mainImage: Image.asset(
        'assets/imgIllustration/IlustrasiOnBoarding2.png',
        height: 285.0,
        width: 285.0,
        alignment: Alignment.center,
      )),

  new PageViewModel(
      pageColor:  Colors.yellow,
      iconColor: Colors.black,
      bubbleBackgroundColor: Colors.black,
      title: Text(
        tr('but_item_header'),style: fontHeaderStyle(),
      ),
      body: Container(
        height: 250.0,
        child: Text(
            tr('buy_item'),textAlign: TextAlign.center,
            style: fontDescriptionStyle()
        ),
      ),
      mainImage: Image.asset(
        'assets/imgIllustration/IlustrasiOnBoarding3.png',
        height: 285.0,
        width: 285.0,
        alignment: Alignment.center,
      )),

];

class _onBoardingState extends State<onBoarding> {
  @override
  Widget build(BuildContext context) {
    return IntroViewsFlutter(
      pages,
      pageButtonsColor: Colors.black45,
      skipText: Text(tr("skip"),style: fontDescriptionStyle().copyWith(color: Colors.black,fontWeight: FontWeight.w800,letterSpacing: 1.0),),
      doneText: Text(tr("done"),style: fontDescriptionStyle().copyWith(color: Colors.black,fontWeight: FontWeight.w800,letterSpacing: 1.0),),
      onTapDoneButton: ()async {

     SharedPreferences prefs;
    prefs = await SharedPreferences.getInstance();
       prefs.setString("username", "Login");
        Navigator.of(context).pushReplacement(PageRouteBuilder(pageBuilder: (_,__,___)=> new ChoseLogin(),
        transitionsBuilder: (_,Animation<double> animation,__,Widget widget){
          return Opacity(
            opacity: animation.value,
            child: widget,
          );
        },
        transitionDuration: Duration(milliseconds: 1500),
        ));
      },
    );
  }
}

