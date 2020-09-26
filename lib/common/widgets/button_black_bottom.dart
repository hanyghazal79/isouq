import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:isouq/common/static_vars/static_vars.dart';
import 'package:isouq/sign_up/views/sign_up_view.dart';

///ButtonBlack class
class ButtonBlackBottom extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return InkWell(
      // onTap: () {
      //   Navigator.of(context).pushReplacement(
      //       MaterialPageRoute(
      //           builder: (BuildContext context) =>
      //           new Signup()
      //       ));
      // },
      child: Padding(
        padding: EdgeInsets.all(30.0),
        child: Container(
          height: 55.0,
          width: 600.0,
          child: Text(
            Universal.textOfButton,
            style: TextStyle(
                color: Colors.black,
                letterSpacing: 0.2,
                fontFamily: "Sans",
                fontSize: 18.0,
                fontWeight: FontWeight.w800),
          ),
          alignment: FractionalOffset.center,
          decoration: BoxDecoration(
              boxShadow: [BoxShadow(color: Colors.black38, blurRadius: 15.0)],
              borderRadius: BorderRadius.circular(30.0),
              gradient: LinearGradient(
                  colors: <Color>[Color(0xfFFFD400), Color(0xfFFFDD3C)])),
        ),
      ),
    );
  }
}