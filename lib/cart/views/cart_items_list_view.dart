import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:isouq/cart/views/Delivery.dart';
import 'package:isouq/cart/models/cart_item_model.dart';
import 'package:isouq/cart/viewmodels/cart_viewmodel.dart';
import 'package:isouq/common/text_styles/text_styles.dart';
import 'package:isouq/common/widgets/gradient_app_bar.dart';
import 'package:isouq/common/widgets/no_item_view.dart';
import 'package:isouq/profile/models/item_model.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';



class cart extends StatefulWidget {
  @override
  _cartState createState() => _cartState();
}

class _cartState extends State<cart> {

  CartViewModel _viewModel;
  List<ItemModel> items;


  bool _showAppbar = true; //this is to show app bar
  ScrollController _scrollBottomBarController = new ScrollController(); // set controller on scrolling
  bool isScrollingDown = false;
  bool _show = true;
  double bottomBarHeight ;
  double totalProductsPrice;

  @override
  void dispose() {
    _scrollBottomBarController.removeListener(() {});
    super.dispose();
  }

  /// Declare price and value for chart
  @override
  void initState() {
    _viewModel = Provider.of<CartViewModel>(context,listen: false);
    _viewModel.getCartList();
    super.initState();
    appBarScroll();

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
    return Scaffold(
        appBar: _showAppbar
            ? AppBar(flexibleSpace:gradientAppBar(tr('cart')),)
            : PreferredSize(
          child: Container(),
          preferredSize: Size(0.0, 0.0),
        ),
        body: StreamBuilder<List<CartItemModel>>(
          stream: _viewModel.cartListController.stream,
          builder: (BuildContext context,
              AsyncSnapshot<List<CartItemModel>> cardSnapshot) {
            if (!cardSnapshot.hasData) {

              return Center(child: CircularProgressIndicator());

            } else {
              if (cardSnapshot.data.length == 0)
                {
                  return NoItemCart();
                }
                else
                  {
                    return StreamBuilder<List<ItemModel>>(
                      stream: _viewModel.itemListController.stream,
                      builder: (BuildContext context,
                          AsyncSnapshot<List<ItemModel>> snapshot) {
                        if(!snapshot.hasData)
                          {
                            return Center(child: CircularProgressIndicator(),);
                          }
                          else
                            {
                              if(snapshot.data.length == 0)
                                return NoItemCart();
                              else
                                {
                                  items = snapshot.data;
                                  print(' cart items length ${items.length}');
                                  totalProductsPrice = _calculateTotal(cardSnapshot);
                                  return Column(
                                    children: [
                                      Expanded(
                                        child: ListView.builder(
                                          controller: _scrollBottomBarController,
                                          itemCount: items.length,
                                          scrollDirection: Axis.vertical,
                                          itemBuilder: (context, position) {
                                            String q = cardSnapshot.data[position].quantity;
                                            int quantity = int.parse(
                                                q.isNotEmpty ? q : "0");
                                            double price = getItemPrice(items.elementAt(position));

                                            return cartRow(context, position, cardSnapshot, price, quantity);
                                          },
                                        ),
                                      ),
                                      Divider(
                                        height: 2.0,
                                        color: Colors.black12,
                                      ),
                                      Container(
                                        height: 80,
                                        padding: const EdgeInsets.only(
                                            top: 9.0, left: 10.0, right: 10.0),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.only(left: 10.0),

                                              /// Total price of item buy
                                              child: Text(
                                                '${tr('cartTotal')} ${totalProductsPrice.toString()} EGP',
                                                style: cartTotalStyle(),
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () {
                                                navigateToDeliveryScreen(context, snapshot, cardSnapshot);
                                              },
                                              child: Padding(
                                                padding:
                                                const EdgeInsets.only(right: 10.0),
                                                child: Container(
                                                  height: 40.0,
                                                  width: 120.0,
                                                  decoration: BoxDecoration(
                                                      color: Colors.green
//                                          Color(0xFFA3BDED),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      tr('cartPay'),
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontFamily: "Sans",
                                                          fontWeight: FontWeight.w600),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  );
                                }
                            }
                      },
                    );
                  }
            }
          },
        ));
  }

  void navigateToDeliveryScreen(BuildContext context, AsyncSnapshot<List<ItemModel>> snapshot, AsyncSnapshot<List<CartItemModel>> cardSnapshot) {
    Navigator.of(context).pop();
    Navigator.of(context)
        .push(PageRouteBuilder(
      pageBuilder: (_, __, ___) => delivery(items: snapshot.data,
          cartModelList: cardSnapshot.data,
          profileId: _viewModel.profileId,
      orderTotalPrice: totalProductsPrice,),
    ));
  }

  double getItemPrice(ItemModel item) {
    double price;
    if (item.newPrice.isEmpty) {
      price = double.parse(item.price.isNotEmpty ? item.price : "0");
    } else {
      price = double.parse(item.newPrice.isNotEmpty ? item.newPrice : "0");
    }
    return price;
  }


  _updateUI() async{
    await _viewModel.getCartList();
//    setState(() {
//    });
  }

  double _calculateTotal(AsyncSnapshot<List<CartItemModel>> cardSnapshot) {
    double totalPrice;
    double totalProductsPrice = 0;
    for (int i = 0; i < items.length; i++) {
      double price;
      price = getItemPrice(items.elementAt(i));
      totalPrice = price * int.parse(cardSnapshot.data.elementAt(i).quantity.isNotEmpty ? cardSnapshot.data.elementAt(i).quantity : "0");
      totalProductsPrice += totalPrice;
    }
    return totalProductsPrice;
  }

  Widget cartRow(BuildContext context, int position, AsyncSnapshot<List> cardSnapshot, double price, int value) {
    return Slidable(
      actionExtentRatio: 0.25,
      actions: <Widget>[
        new IconSlideAction(
          caption: tr('description'),
          color: Colors.blue,
          icon: Icons.archive,
          onTap: () {
            ///
            /// SnackBar show if cart Archive
            ///
            Scaffold.of(context)
                .showSnackBar(SnackBar(
              content: Text(items[position].desc),
              duration: Duration(seconds: 2),
              backgroundColor: Colors.blue,
            ));
          },
        ),
      ],
      secondaryActions: <Widget>[
        new IconSlideAction(
          key: Key(items[position].id.toString()),
          caption: tr('cartDelete'),
          color: Colors.red,
          icon: Icons.delete,
          onTap: () {

            _viewModel.deleteCart(cardSnapshot
                .data[position].id);

            _updateUI();

            ///
            /// SnackBar show if cart delet
            ///
            Scaffold.of(context)
                .showSnackBar(SnackBar(
              content: Text(tr('cartDeleted')),
              duration: Duration(seconds: 2),
              backgroundColor: Colors.redAccent,
            ));
          },
        ),
      ],
      actionPane: SlidableDrawerActionPane(),
      child: Padding(
        padding: const EdgeInsets.only(
            top: 10.0, left: 13.0, right: 13.0),

        /// Background Constructor for card
        child: Container(
          height: 250.0,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black12
                    .withOpacity(0.1),
                blurRadius: 3.5,
                spreadRadius: 0.4,
              )
            ],
          ),
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment:
                MainAxisAlignment.start,
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                      padding:
                      EdgeInsets.all(10.0),

                      /// Image item
                      child: Container(
                          decoration:
                          BoxDecoration(
                              color: Colors
                                  .white
                                  .withOpacity(
                                  0.1),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors
                                        .black12
                                        .withOpacity(
                                        0.1),
                                    blurRadius:
                                    0.5,
                                    spreadRadius:
                                    0.1)
                              ]),
                          child: Image.network(
                            '${items[position].image.length != 0 ? items[position].image.elementAt(0) : ""}',
                            height: 130.0,
                            width: 120.0,
                            fit: BoxFit.cover,
                          ))),
                  Flexible(
                    child: Padding(
                      padding:
                      const EdgeInsets.only(
                          top: 25.0,
                          left: 10.0,
                          right: 5.0),
                      child: Column(
                        /// Text Information Item
                        crossAxisAlignment:
                        CrossAxisAlignment
                            .start,
                        mainAxisAlignment:
                        MainAxisAlignment
                            .start,
                        children: <Widget>[
                          Text(
                            '${items[position].title}',
                            style: TextStyle(
                              fontWeight:
                              FontWeight.w700,
                              fontFamily: "Sans",
                              color:
                              Colors.black87,
                            ),
                            overflow: TextOverflow
                                .ellipsis,
                          ),
                          Padding(
                              padding:
                              EdgeInsets.only(
                                  top: 10.0)),
                          Text(
                            '${items[position].size}',
                            maxLines: 2,
                            style: TextStyle(
                              color:
                              Colors.black54,
                              fontWeight:
                              FontWeight.w500,
                              fontSize: 12.0,
                            ),
                          ),
                          Padding(
                              padding:
                              EdgeInsets.only(
                                  top: 10.0)),
                          Text(price.toString()),
                          Padding(
                            padding:
                            const EdgeInsets
                                .only(
                                top: 18.0,
                                left: 0.0),
                            child: Container(
                              width: 112.0,
                              decoration: BoxDecoration(
                                  color: Colors
                                      .white70,
                                  border: Border.all(
                                      color: Colors
                                          .black12
                                          .withOpacity(
                                          0.1))),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment
                                    .spaceAround,
                                children: <
                                    Widget>[
                                  /// Decrease of value item
                                  InkWell(
                                    onTap: () {
                                      if (value >
                                          1) {
                                        var quantity =
                                            value -
                                                1;
                                        _viewModel.updateCartQuantity(cardSnapshot
                                            .data[
                                        position]
                                            .id,quantity.toString());
                                        _updateUI();
                                      }
                                    },
                                    child:
                                    Container(
                                      height:
                                      30.0,
                                      width: 30.0,
                                      decoration:
                                      BoxDecoration(
                                          border:
                                          Border(right: BorderSide(color: Colors.black12.withOpacity(0.1)))),
                                      child: Center(
                                          child: Text(
                                              "-")),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets
                                        .symmetric(
                                        horizontal:
                                        18.0),
                                    child: Text(value
                                        .toString()),
                                  ),

                                  /// Increasing value of item
                                  InkWell(
                                    onTap: () {
                                      var quantity =
                                          value +
                                              1;
                                      _viewModel.updateCartQuantity(cardSnapshot
                                          .data[
                                      position]
                                          .id,quantity.toString());
                                      _updateUI();
                                    },
                                    child:
                                    Container(
                                      height:
                                      30.0,
                                      width: 28.0,
                                      decoration:
                                      BoxDecoration(
                                          border:
                                          Border(left: BorderSide(color: Colors.black12.withOpacity(0.1)))),
                                      child: Center(
                                          child: Text(
                                              "+")),
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
                ],
              ),
              (cardSnapshot.data[position].size
                  .isNotEmpty)
                  ? Row(
                children: <Widget>[
                  Padding(
                    padding:
                    const EdgeInsets
                        .all(8.0),
                    child: Text(tr('size')),
                  ),
                  Padding(
                    padding:
                    const EdgeInsets
                        .all(8.0),
                    child: Text(
                        cardSnapshot
                            .data[position]
                            .size,
                        style: TextStyle(
                            color: Colors
                                .black,
                            fontWeight:
                            FontWeight
                                .w500,
                            fontSize: 15.5,
                            fontFamily:
                            "Sans")),
                  )
                ],
              )
                  : SizedBox(),
              (cardSnapshot.data[position].color
                  .isNotEmpty)
                  ? Row(
                children: <Widget>[
                  Padding(
                    padding:
                    const EdgeInsets
                        .all(8.0),
                    child:
                    Text(tr('color')),
                  ),
                  Padding(
                    padding:
                    const EdgeInsets
                        .all(8.0),
                    child:
                    Text(
                        cardSnapshot
                            .data[position]
                            .color,
                        style: TextStyle(
                            color: Colors
                                .black,
                            fontWeight:
                            FontWeight
                                .w500,
                            fontSize: 15.5,
                            fontFamily:
                            "Sans")),
//                    Container(
//                      height: 20,
//                      width: 120,

//                      color: Color(int.parse(
//                          cardSnapshot
//                              .data[
//                          position]
//                              .color)),
//                    ),
                  )
                ],
              )
                  : SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}