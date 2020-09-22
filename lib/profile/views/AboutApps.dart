import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:isouq/common/widgets/gradient_app_bar.dart';

class AboutApps extends StatefulWidget {
  @override
  _AboutAppsState createState() => _AboutAppsState();
}

class _AboutAppsState extends State<AboutApps> {
  @override

  static var _txtCustomHead = TextStyle(
    color: Colors.black54,
    fontSize: 17.0,
    fontWeight: FontWeight.w600,
    fontFamily: "Gotik",
  );

  static var _txtCustomSub = TextStyle(
    color: Colors.black38,
    fontSize: 15.0,
    fontWeight: FontWeight.w500,
    fontFamily: "Gotik",
  );

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: gradientAppBar(tr('aboutApps')),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Divider(
                  height: 0.5,
                  color: Colors.black12,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.0, left: 15.0,right: 15.0),
                child: Row(
                  children: <Widget>[
                    Image.asset(
                      "assets/img/logo.png",
                      height: 50.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            tr('title'),
                            style: _txtCustomSub.copyWith(
                                fontWeight: FontWeight.w600),
                          ),
                          Text(
                            tr('uiKit'),
                            style: _txtCustomSub,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Divider(
                  height: 0.5,
                  color: Colors.black12,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  "iSOUQ is the first production company i-Software (which builds mobile applications) and it is one of the first e-commerce applications in the Middle East",
                  style: _txtCustomSub,
                  textAlign: TextAlign.justify,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
