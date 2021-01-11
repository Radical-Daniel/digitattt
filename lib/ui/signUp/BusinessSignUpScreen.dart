import 'dart:io';
import 'package:instachatty/ui/home/HomeScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instachatty/constants.dart';
import 'package:instachatty/ui/controlPanels/BusinessControlPanel.dart';
import 'package:instachatty/main.dart';
import 'package:instachatty/model/User.dart';
import 'package:instachatty/services/FirebaseHelper.dart';
import 'package:instachatty/services/Helper.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:uuid/uuid.dart';
import 'package:instachatty/model/Business.dart';
import 'package:instachatty/model/AddressModel.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:country_state_city_picker/country_state_city_picker.dart';

File _image;
ServicesMap servicesMap = ServicesMap(
  services: {
    'doctor': {
      'provides': true,
      'isHealthService': true,
      'rating': 5.0,
      'completedServices': 0
    },
    'pharmacist': {
      'provides': false,
      'isHealthService': true,
      'rating': 5.0,
      'completedServices': 0
    },
    'laboratory': {
      'provides': false,
      'isHealthService': true,
      'rating': 5.0,
      'completedServices': 0
    },
    'radiologist': {
      'provides': false,
      'isHealthService': true,
      'rating': 5.0,
      'completedServices': 0
    },
    // 'ambulance': {'provides' : false, 'isHealthService' : true, 'rating': 5.0,'completedServices': 0},
    // 'hospital': {'provides' : false, 'isHealthService' : true, 'rating': 5.0,'completedServices': 0},
    // 'clinic': {'provides' : false, 'isHealthService' : true, 'rating': 5.0,'completedServices': 0},
    // 'fitness': {'provides' : false, 'isHealthService' : true, 'rating': 5.0,'completedServices': 0},
    // 'hospitality': {'provides' : false, 'isHealthService' : false, 'rating': 5.0,'completedServices': 0},
    // 'insurance': {'provides' : false, 'isHealthService' : false, 'rating': 5.0,'completedServices': 0},
    // 'travel': {'provides' : false, 'isHealthService' : false, 'rating': 5.0,'completedServices': 0},
    // 'wellness': {'provides' : false, 'isHealthService' : false, 'rating': 5.0,'completedServices': 0},
    // 'education': {'provides' : false, 'isHealthService' : false, 'rating': 5.0,'completedServices': 0},
  },
);

class BusinessSignUpScreen extends StatefulWidget {
  final User user;
  BusinessSignUpScreen({@required this.user});
  @override
  State createState() => _SignUpState(user);
}

class _SignUpState extends State<BusinessSignUpScreen> {
  final User user;
  _SignUpState(this.user);
  final ImagePicker _imagePicker = ImagePicker();
  TextEditingController _businessDescriptionController =
      new TextEditingController();
  TextEditingController _businessNameController = new TextEditingController();
  TextEditingController _businessAddressController =
      new TextEditingController();
  GlobalKey<FormState> _key = new GlobalKey();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  AddressModel address;
  String businessName,
      businessDescription,
      businessAddress,
      cityValue,
      stateValue,
      countryValue,
      businessEmail,
      businessPhoneNumber,
      password,
      confirmPassword,
      _phoneNumber,
      _verificationID;
  AutovalidateMode _validate = AutovalidateMode.disabled;
  bool signInWithPhoneNumber = false,
      _isPhoneValid = false,
      _codeSent = false,
      isPartner = false;
  bool isHealthBusiness = false;
  Uuid uuid = Uuid();

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      retrieveLostData();
    }

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back_outlined,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
        backgroundColor: Color(COLOR_PRIMARY),
        title: Text(
          "Business Profile",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
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
        "Add company picture",
        style: TextStyle(fontSize: 15.0),
      ),
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
                            'assets/images/logo.png',
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
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Healthcare Services Partner?"),
            Switch(
              activeColor: Color(COLOR_PRIMARY),
              value: isHealthBusiness,
              onChanged: (bool value) {
                setState(() {
                  isHealthBusiness = value;
                });
                print(isHealthBusiness);
              },
            ),
          ],
        ),
        Visibility(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: FilterChip(
                      selected: servicesMap.services['doctor']['provides'],
                      selectedColor: Color(COLOR_PRIMARY),
                      onSelected: (bool value) {
                        setState(() {
                          servicesMap.services['doctor']['provides'] = value;
                        });
                      },
                      label: Text(
                        "DOCTOR",
                        style: TextStyle(
                            color: servicesMap.services['doctor']['provides']
                                ? Colors.white
                                : Colors.black),
                      ),
                    )),
                Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: FilterChip(
                      selected: servicesMap.services['pharmacist']['provides'],
                      selectedColor: Color(COLOR_PRIMARY),
                      onSelected: (value) {
                        setState(() {
                          servicesMap.services['pharmacist']['provides'] =
                              value;
                        });
                      },
                      label: Text(
                        "PHARMACIST",
                        style: TextStyle(
                            color: servicesMap.services['pharmacist']
                                    ['provides']
                                ? Colors.white
                                : Colors.black),
                      ),
                    )),
                Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: FilterChip(
                      selected: servicesMap.services['laboratory']['provides'],
                      selectedColor: Color(COLOR_PRIMARY),
                      onSelected: (bool value) {
                        setState(() {
                          servicesMap.services['laboratory']['provides'] =
                              value;
                        });
                      },
                      label: Text(
                        "LABORATORY",
                        style: TextStyle(
                            color: servicesMap.services['laboratory']
                                    ['provides']
                                ? Colors.white
                                : Colors.black),
                      ),
                    )),
                Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: FilterChip(
                      selected: servicesMap.services['radiologist']['provides'],
                      selectedColor: Color(COLOR_PRIMARY),
                      onSelected: (bool value) {
                        setState(() {
                          servicesMap.services['radiologist']['provides'] =
                              value;
                        });
                      },
                      label: Text(
                        "RADIOLOGIST",
                        style: TextStyle(
                            color: servicesMap.services['radiologist']
                                    ['provides']
                                ? Colors.white
                                : Colors.black),
                      ),
                    )),
              ],
            ),
          ),
          visible: isHealthBusiness,
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
                        businessName = val;
                      },
                      controller: _businessNameController,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) =>
                          FocusScope.of(context).nextFocus(),
                      decoration: InputDecoration(
                        contentPadding: new EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        fillColor:
                            isDarkMode(context) ? Colors.black54 : Colors.white,
                        hintText: 'Business name',
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
                        businessDescription = val;
                      },
                      controller: _businessDescriptionController,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) =>
                          FocusScope.of(context).nextFocus(),
                      decoration: InputDecoration(
                        contentPadding: new EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        fillColor:
                            isDarkMode(context) ? Colors.black54 : Colors.white,
                        hintText: 'Business description',
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
        Container(
          margin: EdgeInsets.symmetric(horizontal: 18.0, vertical: 2.0),
          child: SelectState(
            onCityChanged: (value) {
              setState(() {
                cityValue = value;
              });
            },
            onCountryChanged: (value) {
              setState(() {
                countryValue = value;
              });
            },
            onStateChanged: (value) {
              print(value);
            },
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
                      onSaved: (String val) {
                        businessAddress = '$val $cityValue $countryValue';
                      },
                      controller: _businessAddressController,
                      textInputAction: TextInputAction.next,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      onFieldSubmitted: (_) =>
                          FocusScope.of(context).nextFocus(),
                      decoration: InputDecoration(
                        contentPadding: new EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        fillColor:
                            isDarkMode(context) ? Colors.black54 : Colors.white,
                        hintText: 'Business address',
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
                    hintText: 'Business Number',
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
                  initialValue: PhoneNumber(),
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
                        businessPhoneNumber = val;
                      },
                      decoration: InputDecoration(
                        contentPadding: new EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        fillColor:
                            isDarkMode(context) ? Colors.black54 : Colors.white,
                        hintText: 'Business phone number',
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
                        businessEmail = val;
                      },
                      decoration: InputDecoration(
                        contentPadding: new EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        fillColor:
                            isDarkMode(context) ? Colors.black54 : Colors.white,
                        hintText: 'Business email address',
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
          visible: !signInWithPhoneNumber || !_codeSent,
          child: Padding(
            padding: const EdgeInsets.only(right: 40.0, left: 40.0, top: 40.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(minWidth: double.infinity),
              child: RaisedButton(
                color: Color(COLOR_PRIMARY),
                child: Text(
                  signInWithPhoneNumber ? 'sendCode'.tr() : 'Submit',
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
      ],
    );
  }

  _sendToServer() async {
    if (_key.currentState.validate()) {
      String businessID = uuid.v4();
      _key.currentState.save();
      showProgress(context, 'creatingNewAccountPleaseWait'.tr(), false);
      var profilePicUrl = '';
      try {
        // AuthResult result = await FirebaseAuth.instance
        //     .createUserWithEmailAndPassword(
        //         email: businessEmail, password: password);
        if (_image != null) {
          profilePicUrl = await FireStoreUtils()
              .uploadBusinessImageToFireStorage(_image, businessID);
          _image = updateProgress('uploadingImagePleaseWait'.tr());
        }
        Business business = Business(
            businessRepID: user.userID,
            businessAbout: businessDescription,
            businessEmail: businessEmail,
            businessName: businessName,
            businessTeam: [
              Employee(employee: user, isVisible: true),
            ],
            businessPhoneNumber: [businessPhoneNumber],
            businessID: businessID,
            isHealthBusiness: isHealthBusiness,
            servicesMap: servicesMap,
            lastOnlineTimestamp: Timestamp.now(),
            active: true,
            // fcmToken: await FirebaseMessaging().getToken(),
            businessAddress: [
              await AddressModel(address: businessAddress).geoAddress(),
            ],
            businessLogoURL: profilePicUrl);
        await FireStoreUtils.firestore
            .collection(BUSINESSES)
            .document(businessID)
            .setData(business.toJson());
        user.isPartner = true;
        user.businessAffiliations.add(businessID);
        FireStoreUtils.updateUserState(user);
        hideProgress();
        pushAndRemoveUntil(
            context,
            HomeScreen(
              user: user,
              business: business,
            ),
            false);
      } catch (error) {
        print(user.fullName());
        print(error.toString());
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
    _businessDescriptionController.dispose();
    _businessNameController.dispose();
    _businessAddressController.dispose();
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
          pushAndRemoveUntil(context, BusinessControlPanel(user: user), false);
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
        firstName: _businessNameController.text ?? 'Anonymous',
        lastName: _businessAddressController.text ?? 'User',
        email: '',
        profilePictureURL: profilePicUrl,
        active: true,
        fcmToken: await FireStoreUtils.firebaseMessaging.getToken(),
        lastOnlineTimestamp: Timestamp.now(),
        phoneNumber: _phoneNumber,
        isPartner: false,
        settings: Settings(allowPushNotifications: true),
        userID: userID);
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
