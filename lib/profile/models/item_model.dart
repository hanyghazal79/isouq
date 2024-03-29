import 'package:cloud_firestore/cloud_firestore.dart';


class ItemModel {
  String id,
      title,
      price,
      rating,
      sale,
      desc,
      type,
      stock,
      productDetails,
      parentId,
      place,
      ratingStart,
      sellerName,
      newPrice,
      time,
      markedRecommended; // for recommended items
  List color, size, image, imageId;
  int recommendedCount;

  ItemModel(
      {this.id,
      this.image,
      this.title,
      this.price,
      this.rating,
      this.sale,
      this.stock,
      this.size,
      this.color,
      this.time,
      this.productDetails,
      this.desc,
      this.imageId,
      this.parentId,
      this.type,
      this.place,
      this.ratingStart,
      this.sellerName,
      this.newPrice});

  ItemModel.fromDocumentSnapshot(DocumentSnapshot snapshot)
      : id = (snapshot != null && snapshot.id != null)
            ? snapshot.id
            : "",
        image = (snapshot != null && snapshot.data != null && snapshot.get("image") != null)
            ? snapshot.get("image")
            : List(),
        title = (snapshot != null && snapshot.data != null && snapshot.get("title") != null)
            ? snapshot.get("title")
            : "",
        price = (snapshot != null && snapshot.data != null && snapshot.get("price") != null)
            ? snapshot.get("price")
            : "",
        rating = (snapshot != null && snapshot.data != null && snapshot.get("rating") != null)
            ? snapshot.get("rating")
            : "",
        imageId = (snapshot != null && snapshot.data != null && snapshot.get("imageId") != null)
            ? snapshot.get("imageId")
            : List(),
        type = (snapshot != null && snapshot.data != null && snapshot.get("type") != null)
            ? snapshot.get("type")
            : "",
        size = (snapshot != null && snapshot.data != null && snapshot.get("size") != null)
            ? snapshot.get("size")
            : List(),
        color = (snapshot != null && snapshot.data != null && snapshot.get("color") != null)
            ? snapshot.get("color")
            : List(),
        time = (snapshot != null && snapshot.data != null && snapshot.get("time") != null)
            ? snapshot.get("time")
            : "",
        parentId = (snapshot != null && snapshot.data != null && snapshot.get("parentId") != null)
            ? snapshot.get("parentId")
            : "",
        sale = (snapshot != null && snapshot.data != null && snapshot.get("sale") != null)
            ? snapshot.get("sale")
            : "",
        newPrice = (snapshot != null && snapshot.data != null && snapshot.get("newPrice") != null)
            ? snapshot.get("newPrice")
            : "",
        productDetails =
            (snapshot != null && snapshot.data != null && snapshot.get("productDetails") != null)
                ? snapshot.get("productDetails")
                : "",
        stock = (snapshot != null && snapshot.data != null && snapshot.get("stock") != null)
            ? snapshot.get("stock")
            : "",
        place = (snapshot != null && snapshot.data != null && snapshot.get("place") != null)
            ? snapshot.get("place")
            : "",

        ratingStart = (snapshot != null && snapshot.data != null && snapshot.get("ratingStart") != null)
            ? snapshot.get("ratingStart")
            : "",
        sellerName = (snapshot != null && snapshot.data != null && snapshot.get("sellerName") != null)
            ? snapshot.get("sellerName")
            : "",
        desc = (snapshot != null && snapshot.data != null && snapshot.get("desc") != null)
            ? snapshot.get("desc")
            : "",
        markedRecommended = (snapshot != null && snapshot.get("markedRecommended") != null)
            ? snapshot.get("markedRecommended")
            : "false",
        recommendedCount = (snapshot != null && snapshot.get("recommendedCount") != null)
            ? snapshot.get("recommendedCount")
            : 0;

//  int getRecommendedCount()
//  {
//
//}

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "image": image,
      "title": title,
      "price": price,
      "rating": rating,
      "size": size,
      "color": color,
      "time": time,
      "sale": sale,
      "imageId": imageId,
      "productDetails": productDetails,
      "stock": stock,
      "type": type,
      "parentId": parentId,
      "place": place,
      "newPrice": newPrice,
      "ratingStart": ratingStart,
      "sellerName": sellerName,
      "desc": desc,
      "recommendedCount": 0,
      "markedRecommended": "false"
    };
  }
}
