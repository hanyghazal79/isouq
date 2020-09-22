import 'dart:async';

import 'package:flutter/material.dart';
import 'package:isouq/Firebase/firebase_methods.dart';
import 'package:isouq/profile/models/OrderModel.dart';


class OrderListViewModel extends ChangeNotifier {


  final firebaseSharedInstance = FirebaseMethods.sharedInstance;
  StreamController<List<OrderModel>> orderListStreamController = StreamController<List<OrderModel>>.broadcast();


  void getOrderList(String id) {
    firebaseSharedInstance.getOrderList().then((orderSnapshot) {
      var orderUserModelList = List<OrderModel>();
      orderSnapshot.documents.forEach((order) {
        var orderModel = OrderModel.fromDocumentSnapshot(order);
        if (id == orderModel.userInformationModel.userId) {
          if (!orderUserModelList.contains(orderModel)) {
            orderUserModelList.add(orderModel);
            orderListStreamController.add(orderUserModelList);
          }
        }
      });
    });
  }

  @override
  void dispose() {
    orderListStreamController.close();
    super.dispose();
  }


}