import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:isouq/home/views/home_view.dart';
import 'package:isouq/cart/views/cart_items_list_view.dart';
import 'package:isouq/brands/views/brand_list_view.dart';
import 'package:isouq/profile/views/profile_view.dart';


class bottomNavigationBar extends StatefulWidget {
 @override
 _bottomNavigationBarState createState() => _bottomNavigationBarState();
}

class _bottomNavigationBarState extends State<bottomNavigationBar> {
 int currentIndex = 0;
 /// Set a type current number a layout class
 Widget callPage(int current) {
  switch (current) {
   case 0:
    return new Home();
   case 1:
    return new BrandList();
   case 2:
    return new cart();
   case 3:
    return new profile();
    break;
   default:
    return Home();
  }
 }

 /// Build BottomNavigationBar Widget
 @override
 Widget build(BuildContext context) {
  return Scaffold(
    body: callPage(currentIndex),
    bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
            canvasColor: Colors.yellow,
            textTheme: Theme.of(context).textTheme.copyWith(
                caption: TextStyle(color: Colors.black54.withOpacity(0.15)))),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: currentIndex,
          fixedColor: Colors.black,
          onTap: (value) {
            currentIndex = value;
            setState(() {});
          },
          items: [
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                  size: 23.0,
                ),
                title: Text(
                  tr('home'),
                  style: TextStyle(fontFamily: "Berlin", letterSpacing: 0.5),
                )),
            BottomNavigationBarItem(
                icon: Icon(Icons.shop),
                title: Text(
                  tr('brand'),
                  style: TextStyle(fontFamily: "Berlin", letterSpacing: 0.5),
                )),
            BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart),
                title: Text(
                  tr('cart'),
                  style: TextStyle(fontFamily: "Berlin", letterSpacing: 0.5),
                )),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.person,
                  size: 24.0,
                ),
                title: Text(
                  tr('account'),
                  style: TextStyle(fontFamily: "Berlin", letterSpacing: 0.5),
                )),
          ],
        )),

  );
 }
}

