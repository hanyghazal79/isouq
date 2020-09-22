import 'package:flutter/material.dart';
import 'package:isouq/common/text_styles/text_styles.dart';

gradientAppBar(String title, {List<Widget> actions}) => AppBar(
     iconTheme: IconThemeData(color: Colors.grey),
      actions: actions,
      centerTitle: true,
      title: Text(
        title,
        style: cartTextSyle(),
      ),
      flexibleSpace: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[
                  Colors.yellow,
                  Colors.yellowAccent,
                ])),
      ),
    );