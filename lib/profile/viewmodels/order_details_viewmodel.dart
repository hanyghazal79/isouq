import 'dart:async';

import 'package:flutter/material.dart';
import 'package:isouq/Firebase/firebase_methods.dart';
import 'package:isouq/profile/models/OrderModel.dart';
import 'package:isouq/profile/models/item_model.dart';


class OrderDetailsViewModel extends ChangeNotifier {

  final firebaseSharedInstance = FirebaseMethods.sharedInstance;
  StreamController<List<ItemModel>> itemListController =
  StreamController.broadcast();

  getOrderItems(OrderModel orderModel) {
    var itemList = List<ItemModel>();
    orderModel.orderItems.forEach((orderItem) {
      firebaseSharedInstance.getItemDetailsById(itemId: orderItem.itemId).then((v) {
        var item = ItemModel.fromDocumentSnapshot(v);
        itemList.add(item);
        itemListController.add(itemList);
        print(itemList.length.toString());
      });
    });
  }




//  @override
//  void dispose() {
//    itemListController.close();
//    super.dispose();
//  }


}