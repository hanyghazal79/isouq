import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:isouq/common/widgets/gradient_app_bar.dart';
import 'package:isouq/common/widgets/no_item_view.dart';
import 'package:isouq/profile/models/OrderModel.dart';
import 'package:isouq/profile/viewmodels/order_list_viewmodel.dart';
import 'package:isouq/profile/views/order_card_view.dart';
import 'package:provider/provider.dart';

class OrderList extends StatefulWidget {
  String id;

  OrderList(this.id);

  @override
  _OrderListState createState() => _OrderListState();
}

class _OrderListState extends State<OrderList> {

  OrderListViewModel _viewModel ;

  @override
  void initState() {
    _viewModel = Provider.of<OrderListViewModel>(context,listen: false);
    _viewModel.getOrderList(widget.id);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: gradientAppBar(tr('orderList')),

      body: Container(
        child: Column(
          children: <Widget>[
            StreamBuilder<List<OrderModel>>(
              stream: _viewModel.orderListStreamController.stream,
              builder: (BuildContext context,
                  AsyncSnapshot<List<OrderModel>> userOrdersSnapshot) {
                if (userOrdersSnapshot.hasData) {
                  var orderItems = List<OrderModel>();
                  userOrdersSnapshot.data.forEach((order){
                    orderItems.add(order);
                  });

                  if (orderItems.length > 0) {
                    return Expanded(
                        child: ListView.builder(
                            itemCount: orderItems.length,
                            itemBuilder: (c, index) {
                              return OrderCard(userOrdersSnapshot.data[index]);
                            }));
                  } else {
                    return Expanded(child: CircularProgressIndicator());
                  }
                } else {
                  return Expanded(
                      child: Center(
                        child: NoItemCart(),
                      ));
                }
              },
            )
          ],
        ),
      ),
    );
  }
}