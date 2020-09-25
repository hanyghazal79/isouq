import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:isouq/Firebase/firebase_methods.dart';
import 'package:isouq/common/ui_events/ui_events.dart';
import 'package:shared_preferences/shared_preferences.dart';




class SignUpViewModel extends ChangeNotifier{
  FirebaseMethods firebaseMethods = FirebaseMethods.sharedInstance;
  StreamController<UiEvents> eventsStream = StreamController<UiEvents>.broadcast();

  String message = "";

  RegExp regExp = RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  bool validatePassword(String value) {
    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regExp = new RegExp(pattern);
    return regExp.hasMatch(value);
  }

  _saveProfile({String email, String password}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', email);
    await prefs.setString('password', password);
  }


  _signUp(String _name, String _email, String _password) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      try {
        eventsStream.add(UiEvents.loading);
        notifyListeners();

        String response = await firebaseMethods.createUserAccount(fullName: _name,email: _email,password: _password);

        eventsStream.add(UiEvents.completed);
        notifyListeners();

        if (response == firebaseMethods.success) {
          _saveProfile(
              email: _email, password: _password);
          eventsStream.add(UiEvents.runAnimation);
        } else {
          message = response;
          eventsStream.add(UiEvents.showMessage);

        }
      } catch (error) {
        eventsStream.add(UiEvents.completed);
        notifyListeners();

        if (error.toString().contains("ERROR_EMAIL_ALREADY_IN_USE")) {
          message =
          "The email address is already in use by another account";
        }
        eventsStream.add(UiEvents.showMessage);
        notifyListeners();
      }
    } else {
      message = tr('no_internet');
      eventsStream.add(UiEvents.showMessage);
    }
    notifyListeners();
  }

  _isValidSignUp(
      String email, String password, String name, String rePassword) {
    if (email == null || email.trim().isEmpty || !regExp.hasMatch(email)) {
      message = "you must write your right Email ";
      return false;
    }

    if (name == null || name.trim().isEmpty) {
      message = "you must write your right name ";
      return false;
    }

    if (password == null || password.trim().isEmpty || password.length < 7) {
      message =
      "you must write your right password  more than 8 character ";
      return false;
    }

    if (password == password.toLowerCase() ||
        password == password.toUpperCase() ||
        !regExp.hasMatch(email)) {
      message = "Password must include small and capital letter";
      return false;
    }

    if (rePassword == null ||
        rePassword.trim().isEmpty ||
        password != rePassword) {
      message = "password must equal RePassword";
      return false;
    }

    return true;
  }

  registerSignUp(String _name, String _email, String _password,String _rePassword) async {
    eventsStream.add(UiEvents.requestFocus);
    notifyListeners();

    if (_isValidSignUp(_email, _password, _name, _rePassword)) {

      await _signUp(_name,_email,_password);

    } else {
      eventsStream.add(UiEvents.showMessage);
    }
    notifyListeners();
  }

  @override
  // ignore: must_call_super
  void dispose() {
    eventsStream.close();
    super.dispose();
  }
}