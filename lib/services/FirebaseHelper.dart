import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:instachatty/constants.dart';
import 'package:instachatty/model/Business.dart';
import 'package:instachatty/main.dart';
import 'package:instachatty/model/BlockUserModel.dart';
import 'package:instachatty/model/ChannelParticipation.dart';
import 'package:instachatty/model/ChatModel.dart';
import 'package:instachatty/model/ChatVideoContainer.dart';
import 'package:instachatty/model/ContactModel.dart';
import 'package:instachatty/model/ConversationModel.dart';
import 'package:instachatty/model/HomeConversationModel.dart';
import 'package:instachatty/model/MessageData.dart';
import 'package:instachatty/model/User.dart';
import 'package:instachatty/services/Helper.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:instachatty/model/BookingRequest.dart';
import 'package:instachatty/model/Deal.dart';
import 'package:instachatty/model/ImageDetailModel.dart';
import 'package:instachatty/model/momentModel.dart';

class FireStoreUtils {
  static FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  static Firestore firestore = Firestore.instance;
  StorageReference storage = FirebaseStorage.instance.ref();
  List<User> friends = [];
  List<Business> businesses = [];
  List<Employee> businessPartners = [];
  List<User> pendingList = [];
  List<User> receivedRequests = [];
  Moment myMoment;
  List<ContactModel> contactsList = [];
  StreamController<List<HomeConversationModel>> conversationsStream;
  StreamController<List<ImageDetails>> imageDetailStream;
  StreamController<List<Deal>> sentDealStream;
  StreamController<List<Deal>> receivedDealStream;
  List<Deal> sentDeals = [];
  List<ImageDetails> imageDetails = [];
  List<Deal> receivedDeals = [];
  List<HomeConversationModel> homeConversations = [];
  List<BlockUserModel> blockedList = [];

  Future<User> getCurrentUser(String uid) async {
    DocumentSnapshot userDocument =
        await firestore.collection(USERS).document(uid).get();
    if (userDocument != null && userDocument.exists) {
      return User.fromJson(userDocument.data);
    } else {
      return null;
    }
  }

  Future<Moment> getMyMoment(String uid) async {
    await firestore
        .collection(MOMENTS)
        .document(uid)
        .collection(MY_MOMENTS)
        .getDocuments()
        .then((value) =>
            myMoment = new Moment.fromJson(value.documents.last.data));
    // myMoment = moment;
    return myMoment;
  }

  Future<Business> getCurrentBusiness(String uid) async {
    DocumentSnapshot userDocument =
        await firestore.collection(BUSINESSES).document(uid).get();
    if (userDocument != null && userDocument.exists) {
      print('got the thing');
      return Business.fromJson(userDocument.data);
    } else {
      print("didn't get the thing");
      return null;
    }
  }

  static void updateUserState(user) async {
    await FireStoreUtils.updateCurrentUser(user);
    MyAppState.currentUser = user;
  }

  static Future<User> updateCurrentUser(User user) async {
    return await firestore
        .collection(USERS)
        .document(user.userID)
        .setData(user.toJson())
        .then((document) {
      return user;
    });
  }

  static Future<Deal> updateCustomerCurrentSentDeal(Deal deal) async {
    return await firestore
        .collection(DEALS)
        .document(deal.customerID)
        .collection(SENT_DEALS)
        .document(deal.requestID)
        .setData(deal.toJson())
        .then((document) {
      return deal;
    });
  }

  static Future<Deal> updateCustomerCurrentReceivedDeal(Deal deal) async {
    return await firestore
        .collection(DEALS)
        .document(deal.customerID)
        .collection(RECEIVED_DEALS)
        .document(deal.requestID)
        .setData(deal.toJson())
        .then((document) {
      return deal;
    });
  }

  static Future<Deal> updateSellerCurrentSentDeal(Deal deal) async {
    return await firestore
        .collection(DEALS)
        .document(deal.sellerID)
        .collection(SENT_DEALS)
        .document(deal.requestID)
        .setData(deal.toJson())
        .then((document) {
      return deal;
    });
  }

  static Future<Deal> updateSellerCurrentReceivedDeal(Deal deal) async {
    return await firestore
        .collection(DEALS)
        .document(deal.sellerID)
        .collection(RECEIVED_DEALS)
        .document(deal.requestID)
        .setData(deal.toJson())
        .then((document) {
      return deal;
    });
  }

  static Future<Business> updateCurrentBusiness(Business business) async {
    return await firestore
        .collection(BUSINESSES)
        .document(business.businessID)
        .setData(business.toJson())
        .then((document) {
      return business;
    });
  }

  Future<String> uploadUserImageToFireStorage(File image, String userID) async {
    StorageReference upload = storage.child("images/$userID.png");
    StorageUploadTask uploadTask = upload.putFile(image);
    var downloadUrl = await (await uploadTask.onComplete).ref.getDownloadURL();
    return downloadUrl.toString();
  }

  Future<String> uploadUserImageMomentToFireStorage(
      File image, String userID) async {
    StorageReference upload = storage.child("images/$userID.png");
    StorageUploadTask uploadTask = upload.putFile(image);
    var downloadUrl = await (await uploadTask.onComplete).ref.getDownloadURL();
    return downloadUrl.toString();
  }

  Future<String> uploadBusinessImageToFireStorage(
      File image, String businessID) async {
    StorageReference upload = storage.child("images/$businessID.png");
    StorageUploadTask uploadTask = upload.putFile(image);
    var downloadUrl = await (await uploadTask.onComplete).ref.getDownloadURL();
    return downloadUrl.toString();
  }

  Future<Url> uploadChatImageToFireStorage(
      File image, BuildContext context) async {
    showProgress(context, 'Uploading image...', false);
    var uniqueID = Uuid().v4();
    StorageReference upload = storage.child("images/$uniqueID.png");
    StorageUploadTask uploadTask = upload.putFile(image);
    uploadTask.events.listen((event) {
      updateProgress(
          'Uploading image ${(event.snapshot.bytesTransferred.toDouble() / 1000).toStringAsFixed(2)} /'
          '${(event.snapshot.totalByteCount.toDouble() / 1000).toStringAsFixed(2)} '
          'KB');
    });
    uploadTask.onComplete.catchError((onError) {
      print((onError as PlatformException).message);
    });
    var storageRef = (await uploadTask.onComplete).ref;
    var downloadUrl = await storageRef.getDownloadURL();
    var metaData = await storageRef.getMetadata();
    hideProgress();
    return Url(mime: metaData.contentType, url: downloadUrl.toString());
  }

  Future<ChatVideoContainer> uploadChatVideoToFireStorage(
      File video, BuildContext context) async {
    showProgress(context, 'Uploading video...', false);
    var uniqueID = Uuid().v4();
    StorageReference upload = storage.child("videos/$uniqueID.mp4");
    StorageMetadata metadata = new StorageMetadata(contentType: 'video');
    StorageUploadTask uploadTask = upload.putFile(video, metadata);
    uploadTask.events.listen((event) {
      updateProgress(
          'Uploading video ${(event.snapshot.bytesTransferred.toDouble() / 1000).toStringAsFixed(2)} /'
          '${(event.snapshot.totalByteCount.toDouble() / 1000).toStringAsFixed(2)} '
          'KB');
    });
    var storageRef = (await uploadTask.onComplete).ref;
    var downloadUrl = await storageRef.getDownloadURL();
    var metaData = await storageRef.getMetadata();
    final uint8list = await VideoThumbnail.thumbnailFile(
        video: downloadUrl,
        thumbnailPath: (await getTemporaryDirectory()).path,
        imageFormat: ImageFormat.PNG);
    final file = File(uint8list);
    String thumbnailDownloadUrl = await uploadVideoThumbnailToFireStorage(file);
    hideProgress();
    return ChatVideoContainer(
        videoUrl: Url(url: downloadUrl.toString(), mime: metaData.contentType),
        thumbnailUrl: thumbnailDownloadUrl);
  }

  Future<String> uploadVideoThumbnailToFireStorage(File file) async {
    var uniqueID = Uuid().v4();
    StorageReference upload = storage.child("thumbnails/$uniqueID.png");
    StorageUploadTask uploadTask = upload.putFile(file);
    var downloadUrl = await (await uploadTask.onComplete).ref.getDownloadURL();
    return downloadUrl.toString();
  }

  Future<List<ContactModel>> getContacts(
      String userID, bool searchScreen) async {
    friends = await getFriends();
    pendingList = await getPendingRequests();
    receivedRequests = await getReceivedRequests();
    contactsList = [];
    for (final friend in friends) {
      contactsList.add(ContactModel(type: ContactType.FRIEND, user: friend));
    }

    for (final pendingUser in pendingList) {
      contactsList
          .add(ContactModel(type: ContactType.PENDING, user: pendingUser));
    }
    for (final newFriendRequest in receivedRequests) {
      contactsList
          .add(ContactModel(type: ContactType.ACCEPT, user: newFriendRequest));
    }

    if (searchScreen) {
      await firestore.collection(USERS).getDocuments().then((onValue) {
        onValue.documents.asMap().forEach((index, user) {
          User contact = User.fromJson(user.data);
          User friend = friends.firstWhere(
              (user) => user.userID == contact.userID,
              orElse: () => null);
          User pending = pendingList.firstWhere(
              (user) => user.userID == contact.userID,
              orElse: () => null);
          User sent = receivedRequests.firstWhere(
              (user) => user.userID == contact.userID,
              orElse: () => null);
          bool isUnknown = friend == null && pending == null && sent == null;
          if (user.documentID != userID) {
            if (isUnknown) {
              if (contact.userID.isEmpty) contact.userID = user.documentID;
              contactsList
                  .add(ContactModel(type: ContactType.UNKNOWN, user: contact));
            }
          }
        });
      }, onError: (e) {
        print('error $e');
      });
    }
    return contactsList.toSet().toList();
  }

  Future<List<Business>> getBusinesses(
      String businessID, bool searchScreen) async {
    print("started");
    businesses = [];
    await firestore.collection(BUSINESSES).getDocuments().then((onValue) {
      print("maga");
      onValue.documents.asMap().forEach((index, partner) {
        print(partner.data);
        Business business = Business.fromJson(partner.data);

        businesses.add(business);
        print(businesses.length);
        print(businesses.length);
      });
    }, onError: (e) {
      print('error by the $e');
    });
    return businesses;
  }

  Future<List<User>> getFriends() async {
    List<User> receivedFriends = [];
    List<User> actualFriends = [];
    QuerySnapshot receivedFriendsResult = await firestore
        .collection(SOCIAL_GRAPH)
        .document(MyAppState.currentUser.userID)
        .collection(RECEIVED_FRIEND_REQUESTS)
        .getDocuments();
    QuerySnapshot sentFriendsResult = await firestore
        .collection(SOCIAL_GRAPH)
        .document(MyAppState.currentUser.userID)
        .collection(SENT_FRIEND_REQUESTS)
        .getDocuments();

    await Future.forEach(receivedFriendsResult.documents,
        (DocumentSnapshot receivedFriend) {
      receivedFriends.add(User.fromJson(receivedFriend.data));
    });

    await Future.forEach(sentFriendsResult.documents,
        (DocumentSnapshot receivedFriend) {
      User pendingUser = User.fromJson(receivedFriend.data);
      User friendOrNull = receivedFriends.firstWhere(
          (element) => element.userID == pendingUser.userID,
          orElse: () => null);
      if (friendOrNull != null) actualFriends.add(pendingUser);
    });
    return actualFriends.toSet().toList();
  }

  Future<List<User>> getPendingRequests() async {
    List<User> pendingList = [];
    List<User> receivedList = [];
    QuerySnapshot sentRequestsResult = await firestore
        .collection(SOCIAL_GRAPH)
        .document(MyAppState.currentUser.userID)
        .collection(SENT_FRIEND_REQUESTS)
        .getDocuments();

    QuerySnapshot receivedRequestsResult = await firestore
        .collection(SOCIAL_GRAPH)
        .document(MyAppState.currentUser.userID)
        .collection(RECEIVED_FRIEND_REQUESTS)
        .getDocuments();

    await Future.forEach(receivedRequestsResult.documents,
        (DocumentSnapshot user) {
      receivedList.add(User.fromJson(user.data));
    });

    await Future.forEach(sentRequestsResult.documents,
        (DocumentSnapshot document) {
      User user = User.fromJson(document.data);
      User pendingOrNull = receivedList.firstWhere(
          (element) => element.userID == user.userID,
          orElse: () => null);
      if (pendingOrNull == null) pendingList.add(user);
    });
    return pendingList.toSet().toList();
  }

  Future<List<User>> getReceivedRequests() async {
    List<User> receivedList = [];
    List<User> pendingList = [];
    QuerySnapshot receivedRequestsResult = await firestore
        .collection(SOCIAL_GRAPH)
        .document(MyAppState.currentUser.userID)
        .collection(RECEIVED_FRIEND_REQUESTS)
        .getDocuments();

    QuerySnapshot sentRequestsResult = await firestore
        .collection(SOCIAL_GRAPH)
        .document(MyAppState.currentUser.userID)
        .collection(SENT_FRIEND_REQUESTS)
        .getDocuments();

    await Future.forEach(sentRequestsResult.documents, (DocumentSnapshot user) {
      pendingList.add(User.fromJson(user.data));
    });

    await Future.forEach(receivedRequestsResult.documents,
        (DocumentSnapshot document) {
      User sentFriend = User.fromJson(document.data);
      User sentOrNull = pendingList.firstWhere(
          (element) => element.userID == sentFriend.userID,
          orElse: () => null);
      if (sentOrNull == null) receivedList.add(sentFriend);
    });

    return receivedList.toSet().toList();
  }

  onFriendAccept(User pendingUser) async {
    await firestore
        .collection(SOCIAL_GRAPH)
        .document(MyAppState.currentUser.userID)
        .collection(SENT_FRIEND_REQUESTS)
        .document(pendingUser.userID)
        .setData(pendingUser.toJson());

    await firestore
        .collection(SOCIAL_GRAPH)
        .document(pendingUser.userID)
        .collection(RECEIVED_FRIEND_REQUESTS)
        .document(MyAppState.currentUser.userID)
        .setData(MyAppState.currentUser.toJson());

    pendingList.remove(pendingUser);
    friends.add(pendingUser);
    if (pendingUser.settings.allowPushNotifications) {
      await sendNotification(pendingUser.fcmToken,
          MyAppState.currentUser.fullName(), 'Accepted your friend request.');
    }
  }

  onUnFriend(User friend) async {
    await firestore
        .collection(SOCIAL_GRAPH)
        .document(MyAppState.currentUser.userID)
        .collection(SENT_FRIEND_REQUESTS)
        .document(friend.userID)
        .delete();

    await firestore
        .collection(SOCIAL_GRAPH)
        .document(MyAppState.currentUser.userID)
        .collection(RECEIVED_FRIEND_REQUESTS)
        .document(friend.userID)
        .delete();
    await firestore
        .collection(SOCIAL_GRAPH)
        .document(friend.userID)
        .collection(SENT_FRIEND_REQUESTS)
        .document(MyAppState.currentUser.userID)
        .delete();
    await firestore
        .collection(SOCIAL_GRAPH)
        .document(friend.userID)
        .collection(RECEIVED_FRIEND_REQUESTS)
        .document(MyAppState.currentUser.userID)
        .delete();

    friends.remove(friend);
    ContactModel unknownContact =
        contactsList.firstWhere((contact) => contact.user == friend);
    contactsList.remove(unknownContact);
    unknownContact.type = ContactType.UNKNOWN;
    contactsList.add(unknownContact);
  }

  onUnPartner(User friend) async {
    await firestore
        .collection(SOCIAL_GRAPH)
        .document(MyAppState.currentUser.userID)
        .collection(SENT_PARTNER_REQUESTS)
        .document(friend.userID)
        .delete();

    await firestore
        .collection(SOCIAL_GRAPH)
        .document(MyAppState.currentUser.userID)
        .collection(RECEIVED_PARTNER_REQUESTS)
        .document(friend.userID)
        .delete();
    await firestore
        .collection(SOCIAL_GRAPH)
        .document(friend.userID)
        .collection(SENT_PARTNER_REQUESTS)
        .document(MyAppState.currentUser.userID)
        .delete();
    await firestore
        .collection(SOCIAL_GRAPH)
        .document(friend.userID)
        .collection(RECEIVED_PARTNER_REQUESTS)
        .document(MyAppState.currentUser.userID)
        .delete();

    friends.remove(friend);
    ContactModel unknownContact =
        contactsList.firstWhere((contact) => contact.user == friend);
    contactsList.remove(unknownContact);
    unknownContact.type = ContactType.UNKNOWN;
    contactsList.add(unknownContact);
  }

  onCancelRequest(User user) async {
    await firestore
        .collection(SOCIAL_GRAPH)
        .document(MyAppState.currentUser.userID)
        .collection(SENT_FRIEND_REQUESTS)
        .document(user.userID)
        .delete();
    await firestore
        .collection(SOCIAL_GRAPH)
        .document(user.userID)
        .collection(RECEIVED_FRIEND_REQUESTS)
        .document(MyAppState.currentUser.userID)
        .delete();

    pendingList.remove(user);
    ContactModel unknownContact =
        contactsList.firstWhere((contact) => contact.user == user);
    contactsList.remove(unknownContact);
    unknownContact.type = ContactType.UNKNOWN;
    contactsList.add(unknownContact);
  }

  sendFriendRequest(User user) async {
    await firestore
        .collection(SOCIAL_GRAPH)
        .document(MyAppState.currentUser.userID)
        .collection(SENT_FRIEND_REQUESTS)
        .document(user.userID)
        .setData(user.toJson());
    await firestore
        .collection(SOCIAL_GRAPH)
        .document(user.userID)
        .collection(RECEIVED_FRIEND_REQUESTS)
        .document(MyAppState.currentUser.userID)
        .setData(MyAppState.currentUser.toJson());
    pendingList.add(user);
    ContactModel pendingContact =
        contactsList.firstWhere((contact) => contact.user == user);
    contactsList.remove(pendingContact);
    pendingContact.type = ContactType.PENDING;
    contactsList.add(pendingContact);
    if (user.settings.allowPushNotifications) {
      await sendNotification(user.fcmToken, MyAppState.currentUser.fullName(),
          'Sent you a friend request.');
    }
  }

  Stream<List<HomeConversationModel>> getConversations(String userID) async* {
    conversationsStream = StreamController<List<HomeConversationModel>>();
    HomeConversationModel newHomeConversation;

    firestore
        .collection(CHANNEL_PARTICIPATION)
        .where('user', isEqualTo: userID)
        .snapshots()
        .listen((querySnapshot) {
      if (querySnapshot.documents.isEmpty) {
        conversationsStream.sink.add(homeConversations);
      } else {
        homeConversations.clear();
        Future.forEach(querySnapshot.documents, (DocumentSnapshot document) {
          if (document != null && document.exists) {
            ChannelParticipation participation =
                ChannelParticipation.fromJson(document.data);
            firestore
                .collection(CHANNELS)
                .document(participation.channel)
                .snapshots()
                .listen((channel) async {
              if (channel != null && channel.exists) {
                bool isGroupChat = !channel.documentID.contains(userID);
                List<User> users = [];
                if (isGroupChat) {
                  getGroupMembers(channel.documentID).listen((listOfUsers) {
                    if (listOfUsers.isNotEmpty) {
                      users = listOfUsers;
                      newHomeConversation = HomeConversationModel(
                          conversationModel:
                              ConversationModel.fromJson(channel.data),
                          isGroupChat: isGroupChat,
                          members: users);

                      if (newHomeConversation.conversationModel.id.isEmpty)
                        newHomeConversation.conversationModel.id =
                            channel.documentID;

                      homeConversations
                          .removeWhere((conversationModelToDelete) {
                        return newHomeConversation.conversationModel.id ==
                            conversationModelToDelete.conversationModel.id;
                      });
                      homeConversations.add(newHomeConversation);
                      homeConversations.sort((a, b) => a
                          .conversationModel.lastMessageDate
                          .compareTo(b.conversationModel.lastMessageDate));
                      conversationsStream.sink
                          .add(homeConversations.reversed.toList());
                    }
                  });
                } else {
                  getUserByID(channel.documentID.replaceAll(userID, ''))
                      .listen((user) {
                    users.clear();
                    users.add(user);
                    newHomeConversation = HomeConversationModel(
                        conversationModel:
                            ConversationModel.fromJson(channel.data),
                        isGroupChat: isGroupChat,
                        members: users);

                    if (newHomeConversation.conversationModel.id.isEmpty)
                      newHomeConversation.conversationModel.id =
                          channel.documentID;

                    homeConversations.removeWhere((conversationModelToDelete) {
                      return newHomeConversation.conversationModel.id ==
                          conversationModelToDelete.conversationModel.id;
                    });

                    homeConversations.add(newHomeConversation);
                    homeConversations.sort((a, b) => a
                        .conversationModel.lastMessageDate
                        .compareTo(b.conversationModel.lastMessageDate));
                    conversationsStream.sink
                        .add(homeConversations.reversed.toList());
                  });
                }
              }
            });
          }
        });
      }
    });
    yield* conversationsStream.stream;
  }

  Stream<List<ImageDetails>> getDealDetailImagesSent(String requestID) async* {
    imageDetailStream = StreamController<List<ImageDetails>>();
    firestore
        .collection(DETAILS)
        .document(requestID)
        .collection(DETAILS_IMAGES)
        .snapshots()
        .listen((querySnapshot) {
      print(querySnapshot.documents.first.data);
      if (querySnapshot.documents.isEmpty) {
        imageDetailStream.sink.add(imageDetails);
      } else {
        if (imageDetails.isNotEmpty) {
          imageDetails.clear();
        }
        Future.forEach(querySnapshot.documents, (DocumentSnapshot document) {
          if (document != null && document.exists) {
            ImageDetails imageDetail = ImageDetails.fromJson(document.data);
            imageDetails.add(imageDetail);
            imageDetailStream.sink.add(imageDetails);
          }
        });
      }
    });

    yield* imageDetailStream.stream;
  }

  Stream<List<Deal>> getDealRequestsSent(String userID) async* {
    sentDealStream = StreamController<List<Deal>>();
    firestore
        .collection(DEALS)
        .document(userID)
        .collection(SENT_DEALS)
        .snapshots()
        .listen((querySnapshot) {
      if (querySnapshot.documents.isEmpty) {
        sentDealStream.sink.add(sentDeals);
      } else {
        if (sentDeals.isNotEmpty) {
          sentDeals.clear();
        }
        Future.forEach(querySnapshot.documents, (DocumentSnapshot document) {
          if (document != null && document.exists) {
            Deal dealRequest = Deal.fromJson(document.data);
            sentDeals.add(dealRequest);
            sentDealStream.sink.add(sentDeals);
          }
        });
      }
    });

    yield* sentDealStream.stream;
  }

  Stream<List<Deal>> getDealRequestsReceived(String userID) async* {
    receivedDealStream = StreamController<List<Deal>>();
    firestore
        .collection(DEALS)
        .document(userID)
        .collection(RECEIVED_DEALS)
        .snapshots()
        .listen((querySnapshot) {
      print(querySnapshot.documents.first.data);
      if (querySnapshot.documents.isEmpty) {
        receivedDealStream.sink.add(receivedDeals);
      } else {
        if (receivedDeals.isNotEmpty) {
          receivedDeals.clear();
        }
        Future.forEach(querySnapshot.documents, (DocumentSnapshot document) {
          if (document != null && document.exists) {
            Deal deal = Deal.fromJson(document.data);
            receivedDeals.add(deal);
            receivedDealStream.sink.add(receivedDeals);
          }
        });
      }
    });

    yield* receivedDealStream.stream;
  }

  Stream<List<User>> getGroupMembers(String channelID) async* {
    StreamController<List<User>> membersStreamController = StreamController();
    getGroupMembersIDs(channelID).listen((memberIDs) {
      if (memberIDs.isNotEmpty) {
        List<User> groupMembers = [];
        for (String id in memberIDs) {
          getUserByID(id).listen((user) {
            groupMembers.add(user);
            membersStreamController.sink.add(groupMembers);
          });
        }
      } else {
        membersStreamController.sink.add([]);
      }
    });
    yield* membersStreamController.stream;
  }

  Stream<List<String>> getGroupMembersIDs(String channelID) async* {
    StreamController<List<String>> membersIDsStreamController =
        StreamController();
    firestore
        .collection(CHANNEL_PARTICIPATION)
        .where('channel', isEqualTo: channelID)
        .snapshots()
        .listen((participations) {
      List<String> uids = [];
      for (DocumentSnapshot document in participations.documents) {
        uids.add(document.data['user'] ?? '');
      }
      if (uids.contains(MyAppState.currentUser.userID)) {
        membersIDsStreamController.sink.add(uids);
      } else {
        membersIDsStreamController.sink.add([]);
      }
    });
    yield* membersIDsStreamController.stream;
  }

  Stream<User> getUserByID(String id) async* {
    StreamController<User> userStreamController = StreamController();
    firestore.collection(USERS).document(id).snapshots().listen((user) {
      userStreamController.sink.add(User.fromJson(user.data));
    });
    yield* userStreamController.stream;
  }

  Future<ConversationModel> getChannelByIdOrNull(String channelID) async {
    ConversationModel conversationModel;
    await firestore.collection(CHANNELS).document(channelID).get().then(
        (channel) {
      if (channel != null && channel.exists) {
        conversationModel = ConversationModel.fromJson(channel.data);
      }
    }, onError: (e) {
      print((e as PlatformException).message);
    });
    return conversationModel;
  }

  Stream<ChatModel> getChatMessages(
      HomeConversationModel homeConversationModel) async* {
    StreamController<ChatModel> chatModelStreamController = StreamController();
    ChatModel chatModel = ChatModel();
    List<MessageData> listOfMessages = [];
    List<User> listOfMembers = homeConversationModel.members;
    if (homeConversationModel.isGroupChat) {
      homeConversationModel.members.forEach((groupMember) {
        if (groupMember.userID != MyAppState.currentUser.userID) {
          getUserByID(groupMember.userID).listen((updatedUser) {
            for (int i = 0; i < listOfMembers.length; i++) {
              if (listOfMembers[i].userID == updatedUser.userID) {
                listOfMembers[i] = updatedUser;
              }
            }
            chatModel.message = listOfMessages;
            chatModel.members = listOfMembers;
            chatModelStreamController.sink.add(chatModel);
          });
        }
      });
    } else {
      User friend = homeConversationModel.members.first;
      getUserByID(friend.userID).listen((user) {
        listOfMembers.clear();
        listOfMembers.add(user);
        chatModel.message = listOfMessages;
        chatModel.members = listOfMembers;
        chatModelStreamController.sink.add(chatModel);
      });
    }
    if (homeConversationModel.conversationModel != null) {
      firestore
          .collection(CHANNELS)
          .document(homeConversationModel.conversationModel.id)
          .collection(THREAD)
          .orderBy('createdAt', descending: true)
          .snapshots()
          .listen((onData) {
        listOfMessages.clear();
        onData.documents.forEach((document) {
          listOfMessages.add(MessageData.fromJson(document.data));
        });
        chatModel.message = listOfMessages;
        chatModel.members = listOfMembers;
        chatModelStreamController.sink.add(chatModel);
      });
    }
    yield* chatModelStreamController.stream;
  }

  Future<void> sendMessage(
      List<User> members,
      bool isGroup,
      MessageData message,
      ConversationModel conversationModel,
      bool notify) async {
    var ref = firestore
        .collection(CHANNELS)
        .document(conversationModel.id)
        .collection(THREAD)
        .document();
    message.messageID = ref.documentID;
    ref.setData(message.toJson());
    await Future.forEach(members, (User element) async {
      if (notify) if (element.settings.allowPushNotifications) {
        await sendNotification(
            element.fcmToken,
            isGroup
                ? conversationModel.name
                : MyAppState.currentUser.fullName(),
            message.content);
      }
    });
  }

  Future<bool> createConversation(ConversationModel conversation) async {
    bool isSuccessful;
    await firestore
        .collection(CHANNELS)
        .document(conversation.id)
        .setData(conversation.toJson())
        .then((onValue) async {
      ChannelParticipation myChannelParticipation = ChannelParticipation(
          user: MyAppState.currentUser.userID, channel: conversation.id);
      ChannelParticipation myFriendParticipation = ChannelParticipation(
          user: conversation.id.replaceAll(MyAppState.currentUser.userID, ''),
          channel: conversation.id);
      await createChannelParticipation(myChannelParticipation);
      await createChannelParticipation(myFriendParticipation);
      isSuccessful = true;
    }, onError: (e) {
      print((e as PlatformException).message);
      isSuccessful = false;
    });
    return isSuccessful;
  }

  Future<void> updateChannel(ConversationModel conversationModel) async {
    await firestore
        .collection(CHANNELS)
        .document(conversationModel.id)
        .updateData(conversationModel.toJson());
  }

  Future<void> createChannelParticipation(
      ChannelParticipation channelParticipation) async {
    await firestore
        .collection(CHANNEL_PARTICIPATION)
        .add(channelParticipation.toJson());
  }

  Future<List<User>> getAllUsers() async {
    List<User> users = [];
    await firestore.collection(USERS).getDocuments().then((onValue) {
      Future.forEach(onValue.documents, (DocumentSnapshot document) {
        if (document.documentID != MyAppState.currentUser.userID)
          users.add(User.fromJson(document.data));
      });
    });
    return users;
  }

  Future<HomeConversationModel> createGroupChat(
      List<User> selectedUsers, String groupName) async {
    HomeConversationModel groupConversationModel;
    DocumentReference channelDoc = firestore.collection(CHANNELS).document();
    ConversationModel conversationModel = ConversationModel();
    conversationModel.id = channelDoc.documentID;
    conversationModel.creatorId = MyAppState.currentUser.userID;
    conversationModel.name = groupName;
    conversationModel.lastMessage =
        "${MyAppState.currentUser.fullName()} created this group";
    conversationModel.lastMessageDate = Timestamp.now();
    await channelDoc.setData(conversationModel.toJson()).then((onValue) async {
      selectedUsers.add(MyAppState.currentUser);
      for (User user in selectedUsers) {
        ChannelParticipation channelParticipation = ChannelParticipation(
            channel: conversationModel.id, user: user.userID);
        await createChannelParticipation(channelParticipation);
      }
      groupConversationModel = HomeConversationModel(
          isGroupChat: true,
          members: selectedUsers,
          conversationModel: conversationModel);
    });
    return groupConversationModel;
  }

  Future<bool> leaveGroup(ConversationModel conversationModel) async {
    bool isSuccessful = false;
    conversationModel.lastMessage = "${MyAppState.currentUser.fullName()} left";
    conversationModel.lastMessageDate = Timestamp.now();
    await updateChannel(conversationModel).then((_) async {
      await firestore
          .collection(CHANNEL_PARTICIPATION)
          .where('channel', isEqualTo: conversationModel.id)
          .where('user', isEqualTo: MyAppState.currentUser.userID)
          .getDocuments()
          .then((onValue) async {
        await firestore
            .collection(CHANNEL_PARTICIPATION)
            .document(onValue.documents.first.documentID)
            .delete()
            .then((onValue) {
          isSuccessful = true;
        });
      });
    });
    return isSuccessful;
  }

  Future<bool> blockUser(User blockedUser, String type) async {
    bool isSuccessful = false;
    BlockUserModel blockUserModel = BlockUserModel(
        type: type,
        source: MyAppState.currentUser.userID,
        dest: blockedUser.userID,
        createdAt: Timestamp.now());
    await firestore
        .collection(REPORTS)
        .add(blockUserModel.toJson())
        .then((onValue) {
      isSuccessful = true;
    });
    return isSuccessful;
  }

  Stream<bool> getBlocks() async* {
    StreamController<bool> refreshStreamController = StreamController();
    firestore
        .collection(REPORTS)
        .where('source', isEqualTo: MyAppState.currentUser.userID)
        .snapshots()
        .listen((onData) {
      List<BlockUserModel> list = [];
      for (DocumentSnapshot block in onData.documents) {
        list.add(BlockUserModel.fromJson(block.data));
      }
      blockedList = list;

      if (homeConversations.isNotEmpty || friends.isNotEmpty) {
        refreshStreamController.sink.add(true);
      }
    });
    yield* refreshStreamController.stream;
  }

  bool validateIfUserBlocked(String userID) {
    for (BlockUserModel blockedUser in blockedList) {
      if (userID == blockedUser.dest) {
        return true;
      }
    }
    return false;
  }

  Future<Url> uploadAudioFile(File file, BuildContext context) async {
    showProgress(context, 'Uploading Audio...', false);
    var uniqueID = Uuid().v4();
    StorageReference upload = storage.child("audio/$uniqueID.mp3");
    StorageUploadTask uploadTask = upload.putFile(file);
    uploadTask.events.listen((event) {
      updateProgress(
          'Uploading Audio ${(event.snapshot.bytesTransferred.toDouble() / 1000).toStringAsFixed(2)} /'
          '${(event.snapshot.totalByteCount.toDouble() / 1000).toStringAsFixed(2)} '
          'KB');
    });
    uploadTask.onComplete.catchError((onError) {
      print((onError as PlatformException).message);
    });
    var storageRef = (await uploadTask.onComplete).ref;
    var downloadUrl = await storageRef.getDownloadURL();
    var metaData = await storageRef.getMetadata();
    hideProgress();
    return Url(mime: metaData.contentType, url: downloadUrl.toString());
  }
}

sendNotification(String token, String title, String body) async {
  await http.post(
    'https://fcm.googleapis.com/fcm/send',
    headers: <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'key=$SERVER_KEY',
    },
    body: jsonEncode(
      <String, dynamic>{
        'notification': <String, dynamic>{'body': body, 'title': title},
        'priority': 'high',
        'data': <String, dynamic>{
          'click_action': 'FLUTTER_NOTIFICATION_CLICK',
          'id': '1',
          'status': 'done'
        },
        'to': token
      },
    ),
  );
}

sendPayLoad(String token, {Map<String, dynamic> callData}) async {
  print('sendPayLoad $token');
  await http.post(
    'https://fcm.googleapis.com/fcm/send',
    headers: <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'key=$SERVER_KEY',
    },
    body: jsonEncode(
      <String, dynamic>{
        'priority': 'high',
        'data': {'callData': callData},
        'to': token
      },
    ),
  );
}
