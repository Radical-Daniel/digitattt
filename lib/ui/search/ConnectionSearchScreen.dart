import 'package:easy_localization/easy_localization.dart';
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

List<ContactModel> _searchResult = [];
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

List<ContactModel> _contacts = [];

class ConnectionSearchScreen extends StatefulWidget {
  final User user;

  const ConnectionSearchScreen({Key key, @required this.user})
      : super(key: key);

  @override
  _ConnectionSearchScreenState createState() =>
      _ConnectionSearchScreenState(user);
}

class _ConnectionSearchScreenState extends State<ConnectionSearchScreen> {
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
  _ConnectionSearchScreenState(this.user);

  Future<List<ContactModel>> _future;
  // List<String> contactsNames = [];
  // List<String> _contactsNames() {
  //   for (int i = 0; i < snap.data.length; i++) {
  //     String name = snap.data[i].user.fullName();
  //     contactsNames.add(name);
  //   }
  //   return contactsNames;
  // }

  // static List<String> contactsSelected = [];
  // void _openFilterDialog() async {
  //   await FilterListDialog.display(context,
  //       allTextList: _contactsNames(),
  //       height: 480,
  //       borderRadius: 20,
  //       headlineText: "Select interest",
  //       searchFieldHintText: "Search Here",
  //       selectedTextList: contactsSelected, onApplyButtonClick: (list) {
  //     if (list != null) {
  //       setState(() {
  //         contactsSelected = List.from(list);
  //       });
  //     }
  //     Navigator.pop(context);
  //   });
  // }

  @override
  void initState() {
    super.initState();
    _future = fireStoreUtils.getContacts(user.userID, true);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 4),
          child: TextField(
            controller: controller,
            onChanged: _onSearchFilterChanged,
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
                contentPadding: EdgeInsets.all(0),
                isDense: true,
                fillColor:
                    isDarkMode(context) ? Colors.grey[700] : Colors.grey[200],
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
                hintText: tr('searchForFriends'),
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
          child: Row(
            children: [
              Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: FilterChip(
                    selected: _filterList['doctor'],
                    selectedColor: Color(COLOR_PRIMARY),
                    onSelected: (bool value) {
                      setState(() {
                        _filterList['doctor'] = value;
                      });
                      _onSearchFilterChanged(controller.text);
                    },
                    label: Text(
                      "DOCTOR",
                      style: TextStyle(
                          color: _filterList['doctor']
                              ? Colors.white
                              : Colors.black),
                    ),
                  )),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: FilterChip(
                  selected: _filterList['pharmacist'],
                  selectedColor: Color(COLOR_PRIMARY),
                  onSelected: (value) {
                    setState(() {
                      _filterList['pharmacist'] = value;
                      _onSearchFilterChanged(controller.text);
                    });
                  },
                  label: Text(
                    "PHARMACIST",
                    style: TextStyle(
                        color: _filterList['pharmacist']
                            ? Colors.white
                            : Colors.black),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: FilterChip(
                  selected: _filterList['laboratory'],
                  selectedColor: Color(COLOR_PRIMARY),
                  onSelected: (bool value) {
                    setState(() {
                      _filterList['laboratory'] = value;
                      _onSearchFilterChanged(controller.text);
                    });
                  },
                  label: Text(
                    "LABORATORY",
                    style: TextStyle(
                        color: _filterList['laboratory']
                            ? Colors.white
                            : Colors.black),
                  ),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: FilterChip(
                    selected: _filterList['retail'],
                    selectedColor: Color(COLOR_PRIMARY),
                    onSelected: (bool value) {
                      setState(() {
                        _filterList['retail'] = value;
                      });
                      _onSearchFilterChanged(controller.text);
                    },
                    label: Text(
                      "RETAIL",
                      style: TextStyle(
                          color: _filterList['retail']
                              ? Colors.white
                              : Colors.black),
                    ),
                  )),
            ],
          ),
        ),
        FutureBuilder<List<ContactModel>>(
          future: _future,
          initialData: [],
          builder: (context, snap) {
            if (snap.connectionState == ConnectionState.waiting) {
              return Expanded(
                child: Container(
                  child: Center(
                    child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Color(COLOR_ACCENT)),
                    ),
                  ),
                ),
              );
            } else if (!snap.hasData || snap.data.isEmpty) {
              return Expanded(
                child: Center(
                  child: Text(
                    'noUsersFound',
                    style: TextStyle(fontSize: 18),
                  ).tr(),
                ),
              );
            } else {
              return Expanded(
                child: _searchResult.length != 0 || controller.text.isNotEmpty
                    ? new ListView.builder(
                        itemCount: _searchResult.length,
                        itemBuilder: (context, index) {
                          ContactModel contact = _searchResult[index];
                          return Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 4.0, bottom: 4.0),
                                child: ListTile(
                                  onTap: () async {
                                    String channelID;
                                    if (contact.user.userID
                                            .compareTo(user.userID) <
                                        0) {
                                      channelID =
                                          contact.user.userID + user.userID;
                                    } else {
                                      channelID =
                                          user.userID + contact.user.userID;
                                    }
                                    ConversationModel conversationModel =
                                        await fireStoreUtils
                                            .getChannelByIdOrNull(channelID);
                                    push(
                                        context,
                                        ChatScreen(
                                            homeConversationModel:
                                                HomeConversationModel(
                                                    isGroupChat: false,
                                                    members: [contact.user],
                                                    conversationModel:
                                                        conversationModel)));
                                  },
                                  leading: displayCircleImage(
                                      contact.user.profilePictureURL,
                                      55,
                                      false),
                                  title: Text(
                                    '${contact.user.fullName()}',
                                    style: TextStyle(
                                        color: isDarkMode(context)
                                            ? Colors.white
                                            : Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  ),
                                  trailing: FlatButton(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      color: isDarkMode(context)
                                          ? Colors.grey[700]
                                          : Colors.grey[200],
                                      onPressed: () async {
                                        await _onContactButtonClicked(
                                            contact, index, true);
                                        hideProgress();
                                        setState(() {});
                                      },
                                      child: Text(
                                        getStatusByType(contact.type),
                                        style: TextStyle(
                                            color: isDarkMode(context)
                                                ? Colors.white
                                                : Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ).tr()),
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
                            _contacts = snap.data;
                            ContactModel contact = snap.data[index];
                            return Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 4.0, bottom: 4.0),
                                  child: ListTile(
                                    onTap: () async {
                                      String channelID;
                                      if (contact.user.userID
                                              .compareTo(user.userID) <
                                          0) {
                                        channelID =
                                            contact.user.userID + user.userID;
                                      } else {
                                        channelID =
                                            user.userID + contact.user.userID;
                                      }
                                      ConversationModel conversationModel =
                                          await fireStoreUtils
                                              .getChannelByIdOrNull(channelID);
                                      push(
                                          context,
                                          ChatScreen(
                                              homeConversationModel:
                                                  HomeConversationModel(
                                                      isGroupChat: false,
                                                      members: [contact.user],
                                                      conversationModel:
                                                          conversationModel)));
                                    },
                                    leading: displayCircleImage(
                                        contact.user.profilePictureURL,
                                        55,
                                        false),
                                    title: Text(
                                      '${contact.user.fullName()}',
                                      style: TextStyle(
                                          color: isDarkMode(context)
                                              ? Colors.white
                                              : Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),
                                    ),
                                    trailing: FlatButton(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        color: isDarkMode(context)
                                            ? Colors.grey[700]
                                            : Colors.grey[200],
                                        onPressed: () async {
                                          await _onContactButtonClicked(
                                              contact, index, false);
                                          hideProgress();
                                          setState(() {});
                                        },
                                        child: Text(
                                          getStatusByType(contact.type),
                                          style: TextStyle(
                                              color: isDarkMode(context)
                                                  ? Colors.white
                                                  : Colors.black,
                                              fontWeight: FontWeight.bold),
                                        ).tr()),
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
    );
  }

  _onSearchFilterChanged(String searchedText) async {
    _searchResult.clear();
    List<String> selectedFilters =
        _filterList.keys.where(((item) => _filterList[item] == true)).toList();
    print(selectedFilters);
    searchedText = searchedText.isEmpty ? ' ' : searchedText;
    _searchResult = _contacts
        .where((contact) =>
            contact.user
                .fullName()
                .toLowerCase()
                .contains(searchedText.toLowerCase()) &&
            selectedFilters.every(
                (filter) => contact.user.interestMap.interest[filter] == true))
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

  _onContactButtonClicked(
      ContactModel contact, int index, bool fromSearch) async {
    switch (contact.type) {
      case ContactType.ACCEPT:
        showProgress(context, 'acceptingFriendship'.tr(), false);
        await fireStoreUtils.onFriendAccept(contact.user);

        if (fromSearch) {
          _searchResult[index].type = ContactType.FRIEND;
          _contacts
              .where((user) => user.user.userID == contact.user.userID)
              .first
              .type = ContactType.FRIEND;
        } else {
          _contacts[index].type = ContactType.FRIEND;
        }

        break;
      case ContactType.FRIEND:
        showProgress(context, 'removingFriendship'.tr(), false);
        await fireStoreUtils.onUnFriend(contact.user);
        if (fromSearch) {
          _searchResult[index].type = ContactType.UNKNOWN;
          _contacts
              .where((user) => user.user.userID == contact.user.userID)
              .first
              .type = ContactType.UNKNOWN;
        } else {
          _contacts[index].type = ContactType.UNKNOWN;
        }
        break;
      case ContactType.PENDING:
        showProgress(context, 'removingFriendshipRequest'.tr(), false);
        await fireStoreUtils.onCancelRequest(contact.user);
        if (fromSearch) {
          _searchResult[index].type = ContactType.UNKNOWN;
          _contacts
              .where((user) => user.user.userID == contact.user.userID)
              .first
              .type = ContactType.UNKNOWN;
        } else {
          _contacts[index].type = ContactType.UNKNOWN;
        }

        break;
      case ContactType.BLOCKED:
        break;
      case ContactType.UNKNOWN:
        showProgress(context, 'sendingFriendshipRequest'.tr(), false);
        await fireStoreUtils.sendFriendRequest(contact.user);
        if (fromSearch) {
          _searchResult[index].type = ContactType.PENDING;
          _contacts
              .where((user) => user.user.userID == contact.user.userID)
              .first
              .type = ContactType.PENDING;
        }
        break;
    }
  }
}
