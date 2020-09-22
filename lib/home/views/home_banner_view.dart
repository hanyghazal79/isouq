import 'package:flutter/material.dart';
import 'package:isouq/Helpers/Library/carousel_pro/src/carousel_pro.dart';
import 'package:isouq/brands/views/banner_brand_category_list_view.dart';
import 'package:isouq/home/viewmodels/home_viewmodel.dart';
import 'package:isouq/profile/models/item_model.dart';
import 'package:provider/provider.dart';

class HomeBannerView extends StatefulWidget{

  @override
  _homeBannerViewState createState() => _homeBannerViewState();


}

class _homeBannerViewState extends State<HomeBannerView> {

  HomeViewModel _viewModel;

  @override
  void initState() {
    _viewModel = Provider.of<HomeViewModel>(context,listen: false);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _viewModel.streamBanner(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if(snapshot.data.documents.length == 0)
              return SizedBox();
            else
            {
              List list = snapshot.data.documents as List;
              List imageList = List();
              list.forEach((i) {
                var item = ItemModel.fromDocumentSnapshot(i);

                var image = Image(
                  image: NetworkImage(item.image.elementAt(0)),
                  fit: BoxFit.fill,
                );
                imageList.add(image);
              });
              return Container(
                color: Colors.yellow,
                height: 182,
                child: Carousel(
                    onImageTap: (index){
                      var document = snapshot.data.documents[index];
                      Navigator.of(context).pushAndRemoveUntil(
                          PageRouteBuilder(
                              pageBuilder: (_, __, ___) => BannerOrBrandCategoryListScreen(ItemModel.fromDocumentSnapshot(document)),
                              transitionDuration: Duration(milliseconds: 600),
                              transitionsBuilder:
                                  (_, Animation<double> animation, __, Widget child) {
                                return Opacity(
                                  opacity: animation.value,
                                  child: child,
                                );
                              }),
                              (Route<dynamic> route) => true);
                    },
                    boxFit: BoxFit.fill,
                    dotColor: Colors.black,
                    dotSize: 5.5,
                    dotSpacing: 16.0,
                    dotBgColor: Colors.transparent,
                    showIndicator: true,
                    overlayShadow: true,
                    overlayShadowColors: Colors.yellow,
                    overlayShadowSize: 0.9,
                    images: imageList),
              );
            }
          }
        }
    );
  }

}



