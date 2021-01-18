import 'package:flutter/material.dart';
import 'package:instachatty/model/InvoiceModel.dart';
import 'package:instachatty/constants.dart';
import 'package:instachatty/services/Helper.dart';
import 'package:instachatty/model/Deal.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:uuid/uuid.dart';
import 'package:instachatty/services/FirebaseHelper.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:instachatty/ui/components/dealPopUp.dart';
import 'package:instachatty/ui/components/dealTile.dart';

class InvoiceCard extends StatefulWidget {
  InvoiceCard({@required this.deal, this.onPressed});
  final Deal deal;
  final Function onPressed;

  @override
  _InvoiceCardState createState() => _InvoiceCardState(deal, onPressed);
}

class _InvoiceCardState extends State<InvoiceCard> {
  _InvoiceCardState(this.deal, this.onPressed);
  final Deal deal;
  final Function onPressed;
  Uuid uuid = Uuid();
  final ImagePicker _imagePicker = ImagePicker();
  PickedFile image;
  bool isLoadingPic = false;
  bool doneLoadingPic = false;
  TextEditingController _detailsController = TextEditingController();
  TextEditingController _chargeController = TextEditingController();
  TextEditingController _messageController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _paymentOptionsController = TextEditingController();
  final fireStoreUtils = FireStoreUtils();
  String url = '';

  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    return Card(
      child: Material(
        color: Color(COLOR_PRIMARY),
        child: SizedBox(
          child: FlatButton(
            onPressed: () {
              showBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return bottomPopUp(media, context);
                  });
            },
            child: DealTile(deal: deal),
          ),
        ),
      ),
    );
  }

  _sendToServer() async {
    showProgress(context, 'Sending Payment details', false);
    deal.enquiryHandled = true;
    if (_detailsController.text.length > 0) {
      deal.partnerAdditionalDetails = _detailsController.text;
    }
    deal.paid = true;

    if (deal.customerInitiated) {
      try {
        await FireStoreUtils.updateCustomerCurrentSentDeal(deal);
        await FireStoreUtils.updateSellerCurrentReceivedDeal(deal);
      } catch (e) {
        print(e.toString());
      }
    } else {
      try {
        await FireStoreUtils.updateSellerCurrentSentDeal(deal);
        await FireStoreUtils.updateCustomerCurrentReceivedDeal(deal);
      } catch (e) {
        print(e.toString());
      }
    }
    Navigator.pop(context);
    _chargeController.clear();
    _paymentOptionsController.clear();
    _detailsController.clear();
    hideProgress();
    Navigator.pop(context);
  }

  _onCameraClick() {
    final action = CupertinoActionSheet(
      message: Text(
        "sendMedia",
        style: TextStyle(fontSize: 15.0),
      ).tr(),
      actions: <Widget>[
        CupertinoActionSheetAction(
          child: Text("chooseImageFromGallery").tr(),
          isDefaultAction: false,
          onPressed: () async {
            showProgress(context, 'Creating invoice', false);

            setState(() {
              isLoadingPic = true;
            });
            Navigator.pop(context);
            PickedFile imageGot =
                await _imagePicker.getImage(source: ImageSource.gallery);
            String detailURL = uuid.v4();
            if (imageGot != null) {
              url = await fireStoreUtils.uploadBusinessImageToFireStorage(
                  File(imageGot.path), detailURL);
              setState(() {
                image = imageGot;
                doneLoadingPic = true;
                isLoadingPic = false;
                hideProgress();
              });
            }
          },
        ),
        CupertinoActionSheetAction(
          child: Text("takeAPicture").tr(),
          isDestructiveAction: false,
          onPressed: () async {
            Navigator.pop(context);
            String detailURL = uuid.v4();

            PickedFile image =
                await _imagePicker.getImage(source: ImageSource.camera);
            if (image != null) {
              url = await fireStoreUtils.uploadBusinessImageToFireStorage(
                  File(image.path), detailURL);
              // _sendMessage('', url, '');
            }
          },
        ),
      ],
      cancelButton: CupertinoActionSheetAction(
        child: Text(
          "cancel",
        ).tr(),
        onPressed: () {
          image = null;
          Navigator.pop(context);
        },
      ),
    );
    showCupertinoModalPopup(context: context, builder: (context) => action);
  }

  Container bottomPopUp(Size media, BuildContext context) {
    return Container(
      height: media.height * 0.71,
      color: Color(COLOR_PRIMARY),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          RaisedButton(
            color: Color(COLOR_PRIMARY),
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.keyboard_arrow_down_sharp,
                  size: 40.0,
                  color: Colors.white,
                ),
              ],
            ),
          ),
          Text(
            deal.sellerName,
            style: TextStyle(
              fontSize: 19.0,
              color: Colors.white,
              letterSpacing: 1.0,
            ),
          ),

          // Divider(),
          Center(
            child:
                displayCircleImage(deal.sellerURL, 75, false, deal.sellerName),
          ),
          Column(
            children: [
              Text(
                deal.partnerAdditionalDetails,
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.w300),
              ),
            ],
          ),
          Divider(),
          Expanded(
            child: Container(
              width: double.infinity,
              color: Colors.white,
              child: Column(
                children: [
                  SizedBox(
                    height: 5.0,
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(children: [
                      Center(
                        child: SizedBox(
                          height: 180.0,
                          width: 190.0,
                          child: Image.network(deal.pictureDetailsURL),
                        ),
                      ),
                      RaisedButton(
                        onPressed: deal.paid
                            ? () {}
                            : () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return Dialog(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(40)),
                                        elevation: 16,
                                        child: Container(
                                          height: 200,
                                          width: 350,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                top: 40.0,
                                                left: 16,
                                                right: 16,
                                                bottom: 16),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.max,
                                              children: <Widget>[
                                                // Visibility(
                                                //   visible: doneLoadingPic,
                                                //   child: SizedBox(
                                                //     height: 100.0,
                                                //     child: isLoadingPic
                                                //         ? CircularProgressIndicator(
                                                //             valueColor:
                                                //                 AlwaysStoppedAnimation<
                                                //                         Color>(
                                                //                     Color(
                                                //                         COLOR_ACCENT)),
                                                //           )
                                                //         : SingleChildScrollView(
                                                //             child: Column(
                                                //               children: [
                                                //                 Image.file(
                                                //                   File(image.path),
                                                //                   fit: BoxFit.cover,
                                                //                 ),
                                                //               ],
                                                //             ),
                                                //           ),
                                                //   ),
                                                // ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 8.0),
                                                  child: Row(
                                                    children: <Widget>[
                                                      IconButton(
                                                        onPressed: () {
                                                          _onCameraClick();
                                                        },
                                                        icon: Icon(
                                                          Icons.camera_alt,
                                                          color: Color(
                                                              COLOR_PRIMARY),
                                                        ),
                                                      ),
                                                      Expanded(
                                                          child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left: 2.0,
                                                                      right: 2,
                                                                      top: 5.0),
                                                              child: Container(
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(2),
                                                                decoration:
                                                                    ShapeDecoration(
                                                                  shape: OutlineInputBorder(
                                                                      borderRadius: BorderRadius.all(
                                                                        Radius.circular(
                                                                            360),
                                                                      ),
                                                                      borderSide: BorderSide(style: BorderStyle.none)),
                                                                  color: isDarkMode(
                                                                          context)
                                                                      ? Colors.grey[
                                                                          700]
                                                                      : Colors
                                                                          .grey
                                                                          .shade200,
                                                                ),
                                                                child: Row(
                                                                  children: <
                                                                      Widget>[
                                                                    Expanded(
                                                                      child:
                                                                          TextField(
                                                                        onChanged:
                                                                            (s) {
                                                                          setState(
                                                                              () {});
                                                                        },
                                                                        onTap:
                                                                            () {
                                                                          setState(
                                                                              () {
                                                                            // currentRecordingState = RecordingState.HIDDEN;
                                                                          });
                                                                        },
                                                                        textAlignVertical:
                                                                            TextAlignVertical.center,
                                                                        controller:
                                                                            _detailsController,
                                                                        decoration:
                                                                            InputDecoration(
                                                                          isDense:
                                                                              true,
                                                                          contentPadding: EdgeInsets.symmetric(
                                                                              vertical: 8,
                                                                              horizontal: 8),
                                                                          hintText:
                                                                              'Payment Details',
                                                                          hintStyle:
                                                                              TextStyle(color: Colors.grey[400]),
                                                                          focusedBorder: OutlineInputBorder(
                                                                              borderRadius: BorderRadius.all(
                                                                                Radius.circular(360),
                                                                              ),
                                                                              borderSide: BorderSide(style: BorderStyle.none)),
                                                                          enabledBorder: OutlineInputBorder(
                                                                              borderRadius: BorderRadius.all(
                                                                                Radius.circular(360),
                                                                              ),
                                                                              borderSide: BorderSide(style: BorderStyle.none)),
                                                                        ),
                                                                        textCapitalization:
                                                                            TextCapitalization.sentences,
                                                                        maxLines:
                                                                            5,
                                                                        minLines:
                                                                            1,
                                                                        keyboardType:
                                                                            TextInputType.multiline,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ))),
                                                    ],
                                                  ),
                                                ),
                                                Spacer(),
                                                Row(
//                                          spacing: 30,
                                                  children: <Widget>[
                                                    FlatButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Text(
                                                          'cancel',
                                                          style: TextStyle(
                                                            fontSize: 18,
                                                          ),
                                                        ).tr()),
                                                    FlatButton(
                                                        onPressed: () async {
                                                          _detailsController
                                                                      .text
                                                                      .length >
                                                                  0
                                                              ? _sendToServer()
                                                              : print(
                                                                  "make second thing");
                                                          setState(() {
                                                            url = "";
                                                            _detailsController
                                                                .text = '';
                                                          });
                                                        },
                                                        child: Text('Submit',
                                                            style: TextStyle(
                                                                fontSize: 18,
                                                                color: Color(
                                                                    COLOR_PRIMARY)))),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    });
                              },
                        child: deal.paid ? Text("Paid") : Text("Pay"),
                      )
                    ]),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
