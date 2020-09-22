import 'package:cloud_firestore/cloud_firestore.dart';

class CartItemModel {
  String id, productId, size, color,quantity,price,title;


  CartItemModel({this.id, this.productId, this.size, this.color, this.quantity,this.price,this.title});

  CartItemModel.fromDocumentSnapshot(DocumentSnapshot snapshot) :
        id = snapshot.id,
        productId = (snapshot!=null && snapshot.get("id")!=null) ? snapshot.get("id") : "",
        color = (snapshot!=null && snapshot.get("color")!=null) ? snapshot.get("color") : "",
        quantity = (snapshot!=null && snapshot.get("quantity")!=null) ? snapshot.get("quantity") : "",
        price = (snapshot!=null && snapshot.get("price")!=null) ? snapshot.get("price") : "",
        title = (snapshot!=null && snapshot.get("title")!=null) ? snapshot.get("title") : "",
        size = (snapshot!=null && snapshot.get("size")!=null) ? snapshot.get("size") : "";


  toMap() {
    return {
      "id": productId,
      "color": color,
      "size": size,
      "quantity": quantity,
      "price": price,
      "title": title,
    };
  }
}
