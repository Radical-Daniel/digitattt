import 'package:flutter/material.dart';
import 'package:instachatty/constants.dart';
import 'package:instachatty/model/User.dart';
import 'package:instachatty/ui/booking/booking.dart';
import 'package:instachatty/model/InvoiceModel.dart';
import 'package:instachatty/model/Business.dart';
import 'package:instachatty/ui/booking/bookingRequests.dart';
import 'package:instachatty/model/BookingRequest.dart';
import 'package:easy_popup/easy_popup.dart';
import 'package:instachatty/ui/post/home_post.dart';
import 'package:instachatty/ui/signUp/BusinessTeamRegister.dart';
import 'package:instachatty/model/InvoiceModel.dart';
import 'package:instachatty/model/BookingModel.dart';
import 'package:instachatty/services/FirebaseHelper.dart';
import 'package:instachatty/services/Helper.dart';

Color color1 = Color(COLOR_PRIMARY);
Color color2 = Color(COLOR_PRIMARY_DARK);

class PartnerControlPanel extends StatefulWidget {
  final Business business;
  final User user;
  PartnerControlPanel({@required this.user, this.business});

  @override
  _PartnerControlPanelState createState() =>
      _PartnerControlPanelState(user, business);
}

class _PartnerControlPanelState extends State<PartnerControlPanel> {
  final User user;
  final Business business;
  final FireStoreUtils _fireStoreUtils = FireStoreUtils();

  _PartnerControlPanelState(this.user, this.business);
  Stream<BookingRequest> bookingRequestStream;
  @override
  void initState() {
    super.initState();
  }

  // setupStream() {
  //   bookingRequestStream = _fireStoreUtils
  //       .getChatMessages(homeConversationModel)
  //       .asBroadcastStream();
  //   bookingRequestStream.listen((chatModel) {
  //     if (mounted) {
  //       homeConversationModel.members = chatModel.members;
  //       setState(() {});
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
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
                  // IconButton(
                  //   icon: Icon(
                  //     Icons.add_circle,
                  //     color: Colors.white,
                  //   ),
                  //   onPressed: () {
                  //     Navigator.push(
                  //         context,
                  //         MaterialPageRoute(
                  //           builder: (BuildContext context) =>
                  //               BusinessTeamScreen(
                  //             user: user,
                  //             business: business,
                  //           ),
                  //         ));
                  //   },
                  // ),
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.more_vert,
                      color: Colors.white,
                    ),
                    onPressed: () {},
                  ),
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
          SizedBox(height: 2),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                business.businessName,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 19,
                    letterSpacing: 1.0),
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
      height: height * .70 - 40,
      top: height * 0.30 + 34,
      child: Padding(
        padding: const EdgeInsets.only(right: 16, left: 16, top: 10),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Material(
                elevation: 1,
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    buildBodyCardTitle(title: "Bookings"),
                    Divider(
                      height: 2,
                      color: Colors.black87,
                    ),
                    Booking(
                      invoice: InvoiceModel(
                        invoiceId: "123wwww",
                        customerName: "James",
                        completed: false,
                        customerUrl:
                            'https://firebasestorage.googleapis.com/v0/b/digitat-80a24.appspot.com/o/images%2F25ac6600-f1c9-4b7f-ba70-7eb2750f6bef.png?alt=media&token=a006b3af-3269-4e16-a4e4-ad8279e94d42',
                        sellerName: "Daniel",
                        sellerUrl: user.profilePictureURL,
                      ),
                      appointmentTime: DateTime.now(),
                    ),
                    Booking(
                      invoice: InvoiceModel(
                        invoiceId: "123wwww",
                        customerName: "Mark",
                        completed: false,
                        customerUrl:
                            'https://firebasestorage.googleapis.com/v0/b/digitat-80a24.appspot.com/o/images%2Fc8befd09-542f-472d-a6d4-fb063c64962b.png?alt=media&token=d0b7d3be-641c-4fcf-b47a-e3450f5e75c4',
                        sellerName: "Daniel",
                        sellerUrl: user.profilePictureURL,
                      ),
                      appointmentTime: DateTime.now(),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15),
              Material(
                elevation: 1,
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    buildBodyCardTitle(title: "Booking requests"),
                    Divider(
                      height: 3,
                      color: Colors.black87,
                    ),
                    BookingRequestCard(
                      bookingRequest: BookingRequest(
                        customerName: "Jane Almond",
                        customerUrl:
                            'https://firebasestorage.googleapis.com/v0/b/digitat-80a24.appspot.com/o/images%2FOmEOdq5lNySXMHLmj146BGkOS4H2.png?alt=media&token=7c417a72-0b77-44b2-be9d-d086f3bb7d47',
                      ),
                    ),
                    BookingRequestCard(
                      bookingRequest: BookingRequest(
                        customerName: "Nathan Green",
                        customerUrl:
                            'https://firebasestorage.googleapis.com/v0/b/digitat-80a24.appspot.com/o/images%2FnP9LsJtV0NZIhLpsgrPGjnw7N6l1.png?alt=media&token=7619b239-8682-4f84-bb55-b5b1c4d35300',
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 50),
            ],
          ),
        ),
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

  Widget buildNotificationItem(
      {IconData icon,
      String postType,
      String description,
      int views,
      int likes}) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: ListTile(
        contentPadding: const EdgeInsets.only(left: 10),
        leading: Container(
          height: 60,
          width: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [color1, color2],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Icon(
            icon,
            size: 28,
            color: Colors.white70,
          ),
        ),
        title: Text(
          postType,
          style: TextStyle(color: Colors.grey, fontSize: 13),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              description,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "$views views $likes likes",
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ],
        ),
        trailing: Container(
          height: 40,
          width: 70,
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(
                width: 1,
                color: Colors.black26,
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 5),
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.timer,
                  color: Colors.grey,
                  size: 15,
                ),
                Text(
                  " 1 Day",
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                )
              ],
            ),
          ),
        ),
        onTap: () {},
      ),
    );
  }
}

// class BusinessBoarding extends StatefulWidget {
//   @override
//   State createState() {
//     return BusinessBoardingState();
//   }
// }
//
// class BusinessBoardingState extends State<BusinessBoarding> {
//   Future hasBusinessBoarding() async {}
//
//   @override
//   void initState() {
//     super.initState();
//     // hasFinishedOnBoarding();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold();
//   }
// }
