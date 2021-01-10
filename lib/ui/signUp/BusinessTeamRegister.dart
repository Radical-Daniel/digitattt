// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:instachatty/constants.dart';
// import 'package:instachatty/model/ContactModel.dart';
// import 'package:instachatty/model/ConversationModel.dart';
// import 'package:instachatty/model/HomeConversationModel.dart';
// import 'package:instachatty/model/User.dart';
// import 'package:instachatty/services/FirebaseHelper.dart';
// import 'package:instachatty/services/Helper.dart';
// import 'package:instachatty/ui/chat/ChatScreen.dart';
// import 'package:instachatty/model/Business.dart';
//
// List<ContactModel> _searchResult = [];
//
// List<ContactModel> _contacts = [];
//
// class BusinessTeamScreen extends StatefulWidget {
//   final User user;
//   final Business business;
//
//   const BusinessTeamScreen(
//       {Key key, @required this.user, @required this.business})
//       : super(key: key);
//
//   @override
//   _BusinessTeamScreenState createState() =>
//       _BusinessTeamScreenState(user, business);
// }
//
// class _BusinessTeamScreenState extends State<BusinessTeamScreen> {
//   final User user;
//   final Business business;
//   TextEditingController controller = new TextEditingController();
//   final fireStoreUtils = FireStoreUtils();
//
//   _BusinessTeamScreenState(this.user, this.business);
//
//   Future<List<ContactModel>> _future;
//   int selectedIndex = 0;
//   @override
//   void initState() {
//     super.initState();
//     _future = fireStoreUtils.getContacts(user.userID, false);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         backgroundColor: Color(COLOR_PRIMARY),
//         title: Text(
//           "digit@T",
//           style: TextStyle(fontFamily: 'Bauhaus93'),
//           textAlign: TextAlign.center,
//         ),
//       ),
//       bottomNavigationBar: FlatButton(
//         color: Color(COLOR_PRIMARY),
//         onPressed: () {},
//         child: Text("Confirm"),
//       ),
//       body: Column(
//         children: <Widget>[
//           Padding(
//             padding:
//                 const EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 4),
//             child: TextField(
//               controller: controller,
//               onChanged: _onSearchTextChanged,
//               textInputAction: TextInputAction.search,
//               decoration: InputDecoration(
//                   contentPadding: EdgeInsets.all(0),
//                   isDense: true,
//                   fillColor:
//                       isDarkMode(context) ? Colors.grey[700] : Colors.grey[200],
//                   filled: true,
//                   focusedBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.all(
//                         Radius.circular(360),
//                       ),
//                       borderSide: BorderSide(style: BorderStyle.none)),
//                   enabledBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.all(
//                         Radius.circular(360),
//                       ),
//                       borderSide: BorderSide(style: BorderStyle.none)),
//                   hintText: tr('searchForFriends'),
//                   suffixIcon: IconButton(
//                     iconSize: 20,
//                     icon: Icon(Icons.close),
//                     onPressed: () {
//                       FocusScope.of(context).unfocus();
//                       controller.clear();
//                       _onSearchTextChanged('');
//                     },
//                   ),
//                   prefixIcon: Icon(
//                     Icons.search,
//                     size: 20,
//                   )),
//             ),
//           ),
//           FutureBuilder<List<ContactModel>>(
//             future: _future,
//             initialData: [],
//             builder: (context, snap) {
//               if (snap.connectionState == ConnectionState.waiting) {
//                 return Expanded(
//                   child: Container(
//                     child: Center(
//                       child: CircularProgressIndicator(
//                         valueColor: AlwaysStoppedAnimation<Color>(
//                           Color(COLOR_ACCENT),
//                         ),
//                       ),
//                     ),
//                   ),
//                 );
//               } else if (!snap.hasData || snap.data.isEmpty) {
//                 return Expanded(
//                   child: Center(
//                     child: Text(
//                       'noContactsFound',
//                       style: TextStyle(fontSize: 18),
//                     ).tr(),
//                   ),
//                 );
//               } else {
//                 return Expanded(
//                   child: _searchResult.length != 0 || controller.text.isNotEmpty
//                       ? new ListView.builder(
//                           itemCount: _searchResult.length,
//                           itemBuilder: (context, index) {
//                             ContactModel contact = _searchResult[index];
//                             return Column(
//                               children: <Widget>[
//                                 Padding(
//                                   padding: const EdgeInsets.only(
//                                       top: 4.0, bottom: 4.0),
//                                   child: ListTile(
//                                     onTap: () async {
//                                       String channelID;
//                                       if (contact.user.userID
//                                               .compareTo(user.userID) <
//                                           0) {
//                                         channelID =
//                                             contact.user.userID + user.userID;
//                                       } else {
//                                         channelID =
//                                             user.userID + contact.user.userID;
//                                       }
//                                       ConversationModel conversationModel =
//                                           await fireStoreUtils
//                                               .getChannelByIdOrNull(channelID);
//                                       push(
//                                         context,
//                                         ChatScreen(
//                                           homeConversationModel:
//                                               HomeConversationModel(
//                                                   isGroupChat: false,
//                                                   members: [contact.user],
//                                                   conversationModel:
//                                                       conversationModel),
//                                         ),
//                                       );
//                                     },
//                                     leading: displayCircleImage(
//                                         contact.user.profilePictureURL,
//                                         55,
//                                         false),
//                                     title: Text(
//                                       '${contact.user.fullName()}',
//                                       style: TextStyle(
//                                           color: isDarkMode(context)
//                                               ? Colors.white
//                                               : Colors.black,
//                                           fontWeight: FontWeight.bold,
//                                           fontSize: 15),
//                                     ),
//                                     trailing: FlatButton(
//                                         shape: RoundedRectangleBorder(
//                                             borderRadius:
//                                                 BorderRadius.circular(20)),
//                                         color: isDarkMode(context)
//                                             ? Colors.grey[700]
//                                             : Colors.grey[200],
//                                         onPressed: () async {
//                                           await _onContactButtonClicked(
//                                               contact, index, true);
//                                           hideProgress();
//                                           setState(() {});
//                                         },
//                                         child: Text(
//                                           getStatusByType(
//                                               contact.businessPartner),
//                                           style: TextStyle(
//                                               color: isDarkMode(context)
//                                                   ? Colors.white
//                                                   : Colors.black,
//                                               fontWeight: FontWeight.bold),
//                                         ).tr()),
//                                   ),
//                                 ),
//                                 Divider()
//                               ],
//                             );
//                           })
//                       : ListView.builder(
//                           itemCount: snap.hasData ? snap.data.length : 0,
//                           // ignore: missing_return
//                           itemBuilder: (BuildContext context, int index) {
//                             if (snap.hasData) {
//                               _contacts = snap.data;
//                               ContactModel contact = snap.data[index];
//                               return Column(
//                                 children: <Widget>[
//                                   Padding(
//                                     padding: const EdgeInsets.only(
//                                         top: 4.0, bottom: 4.0),
//                                     child: ListTile(
//                                       onTap: () async {
//                                         String channelID;
//                                         if (contact.user.userID
//                                                 .compareTo(user.userID) <
//                                             0) {
//                                           channelID =
//                                               contact.user.userID + user.userID;
//                                         } else {
//                                           channelID =
//                                               user.userID + contact.user.userID;
//                                         }
//                                         ConversationModel conversationModel =
//                                             await fireStoreUtils
//                                                 .getChannelByIdOrNull(
//                                                     channelID);
//                                         push(
//                                           context,
//                                           ChatScreen(
//                                             homeConversationModel:
//                                                 HomeConversationModel(
//                                                     isGroupChat: false,
//                                                     members: [contact.user],
//                                                     conversationModel:
//                                                         conversationModel),
//                                           ),
//                                         );
//                                       },
//                                       leading: displayCircleImage(
//                                           contact.user.profilePictureURL,
//                                           55,
//                                           false),
//                                       title: Text(
//                                         '${contact.user.fullName()}',
//                                         style: TextStyle(
//                                             color: isDarkMode(context)
//                                                 ? Colors.white
//                                                 : Colors.black,
//                                             fontWeight: FontWeight.bold,
//                                             fontSize: 15),
//                                       ),
//                                       trailing: FlatButton(
//                                         shape: RoundedRectangleBorder(
//                                             borderRadius:
//                                                 BorderRadius.circular(20)),
//                                         color: isDarkMode(context)
//                                             ? Colors.grey[700]
//                                             : Colors.grey[200],
//                                         onPressed: () async {
//                                           await _onContactButtonClicked(
//                                               contact, index, false);
//                                           hideProgress();
//                                           setState(() {});
//                                         },
//                                         child: Text(
//                                           getStatusByType(
//                                               contact.businessPartner),
//                                           style: TextStyle(
//                                               color: isDarkMode(context)
//                                                   ? Colors.white
//                                                   : Colors.black,
//                                               fontWeight: FontWeight.bold),
//                                         ).tr(),
//                                       ),
//                                     ),
//                                   ),
//                                   Divider()
//                                 ],
//                               );
//                             }
//                           },
//                         ),
//                 );
//               }
//             },
//           ),
//           SingleChildScrollView(
//             scrollDirection: Axis.horizontal,
//             child: Row(
//               children: [
//                 Column(
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 14.0),
//                       child: displayCircleImage(
//                           user.profilePictureURL, 50.0, false),
//                     ),
//                     Text(user.firstName),
//                   ],
//                 ),
//                 Column(
//                   children: [
//                     displayCircleImage(user.profilePictureURL, 50.0, false),
//                     Text(user.firstName),
//                   ],
//                 ),
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }
//
//   _onSearchTextChanged(String text) async {
//     _searchResult.clear();
//     if (text.isEmpty) {
//       setState(() {});
//       return;
//     }
//     _contacts.forEach((contact) {
//       if (contact.user.fullName().toLowerCase().contains(text.toLowerCase())) {
//         _searchResult.add(contact);
//       }
//     });
//     setState(() {});
//   }
//
//   @override
//   void dispose() {
//     controller.dispose();
//     _searchResult.clear();
//     super.dispose();
//   }
//
//   String getStatusByType(BusinessPartner partner) {
//     switch (partner) {
//       case BusinessPartner.NOTPARTNER:
//         return 'Request';
//         break;
//       case BusinessPartner.REQUESTED:
//         return 'cancel';
//         break;
//       case BusinessPartner.PARTNER:
//         return 'Remove';
//         break;
//       default:
//         return 'Request';
//     }
//   }
//
//   _onContactButtonClicked(
//       ContactModel contact, int index, bool fromSearch) async {
//     switch (contact.businessPartner) {
//       case BusinessPartner.PARTNER:
//         showProgress(context, 'Removing from team', false);
//         await fireStoreUtils.onFriendAccept(contact.user);
//         if (fromSearch) {
//           _searchResult[index].type = ContactType.FRIEND;
//           _contacts
//               .where((user) => user.user.userID == contact.user.userID)
//               .first
//               .type = ContactType.FRIEND;
//         } else {
//           _contacts[index].type = ContactType.FRIEND;
//         }
//         break;
//       case ContactType.FRIEND:
//         showProgress(context, 'removingFriendship'.tr(), false);
//         await fireStoreUtils.onUnFriend(contact.user);
//         if (fromSearch) {
//           _searchResult.removeAt(index);
//           _contacts
//               .removeWhere((item) => item.user.userID == contact.user.userID);
//         } else {
//           _contacts.removeAt(index);
//         }
//
//         break;
//       case ContactType.PENDING:
//         showProgress(context, 'removingFriendshipRequest'.tr(), false);
//         await fireStoreUtils.onCancelRequest(contact.user);
//         if (fromSearch) {
//           _searchResult.removeAt(index);
//           _contacts
//               .removeWhere((item) => item.user.userID == contact.user.userID);
//         } else {
//           _contacts.removeAt(index);
//         }
//         break;
//       case ContactType.BLOCKED:
//         break;
//       case ContactType.UNKNOWN:
//         break;
//     }
//   }
// }
