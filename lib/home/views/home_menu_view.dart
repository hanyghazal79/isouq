import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:isouq/home/viewmodels/home_viewmodel.dart';
import 'package:isouq/home/views/category_item_view.dart';
import 'package:isouq/profile/models/item_model.dart';
import 'package:provider/provider.dart';

class HomeMenuView extends StatefulWidget {
  @override
  _homeMenuViewState createState() => _homeMenuViewState();
}

class _homeMenuViewState extends State<HomeMenuView> {
  HomeViewModel _viewModel;

  @override
  void initState() {
    _viewModel = Provider.of<HomeViewModel>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _viewModel.streamMenu(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            print(snapshot.error.toString());
          }
          if (!snapshot.hasData || snapshot.data.documents.length == 0) {
            return SizedBox();
          } else {
            return Container(
      color: Colors.white,
      padding: EdgeInsets.only(top: 20.0),
      alignment: AlignmentDirectional.centerStart,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(
                left: 20.0, top: 0.0, right: 20.0),
            child: Text(
              tr('menu'),
              style: TextStyle(
                  fontSize: 13.5,
                  fontFamily: "Sans",
                  fontWeight: FontWeight.w700),
            ),
          ),
          Padding(padding: EdgeInsets.only(top: 23.0)),
          GridView.builder(
              physics: ScrollPhysics(),
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(
                  horizontal: 7.0, vertical: 10.0),
              gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisSpacing: 15,
                mainAxisSpacing: 1,
                childAspectRatio: 1,
                crossAxisCount: 4,
              ),
              itemCount: snapshot.data.documents.length,
              itemBuilder: (c, i) {
                var item = ItemModel.fromDocumentSnapshot(
                    snapshot.data.documents[i]);
                return CategoryIconValue(
                  context: context,item: item,
                );
              })
        ],
      ),
    );
          }
        });
  }
}
