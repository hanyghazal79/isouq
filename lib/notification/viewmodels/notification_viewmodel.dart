import 'package:flutter/material.dart';
import 'package:isouq/Firebase/firebase_methods.dart';
import 'package:isouq/home/models/NotificationModel.dart';

class NotificationViewModel extends ChangeNotifier{

  final firebaseSharedInstance = FirebaseMethods.sharedInstance;


  Stream<List<NotificationModel>> getNotificationStream()
  {
    return firebaseSharedInstance.streamNotification();
  }
}