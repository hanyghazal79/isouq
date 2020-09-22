import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:isouq/Firebase/firebase_methods.dart';
import 'package:isouq/common/widgets/gradient_app_bar.dart';
import 'package:isouq/home/views/item_details_view.dart';
import 'package:isouq/profile/models/item_model.dart';
import 'package:isouq/home/Search.dart';
import 'package:shimmer/shimmer.dart';

final firebaseSharedInstance = FirebaseMethods.sharedInstance;
List<ItemModel> subItems = new List();

class menuDetail extends StatefulWidget {
  final ItemModel item;

  menuDetail(this.item);

  @override
  _menuDetailState createState() => _menuDetailState();
}

/// Component widget MenuDetail
class _menuDetailState extends State<menuDetail> {
  ///
  /// Get image data dummy from firebase server
  ///
  var imageNetwork = NetworkImage(
      "https://firebasestorage.googleapis.com/v0/b/beauty-look.appspot.com/o/a.jpg?alt=media&token=e36bbee2-4bfb-4a94-bd53-4055d29358e2");

  ///
  /// check the condition is right or wrong for image loaded or no
  ///
  bool loadImage = true;

  /// Custom text
  static var _customTextStyleBlack = TextStyle(
      fontFamily: "Gotik",
      color: Colors.black,
      fontWeight: FontWeight.w700,
      fontSize: 15.0);

  /// Custom Text Blue Color
  static var _customTextStyleBlue = TextStyle(
      fontFamily: "Gotik",
      color: Color(0xFF6991C7),
      fontWeight: FontWeight.w700,
      fontSize: 15.0);

  ///
  /// SetState after imageNetwork loaded to change list card
  ///

  @override
  void initState() {
    Timer(Duration(seconds: 3), () {
      setState(() {
        loadImage = false;
      });
    });
    // imageNetwork.resolve(ImageConfiguration()).addListener((_,__){
    //   if(mounted){
    //     setState(() {
    //       loadImage=false;
    //     });
    //   }
    // });

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    /// Item first above "Week Promotion" with image Promotion
    var _promoHorizontalList = Container(
      color: Colors.white,
      height: 215.0,
      padding: EdgeInsets.only(bottom: 40.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
              padding: EdgeInsets.only(
                  left: 20.0, top: 10.0, bottom: 3.0, right: 20.0),
              child: Text(tr('weekPromotion'), style: _customTextStyleBlack)),
          Expanded(
            child: ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.only(top: 10.0),
                scrollDirection: Axis.horizontal,
                itemCount: subItems.length,
                itemBuilder: (BuildContext context, index) {
                  if (subItems.length == 0 || subItems == null) {
                    return Center(
                      child: Text('noItems'),
                    );
                  } else {
                    return Row(
                      children: <Widget>[
                        Padding(padding: EdgeInsets.only(left: 20.0)),
                        itemPopular(
                          image: subItems[index].image.elementAt(0),
                          title: subItems[index].title,
                        ),
                      ],
                    );
                  }
                }),
          ),
        ],
      ),
    );

    /// SubCategory item
    var _subCategory = Container(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 20.0, left: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  tr('subCategory'),
                  style: _customTextStyleBlack,
                ),
                InkWell(
                  onTap: null,
                  child: Text(tr('seeMore'), style: _customTextStyleBlue),
                ),
              ],
            ),
          ),
          SingleChildScrollView(
            child: Container(
              color: Colors.white,
              margin: EdgeInsets.only(right: 10.0, top: 15.0),
              height: 110.0,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  /// Get keyword item class in Search.dart
                  Padding(padding: EdgeInsets.only(left: 20.0)),
                  KeywordItem(
                    title: tr('action'),
                    title2: tr('drone'),
                  ),
                  Padding(padding: EdgeInsets.only(left: 15.0)),
                  KeywordItem(
                    title: tr('digital'),
                    title2: tr('handyCam'),
                  ),
                  Padding(padding: EdgeInsets.only(left: 15.0)),
                  KeywordItem(
                    title: tr('analog'),
                    title2: tr('cctv'),
                  ),
                  Padding(padding: EdgeInsets.only(left: 15.0)),
                  KeywordItem(
                    title: tr('spyCam'),
                    title2: tr('accesoris'),
                  ),
                  Padding(padding: EdgeInsets.only(right: 20.0)),
                ],
              ),
            ),
          )
        ],
      ),
    );

    /// Item New
    var _itemNew = new Padding(
      padding: const EdgeInsets.only(top: 30.0),
      child: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 20.0, left: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    tr('newItem'),
                    style: _customTextStyleBlack,
                  ),
                  InkWell(
                    onTap: null,
                    child: Text(tr('seeMore'), style: _customTextStyleBlue),
                  ),
                ],
              ),
            ),
            SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.only(right: 10.0, bottom: 15.0),
                height: 300.0,

                ///
                ///
                /// check the condition if image data from server firebase loaded or no
                /// if image true (image still downloading from server)
                /// Card to set card loading animation
                ///
                ///
                child: loadImage
                    ? _loadingImageAnimation(context)
                    : ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (BuildContext context, int index) =>
                            menuItemCard(subItems[index]),
                        itemCount: subItems.length,
                      ),
              ),
            )
          ],
        ),
      ),
    );

    return Scaffold(
      appBar: gradientAppBar(widget.item.title, actions: <Widget>[
          InkWell(
            onTap: () {
              Navigator.of(context).push(PageRouteBuilder(
                  pageBuilder: (_, __, ___) => new SearchAppbar()));
            },
            child: IconButton(
              onPressed: null,
              icon: Icon(Icons.search, color: Color(0xFF6991C7)),
            ),
          ),
        ],),


      body: SingleChildScrollView(
        child: StreamBuilder(
            stream: firebaseSharedInstance.getSubItems(type: firebaseSharedInstance.item,parentId: widget.item.id),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                var list=snapshot.data.documents as List;
                subItems = list.map((i)=>ItemModel.fromDocumentSnapshot(i)).toList();
                return Container(
                  color: Colors.white,
                  child: Column(
                    children: <Widget>[
                      /// Get a variable
                      _promoHorizontalList,
                      _itemNew

//                _subCategory,
//                _itemDiscount,
//                _itemPopular,
//                _itemNew
                    ],
                  ),
                );
              }
            }),
      ),
    );
  }
}

///Item Popular component class
class itemPopular extends StatelessWidget {
  String image, title;

  itemPopular({this.image, this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 130.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
        image: DecorationImage(image: NetworkImage(image), fit: BoxFit.cover),
      ),
      child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
            color: Colors.black.withOpacity(0.3),
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 80.0, left: 10.0),
            child: Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontFamily: "Gotik",
                fontSize: 15.5,
                letterSpacing: 0.7,
                fontWeight: FontWeight.w600,
              ),
            ),
          )),
    );
  }
}

class menuItemCard extends StatelessWidget {
  ItemModel item;

  menuItemCard(this.item);

  getDiscount() {
    var discount =
        (int.parse(item.newPrice) * 100) / int.parse(item.price);
    discount = 100 - discount;
    String finalDiscount = discount.toInt().toString() + " %";
    return finalDiscount;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          top: 20.0, left: 10.0, bottom: 10.0, right: 0.0),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(PageRouteBuilder(
              pageBuilder: (_, ___, ____) => new ItemDetails(item: item,)));
        },
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              boxShadow: [
                BoxShadow(
                  color: Color(0xFF656565).withOpacity(0.15),
                  blurRadius: 2.0,
                  spreadRadius: 1.0,
//           offset: Offset(4.0, 10.0)
                )
              ]),
          child: Wrap(
            children: <Widget>[
              Container(
                width: 160.0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        Container(
                          height: 185.0,
                          width: 160.0,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(7.0),
                                  topRight: Radius.circular(7.0)),
                              image: DecorationImage(
                                  image: NetworkImage(item.image.elementAt(0)),
                                  fit: BoxFit.cover)),
                        ),
                        item.newPrice.isNotEmpty
                            ?Container(
                          height: 25.5,
                          width: 55.0,
                          decoration: BoxDecoration(
                              color: Color(0xFFD7124A),
                              borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(20.0),
                                  topLeft: Radius.circular(5.0))),
                          child: Center(
                              child: Text(
                             getDiscount() ,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600),
                          )),
                        )
                            : SizedBox()
                      ],
                    ),
                    Padding(padding: EdgeInsets.only(top: 7.0)),
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                      child: Text(
                        item.title,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            letterSpacing: 0.5,
                            color: Colors.black54,
                            fontFamily: "Sans",
                            fontWeight: FontWeight.w500,
                            fontSize: 13.0),
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(top: 1.0)),
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                      child: Text(
                        "${item.price} EGP",
                          style: TextStyle(
                            fontFamily: "Sans",
                            fontWeight: FontWeight.w500,
                            fontSize: 14.0),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 15.0, right: 15.0, top: 5.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Text(
                                item.rating,
                                style: TextStyle(
                                    fontFamily: "Sans",
                                    color: Colors.black26,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12.0),
                              ),
                              Icon(
                                Icons.star,
                                color: Colors.yellow,
                                size: 14.0,
                              )
                            ],
                          ),
                          Text(
                            item.sale,
                            style: TextStyle(
                                fontFamily: "Sans",
                                color: Colors.black26,
                                fontWeight: FontWeight.w500,
                                fontSize: 12.0),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

///
///
///
/// Loading Item Card Animation Constructor
///
///
///
class loadingMenuItemCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          top: 20.0, left: 10.0, bottom: 10.0, right: 0.0),
      child: InkWell(
        onTap: () {},
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              boxShadow: [
                BoxShadow(
                  color: Color(0xFF656565).withOpacity(0.15),
                  blurRadius: 2.0,
                  spreadRadius: 1.0,
//           offset: Offset(4.0, 10.0)
                )
              ]),
          child: Wrap(
            children: <Widget>[
              Shimmer.fromColors(
                baseColor: Colors.black38,
                highlightColor: Colors.white,
                child: Container(
                  width: 160.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                          Container(
                            height: 185.0,
                            width: 160.0,
                            color: Colors.black12,
                          ),
                          Container(
                            height: 25.5,
                            width: 65.0,
                            decoration: BoxDecoration(
                                color: Color(0xFFD7124A),
                                borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(20.0),
                                    topLeft: Radius.circular(5.0))),
                          )
                        ],
                      ),
                      Padding(
                          padding: const EdgeInsets.only(
                              left: 10.0, right: 5.0, top: 12.0),
                          child: Container(
                            height: 9.5,
                            width: 130.0,
                            color: Colors.black12,
                          )),
                      Padding(
                          padding: const EdgeInsets.only(
                              left: 10.0, right: 5.0, top: 10.0),
                          child: Container(
                            height: 9.5,
                            width: 80.0,
                            color: Colors.black12,
                          )),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 15.0, right: 15.0, top: 15.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Text(
                                  "",
                                  style: TextStyle(
                                      fontFamily: "Sans",
                                      color: Colors.black26,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12.0),
                                ),
                                Icon(
                                  Icons.star,
                                  color: Colors.yellow,
                                  size: 14.0,
                                )
                              ],
                            ),
                            Container(
                              height: 8.0,
                              width: 30.0,
                              color: Colors.black12,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

///
///
/// Calling imageLoading animation for set a grid layout
///
///
Widget _loadingImageAnimation(BuildContext context) {
  return ListView.builder(
    scrollDirection: Axis.horizontal,
    itemBuilder: (BuildContext context, int index) => loadingMenuItemCard(),
    itemCount: subItems.length,
  );
}
