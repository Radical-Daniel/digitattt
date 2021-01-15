import 'dart:io';
import 'package:instachatty/ui/home/HomeScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart' as easyLocal;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instachatty/constants.dart';
import 'package:instachatty/main.dart';
import 'package:instachatty/model/User.dart';
import 'package:instachatty/services/FirebaseHelper.dart';
import 'package:instachatty/services/Helper.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

File _image;

class SignUpScreen extends StatefulWidget {
  @override
  State createState() => _SignUpState();
}

class _SignUpState extends State<SignUpScreen> {
  final ImagePicker _imagePicker = ImagePicker();
  TextEditingController _passwordController = new TextEditingController();
  TextEditingController _firstNameController = new TextEditingController();
  TextEditingController _lastNameController = new TextEditingController();
  GlobalKey<FormState> _key = new GlobalKey();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  String firstName,
      lastName,
      email,
      mobile,
      password,
      confirmPassword,
      _phoneNumber,
      _verificationID;
  AutovalidateMode _validate = AutovalidateMode.disabled;
  bool signInWithPhoneNumber = false,
      _isPhoneValid = false,
      _codeSent = false,
      isPartner = false;

  InterestMap interest = InterestMap(interest: {
    'customer': true,
    'doctor': false,
    'pharmacist': false,
    'laboratory': false,
    'retail': false,
    'ambulance': false,
    'radiologist': false,
    'hospital': false,
    'clinic': false,
    'fitness': false,
    'hospitality': false,
    'insurance': false,
    'travel': false,
    'wellness': false,
    'student': false,
    'education': false
  });

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      retrieveLostData();
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(
            color: isDarkMode(context) ? Colors.white : Colors.black),
      ),
      body: SingleChildScrollView(
        child: new Container(
          margin: new EdgeInsets.only(left: 16.0, right: 16, bottom: 16),
          child: new Form(
            key: _key,
            autovalidateMode: _validate,
            child: formUI(),
          ),
        ),
      ),
    );
  }

  Future<void> retrieveLostData() async {
    final LostData response = await _imagePicker.getLostData();
    if (response == null) {
      return;
    }
    if (response.file != null) {
      setState(() {
        _image = File(response.file.path);
      });
    }
  }

  _onCameraClick() {
    final action = CupertinoActionSheet(
      message: Text(
        "addProfilePicture",
        style: TextStyle(fontSize: 15.0),
      ).tr(),
      actions: <Widget>[
        CupertinoActionSheetAction(
          child: Text("chooseFromGallery").tr(),
          isDefaultAction: false,
          onPressed: () async {
            Navigator.pop(context);
            PickedFile image =
                await _imagePicker.getImage(source: ImageSource.gallery);
            setState(() {
              _image = File(image.path);
            });
          },
        ),
        CupertinoActionSheetAction(
          child: Text("takeAPicture").tr(),
          isDestructiveAction: false,
          onPressed: () async {
            Navigator.pop(context);
            PickedFile image =
                await _imagePicker.getImage(source: ImageSource.camera);
            setState(() {
              _image = File(image.path);
            });
          },
        )
      ],
      cancelButton: CupertinoActionSheetAction(
        child: Text("cancel").tr(),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
    showCupertinoModalPopup(context: context, builder: (context) => action);
  }

  Widget formUI() {
    return new Column(
      children: <Widget>[
        new Align(
            alignment: Directionality.of(context) == TextDirection.ltr
                ? Alignment.topLeft
                : Alignment.topRight,
            child: Text(
              'createNewAccount',
              style: TextStyle(
                  color: Color(COLOR_PRIMARY),
                  fontWeight: FontWeight.bold,
                  fontSize: 25.0),
            ).tr()),
        Padding(
          padding:
              const EdgeInsets.only(left: 8.0, top: 32, right: 8, bottom: 8),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: <Widget>[
              CircleAvatar(
                radius: 65,
                backgroundColor: isDarkMode(context)
                    ? Colors.grey[700]
                    : Colors.grey.shade400,
                child: ClipOval(
                  child: SizedBox(
                    width: 170,
                    height: 170,
                    child: _image == null
                        ? Image.asset(
                            'assets/images/placeholder.jpg',
                            fit: BoxFit.cover,
                          )
                        : Image.file(
                            _image,
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
              ),
              Positioned.directional(
                textDirection: Directionality.of(context),
                start: 80,
                end: 0,
                child: FloatingActionButton(
                    backgroundColor: Color(COLOR_ACCENT),
                    child: Icon(
                      Icons.camera_alt,
                      color: isDarkMode(context) ? Colors.black : Colors.white,
                    ),
                    mini: true,
                    onPressed: _onCameraClick),
              )
            ],
          ),
        ),
        Visibility(
          visible: !_codeSent,
          child: ConstrainedBox(
              constraints: BoxConstraints(minWidth: double.infinity),
              child: Padding(
                  padding:
                      const EdgeInsets.only(top: 16.0, right: 8.0, left: 8.0),
                  child: TextFormField(
                      validator: validateName,
                      onSaved: (String val) {
                        firstName = val;
                      },
                      controller: _firstNameController,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) =>
                          FocusScope.of(context).nextFocus(),
                      decoration: InputDecoration(
                        contentPadding: new EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        fillColor:
                            isDarkMode(context) ? Colors.black54 : Colors.white,
                        hintText: easyLocal.tr('firstName'),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: BorderSide(
                                color: Color(COLOR_PRIMARY), width: 2.0)),
                        errorBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Theme.of(context).errorColor),
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Theme.of(context).errorColor),
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey[200]),
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                      )))),
        ),
        Visibility(
          visible: !_codeSent,
          child: ConstrainedBox(
              constraints: BoxConstraints(minWidth: double.infinity),
              child: Padding(
                  padding:
                      const EdgeInsets.only(top: 16.0, right: 8.0, left: 8.0),
                  child: TextFormField(
                      validator: validateName,
                      onSaved: (String val) {
                        lastName = val;
                      },
                      controller: _lastNameController,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) =>
                          FocusScope.of(context).nextFocus(),
                      decoration: InputDecoration(
                        contentPadding: new EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        fillColor:
                            isDarkMode(context) ? Colors.black54 : Colors.white,
                        hintText: 'lastName'.tr(),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: BorderSide(
                                color: Color(COLOR_PRIMARY), width: 2.0)),
                        errorBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Theme.of(context).errorColor),
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Theme.of(context).errorColor),
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey[200]),
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                      )))),
        ),
        Visibility(
          visible: signInWithPhoneNumber && !_codeSent,
          child: Padding(
            padding: EdgeInsets.only(top: 16.0, right: 8.0, left: 8.0),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  shape: BoxShape.rectangle,
                  border: Border.all(color: Colors.grey[200])),
              child: InternationalPhoneNumberInput(
                  onInputChanged: (PhoneNumber number) =>
                      _phoneNumber = number.phoneNumber,
                  onInputValidated: (bool value) => _isPhoneValid = value,
                  ignoreBlank: true,
                  autoValidateMode: AutovalidateMode.onUserInteraction,
                  inputDecoration: InputDecoration(
                    hintText: 'phoneNumber'.tr(),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    isDense: true,
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                  ),
                  inputBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                  initialValue: PhoneNumber(isoCode: 'US'),
                  selectorConfig: SelectorConfig(
                      selectorType: PhoneInputSelectorType.DIALOG)),
            ),
          ),
        ),
        Visibility(
          visible: signInWithPhoneNumber && _codeSent,
          child: Padding(
            padding: EdgeInsets.only(top: 32.0, right: 24.0, left: 24.0),
            child: PinCodeTextField(
              appContext: context,
              length: 6,
              keyboardType: TextInputType.phone,
              backgroundColor: Colors.transparent,
              pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(5),
                  fieldHeight: 40,
                  fieldWidth: 40,
                  activeColor: Color(COLOR_PRIMARY),
                  activeFillColor: Colors.grey[100],
                  selectedFillColor: Colors.transparent,
                  selectedColor: Color(COLOR_PRIMARY),
                  inactiveColor: Colors.grey[600],
                  inactiveFillColor: Colors.transparent),
              enableActiveFill: true,
              onCompleted: (v) {
                _submitCode(v);
              },
              onChanged: (value) {
                print(value);
              },
            ),
          ),
        ),
        Visibility(
          visible: !signInWithPhoneNumber,
          child: ConstrainedBox(
              constraints: BoxConstraints(minWidth: double.infinity),
              child: Padding(
                  padding:
                      const EdgeInsets.only(top: 16.0, right: 8.0, left: 8.0),
                  child: TextFormField(
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) =>
                          FocusScope.of(context).nextFocus(),
                      validator: validateMobile,
                      onSaved: (String val) {
                        mobile = val;
                      },
                      decoration: InputDecoration(
                        contentPadding: new EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        fillColor:
                            isDarkMode(context) ? Colors.black54 : Colors.white,
                        hintText: 'mobileNumber'.tr(),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: BorderSide(
                                color: Color(COLOR_PRIMARY), width: 2.0)),
                        errorBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Theme.of(context).errorColor),
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Theme.of(context).errorColor),
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey[200]),
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                      )))),
        ),
        Visibility(
          visible: !signInWithPhoneNumber,
          child: ConstrainedBox(
              constraints: BoxConstraints(minWidth: double.infinity),
              child: Padding(
                  padding:
                      const EdgeInsets.only(top: 16.0, right: 8.0, left: 8.0),
                  child: TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) =>
                          FocusScope.of(context).nextFocus(),
                      validator: validateEmail,
                      onSaved: (String val) {
                        email = val;
                      },
                      decoration: InputDecoration(
                        contentPadding: new EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        fillColor:
                            isDarkMode(context) ? Colors.black54 : Colors.white,
                        hintText: 'emailAddress'.tr(),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: BorderSide(
                                color: Color(COLOR_PRIMARY), width: 2.0)),
                        errorBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Theme.of(context).errorColor),
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Theme.of(context).errorColor),
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey[200]),
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                      )))),
        ),
        Visibility(
          visible: !signInWithPhoneNumber,
          child: ConstrainedBox(
              constraints: BoxConstraints(minWidth: double.infinity),
              child: Padding(
                padding:
                    const EdgeInsets.only(top: 16.0, right: 8.0, left: 8.0),
                child: TextFormField(
                    obscureText: true,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                    controller: _passwordController,
                    validator: validatePassword,
                    onSaved: (String val) {
                      password = val;
                    },
                    style: TextStyle(height: 0.8, fontSize: 18.0),
                    cursorColor: Color(COLOR_PRIMARY),
                    decoration: InputDecoration(
                      contentPadding:
                          new EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      fillColor:
                          isDarkMode(context) ? Colors.black54 : Colors.white,
                      hintText: 'password'.tr(),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: BorderSide(
                              color: Color(COLOR_PRIMARY), width: 2.0)),
                      errorBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Theme.of(context).errorColor),
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Theme.of(context).errorColor),
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey[200]),
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                    )),
              )),
        ),
        Visibility(
          visible: !signInWithPhoneNumber,
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: double.infinity),
            child: Padding(
              padding: const EdgeInsets.only(top: 16.0, right: 8.0, left: 8.0),
              child: TextFormField(
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) {
                    _sendToServer();
                  },
                  obscureText: true,
                  validator: (val) =>
                      validateConfirmPassword(_passwordController.text, val),
                  onSaved: (String val) {
                    confirmPassword = val;
                  },
                  style: TextStyle(height: 0.8, fontSize: 18.0),
                  cursorColor: Color(COLOR_PRIMARY),
                  decoration: InputDecoration(
                    contentPadding:
                        new EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    fillColor:
                        isDarkMode(context) ? Colors.black54 : Colors.white,
                    hintText: 'confirmPassword'.tr(),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide(
                            color: Color(COLOR_PRIMARY), width: 2.0)),
                    errorBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Theme.of(context).errorColor),
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Theme.of(context).errorColor),
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey[200]),
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                  )),
            ),
          ),
        ),
        Visibility(
          visible: !signInWithPhoneNumber || !_codeSent,
          child: Padding(
            padding: const EdgeInsets.only(right: 40.0, left: 40.0, top: 40.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(minWidth: double.infinity),
              child: RaisedButton(
                color: Color(COLOR_PRIMARY),
                child: Text(
                  signInWithPhoneNumber ? 'sendCode'.tr() : 'signUp'.tr(),
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                textColor: isDarkMode(context) ? Colors.black : Colors.white,
                splashColor: Color(COLOR_PRIMARY),
                onPressed: () => _signUp(),
                padding: EdgeInsets.only(top: 12, bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  side: BorderSide(
                    color: Color(COLOR_PRIMARY),
                  ),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(32.0),
          child: Center(
            child: Text(
              'or',
              style: TextStyle(
                  color: isDarkMode(context) ? Colors.white : Colors.black),
            ).tr(),
          ),
        ),
        InkWell(
          onTap: () {
            setState(() {
              signInWithPhoneNumber = !signInWithPhoneNumber;
            });
          },
          child: Text(
            signInWithPhoneNumber
                ? 'signUpWithEmail'.tr()
                : 'signUpWithPhoneNumber'.tr(),
            style: TextStyle(
                color: Colors.lightBlue,
                fontWeight: FontWeight.bold,
                fontSize: 15,
                letterSpacing: 1),
          ).tr(),
        )
      ],
    );
  }

  _sendToServer() async {
    if (_key.currentState.validate()) {
      _key.currentState.save();
      showProgress(context, 'creatingNewAccountPleaseWait'.tr(), false);
      var profilePicUrl = '';
      try {
        AuthResult result = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
        if (_image != null) {
          updateProgress('uploadingImagePleaseWait'.tr());
          profilePicUrl = await FireStoreUtils()
              .uploadUserImageToFireStorage(_image, result.user.uid);
        }
        User user = User(
            email: email,
            firstName: firstName,
            phoneNumber: mobile,
            userID: result.user.uid,
            lastOnlineTimestamp: Timestamp.now(),
            active: true,
            fcmToken: await FirebaseMessaging().getToken(),
            lastName: lastName,
            interestMap: interest,
            isPartner: isPartner,
            partnerEnabled: false,
            businessAffiliations: [''],
            settings: Settings(allowPushNotifications: true),
            profilePictureURL: profilePicUrl);
        await FireStoreUtils.firestore
            .collection(USERS)
            .document(result.user.uid)
            .setData(user.toJson());
        hideProgress();
        print("here we are!!");
        MyAppState.currentUser = user;
        pushAndRemoveUntil(context, HomeScreen(user: user), false);
      } catch (error) {
        hideProgress();
        (error as PlatformException).code != 'ERROR_EMAIL_ALREADY_IN_USE'
            ? showAlertDialog(context, 'failed'.tr(), 'couldNotSignUp'.tr())
            : showAlertDialog(context, 'failed'.tr(), 'emailAlreadyInUse'.tr());
        print(error.toString());
      }
    } else {
      setState(() {
        _validate = AutovalidateMode.onUserInteraction;
      });
    }
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _image = null;
    super.dispose();
  }

  _signUp() async {
    signInWithPhoneNumber ? _submitPhoneNumber(_phoneNumber) : _sendToServer();
  }

  _submitPhoneNumber(String phoneNumber) {
    if (_isPhoneValid) {
      //send code
      setState(() {
        _codeSent = true;
      });
      FirebaseAuth _auth = FirebaseAuth.instance;
      _auth.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          timeout: Duration(minutes: 2),
          verificationCompleted: (AuthCredential phoneAuthCredential) {},
          verificationFailed: (AuthException error) {
            print('${error.message}');
          },
          codeSent: (String verificationId, [int forceResendingToken]) {
            _verificationID = verificationId;
          },
          codeAutoRetrievalTimeout: (String verificationId) {
            _scaffoldKey.currentState
                .showSnackBar(SnackBar(content: Text('codeTimeOut').tr()));
            setState(() {
              _codeSent = false;
            });
          });
    }
  }

  void _submitCode(String code) async {
    showProgress(context, 'signingUp'.tr(), false);
    try {
      AuthCredential credential = PhoneAuthProvider.getCredential(
          verificationId: _verificationID, smsCode: code);
      await FirebaseAuth.instance
          .signInWithCredential(credential)
          .then((AuthResult authResult) async {
        User user = await FireStoreUtils().getCurrentUser(authResult.user.uid);
        if (user == null) {
          _createUserFromPhoneLogin(authResult.user.uid);
        } else {
          MyAppState.currentUser = user;
          hideProgress();
          pushAndRemoveUntil(context, HomeScreen(user: user), false);
        }
      });
    } catch (exception) {
      hideProgress();
      String message = 'anErrorOccurredTryAgain'.tr();
      switch ((exception as PlatformException).code) {
        case 'ERROR_INVALID_CREDENTIAL':
          message = 'invalidCodeOrExpired'.tr();
          break;
        case 'ERROR_USER_DISABLED':
          message = 'userDisabled'.tr();
          break;
        default:
          message = 'anErrorOccurredTryAgain'.tr();
          break;
      }
      _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message)));
    }
  }

  void _createUserFromPhoneLogin(String userID) async {
    var profilePicUrl = '';
    if (_image != null) {
      updateProgress('uploadingImagePleaseWait'.tr());
      profilePicUrl =
          await FireStoreUtils().uploadUserImageToFireStorage(_image, userID);
    }
    User user = User(
        firstName: _firstNameController.text ?? 'Anonymous',
        lastName: _lastNameController.text ?? 'User',
        email: '',
        profilePictureURL: profilePicUrl,
        active: true,
        fcmToken: await FireStoreUtils.firebaseMessaging.getToken(),
        lastOnlineTimestamp: Timestamp.now(),
        phoneNumber: _phoneNumber,
        isPartner: true,
        partnerEnabled: false,
        settings: Settings(allowPushNotifications: true),
        userID: userID);
    user.partnerEnabled = false;
    user.isPartner = false;
    await FireStoreUtils.firestore
        .collection(USERS)
        .document(userID)
        .setData(user.toJson())
        .then((onValue) {
      MyAppState.currentUser = null;

      MyAppState.currentUser = user;
      hideProgress();
      pushAndRemoveUntil(context, HomeScreen(user: user), false);
    });
  }
}
