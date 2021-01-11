import 'dart:io';
import 'package:instachatty/ui/home/HomeScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instachatty/constants.dart';
import 'package:instachatty/ui/controlPanels/BusinessControlPanel.dart';
import 'package:instachatty/main.dart';
import 'package:instachatty/model/User.dart';
import 'package:instachatty/services/FirebaseHelper.dart';
import 'package:instachatty/services/Helper.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:uuid/uuid.dart';
import 'package:instachatty/model/Business.dart';
import 'package:instachatty/model/AddressModel.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:instachatty/model/BookingRequest.dart';

File _image;
Map<String, dynamic> _filterList = {
  'customer': false,
  'doctor': false,
  'pharmacist': false,
  'laboratory': false,
  'retail': false,
  'ambulance': false,
  'radiologist': false,
  'hospital': false,
  'clinic': false,
  'fitness': false,
  'hospitality': false,
  'insurance': false,
  'travel': false,
  'wellness': false,
  'student': false,
  'education': false
};

class BookingCreator extends StatefulWidget {
  final User user;
  final Business business;
  BookingCreator({@required this.user, @required this.business});
  @override
  State createState() => _SignUpState(user, business);
}

class _SignUpState extends State<BookingCreator> {
  final User user;
  final Business business;
  _SignUpState(this.user, this.business);
  final ImagePicker _imagePicker = ImagePicker();

  GlobalKey<FormState> _key = new GlobalKey();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back_outlined,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
        backgroundColor: Color(COLOR_PRIMARY),
        title: Text(
          "Booking Request",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(
            color: isDarkMode(context) ? Colors.white : Colors.black),
      ),
      body: SingleChildScrollView(
        child: new Container(
          margin: new EdgeInsets.only(left: 16.0, right: 16, bottom: 16),
          child: new Form(
            key: _key,
            child: Container(),
          ),
        ),
      ),
    );
  }

  _sendToServer() async {
    showProgress(context, 'Creating request', false);
    try {
      BookingRequest bookingRequest = BookingRequest(
        customerId: user.userID,
        customerName: user.fullName(),
        customerUrl: user.profilePictureURL,
        sellerId: business.businessID,
        sellerName: business.businessName,
        handled: false,
      );
      await FireStoreUtils.firestore
          .collection(SENT_BOOKING_REQUESTS)
          .document(user.userID)
          .setData(bookingRequest.toJson());
      await FireStoreUtils.firestore
          .collection(RECEIVED_BOOKING_REQUESTS)
          .document(business.businessID)
          .setData(bookingRequest.toJson());

      hideProgress();
      pushAndRemoveUntil(
          context,
          HomeScreen(
            user: user,
            business: business,
          ),
          false);
    } catch (error) {
      print(user.fullName());
      print(error.toString());
      hideProgress();
      (error as PlatformException).code != 'ERROR_EMAIL_ALREADY_IN_USE'
          ? showAlertDialog(context, 'failed'.tr(), 'couldNotSignUp'.tr())
          : showAlertDialog(context, 'failed'.tr(), 'emailAlreadyInUse'.tr());
      print(error.toString());
    }
  }

  @override
  void dispose() {
    _image = null;
    super.dispose();
  }
}
