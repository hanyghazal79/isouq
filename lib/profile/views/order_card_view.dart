import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:isouq/profile/models/OrderModel.dart';

import 'order_details_view.dart';

/// Constructor for itemCard for List Menu
class OrderCard extends StatelessWidget {
  /// Declaration and Get data from BrandDataList.dart
  final OrderModel orderModel;
  OrderCard(this.orderModel);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
      const EdgeInsets.only(left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
      child: InkWell(
        onTap: () {
          Navigator.of(context).pushAndRemoveUntil(
              PageRouteBuilder(
                  pageBuilder: (_, __, ___) =>
                  new OrderDetails(
                    orderModel: orderModel,
                  ),
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
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(15.0))),
          child: Hero(
            tag: 'hero-tag-${orderModel.hashCode}',
            transitionOnUserGestures: true,
            child: Material(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: orderModel.orderItems
                          .elementAt(0)
                          .image == null
                          ? AssetImage('assest/icon/shopping-cart')
                          : NetworkImage(
                          orderModel.orderItems
                          .elementAt(0)
                          .image)),
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
                      DateFormat('dd / MM / yyy')
                          .format(DateTime.parse(orderModel.orderItems
                          .elementAt(0)
                          .time)),
                      style: TextStyle(
                        color: Colors.white,
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