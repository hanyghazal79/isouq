
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:isouq/Firebase/firebase_methods.dart';
import 'package:isouq/profile/models/item_model.dart';
import 'package:isouq/home/views/MenuDetail.dart';

import 'custom_text.dart';
import 'drawer_list_title.dart';

final firebaseSharedInstance = FirebaseMethods.sharedInstance;


class DrawerNavigation extends StatefulWidget {
  @override
  _DrawerNavigationBarState createState() => _DrawerNavigationBarState();
}

class _DrawerNavigationBarState extends State<DrawerNavigation> {

  final _drawerHeader = DrawerHeader(
    decoration: BoxDecoration(
      color: Colors.blue,
    ),
    child: CustomText(tr('title'),14),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Page"),
      ),
      drawer: Drawer(
        child: StreamBuilder<Object>(
            stream: firebaseSharedInstance.getItems(
                type: firebaseSharedInstance.menus),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
            return ListView.builder(
              itemCount: snapshot.data.documents.length,
              itemBuilder: (c, i) {
                var item = ItemModel.fromDocumentSnapshot(
                    snapshot.data.documents[i]);
                return DrawerListTile(
                  title: item.title,
                  image: Image.network(item.image.elementAt(0)),
                  child: menuDetail(item),
                );
              },
            );
          }
        ),
      ),
//      body: AllItemsScreen(),
    );
  }
}
