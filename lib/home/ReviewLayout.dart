import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:isouq/Helpers/Library/Expanded/ExpandedDetailRatting.dart';
import 'package:isouq/home/models/RatingModel.dart';
import 'package:isouq/common/widgets/gradient_app_bar.dart';

class ReviewsAll extends StatefulWidget {
  List<RatingModel> ratingList;
  ReviewsAll(this.ratingList);
  @override
  _ReviewsAllState createState() => _ReviewsAllState();
}

class _ReviewsAllState extends State<ReviewsAll> {
  @override
  double rating = 3.5;
  int starCount = 5;

  /// Custom Text for Detail title
  static var _detailText = TextStyle(
      fontFamily: "Gotik",
      color: Colors.black54,
      letterSpacing: 0.3,
      wordSpacing: 0.5);

  Widget build(BuildContext context) {


        bool seeMore = false;
    List<Widget> columnWidgets = new List();
    List<Widget> seeMoreColumnWidgets = new List();

    var i= 0;
    for(var rating in widget.ratingList)
    {
      if(i<8) {
        columnWidgets.add(
            _buildRating(rating.rating,
                rating.desc,
                    (rating) {
                  setState(() {
//                                    this.rating_start = rating;
                  });
                },
                rating.userImage,
                double.parse(rating.rating)
            ));
        columnWidgets.add(Padding(
          padding: EdgeInsets.only(left: 0.0,
              right: 20.0,
              top: 15.0,
              bottom: 7.0),
          child: _line(),
        ));
        columnWidgets.add(Padding(
            padding: EdgeInsets.only(bottom: 20.0)));
        i++;
      }
      else
        {
          seeMoreColumnWidgets.add(
              _buildRating(rating.ratingTime,
                  rating.desc,
                      (rating) {
                    setState(() {
//                                    this.rating_start = rating;
                    });
                  },
                  rating.userImage,
                  double.parse(rating.rating)
              ));
          seeMoreColumnWidgets.add(Padding(
            padding: EdgeInsets.only(left: 0.0,
                right: 20.0,
                top: 15.0,
                bottom: 7.0),
            child: _line(),
          ));
          seeMoreColumnWidgets.add(Padding(
              padding: EdgeInsets.only(bottom: 20.0)));
        }
    }
    if(i>8)
      seeMore = true;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: gradientAppBar(tr('reviewsAppBar')),

      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top:10.0,left: 20.0),
                  child:  Text(tr('reviewsAppBar'),style: TextStyle(color: Colors.black,fontSize: 20.0,fontFamily: "Popins",fontWeight: FontWeight.w700),),
                ),
                Padding(
                  padding: const EdgeInsets.only(top:5.0,left: 20.0),
                  child: Row(
                    children: <Widget>[
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            StarRating(
                              size: 25.0,
                              starCount: 5,
                              rating: rating,
                              color: Colors.yellow,
                            ),
                            SizedBox(width: 5.0),
                            Text('${widget.ratingList.length} Reviews')
                          ]),
                    ],
                  ),
                ),
                Padding(padding: EdgeInsets.only(left: 20.0,right: 20.0,top: 15.0,bottom: 7.0),
                  child: _line(),
                ),
                Column(children: columnWidgets,),
                SizedBox(height: 10.0,),
                _line(),
                Column(
                  children: <Widget>[
                    seeMore ? ExpansionTileCustomRatting(
                      title:    _buildRating( tr('date'),
                          tr('ratingReview'),
                              (rating) {
                            setState(() {
                              this.rating = rating;
                            });
                          },
                          "assets/avatars/avatar-6.jpg",
                          7070
                      ),
                      children:[
                        Padding(padding: EdgeInsets.only(left: 20.0,right: 20.0,top: 15.0,bottom: 7.0),
                          child: _line(),
                        ),
                        Column(children: seeMoreColumnWidgets,),
                      ],
//                              child: Text("Read More",style: _subHeaderCustomStyle.copyWith(fontSize: 13.0,color: Colors.blueAccent),
//                              textAlign: TextAlign.end,
//                              ),
                    ): Container(),
                  ],
                ),
                Padding(padding: EdgeInsets.only(bottom: 40.0)),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildRating(String date, String details, Function changeRating,String image, double rating) {
    return ListTile(
      leading: Container(
        height: 45.0,
        width: 45.0,
        decoration: BoxDecoration(
            image: DecorationImage(image: (image != null && image.isNotEmpty) ? NetworkImage(image) : AssetImage('assets/img/person-imag.jpg'),fit: BoxFit.cover),
            borderRadius: BorderRadius.all(Radius.circular(50.0))
        ),
      ),
      title: Row(
        children: <Widget>[
          StarRating(
              size: 20.0,
              rating: rating,
              starCount: 5,
              color: Colors.yellow,
              onRatingChanged: changeRating),
          SizedBox(width: 8.0),
          Text(
            date,
            style: TextStyle(fontSize: 12.0),
          )
        ],
      ),
      subtitle: Text(details,style: _detailText,),
    );
  }
}

Widget _line(){
  return  Container(
    height: 0.9,
    width: double.infinity,
    color: Colors.black12,
  );
}