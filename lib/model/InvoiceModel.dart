import 'package:instachatty/model/User.dart';
import 'package:instachatty/model/Business.dart';

class InvoiceModel {
  String customerId = User().userID;
  String customerName = User().fullName();
  String customerUrl = User().profilePictureURL;
  String sellerId = Business().businessID;
  String sellerName = Business().businessName;
  String sellerUrl = Business().businessLogoURL;
  PaymentType type;
  double charge = 0.00;
  bool completed = false;
  String invoiceId;
  PaymentStatus status = PaymentStatus.unpaid;

  InvoiceModel(
      {this.customerId,
      this.customerName,
      this.customerUrl,
      this.sellerId,
      this.sellerName,
      this.sellerUrl,
      this.type,
      this.charge,
      this.completed,
      this.invoiceId,
      this.status});

  factory InvoiceModel.fromJson(Map<String, dynamic> parsedJson) {
    return new InvoiceModel(
        customerId: User.fromJson(parsedJson).userID ?? User().userID,
        customerName: User.fromJson(parsedJson).fullName() ?? User().fullName(),
        customerUrl: User.fromJson(parsedJson).profilePictureURL ?? '',
        sellerId:
            Business.fromJson(parsedJson).businessID ?? Business().businessID,
        sellerName: Business.fromJson(parsedJson).businessName ?? '',
        sellerUrl: Business.fromJson(parsedJson).businessLogoURL ?? '',
        type: parsedJson['type'] ?? PaymentType.Cash,
        charge: parsedJson['charge'] ?? 0.00,
        completed: parsedJson['completed'] ?? false,
        invoiceId: parsedJson['paymentId'] ?? '',
        status: parsedJson['status'] ?? PaymentStatus.unpaid);
  }

  Map<String, dynamic> toJson() {
    return {
      'customerId': this.customerId,
      'customerName': this.customerName,
      'customerUrl': this.customerUrl,
      'seller': this.sellerId,
      'sellerName': this.sellerName,
      'sellerUrl': this.sellerUrl,
      'type': this.type,
      'charge': this.charge,
      'completed': this.completed,
      'paymentId': this.invoiceId,
      'status': this.status,
    };
  }
}

enum PaymentType {
  Cash,
  MedicalAid,
  Electronic,
}
enum PaymentStatus {
  paid,
  unpaid,
  cancelled,
}
