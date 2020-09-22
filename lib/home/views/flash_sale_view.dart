import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:isouq/Helpers/Library/countdown_timer/countDownTimer.dart';
import 'package:isouq/common/widgets/gradient_app_bar.dart';
import 'package:isouq/common/widgets/no_item_view.dart';
import 'package:isouq/home/viewmodels/home_viewmodel.dart';
import 'package:isouq/home/views/grid_item_with_discount.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:isouq/Firebase/firebase_methods.dart';
import 'package:isouq/profile/models/item_model.dart';


class flashSale extends StatefulWidget {
  ItemModel offer;

  flashSale(this.offer);

  @override
  _flashSaleState createState() => _flashSaleState();
}

class _flashSaleState extends State<flashSale> {

  HomeViewModel _viewModel;

  bool loadImage = true;

  @override
//  OfferModel itemSale;
  ///
  /// SetState after imageNetwork loaded to change list card
  /// And
  /// Set for StartStopPress CountDown

  /// To set duration initState auto start if FlashSale Layout open
  @override
  void initState() {
    _viewModel = Provider.of<HomeViewModel>(context, listen: false);

    Timer(Duration(seconds: 3), () {
      setState(() {
        loadImage = false;
      });
    });

    // TODO: implement initState
    super.initState();
  }

  /// Component widget in flashSale layout
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Scaffold(
      appBar: gradientAppBar(widget.offer != null ? widget.offer.title : tr('flashSale')),
      body: SingleChildScrollView(
        child: StreamBuilder(
            stream: _viewModel.getOffersSubItemsStream(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                if (snapshot.data.documents.length == 0)
                  {
                    return NoItemCart();
                  }
                  else
                    {
                      return Container(
                        child: Column(
                          children: <Widget>[
                            /// Header banner
                            Image.network(
                              "https://gfx4arab.com/wp-content/uploads/wpdm-cache/special-offer-background_1126-221-900x0.jpg",
                              height: 195.0,
                              width: 1000.0,
                              fit: BoxFit.cover,
                            ),
                            ///
                            ///
                            /// check the condition if image data from server firebase loaded or no
                            /// if image true (image still downloading from server)
                            /// Card to set card loading animation
                            ///
                            ///
                            /// Create a GridView
                            loadImage
                                ? _loadingImageAnimation(context,snapshot.data.documents.length)
                                : GridView.builder(
                              itemCount: snapshot.data.documents.length,
                              shrinkWrap: true,
                              primary: false,
                              itemBuilder: (BuildContext context, int index) {
                                var item =
                                ItemModel.fromDocumentSnapshot(
                                    snapshot.data.documents[index]);
                                return ItemGridWithDiscount(item);
                              },
                              gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,childAspectRatio: .5
                              ),
                            )
                          ],
                        ),
                      );
                    }
              }
            }),
      ),
    );
  }
}

/// Component Card item for loading image
class LoadingItemGrid extends StatelessWidget {

  final color = Colors.black38;

  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(color: Colors.white, boxShadow: [
                BoxShadow(
                    color: Colors.black12.withOpacity(0.1),
                    spreadRadius: 0.2,
                    blurRadius: 0.5)
              ]),
              child: Shimmer.fromColors(
                baseColor: color,
                highlightColor: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      height: 140.0,
                      width: mediaQueryData.size.width / 2.1,
                      color: Colors.black12,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10.0, top: 10.0),
                      child: Container(
                        height: 15.0,
                        width: mediaQueryData.size.width / 2.6,
                        color: Colors.black12,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10.0, top: 8.0),
                      child: Container(
                        height: 10.0,
                        width: mediaQueryData.size.width / 4.1,
                        color: Colors.black12,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10.0, top: 10.0),
                      child: Container(
                        height: 8.0,
                        width: mediaQueryData.size.width / 6.0,
                        color: Colors.black12,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0, top: 10.0),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.star,
                            size: 11.0,
                            color: Colors.black12,
                          ),
                          Icon(
                            Icons.star,
                            size: 11.0,
                            color: Colors.black12,
                          ),
                          Icon(
                            Icons.star,
                            size: 11.0,
                            color: Colors.black12,
                          ),
                          Icon(
                            Icons.star,
                            size: 11.0,
                            color: Colors.black12,
                          ),
                          Icon(
                            Icons.star,
                            size: 11.0,
                            color: Colors.black12,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0, top: 10.0),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.location_on,
                            size: 13.0,
                            color: Colors.black38,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 5.0),
                            child: Container(
                              height: 6.0,
                              width: mediaQueryData.size.width / 5.5,
                              color: Colors.black12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 24.0, left: 10.0, bottom: 15.0),
                      child: Container(
                        height: 7.0,
                        width: mediaQueryData.size.width / 2.5,
                        decoration: BoxDecoration(
                            color: Colors.black12,
                            borderRadius:
                            BorderRadius.all(Radius.circular(4.0)),
                            shape: BoxShape.rectangle),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        )
      ],
    );
  }
}

///
///
/// Calling imageLoading animation for set a grid layout
///
///
Widget _loadingImageAnimation(BuildContext context,int length) {
  MediaQueryData mediaQueryData = MediaQuery.of(context);
  return GridView.count(
    crossAxisCount: 2,
    shrinkWrap: true,
    childAspectRatio: mediaQueryData.size.height / 1300,
    crossAxisSpacing: 0.0,
    mainAxisSpacing: 0.0,
    primary: false,
    children: List.generate(
      /// Get data in flashSaleItem.dart (ListItem folder)
      length,
          (index) => LoadingItemGrid(),
    ),
  );
}
