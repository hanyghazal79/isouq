import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:isouq/Helpers/google_admob_management//google_admob.dart';
import 'package:isouq/common/ui_events/ui_events.dart';
import 'package:isouq/home/GridListScreen.dart';
import 'package:isouq/login/views/ChooseLoginOrSignup.dart';
import 'package:isouq/profile/views/AboutApps.dart';
import 'package:isouq/profile/views/language_Setting_view.dart';
import 'package:isouq/common/text_styles/text_styles.dart';
import 'package:isouq/profile/models/profileModel.dart';
import 'package:isouq/profile/viewmodels/profile_viewmodel.dart';
import 'package:isouq/profile/views/setting_account_view.dart';

import 'package:provider/provider.dart';
import 'package:share/share.dart';

import 'order_list_view.dart';
import 'profile_list_item_view.dart';

class profile extends StatefulWidget {
  @override
  _profileState createState() => _profileState();
}

class _profileState extends State<profile> {
  GoogleAdMob _googleAdMob = GoogleAdMob();
  ProfileViewModel _viewModel;
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();



  bool _showAppbar = true; //this is to show app bar
  ScrollController _scrollBottomBarController = new ScrollController(); // set controller on scrolling
  bool isScrollingDown = false;
  bool _show = true;
  double bottomBarHeight ; // set bottom bar height

  @override
  void initState() {
    _viewModel = Provider.of<ProfileViewModel>(context,listen: false);
    _viewModel.getProfile();
    _initiateUiEvents(context);

    super.initState();
    appBarScroll();

  }

  void showBottomBar() {
    setState(() {
      _show = true;
    });
  }

  void hideBottomBar() {
    setState(() {
      _show = false;
    });
  }

  void appBarScroll() async {
    _scrollBottomBarController.addListener(() {
      if (_scrollBottomBarController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (!isScrollingDown) {
          isScrollingDown = true;
          _showAppbar = false;
          hideBottomBar();
        }
      }
      if (_scrollBottomBarController.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (isScrollingDown) {
          isScrollingDown = false;
          _showAppbar = true;
          showBottomBar();
        }
      }
    });
  }



  _initiateUiEvents(BuildContext context)
  {
    _viewModel.eventsStreamController.stream.listen((event) {
      if (event == UiEvents.navigateToLogin)
        _navigateToLogin();
    });
  }

  _navigateToLogin()
  {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (BuildContext context) => new ChooseLogin()));
  }

  _showLogoutAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Logout"),
      onPressed: () {
        _viewModel.logout();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Logout"),
      content: Text("Would you like to Logout from your Account ?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  void dispose() {
    _scrollBottomBarController.removeListener(() {});
    super.dispose();
  }

//  _favoriteItem() =>
//  StreamBuilder<List<ItemModel>>(
//    stream: _viewModel.favoriteListController.stream,
//    builder: (BuildContext context, AsyncSnapshot snapshott) {
//      if (snapshott.hasData) {
//        _viewModel.favoriteList = snapshott.data;
//        return GridListScreen(
//            snapshott.data, 'My Favorite');
//      } else {
//        return SizedBox();
//      }
//    },
//  );




  @override
  Widget build(BuildContext context) {

    return StreamBuilder<ProfileModel>(
      stream: _viewModel.profileStreamController.stream,
      builder:
          (BuildContext context, AsyncSnapshot<ProfileModel> profileModel) {
        if (!profileModel.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return SingleChildScrollView(
            key: _key,
            child: Container(
                color: Colors.white,
                child: Stack(
                  children: <Widget>[
                    /// Setting Header Banner
                    Container(
                      height: 240.0,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(
                                  "assets/img/headerProfile.png"),
                              fit: BoxFit.cover)),
                    ),

                    /// Calling _profile variable
                    Padding(
                      padding: EdgeInsets.only(
                        top: 185.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Container(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                height: 100.0,
                                width: 100.0,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.white, width: 2.5),
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: (profileModel.data.avatar ==
                                            null ||
                                            profileModel
                                                .data.avatar.isEmpty)
                                            ? AssetImage(
                                            "assets/img/person-imag.jpg")
                                            : NetworkImage(
                                            profileModel.data.avatar))),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: Text(
                                  profileModel.data.name == null
                                      ? 'name'
                                      : profileModel.data.name,
                                  style: txtName(),
                                ),
                              ),
                            ],
                          ),
                          Container(),
                        ],
                      ),
                    ),
                    Padding( // play_points.png
                      padding: const EdgeInsets.only(top: 360.0),
                      child: Column(
                        /// Setting Category List
                        children: <Widget>[
                          /// Call ProfileListItemView class
                          ProfileListItemView(
                            txt: tr('myOrderList'),
                            padding: 35.0,
                            image: "assets/icon/truck.png",
                            tap: () {
                              Navigator.of(context).push(PageRouteBuilder(
                                  pageBuilder: (_, __, ___) =>
                                      OrderList(profileModel.data.id)));
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 20.0, left: 85.0, right: 30.0),
                            child: Divider(
                              color: Colors.black12,
                              height: 2.0,
                            ),
                          ),
                          ProfileListItemView(
                            txt: tr('favorite'),
                            padding: 35.0,
                            image: "assets/icon/fav_list.png",
                            tap: () {
                              Navigator.of(context).push(PageRouteBuilder(
                                  pageBuilder: (_, __, ___) =>
                                      FavouriteTopRatedGridListScreen(
                                          _viewModel.favoriteList, tr('favorite'),true,)));
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 20.0, left: 85.0, right: 30.0),
                            child: Divider(
                              color: Colors.black12,
                              height: 2.0,
                            ),
                          ),
                          ProfileListItemView(
                            txt: tr('settingAccount'),
                            padding: 30.0,
                            image: "assets/icon/setting.png",
                            tap: () {
                              Navigator.of(context).push(PageRouteBuilder(
                                  pageBuilder: (_, __, ___) =>
                                  new settingAcount(
                                      profileModel.data)));
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 20.0, left: 85.0, right: 30.0),
                            child: Divider(
                              color: Colors.black12,
                              height: 2.0,
                            ),
                          ),
                          ProfileListItemView(
                            txt:
                            tr('language'),
                            padding: 30.0,
                            image: "assets/icon/language.png",
                            tap: () {
                              Navigator.of(context).push(PageRouteBuilder(
                                  pageBuilder: (_, __, ___) =>
                                  new languageSetting()));
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 20.0, left: 85.0, right: 30.0),
                            child: Divider(
                              color: Colors.black12,
                              height: 2.0,
                            ),
                          ),
                          ProfileListItemView(
                            padding: 38.0,
                            txt:tr('supportUs'),
                            image: "assets/icon/handphone.png",
                            tap: () {
                              _googleAdMob.loadRewardedVideoAd();
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 20.0, left: 85.0, right: 30.0),
                            child: Divider(
                              color: Colors.black12,
                              height: 2.0,
                            ),
                          ),
                          ProfileListItemView(
                            padding: 38.0,
                            txt: tr('invite_friend'),
                            image: "assets/icon/share.png",
                            tap: () {
                              _shareApp();
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 20.0, left: 85.0, right: 30.0),
                            child: Divider(
                              color: Colors.black12,
                              height: 2.0,
                            ),
                          ),
                          ProfileListItemView(
                            padding: 38.0,
                            txt: tr('aboutApps'),
                            image: "assets/icon/aboutapp.png",
                            tap: () {
                              Navigator.of(context).push(PageRouteBuilder(
                                  pageBuilder: (_, __, ___) =>
                                  new AboutApps()));
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 20.0, left: 85.0, right: 30.0),
                            child: Divider(
                              color: Colors.black12,
                              height: 2.0,
                            ),
                          ),
                          ProfileListItemView(
                            padding: 38.0,
                            txt: tr('logout'),
                            image: "assets/icon/logout.png",
                            tap: () {
                              _showLogoutAlertDialog(context);
                            },
                          ),
                          Padding(padding: EdgeInsets.only(bottom: 20.0)),
                        ],
                      ),
                    ),
                  ],
                )),
          );
        }
      },
    );
  }

  void _shareApp() {
    //todo: put app stores real links
    bool isIOS = Theme.of(context).platform == TargetPlatform.iOS;
    var iosUrl = "ios link god willing & tell the reciever about sender id";
    var androidUrl = "android link god willing & tell the reciever about sender id";

    var appLink = isIOS ? iosUrl : androidUrl;

    final RenderBox box = context.findRenderObject();
    Share.share(appLink,
        subject: tr('share_app'),
        sharePositionOrigin:
        box.localToGlobal(Offset.zero) &
        box.size);
  }

}
