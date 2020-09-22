import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:isouq/Firebase/firebase_methods.dart';
import 'package:isouq/Helpers/app_tools.dart';
import 'package:isouq/common/ui_events/ui_events.dart';

final firebaseSharedInstance = FirebaseMethods.sharedInstance;
final FirebaseAuth _auth = firebaseSharedInstance.getAppAuth();

class LoginViewModel extends ChangeNotifier{
  StreamController<UiEvents> eventsStreamController = StreamController<UiEvents>.broadcast();


  bool signInError = false;


  final facebookLogin = FacebookLogin();
  final GoogleSignIn googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
    hostedDomain: "",
    clientId: "",);

  User currentUser;

  loginWithFacebook() async {
    var fbLoginResult = await facebookLogin.logIn(['email', 'public_profile'])
        .catchError((onError) {
      signInError = true;
    });
    signInError = !(await facebookLogin.isLoggedIn);
    if(!signInError)
    {
      switch (fbLoginResult.status) {
        case FacebookLoginStatus.loggedIn:
          eventsStreamController.add(UiEvents.loading);
          notifyListeners();

          final token = fbLoginResult.accessToken.token;
          AuthCredential fbCredential = FacebookAuthProvider.credential(token);
          await _auth.signInWithCredential(fbCredential).then((authResult) {
            firebaseSharedInstance.currentFirebaseUser = authResult.user;
            return authResult.user;
          });
          await writeDataLocally(key: firebaseSharedInstance.profileId,
              value: firebaseSharedInstance.currentFirebaseUser.uid);
          await writeBoolDataLocally(
              key: firebaseSharedInstance.loggedIN, value: true);
          await firebaseSharedInstance.addToFirebase(
              firebaseSharedInstance.currentFirebaseUser,
              firebaseSharedInstance.currentFirebaseUser.displayName).then((f) {
            firebaseSharedInstance.currentProfileId = firebaseSharedInstance.currentFirebaseUser == null ? getStringDataLocally(key: firebaseSharedInstance.profileId) : firebaseSharedInstance.currentFirebaseUser.uid;
            firebaseSharedInstance.streamProfile();

            eventsStreamController.add(UiEvents.completed);
            notifyListeners();

            eventsStreamController.add(UiEvents.runAnimation);
            notifyListeners();

            eventsStreamController.add(UiEvents.navigateToNavBar);
            notifyListeners();

          });
          break;
        case FacebookLoginStatus.cancelledByUser:
//          eventsStream.add(UiEvents.completed);
//          notifyListeners();
          signInError = true;
          break;
        case FacebookLoginStatus.error:
          eventsStreamController.add(UiEvents.completed);
          notifyListeners();
          signInError = true;
          print(fbLoginResult.errorMessage);
          break;
      }
    }
  }


  loginWithGoogle() async {
    bool signInError = false;
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn()
        .catchError((onError) {
      signInError = true;
      print(onError.toString());
    });

    if(!signInError && googleSignIn.currentUser!= null){
      eventsStreamController.add(UiEvents.loading);
      notifyListeners();

      var signedIn = await googleSignIn.isSignedIn();
      switch (signedIn) {
        case true:
          final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount
              .authentication;
          AuthCredential googleCredential = GoogleAuthProvider.credential(
              accessToken: googleSignInAuthentication.accessToken,idToken: googleSignInAuthentication.idToken);
          await firebaseSharedInstance.getAppAuth().signInWithCredential(
              googleCredential).then((authResult) {
            firebaseSharedInstance.currentFirebaseUser = authResult.user;
            return authResult.user;
          });
          await writeDataLocally(key: firebaseSharedInstance.profileId,
              value: firebaseSharedInstance.currentFirebaseUser.uid);
          await writeBoolDataLocally(
              key: firebaseSharedInstance.loggedIN, value: true);
          await firebaseSharedInstance.addToFirebase(
              firebaseSharedInstance.currentFirebaseUser,
              firebaseSharedInstance.currentFirebaseUser.displayName).then((f) {
            firebaseSharedInstance.currentProfileId = firebaseSharedInstance.currentFirebaseUser == null ? getStringDataLocally(key: firebaseSharedInstance.profileId) : firebaseSharedInstance.currentFirebaseUser.uid;
            firebaseSharedInstance.streamProfile();

            eventsStreamController.add(UiEvents.completed);
            notifyListeners();

            eventsStreamController.add(UiEvents.runAnimation);
            notifyListeners();

            eventsStreamController.add(UiEvents.navigateToNavBar);
            notifyListeners();

          });
          break;
        case false:
          eventsStreamController.add(UiEvents.completed);
          notifyListeners();
          break;
      }
    }

  }

  loginAnynmously()
  {
    eventsStreamController.add(UiEvents.loading);
    notifyListeners();
    FirebaseAuth.instance
        .signInAnonymously()
        .then((user) {
      firebaseSharedInstance.signInAnonymously(
          user);
      eventsStreamController.add(UiEvents.completed);
      notifyListeners();

      eventsStreamController.add(UiEvents.runAnimation);
      notifyListeners();

      eventsStreamController.add(UiEvents.navigateToNavBar);
      notifyListeners();
        });
  }

//  @override
//  void dispose() {
////    eventsStreamController.close();
//    super.dispose();
//  }
}