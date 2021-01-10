import 'package:flutter/material.dart';
import 'package:instachatty/constants.dart';
import 'package:instachatty/model/User.dart';

Color color1 = Color(COLOR_PRIMARY);
Color color2 = Color(COLOR_PRIMARY_DARK);

class BusinessControlPanel extends StatefulWidget {
  final User user;
  BusinessControlPanel({@required this.user});

  @override
  _BusinessControlPanelState createState() => _BusinessControlPanelState(user);
}

class _BusinessControlPanelState extends State<BusinessControlPanel> {
  final User user;
  _BusinessControlPanelState(this.user);

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
              print("made new post");
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
                    buildBodyCardTitle(title: "Your Posts"),
                    Divider(
                      height: 3,
                      color: Colors.black87,
                    ),
                    buildNotificationItem(
                        icon: Icons.notifications_none,
                        views: 200,
                        likes: 60,
                        description: "Why we love Harare",
                        postType: "repost"),
                    Divider(
                      height: 3,
                      color: Colors.black87,
                    ),
                    buildNotificationItem(
                        icon: Icons.notifications_none,
                        views: 1020,
                        likes: 231,
                        description: "Wish you were here?",
                        postType: "targeted post"),
                    Divider(
                      height: 3,
                      color: Colors.black87,
                    ),
                    buildNotificationItem(
                        icon: Icons.notifications_none,
                        views: 100,
                        likes: 30,
                        description: "Once in a lifetime.",
                        postType: "repost"),
                  ],
                ),
              ),
              SizedBox(height: 15),
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
          Text(
            "View All",
            style: TextStyle(color: Colors.grey),
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
