import 'package:instachatty/model/User.dart';
import 'package:instachatty/model/Business.dart';

class BookingRequest {
  String customerID = '';
  String customerName = '';
  String customerUrl = '';
  String sellerID = '';
  String sellerName = '';
  String details = "";
  String requestID = "";
  String serviceName = "";
  bool handled = false;

  BookingRequest(
      {this.customerID,
      this.customerName,
      this.customerUrl,
      this.sellerID,
      this.sellerName,
      this.handled,
      this.details,
      this.serviceName,
      this.requestID});

  factory BookingRequest.fromJson(Map<String, dynamic> parsedJson) {
    return new BookingRequest(
      customerID: parsedJson['customerID'] ?? '',
      customerName: parsedJson['customerName'] ?? '',
      customerUrl: parsedJson['customerUrl'] ?? '',
      sellerID: parsedJson['sellerID'] ?? "",
      sellerName: parsedJson['sellerName'] ?? '',
      handled: parsedJson['handled'] ?? false,
      details: parsedJson['details'] ?? "",
      serviceName: parsedJson['serviceName'] ?? "",
      requestID: parsedJson['requestID'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'customerID': this.customerID,
      'customerName': this.customerName,
      'customerUrl': this.customerUrl,
      'sellerID': this.sellerID,
      'sellerName': this.sellerName,
      'handled': this.handled,
      'details': this.details,
      'serviceName': this.serviceName,
      'requestID': this.requestID,
    };
  }
}
