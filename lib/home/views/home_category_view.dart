import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:isouq/home/viewmodels/home_viewmodel.dart';
import 'package:isouq/home/views/category_item_view.dart';
import 'package:isouq/profile/models/item_model.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class HomeCategoryView extends StatefulWidget {
  @override
  _homeCategoryViewState createState() => _homeCategoryViewState();
}

class _homeCategoryViewState extends State<HomeCategoryView> {
  HomeViewModel _viewModel;

  @override
  void initState() {
    _viewModel = Provider.of<HomeViewModel>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _viewModel.streamCategories(),
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
                height: 310.0,
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 20.0, top: 20.0, right: 20.0),
                      child: Text(
                        tr('category'),
                        style: TextStyle(
                            fontSize: 17.0,
                            fontWeight: FontWeight.w700,
                            fontFamily: "Sans"),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 20.0),
                        child: GridView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: snapshot.data.documents.length,
                          itemBuilder: (BuildContext context, index) {
                            var item = ItemModel.fromDocumentSnapshot(
                                snapshot.data.documents[index]);
                            return Padding(
                              padding: const EdgeInsets.only(
                                left: 20.0,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(padding: EdgeInsets.only(top: 15.0)),
                                  CategoryItemValue(
                                    category: item,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 10.0),
                                  ),
                                ],
                              ),
                            );
                          },
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: .8,
                                  mainAxisSpacing: 1),
                        ),
                      ),
                    )
                  ],
                ),
              );
            }
          }
        });
  }
}
