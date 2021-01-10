import 'package:flutter/material.dart';
import 'package:instachatty/ui/realEstateTemplate/real_estate_data.dart';
import 'package:instachatty/ui/realEstateTemplate/real_estate_model.dart';
import 'package:instachatty/ui/realEstateTemplate/real_estate_home_details.dart';
import 'package:instachatty/constants.dart';
import 'package:instachatty/model/User.dart';
import 'package:instachatty/services/FirebaseHelper.dart';
import 'package:instachatty/model/ContactModel.dart';

class RealEstateHome extends StatefulWidget {
  final User user;
  final String bubble;
  RealEstateHome({@required this.user, this.bubble});

  @override
  _RealEstateHomeState createState() => _RealEstateHomeState(user, bubble);
}

class _RealEstateHomeState extends State<RealEstateHome> {
  final User user;
  final String bubble;
  _RealEstateHomeState(this.user, this.bubble);
  final fireStoreUtils = FireStoreUtils();
  Future<List<ContactModel>> _future;
  @override
  void initState() {
    super.initState();
    _future = fireStoreUtils.getContacts(user.userID, false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          _buildBackground(),
          _buildTopBar(),
          _buildBody(),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: ExactAssetImage('assets/images/map.png'),
          colorFilter: ColorFilter.mode(
            Colors.white.withOpacity(0.7),
            BlendMode.hardLight,
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Builder(
      builder: (BuildContext context) {
        return Positioned(
          top: 30,
          height: 70,
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(
                      "Howdy",
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(width: 5),
                    Text(
                      widget.user.firstName,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
                CircleAvatar(
                  foregroundColor: Theme.of(context).primaryColor,
                  backgroundColor: Colors.grey,
                  backgroundImage: NetworkImage(widget.user.profilePictureURL),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBody() {
    return Builder(
      builder: (BuildContext context) {
        return Positioned(
          top: 90,
          child: Container(
            padding: const EdgeInsets.all(16),
            height: MediaQuery.of(context).size.height - 100,
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Discover",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 35,
                  ),
                ),
                Text(
                  '#${widget.bubble}',
                  style: TextStyle(
                    fontSize: 35,
                  ),
                ),
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(COLOR_PRIMARY),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                        ),
                        child: TextField(
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            prefixIcon: Icon(
                              Icons.search,
                              color: Colors.white,
                            ),
                            hintText: 'Find your experience',
                            hintStyle: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 50,
                      alignment: Alignment.center,
                      child: Stack(
                        children: <Widget>[
                          Icon(
                            Icons.notifications_none,
                            size: 35,
                            color: Color(COLOR_PRIMARY),
                          ),
                          Positioned(
                            top: -1,
                            right: 2,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xfffd8c00),
                              ),
                              child: Text(
                                '2',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
                SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: realEstatesResult.length,
                      itemBuilder: (BuildContext c, int index) {
                        final RealEstateModel item = realEstatesResult[index];

                        return InkWell(
                          onTap: () {
                            Navigator.of(context).push(new MaterialPageRoute(
                              builder: (c) => RealEstateDetails(
                                item: item,
                                future: _future,
                              ),
                            ));
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(right: 20),
                            child: Stack(
                              children: <Widget>[
                                LayoutBuilder(
                                  builder: (BuildContext c,
                                      BoxConstraints constraints) {
                                    return Container(
                                      width: MediaQuery.of(context).size.width *
                                          .65,
                                      height: constraints.maxHeight - 20,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: NetworkImage(item.img),
                                          colorFilter: ColorFilter.mode(
                                            Colors.black.withOpacity(0.2),
                                            BlendMode.hardLight,
                                          ),
                                        ),
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(35),
                                          bottomLeft: Radius.circular(35),
                                          bottomRight: Radius.circular(35),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                Positioned(
                                  top: 15,
                                  left: 15,
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: 55,
                                    width: 55,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        width: 2,
                                        color: Colors.white,
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          item.priceOff,
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                        Text(
                                          'Off',
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                    height: 45,
                                    width: 45,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color(COLOR_PRIMARY),
                                    ),
                                    child: Icon(
                                      Icons.navigate_next,
                                      size: 40,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 35,
                                  left: 10,
                                  width:
                                      MediaQuery.of(context).size.width * .65,
                                  child: ListTile(
                                    title: Text(
                                      item.name,
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                      ),
                                    ),
                                    subtitle: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Icon(
                                          Icons.room,
                                          color: Colors.white,
                                          size: 18,
                                        ),
                                        Text(
                                          item.address,
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
