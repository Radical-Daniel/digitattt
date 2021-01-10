import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class ServiceModel with ChangeNotifier {
  bool isHealthService = false;
  Services serviceType = Services.None;
  double rating = 5.0;
  int completedServices = 0;

  ServiceModel({
    this.isHealthService,
    this.serviceType,
    this.rating,
    this.completedServices,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> parsedJson) {
    return new ServiceModel(
      isHealthService: parsedJson['isHealthService'] ?? false,
      serviceType: Services.values[parsedJson['serviceType']] ?? Services.None,
      rating: parsedJson['rating'] ?? 0.0,
      completedServices: parsedJson['completedServices'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isHealthService': this.isHealthService,
      'serviceType': Services.values.indexOf(this.serviceType),
      'rating': this.rating,
      'completedServices': this.completedServices,
    };
  }
}

enum Services {
  Doctor,
  Pharmacist,
  Laboratory,
  Ambulance,
  Radiologist,
  Hospital,
  Clinic,
  MedicalAid,
  None,
}

// class ServicesMap {
//   Map<String, bool> services = {
//     'doctor': false,
//     'pharmacist': false,
//     'laboratory': false,
//     'retail': false,
//     'ambulance': false,
//     'radiologist': false,
//     'hospital': false,
//     'clinic': false,
//     'fitness': false,
//     'hospitality': false,
//     'insurance': false,
//     'travel': false,
//     'wellness': false,
//     'education': false
//   };
//
//   ServicesMap({this.services});
//
//   factory ServicesMap.fromJson(Map<String, dynamic> parsedJson) {
//     return new ServicesMap(services: {
//       'doctor': parsedJson['services']['doctor'] ?? false,
//       'pharmacist': parsedJson['services']['pharmacist'] ?? false,
//       'laboratory': parsedJson['services']['laboratory'] ?? false,
//       'retail': parsedJson['services']['retail'] ?? false,
//       'ambulance': parsedJson['services']['ambulance'] ?? false,
//       'radiologist': parsedJson['services']['radiologist'] ?? false,
//       'hospital': parsedJson['services']['hospital'] ?? false,
//       'clinic': parsedJson['services']['clinic'] ?? false,
//       'fitness': parsedJson['services']['fitness'] ?? false,
//       'hospitality': parsedJson['services']['hospitality'] ?? false,
//       'insurance': parsedJson['services']['insurance'] ?? false,
//       'travel': parsedJson['services']['travel'] ?? false,
//       'wellness': parsedJson['services']['wellness'] ?? false,
//       'education': parsedJson['services']['education'] ?? false,
//     });
//   }
//   Map<String, dynamic> toJson() {
//     return {
//       'services': {
//         'doctor': this.services['doctor'],
//         'pharmacist': this.services['pharmacist'],
//         'laboratory': this.services['laboratory'],
//         'retail': this.services['retail'],
//         'ambulance': this.services['ambulance'],
//         'radiologist': this.services['radiologist'],
//         'hospital': this.services['hospital'],
//         'clinic': this.services['clinic'],
//         'fitness': this.services['fitness'],
//         'hospitality': this.services['hospitality'],
//         'insurance': this.services['insurance'],
//         'travel': this.services['travel'],
//         'wellness': this.services['wellness'],
//         'education': this.services['education'],
//       }
//     };
//   }
// }
