import 'package:instachatty/model/User.dart';
import 'package:instachatty/model/Business.dart';

class InvoiceModel {
  String customerID = '';
  String customerName = '';
  String customerURL = '';
  String sellerID = '';
  String sellerName = '';
  String sellerURL = '';
  String type = "";
  double charge = 0.00;
  String additionalDetails = '';
  bool completed = false;
  String invoiceID;
  bool status = false;

  InvoiceModel(
      {this.customerID,
      this.customerName,
      this.customerURL,
      this.sellerID,
      this.sellerName,
      this.sellerURL,
      this.type,
      this.charge,
      this.completed,
      this.additionalDetails,
      this.invoiceID,
      this.status});

  factory InvoiceModel.fromJson(Map<String, dynamic> parsedJson) {
    return new InvoiceModel(
        customerID: parsedJson['customerID'] ?? '',
        customerName: parsedJson['customerName'] ?? "",
        customerURL: parsedJson['customerURL'] ?? '',
        sellerID: parsedJson['sellerID'] ?? '',
        sellerName: parsedJson['sellerName'] ?? '',
        sellerURL: parsedJson['sellerURL'] ?? '',
        type: parsedJson['type'] ?? "Not mentioned",
        charge: parsedJson['charge'] ?? 0.00,
        additionalDetails: parsedJson['additionalDetails'] ?? "Invoice",
        completed: parsedJson['completed'] ?? false,
        invoiceID: parsedJson['paymentId'] ?? '',
        status: parsedJson['status'] ?? false);
  }

  Map<String, dynamic> toJson() {
    return {
      'customerID': this.customerID,
      'customerName': this.customerName,
      'customerURL': this.customerURL,
      'seller': this.sellerID,
      'sellerName': this.sellerName,
      'sellerURL': this.sellerURL,
      'type': this.type,
      'charge': this.charge,
      'additionalDetails': this.additionalDetails,
      'completed': this.completed,
      'paymentID': this.invoiceID,
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
