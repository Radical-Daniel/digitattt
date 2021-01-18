import 'package:flutter/material.dart';
import 'package:instachatty/ui/realEstateTemplate/real_estate_model.dart';
import 'package:instachatty/constants.dart';
import 'package:instachatty/model/ContactModel.dart';
import 'package:instachatty/services/Helper.dart';

class RealEstateDetails extends StatelessWidget {
  final String bubble;
  final RealEstateModel item;
  final Future<List<ContactModel>> future;

  const RealEstateDetails({Key key, this.item, this.bubble, this.future})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * .44,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(item.img),
                  colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.2),
                    BlendMode.hardLight,
                  ),
                ),
              ),
            ),
            Positioned(
              width: MediaQuery.of(context).size.width,
              top: MediaQuery.of(context).size.height * .4 - 90,
              child: Padding(
                padding: const EdgeInsets.only(left: 30, right: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Icon(
                      Icons.rotate_90_degrees_ccw,
                      color: Colors.white,
                      size: 35,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        _buildIndicator(),
                        SizedBox(width: 5),
                        _buildIndicator(),
                        SizedBox(width: 5),
                        _buildIndicator(),
                      ],
                    )
                  ],
                ),
              ),
            ),
            Positioned(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * .6 + 50,
              top: MediaQuery.of(context).size.height * .4 - 50,
              child: Container(
                padding: const EdgeInsets.only(left: 30, right: 20, top: 30),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(80),
                  ),
                  color: Colors.white,
                ),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.bookmark_border,
                          size: 30,
                        )
                      ],
                    ),
                    SizedBox(height: 10),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: Text(
                        item.name,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: 100,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              _buildRow(),
                              _buildRow(),
                              _buildRow(),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    Divider(
                      color: Colors.grey,
                      height: 2,
                    ),
                    SizedBox(height: 15),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          // Text(
                          //   "Home Loan Calculator",
                          //   style: TextStyle(
                          //     fontWeight: FontWeight.bold,
                          //     fontSize: 20,
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            width: 10.0,
                          ),
                          Column(
                            children: [
                              displayCircleImage(
                                  'https://firebasestorage.googleapis.com/v0/b/digitat-80a24.appspot.com/o/images%2FnP9LsJtV0NZIhLpsgrPGjnw7N6l1.png?alt=media&token=7619b239-8682-4f84-bb55-b5b1c4d35300',
                                  70.0,
                                  false,
                                  "Michael Alec"),
                              Text("Michael Alec"),
                            ],
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          Column(
                            children: [
                              displayCircleImage(
                                  'https://firebasestorage.googleapis.com/v0/b/digitat-80a24.appspot.com/o/images%2FlKPkdgcrBCNr8azqb1c9WH56mQi1.png?alt=media&token=bfdbd43e-1964-4279-b80c-fc907c37fc9d',
                                  70.0,
                                  false,
                                  "Niel Walker"),
                              Text("Niel Walker"),
                            ],
                          ),
                          Column(
                            children: [
                              displayCircleImage(
                                  'https://firebasestorage.googleapis.com/v0/b/digitat-80a24.appspot.com/o/images%2FnP9LsJtV0NZIhLpsgrPGjnw7N6l1.png?alt=media&token=7619b239-8682-4f84-bb55-b5b1c4d35300',
                                  70.0,
                                  false,
                                  "James Ford"),
                              Text("James Ford"),
                            ],
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          Column(
                            children: [
                              displayCircleImage(
                                  'https://firebasestorage.googleapis.com/v0/b/digitat-80a24.appspot.com/o/images%2Fc8befd09-542f-472d-a6d4-fb063c64962b.png?alt=media&token=d0b7d3be-641c-4fcf-b47a-e3450f5e75c4',
                                  70.0,
                                  false,
                                  "Michael Alec"),
                              Text("Michael Alec"),
                            ],
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          Column(
                            children: [
                              displayCircleImage(
                                  'https://firebasestorage.googleapis.com/v0/b/digitat-80a24.appspot.com/o/images%2FlKPkdgcrBCNr8azqb1c9WH56mQi1.png?alt=media&token=bfdbd43e-1964-4279-b80c-fc907c37fc9d',
                                  70.0,
                                  false,
                                  "Niel Walker"),
                              Text("Niel Walker"),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Spacer(),
                    Row(
                      children: <Widget>[
                        _buildExpandedBtn('Ask a Question'),
                        SizedBox(width: 10),
                        _buildExpandedBtn('Express Interest'),
                      ],
                    ),
                    SizedBox(height: 15),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildExpandedBtn(String msg) {
    return Expanded(
      child: Container(
        alignment: Alignment.center,
        height: 50,
        decoration: BoxDecoration(
          color: Color(COLOR_PRIMARY),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        child: Text(
          msg,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ),
    );
  }

  Widget _buildRow() {
    return Row(
      children: <Widget>[
        Icon(
          Icons.shop,
          size: 12,
          color: Colors.grey,
        ),
        SizedBox(width: 2),
        Text('2')
      ],
    );
  }

  Widget _buildIndicator() {
    return Container(width: 20, height: 5, color: Colors.white);
  }
}
