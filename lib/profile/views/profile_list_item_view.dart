import 'package:flutter/material.dart';
import 'package:isouq/common/text_styles/text_styles.dart';

/// Component category class to set list
class ProfileListItemView extends StatelessWidget {
  @override
  String txt, image;
  GestureTapCallback tap;
  double padding;

  ProfileListItemView({this.txt, this.image, this.tap, this.padding});

  Widget build(BuildContext context) {
    return InkWell(
      onTap: tap,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 15.0, left: 30.0),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(right: padding),
                  child: ColorFiltered(
                    colorFilter: ColorFilter.mode(
                      Colors.grey,
                      BlendMode.srcATop,
                    ),
                    child: Image.asset(
                      image,
                      height: 25.0,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: Text(
                    txt,
                    style: txtCategory(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}