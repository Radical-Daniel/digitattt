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

class AppointmentCustomerCard extends StatefulWidget {
  AppointmentCustomerCard({@required this.deal, this.onPressed});
  final Deal deal;
  final Function onPressed;

  @override
  _AppointmentCustomerCardState createState() =>
      _AppointmentCustomerCardState(deal, onPressed);
}

class _AppointmentCustomerCardState extends State<AppointmentCustomerCard> {
  _AppointmentCustomerCardState(this.deal, this.onPressed);
  final Deal deal;
  final Function onPressed;
  Uuid uuid = Uuid();
  DateTime pickedDate;
  TimeOfDay time;
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
  void initState() {
    pickedDate = DateTime.now();
    time = TimeOfDay.now();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    return Card(
      child: Material(
        color: Color(COLOR_PRIMARY),
        child: SizedBox(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: ListTile(
                    leading: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        displayCircleImage(
                            deal.sellerURL, 40.0, false, deal.sellerName),
                      ],
                    ),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Appointment Completed',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          "Leave a review for",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          '${deal.sellerName}',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                    onTap: () {
                      showBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return bottomPopUp(media, context);
                          });
                    },
                  ),
                ),
              ],
            ),
          ),
          // FlatButton(
          //   onPressed: () {
          //     showBottomSheet(
          //         context: context,
          //         builder: (BuildContext context) {
          //           return bottomPopUp(media, context);
          //         });
          //   },
          //   child: DealTile(deal: deal),
          // ),
        ),
      ),
    );
  }

  _pickDate() async {
    DateTime date = await showDatePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5),
      initialDate: pickedDate,
    );
    if (date != null)
      setState(() {
        pickedDate = date;
      });
  }

  _pickTime() async {
    TimeOfDay t = await showTimePicker(context: context, initialTime: time);
    if (t != null)
      setState(() {
        time = t;
      });
  }

  _sendToServer(context) async {
    showProgress(context, 'Sending Appointment details', false);
    deal.paid = true;
    deal.bookingConfirmed = true;
    deal.displayAppointmentTime =
        "${pickedDate.year}, ${pickedDate.month}, ${pickedDate.day} ${time.hour}:${time.minute}";
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
            deal.customerName,
            style: TextStyle(
              fontSize: 19.0,
              color: Colors.white,
              letterSpacing: 1.0,
            ),
          ),

          // Divider(),
          Center(
            child: displayCircleImage(
                deal.customerURL, 75, false, deal.customerName),
          ),
          Column(
            children: [
              Text(
                deal.customerAdditionalDetails,
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
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RaisedButton(
                          onPressed: () {},
                          child: Text("Review"),
                        ),
                        // deal.bookingConfirmed
                        //     ? Container()
                        //     : RaisedButton(
                        //         onPressed: _pickTime,
                        //         child: Text("Set Time"),
                        //       ),
//                         RaisedButton(
//                           onPressed: deal.bookingConfirmed
//                               ? () {}
//                               : () {
//                                   showDialog(
//                                       context: context,
//                                       builder: (context) {
//                                         return Dialog(
//                                           shape: RoundedRectangleBorder(
//                                               borderRadius:
//                                                   BorderRadius.circular(40)),
//                                           elevation: 16,
//                                           child: Container(
//                                             height: 200,
//                                             width: 350,
//                                             child: Padding(
//                                               padding: const EdgeInsets.only(
//                                                   top: 40.0,
//                                                   left: 16,
//                                                   right: 16,
//                                                   bottom: 16),
//                                               child: Column(
//                                                 mainAxisSize: MainAxisSize.max,
//                                                 children: <Widget>[
//                                                   // Visibility(
//                                                   //   visible: doneLoadingPic,
//                                                   //   child: SizedBox(
//                                                   //     height: 100.0,
//                                                   //     child: isLoadingPic
//                                                   //         ? CircularProgressIndicator(
//                                                   //             valueColor:
//                                                   //                 AlwaysStoppedAnimation<
//                                                   //                         Color>(
//                                                   //                     Color(
//                                                   //                         COLOR_ACCENT)),
//                                                   //           )
//                                                   //         : SingleChildScrollView(
//                                                   //             child: Column(
//                                                   //               children: [
//                                                   //                 Image.file(
//                                                   //                   File(image.path),
//                                                   //                   fit: BoxFit.cover,
//                                                   //                 ),
//                                                   //               ],
//                                                   //             ),
//                                                   //           ),
//                                                   //   ),
//                                                   // ),
//                                                   Padding(
//                                                     padding:
//                                                         const EdgeInsets.only(
//                                                             top: 8.0),
//                                                     child: Row(
//                                                       children: <Widget>[
//                                                         Expanded(
//                                                             child: Padding(
//                                                           padding:
//                                                               const EdgeInsets
//                                                                       .only(
//                                                                   left: 2.0,
//                                                                   right: 2,
//                                                                   top: 5.0),
//                                                           child: Container(
//                                                             padding:
//                                                                 EdgeInsets.all(
//                                                                     2),
//                                                             decoration:
//                                                                 ShapeDecoration(
//                                                               shape:
//                                                                   OutlineInputBorder(
//                                                                       borderRadius:
//                                                                           BorderRadius
//                                                                               .all(
//                                                                         Radius.circular(
//                                                                             360),
//                                                                       ),
//                                                                       borderSide:
//                                                                           BorderSide(
//                                                                               style: BorderStyle.none)),
//                                                             ),
//                                                             child: Text(
//                                                                 "Confirm availability",
//                                                                 style: TextStyle(
//                                                                     fontSize:
//                                                                         17.0)),
//                                                           ),
//                                                         )),
//                                                       ],
//                                                     ),
//                                                   ),
//                                                   Spacer(),
//                                                   Row(
// //                                          spacing: 30,
//                                                     children: <Widget>[
//                                                       FlatButton(
//                                                           onPressed: () {
//                                                             Navigator.pop(
//                                                                 context);
//                                                           },
//                                                           child: Text(
//                                                             'cancel',
//                                                             style: TextStyle(
//                                                               fontSize: 18,
//                                                             ),
//                                                           ).tr()),
//                                                       FlatButton(
//                                                           onPressed: () async {
//                                                             if (!deal
//                                                                 .bookingConfirmed) {
//                                                               _sendToServer(
//                                                                   context);
//                                                               setState(() {
//                                                                 url = "";
//                                                                 _detailsController
//                                                                     .text = '';
//                                                               });
//                                                             }
//                                                           },
//                                                           child: Text('Submit',
//                                                               style: TextStyle(
//                                                                   fontSize: 18,
//                                                                   color: Color(
//                                                                       COLOR_PRIMARY)))),
//                                                     ],
//                                                   )
//                                                 ],
//                                               ),
//                                             ),
//                                           ),
//                                         );
//                                       });
//                                 },
//                           child: deal.bookingConfirmed
//                               ? Text("Appointment set")
//                               : Text("Confirm Appointment"),
//                         )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        Center(
                          child: SizedBox(
                            height: 120.0,
                            width: 150.0,
                            child: Image.network(deal.pictureDetailsURL),
                          ),
                        ),
                      ],
                    ),
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
