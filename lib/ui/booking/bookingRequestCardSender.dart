import 'package:flutter/material.dart';
import 'package:instachatty/constants.dart';
import 'package:instachatty/services/Helper.dart';
import 'package:instachatty/model/BookingRequest.dart';

class BookingRequestCardSender extends StatefulWidget {
  BookingRequestCardSender({@required this.bookingRequest, this.onPressed});
  final BookingRequest bookingRequest;
  final Function onPressed;
  @override
  _BookingRequestCardSenderState createState() =>
      _BookingRequestCardSenderState(bookingRequest, onPressed);
}

class _BookingRequestCardSenderState extends State<BookingRequestCardSender> {
  _BookingRequestCardSenderState(this.bookingRequest, this.onPressed);
  final BookingRequest bookingRequest;
  final Function onPressed;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Material(
        color: Color(COLOR_PRIMARY),
        child: FlatButton(
          onPressed: onPressed,
          child: SizedBox(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                leading: bookingRequest.sellerURL.length > 1
                    ? Column(
                        children: [
                          Row(
                            children: [
                              displayCircleImage(
                                  bookingRequest.sellerURL, 40.0, false),
                            ],
                          ),
                        ],
                      )
                    : null,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        Text(
                          'Booking request to',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          '${bookingRequest.sellerName}',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        Text(bookingRequest.details),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
