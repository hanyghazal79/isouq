import 'package:flutter/material.dart';

import 'custom_text.dart';



class DrawerListTile extends StatelessWidget {
  final String title;
  final Widget child;
  final Image image;

  DrawerListTile({this.title, this.child, this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListTile(
        title: CustomText(title,12),
        leading: image,
        onTap: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (BuildContext context) => child));
        },
      ),
    );
  }
}

