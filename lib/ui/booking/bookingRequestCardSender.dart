import 'package:flutter/material.dart';
import 'package:instachatty/constants.dart';
import 'package:instachatty/services/Helper.dart';
import 'package:instachatty/model/BookingRequest.dart';
import 'package:instachatty/model/Deal.dart';

class BookingRequestCardSender extends StatefulWidget {
  BookingRequestCardSender({@required this.deal, this.onPressed});
  final Deal deal;
  final Function onPressed;
  @override
  _BookingRequestCardSenderState createState() =>
      _BookingRequestCardSenderState(deal, onPressed);
}

class _BookingRequestCardSenderState extends State<BookingRequestCardSender> {
  _BookingRequestCardSenderState(this.deal, this.onPressed);
  final Deal deal;
  final Function onPressed;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Material(
        color: Color(COLOR_PRIMARY),
        child: FlatButton(
          onPressed: onPressed,
          child: SizedBox(
            child: ListTile(
              leading: deal.sellerURL.length > 1
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        displayCircleImage(
                            deal.sellerURL, 40.0, false, deal.sellerName),
                      ],
                    )
                  : Container(),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Booking request to',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        '${deal.sellerName}',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      Text(deal.customerAdditionalDetails),
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
