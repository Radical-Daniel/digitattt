import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:instachatty/model/User.dart';
import 'package:instachatty/ui/signUp/data.dart';
import 'package:instachatty/model/HomeConversationModel.dart';
import 'package:instachatty/services/FirebaseHelper.dart';

class Typeahead extends StatefulWidget {
  final User user;
  Typeahead({@required this.user});

  @override
  _TypeaheadState createState() => _TypeaheadState(user);
}

class _TypeaheadState extends State<Typeahead> {
  final fireStoreUtils = FireStoreUtils();
  Future<List<User>> _friendsFuture;
  Stream<List<HomeConversationModel>> _conversationsStream;
  TextEditingController controller = new TextEditingController();
  final User user;
  _TypeaheadState(this.user);

  @override
  void initState() {
    super.initState();
    fireStoreUtils.getBlocks().listen((shouldRefresh) {
      if (shouldRefresh) {
        setState(() {});
      }
    });
    _friendsFuture = fireStoreUtils.getFriends();
    _conversationsStream = fireStoreUtils.getConversations(user.userID);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            title: TabBar(tabs: [
              Tab(text: 'Example 2: Form'),
              Tab(text: 'Example 2: Form'),
            ]),
          ),
          body: TabBarView(children: [
            FormExample(),
            FormExample(),
          ])),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            title: TabBar(tabs: [
              Tab(text: 'Example 2: Form'),
              Tab(text: 'Example 2: Form'),
            ]),
          ),
          body: TabBarView(children: [
            FormExample(),
            FormExample(),
          ])),
    );
  }
}

class NavigationExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(32.0),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 10.0,
          ),
          TypeAheadField(
            textFieldConfiguration: TextFieldConfiguration(
              autofocus: true,
              style: DefaultTextStyle.of(context)
                  .style
                  .copyWith(fontStyle: FontStyle.italic),
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'What are you looking for?'),
            ),
            suggestionsCallback: (pattern) async {
              return await BackendService.getSuggestions(pattern);
            },
            itemBuilder: (context, suggestion) {
              return ListTile(
                leading: Icon(Icons.shopping_cart),
                title: Text(suggestion['name']),
                subtitle: Text('\$${suggestion['price']}'),
              );
            },
            onSuggestionSelected: (suggestion) {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ProductPage(product: suggestion)));
            },
          ),
        ],
      ),
    );
  }
}

class FormExample extends StatefulWidget {
  @override
  _FormExampleState createState() => _FormExampleState();
}

class _FormExampleState extends State<FormExample> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _typeAheadController = TextEditingController();

  String _selectedCity;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: this._formKey,
      child: Padding(
        padding: EdgeInsets.all(32.0),
        child: Column(
          children: <Widget>[
            Text('Search for your fellow business associates'),
            TypeAheadFormField(
              textFieldConfiguration: TextFieldConfiguration(
                decoration: InputDecoration(labelText: 'Contacts'),
                controller: this._typeAheadController,
              ),
              suggestionsCallback: (pattern) {
                return CitiesService.getSuggestions(pattern);
              },
              itemBuilder: (context, suggestion) {
                return ListTile(
                  title: Text(suggestion),
                );
              },
              transitionBuilder: (context, suggestionsBox, controller) {
                return suggestionsBox;
              },
              onSuggestionSelected: (suggestion) {
                this._typeAheadController.text = suggestion;
              },
              validator: (value) =>
                  value.isEmpty ? 'Please select a city' : null,
              onSaved: (value) => this._selectedCity = value,
            ),
            SizedBox(
              height: 10.0,
            ),
            RaisedButton(
              child: Text('Submit'),
              onPressed: () {
                if (this._formKey.currentState.validate()) {
                  this._formKey.currentState.save();
                  Scaffold.of(context).showSnackBar(
                    SnackBar(
                      content:
                          Text('Your Favorite City is ${this._selectedCity}'),
                    ),
                  );
                }
              },
            )
          ],
        ),
      ),
    );
  }
}

class ScrollExample extends StatelessWidget {
  final List<String> items = List.generate(5, (index) => "Item $index");

  @override
  Widget build(BuildContext context) {
    return ListView(children: [
      Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("Suggestion box will resize when scrolling"),
        ),
      ),
      SizedBox(height: 200),
      TypeAheadField<String>(
        getImmediateSuggestions: true,
        textFieldConfiguration: TextFieldConfiguration(
          decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'What are you looking for?'),
        ),
        suggestionsCallback: (String pattern) async {
          return items
              .where((item) =>
                  item.toLowerCase().startsWith(pattern.toLowerCase()))
              .toList();
        },
        itemBuilder: (context, String suggestion) {
          return ListTile(
            title: Text(suggestion),
          );
        },
        onSuggestionSelected: (String suggestion) {
          print("Suggestion selected");
        },
      ),
      SizedBox(height: 500),
    ]);
  }
}

class ProductPage extends StatelessWidget {
  final Map<String, dynamic> product;

  ProductPage({this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(50.0),
        child: Column(
          children: [
            Text(
              this.product['name'],
              style: Theme.of(context).textTheme.headline5,
            ),
            Text(
              this.product['price'].toString() + ' USD',
              style: Theme.of(context).textTheme.subtitle1,
            )
          ],
        ),
      ),
    );
  }
}
