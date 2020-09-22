import 'dart:async';

import 'package:flutter/material.dart';
import 'package:isouq/Firebase/firebase_methods.dart';
import 'package:isouq/Helpers/app_tools.dart';
import 'package:isouq/cart/models/cart_item_model.dart';
import 'package:isouq/profile/models/item_model.dart';

class CartViewModel extends ChangeNotifier{
  String profileId;
  final firebaseSharedInstance = FirebaseMethods.sharedInstance;

  StreamController<List<CartItemModel>> cartListController =
  StreamController.broadcast();
  StreamController<List<ItemModel>> itemListController =
  StreamController.broadcast();



  void getCartList() async{
    profileId = await getDataLocally(key: firebaseSharedInstance.profileId);
    firebaseSharedInstance.getCartItems(profileId).first.then((snapshot) {
      var itemList = List<ItemModel>();
      var cardList = List<CartItemModel>();
      snapshot.documents.forEach((i) {
        var card = CartItemModel.fromDocumentSnapshot(i);
        cardList.add(card);
        firebaseSharedInstance
            .getItemDetailsById(itemId: card.productId)
            .then((x) {
              if (x != null && x != false) {
                var item = ItemModel.fromDocumentSnapshot(x);
                itemList.add(item);
                itemListController.add(itemList);
              }
        });
      });
      cartListController.add(cardList);
    });
  }

  deleteCart (String cartId)
  {
    firebaseSharedInstance.deleteCart(userId: profileId, cartId: cartId);
  }

  updateCartQuantity(String cartId, String quantity)
  {
    firebaseSharedInstance.updateCartQuantity(userId: profileId, id: cartId, quantity: quantity);
  }

  placeOrder ({Object userOrder})
  {
    firebaseSharedInstance.addToOrder(object: userOrder);

  }



  @override
  void dispose() {
    cartListController.close();
    itemListController.close();
    super.dispose();
  }

}