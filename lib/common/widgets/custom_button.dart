
import 'package:flutter/material.dart';

/// Button Custom widget
class ButtonCustom extends StatelessWidget {
  String txt;
  GestureTapCallback ontap;

  ButtonCustom({this.txt});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        splashColor: Colors.black,
        child: LayoutBuilder(builder: (context, constraint) {
          return Container(
            width: 300.0,
            height: 52.0,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.0),
                color: Colors.yellow,
                border: Border.all(color: Colors.black)),
            child: Center(
                child: Text(
                  txt,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 19.0,
                      fontWeight: FontWeight.w600,
                      fontFamily: "Sans",
                      letterSpacing: 0.5),
                )),
          );
        }),
      ),
    );
  }
}