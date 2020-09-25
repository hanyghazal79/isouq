import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:isouq/Firebase/firebase_methods.dart';
import 'package:isouq/Helpers/app_tools.dart';
import 'package:isouq/common/ui_events/ui_events.dart';
import 'package:isouq/profile/models/item_model.dart';
import 'package:isouq/profile/models/profileModel.dart';

final firebaseSharedInstance = FirebaseMethods.sharedInstance;

class ProfileViewModel extends ChangeNotifier {
  final db = FirebaseMethods.sharedInstance.getFirestore();

  StreamController<ProfileModel> profileStreamController =
      StreamController<ProfileModel>.broadcast();

  StreamController<UiEvents> eventsStreamController =
      StreamController<UiEvents>.broadcast();
  var favoriteList = List<ItemModel>();
  StreamController<List<ItemModel>> favoriteListController =
      StreamController.broadcast();

  ProfileModel profile;

  String errorMessageEvent = '';

  ProfileViewModel();

  getProfile() async {
    profile = await getProfileFuture();
    profileStreamController.add(profile);
  }

  isValidSignUpdateProfile(String name, String phone) {
    if (name == null || name.trim().isEmpty) {
      errorMessageEvent = tr('right name');
      return false;
    }
    if (phone == null || phone.trim().isEmpty || phone.length < 11) {
      errorMessageEvent = tr('right num');
      return false;
    }

    return true;
  }

  updateProfile(File _imageFile, String phone, String name) async {
    eventsStreamController.add(UiEvents.loading);
    notifyListeners();
    if (_imageFile != null) {
      String imageUrl =
          await firebaseSharedInstance.pickSaveImage(_imageFile, profile.id);

      Firestore.instance
          .collection(firebaseSharedInstance.userCollection)
          .document(profile.id)
          .updateData({
        'phone': phone,
        'name': name,
        'avatar': imageUrl
      }).whenComplete(() {
        eventsStreamController.add(UiEvents.completed);
        notifyListeners();

        eventsStreamController.add(UiEvents.showMessage);
        notifyListeners();
      });
    } else {
      firebaseSharedInstance.firestore
          .collection(firebaseSharedInstance.userCollection)
          .document(profile.id)
          .updateData({
        'phone': phone,
        'name': name,
      }).whenComplete(() {
        eventsStreamController.add(UiEvents.completed);
        notifyListeners();

        eventsStreamController.add(UiEvents.showMessage);
        notifyListeners();
      });
    }
  }

  void getFavoriteList() async {
//    profileStreamController.stream.listen((event) {
//      print("profile id = ${profile.id}");
      var favorites = firebaseSharedInstance.getFavoriteItems(
          userId: profile.id) ;
      var list = List<ItemModel>();

      favorites.first.then((snapshot){
        snapshot.documents.forEach((document) {
          var favId = document['itemFavorite'];
          firebaseSharedInstance
              .getItemDetailsById(itemId: favId)
              .then((favId) {
            var item = ItemModel.fromDocumentSnapshot(favId);
            list.add(item);
            favoriteListController.add(list);
          });
        });
      });
      favoriteList = list;
      print("favourite length = ${favoriteList.length}");
//    });
    notifyListeners();
  }

  void deleteFavourite(String favId) async{
    await firebaseSharedInstance.deleteFavoriteItem(id: favId, userId: profile.id);
    getFavoriteList();
    notifyListeners();
  }

  logout() async {
    await firebaseSharedInstance.signOut();
    if (firebaseSharedInstance.currentFirebaseUser == null) {
      eventsStreamController.add(UiEvents.navigateToLogin);
      notifyListeners();
    }
  }

//  @override
//  void dispose() {
////    profileStreamController.close();
//    super.dispose();
//  }

}

Future<ProfileModel> getProfileFuture() async {
  String profileId =
      await getDataLocally(key: firebaseSharedInstance.profileId);
  var profileSnap = await firebaseSharedInstance.getProfileById(profileId);
  return ProfileModel.fromDocumentSnapshot(profileSnap);
}
