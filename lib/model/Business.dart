import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:instachatty/model/User.dart';

class Business with ChangeNotifier {
  bool isHealthBusiness = false;
  String businessRepID;
  List<dynamic> businessTeam = [];
  String businessName = '';
  String businessAbout = '';
  List<dynamic> businessAddress = [];
  String businessEmail = '';
  List<dynamic> businessPhoneNumber = [];
  ServicesMap servicesMap = ServicesMap();
  bool active = true;
  Timestamp lastOnlineTimestamp = Timestamp.now();
  String businessID;
  String businessLogoURL = '';
  // bool selected = false;

  Business({
    this.isHealthBusiness,
    this.businessRepID,
    this.businessTeam,
    this.businessName,
    this.businessAbout,
    this.businessAddress,
    this.businessEmail,
    this.businessPhoneNumber,
    this.servicesMap,
    this.active,
    this.lastOnlineTimestamp,
    this.businessID,
    this.businessLogoURL,
    // this.selected,
  });

  factory Business.fromJson(Map<String, dynamic> parsedJson) {
    return new Business(
        isHealthBusiness: parsedJson['isHealthBusiness'] ?? false,
        businessRepID: parsedJson['businessRepID'] ?? '',
        businessTeam: parsedJson['businessTeam'] ?? [],
        businessName: parsedJson['businessName'] ?? '',
        businessAbout: parsedJson['businessAbout'] ?? '',
        businessAddress: parsedJson['businessAddress'] ?? '',
        businessEmail: parsedJson['businessEmail'] ?? '',
        businessPhoneNumber: parsedJson['businessPhoneNumber'] ?? [],
        servicesMap: parsedJson['servicesMap'] ??
            {
              'services': {
                'doctor': {
                  'provides': false,
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
            },
        active: parsedJson['active'] ?? true,
        lastOnlineTimestamp:
            parsedJson['lastOnlineTimestamp'] ?? Timestamp.now(),
        businessID: parsedJson['id'] ?? parsedJson['businessID'] ?? '',
        businessLogoURL: parsedJson['businessLogoURL'] ?? "");
  }
  Map<String, dynamic> toJson() {
    return {
      'isHealthBusiness': this.isHealthBusiness,
      'businessRepID': this.businessRepID,
      'businessTeam':
          this.businessTeam.map((employee) => employee.toJson()).toList(),
      'businessName': this.businessName,
      'businessAbout': this.businessAbout,
      'businessAddress':
          this.businessAddress.map((address) => address.toJson()).toList(),
      'businessEmail': this.businessEmail,
      'businessPhoneNumber': this.businessPhoneNumber,
      'servicesMap': this.servicesMap.toJson(),
      'active': this.active,
      'lastOnlineTimestamp': this.lastOnlineTimestamp,
      'businessID': this.businessID,
      'businessLogoURL': this.businessLogoURL,
    };
  }
}

class ServicesMap {
  Map<String, Map<String, dynamic>> services = {
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
  };

  ServicesMap({this.services});

  factory ServicesMap.fromJson(Map<String, dynamic> parsedJson) {
    return new ServicesMap(services: {
      'doctor': parsedJson['services']['doctor'] ??
          {
            'provides': false,
            'isHealthService': true,
            'rating': 5.0,
            'completedServices': 0
          },
      'pharmacist': parsedJson['services']['pharmacist'] ??
          {
            'provides': false,
            'isHealthService': true,
            'rating': 5.0,
            'completedServices': 0
          },
      'laboratory': parsedJson['services']['laboratory'] ??
          {
            'provides': false,
            'isHealthService': true,
            'rating': 5.0,
            'completedServices': 0
          },
      'radiologist': parsedJson['services']['radiologist'] ??
          {
            'provides': false,
            'isHealthService': true,
            'rating': 5.0,
            'completedServices': 0
          },
      // 'retail': parsedJson['services']['retail'] ?? {'provides' : false, 'isHealthService' : false, 'rating': 5.0,'completedServices': 0},
      // 'ambulance': parsedJson['services']['ambulance'] ?? {'provides' : false, 'isHealthService' : true, 'rating': 5.0,'completedServices': 0},
      // 'hospital': parsedJson['services']['hospital'] ?? {'provides' : false, 'isHealthService' : true, 'rating': 5.0,'completedServices': 0},
      // 'clinic': parsedJson['services']['clinic'] ?? {'provides' : false, 'isHealthService' : true, 'rating': 5.0,'completedServices': 0},
      // 'fitness': parsedJson['services']['fitness'] ?? {'provides' : false, 'isHealthService' : true, 'rating': 5.0,'completedServices': 0},
      // 'hospitality': parsedJson['services']['hospitality'] ?? {'provides' : false, 'isHealthService' : false, 'rating': 5.0,'completedServices': 0},
      // 'insurance': parsedJson['services']['insurance'] ?? {'provides' : false, 'isHealthService' : false, 'rating': 5.0,'completedServices': 0},
      // 'travel': parsedJson['services']['travel'] ?? {'provides' : false, 'isHealthService' : false, 'rating': 5.0,'completedServices': 0},
      // 'wellness': parsedJson['services']['wellness'] ?? {'provides' : false, 'isHealthService' : false, 'rating': 5.0,'completedServices': 0},
      // 'education': parsedJson['services']['education'] ?? {'provides' : false, 'isHealthService' : false, 'rating': 5.0,'completedServices': 0},
    });
  }
  Map<String, dynamic> toJson() {
    return {
      'services': {
        'doctor': this.services['doctor'],
        'pharmacist': this.services['pharmacist'],
        'laboratory': this.services['laboratory'],
        'radiologist': this.services['radiologist'],
        // 'retail': this.services['retail'],
        // 'ambulance': this.services['ambulance'],
        // 'hospital': this.services['hospital'],
        // 'clinic': this.services['clinic'],
        // 'fitness': this.services['fitness'],
        // 'hospitality': this.services['hospitality'],
        // 'insurance': this.services['insurance'],
        // 'travel': this.services['travel'],
        // 'wellness': this.services['wellness'],
        // 'education': this.services['education'],
      }
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
