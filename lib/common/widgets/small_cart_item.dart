import 'package:flutter/material.dart';

import 'custom_text.dart';

class SmallCartItem extends StatelessWidget {
  final String image;
  final String name;
  final String points;

  SmallCartItem({this.name, this.image,this.points});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
            width: MediaQuery.of(context).size.width,
            height: 70,
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: 10,
                ),
                CircleAvatar(
                  radius: 30,
                  backgroundImage: (image == null || image.isEmpty )? AssetImage(
                      "assets/img/person-imag.jpg") :NetworkImage(image),
                ),
                SizedBox(
                  width: 50,
                ),
                CustomText(name + ' - $points نقطة ', 12)  //Todo: add localization here
              ],
            )),
      ],
    );
  }
}
