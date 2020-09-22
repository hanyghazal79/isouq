import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:isouq/profile/models/UserInformationModel.dart';
import 'OrderItemModel.dart';

class OrderModel {
  String id, status, time;
  List<OrderItemModel> orderItems;
  UserInformationModel userInformationModel;

  OrderModel.fromDocumentSnapshot(DocumentSnapshot snapshot)
      : id = (snapshot != null && snapshot.id != null)?snapshot.id:'',
        status = (snapshot != null && snapshot.get("status") != null) ? snapshot.get("status") : "",
        time = (snapshot != null && snapshot.get("time") != null) ? snapshot.get("time") : "",
        orderItems =
            (snapshot != null && snapshot.get("products_info") != null)
                ? (snapshot.get("products_info") as Map)
                    .values
                    .map((e) => OrderItemModel.fromMap(e))
                    .toList()
                : List(),
        userInformationModel =
            (snapshot != null && snapshot.get("user_information") != null)
                ? UserInformationModel.fromMap(snapshot.get("user_information"))
                : UserInformationModel();

}
