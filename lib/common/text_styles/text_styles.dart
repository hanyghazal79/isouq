import 'dart:ui';
import 'package:flutter/material.dart';

 fontHeaderStyle() {
  return TextStyle(
      fontFamily: "Popins",
      fontSize: 21.0,
      fontWeight: FontWeight.w800,
      color: Colors.black87,
      letterSpacing: 1.5
  );
}

 fontDescriptionStyle() {
   return  TextStyle(
       fontFamily: "Sans",
       fontSize: 15.0,
       color: Colors.black26,
       fontWeight: FontWeight.w400
   );
 }

 /// Custom Font
 txt () {
  return TextStyle(
    color: Colors.grey,
    fontFamily: "Sans",
    );
  }

  /// Get _txt and custom value of Variable for Name User
  txtName() => txt().copyWith(fontWeight: FontWeight.w700, fontSize: 17.0);

  /// Get _txt and custom value of Variable for Edit text
  txtEdit () => txt().copyWith(color: Colors.black26, fontSize: 15.0);

  /// Get _txt and custom value of Variable for Category Text
  txtCategory() => txt().copyWith(
      fontSize: 14.5, color: Colors.grey, fontWeight: FontWeight.w500);

txtCustomHead() => TextStyle(
  color: Colors.black54,
  fontSize: 17.0,
  fontWeight: FontWeight.w600,
  fontFamily: "Gotik",
);

txtCustomSub() => TextStyle(
  color: Colors.black38,
  fontSize: 15.0,
  fontWeight: FontWeight.w500,
  fontFamily: "Gotik",
);

/// Custom text header for bottomSheet
fontCostumSheetBotomHeader() => TextStyle(
    fontFamily: "Berlin",
    color: Colors.black54,
    fontWeight: FontWeight.w600,
    fontSize: 16.0);

/// Custom text for bottomSheet
 fontCostumSheetBotom() => TextStyle(
    fontFamily: "Sans",
    color: Colors.black45,
    fontWeight: FontWeight.w400,
    fontSize: 16.0);

 cartTextSyle () => TextStyle(
     fontFamily: "Gotik",
     fontSize: 18.0,
     color: Colors.black54,
     fontWeight: FontWeight.w700);

 cartTotalStyle () => TextStyle(
     color: Colors.black,
     fontWeight: FontWeight.bold,
     fontSize: 15.5,
     fontFamily: "Sans");

/// Custom Text Header for Dialog after user succes payment
txtCustomHead2 () => TextStyle(
  color: Colors.black54,
  fontSize: 23.0,
  fontWeight: FontWeight.w600,
  fontFamily: "Gotik",
);

/// Custom Text Description for Dialog after user succes payment
txtCustomSub2 () => TextStyle(
  color: Colors.black38,
  fontSize: 15.0,
  fontWeight: FontWeight.w500,
  fontFamily: "Gotik",
);

/// Custom Text black
customTextStyle() => TextStyle(
  color: Colors.black,
  fontFamily: "Gotik",
  fontSize: 17.0,
  fontWeight: FontWeight.w800,
);

/// Custom Text for Header title
subHeaderCustomStyle() => TextStyle(
    color: Colors.black54,
    fontWeight: FontWeight.w700,
    fontFamily: "Gotik",
    fontSize: 16.0);

/// Custom Text for Detail title
detailText() => TextStyle(
    fontFamily: "Gotik",
    color: Colors.black54,
    letterSpacing: 0.3,
    wordSpacing: 0.5);



