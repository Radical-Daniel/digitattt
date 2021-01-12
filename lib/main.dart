import 'dart:async';

import 'package:instachatty/ui/home/HomeScreen.dart';
import 'package:callkeep/callkeep.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:instachatty/constants.dart';
import 'package:instachatty/services/FirebaseHelper.dart';
import 'package:instachatty/services/Helper.dart';
import 'package:instachatty/ui/chat/PlayerWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:instachatty/model/User.dart';
import 'package:instachatty/ui/auth/AuthScreen.dart';
import 'package:instachatty/ui/onBoarding/OnBoardingScreen.dart';
import 'package:uuid/uuid.dart';
import 'package:instachatty/model/Business.dart';
import 'package:instachatty/ui/home/ChatHomeScreen.dart';

final FlutterCallkeep callKeep = FlutterCallkeep();

void main() async {
  var uuid = Uuid();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    EasyLocalization(
        supportedLocales: [Locale('en'), Locale('ar')],
        path: 'assets/translations',
        fallbackLocale: Locale('en'),
        useOnlyLangCode: true,
        child: MyApp()),
  );
}

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> with WidgetsBindingObserver {
  static User currentUser;
  StreamSubscription tokenStream;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Color(COLOR_PRIMARY_DARK)));
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        title: 'appName'.tr(),
        theme: ThemeData(
            canvasColor: Colors.white,
            sliderTheme: SliderThemeData(
                trackShape: CustomTrackShape(),
                thumbShape: RoundSliderThumbShape(enabledThumbRadius: 5)),
            accentColor: Color(COLOR_PRIMARY),
            brightness: Brightness.light),
        darkTheme: ThemeData(
            sliderTheme: SliderThemeData(
                trackShape: CustomTrackShape(),
                thumbShape: RoundSliderThumbShape(enabledThumbRadius: 5)),
            accentColor: Color(COLOR_PRIMARY),
            brightness: Brightness.dark),
        color: Color(COLOR_PRIMARY),
        home: OnBoarding());
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
    FireStoreUtils.firebaseMessaging.configure(
      onBackgroundMessage: backgroundMessageHandler,
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );
    FireStoreUtils.firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(
            sound: true, badge: true, alert: true, provisional: true));
    FireStoreUtils.firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
    tokenStream =
        FireStoreUtils.firebaseMessaging.onTokenRefresh.listen((event) {
      if (currentUser != null && event != null) {
        print('token $event');
        currentUser.fcmToken = event;
        FireStoreUtils.updateCurrentUser(currentUser);
      }
    });
    callKeep.setup(<String, dynamic>{
      'ios': {
        'appName': 'appName'.tr(),
      },
      'android': {
        'alertTitle': 'Permissions required',
        'alertDescription':
            'This application needs to access your phone accounts',
        'cancelButton': 'Cancel',
        'okButton': 'ok',
      },
    });
  }

  @override
  void dispose() {
    tokenStream.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (FirebaseAuth.instance.currentUser() != null && currentUser != null) {
      if (state == AppLifecycleState.paused) {
        //user offline
        tokenStream.pause();
        currentUser.active = false;
        currentUser.lastOnlineTimestamp = Timestamp.now();
        FireStoreUtils.updateCurrentUser(currentUser);
      } else if (state == AppLifecycleState.resumed) {
        //user online
        tokenStream.resume();
        currentUser.active = true;
        FireStoreUtils.updateCurrentUser(currentUser);
      }
    }
  }
}

class OnBoarding extends StatefulWidget {
  @override
  State createState() {
    return OnBoardingState();
  }
}

class OnBoardingState extends State<OnBoarding> {
  Future hasFinishedOnBoarding() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool finishedOnBoarding = (prefs.getBool(FINISHED_ON_BOARDING) ?? false);

    if (finishedOnBoarding) {
      FirebaseUser firebaseUser = await FirebaseAuth.instance.currentUser();
      if (firebaseUser != null) {
        User user = await FireStoreUtils().getCurrentUser(firebaseUser.uid);
        if (user != null) {
          user.active = true;
          await FireStoreUtils.updateCurrentUser(user);
          MyAppState.currentUser = user;
          if (user.isPartner) {
            Business business = await FireStoreUtils()
                .getCurrentBusiness(user.businessAffiliations.last);

            pushReplacement(
                context,
                new HomeScreen(
                  user: user,
                  business: business,
                ));
          } else {
            pushReplacement(
                context,
                new HomeScreen(
                  user: user,
                ));
          }
        } else {
          pushReplacement(context, new AuthScreen());
        }
      } else {
        pushReplacement(context, new AuthScreen());
      }
    } else {
      pushReplacement(context, new OnBoardingScreen());
    }
  }

  @override
  void initState() {
    super.initState();
    hasFinishedOnBoarding();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}

Future<dynamic> backgroundMessageHandler(Map<dynamic, dynamic> message) async {
  if (message.containsKey('data')) {
    // Handle data message
    final Map<dynamic, dynamic> data = message['data'];
    if (data.containsKey('callData')) {
      // Map<String, dynamic> callData = jsonDecode(data['callData']);
      callKeep.backToForeground();
      // callKeep.displayIncomingCall(
      //     callData['data']['from'],
      //     callData['callerName'],
      //     handleType: 'number',
      //     hasVideo: callData['callType'] == 'video');
    }
  }

  if (message.containsKey('notification')) {
    // Handle notification message
    final dynamic notification = message['notification'];
  }
}
