import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:isouq/common/text_styles/text_styles.dart';
import 'package:isouq/home/horizontal_item_list.dart';
import 'package:isouq/home/viewmodels/home_viewmodel.dart';
import 'package:isouq/home/views/grid_item_with_discount.dart';
import 'package:isouq/home/views/item_grid_view.dart';
import 'package:isouq/profile/models/item_model.dart';
import 'package:provider/provider.dart';

class HomeRecommendedListView extends StatefulWidget {
  @override
  _HomeRecommendedViewState createState() => _HomeRecommendedViewState();
}

class _HomeRecommendedViewState extends State<HomeRecommendedListView> {
  HomeViewModel _viewModel;

  @override
  void initState() {
    _viewModel = Provider.of<HomeViewModel>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _viewModel.streamRecommended(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (snapshot.data.documents.length == 0)
              return SizedBox();
            else {
              List<ItemModel> recommendedList = List();

              for(DocumentSnapshot documentSnapshot in snapshot.data.documents)
                recommendedList.add(ItemModel.fromDocumentSnapshot(documentSnapshot));

              // to sort the list by recommendation count
              Comparator<ItemModel> recommendCountComparator = (a, b) => b.recommendedCount.compareTo(a.recommendedCount);
              recommendedList.sort(recommendCountComparator);
              
              
              
              return SingleChildScrollView(
                child: Container(
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 20.0, top: 20.0, right: 20.0),
                            child: Text(
                              tr('recomended'),
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 17.0,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 20.0,
                                top: 20.0,
                                right: 20.0),
                            child: Row(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              mainAxisAlignment:
                              MainAxisAlignment.start,
                              children: <Widget>[
                                InkWell(
                                  child: Padding(
                                      padding: EdgeInsets.only(
                                          top: 2.0, right: 3.0),
                                      child: Text(
                                        tr('viewAll'),
                                        style: subHeaderCustomStyle()
                                            .copyWith(
                                            color: Colors
                                                .indigoAccent,
                                            fontSize: 14.0),
                                      )),
                                  onTap: () {
                                    // go to all recommendation
                                    Navigator.of(context).push(
                                        PageRouteBuilder(
                                            pageBuilder: (_, __,
                                                ___) =>
                                                HorizontalItemList(
                                                  title: tr('recomended'), isRecommendedList: true,)));
                                  },
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      right: 15.0, top: 2.0),
                                  child: Icon(
                                    Icons.arrow_forward_ios,
                                    size: 18.0,
                                    color: Colors.black54,
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),

                      /// To set GridView item
                      GridView.builder(
                        shrinkWrap: true,
                        itemCount: recommendedList.length > 4 ? 4 : recommendedList.length , // only 4 recommended items in home
//                        snapshot.data.documents.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisSpacing: 10.0,
                            mainAxisSpacing: 17.0,
                            childAspectRatio: 0.5,
                            crossAxisCount: 2),
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 20.0),
                        primary: false,
                        itemBuilder: (BuildContext context, int index) {
                          var item = recommendedList.elementAt(index);
                          return item.newPrice.isEmpty
                              ? ItemGrid(item)
                              : ItemGridWithDiscount(item);
                        },
                      ),
                    ],
                  ),
                ),
              );
            }
          }
        });
//
  }
}
