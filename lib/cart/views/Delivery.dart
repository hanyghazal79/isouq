import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:isouq/cart/models/cart_item_model.dart';
import 'package:isouq/cart/viewmodels/cart_viewmodel.dart';
import 'package:isouq/cart/views/Payment.dart';
import 'package:isouq/common/text_styles/text_styles.dart';
import 'package:isouq/common/widgets/BottomNavigationBar.dart';
import 'package:isouq/profile/models/item_model.dart';
import 'package:provider/provider.dart';

final _localController = TextEditingController();
final _nameController = TextEditingController();
final _phoneController = TextEditingController();

var key = GlobalKey<ScaffoldState>();
String _errorMessageEvent = '';

class delivery extends StatefulWidget {
  final List<CartItemModel> cartModelList;
  final List<ItemModel> items;
  final String profileId;
  final double orderTotalPrice;

  delivery({this.cartModelList, this.profileId, this.items,this.orderTotalPrice});

  @override
  _deliveryState createState() => _deliveryState();
}

class _deliveryState extends State<delivery> {
  //GoogleAdMob _googleAdMob = GoogleAdMob();

  CartViewModel _viewModel;
  String cartId ;

  /// Duration for popup card if user succes to place order
  StartTime() async {
    return Timer(Duration(milliseconds: 3000), navigator);
  }

  /// Navigation to route after user succes place order
  void navigator() {
    Navigator.of(context).pop();
    Navigator.of(context).pushReplacement(PageRouteBuilder(
        pageBuilder: (_, __, ___) => new bottomNavigationBar()));
  }


  @override
  void initState() {
    _viewModel = Provider.of<CartViewModel>(context,listen: false);
    super.initState();

  }

  @override
  void dispose() {
    super.dispose();
    // _googleAdMob.disposeAds();
  }

  _isValidField(
      {String name, String phone, String local}) {
    if (name == null || name.trim().isEmpty) {
      _errorMessageEvent = tr('right name');
      return false;
    }
    if (local == null || local.trim().isEmpty) {
      _errorMessageEvent = tr('right local');
      return false;
    }
    if (phone == null || phone.trim().isEmpty || phone.length < 11) {
      _errorMessageEvent = tr('right num');
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: key,
      appBar: AppBar(
        leading: InkWell(
            onTap: () {
              Navigator.of(context).pop(false);
            },
            child: Icon(Icons.arrow_back)),
        elevation: 0.0,
        title: Text(
          tr('deliveryAppBar'),
          style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 18.0,
              color: Colors.black54,
              fontFamily: "Gotik"),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Color(0xFF6991C7)),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.only(top: 30.0, left: 20.0, right: 20.0),
            child: Column(
              children: <Widget>[
                Text(
                  tr('deliveryLocation'),
                  style: TextStyle(
                      letterSpacing: 0.1,
                      fontWeight: FontWeight.w600,
                      fontSize: 25.0,
                      color: Colors.black54,
                      fontFamily: "Gotik"),
                ),
                Padding(padding: EdgeInsets.only(top: 50.0)),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                      labelText: tr('name'),
                      hintText: tr('name'),
                      hintStyle: TextStyle(color: Colors.black54)),
                ),
                Padding(padding: EdgeInsets.only(top: 20.0)),
                TextFormField(
                  controller: _localController,
                  decoration: InputDecoration(
                      labelText: tr('address'),
                      hintText: tr('address'),
                      hintStyle: TextStyle(color: Colors.black54)),
                ),
                Padding(padding: EdgeInsets.only(top: 20.0)),
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      labelText: tr('num'),
                      hintText: tr('num'),
                      hintStyle: TextStyle(color: Colors.black54)),
                ),
                Padding(padding: EdgeInsets.only(top: 20.0)),
                InkWell(
                  onTap: () {
                    if (_isValidField(
                        local: _localController.value.text,
                        name: _nameController.value.text,
                        phone: _phoneController.value.text)) {
                      Map<String, dynamic> userOrder = createOrder();

                      Navigator.of(context)
                          .push(PageRouteBuilder(
                        pageBuilder: (_, __, ___) => Payment(userOrder: userOrder,cartId: cartId,orderTotalPrice: widget.orderTotalPrice,),
                      ));
//                      _placeOrder();

                    } else {
                      key.currentState.showSnackBar(SnackBar(
                        content: Text(_errorMessageEvent),
                      ));
                    }
                  },
                  child:
                  Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),

                        /// Total price of item buy
                        child: Text(
                          '${tr('cartTotal')} ${_calculateTotal(widget.cartModelList).toString()} EGP',
                          style: cartTotalStyle(),
                        ),
                      ),
                      SizedBox(height: 10,),
                      Container(
                        height: 55.0,
                        width: 300.0,
                        decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.all(Radius.circular(40.0))),
                        child: Center(
                          child: Text(
                            tr('goPayment'),
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 16.5,
                                letterSpacing: 1.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20.0,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  int _calculateTotal(List<CartItemModel> cardModels) {
    int totalPrice;
    int totalProductsPrice = 0;
    for (int i = 0; i < widget.items.length; i++) {
      int price;
      price = getItemPrice(widget.items.elementAt(i));
      totalPrice = price *
          int.parse(
              cardModels.elementAt(i).quantity);
      totalProductsPrice += totalPrice;
    }
    return totalProductsPrice;
  }

  int getItemPrice(ItemModel item) {
    int price;
    if (item
        .newPrice
        .isEmpty) {
      price = int.parse(
          item.price);
    } else {
      price = int.parse(
          item.newPrice);
    }
    return price;
  }

  Map<String, dynamic> createOrder() {
    Map<String, dynamic> finalOrderList = Map();
    Map<String, dynamic> userOrder = Map();
    widget.cartModelList.forEach((element) {
      cartId = element.id;
      var object = {
        'color': element.color,
        'size': element.size,
        'itemId': element.productId,
        'quantity': element.quantity,
        "title": element.title,
        "price" : element.price ,
        'image':widget.items.elementAt(0).image.elementAt(0),
        'time': DateTime.now().toString(),
        'status': 'under order'
      };
      finalOrderList.putIfAbsent(
          element.id, () => object);
    });
    userOrder.putIfAbsent(
        'user_information',
            () => {
          'userName': _nameController.value.text,
          'userLocal': _localController.value.text,
          'userNumber1':
          _phoneController.value.text,
          'userId': widget.profileId

        });

    userOrder.putIfAbsent('products_info', () => finalOrderList);
    userOrder.putIfAbsent('status', () => 'underOrder');
    userOrder.putIfAbsent('time', () => DateTime.now().toString());
    return userOrder;
  }



}
