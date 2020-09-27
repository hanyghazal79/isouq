import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:isouq/Firebase/firebase_methods.dart';
import 'package:isouq/Helpers/app_tools.dart';
import 'package:isouq/common/ui_events/ui_events.dart';
import 'package:shared_preferences/shared_preferences.dart';

final firebaseSharedInstance = FirebaseMethods.sharedInstance;
final FirebaseAuth _auth = firebaseSharedInstance.getAppAuth();

class LoginViewModel extends ChangeNotifier {
  StreamController<UiEvents> eventsStreamController =
      StreamController<UiEvents>.broadcast();

  String message = "";
  bool signInError = false;

  final facebookLogin = FacebookLogin();
  final GoogleSignIn googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
    hostedDomain: "",
    clientId: "",
  );

  User currentUser;

  loginWithFacebook() async {
    var fbLoginResult = await facebookLogin
        .logIn(['email', 'public_profile']).catchError((onError) {
      signInError = true;
    });
    signInError = !(await facebookLogin.isLoggedIn);
    if (!signInError) {
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
          await writeDataLocally(
              key: firebaseSharedInstance.profileId,
              value: firebaseSharedInstance.currentFirebaseUser.uid);
          await writeBoolDataLocally(
              key: firebaseSharedInstance.loggedIN, value: true);
          await firebaseSharedInstance
              .addToFirebase(firebaseSharedInstance.currentFirebaseUser,
                  firebaseSharedInstance.currentFirebaseUser.displayName)
              .then((f) {
            firebaseSharedInstance.currentProfileId = firebaseSharedInstance
                        .currentFirebaseUser ==
                    null
                ? getStringDataLocally(key: firebaseSharedInstance.profileId)
                : firebaseSharedInstance.currentFirebaseUser.uid;
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
    final GoogleSignInAccount googleSignInAccount =
        await googleSignIn.signIn().catchError((onError) {
      signInError = true;
      print(onError.toString());
    });

    if (!signInError && googleSignIn.currentUser != null) {
      eventsStreamController.add(UiEvents.loading);
      notifyListeners();

      var signedIn = await googleSignIn.isSignedIn();
      switch (signedIn) {
        case true:
          final GoogleSignInAuthentication googleSignInAuthentication =
              await googleSignInAccount.authentication;
          AuthCredential googleCredential = GoogleAuthProvider.credential(
              accessToken: googleSignInAuthentication.accessToken,
              idToken: googleSignInAuthentication.idToken);
          await firebaseSharedInstance
              .getAppAuth()
              .signInWithCredential(googleCredential)
              .then((authResult) {
            firebaseSharedInstance.currentFirebaseUser = authResult.user;
            return authResult.user;
          });
          await writeDataLocally(
              key: firebaseSharedInstance.profileId,
              value: firebaseSharedInstance.currentFirebaseUser.uid);
          await writeBoolDataLocally(
              key: firebaseSharedInstance.loggedIN, value: true);
          await firebaseSharedInstance
              .addToFirebase(firebaseSharedInstance.currentFirebaseUser,
                  firebaseSharedInstance.currentFirebaseUser.displayName)
              .then((f) {
            firebaseSharedInstance.currentProfileId = firebaseSharedInstance
                        .currentFirebaseUser ==
                    null
                ? getStringDataLocally(key: firebaseSharedInstance.profileId)
                : firebaseSharedInstance.currentFirebaseUser.uid;
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

  loginAnonymously() {
    eventsStreamController.add(UiEvents.loading);
    notifyListeners();
    FirebaseAuth.instance.signInAnonymously().then((user) {
      firebaseSharedInstance.signInAnonymously(user);
      eventsStreamController.add(UiEvents.completed);
      notifyListeners();

      eventsStreamController.add(UiEvents.runAnimation);
      notifyListeners();

      eventsStreamController.add(UiEvents.navigateToNavBar);
      notifyListeners();
    });
  }

  _saveProfile({String email, String password}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', email);
    await prefs.setString('password', password);
  }

  _login(String email, String password) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      try {
        eventsStreamController.add(UiEvents.loading);
        notifyListeners();

        String response = await firebaseSharedInstance.loginUser(
            email: email, password: password);

        eventsStreamController.add(UiEvents.completed);
        notifyListeners();
        if (response == firebaseSharedInstance.success) {
          _saveProfile(email: email, password: password);
          eventsStreamController.add(UiEvents.runAnimation);
        } else {
          message = response;
          eventsStreamController.add(UiEvents.showMessage);
        }
      } catch (error) {
        eventsStreamController.add(UiEvents.completed);
        notifyListeners();
        if (error.toString().contains("ERROR_USER_NOT_FOUND")) {
          message = "this email is not found";
        }
        if (error.toString().contains("ERROR_WRONG_PASSWORD")) {
          message =
              "The password is invalid or the user does not have a password";
        }
      }
    } else {
      message = message = tr('no_internet');
      eventsStreamController.add(UiEvents.showMessage);
    }
    notifyListeners();
  }

  loginWithEmailAndPassword(String email, String password) async {
    eventsStreamController.add(UiEvents.requestFocus);
    notifyListeners();
    await _login(email, password);
    eventsStreamController.add(UiEvents.completed);
    notifyListeners();
  }

  @override
  void dispose() {
//    eventsStreamController.close();
    super.dispose();
  }
}
