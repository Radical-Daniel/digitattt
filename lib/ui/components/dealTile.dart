import 'package:flutter/material.dart';
import 'package:instachatty/model/Deal.dart';
import 'package:instachatty/services/Helper.dart';

class DealTile extends StatelessWidget {
  final Deal deal;

  const DealTile({
    Key key,
    @required this.deal,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Payment submitted to',
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
        ],
      ),
      trailing: Card(
        color: Colors.green,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 1.0),
          child: Text(
            '\$${deal.amount}',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
      leading: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          displayCircleImage(deal.sellerURL, 40.0, false, deal.sellerName),
        ],
      ),
    );
  }
}
