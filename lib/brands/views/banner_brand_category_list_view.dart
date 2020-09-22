import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:isouq/Helpers/google_admob_management//google_admob.dart';
import 'package:isouq/home/views/home_view.dart';
import 'package:isouq/brands/viewmodels/brand_list_viewmodel.dart';
import 'package:isouq/common/text_styles/text_styles.dart';
import 'package:isouq/profile/models/item_model.dart';
import 'package:provider/provider.dart';

import 'brand_item_card_view.dart';
import 'silver_app_bar_view.dart';

class BannerOrBrandCategoryListScreen extends StatefulWidget {
  /// Get data from BrandDataList.dart (List Item)
  /// Declare class
  final ItemModel brand;

  BannerOrBrandCategoryListScreen(this.brand);

  @override
  _BannerOrBrandCategoryListScreenState createState() => _BannerOrBrandCategoryListScreenState();
}

class _BannerOrBrandCategoryListScreenState extends State<BannerOrBrandCategoryListScreen> {
  /// set key for bottom sheet
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  GoogleAdMob _googleAdMob = GoogleAdMob();

  BrandListViewModel _viewModel;

  @override
  void initState() {
    _viewModel = Provider.of<BrandListViewModel>(context,listen: false);
    super.initState();
    _googleAdMob.loadInterstitialAd();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _googleAdMob.disposeAds();
  }

  /// Create Modal BottomSheet (SortBy)
  void _modalBottomSheetSort() {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return SingleChildScrollView(
            child: new Container(
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(padding: EdgeInsets.only(top: 20.0)),
                  Text(tr('sortBy'), style: fontCostumSheetBotomHeader()),
                  Padding(padding: EdgeInsets.only(top: 20.0)),
                  Container(
                    width: 500.0,
                    color: Colors.black26,
                    height: 0.5,
                  ),
                  Padding(padding: EdgeInsets.only(top: 25.0)),
                  InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context) => new Home()));
                      },
                      child: Text(
                        tr('popularity'),
                        style: fontCostumSheetBotom(),
                      )),
                  Padding(padding: EdgeInsets.only(top: 25.0)),
                  Text(
                    tr('new'),
                    style: fontCostumSheetBotom(),
                  ),
                  Padding(padding: EdgeInsets.only(top: 25.0)),
                  Text(
                    tr('discount'),
                    style: fontCostumSheetBotom(),
                  ),
                  Padding(padding: EdgeInsets.only(top: 25.0)),
                  Text(
                    tr('priceLow'),
                    style: fontCostumSheetBotom(),
                  ),
                  Padding(padding: EdgeInsets.only(top: 25.0)),
                  Text(
                    tr('priceHight'),
                    style: fontCostumSheetBotom(),
                  ),
                  Padding(padding: EdgeInsets.only(top: 25.0)),
                ],
              ),
            ),
          );
        });
  }

  /// Create Modal BottomSheet (RefineBy)
  void _modalBottomSheetRefine() {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return SingleChildScrollView(
            child: new Container(
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(padding: EdgeInsets.only(top: 20.0)),
                  Text(tr('refineBy'), style: fontCostumSheetBotomHeader()),
                  Padding(padding: EdgeInsets.only(top: 20.0)),
                  Container(
                    width: 500.0,
                    color: Colors.black26,
                    height: 0.5,
                  ),
                  Padding(padding: EdgeInsets.only(top: 25.0)),
                  InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context) => new Home()));
                      },
                      child: Text(
                        tr('popularity'),
                        style: fontCostumSheetBotom(),
                      )),
                  Padding(padding: EdgeInsets.only(top: 25.0)),
                  Text(
                    tr('new'),
                    style: fontCostumSheetBotom(),
                  ),
                  Padding(padding: EdgeInsets.only(top: 25.0)),
                  Text(
                    tr('discount'),
                    style: fontCostumSheetBotom(),
                  ),
                  Padding(padding: EdgeInsets.only(top: 25.0)),
                  Text(
                    tr('priceHight'),
                    style: fontCostumSheetBotom(),
                  ),
                  Padding(padding: EdgeInsets.only(top: 25.0)),
                  Text(
                    tr('priceLow'),
                    style: fontCostumSheetBotom(),
                  ),
                  Padding(padding: EdgeInsets.only(top: 25.0)),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    double _height = MediaQuery.of(context).size.height;
    return Scaffold(
      key: _key,
      body: SafeArea(
        child: CustomScrollView(
          scrollDirection: Axis.vertical,
          slivers: <Widget>[
            SliverPersistentHeader(
              delegate: MySliverAppBar(
                  expandedHeight: _height - 40.0,
                  img: widget.brand.image.elementAt(0),
                  title: widget.brand.title,
                  id: widget.brand.id),
              pinned: true,
            ),

            /// Container for description to Sort and Refine
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  color: Colors.white,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                            top: 0.0, left: 0.0, right: 0.0, bottom: 0.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius:
                            BorderRadius.all(Radius.circular(4.0)),
                            color: Colors.white,
                          ),
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 30.0, left: 20.0, right: 20.0),
                                child: Text(
                                  widget.brand.desc,
                                  style: TextStyle(
                                      fontFamily: "Popins",
                                      fontWeight: FontWeight.w400,
                                      fontSize: 15.0,
                                      color: Colors.black54),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            /// Create Grid Item
            StreamBuilder(
                stream: _viewModel.getBrandCategoryList(widget.brand.id),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                        return BrandItemCard(ItemModel.fromDocumentSnapshot(snapshot.data.documents[index]));
                      },
                      childCount:snapshot.hasData? snapshot.data.documents.length:0,
                    ),

                    /// Setting Size for Grid Item
                  );


                }),
          ],
        ),
      ),
    );
  }
}