import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:isouq/Firebase/firebase_methods.dart';
import 'package:isouq/Helpers/stripe_payment-service.dart';
import 'package:isouq/cart/viewmodels/cart_viewmodel.dart';
import 'package:isouq/cart/views/PaypalPaymentWebView.dart';
import 'package:isouq/common/text_styles/text_styles.dart';
import 'package:isouq/common/widgets/BottomNavigationBar.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';

final firebaseSharedInstance = FirebaseMethods.sharedInstance;

class Payment extends StatefulWidget {
  final Map<String, dynamic> userOrder;
  final String cartId;
  final double orderTotalPrice;

  Payment({this.userOrder, this.cartId,this.orderTotalPrice});

  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  static const platform = const MethodChannel("razorpay_flutter");


  ScrollController _controller = ScrollController();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  CartViewModel _viewModel;

  @override
  void initState() {
    _viewModel = Provider.of<CartViewModel>(context, listen: false);
    StripeService.init();
  }

  /// For radio button
  int tapvalue = 0;
  int tapvalue2 = 0;
  int tapvalue3 = 0;
  int tapvalue4 = 0;

  /// Custom Text
  var _customStyle = TextStyle(
      fontFamily: "Gotik",
      fontWeight: FontWeight.w800,
      color: Colors.black,
      fontSize: 17.0);

  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,

      /// Appbar
      appBar: AppBar(
        leading: InkWell(
            onTap: () {
              Navigator.of(context).pop(false);
            },
            child: Icon(Icons.arrow_back)),
        elevation: 0.0,
        title: Text(
          tr('payment'),
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
                  tr('chosePaymnet'),
                  style: TextStyle(
                      letterSpacing: 0.1,
                      fontWeight: FontWeight.w600,
                      fontSize: 25.0,
                      color: Colors.black54,
                      fontFamily: "Gotik"),
                ),
                Padding(padding: EdgeInsets.only(top: 60.0)),

                /// For RadioButton if selected or not selected
                InkWell(
                  onTap: () {
                    setState(() {
                      if (tapvalue == 0) {
                        tapvalue++;
                      } else {
                        tapvalue--;
                      }
                    });
                  },
                  child: Row(
                    children: <Widget>[
                      Radio(
                        value: 1,
                        groupValue: tapvalue,
                        onChanged: null,
                      ),
                      Text(
                        tr('credit'),
                        style: _customStyle,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 40.0),
                        child: Image.asset(
                          "assets/img/credit.png",
                          height: 25.0,
                        ),
                      )
                    ],
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 15.0)),
                Divider(
                  height: 1.0,
                  color: Colors.black26,
                ),
                Padding(padding: EdgeInsets.only(top: 15.0)),
                InkWell(
                  onTap: () {
                    setState(() {
                      if (tapvalue2 == 0) {
                        tapvalue2++;
                      } else {
                        tapvalue2--;
                      }
                    });
                  },
                  child: Row(
                    children: <Widget>[
                      Radio(
                        value: 1,
                        groupValue: tapvalue2,
                        onChanged: null,
                      ),
                      Text(tr('cashOn'), style: _customStyle),
                      Padding(
                        padding: const EdgeInsets.only(left: 50.0),
                        child: Image.asset(
                          "assets/img/handshake.png",
                          height: 25.0,
                        ),
                      )
                    ],
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 15.0)),
                Divider(
                  height: 1.0,
                  color: Colors.black26,
                ),
                Padding(padding: EdgeInsets.only(top: 15.0)),
                InkWell(
                  onTap: () {
                    setState(() {
                      if (tapvalue3 == 0) {
                        tapvalue3++;
                      } else {
                        tapvalue3--;
                      }
                    });
                  },
                  child: Row(
                    children: <Widget>[
                      Radio(
                        value: 1,
                        groupValue: tapvalue3,
                        onChanged: null,
                      ),
                      Text(tr('paypal'), style: _customStyle),
                      Padding(
                        padding: const EdgeInsets.only(left: 130.0),
                        child: Image.asset(
                          "assets/img/paypal.png",
                          height: 25.0,
                        ),
                      )
                    ],
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 15.0)),
                Divider(
                  height: 1.0,
                  color: Colors.black26,
                ),
//                  Padding(padding: EdgeInsets.only(top: 15.0)),
//                  InkWell(
//                    onTap: () {
//                      setState(() {
//                        if (tapvalue4 == 0) {
//                          tapvalue4++;
//                        } else {
//                          tapvalue4--;
//                        }
//                      });
//                    },
//                    child: Row(
//                      children: <Widget>[
//                        Radio(
//                          value: 1,
//                          groupValue: tapvalue4,
//                          onChanged: null,
//                        ),
//                        Text(tr('googleWallet'), style: _customStyle),
//                        Padding(
//                          padding: const EdgeInsets.only(left: 65.0),
//                          child: Image.asset(
//                            "assets/img/googlewallet.png",
//                            height: 25.0,
//                          ),
//                        )
//                      ],
//                    ),
//                  ),
                Padding(padding: EdgeInsets.only(top: 110.0)),

                /// Button pay
                InkWell(
                  onTap: () {
                    if (tapvalue == 1) {
//
                    print(widget.orderTotalPrice);
                      payViaNewCard(context,widget.orderTotalPrice,"USD");

                    } else if (tapvalue2 == 1) {
                      _placeOrder(false);
                      StartTime();
                    } else if (tapvalue3 == 1) {
                      // make PayPal payment

                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) => PaypalPayment(
                            orderTotalPrice: widget.orderTotalPrice
                            ,onFinish: (number) async {

                              // payment done
                            _placeOrder(true);
                            _scaffoldKey.currentState.showSnackBar(
                                SnackBar(
                                  content: Text("Transaction successful"),
                                  duration: new Duration(milliseconds: 4000),
                                )
                            );

                          },
                          ),
                        ),
                      );
                    }
                  },
                  child: Container(
                    height: 55.0,
                    width: 300.0,
                    decoration: BoxDecoration(
                        color: Colors.indigoAccent,
                        borderRadius: BorderRadius.all(Radius.circular(40.0))),
                    child: Center(
                      child: Text(
                        tr('pay'),
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 16.5,
                            letterSpacing: 2.0),
                      ),
                    ),
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

    void _placeOrder(bool paid) {
      _viewModel.deleteCart(widget.cartId);
      Map<String, dynamic> userOrderWithPaidStatus = widget.userOrder;
      userOrderWithPaidStatus['paid'] = paid;
      _viewModel.placeOrder(userOrder: userOrderWithPaidStatus);
      _showDialog(context);
  }

  payViaNewCard(BuildContext context, double amount,String currency) async {
    ProgressDialog dialog = new ProgressDialog(context);
    dialog.style(
        message: 'Please wait...'
    );
    await dialog.show();
    amount = amount*100;
    String amountSt = amount.toString().split(".")[1].length == 1 ? "${amount.toString()}0" : amount.toString();
    amountSt = amountSt.split(".")[0];
    var response = await StripeService.payWithNewCard(
        amount: amountSt,
        currency: currency
    );
    await dialog.hide();

    _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text(response.message),
          duration: new Duration(milliseconds: response.success == true ? 1200 : 3000),
        )
    );

    if (response.success)
      _placeOrder(true);

  }

  /// Card Popup if success place order
  _showDialog(BuildContext ctx) {
    showDialog(
      context: ctx,
      barrierDismissible: true,
      child: SimpleDialog(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 30.0, right: 60.0, left: 60.0),
            color: Colors.white,
            child: Image.asset(
              "assets/img/checklist.png",
              height: 110.0,
              color: Colors.lightGreen,
            ),
          ),
          Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(
                  tr('yuppy'),
                  style: txtCustomHead2(),
                ),
              )),
          Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 30.0, bottom: 40.0,left: 8.0, right: 8.0),
                child: Text(
                  tr('order_requested'),
                  style: txtCustomSub2(),
                ),
              )),
        ],
      ),
    );
    StartTime();
  }

  /// Duration for popup card if user succes to payment
  StartTime() async {
    return Timer(Duration(milliseconds: 1450), navigator);
  }

  /// Navigation to route after user succes payment
  void navigator() {
    Navigator.of(context).pushReplacement(PageRouteBuilder(
        pageBuilder: (_, __, ___) => new bottomNavigationBar()));
  }

}

/// Custom Text Header for Dialog after user succes payment
var _txtCustomHead = TextStyle(
  color: Colors.black54,
  fontSize: 23.0,
  fontWeight: FontWeight.w600,
  fontFamily: "Gotik",
);

/// Custom Text Description for Dialog after user succes payment
var _txtCustomSub = TextStyle(
  color: Colors.black38,
  fontSize: 15.0,
  fontWeight: FontWeight.w500,
  fontFamily: "Gotik",
);

/// Card Popup if success payment
_showDialog(BuildContext ctx) {
  showDialog(
    context: ctx,
    barrierDismissible: true,
    child: SimpleDialog(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(top: 30.0, right: 60.0, left: 60.0),
          color: Colors.white,
          child: Image.asset(
            "assets/img/checklist.png",
            height: 110.0,
            color: Colors.lightGreen,
          ),
        ),
        Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Text(
                tr('yuppy'),
                style: _txtCustomHead,
              ),
            )),
        Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 30.0, bottom: 40.0),
              child: Text(
                tr('order_requested'),
                style: _txtCustomSub,
              ),
            )),
      ],
    ),
  );
}
