import 'package:instachatty/model/User.dart';
import 'package:instachatty/model/Business.dart';

class BookingRequest {
  String customerId = User().userID;
  String customerName = User().fullName();
  String customerUrl = User().profilePictureURL;
  String sellerId = Business().businessID;
  String sellerName = Business().businessName;
  String details = "";
  String requestID = "";
  bool handled = false;

  BookingRequest(
      {this.customerId,
      this.customerName,
      this.customerUrl,
      this.sellerId,
      this.sellerName,
      this.handled,
      this.details,
      this.requestID});

  factory BookingRequest.fromJson(Map<String, dynamic> parsedJson) {
    return new BookingRequest(
      customerId: User.fromJson(parsedJson).userID ?? User().userID,
      customerName: User.fromJson(parsedJson).fullName() ?? User().fullName(),
      customerUrl: User.fromJson(parsedJson).profilePictureURL ?? '',
      sellerId:
          Business.fromJson(parsedJson).businessID ?? Business().businessID,
      sellerName: Business.fromJson(parsedJson).businessName ?? '',
      handled: parsedJson['handled'] ?? false,
      details: parsedJson['details'] ?? "",
      requestID: parsedJson['requestID'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'customerId': this.customerId,
      'customerName': this.customerName,
      'customerUrl': this.customerUrl,
      'seller': this.sellerId,
      'sellerName': this.sellerName,
      'handled': this.handled,
      'details': this.details,
      'requestID': this.requestID,
    };
  }
}
