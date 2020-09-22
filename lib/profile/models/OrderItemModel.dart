import 'package:cloud_firestore/cloud_firestore.dart';


class OrderItemModel {
  String id, quantity, itemId, status, color, size, image,time;

  OrderItemModel(
      {this.id,
      this.quantity,
      this.itemId,
      this.status,
      this.size,
      this.color,
      this.time,
      this.image});

  OrderItemModel.fromDocumentSnapshot(DocumentSnapshot snapshot)
      : id = snapshot.id,
        itemId = (snapshot != null && snapshot.get("itemId") != null) ? snapshot.get("itemId") : "",
        status = (snapshot != null && snapshot.get("status") != null) ? snapshot.get("status") : "",
        time = (snapshot != null && snapshot.get("time") != null) ? snapshot.get("time") : "",
        image = (snapshot != null && snapshot.get("image") != null) ? snapshot.get("image") : "",
        color = (snapshot != null && snapshot.get("color") != null) ? snapshot.get("color") : "",
        size = (snapshot != null && snapshot.get("size") != null) ? snapshot.get("size") : "",
        quantity = (snapshot != null && snapshot.get("quantity") != null) ? snapshot.get("quantity") : "";

  factory OrderItemModel.fromMap(Map<String, dynamic> map) {
    return OrderItemModel(
        itemId: map['itemId'],
        id: map['id'],
        image: map['image'],
        status: map['status'],
        time: map['time'],
        color: map['color'],
        size: map['size'],
        quantity: map['quantity']);
  }

  toJson() {
    return {
      "id": id,
      'status': status,
      'itemId': itemId,
      'image': image,
      'color': color,
      'time': time,
      'size': size,
      'quantity': quantity,
    };
  }
}
