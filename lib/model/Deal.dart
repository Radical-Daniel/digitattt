import 'package:flutter/material.dart';

class Deal {
  String customerID = '';
  String customerName = '';
  String customerURL = '';
  String sellerID = '';
  String sellerName = '';
  String sellerURL = '';
  bool customerInitiated = true;
  String fulfillmentProviderID = '';
  String fulfillmentProviderName = '';
  String fulfillmentProviderURL = '';
  String serviceName = "";
  String customerAdditionalDetails = "";
  String paymentType = "";
  String pictureDetailsURL = "";
  String requestID = "";
  double amount = 0.00;
  String partnerAdditionalDetails = '';
  bool bookingConfirmed = false;
  bool paid = false;
  bool enquiryHandled = false;
  String displayAppointmentTime = '';
  String appointmentDateTime = '';
  String appointmentTime = '';
  String duration = "";
  String appointmentEndTime = "";
  bool appointmentActive = false;
  String customerDeliveryDetails = '';
  bool dealClosed = false;

  Deal(
      {@required this.customerID,
      @required this.sellerID,
      this.customerName,
      this.customerURL,
      this.sellerURL,
      this.sellerName,
      this.serviceName,
      this.customerInitiated,
      this.fulfillmentProviderID,
      this.fulfillmentProviderName,
      this.fulfillmentProviderURL,
      this.pictureDetailsURL,
      this.requestID,
      this.customerAdditionalDetails,
      this.customerDeliveryDetails,
      this.partnerAdditionalDetails,
      this.displayAppointmentTime,
      this.appointmentDateTime,
      this.appointmentTime,
      this.duration,
      this.appointmentEndTime,
      this.paymentType,
      this.paid,
      this.amount,
      this.appointmentActive,
      this.bookingConfirmed,
      this.enquiryHandled,
      this.dealClosed});

  factory Deal.fromJson(Map<String, dynamic> parsedJson) {
    return new Deal(
      customerID: parsedJson['customerID'] ?? "",
      customerName: parsedJson['customerName'] ?? '',
      customerURL: parsedJson['customerURL'] ?? '',
      sellerID: parsedJson['sellerID'] ?? "",
      sellerName: parsedJson['sellerName'] ?? '',
      sellerURL: parsedJson['sellerURL'] ?? "",
      customerInitiated: parsedJson['customerInitiated'] ?? true,
      fulfillmentProviderID: parsedJson['fulfillmentProviderID'] ?? '',
      fulfillmentProviderName: parsedJson['fulfillmentProviderName'] ?? '',
      fulfillmentProviderURL: parsedJson['fulfillmentProviderURL'] ?? '',
      enquiryHandled: parsedJson['enquiryHandled'] ?? false,
      customerAdditionalDetails: parsedJson['customerAdditionalDetails'] ?? "",
      pictureDetailsURL: parsedJson['pictureDetailsURL'] ?? '',
      serviceName: parsedJson['serviceName'] ?? "",
      requestID: parsedJson['requestID'] ?? "",
      paymentType: parsedJson['paymentType'] ?? "",
      duration: parsedJson['duration'] ?? "",
      appointmentEndTime: parsedJson['appointmentEndTime'] ?? "",
      amount: parsedJson['amount'] ?? "",
      partnerAdditionalDetails: parsedJson['partnerAdditionalDetails'] ?? "",
      bookingConfirmed: parsedJson['bookingCompleted'],
      paid: parsedJson['paid'] ?? false,
      appointmentActive: parsedJson['appointmentActive'] ?? false,
      displayAppointmentTime: parsedJson['displayAppointmentTime'] ?? '',
      appointmentDateTime: parsedJson['appointmentDate'] ?? '',
      appointmentTime: parsedJson['appointmentTime'] ?? '',
      customerDeliveryDetails: parsedJson['customerDeliveryDetails'] ?? "",
      dealClosed: parsedJson['dealClosed'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'customerID': this.customerID,
      'sellerID': this.sellerID,
      'customerName': this.customerName,
      'customerURL': this.customerURL,
      'sellerURL': this.sellerURL,
      'sellerName': this.sellerName,
      'customerInitiated': this.customerInitiated,
      'fulfillmentProviderID': this.fulfillmentProviderID,
      'fulfillmentProviderName': this.fulfillmentProviderName,
      'fulfillmentProviderURL': this.fulfillmentProviderURL,
      'serviceName': this.serviceName,
      'pictureDetailsURL': this.pictureDetailsURL,
      'requestID': this.requestID,
      'customerAdditionalDetails': this.customerAdditionalDetails,
      'customerDeliveryDetails': this.customerDeliveryDetails,
      'partnerAdditionalDetails': this.partnerAdditionalDetails,
      'displayAppointmentTime': this.displayAppointmentTime,
      'duration': this.duration,
      'appointmentEndTime': this.appointmentEndTime,
      'appointmentDate': this.appointmentDateTime,
      'appointmentTime': this.appointmentTime,
      'paymentType': this.paymentType,
      'paid': this.paid,
      'appointmentActive': this.appointmentActive,
      'amount': this.amount,
      'bookingCompleted': this.bookingConfirmed,
      'enquiryHandled': this.enquiryHandled,
      'dealClosed': this.dealClosed,
    };
  }
}

class FulfillmentMap {
  String fulfillmentProviderID = '';
  String fulfillmentProviderName = '';
  String fulfillmentProviderURL = '';
  bool handled = false;
  ServiceName serviceName = ServiceName(
    doctor: false,
    pharmacist: false,
    laboratory: false,
    radiologist: false,
    delivery: false,
  );

  FulfillmentMap(
      {this.fulfillmentProviderID,
      this.fulfillmentProviderName,
      this.fulfillmentProviderURL,
      this.serviceName,
      this.handled});

  factory FulfillmentMap.fromJson(Map<String, dynamic> parsedJson) {
    return new FulfillmentMap(
        fulfillmentProviderID: parsedJson['fulfillmentProviderID'] ?? "",
        fulfillmentProviderName: parsedJson['fulfillmentProviderID'] ?? "",
        fulfillmentProviderURL: parsedJson['fulfillmentProviderName'] ?? "",
        handled: parsedJson['fulfillmentProviderURL'] ?? false,
        serviceName: ServiceName.toJson(parsedJson['handled']) ??
            {
              'doctor': false,
              'pharmacist': false,
              'laboratory': false,
              'radiologist': false,
              'delivery': false,
            });
  }

  Map<String, dynamic> toJson() {
    return {
      'fulfillmentProviderID': this.fulfillmentProviderID,
      'fulfillmentProviderName': this.fulfillmentProviderName,
      'fulfillmentProviderURL': this.fulfillmentProviderURL,
      'handled': this.handled,
      'serviceName': this.serviceName.toJson(),
    };
  }
}

class ServiceName {
  bool doctor = false;
  bool pharmacist = false;
  bool laboratory = false;
  bool radiologist = false;
  bool delivery = false;

  ServiceName(
      {this.doctor,
      this.laboratory,
      this.pharmacist,
      this.radiologist,
      this.delivery});

  factory ServiceName.toJson(Map<String, dynamic> parsedJson) {
    return new ServiceName(
      doctor: parsedJson['doctor'] ?? false,
      pharmacist: parsedJson['pharmacist'] ?? false,
      laboratory: parsedJson['laboratory'] ?? false,
      radiologist: parsedJson['radiologist'] ?? false,
      delivery: parsedJson['delivery'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'doctor': this.doctor,
      'pharmacist': this.pharmacist,
      'laboratory': this.laboratory,
      'radiologist': this.radiologist,
      'delivery': this.delivery,
    };
  }
}
