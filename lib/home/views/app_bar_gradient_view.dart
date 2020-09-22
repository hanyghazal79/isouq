import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:isouq/Firebase/firebase_methods.dart';
import 'package:isouq/Helpers/notification_manager.dart';
import 'package:isouq/home/models/NotificationModel.dart';
import 'package:isouq/home/Search.dart';
import 'package:isouq/home/viewmodels/app_bar_gradient_viewmodel.dart';
import 'package:isouq/notification/views/notification_view.dart';
import 'package:provider/provider.dart';
bool isEmpty;

class AppbarGradient extends StatefulWidget {
  @override
  _AppbarGradientState createState() => _AppbarGradientState();
}

class _AppbarGradientState extends State<AppbarGradient> {

  AppBarGradientViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = Provider.of<AppBarGradientViewModel>(context,listen: false);

    _viewModel.listenAndStreamNotification();
  }

  /// Build Appbar in layout home
  @override
  Widget build(BuildContext context) {
    _viewModel.configureNotification(context);


    /// Create responsive height and padding
    final MediaQueryData media = MediaQuery.of(context);
    final double statusBarHeight = MediaQuery.of(context).padding.top;


    /// Create component in appbar
    return Container(
      padding: EdgeInsets.only(top: statusBarHeight),
      height: 58.0 + statusBarHeight,
      decoration: BoxDecoration(

        /// gradient in appbar
          gradient: LinearGradient(
              colors: [
                Colors.yellow,
                Colors.yellowAccent,
              ],
              begin: const FractionalOffset(0.0, 0.0),
              end: const FractionalOffset(1.0, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          /// if user click shape white in appbar navigate to search layout
          InkWell(
            onTap: () {
              Navigator.of(context).push(PageRouteBuilder(
                  pageBuilder: (_, __, ___) => SearchAppbar(),

                  /// transtation duration in animation
                  transitionDuration: Duration(milliseconds: 750),

                  /// animation route to search layout
                  transitionsBuilder:
                      (_, Animation<double> animation, __, Widget child) {
                    return Opacity(
                      opacity: animation.value,
                      child: child,
                    );
                  }));
            },

            /// Create shape background white in appbar (background treva shop text)
            child:
            Container(
              margin: EdgeInsets.only(left: media.padding.left + 15),
              height: 37.0,
              width: 300.0,
              decoration: BoxDecoration(
                  color: Colors.black54.withOpacity(0.15),
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  shape: BoxShape.rectangle),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(padding: EdgeInsets.only(left: 17.0)),
                  Image.asset(
                    "assets/img/search2.png",
                    height: 22.0,
                  ),
                  Padding(
                      padding: EdgeInsets.only(
                        left: 17.0,
                      )),
                  Padding(
                    padding: EdgeInsets.only(top: 3.0),
                    child: Text(
                      tr('title'),
                      style: TextStyle(
                          fontFamily: "Popins",
                          color: Colors.black12,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.0,
                          fontSize: 16.4),
                    ),
                  ),
                ],
              ),
            ),
          ),

          /// Icon chat (if user click navigate to chat layout)
//            InkWell(
//                onTap: () {
//                  Navigator.of(context).push(PageRouteBuilder(
//                      pageBuilder: (_, __, ___) => new chat()));
//                },
//                child: Image.asset(
//                  "assets/img/chat.png",
//                  height: media.devicePixelRatio + 20.0,
//                )),

          /// Icon notification (if user click navigate to notification layout)

          InkWell(
            onTap: () {
              Navigator.of(context).push(PageRouteBuilder(
                  pageBuilder: (_, __, ___) => new notification(isEmpty)));
            },
            child: Row(
              children: <Widget>[
                Stack(
                  alignment: AlignmentDirectional(-3.0, -3.0),
                  children: <Widget>[
                    ColorFiltered(
                      colorFilter: ColorFilter.mode(Colors.grey, BlendMode.srcATop),
                      child: Image.asset(
                        "assets/img/notifications-button.png",
                        height: 24.0,
                      ),
                    ),
                    Container(
                      child: StreamBuilder<List<NotificationModel>>(
                        stream: firebaseSharedInstance.streamNotification(),
                        builder: (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.hasData&&snapshot.data != 0) {
                            isEmpty=false;
                            return CircleAvatar(
                              radius: 8.6,
                              backgroundColor: Colors.redAccent,
                              child: Text(
                                snapshot.data.length.toString(),
                                style: TextStyle(
                                    fontSize: 13.0, color: Colors.white),
                              ),
                            );
                          } else {
                            isEmpty=true;
                            return SizedBox();
                          }
                        },
                      ),
                    )
                  ],
                ),
                SizedBox(width: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }


}