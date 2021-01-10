import 'package:flutter/material.dart';
import 'package:instachatty/model/User.dart';
import 'package:instachatty/model/IconGrid.dart';
import 'package:instachatty/services/FirebaseHelper.dart';
import 'package:line_icons/line_icons.dart';
import 'package:instachatty/constants.dart';
import 'package:instachatty/ui/home/HomeScreen.dart';

class InterestScreen extends StatefulWidget {
  InterestScreen({this.user});

  final User user;

  @override
  _InterestScreenState createState() => _InterestScreenState(user);
}

class _InterestScreenState extends State<InterestScreen> {
  final User user;
  _InterestScreenState(this.user);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(COLOR_PRIMARY),
        title: Text("Choose your interest"),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Color(COLOR_PRIMARY),
        unselectedItemColor: Colors.black45,
        currentIndex: 1,
        onTap: (int) {
          int == 0 ? Navigator.of(context).pop() : user.isPartner = true;
          FireStoreUtils.updateUserState(user);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => HomeScreen(user: user),
            ),
          );
        },
        items: [
          BottomNavigationBarItem(
              backgroundColor: Colors.black45,
              label: 'Cancel',
              icon: Icon(
                Icons.cancel,
                color: Colors.black45,
              )),
          BottomNavigationBarItem(label: "Confirm", icon: Icon(Icons.check)),
        ],
      ),
      body: SingleChildScrollView(
        child: Wrap(
          children: [
            Row(
              children: [
                IconGridCard(
                    text: "Fitness",
                    icon: LineIcons.medkit,
                    color: user.interestMap.interest['Fitness']
                        ? Color(COLOR_PRIMARY)
                        : Colors.black,
                    onPressed: () async {
                      setState(() {
                        user.interestMap.interest['Fitness'] =
                            !user.interestMap.interest['Fitness'];
                      });
                      FireStoreUtils.updateUserState(user);
                    }),
                IconGridCard(
                    text: "Cooking",
                    icon: LineIcons.eyedropper,
                    color: user.interestMap.interest['Cooking']
                        ? Color(COLOR_PRIMARY)
                        : Colors.black,
                    onPressed: () async {
                      setState(() {
                        user.interestMap.interest['Cooking'] =
                            !user.interestMap.interest['Cooking'];
                      });
                      FireStoreUtils.updateUserState(user);
                    }),
                IconGridCard(
                    text: "Fashion",
                    icon: LineIcons.balance_scale,
                    color: user.interestMap.interest['Fashion']
                        ? Color(COLOR_PRIMARY)
                        : Colors.black,
                    onPressed: () async {
                      setState(() {
                        user.interestMap.interest['Fashion'] =
                            !user.interestMap.interest['Fashion'];
                      });
                      FireStoreUtils.updateUserState(user);
                    }),
              ],
            ),
            Row(
              children: [
                IconGridCard(
                    text: "Travelling",
                    icon: LineIcons.money,
                    color: user.interestMap.interest['Fashion']
                        ? Color(COLOR_PRIMARY)
                        : Colors.black,
                    onPressed: () async {
                      setState(() {
                        user.interestMap.interest['Fashion'] =
                            !user.interestMap.interest['Fashion'];
                      });
                      FireStoreUtils.updateUserState(user);
                    }),
                IconGridCard(
                    text: "Sports",
                    icon: LineIcons.ambulance,
                    color: user.interestMap.interest['Sports']
                        ? Color(COLOR_PRIMARY)
                        : Colors.black,
                    onPressed: () async {
                      setState(() {
                        user.interestMap.interest['Sports'] =
                            !user.interestMap.interest['Sports'];
                      });
                      FireStoreUtils.updateUserState(user);
                    }),
                IconGridCard(
                    text: "Music",
                    icon: LineIcons.map,
                    color: user.interestMap.interest['Music']
                        ? Color(COLOR_PRIMARY)
                        : Colors.black,
                    onPressed: () async {
                      setState(() {
                        user.interestMap.interest['Music'] =
                            !user.interestMap.interest['Music'];
                      });
                      FireStoreUtils.updateUserState(user);
                    }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
