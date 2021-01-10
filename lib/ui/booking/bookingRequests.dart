import 'package:flutter/material.dart';
import 'package:instachatty/constants.dart';
import 'package:instachatty/services/Helper.dart';
import 'package:instachatty/model/BookingRequest.dart';

class BookingRequestCard extends StatefulWidget {
  BookingRequestCard({
    @required this.bookingRequest,
  });
  final BookingRequest bookingRequest;

  @override
  _BookingRequestCardState createState() => _BookingRequestCardState(
        bookingRequest,
      );
}

class _BookingRequestCardState extends State<BookingRequestCard> {
  _BookingRequestCardState(
    this.bookingRequest,
  );
  final BookingRequest bookingRequest;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Material(
        color: Color(COLOR_PRIMARY),
        child: SizedBox(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Text(
                      'Booking request from',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      '${bookingRequest.customerName}',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Row(
                      children: [
                        displayCircleImage(
                            bookingRequest.customerUrl, 40.0, false),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
