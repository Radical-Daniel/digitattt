import 'package:geocoder/geocoder.dart';
import 'package:geodesy/geodesy.dart';

class AddressModel {
  String address = '';
  double latitude = 0.0;
  double longitude = 0.0;

  AddressModel({this.address, this.latitude, this.longitude});

  factory AddressModel.fromJson(Map<String, dynamic> parsedJson) {
    return new AddressModel(
        address: parsedJson['address'] ?? '',
        latitude: parsedJson['latitude'] ?? 0.0,
        longitude: parsedJson['longitude'] ?? 0.0);
  }

  Map<String, dynamic> toJson() {
    return {
      'address': this.address ?? '',
      'latitude': this.latitude ?? 0.0,
      'longitude': this.longitude ?? 0.0,
    };
  }

  Future<AddressModel> geoAddress() async {
    dynamic geoLocation = await Geocoder.local.findAddressesFromQuery(address);

    latitude = geoLocation.first.coordinates.latitude;
    longitude = geoLocation.first.coordinates.longitude;
    return AddressModel(
      address: address,
      longitude: longitude,
      latitude: latitude,
    );
  }

  List<LatLng> getNearbyPoints(double distance, List<LatLng> locations) {
    final point = LatLng(this.latitude, this.latitude);
    List<LatLng> nearbyPoints =
        Geodesy().pointsInRange(point, locations, distance);
    return nearbyPoints;
  }

  changeAddress(String newAddress) async {
    this.address = newAddress;
    await geoAddress();
  }
}
