import 'package:flutter/material.dart';
import 'package:instachatty/services/Helper.dart';

class HomeNavigator extends StatelessWidget {
  final Icon icon;
  final Function onPressed;

  HomeNavigator({this.icon, this.onPressed});

  static Route goToDrawer(Widget toDrawer, double xDirection) {
    return PageRouteBuilder(
      transitionDuration: Duration(milliseconds: 600),
      pageBuilder: (context, animation, secondaryAnimation) => toDrawer,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(xDirection, 0.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return IconButton(
          icon: icon,
          onPressed: onPressed,
          color: isDarkMode(context) ? Colors.grey.shade200 : Colors.white,
        );
      },
    );
  }
}
