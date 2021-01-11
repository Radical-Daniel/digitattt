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

class ServicesSearchScreen extends StatefulWidget {
  final User user;

  const ServicesSearchScreen({Key key, @required this.user}) : super(key: key);

  @override
  _ServicesSearchScreenState createState() => _ServicesSearchScreenState(user);
}

class _ServicesSearchScreenState extends State<ServicesSearchScreen> {
  double _locationSliderValue = 15;
  final User user;
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
  _ServicesSearchScreenState(this.user);

  Future<List<Business>> _future;
  User selectedContact;

  @override
  void initState() {
    _future = fireStoreUtils.getBusinesses(user.userID, true);
    print("initsss");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    return ChangeNotifierProvider.value(
      value: selectedContact,
      child: Scaffold(
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
                    hintText: 'Search for services',
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
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              // child: Row(
              //   children: [
              //     Padding(
              //         padding: const EdgeInsets.all(4.0),
              //         child: FilterChip(
              //           selected: _filterList['doctor'],
              //           selectedColor: Color(COLOR_PRIMARY),
              //           onSelected: (bool value) {
              //             setState(() {
              //               _filterList['doctor'] = value;
              //             });
              //             _onSearchFilterChanged(controller.text);
              //           },
              //           label: Text(
              //             "DOCTOR",
              //             style: TextStyle(
              //                 color: _filterList['doctor']
              //                     ? Colors.white
              //                     : Colors.black),
              //           ),
              //         )),
              //     Padding(
              //         padding: const EdgeInsets.all(4.0),
              //         child: FilterChip(
              //           selected: _filterList['pharmacist'],
              //           selectedColor: Color(COLOR_PRIMARY),
              //           onSelected: (value) {
              //             setState(() {
              //               _filterList['pharmacist'] = value;
              //               _onSearchFilterChanged(controller.text);
              //             });
              //           },
              //           label: Text(
              //             "PHARMACIST",
              //             style: TextStyle(
              //                 color: _filterList['pharmacist']
              //                     ? Colors.white
              //                     : Colors.black),
              //           ),
              //         )),
              //     Padding(
              //         padding: const EdgeInsets.all(4.0),
              //         child: FilterChip(
              //           selected: _filterList['laboratory'],
              //           selectedColor: Color(COLOR_PRIMARY),
              //           onSelected: (bool value) {
              //             setState(() {
              //               _filterList['laboratory'] = value;
              //               _onSearchFilterChanged(controller.text);
              //             });
              //           },
              //           label: Text(
              //             "LABORATORY",
              //             style: TextStyle(
              //                 color: _filterList['laboratory']
              //                     ? Colors.white
              //                     : Colors.black),
              //           ),
              //         )),
              //     Padding(
              //         padding: const EdgeInsets.all(4.0),
              //         child: FilterChip(
              //           selected: _filterList['radiologist'],
              //           selectedColor: Color(COLOR_PRIMARY),
              //           onSelected: (bool value) {
              //             setState(() {
              //               _filterList['radiologist'] = value;
              //             });
              //             _onSearchFilterChanged(controller.text);
              //           },
              //           label: Text(
              //             "RADIOLOGIST",
              //             style: TextStyle(
              //                 color: _filterList['radiologist']
              //                     ? Colors.white
              //                     : Colors.black),
              //           ),
              //         )),
              //   ],
              // ),
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
                        'No Business Found',
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
                                          List<Card> serviceCards =
                                              business.servicesMap.services.keys
                                                  .where((service) =>
                                                      business.servicesMap
                                                              .services[service]
                                                          ['provides'] ==
                                                      true)
                                                  .map((service) => Card(
                                                        margin: EdgeInsets
                                                            .symmetric(
                                                                horizontal:
                                                                    10.0),
                                                        color: Colors.white70,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      28.0,
                                                                  vertical:
                                                                      10.0),
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
                                                                            shape:
                                                                                RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                                                                            elevation: 16,
                                                                            child: Container(
                                                                              height: 200,
                                                                              width: 350,
                                                                              child: Padding(
                                                                                  padding: const EdgeInsets.only(top: 40.0, left: 16, right: 16, bottom: 16),
                                                                                  child: Column(
                                                                                    mainAxisSize: MainAxisSize.max,
                                                                                    children: <Widget>[
                                                                                      TextField(
                                                                                        textInputAction: TextInputAction.done,
                                                                                        keyboardType: TextInputType.text,
                                                                                        textCapitalization: TextCapitalization.sentences,
                                                                                        controller: requestDetailsController,
                                                                                        decoration: InputDecoration(
                                                                                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(25.0), borderSide: BorderSide(color: Color(COLOR_PRIMARY), width: 2.0)),
                                                                                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(25.0)),
                                                                                          labelText: 'Details',
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
                                                                                          FlatButton(onPressed: () async {}, child: Text('Submit', style: TextStyle(fontSize: 18, color: Color(COLOR_PRIMARY)))),
                                                                                        ],
                                                                                      )
                                                                                    ],
                                                                                  )),
                                                                            ));
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
                                                          false),
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
                                          business.businessLogoURL, 55, false),
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
                                                                              borderRadius: BorderRadius.circular(
                                                                                  40)),
                                                                          elevation:
                                                                              16,
                                                                          child:
                                                                              Container(
                                                                            height:
                                                                                200,
                                                                            width:
                                                                                350,
                                                                            child: Padding(
                                                                                padding: const EdgeInsets.only(top: 40.0, left: 16, right: 16, bottom: 16),
                                                                                child: Column(
                                                                                  mainAxisSize: MainAxisSize.max,
                                                                                  children: <Widget>[
                                                                                    TextField(
                                                                                      textInputAction: TextInputAction.done,
                                                                                      keyboardType: TextInputType.text,
                                                                                      textCapitalization: TextCapitalization.sentences,
                                                                                      controller: requestDetailsController,
                                                                                      decoration: InputDecoration(
                                                                                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(25.0), borderSide: BorderSide(color: Color(COLOR_PRIMARY), width: 2.0)),
                                                                                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(25.0)),
                                                                                        labelText: 'Details',
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
                                                                                        FlatButton(onPressed: () async {}, child: Text('Submit', style: TextStyle(fontSize: 18, color: Color(COLOR_PRIMARY)))),
                                                                                      ],
                                                                                    )
                                                                                  ],
                                                                                )),
                                                                          ));
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
                                                            false),
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
                                            false),
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

  _sendToServer(business) async {
    showProgress(context, 'Creating request', false);
    try {
      BookingRequest bookingRequest = BookingRequest(
        customerId: user.userID,
        customerName: user.fullName(),
        customerUrl: user.profilePictureURL,
        sellerId: business.businessID,
        sellerName: business.businessName,
        handled: false,
      );
      await FireStoreUtils.firestore
          .collection(SENT_BOOKING_REQUESTS)
          .document(user.userID)
          .setData(bookingRequest.toJson());
      await FireStoreUtils.firestore
          .collection(RECEIVED_BOOKING_REQUESTS)
          .document(business.businessID)
          .setData(bookingRequest.toJson());

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
      print(error.toString());
    }
  }

// _onContactButtonClicked(
  //     Business contact, int index, bool fromSearch) async {
  //   switch (contact.type) {
  //     case ContactType.ACCEPT:
  //       showProgress(context, 'acceptingFriendship'.tr(), false);
  //       await fireStoreUtils.onFriendAccept(contact.user);
  //
  //       if (fromSearch) {
  //         _searchResult[index].type = ContactType.FRIEND;
  //         _businesses
  //             .where((user) => user.user.userID == contact.user.userID)
  //             .first
  //             .type = ContactType.FRIEND;
  //       } else {
  //         _businesses[index].type = ContactType.FRIEND;
  //       }
  //
  //       break;
  //     case ContactType.FRIEND:
  //       showProgress(context, 'removingFriendship'.tr(), false);
  //       await fireStoreUtils.onUnFriend(contact.user);
  //       if (fromSearch) {
  //         _searchResult[index].type = ContactType.UNKNOWN;
  //         _businesses
  //             .where((user) => user.user.userID == contact.user.userID)
  //             .first
  //             .type = ContactType.UNKNOWN;
  //       } else {
  //         _businesses[index].type = ContactType.UNKNOWN;
  //       }
  //       break;
  //     case ContactType.PENDING:
  //       showProgress(context, 'removingFriendshipRequest'.tr(), false);
  //       await fireStoreUtils.onCancelRequest(contact.user);
  //       if (fromSearch) {
  //         _searchResult[index].type = ContactType.UNKNOWN;
  //         _businesses
  //             .where((user) => user.user.userID == contact.user.userID)
  //             .first
  //             .type = ContactType.UNKNOWN;
  //       } else {
  //         _businesses[index].type = ContactType.UNKNOWN;
  //       }
  //
  //       break;
  //     case ContactType.BLOCKED:
  //       break;
  //     case ContactType.UNKNOWN:
  //       showProgress(context, 'sendingFriendshipRequest'.tr(), false);
  //       await fireStoreUtils.sendFriendRequest(contact.user);
  //       if (fromSearch) {
  //         _searchResult[index].type = ContactType.PENDING;
  //         _businesses
  //             .where((user) => user.user.userID == contact.user.userID)
  //             .first
  //             .type = ContactType.PENDING;
  //       }
  //       break;
  //   }
  // }
}
