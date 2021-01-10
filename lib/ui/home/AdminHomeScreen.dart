import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:instachatty/model/User.dart';
import 'package:instachatty/constants.dart';
import 'package:instachatty/services/FirebaseHelper.dart';
import 'package:instachatty/services/HomeNavigationHelper.dart';
import 'package:instachatty/ui/professions/ProfessionScreen.dart';

class AdminHomeScreen extends StatefulWidget {
  AdminHomeScreen({@required this.user});
  final User user;

  @override
  _AdminHomeScreenState createState() => _AdminHomeScreenState(user);
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  final User user;
  FireStoreUtils _fireStoreUtils = FireStoreUtils();

  _AdminHomeScreenState(this.user);

  int _page = 0;
  GlobalKey _bottomNavigationKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(
              LineIcons.diamond,
              color: Color(COLOR_PRIMARY),
            ),
            onPressed: () {
              Navigator.of(context).push(HomeNavigator.goToDrawer(
                  ProfessionScreen(
                    user: user,
                  ),
                  -1.0));
            },
          )
        ],
        leading: HomeNavigator(
          icon: Icon(
            LineIcons.globe,
            color: Color(COLOR_PRIMARY),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        // brightness: Brightness.light,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'appName',
              style: TextStyle(color: Color(COLOR_PRIMARY)),
            ).tr(),
            Text(
              " Partner",
              style: TextStyle(color: Color(COLOR_PRIMARY)),
            )
          ],
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        index: 0,
        height: 50.0,
        items: <Widget>[
          Icon(Icons.add, size: 30),
          Icon(Icons.list, size: 30),
          Icon(Icons.compare_arrows, size: 30),
          Icon(Icons.call_split, size: 30),
          Icon(Icons.perm_identity, size: 30),
        ],
        color: Colors.white,
        buttonBackgroundColor: Colors.white,
        backgroundColor: Colors.blueAccent,
        animationCurve: Curves.easeInOut,
        animationDuration: Duration(milliseconds: 600),
        onTap: (index) {
          setState(() {
            _page = index;
          });
        },
        letIndexChange: (index) => true,
      ),
      body: Container(
        color: Colors.blueAccent,
        child: Center(
          child: Column(
            children: <Widget>[
              Text(_page.toString(), textScaleFactor: 10.0),
              RaisedButton(
                child: Text('Go To Page of index 1'),
                onPressed: () {
                  final CurvedNavigationBarState navBarState =
                      _bottomNavigationKey.currentState;
                  navBarState.setPage(1);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
