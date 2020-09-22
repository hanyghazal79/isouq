// Constructor for itemCard for List Menu
import 'package:flutter/material.dart';
import 'package:isouq/home/horizontal_item_list.dart';
import 'package:isouq/profile/models/item_model.dart';

class BrandItemCard extends StatefulWidget {
  /// Declaration and Get data from BrandDataList.dart
  final ItemModel category;

  BrandItemCard(this.category);

  _BrandItemCardState createState() => _BrandItemCardState();
}

class _BrandItemCardState extends State<BrandItemCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
      const EdgeInsets.only(left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
      child: InkWell(
        onTap: () {
          Navigator.of(context).pushAndRemoveUntil(
              PageRouteBuilder(
                  pageBuilder: (_, __, ___) => HorizontalItemList(id: widget.category.id,title: widget.category.title, isRecommendedList: false),
                  transitionDuration: Duration(milliseconds: 600),
                  transitionsBuilder:
                      (_, Animation<double> animation, __, Widget child) {
                    return Opacity(
                      opacity: animation.value,
                      child: child,
                    );
                  }),
                  (Route<dynamic> route) => true);
        },
        child: Container(
          height: 130.0,
          width: 400.0,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(15.0))),
          child: Hero(
            tag: 'hero-tag-${widget.category.id}',
            transitionOnUserGestures: true,
            child: Material(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: (widget.category.image == null ||
                          widget.category.image.isEmpty)
                          ? AssetImage('assets/img/Logo.png')
                          : NetworkImage(widget.category.image.elementAt(0))),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFFABABAB).withOpacity(0.3),
                      blurRadius: 1.0,
                      spreadRadius: 2.0,
                    ),
                  ],
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    color: Colors.black12.withOpacity(0.1),
                  ),
                  child: Center(
                    child: Text(
                      widget.category.title,
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: "Berlin",
                        fontSize: 35.0,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}