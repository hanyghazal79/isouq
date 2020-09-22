import 'package:flutter/material.dart';
import 'package:isouq/Firebase/firebase_methods.dart';

class BrandListViewModel extends ChangeNotifier {

  final firebaseSharedInstance = FirebaseMethods.sharedInstance;

  getBrandList()
  {
    return firebaseSharedInstance.getItems(type: firebaseSharedInstance.brand);
  }

  getBrandCategoryList(String brandId)
  {
    return firebaseSharedInstance.getSubItems(type: firebaseSharedInstance.categoriesCollection, parentId: brandId);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

}