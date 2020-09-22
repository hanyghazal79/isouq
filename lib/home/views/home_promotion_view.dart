import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:isouq/home/horizontal_item_list.dart';
import 'package:isouq/home/viewmodels/home_viewmodel.dart';
import 'package:isouq/profile/models/item_model.dart';
import 'package:provider/provider.dart';

class HomePromotionView extends StatefulWidget {
  @override
  _homePromotionViewState createState() => _homePromotionViewState();
}

class _homePromotionViewState extends State<HomePromotionView> {
  HomeViewModel _viewModel;

  @override
  void initState() {
    _viewModel = Provider.of<HomeViewModel>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _viewModel.streamPromotions(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (snapshot.data.documents.length == 0)
              return SizedBox();
            else {
              return Container(
                color: Colors.white,
                width: MediaQuery.of(context).size.width,
                height: 230.0,
                padding: EdgeInsets.only(bottom: 40.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.only(
                            left: 20.0, top: 15.0, bottom: 3.0, right: 20.0),
                        child: Text(
                          tr('deals'),
                          style: TextStyle(
                              fontSize: 15.0,
                              fontFamily: "Sans",
                              fontWeight: FontWeight.w700),
                        )),
                    Expanded(
                      child: ListView.builder(
                          itemCount: snapshot.data.documents.length,
                          shrinkWrap: true,
                          padding: EdgeInsets.only(top: 10.0),
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (BuildContext context, index) {
                            var item = ItemModel.fromDocumentSnapshot(
                                snapshot.data.documents[index]);
                            return Row(
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(left: 10.0),
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.of(context).push(
                                        PageRouteBuilder(
                                            pageBuilder: (_, __, ___) => HorizontalItemList(
                                                id: item.id,title: item.title, isRecommendedList: false,),
                                            transitionDuration:
                                            Duration(
                                                milliseconds: 750),
                                            transitionsBuilder: (_,
                                                Animation<double>
                                                animation,
                                                __,
                                                Widget child) {
                                              return Opacity(
                                                opacity:
                                                animation.value,
                                                child: child,
                                              );
                                            }));
                                  },
                                  child: Image.network(
                                      item.image.elementAt(0)),
                                )
                              ],
                            );
                          }),
                    ),
                  ],
                ),
              );
            }
          }
        });
  }
}
