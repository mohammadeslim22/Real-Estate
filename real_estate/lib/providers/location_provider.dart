import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';

class LocationProvider with ChangeNotifier {
  double addProplat = 0.0;
  double addProplong = 0.0;
  String addPropAddress;
  List<Address> addeesss;

  void setAddress(String address) async {
    // Coordinates coordinates = Coordinates(addProplat, addProplong);
    // addeesss = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    // addPropAddress = addeesss[0].addressLine;
    // locationController.text = address;
    addPropAddress = address;
    print("locationController.text $addPropAddress");
    //     .then((List<Address> adds) {
    //   addPropAddress = adds[0].addressLine;
    //   locationController.text = addPropAddress;
    // });
    notifyListeners();
  }

  void setLocation(double lat, double long) {
    addProplat = lat;
    addProplong = long;
    notifyListeners();
  }
}
