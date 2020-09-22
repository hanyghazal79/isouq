import 'package:flutter/material.dart';

class buttonCustom extends StatelessWidget {
  String txt;
  Color color;
  GestureTapCallback ontap;

  buttonCustom({this.txt, this.color, this.ontap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ontap,
      child: Container(
        height: 45.0,
        width: 300.0,
        decoration: BoxDecoration(
          color: color,
        ),
        child: Center(
            child: Text(
              txt,
              style: TextStyle(color: Colors.white, fontFamily: "Sans"),
            )),
      ),
    );
  }
}
