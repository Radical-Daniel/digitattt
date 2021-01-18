import 'package:easy_popup/easy_popup.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:easy_localization/easy_localization.dart' as easyLocal;
import 'package:image_picker/image_picker.dart';
import 'package:instachatty/services/FirebaseHelper.dart';
import 'package:instachatty/services/Helper.dart';
import 'package:instachatty/model/MessageData.dart';
import 'dart:io';
import 'package:instachatty/model/ChatVideoContainer.dart';
import 'package:instachatty/constants.dart';
import 'package:instachatty/ui/chatTemplate/multipick.dart';
import 'package:instachatty/model/User.dart';

class DropDownMenu extends StatefulWidget with EasyPopupChild {
  final User user;
  DropDownMenu({this.user});
  final _PopController controller = _PopController();

  @override
  _DropDownMenuState createState() => _DropDownMenuState(user);

  @override
  dismiss() {
    controller.dismiss();
  }
}

class _DropDownMenuState extends State<DropDownMenu>
    with SingleTickerProviderStateMixin {
  final User user;
  _DropDownMenuState(this.user);
  FireStoreUtils _fireStoreUtils = FireStoreUtils();
  final ImagePicker _imagePicker = ImagePicker();

  Animation<Offset> _animation;
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    widget.controller._bindState(this);
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _animation = Tween<Offset>(begin: Offset(0, -1), end: Offset.zero)
        .animate(_controller);
    _controller.forward();
  }

  dismiss() {
    _controller?.reverse();
  }

  @override
  void dispose() {
    super.dispose();
    _controller?.dispose();
  }

  PickedFile image;

  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: MultiPick(
        user: user,
      ),
    );
  }

  _onCameraClick() {
    final action = CupertinoActionSheet(
      message: Text(
        "sendMedia",
        style: TextStyle(fontSize: 15.0),
      ).tr(),
      actions: [
        CupertinoActionSheetAction(
          child: Text("chooseImageFromGallery").tr(),
          isDefaultAction: false,
          onPressed: () async {
            Navigator.pop(context);
            PickedFile image =
                await _imagePicker.getImage(source: ImageSource.gallery);
            if (image != null) {
              Url url = await _fireStoreUtils.uploadChatImageToFireStorage(
                  File(image.path), context);
            }
          },
        ),
        CupertinoActionSheetAction(
          child: Text("chooseVideoFromGallery").tr(),
          isDefaultAction: false,
          onPressed: () async {
            Navigator.pop(context);
            PickedFile galleryVideo =
                await _imagePicker.getVideo(source: ImageSource.gallery);
            if (galleryVideo != null) {
              ChatVideoContainer videoContainer =
                  await _fireStoreUtils.uploadChatVideoToFireStorage(
                      File(galleryVideo.path), context);
            }
          },
        ),
        CupertinoActionSheetAction(
          child: Text("takeAPicture").tr(),
          isDestructiveAction: false,
          onPressed: () async {
            Navigator.pop(context);
            PickedFile image =
                await _imagePicker.getImage(source: ImageSource.camera);
            if (image != null) {
              Url url = await _fireStoreUtils.uploadChatImageToFireStorage(
                  File(image.path), context);
            }
          },
        ),
        CupertinoActionSheetAction(
          child: Text("recordVideo").tr(),
          isDestructiveAction: false,
          onPressed: () async {
            Navigator.pop(context);
            PickedFile recordedVideo =
                await _imagePicker.getVideo(source: ImageSource.camera);
            if (recordedVideo != null) {
              ChatVideoContainer videoContainer =
                  await _fireStoreUtils.uploadChatVideoToFireStorage(
                      File(recordedVideo.path), context);
            }
          },
        ),
      ],
      cancelButton: CupertinoActionSheetAction(
        child: Text(
          "cancel",
        ).tr(),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
    showCupertinoModalPopup(context: context, builder: (context) => action);
  }
}

class _PopController {
  _DropDownMenuState state;

  _bindState(_DropDownMenuState state) {
    this.state = state;
  }

  dismiss() {
    state?.dismiss();
  }
}
