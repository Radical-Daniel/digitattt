import 'package:flutter/material.dart';
import 'package:instachatty/model/InvoiceModel.dart';
import 'package:instachatty/constants.dart';
import 'package:instachatty/services/Helper.dart';

class InvoiceCard extends StatefulWidget {
  InvoiceCard({@required this.details, this.onPressed});
  final InvoiceModel details;
  final Function onPressed;

  @override
  _InvoiceCardState createState() => _InvoiceCardState(details, onPressed);
}

class _InvoiceCardState extends State<InvoiceCard> {
  _InvoiceCardState(this.details, this.onPressed);
  final InvoiceModel details;
  final Function onPressed;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Material(
        color: Color(COLOR_PRIMARY),
        child: SizedBox(
          child: FlatButton(
            onPressed: onPressed,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text(
                      'Invoice for ${details.customerName}',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'From ${details.sellerName}',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Card(
                  color: Colors.green,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 6.0, vertical: 1.0),
                    child: Text(
                      '\$${details.charge}',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Column(
                  children: [
                    displayCircleImage(details.sellerURL, 40.0, false),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
