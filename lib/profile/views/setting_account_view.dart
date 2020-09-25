import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:isouq/Firebase/firebase_methods.dart';
import 'package:isouq/Helpers/app_tools.dart';
import 'package:isouq/common/text_styles/text_styles.dart';
import 'package:isouq/common/ui_events/ui_events.dart';
import 'package:isouq/common/widgets/gradient_app_bar.dart';
import 'package:isouq/profile/models/profileModel.dart';
import 'package:isouq/login/views/ChooseLoginOrSignup.dart';
import 'package:isouq/profile/viewmodels/profile_viewmodel.dart';
import 'package:provider/provider.dart';


final _key = GlobalKey<ScaffoldState>();

class settingAcount extends StatefulWidget {
  ProfileModel profile;

  settingAcount(this.profile);

  @override
  _settingAcountState createState() => _settingAcountState();
}

class _settingAcountState extends State<settingAcount> {
  File _imageFile;
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();

  ProfileViewModel _viewModel;

  ProfileModel profile;

  @override
  void initState() {
    profile = widget.profile;
    _nameController.text = profile.name;
    _phoneController.text = profile.phone;
    _viewModel = Provider.of<ProfileViewModel>(context,listen: false);
    _initiateUiEvents(context);

    super.initState();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  _initiateUiEvents(BuildContext context)
  {
    _viewModel.eventsStreamController.stream.listen((event) {
      if (event == UiEvents.loading)
        displayProgressDialog(context);
      else if (event == UiEvents.completed)
        closeProgressDialog(context);
      else if (event == UiEvents.showMessage)
        _showMessageProfileUpdated();
//      else if (event == UiEvents.navigateToLogin)
//        _navigateToLogin();
    });
  }

  _getImageFromGallery() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _imageFile = image;
    });
  }


  _showMessageProfileUpdated()
  {
    _key.currentState
        .showSnackBar(SnackBar(content: Text("profile update")));
  }



  _showErrorMessage(String _errorMessageEvent)
  {
    _key.currentState.showSnackBar(
        SnackBar(content: Text(_errorMessageEvent)));
  }





  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: _key,
      appBar: gradientAppBar(tr('settingAccount')),

      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              InkWell(
                onTap: () {
                  _getImageFromGallery();
                },
                child: Container(
                  height: 100.0,
                  width: 100.0,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 2.5),
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: (_imageFile != null)
                              ? FileImage(_imageFile)
                              : (profile.avatar == null ||
                              profile.avatar.isEmpty ||
                              profile.avatar == '')
                              ? AssetImage("assets/img/person-imag.jpg")
                              : NetworkImage(profile.avatar))),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                    controller: _nameController,
                    keyboardType: TextInputType.emailAddress,
                    maxLines: 1,
                    decoration: InputDecoration(
                        labelText: "Name",
                        labelStyle: TextStyle(color: Colors.black),
                        fillColor: Theme.of(context).accentColor,
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                          BorderSide(width: 5.0, color: Colors.black38),
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.black38,
                              width: 5,
                            ),
                            borderRadius: BorderRadius.circular(10)))),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.number,
                    maxLines: 1,
                    decoration: InputDecoration(
                        labelText: "Phone",
                        labelStyle: TextStyle(color: Colors.black),
                        fillColor: Theme.of(context).accentColor,
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                          BorderSide(width: 5.0, color: Colors.black38),
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.black38,
                              width: 5,
                            ),
                            borderRadius: BorderRadius.circular(10)))),
              ),
              FlatButton(
                shape: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide:
                    BorderSide(color: Theme.of(context).accentColor)),
                color: Colors.white,
                child: Text("Update Profile"),
                onPressed: () async {
                  FocusScope.of(context).requestFocus(FocusNode());
                  if (_viewModel.isValidSignUpdateProfile(_nameController.value.text,
                      _phoneController.value.text)) {
                    await _viewModel.updateProfile(_imageFile,_phoneController.value.text,_nameController.value.text);
                  } else {
                    _showErrorMessage(_viewModel.errorMessageEvent);
                  }
                },
              ),
              SizedBox(
                height: 20,
              ),
//              Padding(
//                padding: const EdgeInsets.only(top: 5.0),
//                child: Container(
//                  height: 50.0,
//                  width: 1000.0,
//                  color: Colors.white,
//                  child: Padding(
//                    padding: const EdgeInsets.only(
//                        top: 13.0, left: 20.0, bottom: 15.0),
//                    child: InkWell(
//                      onTap: () {
//                        _showLogoutAlertDialog(context);
//                      },
//                      child: Text(
//                        tr('logout'),
//                        style: txtCustomHead(),
//                      ),
//                    ),
//                  ),
//                ),
//              )
            ],
          ),
        ),
      ),
    );
  }
}