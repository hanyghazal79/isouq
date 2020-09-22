import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:isouq/brands/viewmodels/brand_list_viewmodel.dart';
import 'package:isouq/common/widgets/gradient_app_bar.dart';
import 'package:isouq/profile/models/item_model.dart';
import 'package:provider/provider.dart';

import 'brand_card_view.dart';



class BrandList extends StatefulWidget {
  @override
  _BrandListState createState() => _BrandListState();
}

class _BrandListState extends State<BrandList> {

  bool loadImage = true;
  String _textSearch = '';

  BrandListViewModel _viewModel;

  bool _showAppbar = true; //this is to show app bar
  ScrollController _scrollBottomBarController = new ScrollController(); // set controller on scrolling
  bool isScrollingDown = false;
  bool _show = true;
  double bottomBarHeight ; // set bottom bar height

  @override
  void initState() {
    _viewModel = Provider.of<BrandListViewModel>(context,listen: false);
    super.initState();
    appBarScroll();

  }


  @override
  void dispose() {
    _scrollBottomBarController.removeListener(() {});
    super.dispose();
  }

  void showBottomBar() {
    setState(() {
      _show = true;
    });
  }

  void hideBottomBar() {
    setState(() {
      _show = false;
    });
  }

  void appBarScroll() async {
    _scrollBottomBarController.addListener(() {
      if (_scrollBottomBarController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (!isScrollingDown) {
          isScrollingDown = true;
          _showAppbar = false;
          hideBottomBar();
        }
      }
      if (_scrollBottomBarController.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (isScrollingDown) {
          isScrollingDown = false;
          _showAppbar = true;
          showBottomBar();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    /// Component appbar
    var _appbar = _showAppbar
        ? AppBar(flexibleSpace:gradientAppBar(tr('categoryBrand')),)
        : PreferredSize(
      child: Container(),
      preferredSize: Size(0.0, 0.0),
    );

    return Scaffold(
        /// Calling variable appbar
        appBar: _appbar,
        body: Container(
          child: Column(
            children: <Widget>[
              Container(
                height: 50.0,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 15.0,
                          spreadRadius: 0.0)
                    ]),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 10.0),
                    child: Theme(
                      data: ThemeData(hintColor: Colors.transparent),
                      child: TextFormField(
                        onChanged: (val) {
                          setState(() {
                            _textSearch = val;
                          });
                        },
                        autofocus: false,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            icon: Icon(
                              Icons.search,
                              color: Color(0xFF6991C7),
                              size: 28.0,
                            ),
                            hintText: tr('findYouWant'),
                            hintStyle: TextStyle(
                                color: Colors.black54,
                                fontFamily: "Gotik",
                                fontWeight: FontWeight.w400)),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Expanded(
                  child: StreamBuilder(
                      stream: _viewModel.getBrandList(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.hasError) {
                          print(snapshot.error.toString());
                        }
                        if (!snapshot.hasData) {
                          return Center(child: CircularProgressIndicator());
                        } else {
                          return ListView.builder(
                            controller: _scrollBottomBarController,
                              itemCount: snapshot.data.documents.length,
                              itemBuilder: (c, index) {
                                var item =
                                ItemModel.fromDocumentSnapshot(
                                    snapshot.data.documents[index]);
                                if (_textSearch.isNotEmpty ||
                                    _textSearch != '') {
                                  bool isContains = snapshot.data[index].title
                                      .toLowerCase()
                                      .contains(_textSearch);
                                  if (isContains) {
                                    return ItemCard(
                                        snapshot.requireData[index]);
                                  } else {
                                    return SizedBox();
                                  }
                                } else {
                                  return ItemCard(item);
                                }
                              });
                        }
                      })),
            ],
          ),
        ),
    );
  }
}