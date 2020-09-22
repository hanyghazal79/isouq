import 'package:flutter/material.dart';
import 'package:isouq/home/views/CategoryDetail.dart';
import 'package:isouq/home/views/MenuDetail.dart';
import 'package:isouq/profile/models/item_model.dart';

/// Component category item bellow FlashSale
class CategoryItemValue extends StatelessWidget {
  ItemModel category;

  CategoryItemValue({this.category});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(PageRouteBuilder(
            pageBuilder: (_, __, ___) =>
            new CategoryDetail(
                category: category),
            transitionDuration: Duration(milliseconds: 750),
            transitionsBuilder:
                (_, Animation<double> animation, __, Widget child) {
              return Opacity(
                opacity: animation.value,
                child: child,
              );
            }));
      },
      child: Container(
        height: 105.0,
        width: 160.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(3.0)),
          image: DecorationImage(
              image: (category.image == null || category.image.isEmpty)
                  ? AssetImage('assets/img/Logo.png')
                  : NetworkImage(category.image.elementAt(0)),
              fit: BoxFit.cover),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(3.0)),
            color: Colors.black.withOpacity(0.25),
          ),
          child: Center(
              child: Text(
                category.title,
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: "Berlin",
                  fontSize: 18.5,
                  letterSpacing: 0.7,
                  fontWeight: FontWeight.w800,
                ),
              )),
        ),
      ),
    );
  }
}

/// Component item Menu icon bellow a ImageSlider
class CategoryIconValue extends StatelessWidget {
  final ItemModel item;
  final BuildContext context;

  CategoryIconValue({
    this.item,
    this.context
  });

//  GestureTapCallback tap1;

  onClickWeekMenuIcon() {
    Navigator.of(context).push(PageRouteBuilder(
        pageBuilder: (_, __, ___) =>
        new menuDetail(item),
        transitionDuration: Duration(milliseconds: 750),

        /// Set animation with opacity
        transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
          return Opacity(
            opacity: animation.value,
            child: child,
          );
        }));
  }


  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClickWeekMenuIcon,
      child: Column(
        children: <Widget>[
          Container(
            height: 30,
            color: Colors.yellow,
            child: Image.network(
              item.image.elementAt(0),
              fit: BoxFit.fill,
            ),
          ),
          Padding(padding: EdgeInsets.only(top: 7.0)),
          Text(
            item.title,
            style: TextStyle(
              fontFamily: "Sans",
              fontSize: 13.0,
              fontWeight: FontWeight.w500,
            ),
          )
        ],
      ),
    );
  }
}