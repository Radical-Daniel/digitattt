import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:instachatty/ui/chatTemplate/theme.bloc.dart';
import 'package:instachatty/ui/chatTemplate/themes.dart';
import 'package:instachatty/ui/home/ZoomableSlider.dart';
import 'package:instachatty/constants.dart';
import 'package:instachatty/model/User.dart';
import 'package:instachatty/services/FirebaseHelper.dart';
import 'package:instachatty/services/Helper.dart';
import 'package:line_icons/line_icons.dart';
import 'package:easy_popup/easy_popup.dart';
import 'package:instachatty/ui/post/home_post.dart';
import 'package:instachatty/ui/controlPanels/CustomerControlPanel.dart';
import 'package:instachatty/ui/signUp/BusinessSignUpScreen.dart';
import 'package:instachatty/ui/controlPanels/PartnerControlPanel.dart';
import 'package:instachatty/model/Business.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:instachatty/model/notifications.dart';

String img2 =
    "https://passivehouseplus.ie/media/k2/items/cache/fc5d9d8578a06f6d4c69c78df34d3f3a_XL.jpg?t=-62169984000";

class HealthHome extends StatefulWidget {
  HealthHome({@required this.user, this.business});
  final User user;
  final Business business;

  @override
  _HealthHomeState createState() => _HealthHomeState(user, business);
}

class _HealthHomeState extends State<HealthHome>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final User user;
  final Business business;
  FireStoreUtils _fireStoreUtils = FireStoreUtils();
  _HealthHomeState(this.user, this.business);
  AnimationController _controller;
  Animation<double> _heightAnimation;
  Animation<double> _iconSizeAnimation;

  @override
  void initState() {
    super.initState();
    themeBloc.changeTheme(Themes.smartNav);
    _controller = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _heightAnimation =
        new Tween<double>(begin: 0.0, end: 161.0).animate(new CurvedAnimation(
      curve: Curves.decelerate,
      parent: _controller,
    ));

    _iconSizeAnimation =
        new Tween<double>(begin: 10, end: 35).animate(new CurvedAnimation(
      curve: Curves.easeInOut,
      parent: _controller,
    ));

    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(COLOR_PRIMARY),
        title: Text(
          "digit@T",
          style: TextStyle(fontFamily: 'Bauhaus93'),
          textAlign: TextAlign.center,
        ),
        leading: Stack(
          children: [
            IconButton(
              icon: Icon(LineIcons.bell),
              onPressed: () {
                _scaffoldKey.currentState.openDrawer();
              },
            ),
            Positioned(
              top: 13,
              right: 24,
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
            )
          ],
        ),
        actions: [
          IconButton(
            icon:
                user.isPartner ? Icon(LineIcons.diamond) : Icon(LineIcons.lock),
            onPressed: () {
              _scaffoldKey.currentState.openEndDrawer();
            },
          )
        ],
      ),
      drawer: CustomerControlPanel(
        user: user,
      ),
      endDrawer: administrationScreenPicker(),
      body: Container(
        height: media.height,
        width: media.width,
        child: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  displayCircleImage(user.profilePictureURL, 35, false),
                  SizedBox(
                    width: 5,
                  ),
                  RaisedButton(
                    color: Colors.white70,
                    onPressed: () {
                      EasyPopup.show(context, DropDownMenu(),
                          offsetLT: Offset(
                              0, MediaQuery.of(context).padding.top + 50));
                    },
                    child: Container(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(80.0)),
                        child: Text(
                          "What's happening, ${user.firstName}?",
                          style: TextStyle(
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 35.0),
              child: ZoomableSlider(
                user: user,
              ),
            ),
            Padding(padding: (EdgeInsets.only(top: 10.0))),
            Padding(
              padding: EdgeInsets.only(top: 270.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    Text(
                      "Health Service",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 21.0,
                        letterSpacing: 1.0,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Card(
                          margin: EdgeInsets.symmetric(horizontal: 10.0),
                          color: Colors.white70,
                          child: SizedBox(
                            child: FlatButton(
                                onPressed: () {},
                                child: Image.asset("assets/images/doctor.png")),
                            height: 90.0,
                            width: 150.0,
                          ),
                        ),
                        Card(
                          margin: EdgeInsets.symmetric(horizontal: 10.0),
                          color: Colors.white70,
                          child: SizedBox(
                            child: Image.asset("assets/images/pharmacist.png"),
                            height: 90.0,
                            width: 150.0,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Card(
                          margin: EdgeInsets.symmetric(horizontal: 10.0),
                          color: Colors.white70,
                          child: SizedBox(
                            child: Image.asset("assets/images/radiologist.png"),
                            height: 90.0,
                            width: 150.0,
                          ),
                        ),
                        Card(
                          margin: EdgeInsets.symmetric(horizontal: 10.0),
                          color: Colors.white70,
                          child: SizedBox(
                            child: Image.asset("assets/images/laboratory.png"),
                            height: 90.0,
                            width: 150.0,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '#Hot ',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 22.0,
                            color: Color(COLOR_PRIMARY),
                          ),
                        ),
                        Text(
                          'Information',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 22.0,
                          ),
                        ),
                      ],
                    ),
                    Card(
                      margin: EdgeInsets.symmetric(horizontal: 20.0),
                      color: Colors.white70,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30.0),
                                  image: DecorationImage(
                                      image:
                                          AssetImage('assets/images/1.png'))),
                            ),
                            height: 90.0,
                            width: 110.0,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("We love stories about prohibition"),
                              Row(
                                verticalDirection: VerticalDirection.up,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.remove_red_eye_outlined),
                                    onPressed: () {
                                      print("post number of views");
                                    },
                                  ),
                                  Text("11"),
                                  IconButton(
                                    icon: Icon(LineIcons.heart_o),
                                    onPressed: () {
                                      print("post id added to liked posts");
                                    },
                                  ),
                                  Text("22"),
                                ],
                              )
                            ],
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
      ),
    );
  }

  Widget administrationScreenPicker() {
    if (user.partnerEnabled) {
      return user.isPartner
          ? PartnerControlPanel(
              user: user,
              business: business,
            )
          : BusinessSignUpScreen(user: user);
    } else {
      return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
          elevation: 16,
          child: Container(
            height: 160,
            width: 350,
            child: Padding(
                padding: const EdgeInsets.only(
                    top: 38.0, left: 16, right: 16, bottom: 16),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Text(
                      "You must be a Partner to continue.",
                      style: TextStyle(
                        fontSize: 15.0,
                      ),
                    ),
                    Spacer(),
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                                          spacing: 30,
                      children: <Widget>[
                        FlatButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              'cancel',
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ).tr()),
                        FlatButton(
                            onPressed: () async {
                              user.partnerEnabled = true;
                              FireStoreUtils.updateUserState(user);
                              print("alrighty then");
                              Navigator.pop(context);
                            },
                            child: Text('Confirm',
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Color(COLOR_PRIMARY)))),
                      ],
                    )
                  ],
                )),
          ));
    }
  }
}
