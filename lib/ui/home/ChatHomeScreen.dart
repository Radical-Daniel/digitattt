import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instachatty/constants.dart';
import 'package:instachatty/main.dart';
import 'package:instachatty/model/ConversationModel.dart';
import 'package:instachatty/model/HomeConversationModel.dart';
import 'package:instachatty/model/User.dart';
import 'package:instachatty/services/FirebaseHelper.dart';
import 'package:instachatty/services/Helper.dart';
import 'package:instachatty/ui/contacts/ContactsScreen.dart';
import 'package:instachatty/ui/conversations/ConversationsScreen.dart';
import 'package:instachatty/ui/search/ConnectionSearchScreen.dart';
import 'package:instachatty/ui/videoCall/VideoCallScreen.dart';
import 'package:instachatty/ui/videoCallsGroupChat/VideoCallsGroupScreen.dart';
import 'package:instachatty/ui/voiceCall/VoiceCallScreen.dart';
import 'package:instachatty/ui/voiceCallsGroupChat/VoiceCallsGroupScreen.dart';
import 'package:provider/provider.dart';
import 'package:line_icons/line_icons.dart';
import 'package:instachatty/services/HomeNavigationHelper.dart';
import 'package:instachatty/ui/chatTemplate/themes.dart';
import 'package:instachatty/ui/chatTemplate/theme.bloc.dart';
import 'package:instachatty/ui/professions/ProfessionScreen.dart';

enum DrawerSelection { Conversations, Contacts, Search, Profile }

class ChatHomeScreen extends StatefulWidget {
  final User user;
  static bool onGoingCall = false;
  final Widget selectedScreen;
  ChatHomeScreen({Key key, @required this.user, this.selectedScreen})
      : super(key: key);

  @override
  _HomeState createState() {
    return _HomeState(user, selectedScreen);
  }
}

class _HomeState extends State<ChatHomeScreen>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _heightAnimation;
  Animation<double> _iconSizeAnimation;
  final User user;
  final Widget selectedScreen;
  DrawerSelection _drawerSelection = DrawerSelection.Conversations;
  String _appBarTitle = tr('conversations');
  Widget _endDrawerCurrentWidget;
  _HomeState(this.user, this.selectedScreen);

  int selectedIndex = 0;
  int badge = 0;
  var padding = EdgeInsets.symmetric(horizontal: 18, vertical: 5);
  double gap = 10;
  PageController controller = PageController();
  bool showGroupMaker = true;
  Widget _currentWidget;

  @override
  void initState() {
    super.initState();
    _currentWidget = selectedScreen ??
        ConversationsScreen(
          user: user,
        );
    if (CALLS_ENABLED) _listenForCalls();
    var padding = EdgeInsets.symmetric(horizontal: 18, vertical: 5);
    double gap = 10;
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
    return ChangeNotifierProvider.value(
      value: user,
      child: Scaffold(
        extendBody: true,
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              Consumer<User>(
                builder: (context, user, _) {
                  return DrawerHeader(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        displayCircleImage(user.profilePictureURL, 75, false),
                        Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                user.fullName(),
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(
                                width: 10.0,
                              ),
                              Icon(
                                LineIcons.medkit,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              user.email,
                              style: TextStyle(color: Colors.white),
                            )),
                      ],
                    ),
                    decoration: BoxDecoration(
                      color: Color(COLOR_PRIMARY),
                    ),
                  );
                },
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ListTile(
                    selectedTileColor: Color(COLOR_PRIMARY),
                    selected: _drawerSelection == DrawerSelection.Conversations,
                    title: Text(
                      'conversations',
                      style: TextStyle(
                        color: _drawerSelection == DrawerSelection.Conversations
                            ? Colors.white
                            : Color(COLOR_PRIMARY),
                        fontSize: 19.0,
                        letterSpacing: 1.0,
                      ),
                    ).tr(),
                    contentPadding: LISTTILEPADDING,
                    onTap: () {
                      Navigator.pop(context);
                      setState(() {
                        showGroupMaker = true;
                        _drawerSelection = DrawerSelection.Conversations;
                        _appBarTitle = 'conversations'.tr();
                        _currentWidget = ConversationsScreen(
                          user: user,
                        );
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
                        Icons.contacts,
                        color: _drawerSelection == DrawerSelection.Contacts
                            ? Colors.white
                            : Color(COLOR_PRIMARY),
                      ),
                      title: Text(
                        'contacts',
                        style: TextStyle(
                          color: _drawerSelection == DrawerSelection.Contacts
                              ? Colors.white
                              : Color(COLOR_PRIMARY),
                          fontSize: 19.0,
                          letterSpacing: 1.0,
                        ),
                      ).tr(),
                      contentPadding: LISTTILEPADDING,
                      onTap: () {
                        Navigator.pop(context);
                        setState(() {
                          showGroupMaker = true;
                          _drawerSelection = DrawerSelection.Contacts;
                          _appBarTitle = 'contacts'.tr();
                          _currentWidget = ContactsScreen(
                            user: user,
                          );
                        });
                      }),
                  ListTile(
                      selectedTileColor: Color(COLOR_PRIMARY),
                      selected: _drawerSelection == DrawerSelection.Search,
                      title: Text(
                        'search',
                        style: TextStyle(
                          color: _drawerSelection == DrawerSelection.Search
                              ? Colors.white
                              : Color(COLOR_PRIMARY),
                          fontSize: 19.0,
                          letterSpacing: 1.0,
                        ),
                      ).tr(),
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
                          showGroupMaker = false;
                          _drawerSelection = DrawerSelection.Search;
                          _appBarTitle = 'search'.tr();
                          _currentWidget = ConnectionSearchScreen(
                            user: user,
                          );
                        });
                      }),
                ],
              ),
            ],
          ),
        ),
        appBar: AppBar(
          // shadowColor: Color(COLOR_PRIMARY),
          backgroundColor: Color(COLOR_PRIMARY),
          title: Text(
            'appName'.tr(),
            style: TextStyle(
                color:
                    isDarkMode(context) ? Colors.grey.shade200 : Colors.white,
                fontWeight: FontWeight.bold),
          ),
          actions: <Widget>[
            HomeNavigator(
              icon: Icon(
                LineIcons.diamond,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context).push(HomeNavigator.goToDrawer(
                    ProfessionScreen(
                      user: user,
                    ),
                    1.0));
              },
            ),
          ],
          iconTheme: IconThemeData(
              color: isDarkMode(context) ? Colors.grey.shade200 : Colors.white),
          centerTitle: true,
        ),
        body: _currentWidget,
      ),
    );
  }

  void _listenForCalls() {
    Stream callStream = FireStoreUtils.firestore
        .collection(USERS)
        .document(user.userID)
        .collection(CALL_DATA)
        .snapshots();
    // ignore: cancel_subscriptions
    final callSubscription = callStream.listen((event) async {
      if (event.documents.isNotEmpty) {
        DocumentSnapshot callDocument = event.documents.first;
        if (callDocument.documentID != user.userID) {
          DocumentSnapshot userSnapShot = await FireStoreUtils.firestore
              .collection(USERS)
              .document(event.documents.first.documentID)
              .get();
          User caller = User.fromJson(userSnapShot.data);
          print('${caller.fullName()} called you');
          print('${callDocument.data['type'] ?? 'null'}');
          String type = callDocument.data['type'] ?? '';
          bool isGroupCall = callDocument.data['isGroupCall'] ?? false;
          String callType = callDocument.data['callType'] ?? '';
          Map<String, dynamic> connections =
              callDocument.data['connections'] ?? Map<String, dynamic>();
          List<dynamic> groupCallMembers =
              callDocument.data['members'] ?? <dynamic>[];
          if (type == 'offer') {
            if (callType == VIDEO) {
              if (isGroupCall) {
                if (!ChatHomeScreen.onGoingCall &&
                    connections.keys.contains(getConnectionID(caller.userID)) &&
                    connections[getConnectionID(caller.userID)]['description']
                            ['type'] ==
                        'offer') {
                  ChatHomeScreen.onGoingCall = true;
                  List<User> members = [];
                  groupCallMembers.forEach((element) {
                    members.add(User.fromJson(element));
                  });
                  push(
                    context,
                    VideoCallsGroupScreen(
                        homeConversationModel: HomeConversationModel(
                            isGroupChat: true,
                            conversationModel: ConversationModel.fromJson(
                                callDocument.data['conversationModel']),
                            members: members),
                        isCaller: false,
                        caller: caller,
                        sessionDescription:
                            connections[getConnectionID(caller.userID)]
                                ['description']['sdp'],
                        sessionType: connections[getConnectionID(caller.userID)]
                            ['description']['type']),
                  );
                }
              } else {
                push(
                  context,
                  VideoCallScreen(
                      homeConversationModel: HomeConversationModel(
                          isGroupChat: false,
                          conversationModel: null,
                          members: [caller]),
                      isCaller: false,
                      sessionDescription: callDocument.data['data']
                          ['description']['sdp'],
                      sessionType: callDocument.data['data']['description']
                          ['type']),
                );
              }
            } else if (callType == VOICE) {
              if (isGroupCall) {
                if (!ChatHomeScreen.onGoingCall &&
                    connections.keys.contains(getConnectionID(caller.userID)) &&
                    connections[getConnectionID(caller.userID)]['description']
                            ['type'] ==
                        'offer') {
                  ChatHomeScreen.onGoingCall = true;
                  List<User> members = [];
                  groupCallMembers.forEach((element) {
                    members.add(User.fromJson(element));
                  });
                  push(
                    context,
                    VoiceCallsGroupScreen(
                        homeConversationModel: HomeConversationModel(
                            isGroupChat: true,
                            conversationModel: ConversationModel.fromJson(
                                callDocument.data['conversationModel']),
                            members: members),
                        isCaller: false,
                        caller: caller,
                        sessionDescription:
                            connections[getConnectionID(caller.userID)]
                                ['description']['sdp'],
                        sessionType: connections[getConnectionID(caller.userID)]
                            ['description']['type']),
                  );
                }
              } else {
                push(
                  context,
                  VoiceCallScreen(
                      homeConversationModel: HomeConversationModel(
                          isGroupChat: false,
                          conversationModel: null,
                          members: [caller]),
                      isCaller: false,
                      sessionDescription: callDocument.data['data']
                          ['description']['sdp'],
                      sessionType: callDocument.data['data']['description']
                          ['type']),
                );
              }
            }
          }
        } else {
          print('you called someone');
        }
      }
    });
    FirebaseAuth.instance.onAuthStateChanged.listen((event) {
      if (event == null) {
        callSubscription.cancel();
      }
    });
  }

  String getConnectionID(String friendID) {
    String connectionID;
    String selfID = MyAppState.currentUser.userID;
    if (friendID.compareTo(selfID) < 0) {
      connectionID = friendID + selfID;
    } else {
      connectionID = selfID + friendID;
    }
    return connectionID;
  }
}
