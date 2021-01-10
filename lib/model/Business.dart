import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:instachatty/model/User.dart';
import 'package:instachatty/model/ServiceModel.dart';

class Business with ChangeNotifier {
  bool isHealthService = false;
  String businessRepID;
  List<dynamic> businessTeam = [];
  String businessName = '';
  String businessAbout = '';
  List<dynamic> businessAddress = [];
  String businessEmail = '';
  List<dynamic> businessPhoneNumber = [];
  List<dynamic> businessServices = [];
  bool active = true;
  Timestamp lastOnlineTimestamp = Timestamp.now();
  String businessID;
  String businessLogoURL = '';
  // bool selected = false;

  Business({
    this.isHealthService,
    this.businessRepID,
    this.businessTeam,
    this.businessName,
    this.businessAbout,
    this.businessAddress,
    this.businessEmail,
    this.businessPhoneNumber,
    this.businessServices,
    this.active,
    this.lastOnlineTimestamp,
    this.businessID,
    this.businessLogoURL,
    // this.selected,
  });

  factory Business.fromJson(Map<String, dynamic> parsedJson) {
    return new Business(
        isHealthService: parsedJson['isHealthService'] ?? false,
        businessRepID: parsedJson['businessRepID'] ?? '',
        businessTeam: parsedJson['businessTeam'] ?? [],
        businessName: parsedJson['businessName'] ?? '',
        businessAbout: parsedJson['businessAbout'] ?? '',
        businessAddress: parsedJson['businessAddress'] ?? '',
        businessEmail: parsedJson['businessEmail'] ?? '',
        businessPhoneNumber: parsedJson['businessPhoneNumber'] ?? [],
        businessServices: parsedJson['businessServices'] ?? [],
        active: parsedJson['active'] ?? true,
        lastOnlineTimestamp:
            parsedJson['lastOnlineTimestamp'] ?? Timestamp.now(),
        businessID: parsedJson['id'] ?? parsedJson['businessID'] ?? '',
        businessLogoURL: parsedJson['businessLogoURL'] ?? "");
  }
  Map<String, dynamic> toJson() {
    return {
      'isHealthService': this.isHealthService,
      'businessRepID': this.businessRepID,
      'businessTeam':
          this.businessTeam.map((employee) => employee.toJson()).toList(),
      'businessName': this.businessName,
      'businessAbout': this.businessAbout,
      'businessAddress':
          this.businessAddress.map((address) => address.toJson()).toList(),
      'businessEmail': this.businessEmail,
      'businessPhoneNumber': this.businessPhoneNumber,
      'businessServices':
          this.businessServices.map((services) => services.toJson()).toList(),
      'active': this.active,
      'lastOnlineTimestamp': this.lastOnlineTimestamp,
      'businessID': this.businessID,
      'businessLogoURL': this.businessLogoURL,
    };
  }
}

class Employee {
  User employee;
  bool isVisible;

  Employee({this.employee, this.isVisible});

  factory Employee.fromJson(Map<dynamic, dynamic> parsedJson) {
    return new Employee(
      employee: parsedJson['employee'] ?? User(),
      isVisible: parsedJson['isVisible'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {'employee': this.employee.toJson(), 'isVisible': this.isVisible};
  }
}
