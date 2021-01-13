import 'package:instachatty/model/User.dart';
import 'package:instachatty/model/Business.dart';

class BookingRequest {
  String customerID = '';
  String customerName = '';
  String customerURL = '';
  String sellerID = '';
  String sellerName = '';
  String sellerURL = '';
  String details = "";
  String pictureDetailsURL = "";
  String requestID = "";
  String serviceName = "";
  bool handled = false;

  BookingRequest(
      {this.customerID,
      this.customerName,
      this.customerURL,
      this.sellerID,
      this.sellerName,
      this.sellerURL,
      this.handled,
      this.details,
      this.pictureDetailsURL,
      this.serviceName,
      this.requestID});

  factory BookingRequest.fromJson(Map<String, dynamic> parsedJson) {
    return new BookingRequest(
      customerID: parsedJson['customerID'] ?? '',
      customerName: parsedJson['customerName'] ?? '',
      customerURL: parsedJson['customerURL'] ?? '',
      sellerID: parsedJson['sellerID'] ?? "",
      sellerName: parsedJson['sellerName'] ?? '',
      sellerURL: parsedJson['sellerURL'] ?? "",
      handled: parsedJson['handled'] ?? false,
      details: parsedJson['details'] ?? "",
      pictureDetailsURL: parsedJson['pictureDetailsURL'] ?? '',
      serviceName: parsedJson['serviceName'] ?? "",
      requestID: parsedJson['requestID'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'customerID': this.customerID,
      'customerName': this.customerName,
      'customerURL': this.customerURL,
      'sellerID': this.sellerID,
      'sellerName': this.sellerName,
      'sellerURL': this.sellerURL,
      'handled': this.handled,
      'details': this.details,
      'pictureDetailsURL': this.pictureDetailsURL,
      'serviceName': this.serviceName,
      'requestID': this.requestID,
    };
  }
}
