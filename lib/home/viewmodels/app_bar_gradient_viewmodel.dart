import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:isouq/Firebase/firebase_methods.dart';
import 'package:isouq/Helpers/notification_manager.dart';
import 'package:isouq/home/models/NotificationModel.dart';

class AppBarGradientViewModel extends ChangeNotifier {

  final firebaseSharedInstance = FirebaseMethods.sharedInstance;


  int notificationCount = 0;
  NotificationManager _notificationManager ;


  listenAndStreamNotification()
  {
    firebaseSharedInstance.getFirestore().collection(firebaseSharedInstance.notificationCollection).snapshots().listen((result) {
      result.documentChanges.forEach((res) {
        if (res.type == DocumentChangeType.added) {
          _onNotificationAdded(res.document);
        }
      });
    });

    firebaseSharedInstance.streamNotification();
  }

  _onNotificationAdded(DocumentSnapshot documentSnapshot) {
    NotificationModel _recieved =  NotificationModel.fromDocumentSnapshot(documentSnapshot);
    _notificationManager.showNotification(_recieved);
  }

  void configureNotification(BuildContext context) {
    _notificationManager = NotificationManager();
    _notificationManager.configure(context);
  }


}