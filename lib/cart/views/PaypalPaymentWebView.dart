import 'dart:core';
import 'package:flutter/material.dart';
import 'package:isouq/Helpers/paypal_payment_service.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaypalPayment extends StatefulWidget {
  final Function onFinish;
  final double orderTotalPrice;

  PaypalPayment({this.onFinish,this.orderTotalPrice});

  @override
  State<StatefulWidget> createState() {
    return PaypalPaymentState();
  }
}

class PaypalPaymentState extends State<PaypalPayment> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String checkoutUrl;
  String executeUrl;
  String accessToken;
  PaypalServices services = PaypalServices();

  // you can change default currency according to your need
  Map<dynamic,dynamic> defaultCurrency = {"symbol": "USD ", "decimalDigits": 2, "symbolBeforeTheNumber": true, "currency": "USD"};

  bool isEnableShipping = false;
  bool isEnableAddress = false;

  String returnURL = 'return.example.com';
  String cancelURL= 'cancel.example.com';


  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () async {
      try {
        accessToken = await services.getAccessToken();

        final transactions = getOrderParams();
        final res =
        await services.createPaypalPayment(transactions, accessToken);
        if (res != null) {
          setState(() {
            checkoutUrl = res["approvalUrl"];
            executeUrl = res["executeUrl"];
          });
        }
      } catch (e) {
        print('exception: '+e.toString());
        final snackBar = SnackBar(
          content: Text(e.toString()),
          duration: Duration(seconds: 10),
          action: SnackBarAction(
            label: 'Close',
            onPressed: () {
              // Some code to undo the change.
            },
          ),
        );
        _scaffoldKey.currentState.showSnackBar(snackBar);
      }
    });
  }

  // item name and quantity
  String itemName = 'Order Total';
  int quantity = 1;

  Map<String, dynamic> getOrderParams() {
    List items = [
      {
        "name": itemName,
        "quantity": quantity,
        "price": widget.orderTotalPrice.toString().split(".")[1].length == 1 ? "${widget.orderTotalPrice.toString()}0" : widget.orderTotalPrice.toString(),
        "currency": defaultCurrency["currency"]
      }
    ];


    // checkout invoice details
    String totalAmount = widget.orderTotalPrice.toString().split(".")[1].length == 1 ? "${widget.orderTotalPrice.toString()}0" : widget.orderTotalPrice.toString();
    String subTotalAmount = widget.orderTotalPrice.toString().split(".")[1].length == 1 ? "${widget.orderTotalPrice.toString()}0" : widget.orderTotalPrice.toString();
    String shippingCost = '0';
    int shippingDiscountCost = 0;
    String userFirstName = 'Saad';
    String userLastName = 'Ali';
    String addressCity = 'Nasr City';
    String addressStreet = 'Nasr Road';
    String addressZipCode = '110014';
    String addressCountry = 'Egypt';
    String addressState = 'Cairo';
    String addressPhoneNumber = '+201099008377';

    Map<String, dynamic> temp = {
    "intent": "sale",
    "payer": {"payment_method": "paypal"},
    "transactions": [
    {
    "amount": {
    "total": totalAmount,
    "currency": defaultCurrency["currency"],
    "details": {
    "subtotal": subTotalAmount,
    "shipping": shippingCost,
    "shipping_discount":
    ((-1.0) * shippingDiscountCost).toString()
    }
    },
    "description": "The payment transaction description.",
    "payment_options": {
    "allowed_payment_method": "INSTANT_FUNDING_SOURCE"
    },
    "item_list": {
    "items": items,
    if (isEnableShipping &&
    isEnableAddress)
    "shipping_address": {
    "recipient_name": userFirstName +
    " " +
    userLastName,
    "line1": addressStreet,
    "line2": "",
    "city": addressCity,
    "country_code": addressCountry,
    "postal_code": addressZipCode,
    "phone": addressPhoneNumber,
    "state": addressState
    },
    }
    }
    ],
    "note_to_payer": "Contact us for any questions on your order.",
    "redirect_urls": {
    "return_url": returnURL,
    "cancel_url": cancelURL
    }
  };
    return temp;
  }


  @override
  Widget build(BuildContext context) {
    print(checkoutUrl);

    if (checkoutUrl != null) {
      return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: Theme.of(context).backgroundColor,
          leading: GestureDetector(
            child: Icon(Icons.arrow_back_ios),
            onTap: () => Navigator.pop(context),
          ),
        ),
        body: WebView(
          initialUrl: checkoutUrl,
          javascriptMode: JavascriptMode.unrestricted,
          navigationDelegate: (NavigationRequest request) {
            if (request.url.contains(returnURL)) {
              final uri = Uri.parse(request.url);
              final payerID = uri.queryParameters['PayerID'];
              if (payerID != null) {
                services
                    .executePayment(executeUrl, payerID, accessToken)
                    .then((id) {
                  widget.onFinish(id);
                  Navigator.of(_scaffoldKey.currentContext).pop();
                });
              } else {
                Navigator.of(_scaffoldKey.currentContext).pop();
              }
              Navigator.of(_scaffoldKey.currentContext).pop();
            }
            if (request.url.contains(cancelURL)) {
              Navigator.of(_scaffoldKey.currentContext).pop();
            }
            return NavigationDecision.navigate;
          },
        ),
      );
    } else {
      return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop();
              }),
          backgroundColor: Colors.black12,
          elevation: 0.0,
        ),
        body: Center(child: Container(child: CircularProgressIndicator())),
      );
    }
  }
}