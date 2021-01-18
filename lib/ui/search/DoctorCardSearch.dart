import 'package:easy_localization/easy_localization.dart';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instachatty/constants.dart';
import 'package:instachatty/model/ContactModel.dart';
import 'package:instachatty/model/ConversationModel.dart';
import 'package:instachatty/model/HomeConversationModel.dart';
import 'package:instachatty/model/User.dart';
import 'package:instachatty/services/FirebaseHelper.dart';
import 'package:instachatty/services/Helper.dart';
import 'package:instachatty/ui/chat/ChatScreen.dart';
import 'package:instachatty/ui/chat/ChatInfoScreen.dart';
import 'package:provider/provider.dart';
import 'package:instachatty/model/Business.dart';
import 'package:instachatty/model/BookingRequest.dart';
import 'package:instachatty/ui/home/HomeScreen.dart';
import 'package:uuid/uuid.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instachatty/model/MessageData.dart';
import 'package:instachatty/model/ChatVideoContainer.dart';
import 'package:instachatty/ui/controlPanels/CustomerControlPanel.dart';
import 'package:line_icons/line_icons.dart';
import 'package:instachatty/model/notifications.dart';
import 'package:instachatty/model/Deal.dart';

List<Business> _searchResult = [];
Map<String, dynamic> _filterList = {
  'customer': false,
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
};
TextEditingController requestDetailsController = TextEditingController();
List<Business> _businesses = [];

class BuildContactInfo extends ChangeNotifier {
  User user;
  User contact;
  User selectedContact;

  void updateSelectedContact(contact) {
    selectedContact = contact;
    notifyListeners();
  }

  ChatInfoScreen createChatInfo(contact) {
    return ChatInfoScreen(
      user: user,
      member: contact,
    );
  }
}

class DoctorServicesSearchScreen extends StatefulWidget {
  final String type;
  final User user;

  const DoctorServicesSearchScreen(
      {Key key, @required this.user, @required this.type})
      : super(key: key);

  @override
  _DoctorServicesSearchScreenState createState() =>
      _DoctorServicesSearchScreenState(user, type);
}

class _DoctorServicesSearchScreenState
    extends State<DoctorServicesSearchScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final String type;
  double _locationSliderValue = 15;
  final ImagePicker _imagePicker = ImagePicker();
  PickedFile image;
  bool isLoadingPic = false;
  bool doneLoadingPic = false;
  TextEditingController _messageController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  Uuid uuid = Uuid();
  String details = '';
  final User user;
  String url = '';
  TextEditingController controller = new TextEditingController();
  final fireStoreUtils = FireStoreUtils();
  // bool doctorChipSelected = false,
  //     pharmacistChipSelected = false,
  //     laboratoryChipSelected = false,
  //     retailChipSelected = false,
  //     ambulanceChipSelected = false,
  //     radiologistChipSelected = false,
  //     hospitalChipSelected = false,
  //     clinicChipSelected = false,
  //     fitnessChipSelected = false,
  //     hospitalityChipSelected = false,
  //     insuranceChipSelected = false,
  //     travelChipSelected = false,
  //     wellnessChipSelected = false,
  //     studentChipSelected = false,
  //     educationChipSelected = false;
  _DoctorServicesSearchScreenState(this.user, this.type);

  Future<List<Business>> _future;
  User selectedContact;

  @override
  void initState() {
    _future = fireStoreUtils.getBusinesses(user.userID, true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    return ChangeNotifierProvider.value(
      value: selectedContact,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Color(COLOR_PRIMARY),
          title: Text(
            "digit@T",
            style: TextStyle(fontFamily: 'Bauhaus93'),
            textAlign: TextAlign.center,
          ),
        ),
        body: Column(
          children: <Widget>[
            Padding(
              padding:
                  const EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 4),
              child: TextField(
                controller: controller,
                onChanged: _onSearchFilterChanged,
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(0),
                    isDense: true,
                    fillColor: isDarkMode(context)
                        ? Colors.grey[700]
                        : Colors.grey[200],
                    filled: true,
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(360),
                        ),
                        borderSide: BorderSide(style: BorderStyle.none)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(360),
                        ),
                        borderSide: BorderSide(style: BorderStyle.none)),
                    hintText: 'Search for a $type',
                    suffixIcon: IconButton(
                      iconSize: 20,
                      icon: Icon(Icons.close),
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        controller.clear();
                        _onSearchFilterChanged('');
                      },
                    ),
                    // prefix: Icon(Icons.location_on_outlined),
                    prefixIcon: Icon(
                      Icons.search,
                      size: 20,
                    )),
              ),
            ),
            Center(
              child: Text(
                "Distance :" + _locationSliderValue.round().toString() + "km",
                style: TextStyle(
                  color: Color(COLOR_PRIMARY),
                  fontSize: 16.0,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 14.0,
                vertical: 0.0,
              ),
              child: SliderTheme(
                data: SliderThemeData(
                  thumbColor: Color(COLOR_PRIMARY),
                  disabledThumbColor: Colors.grey,
                  activeTrackColor: Color(COLOR_PRIMARY_DARK),
                  activeTickMarkColor: Colors.black,
                ),
                child: Slider(
                  value: _locationSliderValue,
                  min: 1,
                  max: 50,
                  divisions: 23,
                  label: _locationSliderValue.round().toString(),
                  onChanged: (double value) {
                    setState(() {
                      _locationSliderValue = value;
                    });
                  },
                ),
              ),
            ),
            FutureBuilder<List<Business>>(
              future: _future,
              initialData: [],
              builder: (context, snap) {
                if (snap.connectionState == ConnectionState.waiting) {
                  return Expanded(
                    child: Container(
                      child: Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Color(COLOR_ACCENT)),
                        ),
                      ),
                    ),
                  );
                } else if (!snap.hasData || snap.data.isEmpty) {
                  return Expanded(
                    child: Center(
                      child: Text(
                        'No ${type}s found',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  );
                } else {
                  return Expanded(
                    child: _searchResult.length != 0 ||
                            controller.text.isNotEmpty
                        ? new ListView.builder(
                            itemCount: _searchResult.length,
                            itemBuilder: (context, index) {
                              Business business = _searchResult[index];
                              return Column(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 4.0, bottom: 4.0),
                                    child: ListTile(
                                      onTap: () async {
                                        String channelID;
                                        if (business.businessID
                                                .compareTo(user.userID) <
                                            0) {
                                          channelID =
                                              business.businessID + user.userID;
                                        } else {
                                          channelID =
                                              user.userID + business.businessID;
                                        }
                                        ConversationModel conversationModel =
                                            await fireStoreUtils
                                                .getChannelByIdOrNull(
                                                    channelID);
                                        List<Card> createServiceCards() {
                                          List<Card> serviceCards = business
                                              .servicesMap.services.keys
                                              .where((service) =>
                                                  business.servicesMap
                                                          .services[service]
                                                      ['provides'] ==
                                                  true)
                                              .map((service) => Card(
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 10.0),
                                                    color: Colors.white70,
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 28.0,
                                                          vertical: 10.0),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        children: [
                                                          Text(
                                                            service,
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        18.0,
                                                                    vertical:
                                                                        5.0),
                                                            child: Image.asset(
                                                              'assets/images/$service.png',
                                                              width: 50.0,
                                                              height: 50.0,
                                                            ),
                                                          ),
                                                          Row(
                                                            children: [
                                                              Icon(
                                                                Icons.star,
                                                                color: Colors
                                                                    .orange,
                                                              ),
                                                              Text(
                                                                business
                                                                    .servicesMap
                                                                    .services[
                                                                        service]
                                                                        [
                                                                        'rating']
                                                                    .toString(),
                                                              ),
                                                            ],
                                                          ),
                                                          RaisedButton(
                                                            color: Color(
                                                                COLOR_PRIMARY),
                                                            child: Text(
                                                              "Select",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                            onPressed: () {
                                                              showDialog(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (context) {
                                                                    return Dialog(
                                                                      shape: RoundedRectangleBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(40)),
                                                                      elevation:
                                                                          16,
                                                                      child:
                                                                          Container(
                                                                        height:
                                                                            200,
                                                                        width:
                                                                            350,
                                                                        child:
                                                                            Padding(
                                                                          padding: const EdgeInsets.only(
                                                                              top: 40.0,
                                                                              left: 16,
                                                                              right: 16,
                                                                              bottom: 16),
                                                                          child:
                                                                              Column(
                                                                            mainAxisSize:
                                                                                MainAxisSize.max,
                                                                            children: <Widget>[
                                                                              Visibility(
                                                                                visible: image.path.isNotEmpty && (!isLoadingPic || doneLoadingPic),
                                                                                child: SizedBox(
                                                                                  height: 100.0,
                                                                                  child: !doneLoadingPic
                                                                                      ? CircularProgressIndicator(
                                                                                          valueColor: AlwaysStoppedAnimation<Color>(Color(COLOR_ACCENT)),
                                                                                        )
                                                                                      : SingleChildScrollView(
                                                                                          child: Column(
                                                                                            children: [
                                                                                              Image.file(
                                                                                                File(image.path),
                                                                                                fit: BoxFit.cover,
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                        ),
                                                                                ),
                                                                              ),
                                                                              Padding(
                                                                                padding: const EdgeInsets.only(top: 8.0),
                                                                                child: Row(
                                                                                  children: <Widget>[
                                                                                    IconButton(
                                                                                      onPressed: () {
                                                                                        _onCameraClick();
                                                                                      },
                                                                                      icon: Icon(
                                                                                        Icons.camera_alt,
                                                                                        color: Color(COLOR_PRIMARY),
                                                                                      ),
                                                                                    ),
                                                                                    Expanded(
                                                                                        child: Padding(
                                                                                            padding: const EdgeInsets.only(left: 2.0, right: 2, top: 5.0),
                                                                                            child: Container(
                                                                                              padding: EdgeInsets.all(2),
                                                                                              decoration: ShapeDecoration(
                                                                                                shape: OutlineInputBorder(
                                                                                                    borderRadius: BorderRadius.all(
                                                                                                      Radius.circular(360),
                                                                                                    ),
                                                                                                    borderSide: BorderSide(style: BorderStyle.none)),
                                                                                                color: isDarkMode(context) ? Colors.grey[700] : Colors.grey.shade200,
                                                                                              ),
                                                                                              child: Row(
                                                                                                children: <Widget>[
                                                                                                  // InkWell(
                                                                                                  //   onTap: () => {},
                                                                                                  //   child: Icon(
                                                                                                  //     Icons.mic,
                                                                                                  //     // color: currentRecordingState == RecordingState.HIDDEN ? Color(COLOR_PRIMARY) : Colors.red,
                                                                                                  //   ),
                                                                                                  // ),
                                                                                                  Expanded(
                                                                                                    child: TextField(
                                                                                                      onChanged: (s) {
                                                                                                        setState(() {});
                                                                                                      },
                                                                                                      onTap: () {
                                                                                                        setState(() {
                                                                                                          // currentRecordingState = RecordingState.HIDDEN;
                                                                                                        });
                                                                                                      },
                                                                                                      textAlignVertical: TextAlignVertical.center,
                                                                                                      controller: _messageController,
                                                                                                      decoration: InputDecoration(
                                                                                                        isDense: true,
                                                                                                        contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                                                                                                        hintText: 'Details',
                                                                                                        hintStyle: TextStyle(color: Colors.grey[400]),
                                                                                                        focusedBorder: OutlineInputBorder(
                                                                                                            borderRadius: BorderRadius.all(
                                                                                                              Radius.circular(360),
                                                                                                            ),
                                                                                                            borderSide: BorderSide(style: BorderStyle.none)),
                                                                                                        enabledBorder: OutlineInputBorder(
                                                                                                            borderRadius: BorderRadius.all(
                                                                                                              Radius.circular(360),
                                                                                                            ),
                                                                                                            borderSide: BorderSide(style: BorderStyle.none)),
                                                                                                      ),
                                                                                                      textCapitalization: TextCapitalization.sentences,
                                                                                                      maxLines: 5,
                                                                                                      minLines: 1,
                                                                                                      keyboardType: TextInputType.multiline,
                                                                                                    ),
                                                                                                  ),
                                                                                                ],
                                                                                              ),
                                                                                            ))),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                              Padding(
                                                                                padding: const EdgeInsets.only(top: 8.0),
                                                                                child: Row(
                                                                                  children: <Widget>[
                                                                                    Expanded(
                                                                                        child: Padding(
                                                                                            padding: const EdgeInsets.only(left: 2.0, right: 2, top: 5.0),
                                                                                            child: Container(
                                                                                              padding: EdgeInsets.all(2),
                                                                                              decoration: ShapeDecoration(
                                                                                                shape: OutlineInputBorder(
                                                                                                    borderRadius: BorderRadius.all(
                                                                                                      Radius.circular(360),
                                                                                                    ),
                                                                                                    borderSide: BorderSide(style: BorderStyle.none)),
                                                                                                color: isDarkMode(context) ? Colors.grey[700] : Colors.grey.shade200,
                                                                                              ),
                                                                                              child: Row(
                                                                                                children: <Widget>[
                                                                                                  Expanded(
                                                                                                    child: TextField(
                                                                                                      onChanged: (s) {
                                                                                                        setState(() {});
                                                                                                      },
                                                                                                      onTap: () {
                                                                                                        setState(() {
                                                                                                          // currentRecordingState = RecordingState.HIDDEN;
                                                                                                        });
                                                                                                      },
                                                                                                      textAlignVertical: TextAlignVertical.center,
                                                                                                      controller: _addressController,
                                                                                                      decoration: InputDecoration(
                                                                                                        isDense: true,
                                                                                                        contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                                                                                                        hintText: 'Delivery Address',
                                                                                                        hintStyle: TextStyle(color: Colors.grey[400]),
                                                                                                        focusedBorder: OutlineInputBorder(
                                                                                                            borderRadius: BorderRadius.all(
                                                                                                              Radius.circular(360),
                                                                                                            ),
                                                                                                            borderSide: BorderSide(style: BorderStyle.none)),
                                                                                                        enabledBorder: OutlineInputBorder(
                                                                                                            borderRadius: BorderRadius.all(
                                                                                                              Radius.circular(360),
                                                                                                            ),
                                                                                                            borderSide: BorderSide(style: BorderStyle.none)),
                                                                                                      ),
                                                                                                      textCapitalization: TextCapitalization.sentences,
                                                                                                      maxLines: 5,
                                                                                                      minLines: 1,
                                                                                                      keyboardType: TextInputType.multiline,
                                                                                                    ),
                                                                                                  ),
                                                                                                ],
                                                                                              ),
                                                                                            ))),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                              Spacer(),
                                                                              Row(
//                                          spacing: 30,
                                                                                children: <Widget>[
                                                                                  FlatButton(
                                                                                      onPressed: () {
                                                                                        Navigator.pop(context);
                                                                                      },
                                                                                      child: Text(
                                                                                        'cancel',
                                                                                        style: TextStyle(
                                                                                          fontSize: 18,
                                                                                        ),
                                                                                      ).tr()),
                                                                                  FlatButton(
                                                                                      onPressed: () async {
                                                                                        _messageController.text.length > 0 ? _sendToServer(business, _messageController.text, _addressController.text, service, url) : print("make second thing");
                                                                                        setState(() {
                                                                                          details = "";
                                                                                          url = "";
                                                                                          _messageController.text = '';
                                                                                        });
                                                                                      },
                                                                                      child: Text('Submit', style: TextStyle(fontSize: 18, color: Color(COLOR_PRIMARY)))),
                                                                                ],
                                                                              )
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    );
                                                                  });
                                                            },
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ))
                                              .toList();

                                          return serviceCards;
                                        }

                                        showBottomSheet(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return Container(
                                                height: media.height * 0.72,
                                                color: Color(COLOR_PRIMARY),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    RaisedButton(
                                                      color:
                                                          Color(COLOR_PRIMARY),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Icon(
                                                            Icons
                                                                .keyboard_arrow_down_sharp,
                                                            size: 40.0,
                                                            color: Colors.white,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Text(
                                                      business.businessName,
                                                      style: TextStyle(
                                                        fontSize: 19.0,
                                                        color: Colors.white,
                                                        letterSpacing: 1.0,
                                                      ),
                                                    ),

                                                    // Divider(),
                                                    Center(
                                                      child: displayCircleImage(
                                                          business
                                                              .businessLogoURL,
                                                          105,
                                                          false,
                                                          business
                                                              .businessName),
                                                    ),
                                                    Column(
                                                      children: [
                                                        Text(
                                                          business
                                                              .businessAbout,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w300),
                                                        ),
                                                      ],
                                                    ),
                                                    Divider(),
                                                    Expanded(
                                                      child: Container(
                                                        width: double.infinity,
                                                        color: Colors.white,
                                                        child: Column(
                                                          children: [
                                                            SizedBox(
                                                              height: 5.0,
                                                            ),
                                                            Text(
                                                              "Services",
                                                              style: TextStyle(
                                                                fontSize: 19.0,
                                                                color: Color(
                                                                    COLOR_PRIMARY),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: 5.0,
                                                            ),
                                                            SingleChildScrollView(
                                                              scrollDirection:
                                                                  Axis.horizontal,
                                                              child: Row(
                                                                children:
                                                                    createServiceCards(),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            });
                                      },
                                      leading: displayCircleImage(
                                          business.businessLogoURL,
                                          55,
                                          false,
                                          business.businessName),
                                      title: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${business.businessName}',
                                            style: TextStyle(
                                                color: isDarkMode(context)
                                                    ? Colors.white
                                                    : Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15),
                                          ),
                                          Text(
                                            business.businessAbout,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Divider()
                                ],
                              );
                            })
                        : ListView.builder(
                            itemCount: snap.hasData ? snap.data.length : 0,
                            // ignore: missing_return
                            itemBuilder: (BuildContext context, int index) {
                              if (snap.hasData) {
                                _businesses = snap.data;
                                Business business = snap.data[index];

                                return Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 4.0, bottom: 4.0),
                                      child: ListTile(
                                        onTap: () async {
                                          String channelID;
                                          if (business.businessID
                                                  .compareTo(user.userID) <
                                              0) {
                                            channelID = business.businessID +
                                                user.userID;
                                          } else {
                                            channelID = user.userID +
                                                business.businessID;
                                          }
                                          ConversationModel conversationModel =
                                              await fireStoreUtils
                                                  .getChannelByIdOrNull(
                                                      channelID);

                                          List<Card> createServiceCards() {
                                            List<Card> serviceCards = business
                                                .servicesMap.services.keys
                                                .where((service) =>
                                                    business.servicesMap
                                                            .services[service]
                                                        ['provides'] ==
                                                    true)
                                                .map((service) => Card(
                                                      margin:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 10.0),
                                                      color: Colors.white70,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal:
                                                                    28.0,
                                                                vertical: 10.0),
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceEvenly,
                                                          children: [
                                                            Text(
                                                              service,
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                            Padding(
                                                              padding: const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      18.0,
                                                                  vertical:
                                                                      5.0),
                                                              child:
                                                                  Image.asset(
                                                                'assets/images/$service.png',
                                                                width: 50.0,
                                                                height: 50.0,
                                                              ),
                                                            ),
                                                            Row(
                                                              children: [
                                                                Icon(
                                                                  Icons.star,
                                                                  color: Colors
                                                                      .orange,
                                                                ),
                                                                Text(
                                                                  business
                                                                      .servicesMap
                                                                      .services[
                                                                          service]
                                                                          [
                                                                          'rating']
                                                                      .toString(),
                                                                ),
                                                              ],
                                                            ),
                                                            RaisedButton(
                                                              color: Color(
                                                                  COLOR_PRIMARY),
                                                              child: Text(
                                                                "Select",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                              onPressed: () {
                                                                showDialog(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (context) {
                                                                      return Dialog(
                                                                        shape: RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(40)),
                                                                        elevation:
                                                                            16,
                                                                        child:
                                                                            Container(
                                                                          height: image != null
                                                                              ? 305
                                                                              : 200,
                                                                          width:
                                                                              350,
                                                                          child:
                                                                              Padding(
                                                                            padding: const EdgeInsets.only(
                                                                                top: 40.0,
                                                                                left: 16,
                                                                                right: 16,
                                                                                bottom: 16),
                                                                            child:
                                                                                Column(
                                                                              mainAxisSize: MainAxisSize.max,
                                                                              children: <Widget>[
                                                                                Visibility(
                                                                                  visible: image != null,
                                                                                  child: SizedBox(
                                                                                    height: 100.0,
                                                                                    child: SingleChildScrollView(
                                                                                      child: Column(
                                                                                        children: [
                                                                                          image != null
                                                                                              ? Image.file(
                                                                                                  File(image.path),
                                                                                                  fit: BoxFit.cover,
                                                                                                )
                                                                                              : Container(),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                Padding(
                                                                                  padding: const EdgeInsets.only(top: 8.0),
                                                                                  child: Row(
                                                                                    children: <Widget>[
                                                                                      IconButton(
                                                                                        onPressed: () {
                                                                                          _onCameraClick();
                                                                                        },
                                                                                        icon: Icon(
                                                                                          Icons.camera_alt,
                                                                                          color: Color(COLOR_PRIMARY),
                                                                                        ),
                                                                                      ),
                                                                                      Expanded(
                                                                                          child: Padding(
                                                                                              padding: const EdgeInsets.only(left: 2.0, right: 2, top: 5.0),
                                                                                              child: Container(
                                                                                                padding: EdgeInsets.all(2),
                                                                                                decoration: ShapeDecoration(
                                                                                                  shape: OutlineInputBorder(
                                                                                                      borderRadius: BorderRadius.all(
                                                                                                        Radius.circular(360),
                                                                                                      ),
                                                                                                      borderSide: BorderSide(style: BorderStyle.none)),
                                                                                                  color: isDarkMode(context) ? Colors.grey[700] : Colors.grey.shade200,
                                                                                                ),
                                                                                                child: Row(
                                                                                                  children: <Widget>[
                                                                                                    InkWell(
                                                                                                      onTap: () => {},
                                                                                                      child: Icon(
                                                                                                        Icons.mic,
                                                                                                        // color: currentRecordingState == RecordingState.HIDDEN ? Color(COLOR_PRIMARY) : Colors.red,
                                                                                                      ),
                                                                                                    ),
                                                                                                    Expanded(
                                                                                                      child: TextField(
                                                                                                        onChanged: (s) {
                                                                                                          setState(() {});
                                                                                                        },
                                                                                                        onTap: () {
                                                                                                          setState(() {
                                                                                                            // currentRecordingState = RecordingState.HIDDEN;
                                                                                                          });
                                                                                                        },
                                                                                                        textAlignVertical: TextAlignVertical.center,
                                                                                                        controller: _messageController,
                                                                                                        decoration: InputDecoration(
                                                                                                          isDense: true,
                                                                                                          contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                                                                                                          hintText: 'Details',
                                                                                                          hintStyle: TextStyle(color: Colors.grey[400]),
                                                                                                          focusedBorder: OutlineInputBorder(
                                                                                                              borderRadius: BorderRadius.all(
                                                                                                                Radius.circular(360),
                                                                                                              ),
                                                                                                              borderSide: BorderSide(style: BorderStyle.none)),
                                                                                                          enabledBorder: OutlineInputBorder(
                                                                                                              borderRadius: BorderRadius.all(
                                                                                                                Radius.circular(360),
                                                                                                              ),
                                                                                                              borderSide: BorderSide(style: BorderStyle.none)),
                                                                                                        ),
                                                                                                        textCapitalization: TextCapitalization.sentences,
                                                                                                        maxLines: 5,
                                                                                                        minLines: 1,
                                                                                                        keyboardType: TextInputType.multiline,
                                                                                                      ),
                                                                                                    ),
                                                                                                  ],
                                                                                                ),
                                                                                              ))),
                                                                                      // IconButton(
                                                                                      //     icon: Icon(
                                                                                      //       Icons.send,
                                                                                      //       color: _messageController.text.isEmpty ? Color(COLOR_PRIMARY).withOpacity(.5) : Color(COLOR_PRIMARY),
                                                                                      //     ),
                                                                                      //     onPressed: () async {
                                                                                      //       if (_messageController.text.isNotEmpty) {
                                                                                      //         // _sendMessage(_messageController.text, Url(mime: '', url: ''), '');
                                                                                      //         _messageController.clear();
                                                                                      //         setState(() {});
                                                                                      //       }
                                                                                      //     })
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                                Spacer(),
                                                                                Row(
//                                          spacing: 30,
                                                                                  children: <Widget>[
                                                                                    FlatButton(
                                                                                        onPressed: () {
                                                                                          Navigator.pop(context);
                                                                                        },
                                                                                        child: Text(
                                                                                          'cancel',
                                                                                          style: TextStyle(
                                                                                            fontSize: 18,
                                                                                          ),
                                                                                        ).tr()),
                                                                                    FlatButton(
                                                                                        onPressed: () async {
                                                                                          _messageController.text.length > 0 ? _sendToServer(business, _messageController.text, _addressController.text, service, url) : print("make second thing");
                                                                                          setState(() {
                                                                                            details = "";
                                                                                            url = "";
                                                                                            _messageController.text = '';
                                                                                          });
                                                                                        },
                                                                                        child: Text('Submit', style: TextStyle(fontSize: 18, color: Color(COLOR_PRIMARY)))),
                                                                                  ],
                                                                                )
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      );
                                                                    });
                                                              },
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ))
                                                .toList();

                                            return serviceCards;
                                          }

                                          showBottomSheet(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return Container(
                                                  height: media.height * 0.72,
                                                  color: Color(COLOR_PRIMARY),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      RaisedButton(
                                                        color: Color(
                                                            COLOR_PRIMARY),
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Icon(
                                                              Icons
                                                                  .keyboard_arrow_down_sharp,
                                                              size: 40.0,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Text(
                                                        business.businessName,
                                                        style: TextStyle(
                                                          fontSize: 19.0,
                                                          color: Colors.white,
                                                          letterSpacing: 1.0,
                                                        ),
                                                      ),

                                                      // Divider(),
                                                      Center(
                                                        child: displayCircleImage(
                                                            business
                                                                .businessLogoURL,
                                                            105,
                                                            false,
                                                            business
                                                                .businessName),
                                                      ),
                                                      Column(
                                                        children: [
                                                          Text(
                                                            business
                                                                .businessAbout,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w300),
                                                          ),
                                                        ],
                                                      ),
                                                      Divider(),
                                                      Expanded(
                                                        child: Container(
                                                          width:
                                                              double.infinity,
                                                          color: Colors.white,
                                                          child: Column(
                                                            children: [
                                                              SizedBox(
                                                                height: 5.0,
                                                              ),
                                                              Text(
                                                                "Services",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      19.0,
                                                                  color: Color(
                                                                      COLOR_PRIMARY),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height: 5.0,
                                                              ),
                                                              SingleChildScrollView(
                                                                scrollDirection:
                                                                    Axis.horizontal,
                                                                child: Row(
                                                                  children:
                                                                      createServiceCards(),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              });
                                        },
                                        leading: displayCircleImage(
                                            business.businessLogoURL,
                                            55,
                                            false,
                                            business.businessName),
                                        title: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '${business.businessName}',
                                              style: TextStyle(
                                                  color: isDarkMode(context)
                                                      ? Colors.white
                                                      : Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15),
                                            ),
                                            Text(
                                              business.businessAbout,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w300,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Divider()
                                  ],
                                );
                              }
                            },
                          ),
                  );
                }
              },
            )
          ],
        ),
      ),
    );
  }

  _onSearchFilterChanged(String searchedText) async {
    _searchResult.clear();
    List<String> selectedFilters =
        _filterList.keys.where(((item) => _filterList[item] == true)).toList();
    print(selectedFilters);
    searchedText = searchedText.isEmpty ? ' ' : searchedText;
    _searchResult = _businesses
        .where((partner) => partner.businessName
            .toLowerCase()
            .contains(searchedText.toLowerCase()))
        .toList();
    setState(() {});
  }

  @override
  void dispose() {
    controller.dispose();
    _searchResult.clear();
    _messageController.clear();
    _addressController.clear();
    super.dispose();
  }

  String getStatusByType(ContactType type) {
    switch (type) {
      case ContactType.ACCEPT:
        return 'accept';
        break;
      case ContactType.PENDING:
        return 'cancel';
        break;
      case ContactType.FRIEND:
        return 'unfriend';
        break;
      case ContactType.UNKNOWN:
        return 'addFriend';
        break;
      case ContactType.BLOCKED:
        return 'unblock';
        break;
      default:
        return 'addFriend';
    }
  }

  // String getServicesTextByType(Services serviceType) {
  //   switch (serviceType) {
  //     case Services.Doctor:
  //       return 'Doctor';
  //       break;
  //     case Services.Radiologist:
  //       return 'Radiologist';
  //       break;
  //     case Services.Laboratory:
  //       return 'Laboratory';
  //       break;
  //     case Services.Pharmacist:
  //       return 'Pharmacist';
  //       break;
  //     default:
  //       return 'Other';
  //   }
  // }

  _sendToServer(Business business, detail, customerDeliveryDetails, serviceName,
      url) async {
    showProgress(context, 'Creating request', false);
    String requestID = uuid.v4();
    try {
      // BookingRequest bookingRequest = BookingRequest(
      //   details: detail,
      //   pictureDetailsURL: url,
      //   customerID: user.userID,
      //   customerName: user.fullName(),
      //   customerURL: user.profilePictureURL,
      //   sellerID: business.businessID,
      //   sellerName: business.businessName,
      //   handled: false,
      //   serviceName: serviceName,
      //   requestID: requestID,
      // );
      Deal deal = Deal(
        customerID: user.userID,
        customerName: user.fullName(),
        customerURL: user.profilePictureURL,
        sellerID: business.businessID,
        sellerName: business.businessName,
        sellerURL: business.businessLogoURL,
        customerInitiated: true,
        serviceName: serviceName,
        pictureDetailsURL: "",
        requestID: requestID,
        customerAdditionalDetails: detail,
        customerDeliveryDetails: customerDeliveryDetails,
        partnerAdditionalDetails: "",
        displayAppointmentTime: "",
        paymentType: "",
        paid: false,
        amount: 0.0,
        bookingConfirmed: false,
        enquiryHandled: false,
        dealClosed: false,
      );
      await FireStoreUtils.firestore
          .collection(DEALS)
          .document(user.userID)
          .collection(SENT_DEALS)
          .document(requestID)
          .setData(deal.toJson());
      await FireStoreUtils.firestore
          .collection(DEALS)
          .document(business.businessID)
          .collection(RECEIVED_DEALS)
          .document(requestID)
          .setData(deal.toJson());

      hideProgress();
      _messageController.dispose();
      _addressController.dispose();

      user.isPartner
          ? pushAndRemoveUntil(
              context,
              HomeScreen(
                user: user,
                business: business,
              ),
              false)
          : pushAndRemoveUntil(
              context,
              HomeScreen(
                user: user,
              ),
              false);
    } catch (error) {
      print(user.fullName());
      print(error.toString());
      hideProgress();
      print(error.toString());
    }
  }

  _onCameraClick() {
    final action = CupertinoActionSheet(
      message: Text(
        "sendMedia",
        style: TextStyle(fontSize: 15.0),
      ).tr(),
      actions: <Widget>[
        CupertinoActionSheetAction(
          child: Text("chooseImageFromGallery").tr(),
          isDefaultAction: false,
          onPressed: () async {
            setState(() {
              isLoadingPic = true;
            });
            Navigator.pop(context);
            PickedFile imageGot =
                await _imagePicker.getImage(source: ImageSource.gallery);
            String detailURL = uuid.v4();
            if (imageGot != null) {
              url = await fireStoreUtils.uploadBusinessImageToFireStorage(
                  File(imageGot.path), detailURL);
              setState(() {
                image = imageGot;
                doneLoadingPic = true;
                isLoadingPic = false;
              });
            }
          },
        ),
        // CupertinoActionSheetAction(
        //   child: Text("chooseVideoFromGallery").tr(),
        //   isDefaultAction: false,
        //   onPressed: () async {
        //     Navigator.pop(context);
        //     PickedFile galleryVideo =
        //         await _imagePicker.getVideo(source: ImageSource.gallery);
        //     if (galleryVideo != null) {
        //       ChatVideoContainer videoContainer =
        //           await fireStoreUtils.uploadChatVideoToFireStorage(
        //               File(galleryVideo.path), context);
        //       // _sendMessage(
        //       //     '', videoContainer.videoUrl, videoContainer.thumbnailUrl);
        //     }
        //   },
        // ),
        CupertinoActionSheetAction(
          child: Text("takeAPicture").tr(),
          isDestructiveAction: false,
          onPressed: () async {
            Navigator.pop(context);
            PickedFile image =
                await _imagePicker.getImage(source: ImageSource.camera);
            if (image != null) {
              url = await fireStoreUtils.uploadBusinessImageToFireStorage(
                  File(image.path), user.userID);
              // _sendMessage('', url, '');
            }
          },
        ),
        // CupertinoActionSheetAction(
        //   child: Text("recordVideo").tr(),
        //   isDestructiveAction: false,
        //   onPressed: () async {
        //     Navigator.pop(context);
        //     PickedFile recordedVideo =
        //         await _imagePicker.getVideo(source: ImageSource.camera);
        //     if (recordedVideo != null) {
        //       ChatVideoContainer videoContainer =
        //           await fireStoreUtils.uploadChatVideoToFireStorage(
        //               File(recordedVideo.path), context);
        //       _sendMessage(
        //           '', videoContainer.videoUrl, videoContainer.thumbnailUrl);
        //     }
        //   },
        // )
      ],
      cancelButton: CupertinoActionSheetAction(
        child: Text(
          "cancel",
        ).tr(),
        onPressed: () {
          image = null;
          Navigator.pop(context);
        },
      ),
    );
    showCupertinoModalPopup(context: context, builder: (context) => action);
  }
}
