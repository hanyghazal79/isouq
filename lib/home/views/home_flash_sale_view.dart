import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:isouq/Helpers/Library/countdown_timer/countDownTimer.dart';
import 'package:isouq/home/viewmodels/home_viewmodel.dart';
import 'package:isouq/home/views/flash_sale_item_view.dart';
import 'package:isouq/profile/models/item_model.dart';
import 'package:provider/provider.dart';

class HomeFlashSaleView extends StatefulWidget{

  @override
  _homeFlashSaleViewState createState() => _homeFlashSaleViewState();


}

class _homeFlashSaleViewState extends State<HomeFlashSaleView> {

  HomeViewModel _viewModel;

  @override
  void initState() {
    _viewModel = Provider.of<HomeViewModel>(context,listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    double size = mediaQueryData.size.height;

    /// Declare device Size
    var deviceSize = MediaQuery
        .of(context)
        .size;

    return StreamBuilder(
        stream: _viewModel.streamOffers(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
              if(snapshot.data.documents.length == 0)
              {
                return SizedBox();
              }
              else
                {
                  var listWidgets = List<Widget>();
                  listWidgets.add(Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding:
                        EdgeInsets.only(left: mediaQueryData.padding.left + 20),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Image.asset(
                            "assets/img/flashsaleicon.png",
                            height: deviceSize.height * 0.087,
                          ),
                          Text(
                            tr('flash'),
                            style: TextStyle(
                              fontFamily: "Popins",
                              fontSize: 30.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            tr('sale'),
                            style: TextStyle(
                              fontFamily: "Sans",
                              fontSize: 28.0,
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      )
                    ],
                  ));
                  listWidgets.add(
                    Padding(padding: EdgeInsets.only(left: 40.0)),
                  );
                  var offerList = snapshot.data.documents as List;
                  offerList.forEach((i) {
                    var offer = ItemModel.fromDocumentSnapshot(i);
                    listWidgets.add(

                      /// Get a component flashSaleItem class
                      FlashSaleItem(
                        image: offer.image.length == 0 ? '' : offer.image.elementAt(0),
                        title: offer.title,
                        normalprice: offer.price,
                        discountprice: offer.newPrice,
                        ratingvalue: "(${offer.rating})",
                        place: offer.place,
                        stock: offer.stock,
                        colorLine: int.parse("0xFFFFA500"),
                        widthLine:
                        offer.stock != "" && double.parse(offer.stock) < 200.0
                            ? double.parse(offer.stock)
                            : 50,
                      ),
                    );
                    listWidgets.add(
                      Padding(padding: EdgeInsets.only(left: 10.0)),
                    );
                  });

                  return Container(
                    height: 390.0,
                    decoration: BoxDecoration(

                      /// To set Gradient in flashSale background
                      gradient: LinearGradient(colors: [
                        Colors.yellowAccent,
                        Color(0xFFA0F1EA),
//                        Color(0xFF1034A6),
                      ]),
                    ),
                    child: ListView(
                        scrollDirection: Axis.horizontal, children: listWidgets),
                  );
                }
          }

        }
        );
  }

}



