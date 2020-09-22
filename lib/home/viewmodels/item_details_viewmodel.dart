import 'dart:async';

import 'package:flutter/material.dart';
import 'package:isouq/Firebase/firebase_methods.dart';
import 'package:isouq/profile/models/item_model.dart';
import 'package:isouq/profile/models/profileModel.dart';
import 'package:isouq/profile/viewmodels/profile_viewmodel.dart';

class ItemDetailsViewModel extends ChangeNotifier
{
  String profileId;
  final firebaseSharedInstance = FirebaseMethods.sharedInstance;

  var topRatedList = List<ItemModel>();
  StreamController<List<ItemModel>> topRatedListController =
  StreamController.broadcast();

  var colorSelected;
  var sizeSelected;

  List<bool> sizeList;
  List<bool> colorList;

  ItemDetailsViewModel()
  {
    getProfile();
  }

  Stream<ItemModel> getItemDetailsStream (String id)
  {
    return firebaseSharedInstance.getItemDetailsStream(itemId: id).map((snapshot) => ItemModel.fromDocumentSnapshot(snapshot));
  }

  addListSize(int size) {
    sizeList = List.generate(size, (i) => false);
  }

  addSizeItemSelect(int index) {
    sizeList.forEach((i) => false);
    sizeList[index] = true;
    notifyListeners();
  }

  addListColor(int size) {
    colorList = List.generate(size, (i) => false);
  }

  addColorItemSelect(int index) {
    colorList.forEach((i) => false);
    colorList[index] = true;
    notifyListeners();
  }

  Future<ProfileModel> getProfile() async
  {
    var profile = await getProfileFuture();
    profileId = profile.id;
    return profile;
  }

  getCartItemsFuture() {
    return firebaseSharedInstance.getCartItems(profileId);
  }

  getTopRatedSubItemsStream() {
    return firebaseSharedInstance.getSubItems(
        type: firebaseSharedInstance.item,
        parentId: firebaseSharedInstance.topRated);
  }

  void getTopRatedList() async{
//    var userProfile = await getProfile();
    getTopRatedSubItemsStream()
        .first
        .then((snapshot) {
      var list = List<ItemModel>();
      snapshot.documents.forEach((i) {
        firebaseSharedInstance
            .getItemDetailsById(itemId: i.documentID)
            .then((i) {
          var item = ItemModel.fromDocumentSnapshot(i);
          list.add(item);
          topRatedListController.add(list);
        });
      });
      topRatedList = list;
    });
  }

  getUserRatingsStream(String itemId) {
    return firebaseSharedInstance.getUserRatingSnapshot(
        itemId: itemId);
  }

  void addToCart(object) async{
    await firebaseSharedInstance.addToCart(
      userId: profileId,
      object: object,
    );
  }

  void addToFavourite(String itemId) {
    firebaseSharedInstance.addToFavorite(
      id: itemId,
      object: {'itemFavorite': itemId},
      userId: profileId,
    );
  }

  void addRatingToItem(String itemId, Object object)
  {
    firebaseSharedInstance.addRatingToItem(itemId, object);
  }

  void addRecommendationToItem(String itemId, int recommendedCount)
  {
    firebaseSharedInstance.addRecommendationToItem(itemId, recommendedCount);
  }


}