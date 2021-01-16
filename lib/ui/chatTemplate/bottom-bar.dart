import 'package:flutter/material.dart';
import 'package:instachatty/ui/chatTemplate/slider.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

Color color = Color(0xffff024a);

class BottomBar extends StatefulWidget {
  final List images;
  BottomBar({Key key, this.images}) : super(key: key);

  _BottomBarState createState() => _BottomBarState(images);
}

class _BottomBarState extends State<BottomBar> {
  final List images;
  _BottomBarState(this.images);
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
                  child: images != null
                      ? SliderCarousel(
                          images: images,
                        )
                      : SliderCarousel(),
                ),
              );
            });
      },
    );
  }
}
