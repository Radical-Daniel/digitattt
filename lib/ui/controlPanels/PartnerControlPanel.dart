import 'package:flutter/material.dart';
import 'package:instachatty/constants.dart';
import 'package:instachatty/model/Deal.dart';
import 'package:instachatty/model/User.dart';
import 'package:instachatty/services/Helper.dart';
import 'package:line_icons/line_icons.dart';
import 'package:easy_popup/easy_popup.dart';
import 'package:instachatty/ui/post/home_post.dart';
import 'package:instachatty/ui/booking/booking.dart';
import 'package:instachatty/model/InvoiceModel.dart';
import 'package:instachatty/ui/invoice/InvoiceCustomerCard.dart';
import 'package:instachatty/services/FirebaseHelper.dart';
import 'package:instachatty/model/BookingRequest.dart';
import 'package:instachatty/ui/booking/bookingRequestCard.dart';
import 'package:instachatty/model/notifications.dart';
import 'package:instachatty/model/Business.dart';
import 'package:instachatty/ui/payment/paymentPartner.dart';
import 'package:instachatty/ui/invoice/InvoicePartnerCard.dart';
import 'package:instachatty/ui/booking/booking.dart';

Color color1 = Color(COLOR_PRIMARY);
Color color2 = Color(COLOR_PRIMARY_DARK);

void isShowingNotificationNum() {
  Notifications.notifications['count'] > 0
      ? Notifications.notifications['visible'] = true
      : Notifications.notifications['visible'] = false;
}

void notificationCounter() {
  Notifications.notifications['count']++;
}

void resetNotifications() {
  Notifications.notifications['count'] = 0;
}

class PartnerControlPanel extends StatefulWidget {
  final User user;
  final Business business;
  PartnerControlPanel({@required this.user, @required this.business});

  @override
  _PartnerControlPanelState createState() =>
      _PartnerControlPanelState(user, business);
}

class _PartnerControlPanelState extends State<PartnerControlPanel> {
  final User user;
  final Business business;

  _PartnerControlPanelState(this.user, this.business);

  final fireStoreUtils = FireStoreUtils();
  Stream<List<Deal>> _dealRequestsStream;

  @override
  void initState() {
    super.initState();
    setupStream();
  }

  setupStream() {
    _dealRequestsStream = fireStoreUtils
        .getDealRequestsReceived(business.businessID)
        .asBroadcastStream();
    _dealRequestsStream.listen((dealModel) {
      if (mounted) {
        setState(() {
          isShowingNotificationNum();
          notificationCounter();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      Notifications.notifications['count'] = 0;
      isShowingNotificationNum();
    });
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Container(
        width: width,
        height: height,
        child: Stack(
          children: <Widget>[
            Container(
              width: width,
              height: height * .30,
              decoration: BoxDecoration(
                color: Color(COLOR_PRIMARY),
              ),
            ),
            buildHeader(width, height),
            buildHeaderData(height, width),
            buildHeaderInfoCard(height, width),
            buildNotificationPanel(width, height),
          ],
        ),
      ),
    );
  }

  Widget buildHeader(double width, double height) {
    return Positioned(
      top: 20,
      child: Container(
        width: width,
        height: height * .30,
        child: Column(
          children: <Widget>[
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 2.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Stack(
                    children: <Widget>[
                      Icon(
                        Icons.notifications_none,
                        color: Colors.white,
                      ),
                      Visibility(
                        visible: Notifications.notifications['visible'],
                        child: Positioned(
                          top: 0,
                          right: 2,
                          child: Container(
                            height: 13,
                            width: 13,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.red,
                            ),
                            child: Text(
                              Notifications.notifications['count'].toString(),
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildHeaderData(double height, double width) {
    return Positioned(
      top: (height * .20) / 2 - 40,
      width: width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          displayCircleImage(business.businessLogoURL, 100.0, false),
          SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                business.businessName,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildHeaderInfoCard(double height, double width) {
    return Positioned(
      top: height * .30 - 25,
      width: width,
      child: Container(
        alignment: Alignment.center,
        child: Container(
          height: 50,
          width: width * .65,
          child: FlatButton(
            onPressed: () {
              EasyPopup.show(context, DropDownMenu());
            },
            child: Material(
              elevation: 3,
              borderRadius: BorderRadius.circular(30),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        "CREATE POST",
                        style: TextStyle(
                          color: Color(0xff053150),
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                        textAlign: TextAlign.end,
                      ),
                    ],
                  ),
                  Icon(
                    Icons.add_circle,
                    size: 35,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildBottomBar(double width) {
    return Positioned(
      bottom: 0,
      width: width,
      child: Container(
        height: 55,
        width: width,
        color: Colors.white,
        child: Material(
          elevation: 5,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                width: width / 3,
                child: Icon(
                  Icons.account_circle,
                  size: 35,
                  color: Color(0xff065967).withOpacity(0.7),
                ),
              ),
              Container(width: width / 3),
              Container(
                width: width / 3,
                child: Icon(
                  Icons.assessment,
                  size: 35,
                  color: Color(0xff065967).withOpacity(0.7),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildFloatingButton(double width, double height) {
    return Positioned(
      top: height - 85,
      width: width,
      child: Container(
        height: 70,
        width: 70,
        child: RawMaterialButton(
          shape: CircleBorder(),
          fillColor: Color(0xff1a9bb1),
          elevation: 4,
          onPressed: () {},
          child: Icon(
            Icons.menu,
            size: 35,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget buildNotificationPanel(double width, double height) {
    return Positioned(
      width: width,
      height: height * .60 - 40,
      top: height * 0.30 + 34,
      child: Padding(
        padding: const EdgeInsets.only(right: 16, left: 16, top: 10),
        child: StreamBuilder(
            stream: _dealRequestsStream,
            initialData: [],
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      if (snapshot.hasData) {
                        print(snapshot.data[index].enquiryHandled.toString());
                        if (snapshot.data[index].bookingConfirmed) {
                          return AppointmentPartnerCard(
                            deal: snapshot.data[index],
                          );
                        } else if (snapshot.data[index].paid) {
                          return PaymentPartnerCard(deal: snapshot.data[index]);
                        } else if (snapshot.data[index].enquiryHandled) {
                          return InvoicePartnerCard(
                            deal: snapshot.data[index],
                          );
                        } else {
                          return user.isPartner
                              ? BookingRequestCard(
                                  deal: snapshot.data[index],
                                  user: user,
                                  business: business,
                                )
                              : BookingRequestCard(
                                  deal: snapshot.data[index],
                                  user: user,
                                );
                        }
                      } else {
                        return Container(
                          child: Text("No requests yet"),
                        );
                      }
                    });
              }
            }),
      ),
    );
  }

  Widget buildBodyCardTitle({String title}) {
    return Container(
      padding: const EdgeInsets.all(15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
              color: Color(0xff06866C),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
