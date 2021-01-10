import 'package:flutter/material.dart';
import 'package:instachatty/constants.dart';
import 'package:instachatty/model/User.dart';
import 'package:instachatty/services/Helper.dart';
import 'package:line_icons/line_icons.dart';
import 'package:easy_popup/easy_popup.dart';
import 'package:instachatty/ui/post/home_post.dart';
import 'package:instachatty/ui/booking/booking.dart';
import 'package:instachatty/model/InvoiceModel.dart';
import 'package:instachatty/ui/invoice/Invoice.dart';

Color color1 = Color(COLOR_PRIMARY);
Color color2 = Color(COLOR_PRIMARY_DARK);

class CustomerControlPanel extends StatefulWidget {
  final User user;
  CustomerControlPanel({@required this.user});

  @override
  _CustomerControlPanelState createState() => _CustomerControlPanelState(user);
}

class _CustomerControlPanelState extends State<CustomerControlPanel> {
  final User user;
  _CustomerControlPanelState(this.user);

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
                      Positioned(
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
                            "5",
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.white,
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
          Container(
            height: 95,
            width: 95,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: new Border.all(color: Color(COLOR_PRIMARY), width: 3),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: new NetworkImage(user.profilePictureURL),
                )),
          ),
          SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                user.fullName(),
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
                  children: <Widget>[
                    buildBodyCardTitle(title: "Your Bookings"),
                    Divider(
                      height: 3,
                      color: Colors.black87,
                    ),
                    Booking(
                      invoice: InvoiceModel(
                        customerName: user.fullName(),
                        completed: false,
                        customerUrl: user.profilePictureURL,
                        invoiceId: 'fffa',
                        status: PaymentStatus.paid,
                        sellerName: 'Jane Doe',
                        sellerId: 'qqqq',
                        charge: 30.0,
                      ),
                      appointmentTime: DateTime.now(),
                    ),
                    Divider(
                      height: 3,
                      color: Colors.black87,
                    ),
                    Booking(
                      invoice: InvoiceModel(
                        customerName: user.fullName(),
                        sellerName: 'Dr. Melissa Avon',
                        customerUrl: user.profilePictureURL,
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
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    buildBodyCardTitle(title: "Invoices"),
                    Divider(
                      height: 2,
                      color: Colors.black87,
                    ),
                    InvoiceCard(
                      details: InvoiceModel(
                        customerId: "cccc",
                        customerName: user.fullName(),
                        customerUrl: user.profilePictureURL,
                        charge: 100.00,
                        completed: false,
                        type: PaymentType.Electronic,
                        sellerName: "Code Grease",
                        sellerId: "gggg",
                        status: PaymentStatus.paid,
                        sellerUrl: user.profilePictureURL,
                      ),
                    )
                    // ListTile(
                    //   contentPadding: const EdgeInsets.only(
                    //     left: 10,
                    //     top: 10,
                    //     bottom: 10,
                    //   ),
                    //   leading: Card(
                    //     elevation: 2,
                    //     child: Container(
                    //       height: 70,
                    //       width: 60,
                    //       child: Column(
                    //         mainAxisAlignment: MainAxisAlignment.center,
                    //         children: <Widget>[
                    //           Text(
                    //             DateTime.now().month.toString(),
                    //             style: TextStyle(
                    //               fontWeight: FontWeight.bold,
                    //               fontSize: 14,
                    //             ),
                    //           ),
                    //           Text(
                    //             "21",
                    //             style: TextStyle(
                    //               fontWeight: FontWeight.bold,
                    //               fontSize: 18,
                    //             ),
                    //           ),
                    //         ],
                    //       ),
                    //     ),
                    //   ),
                    //   title: Column(
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     mainAxisAlignment: MainAxisAlignment.start,
                    //     children: <Widget>[
                    //       Text(
                    //         "Invoice 213",
                    //         style: TextStyle(fontWeight: FontWeight.bold),
                    //       ),
                    //       Text(
                    //         "This month fate fee",
                    //         style: TextStyle(
                    //           fontSize: 14,
                    //           color: Colors.grey,
                    //         ),
                    //       ),
                    //       Text(
                    //         "PENDING",
                    //         style: TextStyle(
                    //           color: Colors.red,
                    //           fontSize: 10,
                    //           fontWeight: FontWeight.bold,
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    //   trailing: Container(
                    //     height: 70,
                    //     width: 80,
                    //     padding: const EdgeInsets.only(right: 5),
                    //     child: Column(
                    //       mainAxisAlignment: MainAxisAlignment.center,
                    //       crossAxisAlignment: CrossAxisAlignment.center,
                    //       children: <Widget>[
                    //         Text(
                    //           "\$1200",
                    //           style: TextStyle(
                    //             fontWeight: FontWeight.bold,
                    //             fontSize: 18,
                    //           ),
                    //         ),
                    //         SizedBox(height: 2),
                    //         Container(
                    //           alignment: Alignment.center,
                    //           height: 30,
                    //           width: 80,
                    //           decoration: BoxDecoration(
                    //             borderRadius: BorderRadius.circular(20),
                    //             color: Color(0xff1abcaa),
                    //           ),
                    //           child: Text(
                    //             "PAY NOW",
                    //             style: TextStyle(
                    //               color: Colors.white,
                    //               fontSize: 12,
                    //               fontWeight: FontWeight.bold,
                    //             ),
                    //           ),
                    //         )
                    //       ],
                    //     ),
                    //   ),
                    // ),
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
        onTap: () {
          showModalBottomSheet(
              elevation: 20.0,
              context: context,
              builder: (BuildContext context) {
                return Container(
                  height: 500.0,
                  color: Color(COLOR_PRIMARY),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 10.0,
                      ),
                      Center(
                        child: displayCircleImage(
                            user.profilePictureURL, 105, false),
                      ),
                      Text(
                        user.fullName(),
                        style: TextStyle(
                          fontSize: 19.0,
                          color: Colors.white,
                          letterSpacing: 1.0,
                        ),
                      ),
                      Divider(),
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          color: Colors.white,
                          child: Column(
                            children: [
                              SizedBox(
                                height: 20.0,
                              ),
                              Text(
                                "Bookings",
                                style: TextStyle(
                                  fontSize: 19.0,
                                  color: Color(COLOR_PRIMARY),
                                ),
                              ),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Card(
                                      child: Material(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                        color: Color(COLOR_PRIMARY),
                                        child: SizedBox(
                                          height: 100.0,
                                          width: 160.0,
                                          child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "Tuesday",
                                                  style: TextStyle(
                                                    fontSize: 20.0,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                Text(
                                                  "Regular Checkup",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      "Paid",
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                    IconButton(
                                                      icon: Icon(
                                                        LineIcons.money,
                                                        color: Colors.white,
                                                      ),
                                                      onPressed: () {},
                                                    ),
                                                  ],
                                                )
                                              ]),
                                        ),
                                      ),
                                    ),
                                    Card(
                                      child: Material(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                        color: Color(COLOR_PRIMARY),
                                        child: SizedBox(
                                          height: 100.0,
                                          width: 160.0,
                                          child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "Wednesday",
                                                  style: TextStyle(
                                                    fontSize: 20.0,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                Text(
                                                  "Consultation",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      "Paid",
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                    IconButton(
                                                      icon: Icon(
                                                        LineIcons.money,
                                                        color: Colors.white,
                                                      ),
                                                      onPressed: () {},
                                                    ),
                                                  ],
                                                )
                                              ]),
                                        ),
                                      ),
                                    ),
                                    Card(
                                      child: Material(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                        color: Color(COLOR_PRIMARY),
                                        child: SizedBox(
                                          height: 100.0,
                                          width: 160.0,
                                          child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "Friday",
                                                  style: TextStyle(
                                                    fontSize: 20.0,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                Text(
                                                  "Review",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      "Unpaid",
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                    IconButton(
                                                      icon: Icon(
                                                        LineIcons.money,
                                                        color: Colors.white,
                                                      ),
                                                      onPressed: () {},
                                                    ),
                                                  ],
                                                )
                                              ]),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              });
        },
      ),
    );
  }
}