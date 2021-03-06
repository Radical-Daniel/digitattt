import 'package:flutter/material.dart';
import 'package:instachatty/model/User.dart';
import 'package:instachatty/services/FirebaseHelper.dart';
import 'package:instachatty/services/Helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:instachatty/constants.dart';

enum DrawerSelection { Conversations, Contacts, Search, Settings }

class PrimaryDrawer extends StatefulWidget {
  PrimaryDrawer({@required this.user});
  final User user;

  @override
  _PrimaryDrawerState createState() => _PrimaryDrawerState(user);
}

class _PrimaryDrawerState extends State<PrimaryDrawer> {
  final User member;
  FireStoreUtils _fireStoreUtils = FireStoreUtils();

  DrawerSelection _drawerSelection = DrawerSelection.Conversations;

  _PrimaryDrawerState(this.member);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Scaffold(
        // appBar: AppBar(
        //   backgroundColor: Color(COLOR_PRIMARY),
        //   shadowColor: Colors.transparent,
        //   actions: [Icon(Icons.settings)],
        // ),
        body: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  displayCircleImage(
                      member.profilePictureURL, 85, false, member.fullName()),
                  Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        member.email,
                        style: TextStyle(color: Colors.white),
                      )),
                ],
              ),
              decoration: BoxDecoration(
                color: Color(COLOR_PRIMARY),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ListTile(
                  selectedTileColor: Color(COLOR_PRIMARY),
                  selected: _drawerSelection == DrawerSelection.Conversations,
                  title: Text(
                    'Bookings',
                    style: TextStyle(
                      color: _drawerSelection == DrawerSelection.Conversations
                          ? Colors.white
                          : Color(COLOR_PRIMARY),
                      fontSize: 19.0,
                      letterSpacing: 1.0,
                    ),
                  ),
                  contentPadding: LISTTILEPADDING,
                  onTap: () {
                    Navigator.pop(context);
                    setState(() {
                      _drawerSelection = DrawerSelection.Conversations;
                    });
                  },
                  leading: Icon(
                    Icons.chat_bubble,
                    color: _drawerSelection == DrawerSelection.Conversations
                        ? Colors.white
                        : Color(COLOR_PRIMARY),
                  ),
                ),
                ListTile(
                    selectedTileColor: Color(COLOR_PRIMARY),
                    selected: _drawerSelection == DrawerSelection.Contacts,
                    leading: Icon(
                      Icons.star,
                      color: _drawerSelection == DrawerSelection.Contacts
                          ? Colors.white
                          : Color(COLOR_PRIMARY),
                    ),
                    title: Text(
                      'Review',
                      style: TextStyle(
                        color: _drawerSelection == DrawerSelection.Contacts
                            ? Colors.white
                            : Color(COLOR_PRIMARY),
                        fontSize: 19.0,
                        letterSpacing: 1.0,
                      ),
                    ),
                    contentPadding: LISTTILEPADDING,
                    onTap: () {
                      Navigator.pop(context);
                      setState(() {
                        _drawerSelection = DrawerSelection.Contacts;
                      });
                    }),
                ListTile(
                    selectedTileColor: Color(COLOR_PRIMARY),
                    selected: _drawerSelection == DrawerSelection.Search,
                    title: Text(
                      'Gallery',
                      style: TextStyle(
                        color: _drawerSelection == DrawerSelection.Search
                            ? Colors.white
                            : Color(COLOR_PRIMARY),
                        fontSize: 19.0,
                        letterSpacing: 1.0,
                      ),
                    ),
                    leading: Icon(
                      Icons.search,
                      color: _drawerSelection == DrawerSelection.Search
                          ? Colors.white
                          : Color(COLOR_PRIMARY),
                    ),
                    contentPadding: LISTTILEPADDING,
                    onTap: () {
                      Navigator.pop(context);
                      setState(() {
                        _drawerSelection = DrawerSelection.Search;
                      });
                    }),
                ListTile(
                    selectedTileColor: Color(COLOR_PRIMARY),
                    selected: _drawerSelection == DrawerSelection.Settings,
                    title: Text(
                      'Settings',
                      style: TextStyle(
                        color: _drawerSelection == DrawerSelection.Settings
                            ? Colors.white
                            : Color(COLOR_PRIMARY),
                        fontSize: 19.0,
                        letterSpacing: 1.0,
                      ),
                    ),
                    leading: Icon(
                      Icons.settings,
                      color: _drawerSelection == DrawerSelection.Settings
                          ? Colors.white
                          : Color(COLOR_PRIMARY),
                    ),
                    contentPadding: LISTTILEPADDING,
                    onTap: () {
                      Navigator.pop(context);
                      _onPrivateChatSettingsClick();
                      setState(() {
                        _drawerSelection = DrawerSelection.Settings;
                      });
                    }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _onPrivateChatSettingsClick() {
    final action = CupertinoActionSheet(
      message: Text(
        "chatSettings",
        style: TextStyle(fontSize: 15.0),
      ),
      actions: <Widget>[
        CupertinoActionSheetAction(
          child: Text("blockUser"),
          onPressed: () async {
            Navigator.pop(context);
            showProgress(context, 'blockingUser', false);
            bool isSuccessful =
                await _fireStoreUtils.blockUser(member, 'block');
            hideProgress();
            if (isSuccessful) {
              Navigator.pop(context);
              _showAlertDialog(context, 'block',
                  'hasBeenBlocked.'.tr(args: ['${member.fullName()}']));
            } else {
              _showAlertDialog(context, 'block'.tr(),
                  'couldNotBlock'.tr(args: ['${member.fullName()}']));
            }
          },
        ),
        CupertinoActionSheetAction(
          child: Text("reportUser").tr(),
          onPressed: () async {
            Navigator.pop(context);
            showProgress(context, 'reportingUser'.tr(), false);
            bool isSuccessful =
                await _fireStoreUtils.blockUser(member, 'report');
            hideProgress();
            if (isSuccessful) {
              Navigator.pop(context);
              _showAlertDialog(
                  context,
                  'report'.tr(),
                  'hasBeenBlockedAndReported'
                      .tr(args: ['${member.fullName()}']));
            } else {
              _showAlertDialog(context, 'report'.tr(),
                  'couldNotReportAndBlock'.tr(args: ['${member.fullName()}']));
            }
          },
        ),
      ],
      cancelButton: CupertinoActionSheetAction(
        child: Text(
          "cancel",
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
    showCupertinoModalPopup(context: context, builder: (context) => action);
  }

  _showAlertDialog(BuildContext context, String title, String message) {
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
