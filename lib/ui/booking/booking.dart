import 'package:flutter/material.dart';
import 'package:instachatty/model/InvoiceModel.dart';
import 'package:instachatty/constants.dart';
import 'package:instachatty/services/Helper.dart';
import 'package:intl/intl.dart';

class Booking extends StatefulWidget {
  Booking({@required this.invoice, this.appointmentTime, this.onPressed});
  final InvoiceModel invoice;
  final DateTime appointmentTime;
  final Function onPressed;

  @override
  _BookingState createState() =>
      _BookingState(invoice, appointmentTime, onPressed);
}

class _BookingState extends State<Booking> {
  _BookingState(this.invoice, this.appointmentTime, this.onPressed);
  final InvoiceModel invoice;
  final Function onPressed;

  final DateTime appointmentTime;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Material(
        color: Color(COLOR_PRIMARY),
        child: SizedBox(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: FlatButton(
              onPressed: onPressed,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Text(
                        'Appointment',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'with',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        '${invoice.sellerName}',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0.0, vertical: 3.0),
                      child: Column(
                        children: [
                          Text(
                            '${appointmentTime.hour}:${appointmentTime.minute}',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                  ' ${DateFormat('EEEE').format(appointmentTime)} '),
                              Text('${appointmentTime.day}th '),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      displayCircleImage(invoice.customerUrl, 40.0, false),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
