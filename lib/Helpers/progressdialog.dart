import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ProgressDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Material(
      color: Colors.black.withAlpha(200),
      child: Center(
        child: new Container(
          padding: const EdgeInsets.all(30.0),
          child: new GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: new Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new CircularProgressIndicator(),
                  new SizedBox(height: 15.0),
                  new Text(
                   tr('please_wait'),
                    style: new TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w700),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
