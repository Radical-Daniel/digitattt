import 'package:flutter/material.dart';

import 'package:line_icons/line_icons.dart';

class IconGridCard extends StatefulWidget {
  IconGridCard({this.text, this.icon, this.onPressed, this.color});
  final String text;
  final IconData icon;
  final onPressed;
  final Color color;
  @override
  _IconGridCardState createState() => _IconGridCardState();
}

class _IconGridCardState extends State<IconGridCard> {
  static List<IconData> iconList = [
    LineIcons.medkit,
    LineIcons.life_saver,
    LineIcons.eyedropper,
    LineIcons.shopping_cart,
    LineIcons.ambulance,
    LineIcons.y_combinator,
    LineIcons.hospital_o,
    LineIcons.university,
    LineIcons.bicycle,
    LineIcons.hotel,
    LineIcons.balance_scale,
    LineIcons.plane,
    LineIcons.apple,
    LineIcons.book,
    LineIcons.suitcase,
  ];
  static List<String> interestList = [
    'Doctor',
    'Pharmacist',
    'Laboratory',
    'Retail',
    'Ambulance',
    'Radiologist',
    'Hospital',
    'Clinic',
    'Fitness',
    'Hospitality',
    'Insurance',
    'Travel',
    'Wellness',
    'Student',
    'Education',
  ];

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        color: Colors.white,
        elevation: 10.0,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 25.0),
          child: FlatButton(
            onPressed: widget.onPressed,
            child: Column(
              children: [
                Center(
                  child: Icon(
                    widget.icon,
                    size: 70.0,
                    color: widget.color,
                  ),
                ),
                Text(
                  widget.text,
                  style: TextStyle(
                    color: widget.color,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
