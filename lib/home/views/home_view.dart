import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:isouq/home/views/app_bar_gradient_view.dart';
import 'package:isouq/home/views/home_banner_view.dart';
import 'package:isouq/home/views/home_category_view.dart';
import 'package:isouq/home/views/home_flash_sale_view.dart';
import 'package:isouq/home/views/home_menu_view.dart';
import 'package:isouq/home/views/home_promotion_view.dart';
import 'package:isouq/home/views/home_recommended.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

/// Component all widget in home
class _HomeState extends State<Home> with TickerProviderStateMixin {
//  GoogleAdMob _googleAdMob = GoogleAdMob();


  bool _showAppbar = true; //this is to show app bar
  ScrollController _scrollBottomBarController = new ScrollController(); // set controller on scrolling
  bool isScrollingDown = false;
  bool _show = true;
  double bottomBarHeight ; // set bottom bar height

  @override
  void initState() {
    super.initState();
    appBarScroll();
  }


  @override
  void dispose() {
    _scrollBottomBarController.removeListener(() {});
    super.dispose();

  }

  void showBottomBar() {
    setState(() {
      _show = true;
    });
  }

  void hideBottomBar() {
    setState(() {
      _show = false;
    });
  }

  void appBarScroll() async {
    _scrollBottomBarController.addListener(() {
      if (_scrollBottomBarController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (!isScrollingDown) {
          isScrollingDown = true;
          _showAppbar = false;
          hideBottomBar();
        }
      }
      if (_scrollBottomBarController.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (isScrollingDown) {
          isScrollingDown = false;
          _showAppbar = true;
          showBottomBar();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    bottomBarHeight = mediaQueryData.padding.top + 58.5;
    return Scaffold(
      appBar: _showAppbar
          ? AppBar(flexibleSpace:AppbarGradient(),)
          : PreferredSize(
        child: Container(),
        preferredSize: Size(0.0, 0.0),
      ),
      /// Use Stack to costume a appbar
      body:
      Stack(
        children: <Widget>[

      ListView(
              controller: _scrollBottomBarController,
              children: <Widget>[
//               _googleAdMob.loadBannerAdd(),
                /// Call var imageSlider
                HomeBannerView(),

                /// Call var categoryIcon
                HomeMenuView(),
                Padding(
                  padding: EdgeInsets.only(top: 10.0),
                ),

                /// Call var PromoHorizontalList
                HomePromotionView(),

                /// Call var a FlashSell, i am sorry Typo :v
                HomeFlashSaleView(),
                Padding(
                  padding: EdgeInsets.only(top: 10.0),
                ),
                HomeCategoryView(),
                Padding(
                  padding: EdgeInsets.only(bottom: 10.0),
                ),

                /// Call a Grid variable, this is item list in Recomended item
                HomeRecommendedListView(),
              ],
            ),
        ],
      ),
    );
  }
}