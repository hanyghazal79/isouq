import 'package:cloud_firestore/cloud_firestore.dart';

class UserInformationModel {
  String id,
      userCity,
      userLocal,
      userName,
      userPhone1,
      userPhone2,
      userId;

  UserInformationModel({this.id, this.userCity, this.userLocal, this.userName,
      this.userPhone1, this.userPhone2, this.userId});

  UserInformationModel.fromDocumentSnapshot(DocumentSnapshot snapshot)
      : id = snapshot.id,
        userId = (snapshot != null && snapshot.get("userId") != null)
            ? snapshot.get("userId")
            : "",
        userName = (snapshot != null && snapshot.get("userName") != null)
            ? snapshot.get("userName")
            : "",
        userCity = (snapshot != null && snapshot.get("userCity") != null)
            ? snapshot.get("userCity")
            : "",
        userPhone1 = (snapshot != null && snapshot.get("userNumber1") != null)
            ? snapshot.get("userNumber1")
            : "",
        userPhone2 = (snapshot != null && snapshot.get("userNumber2") != null)
            ? snapshot.get("userNumber2")
            : "",
        userLocal = (snapshot != null && snapshot.get("userLocal") != null)
            ? snapshot.get("userLocal")
            : "";

  factory UserInformationModel.fromMap(Map<String, dynamic> map) {
    return UserInformationModel(
        userLocal: map['userLocal'],
        userPhone2: map['userNumber2'],
        userPhone1: map['userNumber1'],
        userName: map['userName'],
        id: map['id'],
        userCity: map['userCity'],
        userId: map['userId'],
        );
  }
}
