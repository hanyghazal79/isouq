import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';

class RatingModel {
  String id,userImage, ratingTime, rating, desc;

  RatingModel({
    this.id,
    this.userImage,
    this.ratingTime,
    this.rating,
    this.desc
  });

  RatingModel.fromSnapshot(DataSnapshot snapshot) :
        id = snapshot.key,
        rating = snapshot.value["rating"],
        ratingTime = snapshot.value["title"],
        desc = snapshot.value["desc"],
        userImage = snapshot.value["image"];

  RatingModel.fromDocumentSnapshot(DocumentSnapshot snapshot) :
        id = snapshot.id,
        rating = (snapshot!=null && snapshot.get("rating")!=null) ? snapshot.get("rating") : "",
        ratingTime = (snapshot!=null && snapshot.get("rating_time")!=null) ? snapshot.get("rating_time") : "",
        desc = (snapshot!=null && snapshot.get("desc")!=null) ? snapshot.get("desc") : "",
        userImage = (snapshot!=null && snapshot.get("user_image")!=null) ? snapshot.get("user_image") : "";

  static List<RatingModel> getRatingList(List<DocumentSnapshot> snapshots)
  {
    List<RatingModel> ratings = new List();
    for(DocumentSnapshot doc in snapshots)
      ratings.add(RatingModel.fromDocumentSnapshot(doc));
    return ratings;
  }

  toMap() {
    return {
      "rating_time": ratingTime,
      "rating": rating,
      "user_image": userImage,
      "desc": desc
    };
  }
}