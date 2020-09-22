import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';

class ProfileModel  {

  String id,email,name,avatar,platform,phone;

  ProfileModel(this.id,this.email, this.name,this.avatar,this.platform,this.phone);



  ProfileModel.fromSnapshot(DataSnapshot snapshot) :
        id = snapshot.key,
        email = snapshot.value["email"],
        name = snapshot.value["name"],
        avatar = snapshot.value["avatar"],
        phone = snapshot.value["phone"],
        platform = snapshot.value["platform"];

  ProfileModel.fromDocumentSnapshot(DocumentSnapshot snapshot) :
        id = snapshot.id,
        email = (snapshot!=null && snapshot.get("email")!=null) ? snapshot.get("email") : "",
        name = (snapshot!=null && snapshot.get("name")!=null) ? snapshot.get("name") : "",
        platform = (snapshot!=null && snapshot.get("platform")!=null) ? snapshot.get("platform") : "",
        phone = (snapshot!=null && snapshot.get("phone")!=null) ? snapshot.get("phone") : "",
        avatar = (snapshot!=null && snapshot.get("avatar") !=null) ? snapshot.get("avatar") : "" ;

  toJson() {
    return {
      "id" : id,
      "email": email,
      "name": name,
      "avatar": avatar,
      "phone" : phone,
      "platform" : platform
    };
  }


}