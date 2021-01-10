import 'User.dart';

class ContactModel {
  ContactType type = ContactType.UNKNOWN;
  BusinessPartner businessPartner = BusinessPartner.NOTPARTNER;
  User user = User();

  ContactModel({this.type, this.user, this.businessPartner});
}

enum ContactType { FRIEND, PENDING, BLOCKED, UNKNOWN, ACCEPT }
enum BusinessPartner { REQUESTED, NOTPARTNER, PARTNER }
