import 'package:flutter/material.dart';
import 'package:instachatty/constants.dart';
import 'package:instachatty/services/Helper.dart';
import 'package:instachatty/model/BookingRequest.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:uuid/uuid.dart';
import 'package:instachatty/model/InvoiceModel.dart';
import 'package:instachatty/services/FirebaseHelper.dart';
import 'package:instachatty/ui/controlPanels/PartnerControlPanel.dart';

class BookingRequestCard extends StatefulWidget {
  BookingRequestCard({
    @required this.bookingRequest,
  });
  final BookingRequest bookingRequest;

  @override
  _BookingRequestCardState createState() => _BookingRequestCardState(
        bookingRequest,
      );
}

class _BookingRequestCardState extends State<BookingRequestCard> {
  _BookingRequestCardState(
    this.bookingRequest,
  );
  final BookingRequest bookingRequest;
  TextEditingController _detailsController = TextEditingController();
  TextEditingController _chargeController = TextEditingController();
  TextEditingController _paymentOptionsController = TextEditingController();
  Uuid uuid = Uuid();

  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;

    return Card(
      child: Material(
        color: Color(COLOR_PRIMARY),
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
                          bookingRequest.customerName,
                          style: TextStyle(
                            fontSize: 19.0,
                            color: Colors.white,
                            letterSpacing: 1.0,
                          ),
                        ),

                        // Divider(),
                        Center(
                          child: displayCircleImage(
                              bookingRequest.sellerURL, 75, false),
                        ),
                        Column(
                          children: [
                            Text(
                              bookingRequest.details,
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
                                            bookingRequest.pictureDetailsURL),
                                      ),
                                    ),
                                    RaisedButton(
                                      onPressed: () {
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return Dialog(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            40)),
                                                elevation: 16,
                                                child: Container(
                                                  height: 305,
                                                  width: 370,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 40.0,
                                                            left: 16,
                                                            right: 16,
                                                            bottom: 16),
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: <Widget>[
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 8.0),
                                                          child: Row(
                                                            children: <Widget>[
                                                              Expanded(
                                                                  child:
                                                                      Padding(
                                                                          padding: const EdgeInsets.only(
                                                                              left: 2.0,
                                                                              right: 2,
                                                                              top: 5.0),
                                                                          child: Container(
                                                                            padding:
                                                                                EdgeInsets.all(2),
                                                                            decoration:
                                                                                ShapeDecoration(
                                                                              shape: OutlineInputBorder(
                                                                                  borderRadius: BorderRadius.all(
                                                                                    Radius.circular(360),
                                                                                  ),
                                                                                  borderSide: BorderSide(style: BorderStyle.none)),
                                                                              color: isDarkMode(context) ? Colors.grey[700] : Colors.grey.shade200,
                                                                            ),
                                                                            child:
                                                                                Row(
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
                                                                                      hintText: 'Charge',
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
                                                          children: <Widget>[
                                                            Expanded(
                                                                child: Padding(
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            2.0,
                                                                        right:
                                                                            2,
                                                                        top:
                                                                            5.0),
                                                                    child:
                                                                        Container(
                                                                      padding:
                                                                          EdgeInsets.all(
                                                                              2),
                                                                      decoration:
                                                                          ShapeDecoration(
                                                                        shape: OutlineInputBorder(
                                                                            borderRadius: BorderRadius.all(
                                                                              Radius.circular(360),
                                                                            ),
                                                                            borderSide: BorderSide(style: BorderStyle.none)),
                                                                        color: isDarkMode(context)
                                                                            ? Colors.grey[700]
                                                                            : Colors.grey.shade200,
                                                                      ),
                                                                      child:
                                                                          Row(
                                                                        children: <
                                                                            Widget>[
                                                                          Expanded(
                                                                            child:
                                                                                TextField(
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
                                                                                hintText: 'Additional Details',
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
                                                          children: <Widget>[
                                                            Expanded(
                                                                child: Padding(
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            2.0,
                                                                        right:
                                                                            2,
                                                                        top:
                                                                            5.0),
                                                                    child:
                                                                        Container(
                                                                      padding:
                                                                          EdgeInsets.all(
                                                                              2),
                                                                      decoration:
                                                                          ShapeDecoration(
                                                                        shape: OutlineInputBorder(
                                                                            borderRadius: BorderRadius.all(
                                                                              Radius.circular(360),
                                                                            ),
                                                                            borderSide: BorderSide(style: BorderStyle.none)),
                                                                        color: isDarkMode(context)
                                                                            ? Colors.grey[700]
                                                                            : Colors.grey.shade200,
                                                                      ),
                                                                      child:
                                                                          Row(
                                                                        children: <
                                                                            Widget>[
                                                                          Expanded(
                                                                            child:
                                                                                TextField(
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
                                                                                hintText: 'Accepted payment options',
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
                                                          children: <Widget>[
                                                            FlatButton(
                                                                onPressed: () {
                                                                  _chargeController
                                                                      .text = '';
                                                                  _paymentOptionsController
                                                                      .text = '';
                                                                  _detailsController
                                                                      .text = '';
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                child: Text(
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
                                                                    _paymentOptionsController
                                                                            .text
                                                                            .length >
                                                                        0 &&
                                                                    _detailsController
                                                                            .text
                                                                            .length >
                                                                        0) {
                                                                  _sendToServer();
                                                                  _chargeController
                                                                      .clear();
                                                                  _paymentOptionsController
                                                                      .clear();
                                                                  _detailsController
                                                                      .clear();
                                                                  Navigator.pop(
                                                                      context);
                                                                } else {
                                                                  print(
                                                                      "make second thing");
                                                                }
                                                                setState(() {});
                                                              },
                                                              child: Text(
                                                                'Submit',
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 18,
                                                                  color: Color(
                                                                      COLOR_PRIMARY),
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
                                      child: Text("Invoice"),
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
          child: SizedBox(
            child: ListTile(
              leading: bookingRequest.customerURL.length > 1
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        displayCircleImage(
                            bookingRequest.customerURL, 40.0, false),
                      ],
                    )
                  : null,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Booking request from',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        '${bookingRequest.customerName}',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        bookingRequest.details,
                        style: TextStyle(
                          color: Colors.white,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w200,
                        ),
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                      ),
                    ],
                  ),
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
    String invoiceID = uuid.v4();
    try {
      InvoiceModel invoice = InvoiceModel(
        customerID: bookingRequest.customerID,
        customerName: bookingRequest.customerName,
        customerURL: bookingRequest.customerURL,
        sellerID: bookingRequest.sellerID,
        sellerName: bookingRequest.sellerName,
        sellerURL: bookingRequest.sellerURL,
        completed: false,
        invoiceID: bookingRequest.requestID,
        type: _paymentOptionsController.text,
        charge: double.parse(_chargeController.text),
        status: false,
        additionalDetails: _detailsController.text,
      );
      await FireStoreUtils.firestore
          .collection(INVOICES)
          .document(bookingRequest.customerID)
          .collection(RECEIVED_INVOICES)
          .document(invoiceID)
          .setData(invoice.toJson());
      await FireStoreUtils.firestore
          .collection(INVOICES)
          .document(bookingRequest.sellerID)
          .collection(SENT_INVOICES)
          .document(invoiceID)
          .setData(invoice.toJson());

      hideProgress();
    } catch (error) {
      print(error.toString());
      hideProgress();
      print(error.toString());
    }
  }

  @override
  void dispose() {
    _detailsController.clear();
    _paymentOptionsController.clear();
    _chargeController.clear();
    super.dispose();
  }
}
