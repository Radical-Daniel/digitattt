import 'package:flutter/material.dart';
import 'package:instachatty/model/InvoiceModel.dart';
import 'package:instachatty/constants.dart';
import 'package:instachatty/services/Helper.dart';
import 'package:instachatty/model/Deal.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:uuid/uuid.dart';
import 'package:instachatty/services/FirebaseHelper.dart';

class InvoicePartnerCard extends StatefulWidget {
  InvoicePartnerCard({@required this.deal, this.onPressed});
  final Deal deal;
  final Function onPressed;

  @override
  _InvoicePartnerCardState createState() =>
      _InvoicePartnerCardState(deal, onPressed);
}

class _InvoicePartnerCardState extends State<InvoicePartnerCard> {
  _InvoicePartnerCardState(this.deal, this.onPressed);
  final Deal deal;
  final Function onPressed;
  Uuid uuid = Uuid();

  TextEditingController _detailsController = TextEditingController();
  TextEditingController _chargeController = TextEditingController();
  TextEditingController _paymentOptionsController = TextEditingController();
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
                            child:
                                displayCircleImage(deal.customerURL, 75, false),
                          ),
                          Column(
                            children: [
                              Text(
                                deal.customerAdditionalDetails,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w300),
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
                                  // Text(
                                  //   "Services",
                                  //   style: TextStyle(
                                  //     fontSize: 19.0,
                                  //     color: Color(
                                  //         COLOR_PRIMARY),
                                  //   ),
                                  // ),
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
                                          child: Image.network(
                                              deal.pictureDetailsURL),
                                        ),
                                      ),
                                      RaisedButton(
                                        onPressed: deal.enquiryHandled
                                            ? () {}
                                            : () {
                                                showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return Dialog(
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        40)),
                                                        elevation: 16,
                                                        child: Container(
                                                          height: 305,
                                                          width: 370,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 40.0,
                                                                    left: 16,
                                                                    right: 16,
                                                                    bottom: 16),
                                                            child: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              children: <
                                                                  Widget>[
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      top: 8.0),
                                                                  child: Row(
                                                                    children: <
                                                                        Widget>[
                                                                      Expanded(
                                                                          child: Padding(
                                                                              padding: const EdgeInsets.only(left: 2.0, right: 2, top: 5.0),
                                                                              child: Container(
                                                                                padding: EdgeInsets.all(2),
                                                                                decoration: ShapeDecoration(
                                                                                  shape: OutlineInputBorder(
                                                                                      borderRadius: BorderRadius.all(
                                                                                        Radius.circular(360),
                                                                                      ),
                                                                                      borderSide: BorderSide(style: BorderStyle.none)),
                                                                                  color: isDarkMode(context) ? Colors.grey[700] : Colors.grey.shade200,
                                                                                ),
                                                                                child: Row(
                                                                                  children: <Widget>[
                                                                                    Expanded(
                                                                                      child: TextField(
                                                                                        onChanged: (s) {
                                                                                          setState(() {});
                                                                                        },
                                                                                        onTap: () {
                                                                                          setState(() {
                                                                                            // currentRecordingState = RecordingState.HIDDEN;
                                                                                          });
                                                                                        },
                                                                                        textAlignVertical: TextAlignVertical.center,
                                                                                        controller: _chargeController,
                                                                                        decoration: InputDecoration(
                                                                                          isDense: true,
                                                                                          contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                                                                                          hintText: 'Amount',
                                                                                          hintStyle: TextStyle(color: Colors.grey[400]),
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
                                                                                        textCapitalization: TextCapitalization.sentences,
                                                                                        maxLines: 1,
                                                                                        minLines: 1,
                                                                                        keyboardType: TextInputType.number,
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
                                                                  children: <
                                                                      Widget>[
                                                                    Expanded(
                                                                        child: Padding(
                                                                            padding: const EdgeInsets.only(left: 2.0, right: 2, top: 5.0),
                                                                            child: Container(
                                                                              padding: EdgeInsets.all(2),
                                                                              decoration: ShapeDecoration(
                                                                                shape: OutlineInputBorder(
                                                                                    borderRadius: BorderRadius.all(
                                                                                      Radius.circular(360),
                                                                                    ),
                                                                                    borderSide: BorderSide(style: BorderStyle.none)),
                                                                                color: isDarkMode(context) ? Colors.grey[700] : Colors.grey.shade200,
                                                                              ),
                                                                              child: Row(
                                                                                children: <Widget>[
                                                                                  Expanded(
                                                                                    child: TextField(
                                                                                      onChanged: (s) {
                                                                                        setState(() {});
                                                                                      },
                                                                                      onTap: () {
                                                                                        setState(() {
                                                                                          // currentRecordingState = RecordingState.HIDDEN;
                                                                                        });
                                                                                      },
                                                                                      textAlignVertical: TextAlignVertical.center,
                                                                                      controller: _detailsController,
                                                                                      decoration: InputDecoration(
                                                                                        isDense: true,
                                                                                        contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                                                                                        hintText: 'Invoice Details',
                                                                                        hintStyle: TextStyle(color: Colors.grey[400]),
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
                                                                                      textCapitalization: TextCapitalization.sentences,
                                                                                      maxLines: 3,
                                                                                      minLines: 1,
                                                                                      keyboardType: TextInputType.multiline,
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ))),
                                                                  ],
                                                                ),
                                                                Spacer(),
                                                                Row(
                                                                  children: <
                                                                      Widget>[
                                                                    Expanded(
                                                                        child: Padding(
                                                                            padding: const EdgeInsets.only(left: 2.0, right: 2, top: 5.0),
                                                                            child: Container(
                                                                              padding: EdgeInsets.all(2),
                                                                              decoration: ShapeDecoration(
                                                                                shape: OutlineInputBorder(
                                                                                    borderRadius: BorderRadius.all(
                                                                                      Radius.circular(360),
                                                                                    ),
                                                                                    borderSide: BorderSide(style: BorderStyle.none)),
                                                                                color: isDarkMode(context) ? Colors.grey[700] : Colors.grey.shade200,
                                                                              ),
                                                                              child: Row(
                                                                                children: <Widget>[
                                                                                  Expanded(
                                                                                    child: TextField(
                                                                                      onChanged: (s) {
                                                                                        setState(() {});
                                                                                      },
                                                                                      onTap: () {
                                                                                        setState(() {
                                                                                          // currentRecordingState = RecordingState.HIDDEN;
                                                                                        });
                                                                                      },
                                                                                      textAlignVertical: TextAlignVertical.center,
                                                                                      controller: _paymentOptionsController,
                                                                                      decoration: InputDecoration(
                                                                                        isDense: true,
                                                                                        contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                                                                                        hintText: 'Payment Options',
                                                                                        hintStyle: TextStyle(color: Colors.grey[400]),
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
                                                                                      textCapitalization: TextCapitalization.sentences,
                                                                                      maxLines: 3,
                                                                                      minLines: 1,
                                                                                      keyboardType: TextInputType.multiline,
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ))),
                                                                  ],
                                                                ),
                                                                Spacer(),
                                                                Row(
//                                          spacing: 30,
                                                                  children: <
                                                                      Widget>[
                                                                    FlatButton(
                                                                        onPressed:
                                                                            () {
                                                                          _chargeController.text =
                                                                              '';
                                                                          _paymentOptionsController.text =
                                                                              '';
                                                                          _detailsController.text =
                                                                              '';
                                                                          Navigator.pop(
                                                                              context);
                                                                        },
                                                                        child:
                                                                            Text(
                                                                          'cancel',
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                18,
                                                                          ),
                                                                        ).tr()),
                                                                    FlatButton(
                                                                      onPressed:
                                                                          () async {
                                                                        if (_chargeController.text.length > 0 &&
                                                                            _paymentOptionsController.text.length >
                                                                                0 &&
                                                                            _detailsController.text.length >
                                                                                0) {
                                                                          _sendToServer();
                                                                        } else {
                                                                          print(
                                                                              "make second thing");
                                                                        }
                                                                        setState(
                                                                            () {});
                                                                      },
                                                                      child:
                                                                          Text(
                                                                        'Submit',
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              18,
                                                                          color:
                                                                              Color(COLOR_PRIMARY),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    });
                                              },
                                        child: deal.enquiryHandled
                                            ? Text("Invoice sent")
                                            : Text("Invoice"),
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
                  });
            },
            child: ListTile(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Invoice for ',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    deal.customerName,
                    style: TextStyle(color: Colors.white),
                  ),
                  Text(
                    'From ${deal.sellerName}',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              trailing: Card(
                color: Colors.green,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 6.0, vertical: 1.0),
                  child: Text(
                    '\$${deal.amount}',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              leading: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  displayCircleImage(deal.customerURL, 40.0, false),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _sendToServer() async {
    showProgress(context, 'Creating invoice', false);

    deal.enquiryHandled = true;
    deal.paymentType = _paymentOptionsController.text;
    deal.amount = double.parse(_chargeController.text);
    deal.partnerAdditionalDetails = _detailsController.text;

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
}
