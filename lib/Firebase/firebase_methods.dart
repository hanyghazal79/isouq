import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:isouq/home/models/NotificationModel.dart';
import 'package:isouq/home/models/RatingModel.dart';
import 'package:isouq/profile/models/profileModel.dart';
import 'dart:io';
import 'package:isouq/Helpers/app_tools.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseMethods {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseDatabase _database = FirebaseDatabase.instance;
  User currentFirebaseUser;

  String currentProfileId;
  Stream<ProfileModel> profileStream;
  Stream<User> firebaseUserStream;

  bool isIos = Platform.isIOS;

  /////////////// user collection////////////
  String userCollection = "users";
  String profileId = "id",
      email = "email",
      name = "name",
      avatar = "avatar",
      platform = "platform";

  ////////////////// collections ///////////////////////
  String notificationCollection = "notifications";
  String itemsCollection = "items";
//  String category = "category";
  String brandsCollection = "brands";
  String menuCollection = "menus";
  String offerCollection = "offers";
  String recommendedCollection = "recommended";
  String categoriesCollection = "categories";
  String promotionsCollection = 'promotions';
  String topRatedCollection = 'top_rated';
  String cart = 'card';
  String userOrder = 'userOrder';
  String orders = 'orders';
  String prizes = 'prizes';
  String favorite = 'favorite';
  String items = 'items';
  String item = 'item';
  String type = 'type';
  String parentId = 'parentId';
  String banner = 'banner';
  String promotions = 'promotions';
  String menus = 'menus';
  String offers = 'offers';
  String brand = 'brand';
  String topRated = 'topRated';

  /////////////////////////////////////////////////
  String success = 'Success';
  String loggedIN = "loggedIN";
  String usersRating = "usersRating";
  ////////////////////////////////////////////
  String markedRecommended = "markedRecommended";

  String _errorMessageEvent = "";

  getItems({String type}) {
    var itemsSnapShots = firestore
        .collection(items)
        .where(this.type, isEqualTo: type)
        .snapshots();
    return itemsSnapShots;
  }

  Stream<List<NotificationModel>> streamNotification() {
    return firestore.collection(notificationCollection).snapshots().map(
            (collectionSnaps) =>
            NotificationModel.getListOfNotification(collectionSnaps.docs));
  }

  Future getItemDetailsById({String itemId}) {
    return firestore.collection(items).doc(itemId).get();
  }

  Stream getItemDetailsStream ({String itemId})
  {
    return firestore.collection(items).doc(itemId).snapshots();
  }

  getItemsByName({String name}) {
    var itemsSnapShots = firestore
        .collection(items)
        .where(this.item, isEqualTo: this.item)
        .where('title', isEqualTo: name)
        .snapshots();
    return itemsSnapShots;
  }

  getSubItems({String parentId, String type}) {
    return firestore
        .collection(items)
        .where(this.type, isEqualTo: type)
        .where(this.parentId, isEqualTo: parentId)
        .snapshots();
  }

  getRecommendedItemsStream()
  {
    return firestore.collection(items)
        .where(this.type, isEqualTo: this.item)
        .where(this.markedRecommended, isEqualTo: 'true').snapshots();
  }

  getFavoriteItems({String userId}) {
    return firestore
        .collection(userCollection)
        .doc(userId)
        .collection(favorite)
        .snapshots();
  }

  getUserRatingSnapshot({String itemId}) {
    return firestore
        .collection(items)
        .doc(itemId)
        .collection(usersRating)
        .snapshots().map((i)=> RatingModel.getRatingList(i.docs));
  }

  static final FirebaseMethods sharedInstance = FirebaseMethods._internal();

  factory FirebaseMethods() {
    return sharedInstance;
  }

  FirebaseMethods._internal();

  Future<void> addToCart({Object object, String userId}) async{
    await firestore
        .collection(userCollection)
        .doc(userId)
        .collection(cart)
        .doc()
        .set(object);
  }

// Stream getFavoriteItem({String userId}) {
//    return firestore
//        .collection(userCollection)
//        .document(userId)
//        .collection(favorite)
//        .snapshots();
//  }

  updateItem({String itemId, Object object,String collection}) {
    firestore
        .collection(collection)
        .doc(itemId)
        .update(object);
  }

  deleteFavoriteItem({String userId,String id}) {
    return firestore
        .collection(userCollection)
        .doc(userId)
        .collection(favorite).doc(id)
        .delete();
  }

  void addToFavorite({Object object, String userId,String id}) {
    firestore
        .collection(userCollection)
        .doc(userId)
        .collection(favorite)
        .doc(id)
        .set(object);
  }

  void addToOrder({Object object}) {
    firestore.collection(orders).doc().set(object);
  }

  void addRatingToItem(String itemId, Object object)
  {
    firestore.collection(items).doc(itemId).collection(usersRating).doc().set(object);
  }

  void addRecommendationToItem(String itemId, int recommendedCount)
  {
    firestore.collection(items).doc(itemId).update({'recommendedCount': recommendedCount, "markedRecommended": "true"});
  }

  void deleteCart({String cartId, String userId}) {
    firestore
        .collection(userCollection)
        .doc(userId)
        .collection(cart)
        .doc(cartId)
        .delete();
  }

  void updateCartQuantity({String userId, String id, String quantity}) {
    firestore
        .collection(userCollection)
        .doc(userId)
        .collection(cart)
        .doc(id)
        .update({'quantity': quantity});
  }

 Stream getCartItems(String userId) {
    return firestore
        .collection(userCollection)
        .doc(userId)
        .collection(cart)
        .snapshots();
  }

  Future getOrderList() {
    return firestore
        .collection(orders)
        .get();
  }

  getProfileById(String userId) {
    return firestore.collection(userCollection).doc(userId).get();
  }

  void streamProfile() {
    profileStream = firestore
        .collection(userCollection)
        .doc(currentProfileId)
        .snapshots()
        .map((docSnap) => ProfileModel.fromDocumentSnapshot(docSnap));
  }

  Future<String> createUserAccount(
      {String fullname, String email, String password}) async {
    // TODO: implement createUserAccount
//    try {
    var authResult = await auth.createUserWithEmailAndPassword(
        email: email, password: password);
    currentFirebaseUser = authResult.user;

    if (currentFirebaseUser != null) {
      currentProfileId = currentFirebaseUser.uid;
      await writeDataLocally(key: profileId, value: currentProfileId);
      await writeBoolDataLocally(key: loggedIN, value: true);
      await addToFirebase(currentFirebaseUser, fullname);
      streamProfile();
//      profileStream = streamProfile(currentFirebaseUser.uid);

    }
    return currentFirebaseUser == null ? _errorMessageEvent : success;
  }

  addToFirebase(User user, String fullname) async {
    await firestore.collection(userCollection).doc(user.uid).set({
      profileId: user.uid,
      email: user.email,
      name: fullname,
      avatar: (user.photoURL != null && user.photoURL.isNotEmpty)
          ? user.photoURL
          : '',
      platform: isIos ? 'iOS' : 'Android',
    });
  }

  signInAnonymously(user) async {
    FirebaseFirestore.instance.collection('users').doc(user.user.uid).set(
        {'id': user.user.uid, 'email': '', 'name': 'Anonymous', 'avatar': '', 'platform': isIos ? 'iOS' : 'Android',
        });
    currentProfileId = user.user.uid;
    streamProfile();
    await writeDataLocally(key: profileId, value: user.user.uid);
    await writeBoolDataLocally(key: loggedIN, value: true);
  }

  Future<String> logginUser({String email, String password}) async {
    // TODO: implement logginUser

    try {
      await auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((authResult) {
        currentFirebaseUser = authResult.user;
      });

      if (currentFirebaseUser != null) {
        currentProfileId = currentFirebaseUser.uid;
        await writeDataLocally(key: profileId, value: currentProfileId);
        await writeBoolDataLocally(key: loggedIN, value: true);
        currentProfileId = currentFirebaseUser.uid;
        streamProfile();
      }
    } catch (e) {
      //print(e.details);

      if (e.toString().contains("ERROR_USER_NOT_FOUND")) {
        _errorMessageEvent = "this email is not found";
      }
      if (e.toString().contains("ERROR_WRONG_PASSWORD")) {
        _errorMessageEvent =
            "The password is invalid or the user does not have a password";
      }
//      signError.onGetException(_errorMessageEvent);
      return errorMSG(_errorMessageEvent);
    }

    return currentFirebaseUser == null ? errorMSG("Error") : success;
  }

  Future<bool> complete() async {
    return true;
  }

  Future<bool> notComplete() async {
    return false;
  }

  Future<String> errorMSG(String e) async {
    return e;
  }

  Future<bool> logOutUser() async {
    // TODO: implement logOutUser
    await auth.signOut();
    await clearDataLocally();

    return complete();
  }

  pickSaveImage(File imageFile, String profileId) async {
    StorageReference ref = FirebaseStorage.instance
        .ref()
        .child("profile")
        .child(profileId)
        .child("profileImage.jpg");
    StorageUploadTask uploadTask = ref.putFile(imageFile);
    return await (await uploadTask.onComplete).ref.getDownloadURL();
  }

  FirebaseAuth getAppAuth() {
    return auth;
  }

  FirebaseDatabase getAppDB() {
    return _database;
  }

  FirebaseFirestore getFirestore() {
    return firestore;
  }

  SignOut() async {
    await auth.signOut();
    await clearDataLocally();
    currentFirebaseUser = null;
  }

}
