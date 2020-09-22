import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:isouq/common/widgets/gradient_app_bar.dart';
import 'package:isouq/common/widgets/no_item_view.dart';
import 'package:isouq/home/views/grid_item_with_discount.dart';
import 'package:isouq/home/views/item_details_view.dart';
import 'package:shimmer/shimmer.dart';
import 'package:isouq/Firebase/firebase_methods.dart';
import 'package:isouq/profile/models/item_model.dart';


class HorizontalItemList extends StatefulWidget {
  final String id,title;
  final bool isRecommendedList;

  HorizontalItemList({this.id,this.title, this.isRecommendedList});

  @override
  _HorizontalItemListState createState() => _HorizontalItemListState();
}

class _HorizontalItemListState extends State<HorizontalItemList> {
  String _textSearch = '';
  final firebaseSharedInstance = FirebaseMethods.sharedInstance;

  ///
  /// check the condition is right or wrong for image loaded or no
  ///
  bool imageLoad = true;

  ///
  /// SetState after imageNetwork loaded to change list card
  ///
  @override
  void initState() {
    Timer(Duration(seconds: 3), () {
      setState(() {
        imageLoad = false;
      });
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    /// Item Search in bottom of appbar
    var _search = Container(
        height: 50.0,
        decoration: BoxDecoration(
            color: Colors.white,
            border:
                Border.all(color: Colors.grey.withOpacity(0.2), width: 1.0)),
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
          child: Theme(
            data: ThemeData(hintColor: Colors.transparent),
            child: TextFormField(
              onChanged: (val) {
                setState(() {
                  _textSearch = val;
                });
              },
              decoration: InputDecoration(
                  border: InputBorder.none,
                  icon: Icon(
                    Icons.search,
                    color: Colors.black38,
                    size: 18.0,
                  ),
                  hintText: tr('description'),
                  hintStyle: TextStyle(color: Colors.black38, fontSize: 14.0)),
            ),
          ),
        ));

    /// Grid Item a product
    var _grid = Expanded(
      child: Container(
        color: Colors.white,
        child: StreamBuilder(
            stream: widget.isRecommendedList
                ? firebaseSharedInstance.getRecommendedItemsStream()
                :firebaseSharedInstance.getSubItems(
                type: firebaseSharedInstance.item, parentId: widget.id),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasError) {
                print(snapshot.error.toString());
              }
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              } else {
                int length = snapshot.data.documents.length;
                if (length > 0) {
                  if (imageLoad) {
                    return _imageLoading(context: context, length: length);
                  } else {
                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          childAspectRatio: .6,
                          crossAxisSpacing: .7,
                          crossAxisCount: 2),
                      itemCount: length,
                      padding:
                          EdgeInsets.symmetric(horizontal: 7.0, vertical: 10.0),
                      itemBuilder: (context, index) {
                        var item = ItemModel.fromDocumentSnapshot(
                            snapshot.data.documents[index]);
                        if (_textSearch.isNotEmpty || _textSearch != '') {
                          bool isContains =
                              item.title.toLowerCase().contains(_textSearch);
                          if (isContains) {
                            if(item.newPrice.isEmpty || item.price.isEmpty)
                              return GridItem(item);
                            else
                             return ItemGridWithDiscount(item);
                          } else {
                            return SizedBox();
                          }
                        } else {
                          if(item.newPrice.isEmpty || item.price.isEmpty)
                            return GridItem(item);
                          else
                            return ItemGridWithDiscount(item);
                        }
                      },
                    );
                  }
                } else {
                  return NoItemCart();
                }
              }
            }),
      ),
    );

    return Scaffold(
      /// Appbar item
      appBar: gradientAppBar(widget.title),
      body: Container(
        child: Column(
          /// Calling search and grid variable
          children: <Widget>[
            _search,
            _grid,
          ],
        ),
      ),
    );
  }
}

/// ItemGrid class
class GridItem extends StatelessWidget {
 final ItemModel item;

  GridItem(this.item);


  @override
  Widget build(BuildContext context) {

    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
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
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(PageRouteBuilder(
                pageBuilder: (_, ___, ____) => new ItemDetails(
                      item:item,
                    )));
          },
          child: Wrap(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Container(
                        height: mediaQueryData.size.height / 3.3,
                        width: 200.0,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(7.0),
                                topRight: Radius.circular(7.0)),
                            image: DecorationImage(
                                image: item.image.length != 0 ? NetworkImage(item.image.elementAt(0)) : AssetImage('assets/img/logo.png'),
                                fit: BoxFit.cover)),
                      ),
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
                      item.price.isEmpty ? "${item.newPrice} EGP" : "${item.price} EGP",
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
                )
              ]),
          child: Wrap(
            children: <Widget>[
              ///
              ///
              /// Shimmer class for animation loading
              ///
              ///
              ///
              Shimmer.fromColors(
                baseColor: Colors.black38,
                highlightColor: Colors.white,
                child: Container(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                          Container(
                            height: 205.0,
                            width: 185.0,
                            color: Colors.black12,
                          ),
//                          Container(
//                            height: 25.5,
//                            width: 65.0,
//                            decoration: BoxDecoration(
//                                color: Color(0xFFD7124A),
//                                borderRadius: BorderRadius.only(
//                                    bottomRight: Radius.circular(20.0),
//                                    topLeft: Radius.circular(5.0))),
//                          )
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
                            left: 15.0, right: 15.0, top: 7.0, bottom: 0.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
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

Widget _imageLoading({BuildContext context, int length}) {
  return GridView.count(
    shrinkWrap: true,
    padding: EdgeInsets.symmetric(horizontal: 7.0, vertical: 10.0),
    crossAxisSpacing: 10.0,
    mainAxisSpacing: 15.0,
    childAspectRatio: 0.545,
    crossAxisCount: 2,
    primary: false,
    children: List.generate(
      /// Get data in horizontal_item_list.dart (ListItem folder)
      length,
      (index) => loadingMenuItemCard(),
    ),
  );
}
