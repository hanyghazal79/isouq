import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:isouq/Firebase/firebase_methods.dart';
import 'package:isouq/common/widgets/gradient_app_bar.dart';
import 'package:isouq/home/views/item_details_view.dart';
import 'package:isouq/profile/models/item_model.dart';

String _textSearch;

final firebaseSharedInstance = FirebaseMethods.sharedInstance;

class SearchAppbar extends StatefulWidget {
  @override
  _SearchAppbarState createState() => _SearchAppbarState();
}

class _SearchAppbarState extends State<SearchAppbar> {
  bool clickSearch = false;


  Widget build(BuildContext context) {
    /// Sentence Text header "Hello i am Treva.........."
    var _textHello = Padding(
      padding: const EdgeInsets.only(right: 50.0, left: 20.0),
      child: Text(
        tr('searchHello') + " in Items ?",
        style: TextStyle(
            letterSpacing: 0.1,
            fontWeight: FontWeight.w600,
            fontSize: 27.0,
            color: Colors.black54,
            fontFamily: "Gotik"),
      ),
    );

    /// Item TextFromField Search
    var _search = Padding(
      padding: const EdgeInsets.only(top: 35.0, right: 20.0, left: 20.0),
      child: Container(
        height: 50.0,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 15.0,
                  spreadRadius: 0.0)
            ]),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 10.0),
            child: Theme(
              data: ThemeData(hintColor: Colors.transparent),
              child: TextFormField(
                onChanged: (val) {
                  setState(() {
                    clickSearch = true;
                    _textSearch = val;
                  });
                },
                decoration: InputDecoration(
                    border: InputBorder.none,
                    icon: Icon(
                      Icons.search,
                      color: Colors.grey,
                      size: 28.0,
                    ),
                    hintText: tr('findYouWant'),
                    hintStyle: TextStyle(
                        color: Colors.black54,
                        fontFamily: "Gotik",
                        fontWeight: FontWeight.w400)),
              ),
            ),
          ),
        ),
      ),
    );

    /// Item search results with Card item
    var _searchResults = Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Container(
        height: 350,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: Text(
                tr('searchResults'),
                style: TextStyle(fontFamily: "Gotik", color: Colors.black26),
              ),
            ),
            StreamBuilder(
                stream: firebaseSharedInstance.getItems(
                    type: firebaseSharedInstance.item),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    List list = List();

                    if (_textSearch.isNotEmpty || _textSearch != '') {
                      snapshot.data.documents.forEach((element) {
                        var item =
                            ItemModel.fromDocumentSnapshot(element);

                        if (item.title.toLowerCase().contains(_textSearch)) {
                          list.add(item);
                        }
                      });
                    }
                    if (list.length > 0) {
                      return Expanded(
                        child: ListView.builder(
                          itemCount: list.length,
                          padding: EdgeInsets.only(top: 20.0, bottom: 2.0),
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: FavoriteItem(
                                itemModel: list[index],
                              ),
                            );
                          },
                        ),
                      );
                    } else {
                      return Image.asset(
                        "assets/imgIllustration/IlustrasiCart.png",
                      );
                    }
                  }
                }),
          ],
        ),
      ),
    );

    /// Item Favorite Item with Card item
    var _favorite = Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Container(
        height: 250.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: Text(
                tr('topRated'),
                style: TextStyle(fontFamily: "Gotik", color: Colors.black26),
              ),
            ),
            StreamBuilder(
                stream: firebaseSharedInstance.getRecommendedItemsStream(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return Expanded(
                      child: ListView.builder(
                        itemCount: snapshot.data.documents.length,
                        padding: EdgeInsets.only(top: 20.0, bottom: 2.0),
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (BuildContext context, int index) {
                          var item = ItemModel.fromDocumentSnapshot(
                              snapshot.data.documents[index]);
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FavoriteItem(
                              itemModel: item,
                            ),
                          );
                        },
                      ),
                    );
                  }
                }),
          ],
        ),
      ),
    );

    /// Popular Keyword Item
    var _sugestedText = Container(
      height: 145.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 20.0, right: 20.0),
            child: Text(
              tr('popularity'),
              style: TextStyle(fontFamily: "Gotik", color: Colors.black26),
            ),
          ),
          Padding(padding: EdgeInsets.only(top: 20.0)),
          Expanded(
              child: ListView(
            scrollDirection: Axis.horizontal,
            children: <Widget>[
              Padding(padding: EdgeInsets.only(left: 20.0)),
              KeywordItem(
                title: tr('searchTitle1'),
                title2: tr('searchTitle2'),
              ),
              KeywordItem(
                title: tr('searchTitle3'),
                title2: tr('searchTitle4'),
              ),
              KeywordItem(
                title: tr('searchTitle5'),
                title2: tr('searchTitle6'),
              ),
              KeywordItem(
                title: tr('searchTitle7'),
                title2: tr('searchTitle8'),
              ),
            ],
          ))
        ],
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: gradientAppBar(tr('search')),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.only(top: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                /// Caliing a variable
                _textHello,
                _search,
                //  _sugestedText,
                clickSearch ? _searchResults : Container(),
                _favorite,
                Padding(padding: EdgeInsets.only(bottom: 30.0, top: 2.0))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Popular Keyword Item class
class KeywordItem extends StatelessWidget {
  @override
  String title, title2;

  KeywordItem({this.title, this.title2});

  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 4.0, left: 3.0),
          child: Container(
            height: 29.5,
            width: 90.0,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4.5,
                  spreadRadius: 1.0,
                )
              ],
            ),
            child: Center(
              child: Text(
                title,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.black54, fontFamily: "Sans"),
              ),
            ),
          ),
        ),
        Padding(padding: EdgeInsets.only(top: 15.0)),
        Container(
          height: 29.5,
          width: 90.0,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4.5,
                spreadRadius: 1.0,
              )
            ],
          ),
          child: Center(
            child: Text(
              title2,
              style: TextStyle(
                color: Colors.black54,
                fontFamily: "Sans",
              ),
            ),
          ),
        ),
      ],
    );
  }
}

///Favorite Item Card
class FavoriteItem extends StatelessWidget {
  final ItemModel itemModel;

  FavoriteItem({this.itemModel});

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Padding(
      padding: const EdgeInsets.only(left: 2.0),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            boxShadow: [
              BoxShadow(
                color: Color(0xFF656565).withOpacity(0.15),
                blurRadius: 4.0,
                spreadRadius: 1.0,
//           offset: Offset(4.0, 10.0)
              )
            ]),
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(PageRouteBuilder(
                pageBuilder: (_, ___, ____) => new ItemDetails(
                  item: itemModel,
                    )));
          },
          child: Wrap(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    height: 120.0,
                    width: 150.0,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(7.0),
                            topRight: Radius.circular(7.0)),
                        image: DecorationImage(
                            image: NetworkImage(itemModel.image.elementAt(0)),
                            fit: BoxFit.cover)),
                  ),
                  Padding(padding: EdgeInsets.only(top: 15.0)),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                    child: Text(
                      itemModel.title,
                      style: TextStyle(
                          letterSpacing: 0.5,
                          color: Colors.black54,
                          fontFamily: "Sans",
                          fontWeight: FontWeight.w500,
                          fontSize: 13.0),
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(top: 1.0)),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                    child: Text(
                      itemModel.price,
                      style: TextStyle(
                          fontFamily: "Sans",
                          fontWeight: FontWeight.w500,
                          fontSize: 14.0),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 15.0, right: 15.0, top: 5.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text(
                              itemModel.rating,
                              style: TextStyle(
                                  fontFamily: "Sans",
                                  color: Colors.black26,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12.0),
                            ),
                            Icon(
                              Icons.star,
                              color: Colors.yellow,
                              size: 14.0,
                            )
                          ],
                        ),
                        Text(
                          itemModel.sale,
                          style: TextStyle(
                              fontFamily: "Sans",
                              color: Colors.black26,
                              fontWeight: FontWeight.w500,
                              fontSize: 12.0),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
