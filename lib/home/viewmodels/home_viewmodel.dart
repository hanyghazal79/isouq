import 'dart:async';

import 'package:flutter/material.dart';
import 'package:isouq/Firebase/firebase_methods.dart';
import 'package:isouq/profile/models/item_model.dart';

class HomeViewModel extends ChangeNotifier {

  final firebaseSharedInstance = FirebaseMethods.sharedInstance;

  StreamController<List<ItemModel>> topRecommendedListController =
  StreamController.broadcast();

  streamBanner() {
    return firebaseSharedInstance.getItems(
        type: firebaseSharedInstance.banner);
  }

  streamMenu() {
    return firebaseSharedInstance.getItems(
        type: firebaseSharedInstance.menus);
  }

  streamPromotions() {
    return firebaseSharedInstance.getItems(
        type: firebaseSharedInstance.promotions);
  }

  streamOffers() {
    return firebaseSharedInstance.getSubItems(
        type: firebaseSharedInstance.item,
        parentId: firebaseSharedInstance.offers);
  }

  streamCategories() {
    return firebaseSharedInstance.getItems(
        type: firebaseSharedInstance.categoriesCollection);
  }

  streamRecommended() {
    return firebaseSharedInstance.getRecommendedItemsStream();
  }

//  streamHomeRecommended() async
//  {
//    return streamRecommended()
//        .first
//        .then((snapshot) {
//      var list = List<ItemModel>();
//      snapshot.documents.forEach((i) {
//        firebaseSharedInstance
//            .getItemDetailsById(itemId: i.documentID)
//            .then((i) {
//          var item = ItemModel.fromDocumentSnapshot(i);
//          list.add(item);
//
//          Comparator<ItemModel> recommendCountComparator = (a, b) => a.recommendedCount.compareTo(b.recommendedCount);
//          list.sort(recommendCountComparator);
//          topRecommendedListController.add(list);
//        });
//      });
//    });
//  }

  getOffersSubItemsStream() {
    return firebaseSharedInstance.getSubItems(
        parentId: firebaseSharedInstance.offers,
        type: firebaseSharedInstance.item);
  }

}