import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:isouq/Firebase/firebase_methods.dart';
import 'package:isouq/common/widgets/gradient_app_bar.dart';
import 'package:isouq/profile/models/OrderModel.dart';
import 'package:isouq/profile/models/item_model.dart';
import 'package:isouq/profile/viewmodels/order_details_viewmodel.dart';
import 'package:provider/provider.dart';


class OrderDetails extends StatefulWidget {
  final OrderModel orderModel;

  const OrderDetails({Key key, this.orderModel}) : super(key: key);

  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {

  OrderDetailsViewModel _viewModel;


  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _viewModel = Provider.of<OrderDetailsViewModel>(context,listen: false);
    _viewModel.getOrderItems(widget.orderModel);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: gradientAppBar(tr('OrderDetails')),

        body: Container(
          child: StreamBuilder<List<ItemModel>>(
              stream: _viewModel.itemListController.stream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<ItemModel> items = List();
                  items = snapshot.data;
                  int totalPrice;
                  int totalProductsPrice = 0;
                  print(items.length.toString()+"kkkkkkkkkkkkk");

                  for (int i = 0; i < items.length; i++) {
                    int price;
                    if (items.elementAt(i).newPrice.isEmpty) {
                      price = int.parse(items.elementAt(i).price);
                    } else {
                      price = int.parse(items.elementAt(i).newPrice);
                    }
                    totalPrice = price *
                        int.parse(widget.orderModel.orderItems
                            .elementAt(i)
                            .quantity);
                    totalProductsPrice += totalPrice;
                  }

                  return Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                            itemCount: items.length,
                            scrollDirection: Axis.vertical,
                            itemBuilder: (context, position) {
                              var color = widget.orderModel
                                  .orderItems[position].color;
                              var size = widget.orderModel
                                  .orderItems[position].color;

                              int value = int.parse(widget.orderModel
                                  .orderItems[position].quantity);
                              int itemPrice;
                              if (items.elementAt(position).newPrice.isEmpty) {
                                itemPrice =
                                    int.parse(items.elementAt(position).price);
                              } else {
                                itemPrice = int.parse(
                                    items.elementAt(position).newPrice);
                              }
                              var pay = itemPrice *
                                  int.parse(widget.orderModel.orderItems
                                      .elementAt(position)
                                      .quantity);
                              return Slidable(
                                actionExtentRatio: 0.25,
                                actions: <Widget>[
                                  new IconSlideAction(
                                    caption: tr('description'),
                                    color: Colors.black,
                                    icon: Icons.archive,
                                    onTap: () {
                                      Scaffold.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text(items[position].desc),
                                        duration: Duration(seconds: 2),
                                        backgroundColor: Colors.blue,
                                      ));
                                    },
                                  ),
                                ],
                                actionPane: SlidableDrawerActionPane(),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 1.0, left: 13.0, right: 13.0),

                                  /// Background Constructor for card
                                  child: Container(
                                    height: 290.0,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color:
                                          Colors.black12.withOpacity(0.1),
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
                                                padding: EdgeInsets.all(10.0),

                                                /// Image item
                                                child: Container(
                                                    decoration: BoxDecoration(
                                                        color: Colors.white
                                                            .withOpacity(0.1),
                                                        boxShadow: [
                                                          BoxShadow(
                                                              color: Colors
                                                                  .black12
                                                                  .withOpacity(
                                                                  0.1),
                                                              blurRadius: 0.5,
                                                              spreadRadius: 0.1)
                                                        ]),
                                                    child: Image.network(
                                                      '${items[position].image.elementAt(0)}',
                                                      height: 130.0,
                                                      width: 120.0,
                                                      fit: BoxFit.cover,
                                                    ))),
                                            Flexible(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 25.0,
                                                    left: 10.0,
                                                    right: 5.0),
                                                child: Column(
                                                  /// Text Information Item
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                                  children: <Widget>[
                                                    Text(
                                                      '${items[position].title}',
                                                      style: TextStyle(
                                                        fontWeight:
                                                        FontWeight.w700,
                                                        fontFamily: "Sans",
                                                        color: Colors.black87,
                                                      ),
                                                      overflow:
                                                      TextOverflow.ellipsis,
                                                    ),
                                                    Padding(
                                                        padding:
                                                        EdgeInsets.only(
                                                            top: 10.0)),
                                                    Text(
                                                      '${items[position].size}',
                                                      maxLines: 2,
                                                      style: TextStyle(
                                                        color: Colors.black54,
                                                        fontWeight:
                                                        FontWeight.w500,
                                                        fontSize: 12.0,
                                                      ),
                                                    ),
                                                    Padding(
                                                        padding:
                                                        EdgeInsets.only(
                                                            top: 10.0)),
                                                    Text(itemPrice.toString()),
                                                    Padding(
                                                      padding:
                                                      const EdgeInsets.only(
                                                          top: 18.0,
                                                          left: 0.0),
                                                      child: Container(
                                                        width: 112.0,
                                                        decoration: BoxDecoration(
                                                            color:
                                                            Colors.white70,
                                                            border: Border.all(
                                                                color: Colors
                                                                    .black12
                                                                    .withOpacity(
                                                                    0.1))),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceAround,
                                                          children: <Widget>[
                                                            /// Decrease of value item
                                                            Container(
                                                              height: 30.0,
                                                              width: 30.0,
                                                              decoration: BoxDecoration(
                                                                  border: Border(
                                                                      right: BorderSide(
                                                                          color: Colors
                                                                              .black12
                                                                              .withOpacity(0.1)))),
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
                                                            Container(
                                                              height: 30.0,
                                                              width: 28.0,
                                                              decoration: BoxDecoration(
                                                                  border: Border(
                                                                      left: BorderSide(
                                                                          color: Colors
                                                                              .black12
                                                                              .withOpacity(0.1)))),
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
                                        size.isNotEmpty
                                            ? Row(
                                          children: <Widget>[
                                            Padding(
                                              padding:
                                              const EdgeInsets.all(
                                                  8.0),
                                              child: Text(tr('size')),
                                            ),
                                            Padding(
                                              padding:
                                              const EdgeInsets.all(
                                                  8.0),
                                              child: Text(size,
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                      FontWeight.w500,
                                                      fontSize: 15.5,
                                                      fontFamily:
                                                      "Sans")),
                                            )
                                          ],
                                        )
                                            : SizedBox(),
                                        color.isNotEmpty
                                            ? Row(
                                          children: <Widget>[
                                            Padding(
                                              padding:
                                              const EdgeInsets.all(
                                                  8.0),
                                              child: Text(tr('color')),
                                            ),
                                            Padding(
                                              padding:
                                              const EdgeInsets.all(
                                                  8.0),
                                              child: Container(
                                                height: 20,
                                                width: 120,
                                                color: Color(
                                                    int.parse(color)),
                                              ),
                                            )
                                          ],
                                        )
                                            : SizedBox(),
                                        Divider(
                                          height: 2.0,
                                          color: Colors.black12,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 9.0,
                                              left: 10.0,
                                              right: 10.0),
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 10.0),

                                                /// Total price of item buy
                                                child: Text(
                                                  tr('cartTotal') +
                                                      pay.toString() +
                                                      " \$",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                      FontWeight.w500,
                                                      fontSize: 15.5,
                                                      fontFamily: "Sans"),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 10.0),
                                                child: Container(
                                                  height: 40.0,
                                                  width: 120.0,
                                                  decoration: BoxDecoration(
                                                    color: Color(0xFFA3BDED),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      widget
                                                          .orderModel
                                                          .orderItems[
                                                      position]
                                                          .status,
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontFamily: "Sans",
                                                          fontWeight:
                                                          FontWeight.w600),
                                                    ),
                                                  ),
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
                            }),
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),

                              /// Total price of item buy
                              child: Text(
                                tr('cartTotal') +
                                    "\$" +
                                    totalProductsPrice.toString(),
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15.5,
                                    fontFamily: "Sans"),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 10.0),
                              child: Container(
                                height: 40.0,
                                width: 120.0,
                                decoration: BoxDecoration(
                                  color: Color(0xFFA3BDED),
                                ),
                                child: Center(
                                  child: Text(
                                    widget.orderModel.status,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: "Sans",
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }),
        ));
  }
}
