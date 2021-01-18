import 'package:flutter/material.dart';
import 'package:instachatty/ui/chatTemplate/SliderCarousel.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:instachatty/model/User.dart';
import 'package:instachatty/model/momentModel.dart';
import 'package:instachatty/services/FirebaseHelper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Color color = Color(0xffff024a);

class BottomBar extends StatefulWidget {
  final User user;
  final List<String> images;
  BottomBar({Key key, this.images, this.user}) : super(key: key);

  _BottomBarState createState() => _BottomBarState(images, user);
}

class _BottomBarState extends State<BottomBar> {
  final User user;
  final List<String> images;
  _BottomBarState(this.images, this.user);
  @override
  Widget build(BuildContext context) {
    double itemWidth = MediaQuery.of(context).size.width / 5;

    return RaisedButton(
      child: Text("open up"),
      onPressed: () {
        showDialog(
            context: context,
            builder: (context) {
              return Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                ),
                elevation: 16,
                child: Container(
                    height: 520,
                    width: 335,
                    child: SliderCarousel(
                      user: user,
                    )),
              );
            });
      },
    );
  }
}
