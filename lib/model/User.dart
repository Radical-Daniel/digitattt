import 'dart:io';
import 'package:instachatty/model/AddressModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class User with ChangeNotifier {
  String email = '';
  String firstName = '';
  String lastName = '';
  Settings settings = Settings(allowPushNotifications: true);
  String phoneNumber = '';
  bool active = false;
  Timestamp lastOnlineTimestamp = Timestamp.now();
  AddressModel address = AddressModel();
  String userID;
  String profilePictureURL = '';
  bool selected = false;
  String fcmToken = '';
  InterestMap interestMap = InterestMap();
  String appIdentifier = 'Flutter Instachatty ${Platform.operatingSystem}';
  bool isPartner = false;
  bool partnerEnabled = false;
  List<dynamic> businessAffiliations = ["none"];
  User(
      {this.email,
      this.firstName,
      this.phoneNumber,
      this.lastName,
      this.active,
      this.interestMap,
      this.lastOnlineTimestamp,
      this.settings,
      this.address,
      this.fcmToken,
      this.userID,
      this.profilePictureURL,
      this.isPartner,
      this.partnerEnabled,
      this.businessAffiliations});

  String fullName() {
    return '$firstName $lastName';
  }

  factory User.fromJson(Map<String, dynamic> parsedJson) {
    return new User(
        email: parsedJson['email'] ?? "",
        firstName: parsedJson['firstName'] ?? '',
        lastName: parsedJson['lastName'] ?? '',
        active: parsedJson['active'] ?? false,
        lastOnlineTimestamp:
            parsedJson['lastOnlineTimestamp'] ?? Timestamp.now(),
        address:
            // AddressModel.fromJson(parsedJson['address']) ??
            AddressModel(),
        settings: Settings.fromJson(
            parsedJson['settings'] ?? {'allowPushNotifications': true}),
        phoneNumber: parsedJson['phoneNumber'] ?? "",
        fcmToken: parsedJson['fcmToken'] ?? '',
        userID: parsedJson['id'] ?? parsedJson['userID'] ?? '',
        profilePictureURL: parsedJson['profilePictureURL'] ?? "",
        isPartner: parsedJson['isPartner'] ?? false,
        partnerEnabled: parsedJson['partnerEnabled'] ?? false,
        businessAffiliations: parsedJson['businessAffiliations'] ?? ['none'],
        interestMap: InterestMap.fromJson(parsedJson['interestMap'] ??
            {
              'interest': {
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
              }
            }));
  }

  Map<String, dynamic> toJson() {
    return {
      'email': this.email,
      'firstName': this.firstName,
      'lastName': this.lastName,
      'settings': this.settings.toJson(),
      'phoneNumber': this.phoneNumber,
      'id': this.userID,
      'userID': this.userID,
      'active': this.active,
      'lastOnlineTimestamp': this.lastOnlineTimestamp,
      'fcmToken': this.fcmToken,
      'address': this.address.toJson(),
      'profilePictureURL': this.profilePictureURL,
      'isPartner': this.isPartner ?? false,
      'partnerEnabled': this.partnerEnabled ?? false,
      'businessAffiliations': this.businessAffiliations,
      'interestMap': this.interestMap.toJson(),
      'appIdentifier': this.appIdentifier
    };
  }
}

class InterestMap {
  Map<String, bool> interest = {
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
  };

  InterestMap({this.interest});

  factory InterestMap.fromJson(Map<String, dynamic> parsedJson) {
    return new InterestMap(interest: {
      'customer': parsedJson['interest']['customer'] ?? true,
      'doctor': parsedJson['interest']['doctor'] ?? false,
      'pharmacist': parsedJson['interest']['pharmacist'] ?? false,
      'laboratory': parsedJson['interest']['laboratory'] ?? false,
      'retail': parsedJson['interest']['retail'] ?? false,
      'ambulance': parsedJson['interest']['ambulance'] ?? false,
      'radiologist': parsedJson['interest']['radiologist'] ?? false,
      'hospital': parsedJson['interest']['hospital'] ?? false,
      'clinic': parsedJson['interest']['clinic'] ?? false,
      'fitness': parsedJson['interest']['fitness'] ?? false,
      'hospitality': parsedJson['interest']['hospitality'] ?? false,
      'insurance': parsedJson['interest']['insurance'] ?? false,
      'travel': parsedJson['interest']['travel'] ?? false,
      'wellness': parsedJson['interest']['wellness'] ?? false,
      'student': parsedJson['interest']['student'] ?? false,
      'education': parsedJson['interest']['education'] ?? false,
    });
  }
  Map<String, dynamic> toJson() {
    return {
      'interest': {
        'customer': this.interest['customer'],
        'doctor': this.interest['doctor'],
        'pharmacist': this.interest['pharmacist'],
        'laboratory': this.interest['laboratory'],
        'retail': this.interest['retail'],
        'ambulance': this.interest['ambulance'],
        'radiologist': this.interest['radiologist'],
        'hospital': this.interest['hospital'],
        'clinic': this.interest['clinic'],
        'fitness': this.interest['fitness'],
        'hospitality': this.interest['hospitality'],
        'insurance': this.interest['insurance'],
        'travel': this.interest['travel'],
        'wellness': this.interest['wellness'],
        'student': this.interest['student'],
        'education': this.interest['education'],
      }
    };
  }
}

class Settings {
  bool allowPushNotifications = true;

  Settings({this.allowPushNotifications});

  factory Settings.fromJson(Map<dynamic, dynamic> parsedJson) {
    return new Settings(
        allowPushNotifications: parsedJson['allowPushNotifications'] ?? true);
  }

  Map<String, dynamic> toJson() {
    return {'allowPushNotifications': this.allowPushNotifications};
  }
}
