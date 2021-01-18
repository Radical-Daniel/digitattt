import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:instachatty/ui/chatTemplate/bottom-bar.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instachatty/services/FirebaseHelper.dart';
import 'package:instachatty/constants.dart';
import 'package:instachatty/model/User.dart';
import 'package:uuid/uuid.dart';
import 'package:instachatty/model/momentModel.dart';
import 'package:instachatty/services/Helper.dart';
import 'package:instachatty/ui/chatTemplate/photofilter.dart';
import 'package:instachatty/ui/chatTemplate/SliderCarousel.dart';

class MultiPick extends StatefulWidget {
  final User user;
  MultiPick({this.user});
  @override
  _MultiPickState createState() => new _MultiPickState(user);
}

class _MultiPickState extends State<MultiPick> {
  final User user;
  final fireStoreUtils = FireStoreUtils();

  _MultiPickState(this.user);
  List<Asset> images = List<Asset>();
  List<Image> imagesList = [];
  List<Image> package = [];
  Uuid uuid = Uuid();
  Future<List<Moment>> moments;
  List<String> momentURL = [];

  String _error = 'No Error Detected';

  @override
  void initState() {
    super.initState();
  }

  Widget buildGridView() {
    return GridView.count(
      crossAxisCount: 3,
      children: List.generate(images.length, (index) {
        Asset asset = images[index];
        return FlatButton(
          padding: EdgeInsets.all(0.0),
          onPressed: () {
            // Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Philter());)
          },
          child: AssetThumb(
            asset: asset,
            width: 300,
            height: 300,
          ),
        );
      }),
    );
  }

  Future<void> loadAssets() async {
    List<Asset> resultList = List<Asset>();
    String error = 'No Error Detected';

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 12,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#1DA1F2",
          actionBarTitle: "Select Pictures",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      images = resultList;
      _error = error;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white54,
      child: new Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 40.0),
          ),
          RaisedButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            child: Text(
              "Pick Images",
              style: TextStyle(
                fontSize: 15.0,
              ),
            ),
            onPressed: loadAssets,
          ),
          Expanded(
            child: buildGridView(),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 42.0),
            child: FloatingActionButton(
              onPressed: () async {
                showProgress(context, 'Uploading Moment', false);
                String postID = uuid.v4();
                await Future.forEach(images, (Asset asset) async {
                  String path = await FlutterAbsolutePath.getAbsolutePath(
                      asset.identifier);
                  imagesList.add(new Image.asset(
                    path,
                    fit: BoxFit.cover,
                  ));
                  String pictureID = uuid.v4();
                  print(pictureID);
                  String picture = await fireStoreUtils
                      .uploadUserImageToFireStorage(File(path), pictureID);
                  momentURL.add(picture);
                  print(momentURL.length);

                  setState(() {
                    package = imagesList;
                  });
                });
                await FireStoreUtils.firestore
                    .collection(MOMENTS)
                    .document(user.userID)
                    .collection(MY_MOMENTS)
                    .document(postID)
                    .setData(
                      Moment(urls: momentURL).toJson(),
                    );
                hideProgress();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => SliderCarousel(
                            user: user,
                          )),
                );
              },
              child: Icon(Icons.check_circle_outline),
            ),
          ),
        ],
      ),
    );
  }
}
