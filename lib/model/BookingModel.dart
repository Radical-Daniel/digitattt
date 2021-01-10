import 'package:instachatty/model/InvoiceModel.dart';

class BookingModel {
  InvoiceModel invoice;
  DateTime appointmentTime;

  BookingModel({this.invoice, this.appointmentTime});

  factory BookingModel.fromJson(Map<String, dynamic> parsedJson) {
    return new BookingModel(
      invoice: InvoiceModel.fromJson(parsedJson) ?? InvoiceModel(),
      appointmentTime: parsedJson['appointmentTime'] ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'invoice': this.invoice,
      'appointmentTime': this.appointmentTime,
    };
  }
}
