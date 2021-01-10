import 'package:flutter/material.dart';
import 'package:instachatty/model/User.dart';
import 'package:instachatty/model/IconGrid.dart';
import 'package:instachatty/services/FirebaseHelper.dart';
import 'package:instachatty/services/Helper.dart';
import 'package:line_icons/line_icons.dart';
import 'package:instachatty/constants.dart';
import 'package:instachatty/ui/home/HomeScreen.dart';

import 'package:instachatty/main.dart';

class ProfessionScreen extends StatefulWidget {
  ProfessionScreen({this.user});

  final User user;

  @override
  _ProfessionScreenState createState() => _ProfessionScreenState(user);
}

class _ProfessionScreenState extends State<ProfessionScreen> {
  final User user;
  _ProfessionScreenState(this.user);

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
                    text: "doctor",
                    icon: LineIcons.medkit,
                    color: user.interestMap.interest['doctor']
                        ? Color(COLOR_PRIMARY)
                        : Colors.black,
                    onPressed: () async {
                      setState(() {
                        user.interestMap.interest['doctor'] =
                            !user.interestMap.interest['doctor'];
                      });
                      FireStoreUtils.updateUserState(user);
                    }),
                IconGridCard(
                    text: "Pharmacist",
                    icon: LineIcons.eyedropper,
                    color: user.interestMap.interest['pharmacist']
                        ? Color(COLOR_PRIMARY)
                        : Colors.black,
                    onPressed: () async {
                      setState(() {
                        user.interestMap.interest['pharmacist'] =
                            !user.interestMap.interest['pharmacist'];
                      });
                      FireStoreUtils.updateUserState(user);
                    }),
                IconGridCard(
                    text: "Laboratory",
                    icon: LineIcons.balance_scale,
                    color: user.interestMap.interest['laboratory']
                        ? Color(COLOR_PRIMARY)
                        : Colors.black,
                    onPressed: () async {
                      setState(() {
                        user.interestMap.interest['laboratory'] =
                            !user.interestMap.interest['laboratory'];
                      });
                      FireStoreUtils.updateUserState(user);
                    }),
              ],
            ),
            Row(
              children: [
                IconGridCard(
                    text: "retail",
                    icon: LineIcons.money,
                    color: user.interestMap.interest['retail']
                        ? Color(COLOR_PRIMARY)
                        : Colors.black,
                    onPressed: () async {
                      setState(() {
                        user.interestMap.interest['retail'] =
                            !user.interestMap.interest['retail'];
                      });
                      FireStoreUtils.updateUserState(user);
                    }),
                IconGridCard(
                    text: "ambulance",
                    icon: LineIcons.ambulance,
                    color: user.interestMap.interest['ambulance']
                        ? Color(COLOR_PRIMARY)
                        : Colors.black,
                    onPressed: () async {
                      setState(() {
                        user.interestMap.interest['ambulance'] =
                            !user.interestMap.interest['ambulance'];
                      });
                      FireStoreUtils.updateUserState(user);
                    }),
                IconGridCard(
                    text: "radiologist",
                    icon: LineIcons.map,
                    color: user.interestMap.interest['radiologist']
                        ? Color(COLOR_PRIMARY)
                        : Colors.black,
                    onPressed: () async {
                      setState(() {
                        user.interestMap.interest['radiologist'] =
                            !user.interestMap.interest['radiologist'];
                      });
                      FireStoreUtils.updateUserState(user);
                    }),
              ],
            ),
            Row(
              children: [
                IconGridCard(
                    text: "hospital",
                    icon: LineIcons.hospital_o,
                    color: user.interestMap.interest['hospital']
                        ? Color(COLOR_PRIMARY)
                        : Colors.black,
                    onPressed: () async {
                      setState(() {
                        user.interestMap.interest['hospital'] =
                            !user.interestMap.interest['hospital'];
                      });
                      await FireStoreUtils.updateCurrentUser(user);
                      MyAppState.currentUser = user;
                      hideProgress();
                    }),
                IconGridCard(
                    text: "clinic",
                    icon: LineIcons.life_saver,
                    color: user.interestMap.interest['clinic']
                        ? Color(COLOR_PRIMARY)
                        : Colors.black,
                    onPressed: () async {
                      setState(() {
                        user.interestMap.interest['clinic'] =
                            !user.interestMap.interest['clinic'];
                      });
                      await FireStoreUtils.updateCurrentUser(user);
                      MyAppState.currentUser = user;
                      hideProgress();
                    }),
                IconGridCard(
                    text: "fitness",
                    icon: LineIcons.trophy,
                    color: user.interestMap.interest['fitness']
                        ? Color(COLOR_PRIMARY)
                        : Colors.black,
                    onPressed: () async {
                      setState(() {
                        user.interestMap.interest['fitness'] =
                            !user.interestMap.interest['fitness'];
                      });
                      FireStoreUtils.updateUserState(user);
                    }),
              ],
            ),
            Row(
              children: [
                IconGridCard(
                    text: "hospitality",
                    icon: LineIcons.hotel,
                    color: user.interestMap.interest['hospitality']
                        ? Color(COLOR_PRIMARY)
                        : Colors.black,
                    onPressed: () async {
                      setState(() {
                        user.interestMap.interest['hospitality'] =
                            !user.interestMap.interest['hospitality'];
                      });
                      await FireStoreUtils.updateCurrentUser(user);
                      MyAppState.currentUser = user;
                      hideProgress();
                    }),
                IconGridCard(
                    text: "insurance",
                    icon: LineIcons.briefcase,
                    color: user.interestMap.interest['insurance']
                        ? Color(COLOR_PRIMARY)
                        : Colors.black,
                    onPressed: () async {
                      setState(() {
                        user.interestMap.interest['insurance'] =
                            !user.interestMap.interest['insurance'];
                      });
                      await FireStoreUtils.updateCurrentUser(user);
                      MyAppState.currentUser = user;
                      hideProgress();
                    }),
                IconGridCard(
                    text: "travel",
                    icon: LineIcons.plane,
                    color: user.interestMap.interest['travel']
                        ? Color(COLOR_PRIMARY)
                        : Colors.black,
                    onPressed: () async {
                      setState(() {
                        user.interestMap.interest['travel'] =
                            !user.interestMap.interest['travel'];
                      });
                      FireStoreUtils.updateUserState(user);
                    }),
              ],
            ),
            Row(
              children: [
                IconGridCard(
                    text: "wellness",
                    icon: LineIcons.apple,
                    color: user.interestMap.interest['wellness']
                        ? Color(COLOR_PRIMARY)
                        : Colors.black,
                    onPressed: () async {
                      setState(() {
                        user.interestMap.interest['wellness'] =
                            !user.interestMap.interest['wellness'];
                      });
                      await FireStoreUtils.updateCurrentUser(user);
                      MyAppState.currentUser = user;
                      hideProgress();
                    }),
                IconGridCard(
                    text: "student",
                    icon: LineIcons.book,
                    color: user.interestMap.interest['student']
                        ? Color(COLOR_PRIMARY)
                        : Colors.black,
                    onPressed: () async {
                      setState(() {
                        user.interestMap.interest['student'] =
                            !user.interestMap.interest['student'];
                      });
                      await FireStoreUtils.updateCurrentUser(user);
                      MyAppState.currentUser = user;
                      hideProgress();
                    }),
                IconGridCard(
                    text: "education",
                    icon: LineIcons.university,
                    color: user.interestMap.interest['education']
                        ? Color(COLOR_PRIMARY)
                        : Colors.black,
                    onPressed: () async {
                      setState(() {
                        user.interestMap.interest['education'] =
                            !user.interestMap.interest['education'];
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
