import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:isouq/Helpers/Library/carousel_pro/src/carousel_pro.dart';
import 'package:isouq/cart/views/cart_items_list_view.dart';
import 'package:isouq/common/text_styles/text_styles.dart';
import 'package:isouq/common/widgets/gradient_app_bar.dart';
import 'package:isouq/home/viewmodels/item_details_viewmodel.dart';
import 'package:isouq/profile/viewmodels/profile_viewmodel.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:isouq/Firebase/firebase_methods.dart';
import 'package:isouq/Helpers/app_tools.dart';
import 'package:flutter/material.dart';
import 'package:isouq/cart/models/cart_item_model.dart';
import 'package:isouq/home/models/RatingModel.dart';
import 'package:isouq/profile/models/profileModel.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:isouq/home/GridListScreen.dart';
import 'package:isouq/home/ReviewLayout.dart';
import 'package:isouq/profile/models/item_model.dart';

ItemDetailsViewModel _viewModel;
final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();


class ItemDetails extends StatefulWidget {
  final ItemModel item;

  ItemDetails({this.item});

  @override
  _ItemDetailsState createState() => _ItemDetailsState();
}

/// Detail Product for Recomended Grid in home screen
class _ItemDetailsState extends State<ItemDetails> {
  @override
  void initState() {
    _viewModel = Provider.of<ItemDetailsViewModel>(context, listen: false);

    _viewModel.getTopRatedList();

    super.initState();
  }


  /// BottomSheet for view more in specification
  void _bottomSheet(String desc) {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return SingleChildScrollView(
            child: Container(
              color: Colors.black26,
              child: Padding(
                padding: const EdgeInsets.only(top: 2.0),
                child: Container(
                  height: 1500.0,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          topRight: Radius.circular(20.0))),
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(padding: EdgeInsets.only(top: 20.0)),
                      Center(
                          child: Text(
                        tr('description'),
                        style: subHeaderCustomStyle(),
                      )),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 20.0, left: 20.0, right: 20.0, bottom: 20.0),
                        child: Text(desc, style: detailText()),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: Text(
                          tr('spesifications'),
                          style: TextStyle(
                              fontFamily: "Gotik",
                              fontWeight: FontWeight.w600,
                              fontSize: 15.0,
                              color: Colors.black,
                              letterSpacing: 0.3,
                              wordSpacing: 0.5),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0, left: 20.0),
                        child: Text(
                          widget.item.productDetails,
                          style: detailText(),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    var sale = widget.item.newPrice.isNotEmpty;

    /// Variable Component UI use in bottom layout "Top Rated Products"
    var _suggestedItem = StreamBuilder(
        stream: _viewModel.getTopRatedSubItemsStream(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (snapshot.data.documents.length == 0) {
              return SizedBox(
              );
            } else {
              return Padding(
                padding: const EdgeInsets.only(
                    left: 15.0, right: 20.0, top: 30.0, bottom: 20.0),
                child: Container(
                  height: 400.0,
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            tr('topRated'),
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontFamily: "Gotik",
                                fontSize: 15.0),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).push(PageRouteBuilder(
                                  pageBuilder: (_, __, ___) =>
                                      FavouriteTopRatedGridListScreen(
                                          _viewModel.topRatedList,
                                          tr('top_rated'),
                                          false)));
                            },
                            child: Text(
                              tr('seeAll'),
                              style: TextStyle(
                                  color: Colors.indigoAccent.withOpacity(0.8),
                                  fontFamily: "Gotik",
                                  fontWeight: FontWeight.w700),
                            ),
                          )
                        ],
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: snapshot.data.documents.length,
                          padding: EdgeInsets.only(
                            top: 20.0,
                            bottom: 2.0,
                          ),
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (BuildContext context, int index) {
                            var item = ItemModel.fromDocumentSnapshot(
                                snapshot.data.documents[index]);

                            return Container(
                              margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                              child: item.newPrice.isEmpty
                                  ? ItemGrid(item)
                                  : ItemGridWithDiscount(item),
                            );
                          },
                        ),
                      )
                    ],
                  ),
                ),
              );
            }
          }
        });

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ItemDetailsViewModel(),
        ),
      ],
      child: StreamBuilder<ItemModel>(
          stream: _viewModel.getItemDetailsStream(widget.item.id),
          builder: (context, item) {
            return Scaffold(
              key: _key,
              appBar: gradientAppBar(item.data.title, actions: <Widget>[
                InkWell(
                  onTap: () {
                    Navigator.of(context).pushReplacement(PageRouteBuilder(
                        pageBuilder: (_, __, ___) => new cart()));
                  },
                  child: Stack(
                    alignment: AlignmentDirectional(-1.0, -0.8),
                    children: <Widget>[
                      IconButton(
                          onPressed: null,
                          icon: Icon(
                            Icons.shopping_cart,
                            color: Colors.black26,
                          )),
                      FutureBuilder(
                        future: _viewModel.getProfile(),
                        builder: (context, snapshot) {
                          return StreamBuilder(
                            stream: _viewModel.getCartItemsFuture(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return CircleAvatar(
                                    radius: 10.0,
                                    backgroundColor: Colors.red,
                                    child: Text(
                                        snapshot.data.documents.length
                                            .toString(),
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 13.0)));
                              } else {
                                return SizedBox();
                              }
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ]),
              body: ListView(
                children: <Widget>[
                  /// Header image slider
                  Container(
                    height: 300.0,
                    child: Hero(
                      tag: "hero-grid-${item.data.id}",
                      child: Material(
                        child: Carousel(
                          dotColor: Colors.black26,
                          dotIncreaseSize: 1.7,
                          dotBgColor: Colors.transparent,
                          autoplay: true,
                          boxFit: BoxFit.cover,
                          images: item.data.image
                              .map((i) => NetworkImage(i))
                              .toList(),
                        ),
                      ),
                    ),
                  ),
                  sale
                      ? Container(
                    height: 50.0,
                    width: 1000.0,
                    color: Colors.redAccent,
                    child: Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Padding(
                                padding:
                                EdgeInsets.only(left: 20.0)),
                            Image.asset(
                              "assets/icon/flashSaleIcon.png",
                              height: 25.0,
                            ),
                            Padding(
                                padding:
                                EdgeInsets.only(left: 10.0)),
                            Text(
                              tr('flashSale'),
                              style: customTextStyle()
                                  .copyWith(color: Colors.white),
                            ),
                          ],
                        ),
                        Padding(
                          padding:
                          const EdgeInsets.only(right: 15.0),
                          child: Text(
                            "${item.data.stock} ${tr('available')}",
                            style: customTextStyle().copyWith(
                                color: Colors.white,
                                fontSize: 13.5),
                          ),
                        )
                      ],
                    ),
                  )
                      : SizedBox(),

                  /// Background white title,price and ratting
                  Container(
                    decoration:
                    BoxDecoration(color: Colors.white, boxShadow: [
                      BoxShadow(
                        color: Color(0xFF656565).withOpacity(0.15),
                        blurRadius: 1.0,
                        spreadRadius: 0.2,
                      )
                    ]),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 20.0, top: 10.0, right: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            item.data.title,
                            style: customTextStyle(),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Padding(padding: EdgeInsets.only(top: 5.0)),
                          !sale
                              ? SizedBox()
                              : Text(
                            "${item.data.price} EGP",
                            style: customTextStyle().copyWith(
                                decoration:
                                TextDecoration.lineThrough,
                                fontSize: 13.0,
                                color: Colors.black26),
                          ),
                          Padding(padding: EdgeInsets.only(top: 5.0)),
                          !sale
                              ? Text(
                            "${item.data.price} EGP",
                            style: customTextStyle().copyWith(
                                color: Colors.black,
                                fontSize: 20.0),
                          )
                              : Text(
                            "${item.data.newPrice} EGP",
                            style: customTextStyle().copyWith(
                                color: Colors.redAccent,
                                fontSize: 20.0),
                          ),
                          Padding(padding: EdgeInsets.only(top: 10.0)),
                          Divider(
                            color: Colors.black12,
                            height: 1.0,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 10.0, bottom: 10.0),
                            child: Row(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(
                                  height: 30.0,
                                  width: 75.0,
                                  decoration: BoxDecoration(
                                    color: Colors.lightGreen,
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(20.0)),
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        item.data.rating,
                                        style: TextStyle(
                                            color: Colors.white),
                                      ),
                                      Padding(
                                          padding: EdgeInsets.only(
                                              left: 8.0)),
                                      Icon(
                                        Icons.star,
                                        color: Colors.white,
                                        size: 19.0,
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding:
                                  const EdgeInsets.only(left: 10.0),
                                  child: Text(
                                    item.data.sale + " ${tr('sale')}",
                                    style: TextStyle(
                                        color: Colors.black26,
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.w500),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),

                  /// Background white for chose Size and Color
                  (item.data.color.length > 0 ||
                      item.data.size.length > 0)
                      ? Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Container(
                      height: 220.0,
                      width: 600.0,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xFF656565)
                                  .withOpacity(0.15),
                              blurRadius: 1.0,
                              spreadRadius: 0.2,
                            )
                          ]),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 20.0, left: 20.0, right: 20.0),
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: <Widget>[
                            item.data.size.length > 0
                                ? Text(tr('size'),
                                style: subHeaderCustomStyle())
                                : SizedBox(),
                            item.data.size.length > 0
                                ? Container(
                                height: 60,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  scrollDirection:
                                  Axis.horizontal,
                                  itemCount:
                                  item.data.size.length,
                                  itemBuilder:
                                      (BuildContext context,
                                      int index) {
                                    return RadioButtonCustom(
                                      listSize: item
                                          .data.size.length,
                                      index: index,
                                      textSize: item
                                          .data.size[index],
                                    );
                                  },
                                ))
                                : SizedBox(),
                            Padding(
                                padding:
                                EdgeInsets.only(top: 15.0)),
                            Divider(
                              color: Colors.black12,
                              height: 1.0,
                            ),
                            Padding(
                                padding:
                                EdgeInsets.only(top: 10.0)),
                            item.data.color.length > 0
                                ? Text(
                              tr('color'),
                              style: subHeaderCustomStyle(),
                            )
                                : SizedBox(),
                            item.data.color.length > 0
                                ? Container(
                                height: 60,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  scrollDirection:
                                  Axis.horizontal,
                                  itemCount:
                                  item.data.color.length,
                                  itemBuilder:
                                      (BuildContext context,
                                      int index) {
                                    return RadioButtonColor(
                                        index: index,
                                        clr: item.data
                                            .color[index],
                                        listColor: item.data
                                            .color.length);
                                  },
                                ))
                                : SizedBox(),
                          ],
                        ),
                      ),
                    ),
                  )
                      : SizedBox(),

                  /// Background white for description
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Container(
                      width: 600.0,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color:
                              Color(0xFF656565).withOpacity(0.15),
                              blurRadius: 1.0,
                              spreadRadius: 0.2,
                            )
                          ]),
                      child: Padding(
                        padding: EdgeInsets.only(top: 10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 20.0, right: 20.0),
                              child: Text(
                                tr('description'),
                                style: subHeaderCustomStyle(),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 15.0,
                                  right: 20.0,
                                  bottom: 10.0,
                                  left: 20.0),
                              child: Text(
                                item.data.desc,
                                style: detailText(),maxLines: 3,),
                            ),
                            Padding(
                              padding:
                              const EdgeInsets.only(bottom: 15.0),
                              child: Center(
                                child: InkWell(
                                  onTap: () {
                                    _bottomSheet(item.data.desc);
                                  },
                                  child: Text(
                                    tr('viewMore'),
                                    style: TextStyle(
                                      color: Colors.indigoAccent,
                                      fontSize: 15.0,
                                      fontFamily: "Gotik",
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  _suggestedItem,

                  /// Background white for Ratting
                  StreamBuilder(
                      stream:
                      _viewModel.getUserRatingsStream(item.data.id),
                      builder: (BuildContext context,
                          AsyncSnapshot snapshot) {
                        if (!snapshot.hasData) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          if (snapshot.data.length == 0)
                            return SizedBox(
                            );
                          else {
                            List<Widget> columnWidgets = new List();
                            columnWidgets.add(Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  tr('review'),
                                  style: subHeaderCustomStyle(),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20.0,
                                      top: 15.0,
                                      bottom: 15.0),
                                  child: Row(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                    MainAxisAlignment.start,
                                    children: <Widget>[
                                      InkWell(
                                        child: Padding(
                                            padding: EdgeInsets.only(
                                                top: 2.0, right: 3.0),
                                            child: Text(
                                              tr('viewAll'),
                                              style: subHeaderCustomStyle()
                                                  .copyWith(
                                                  color: Colors
                                                      .indigoAccent,
                                                  fontSize: 14.0),
                                            )),
                                        onTap: () {
                                          Navigator.of(context).push(
                                              PageRouteBuilder(
                                                  pageBuilder: (_, __,
                                                      ___) =>
                                                      ReviewsAll(snapshot
                                                          .requireData)));
                                        },
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            right: 15.0, top: 2.0),
                                        child: Icon(
                                          Icons.arrow_forward_ios,
                                          size: 18.0,
                                          color: Colors.black54,
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ));
                            var reviewCount =
                                snapshot.data.length;
                            // calculate rating if reviews found
                            var ratingSum = 0.0;
                            for(RatingModel rate in snapshot.data)
                              ratingSum += double.parse(rate.rating);

                            var overallRating = ratingSum/reviewCount;

                            columnWidgets.add(Row(
                              children: <Widget>[
                                Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.start,
                                    children: <Widget>[
                                      StarRating(
                                        size: 25.0,
                                        starCount: 5,
                                        rating: reviewCount==0 ? double.parse(item.data.rating) : overallRating,
                                        color: Colors.yellow,
                                      ),
                                      SizedBox(width: 5.0),
                                      Text("$reviewCount ${tr('reviews')} ")
                                    ]),
                              ],
                            ));

                            columnWidgets.add(Padding(
                              padding: EdgeInsets.only(
                                  left: 0.0,
                                  right: 20.0,
                                  top: 15.0,
                                  bottom: 7.0),
                              child: _line(),
                            ));

                            for (var i in snapshot.data) {
                              var rating = i;
//                                          RatingModel.fromDocumentSnapshot(i);
                              columnWidgets.add(_buildRating(
                                  rating.rating,
                                  rating.desc,
                                  rating.userImage,
                                  double.parse(rating.rating)));
                              columnWidgets.add(Padding(
                                padding: EdgeInsets.only(
                                    left: 0.0,
                                    right: 20.0,
                                    top: 15.0,
                                    bottom: 7.0),
                                child: _line(),
                              ));
                              columnWidgets.add(Padding(
                                  padding:
                                  EdgeInsets.only(bottom: 20.0)));
                            }
                            return Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Container(
                                width: 600.0,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color(0xFF656565)
                                            .withOpacity(0.15),
                                        blurRadius: 1.0,
                                        spreadRadius: 0.2,
                                      )
                                    ]),
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      top: 20.0,
                                      left: 20.0,
                                      right: 20.0),
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: columnWidgets,
                                  ),
                                ),
                              ),
                            );
                          }
                        }
                      }),

                  InkWell(
                    onTap: () => _showRatingDialog(context),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(right: 10),
                              child: ColorFiltered(
                                colorFilter: ColorFilter.mode(
                                  Colors.grey,
                                  BlendMode.srcATop,
                                ),
                                child: Image.asset(
                                  'assets/icon/write_review.png',
                                  height: 25.0,
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                              const EdgeInsets.only(right: 20.0),
                              child: Text(
                                tr('write_review'),
                                style: txtCategory(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              bottomSheet: Padding(
                padding: const EdgeInsets.only(bottom: 5.0),
                child: Container(
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            var snackbar;
                            if (item.data.size.isEmpty &&
                                item.data.color.isEmpty) {
                              snackbar = SnackBar(
                                content: Text(
                                  tr('itemAdded'),
                                ),
                              );
                              var object = CartItemModel(
                                      color: _viewModel.colorSelected,
                                      size: _viewModel.sizeSelected,
                                      quantity: '1',
                                      title: item.data.title,
                                      price: item.data.newPrice.isNotEmpty ? item.data.newPrice : item.data.price,
                                      productId: item.data.id)
                                  .toMap();

                              addToCart(object);
                            } else {
                              if (item.data.size.isNotEmpty &&
                                  _viewModel.sizeSelected == null) {
                                snackbar = SnackBar(
                                  content: Text(
                                    tr('itemNotSelected'),
                                  ),
                                );
                              } else if (item.data.color.isNotEmpty &&
                                  _viewModel.colorSelected == null) {
                                snackbar = SnackBar(
                                  content: Text(
                                    tr('itemNotSelected'),
                                  ),
                                );
                              } else {
                                snackbar = SnackBar(
                                  content: Text(
                                    tr('itemAdded'),
                                  ),
                                );
//                                var object = {
//                                  'color': _viewModel.colorSelected,
//                                  'size': _viewModel.sizeSelected,
//                                  'id': item.data.id
//                                };
                                var object = CartItemModel(
                                    color: _viewModel.colorSelected,
                                    size: _viewModel.sizeSelected,
                                    quantity: '1',
                                    title: item.data.title,
                                    price: item.data.newPrice.isNotEmpty ? item.data.newPrice : item.data.price,
                                    productId: item.data.id)
                                    .toMap();

                                addToCart(object);
                              }
                            }
                            _key.currentState.showSnackBar(snackbar);
                          },
                          child: Container(
                            height: 40.0,
                            width: 60.0,
                            decoration: BoxDecoration(
                                color: Colors.white12.withOpacity(0.1),
                                border: Border.all(color: Colors.black12)),
                            child: Center(
                              child: Image.asset(
                                "assets/icon/shopping-cart.png",
                                height: 23.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            var snackbar;
                            setState(() {
                              _viewModel.addToFavourite(item.data.id);
                            });

                            snackbar = SnackBar(
                              content: Text(
                                tr('itemFavoriteAdded'),
                              ),
                            );

                            _key.currentState.showSnackBar(snackbar);
                          },
                          child: Container(
                            height: 40.0,
                            width: 60.0,
                            decoration: BoxDecoration(
                                color: Colors.white12.withOpacity(0.1),
                                border: Border.all(color: Colors.black12)),
                            child: Center(
                              child: Image.asset("assets/icon/love.png",
                                  height: 20.0),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }

  void addToCart(object) async{
    ProgressDialog dialog = new ProgressDialog(context);
    dialog.style(
        message: 'Please wait...'
    );
    await dialog.show();
    await _viewModel.addToCart(object);
    await dialog.hide();
  }

  Widget _buildRating(
      String date, String details, String image, double rating) {
    return ListTile(
      leading: Container(
        height: 45.0,
        width: 45.0,
        decoration: BoxDecoration(
            image:
                DecorationImage(image: (image != null && image.isNotEmpty) ? NetworkImage(image) : AssetImage('assets/img/person-imag.jpg'), fit: BoxFit.cover),
            borderRadius: BorderRadius.all(Radius.circular(50.0))),
      ),
      title: Row(
        children: <Widget>[
          StarRating(
            size: 20.0,
            rating: rating,
            starCount: 5,
            color: Colors.yellow,
          ),
          SizedBox(width: 8.0),
          Text(
            date,
            style: TextStyle(fontSize: 12.0),
          )
        ],
      ),
      subtitle: Text(
        details,
        style: detailText(),
      ),
    );
  }


  _showRatingDialog(BuildContext context) async {
    await showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return RatingAlertDialog(itemModel: widget.item,);
        });
  }
}

class RatingAlertDialog extends StatefulWidget
{
  final ItemModel itemModel;

  RatingAlertDialog({this.itemModel});

  @override
  _RatingAlertDialogState createState() => _RatingAlertDialogState();

}

class _RatingAlertDialogState extends State<RatingAlertDialog>{

  var _ratingEditingController = TextEditingController();
  var _ratingValueController = TextEditingController();
  var recommendCheckedValue = true;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          RatingBar(
            initialRating: 0,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
            itemBuilder: (context, _) => Icon(
              Icons.star,
              color: Colors.amber,
            ),
            onRatingUpdate: (rating) {
              _ratingValueController.text = rating.toString();
            },
          ),
          SizedBox(height: 20,),
          TextField(
            controller: _ratingEditingController,
            maxLines: 5,
            decoration: new InputDecoration(
              labelText: tr('write_review'),
            ),
          ),
          SizedBox(height: 20,),
          CheckboxListTile(
            title: Text(tr('recommend_friend')),
            value: recommendCheckedValue,
            onChanged: (newValue) {
              setState(() {
                recommendCheckedValue = newValue;
              });
            },
            controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
          ),
        ],
      ),
      actions: <Widget>[
        new FlatButton(
            child: new Text(tr('cancel')),
            onPressed: () {
              Navigator.pop(context);
            }),
        new FlatButton(
            child: new Text(tr('Save')),
            onPressed: () async {
              if (_ratingEditingController.text.isNotEmpty && _ratingValueController.text.isNotEmpty ) {

                var userProfile = await getProfileFuture();
                var rating = RatingModel(
                    rating: _ratingValueController.text.toString(),
                    ratingTime: DateTime.now().toString(),
                    desc: _ratingEditingController.text.toString(),
                    userImage: userProfile.avatar
                );
                 if(recommendCheckedValue) {
                   var recommendedCount = widget.itemModel.recommendedCount;
                   recommendedCount++;
                   _viewModel.addRecommendationToItem(
                       widget.itemModel.id, recommendedCount);
                 }
                _viewModel.addRatingToItem(widget.itemModel.id, rating.toMap());

                _key.currentState.showSnackBar(SnackBar(
                  content: Text(
                    tr('review_added'),
                  ),
                ));
                Navigator.pop(context);

              } else {
                _key.currentState.showSnackBar(SnackBar(
                  content: Text(
                    tr('review_empty'),
                  ),
                ));
              }
            })
      ],
    );
  }
}

/// RadioButton for item choose in size
class RadioButtonCustom extends StatefulWidget {
  final String textSize;
  final int listSize;
  final int index;

  RadioButtonCustom({this.textSize, this.index, this.listSize});

  @override
  _RadioButtonCustomState createState() => _RadioButtonCustomState();
}

class _RadioButtonCustomState extends State<RadioButtonCustom> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Provider.of<ItemDetailsViewModel>(context, listen: false)
            .addListSize(widget.listSize);
        Provider.of<ItemDetailsViewModel>(context, listen: false)
            .addSizeItemSelect(widget.index);
        _viewModel.sizeSelected = widget.textSize;
      },
      child: Consumer<ItemDetailsViewModel>(
        builder: (BuildContext context, value, Widget child) {
          bool isSelected =
              value.sizeList == null ? false : value.sizeList[widget.index];
          return Container(
            child: Card(
              color: isSelected ? Colors.blue : Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              elevation: 1.0,
              child: Container(
                  margin: EdgeInsets.all(8),
                  child: Center(
                      child: Text(
                    widget.textSize,
                    style: TextStyle(fontSize: 20),
                  ))),
            ),
          );
        },
      ),
    );
  }
}

/// RadioButton for item choose in color
class RadioButtonColor extends StatefulWidget {
  final String clr;
  final int listColor;
  final int index;

  RadioButtonColor({this.clr, this.index, this.listColor});

  @override
  _RadioButtonColorState createState() => _RadioButtonColorState();
}

class _RadioButtonColorState extends State<RadioButtonColor> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Provider.of<ItemDetailsViewModel>(context, listen: false)
            .addListColor(widget.listColor);
        Provider.of<ItemDetailsViewModel>(context, listen: false)
            .addColorItemSelect(widget.index);
        _viewModel.colorSelected = widget.clr;
      },
      child: Consumer<ItemDetailsViewModel>(
        builder:
            (BuildContext context, ItemDetailsViewModel value, Widget child) {
          bool itemSelected =
              value.colorList == null ? false : value.colorList[widget.index];

          return Container(
            child: Card(
              color: itemSelected ? Colors.blue : Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              elevation: 1.0,
              child: Container(
                  margin: EdgeInsets.all(8),
                  child: Center(
                      child: Text(
                        widget.clr,
                        style: TextStyle(fontSize: 20),
                      ))),
            ),
          );
        },
      ),
    );
  }
}

Widget _line() {
  return Container(
    height: 0.9,
    width: double.infinity,
    color: Colors.black12,
  );
}
