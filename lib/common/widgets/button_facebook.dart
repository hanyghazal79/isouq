//buttonCustomFacebook class
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ButtonCustomFacebook extends StatefulWidget {
  @override
  _ButtonCustomFacebookState createState() => _ButtonCustomFacebookState();
}

class _ButtonCustomFacebookState extends State<ButtonCustomFacebook> {

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Container(
          alignment: FractionalOffset.center,
          height: 49.0,
          width: 500.0,
          decoration: BoxDecoration(
            color: Color.fromRGBO(107, 112, 248, 1.0),
            borderRadius: BorderRadius.circular(40.0),
            boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 15.0)],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                "assets/img/icon_facebook.png",
                height: 25.0,
              ),
              Padding(padding: EdgeInsets.symmetric(horizontal: 7.0)),
              Text(
                tr('loginFacebook'),
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 15.0,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Sans'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}