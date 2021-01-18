import 'package:flutter/material.dart';
import 'dart:io';
import 'package:instachatty/model/momentModel.dart';
import 'package:instachatty/services/FirebaseHelper.dart';
import 'package:instachatty/model/User.dart';
import 'package:instachatty/constants.dart';

const double _kViewportFraction = 0.7;

class SliderCarousel extends StatefulWidget {
  final User user;
  final List images;
  SliderCarousel({Key key, this.images, this.user}) : super(key: key);

  @override
  _SliderCarouselState createState() => _SliderCarouselState(images, user);
}

class _SliderCarouselState extends State<SliderCarousel> {
  final List images;
  final User user;
  final fireStoreUtils = FireStoreUtils();

  _SliderCarouselState(this.images, this.user);
  final PageController _backgroundPageController = PageController();
  final PageController _pageController =
      PageController(viewportFraction: _kViewportFraction);
  ValueNotifier<double> selectedIndex = ValueNotifier<double>(0.0);
  Moment moment;
  bool showShadow = false;
  bool _handlePageNotification(ScrollNotification notification,
      PageController leader, PageController follower) {
    if (notification.depth == 0 && notification is ScrollUpdateNotification) {
      selectedIndex.value = leader.page;
      if (follower.page != leader.page) {
        follower.position.jumpToWithoutSettling(leader.position.pixels /
            _kViewportFraction); // ignore: deprecated_member_use
      }
      setState(() {});
    }
    return false;
  }

  void getImages() async {
    moment = await fireStoreUtils.getMyMoment(user.userID);
    await new Future.delayed(const Duration(
      seconds: 1,
    ));
    setState(() {});
    await new Future.delayed(const Duration(
      seconds: 7,
    ));
    setState(() {
      showShadow = true;
    });

    print(moment.urls.last);
  }

  @override
  void initState() {
    getImages();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          PageView(
            controller: _backgroundPageController,
            children: _buildBackgroundPages(),
          ),
          NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification notification) {
              return _handlePageNotification(
                  notification, _pageController, _backgroundPageController);
            },
            child: PageView(
              controller: _pageController,
              children: _buildPages(),
            ),
          ),
        ],
      ),
    );
  }

  Iterable<Widget> _buildBackgroundPages() {
    final List<Widget> backgroundPages = <Widget>[];
    if (moment != null) {
      if (moment.urls.length > 0) {
        for (String image in moment.urls) {
          backgroundPages.add(
            Container(
              color: Color(0xB07986CB),
              child: Opacity(
                opacity: 0.3,
                child: Expanded(
                  child: Image.network(
                    image,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          );
        }
        return backgroundPages;
      }
      return backgroundPages;
    } else {
      for (int index = 0; index < 10; index++) {
        backgroundPages.add(Container(
          child: Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(COLOR_ACCENT)),
            ),
          ),
        ));
      }
      return backgroundPages;
    }
  }

  Iterable<Widget> _buildPages() {
    final List<Widget> pages = <Widget>[];
    double pictureHeight = MediaQuery.of(context).size.height * 0.6;
    double pictureWidth = MediaQuery.of(context).size.width * 0.6;
    if (moment != null) {
      if (moment.urls.length > 0) {
        int i = 0;
        for (String image in moment.urls) {
          var alignment = Alignment.center.add(
              Alignment((selectedIndex.value - i) * _kViewportFraction, 0.0));
          var resizeFactor =
              (1 - (((selectedIndex.value - i).abs() * 0.3).clamp(0.0, 1.0)));
          var imageAsset = image;
          pages.add(
            Container(
              alignment: alignment,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  //color: Colors.red[400],
                  boxShadow: <BoxShadow>[
                    showShadow
                        ? BoxShadow(
                            color: Color(0xEE000000),
                            offset: Offset(0.0, 6.0),
                            blurRadius: 10.0,
                          )
                        : null,
                  ],
                ),
                width: pictureWidth * resizeFactor,
                height: pictureHeight * resizeFactor,
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return Hero(
                        tag: imageAsset,
                        child: Container(
                          color: Color(COLOR_PRIMARY),
                          child: Image.network(
                            image,
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    }));
                  },
                  child: Hero(
                    tag: imageAsset,
                    child: Image.network(
                      image,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          );
          i++;
        }
        return pages;
      }
      return pages;
    } else {
      for (int index = 0; index < 2; index++) {
        var alignment = Alignment.center.add(
            Alignment((selectedIndex.value - index) * _kViewportFraction, 0.0));
        pages.add(Container(
          alignment: alignment,
          child: Container(
            child: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(COLOR_ACCENT)),
              ),
            ),
          ),
        ));
      }

      return pages;
    }
  }
}
