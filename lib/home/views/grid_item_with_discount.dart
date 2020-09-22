import 'package:flutter/material.dart';
import 'package:isouq/home/views/item_details_view.dart';
import 'package:isouq/profile/models/item_model.dart';

/// Class for card product in "Top Rated Products"
class ItemGridWithDiscount extends StatelessWidget {
  final ItemModel itemSale;

  ItemGridWithDiscount(this.itemSale);

  getDiscount() {
    var discount =
        (int.parse(itemSale.newPrice) * 100) / int.parse(itemSale.price);
    discount = 100 - discount;
    String finalDiscount = discount.toInt().toString() + " %";
    return finalDiscount;
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Container(
      decoration:
      BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(50))),
      padding: EdgeInsets.all(10),
      child: Card(
        child: InkWell(
          onTap: () {
            /// Animation Transition with opacity value in route navigate another layout
            Navigator.of(context).push(PageRouteBuilder(
                pageBuilder: (_, __, ___) => new ItemDetails(
                  item: itemSale,
                ),
                transitionDuration: Duration(milliseconds: 950),
                transitionsBuilder:
                    (_, Animation<double> animation, __, Widget child) {
                  return Opacity(
                    opacity: animation.value,
                    child: child,
                  );
                }));
          },
          child: Container(
            decoration: BoxDecoration(color: Colors.white, boxShadow: [
              BoxShadow(
                  color: Colors.black12.withOpacity(0.1),
                  spreadRadius: 0.2,
                  blurRadius: 0.5)
            ]),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                /// Animation image header to flashSaleDetail.dart
                Hero(
                  tag: "hero-flashsale-${itemSale.id}",
                  child: Material(
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(PageRouteBuilder(
                            opaque: false,
                            pageBuilder: (BuildContext context, _, __) {
                              return new Material(
                                color: Colors.black54,
                                child: Container(
                                  padding: EdgeInsets.all(30.0),
                                  child: InkWell(
                                    child: Hero(
                                        tag: "hero-flashsale-${itemSale.id}",
                                        child: Image.network(
                                          itemSale.image.elementAt(0),
                                          width: 300.0,
                                          height: 300.0,
                                          alignment: Alignment.center,
                                          fit: BoxFit.contain,
                                        )),
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ),
                              );
                            },
                            transitionDuration: Duration(milliseconds: 500)));
                      },
                      child: SizedBox(
                        child: Stack(
                          children: <Widget>[
                            Image.network(
                              itemSale.image.elementAt(0),
                              fit: BoxFit.cover,
                              height: 140.0,
                              width: mediaQueryData.size.width / 2.1,
                            ),
                            Container(
                              height: 25.5,
                              width: 55.0,
                              decoration: BoxDecoration(
                                  color: Color(0xFFD7124A),
                                  borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(20.0),
                                      topLeft: Radius.circular(5.0))),
                              child: Center(
                                  child: Text(
                                    getDiscount(),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600),
                                  )),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 15.0),
                  child: Container(
                    width: mediaQueryData.size.width / 2.7,
                    child: Text(
                      itemSale.title,
                      style: TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w500,
                          fontFamily: "Sans"),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10.0, top: 5.0,right: 10),
                  child: Text("${itemSale.price} EGP",
                      style: TextStyle(
                          fontSize: 10.5,
                          decoration: TextDecoration.lineThrough,
                          color: Colors.black54,
                          fontWeight: FontWeight.w600,
                          fontFamily: "Sans")),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10.0, top: 5.0,right: 10),
                  child: Text("${itemSale.newPrice} EGP",
                      style: TextStyle(
                          fontSize: 12.0,
                          color: Color(0xFF7F7FD5),
                          fontWeight: FontWeight.w800,
                          fontFamily: "Sans")),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, top: 5.0,right: 10),
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.star,
                        size: 11.0,
                        color: Colors.yellow,
                      ),
                      Icon(
                        Icons.star,
                        size: 11.0,
                        color: Colors.yellow,
                      ),
                      Icon(
                        Icons.star,
                        size: 11.0,
                        color: Colors.yellow,
                      ),
                      Icon(
                        Icons.star,
                        size: 11.0,
                        color: Colors.yellow,
                      ),
                      Icon(
                        Icons.star_half,
                        size: 11.0,
                        color: Colors.yellow,
                      ),
                      Text(
                        itemSale.rating,
                        style: TextStyle(
                            fontSize: 10.0,
                            fontWeight: FontWeight.w500,
                            fontFamily: "Sans",
                            color: Colors.black38),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, top: 5.0,right: 10),
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.location_on,
                        size: 11.0,
                        color: Colors.black38,
                      ),
                      Text(
                        itemSale.place,
                        style: TextStyle(
                            fontSize: 10.0,
                            fontWeight: FontWeight.w500,
                            fontFamily: "Sans",
                            color: Colors.black38),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0, left: 10.0,right: 10),
                  child: Text(
                    itemSale.stock,
                    style: TextStyle(
                        fontSize: 10.0,
                        fontWeight: FontWeight.w500,
                        fontFamily: "Sans",
                        color: Colors.black),
                  ),
                ),
                Padding(
                  padding:
                  const EdgeInsets.only(top: 4.0, left: 10.0, bottom: 15.0,right: 10),
                  child: Container(
                    height: 5.0,
                    width: 50,
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.all(Radius.circular(4.0)),
                        shape: BoxShape.rectangle),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}