import 'package:flutter/material.dart';
import 'dart:math';
import 'package:instachatty/constants.dart';
import 'package:instachatty/ui/realEstateTemplate/real_estate_temp.dart';
import 'package:instachatty/model/User.dart';

const SCALE_FRACTION = 0.5;
const FULL_SCALE = 0.9;
const PAGER_HEIGHT = 200.0;

class ZoomableSlider extends StatefulWidget {
  final User user;
  final String bubble;
  ZoomableSlider({@required this.user, this.bubble});
  @override
  _ZoomableSliderState createState() => _ZoomableSliderState(user, bubble);
}

class _ZoomableSliderState extends State<ZoomableSlider> {
  final User user;
  final String bubble;
  _ZoomableSliderState(this.user, this.bubble);
  double viewPortFraction = 0.5;

  PageController pageController;

  int currentPage = 2;

  List<Map<String, String>> listOfCharacters = [
    {'image': "assets/images/food.jpg", 'name': "Food"},
    {'image': "assets/images/fashion.jpg", 'name': "Fashion"},
    {'image': "assets/images/Hospitality.jpg", 'name': "Hospitality"},
    {'image': "assets/images/hobby.jpg", 'name': "Hobbies"},
    {'image': "assets/images/travel.jpg", 'name': "Travel"},
    {'image': "assets/images/finances.jpg", 'name': "Finances"},
    {'image': "assets/images/home decor.jpg", 'name': "Home Decor"},
    {'image': "assets/images/gardening.png", 'name': "Gardening"},
    {'image': "assets/images/parenting.jpg", 'name': "Parenting"},
    {'image': "assets/images/beauty.png", 'name': "Beauty"},
    {'image': "assets/images/self care.jpg", 'name': "Self Care"},
    {'image': "assets/images/family.jpg", 'name': "Family"},
  ];

  double page = 2.0;

  @override
  void initState() {
    pageController = PageController(
        initialPage: currentPage, viewportFraction: viewPortFraction);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: ListView(
        children: <Widget>[
          Container(
            height: PAGER_HEIGHT,
            child: NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification notification) {
                if (notification is ScrollUpdateNotification) {
                  setState(() {
                    page = pageController.page;
                  });
                }
              },
              child: PageView.builder(
                onPageChanged: (pos) {
                  setState(() {
                    currentPage = pos;
                  });
                },
                physics: BouncingScrollPhysics(),
                controller: pageController,
                itemCount: listOfCharacters.length,
                itemBuilder: (context, index) {
                  final scale = max(SCALE_FRACTION,
                      (FULL_SCALE - (index - page).abs()) + viewPortFraction);
                  return circleOffer(listOfCharacters[index]['image'], scale);
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(0.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '#Explore ',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22.0,
                    color: Color(COLOR_PRIMARY),
                  ),
                ),
                Text(
                  '${listOfCharacters[currentPage]['name']}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22.0,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget circleOffer(String image, double scale) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: FlatButton(
        clipBehavior: Clip.antiAlias,
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
                builder: (BuildContext context) => RealEstateHome(
                      user: user,
                      bubble: listOfCharacters[currentPage]['name'],
                    )),
          );
        },
        child: Container(
          margin: EdgeInsets.only(bottom: 1),
          height: PAGER_HEIGHT * scale,
          width: PAGER_HEIGHT * scale,
          child: Card(
            elevation: 4,
            clipBehavior: Clip.antiAlias,
            shape: CircleBorder(
                side: BorderSide(color: Colors.grey.shade200, width: 5)),
            child: Image.asset(
              image,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
