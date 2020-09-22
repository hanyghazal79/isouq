import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:isouq/common/widgets/gradient_app_bar.dart';
import 'package:isouq/common/widgets/no_item_view.dart';
import 'package:isouq/home/views/item_details_view.dart';
import 'package:isouq/profile/viewmodels/profile_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:isouq/Firebase/firebase_methods.dart';
import 'package:isouq/profile/models/item_model.dart';

final firebaseSharedInstance = FirebaseMethods.sharedInstance;

List<ItemModel> subItems = new List();

class FavouriteTopRatedGridListScreen extends StatefulWidget {
final List<ItemModel> list;
final String listTitle;
final isFavourite;

  FavouriteTopRatedGridListScreen(this.list,this.listTitle,this.isFavourite);
  @override
  _CategorySubItemListScreenState createState() =>
      _CategorySubItemListScreenState();
}

class _CategorySubItemListScreenState extends State<FavouriteTopRatedGridListScreen> {

  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  ProfileViewModel _viewModel;

  ///
  /// Get image data dummy from firebase server
  ///
  var imageNetwork = NetworkImage(
      "https://firebasestorage.googleapis.com/v0/b/beauty-look.appspot.com/o/Screenshot_20181005-213931.png?alt=media&token=e6287f67-5bc0-4225-8e96-1623dc9dc42f");

  ///
  /// check the condition is right or wrong for image loaded or no
  ///
  bool imageLoad = true;

  ///
  /// SetState after imageNetwork loaded to change list card
  ///
  @override
  void initState() {
    if (widget.isFavourite) {
      _viewModel = Provider.of<ProfileViewModel>(context, listen: false);
      _viewModel.getFavoriteList();
    }
    Timer(Duration(seconds: 2), () {
      imageLoad = false;
    });
    // TODO: implement initState
    super.initState();
  }

  updateUI()
  {
    if (mounted)
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    var _grid;

    if(widget.isFavourite)
      {
        _viewModel.favoriteListController.stream.listen((event) { updateUI();});

        _grid = Consumer<ProfileViewModel>(
          builder: (context, profile, child)
          {
            return SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ///
                    ///
                    /// check the condition if image data from server firebase loaded or no
                    /// if image true (image still downloading from server)
                    /// Card to set card loading animation
                    ///
                    ///  crossAxisSpacing: 10.0,
                    profile.favoriteList.length>0 ?  GridView.builder(
                      shrinkWrap: true,
                      itemCount: profile.favoriteList.length,
                      padding: EdgeInsets.symmetric(
                          horizontal: 7.0, vertical: 10.0),
                      itemBuilder: (context, index) {
                        return profile.favoriteList.elementAt(index).newPrice.isEmpty
                            ? InkWell(child: ItemGrid(profile.favoriteList.elementAt(index)),onLongPress: () => showDeleteFavouriteAlertDialog(context, profile.favoriteList.elementAt(index).id),)
                            : InkWell(child: ItemGridWithDiscount(profile.favoriteList.elementAt(index)),onLongPress: () => showDeleteFavouriteAlertDialog(context, profile.favoriteList.elementAt(index).id),);
                      },
                      gridDelegate:
                      SliverGridDelegateWithFixedCrossAxisCount(
                        mainAxisSpacing: 15.0,
                        childAspectRatio: 0.5235,
                        crossAxisCount: 2,
                      ),
                    ):NoItemCart()
                  ],
                ),
              ),
            );
          }
          ,
        );
      }
      else
        {
          List<ItemModel> list = widget.list;

          /// Grid Item a product
          _grid = SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ///
                  ///
                  /// check the condition if image data from server firebase loaded or no
                  /// if image true (image still downloading from server)
                  /// Card to set card loading animation
                  ///
                  ///  crossAxisSpacing: 10.0,
                  list.length>0 ?  GridView.builder(
                    shrinkWrap: true,
                    itemCount: list.length,
                    padding: EdgeInsets.symmetric(
                        horizontal: 7.0, vertical: 10.0),
                    itemBuilder: (context, index) {
                      return list.elementAt(index).newPrice.isEmpty
                          ? InkWell(child: ItemGrid(list.elementAt(index)),onLongPress: () => showDeleteFavouriteAlertDialog(context, list.elementAt(index).id),)
                          : InkWell(child: ItemGridWithDiscount(list.elementAt(index)),onLongPress: () => showDeleteFavouriteAlertDialog(context, list.elementAt(index).id),);
                    },
                    gridDelegate:
                    SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisSpacing: 15.0,
                      childAspectRatio: 0.5235,
                      crossAxisCount: 2,
                    ),
                  ):NoItemCart()
                ],
              ),
            ),
          );
        }
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


    return Scaffold(
      key: _key,
      /// Appbar item
      appBar: gradientAppBar(widget.listTitle),

      body: SingleChildScrollView(
        child: Container(
          child: Column(
            /// Calling search and grid variable
            children: <Widget>[
              _search,
              _grid,
            ],
          ),
        ),
      ),
    );
  }

  showDeleteFavouriteAlertDialog(BuildContext context, String id) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text(tr('cancel')),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = FlatButton(
      child: Text(tr('continue')),
      onPressed: () {
        _viewModel.deleteFavourite(id);

        Navigator.of(context).pop();
        _key.currentState.showSnackBar(SnackBar(
          content: Text(
            tr('itemFavoriteDeleted'),
          ),
        ));
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(tr('alert')),
      content: Text(tr('deleteItemFavorite')),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

/// ItemGrid class
class ItemGridWithDiscount extends StatelessWidget {
  final ItemModel itemSale;

  ItemGridWithDiscount(this.itemSale);

  getDiscount() {
    var discount =
        (int.parse(itemSale.newPrice) * 100) / int.parse(itemSale.price);
    discount = 100 - discount;
    String finalDiscount = discount.toInt().toString() + " %";
    return finalDiscount;
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Container(
      decoration:
      BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(50))),
      padding: EdgeInsets.all(10),
      child: Card(
        child: InkWell(
          onTap: () {
            /// Animation Transition with opacity value in route navigate another layout
            Navigator.of(context).push(PageRouteBuilder(
                pageBuilder: (_, __, ___) => new ItemDetails(
                  item: itemSale,
                ),
                transitionDuration: Duration(milliseconds: 950),
                transitionsBuilder:
                    (_, Animation<double> animation, __, Widget child) {
                  return Opacity(
                    opacity: animation.value,
                    child: child,
                  );
                }));
          },
          child: Container(
            decoration: BoxDecoration(color: Colors.white, boxShadow: [
              BoxShadow(
                  color: Colors.black12.withOpacity(0.1),
                  spreadRadius: 0.2,
                  blurRadius: 0.5)
            ]),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                /// Animation image header to flashSaleDetail.dart
                Hero(
                  tag: "hero-flashsale-${itemSale.id}",
                  child: Material(
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(PageRouteBuilder(
                            opaque: false,
                            pageBuilder: (BuildContext context, _, __) {
                              return new Material(
                                color: Colors.black54,
                                child: Container(
                                  padding: EdgeInsets.all(30.0),
                                  child: InkWell(
                                    child: Hero(
                                        tag: "hero-flashsale-${itemSale.id}",
                                        child: Image.network(
                                          itemSale.image.elementAt(0),
                                          width: 300.0,
                                          height: 300.0,
                                          alignment: Alignment.center,
                                          fit: BoxFit.contain,
                                        )),
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ),
                              );
                            },
                            transitionDuration: Duration(milliseconds: 500)));
                      },
                      child: SizedBox(
                        child: Stack(
                          children: <Widget>[
                            Image.network(
                              itemSale.image.elementAt(0),
                              fit: BoxFit.cover,
                              height: 140.0,
                              width: mediaQueryData.size.width / 2.1,
                            ),
                            Container(
                              height: 25.5,
                              width: 55.0,
                              decoration: BoxDecoration(
                                  color: Color(0xFFD7124A),
                                  borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(20.0),
                                      topLeft: Radius.circular(5.0))),
                              child: Center(
                                  child: Text(
                                    getDiscount(),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600),
                                  )),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 8.0, right: 3.0, top: 15.0),
                  child: Container(
                    width: mediaQueryData.size.width / 2.7,
                    child: Text(
                      itemSale.title,
                      style: TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w500,
                          fontFamily: "Sans"),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10.0, top: 5.0),
                  child: Text("${itemSale.price} EGP",
                      style: TextStyle(
                          fontSize: 10.5,
                          decoration: TextDecoration.lineThrough,
                          color: Colors.black54,
                          fontWeight: FontWeight.w600,
                          fontFamily: "Sans")),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10.0, top: 5.0),
                  child: Text("${itemSale.newPrice} EGP",
                      style: TextStyle(
                          fontSize: 12.0,
                          color: Color(0xFF7F7FD5),
                          fontWeight: FontWeight.w800,
                          fontFamily: "Sans")),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, top: 5.0),
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.star,
                        size: 11.0,
                        color: Colors.yellow,
                      ),
                      Icon(
                        Icons.star,
                        size: 11.0,
                        color: Colors.yellow,
                      ),
                      Icon(
                        Icons.star,
                        size: 11.0,
                        color: Colors.yellow,
                      ),
                      Icon(
                        Icons.star,
                        size: 11.0,
                        color: Colors.yellow,
                      ),
                      Icon(
                        Icons.star_half,
                        size: 11.0,
                        color: Colors.yellow,
                      ),
                      Text(
                        itemSale.rating,
                        style: TextStyle(
                            fontSize: 10.0,
                            fontWeight: FontWeight.w500,
                            fontFamily: "Sans",
                            color: Colors.black38),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, top: 5.0),
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.location_on,
                        size: 11.0,
                        color: Colors.black38,
                      ),
                      Text(
                        itemSale.place,
                        style: TextStyle(
                            fontSize: 10.0,
                            fontWeight: FontWeight.w500,
                            fontFamily: "Sans",
                            color: Colors.black38),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0, left: 10.0),
                  child: Text(
                    itemSale.stock,
                    style: TextStyle(
                        fontSize: 10.0,
                        fontWeight: FontWeight.w500,
                        fontFamily: "Sans",
                        color: Colors.black),
                  ),
                ),
                Padding(
                  padding:
                  const EdgeInsets.only(top: 4.0, left: 10.0, bottom: 15.0),
                  child: Container(
                    height: 5.0,
                    width: 50,
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.all(Radius.circular(4.0)),
                        shape: BoxShape.rectangle),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// ItemGrid in bottom item "Recomended" item
class ItemGrid extends StatelessWidget {
  final ItemModel itemSale;

  ItemGrid(this.itemSale);

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Container(
      padding: EdgeInsets.all(10),
      child: Card(
        child: InkWell(
          onTap: () {
            /// Animation Transition with opacity value in route navigate another layout
            /// Animation Transition with opacity value in route navigate another layout
            Navigator.of(context).push(PageRouteBuilder(
                pageBuilder: (_, __, ___) => new ItemDetails(
                  item: itemSale,
                ),
                transitionDuration: Duration(milliseconds: 950),
                transitionsBuilder:
                    (_, Animation<double> animation, __, Widget child) {
                  return Opacity(
                    opacity: animation.value,
                    child: child,
                  );
                }));
          },
          child: Container(
            decoration: BoxDecoration(color: Colors.white, boxShadow: [
              BoxShadow(
                  color: Colors.black12.withOpacity(0.1),
                  spreadRadius: 0.2,
                  blurRadius: 0.5)
            ]),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                /// Animation image header to flashSaleDetail.dart
                Hero(
                  tag: "hero-flashsale-${itemSale.id}",
                  child: Material(
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(PageRouteBuilder(
                            opaque: false,
                            pageBuilder: (BuildContext context, _, __) {
                              return new Material(
                                color: Colors.black54,
                                child: Container(
                                  padding: EdgeInsets.all(30.0),
                                  child: InkWell(
                                    child: Hero(
                                        tag: "hero-flashsale-${itemSale.id}",
                                        child: Image.network(
                                          itemSale.image.elementAt(0),
                                          width: 300.0,
                                          height: 300.0,
                                          alignment: Alignment.center,
                                          fit: BoxFit.contain,
                                        )),
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ),
                              );
                            },
                            transitionDuration: Duration(milliseconds: 500)));
                      },
                      child: SizedBox(
                        child: Stack(
                          children: <Widget>[
                            Image.network(
                              itemSale.image.elementAt(0),
                              fit: BoxFit.cover,
                              height: 140.0,
                              width: mediaQueryData.size.width / 2.1,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 8.0, right: 3.0, top: 15.0),
                  child: Container(
                    width: mediaQueryData.size.width / 2.7,
                    child: Text(
                      itemSale.title,
                      style: TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w500,
                          fontFamily: "Sans"),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10.0, top: 5.0),
                  child: Text("${itemSale.price} EGP",
                      style: TextStyle(
                          fontSize: 12.0,
                          color: Color(0xFF7F7FD5),
                          fontWeight: FontWeight.w800,
                          fontFamily: "Sans")),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, top: 5.0),
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.star,
                        size: 11.0,
                        color: Colors.yellow,
                      ),
                      Icon(
                        Icons.star,
                        size: 11.0,
                        color: Colors.yellow,
                      ),
                      Icon(
                        Icons.star,
                        size: 11.0,
                        color: Colors.yellow,
                      ),
                      Icon(
                        Icons.star,
                        size: 11.0,
                        color: Colors.yellow,
                      ),
                      Icon(
                        Icons.star_half,
                        size: 11.0,
                        color: Colors.yellow,
                      ),
                      Text(
                        itemSale.rating,
                        style: TextStyle(
                            fontSize: 10.0,
                            fontWeight: FontWeight.w500,
                            fontFamily: "Sans",
                            color: Colors.black38),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, top: 5.0),
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.location_on,
                        size: 11.0,
                        color: Colors.black38,
                      ),
                      Text(
                        itemSale.place,
                        style: TextStyle(
                            fontSize: 10.0,
                            fontWeight: FontWeight.w500,
                            fontFamily: "Sans",
                            color: Colors.black38),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0, left: 10.0),
                  child: Text(
                    itemSale.stock,
                    style: TextStyle(
                        fontSize: 10.0,
                        fontWeight: FontWeight.w500,
                        fontFamily: "Sans",
                        color: Colors.black),
                  ),
                ),
                Padding(
                  padding:
                  const EdgeInsets.only(top: 4.0, left: 10.0, bottom: 15.0),
                  child: Container(
                    height: 5.0,
                    width: 50,
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.all(Radius.circular(4.0)),
                        shape: BoxShape.rectangle),
                  ),
                )
              ],
            ),
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
              ///
              ///
              /// Shimmer class for animation loading
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

///
///
/// Calling imageLoading animation for set a grid layout
///
///
Widget _imageLoading(BuildContext context) {
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
      subItems.length,
      (index) => loadingMenuItemCard(),
    ),
  );
}
