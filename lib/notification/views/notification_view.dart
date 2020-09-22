import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:isouq/Helpers/app_tools.dart';
import 'package:isouq/common/widgets/gradient_app_bar.dart';
import 'package:isouq/home/models/NotificationModel.dart';
import 'package:isouq/notification/viewmodels/notification_viewmodel.dart';
import 'package:isouq/notification/views/no_notification_view.dart';
import 'package:provider/provider.dart';

class notification extends StatefulWidget {
  bool isEmpty;

  notification(this.isEmpty);

  @override
  _notificationState createState() => _notificationState();
}

class _notificationState extends State<notification> {

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  NotificationViewModel _viewModel;

  List<NotificationModel> notifications;

  @override
  void initState() {
    _viewModel = Provider.of<NotificationViewModel>(context,listen: false);
    super.initState();
  }

  void _onTapItem(BuildContext context, NotificationModel post) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(post.desc)));
  }

  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: gradientAppBar(tr('notification')),



      body: widget.isEmpty
          ? noItemNotifications()
          : StreamBuilder<List<NotificationModel>>(
        stream: _viewModel.getNotificationStream(),
        builder: (BuildContext context,
            AsyncSnapshot<List<NotificationModel>> nots) {
          if (!nots.hasData) {
            return Center(child: CircularProgressIndicator());
          } else {
            notifications = nots.requireData;
            return notifications.length > 0
                ? ListView.builder(
                itemCount: notifications.length,
                padding: const EdgeInsets.all(5.0),
                itemBuilder: (context, position) {
                  return FutureBuilder(
                    future: getBoolDataLocally(
                        key: notifications[position].id),
                    builder: (context, snapshot) {
                      if (snapshot.hasData &&
                          snapshot.data == false) {
                        return Dismissible(
                            key: Key(notifications[position]
                                .id
                                .toString()),
                            onDismissed: (direction) {
                              setState(() {
                                writeBoolDataLocally(
                                    key: notifications[position]
                                        .id
                                        .toString(),
                                    value: true);
                                notifications.removeAt(position);
                              });
                            },
                            background: Container(
                              color: Color(0xFF6991C7),
                            ),
                            child: Container(
                              height: 88.0,
                              child: Column(
                                children: <Widget>[
                                  Divider(height: 5.0),
                                  ListTile(
                                    title: Text(
                                      '${notifications[position].title}',
                                      style: TextStyle(
                                          fontSize: 17.5,
                                          color: Colors.black87,
                                          fontWeight:
                                          FontWeight.w600),
                                    ),
                                    subtitle: Padding(
                                      padding:
                                      const EdgeInsets.only(
                                          top: 6.0),
                                      child: Container(
                                        width: 440.0,
                                        child: Text(
                                          '${notifications[position].desc}',
                                          style: new TextStyle(
                                              fontSize: 15.0,
                                              fontStyle:
                                              FontStyle.italic,
                                              color:
                                              Colors.black38),
                                          overflow:
                                          TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                    leading: Column(
                                      children: <Widget>[
                                        Container(
                                          height: 40.0,
                                          width: 40.0,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius.all(
                                                Radius.circular(
                                                    60.0)),
                                            image: DecorationImage(
                                                fit: BoxFit.cover,
                                                image: (notifications[position]
                                                    .image ==
                                                    null ||
                                                    notifications[
                                                    position]
                                                        .image
                                                        .isEmpty)
                                                    ? AssetImage(
                                                    'assets/img/logo.png')
                                                    : NetworkImage(
                                                    notifications[
                                                    position]
                                                        .image)),
                                          ),
                                        )
                                      ],
                                    ),
                                    onTap: () => _onTapItem(context,
                                        notifications[position]),
                                  ),
                                  Divider(height: 5.0),
                                ],
                              ),
                            ));
                      } else {
                        if (snapshot.hasData &&
                            snapshot.data == true) {
                          return SizedBox();
                        }
                        return Center(
                            child: CircularProgressIndicator());
                      }
                    },
                  );
                })
                : noItemNotifications();
          }
        },
      ),
    );
  }
}