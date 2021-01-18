import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:instachatty/constants.dart';
import 'package:instachatty/ui/profile/ProfileScreen.dart';
import 'package:line_icons/line_icons.dart';
import 'package:instachatty/ui/home/ChatHomeScreen.dart';
import 'package:instachatty/model/User.dart';
import 'package:instachatty/services/FirebaseHelper.dart';
import 'package:instachatty/ui/search/ConnectionSearchScreen.dart';
import 'package:instachatty/ui/home/HealthHomeScreen.dart';
import 'package:instachatty/services/Helper.dart';
import 'package:instachatty/ui/search/ServicesSearchScreen.dart';
import 'package:instachatty/model/Business.dart';
import 'package:instachatty/ui/chatTemplate/multipick.dart';
import 'package:instachatty/ui/chatTemplate/photofilter.dart';
import 'package:instachatty/ui/chatTemplate/SliderCarousel.dart';
import 'package:instachatty/ui/chatTemplate/bottom-bar.dart';

class HomeScreen extends StatefulWidget {
  final User user;
  final Business business;
  HomeScreen({@required this.user, this.business});

  @override
  _HomeScreenState createState() => _HomeScreenState(user, business);
}

class _HomeScreenState extends State<HomeScreen> {
  _HomeScreenState(this.user, this.business);
  FireStoreUtils _fireStoreUtils = FireStoreUtils();
  final User user;
  final Business business;
  int _page = 0;
  GlobalKey _bottomNavigationKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      HealthHome(
        user: user,
        business: business,
      ),
      ChatHomeScreen(
        user: user,
      ),
      ServicesSearchScreen(
        user: user,
      ),
      ProfileScreen(
        user: user,
      ),
    ];
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        index: 0,
        height: 50.0,
        items: <Widget>[
          Icon(
            LineIcons.home,
            size: 30,
            color: Colors.white,
          ),
          Icon(
            LineIcons.comments,
            size: 30,
            color: Colors.white,
          ),
          Icon(
            Icons.search,
            size: 30,
            color: Colors.white,
          ),
          displayCircleImage(
              user.profilePictureURL, 42.0, false, user.fullName()),
        ],
        color: Color(COLOR_PRIMARY),
        backgroundColor: Colors.white,
        animationCurve: Curves.easeInOut,
        animationDuration: Duration(milliseconds: 600),
        onTap: (index) {
          setState(() {
            _page = index;
          });
        },
        buttonBackgroundColor:
            _page == 3 ? Colors.transparent : Color(COLOR_PRIMARY),
        letIndexChange: (index) => true,
      ),
      body: pages[_page],
    );
  }
}
