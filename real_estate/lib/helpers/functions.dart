import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:real_estate/constants/colors.dart';
import 'package:real_estate/constants/config.dart';
import 'package:real_estate/constants/styles.dart';
import 'package:location/location.dart';
import 'package:geocoder/geocoder.dart';
import 'package:real_estate/helpers/data.dart';

final Location location = Location();

Future<List<String>> getLocation() async {
  bool serviceEnabled;
  PermissionStatus permissionGranted;
  LocationData locationData;
  final List<String> locaion = <String>[];
  serviceEnabled = await location.serviceEnabled();
  if (!serviceEnabled) {
    serviceEnabled = await location.requestService();

    if (!serviceEnabled) {
      return locaion;
    }
  }

  permissionGranted = await location.hasPermission();
  if (permissionGranted == PermissionStatus.denied) {
    permissionGranted = await location.requestPermission();
    if (permissionGranted != PermissionStatus.granted) {
      return locaion;
    }
  }

  locationData = await location.getLocation();
  locaion.add(locationData.latitude.toString());
  data.setData("lat", locationData.latitude.toString());
  locaion.add(locationData.longitude.toString());
  data.setData("long", locationData.longitude.toString());

  return locaion;
}

Future<bool> get updateLocation async {
  bool res;
  Address first;
  Coordinates coordinates;
  List<Address> addresses;
  config.locationController.text = "getting your location...";

  final List<String> loglat = await getLocation();
  if (loglat.isEmpty) {
    res = false;
  } else {
    config.lat = double.parse(loglat.elementAt(0));
    print("config lat : ${config.lat}");
    config.long = double.parse(loglat.elementAt(1));
    print("config long : ${config.long}");
    res = true;
  }

  try {
    coordinates = Coordinates(
        double.parse(loglat.elementAt(0)), double.parse(loglat.elementAt(1)));
    // addresses = await Geocoder.google("AIzaSyDeUxKyBfZ1rlInBG6f0G4RT0tzgUstoes")
    //     .findAddressesFromCoordinates(coordinates);
    addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    first = addresses.first;
    data.setData('address', first.toString());
  } catch (e) {
    data.setData('address', "Unkown Location");
  }

  return res;
}

Future<void> getLocationName() async {
  try {
    config.coordinates = Coordinates(config.lat, config.long);
    config.addresses =
        await Geocoder.local.findAddressesFromCoordinates(config.coordinates);
    config.first = config.addresses.first;
    config.first = config.addresses.first;
    config.locationController.text = (config.first == null)
        ? "loading"
        : config.first.addressLine ?? "loading";
  } catch (e) {
    config.locationController.text =
        "Unkown latitude: ${config.lat.round().toString()} , longitud: ${config.long.round().toString()}";
  }
}

SnackBar snackBar = SnackBar(
    content: const Text("Location Service was not alowed  !"),
    action: SnackBarAction(label: 'Ok !', onPressed: () {}));
SpinKitRing spinkit =
    SpinKitRing(color: colors.orange, size: 30.0, lineWidth: 3);

Future<bool> onWillPop(BuildContext context) async {
  return (await showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text("???? ?????? ??????????"),
          content: Text("???? ???????? ????????????"),
          actionsOverflowButtonSpacing: 50,
          actions: <Widget>[
            FlatButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text("??????????"),
            ),
            FlatButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text("??????????"),
            ),
          ],
        ),
      )) ??
      false;
}

void goToMap(BuildContext context) {
  try {
    Navigator.pushNamedAndRemoveUntil(context, "/Home", (_) => false,
        arguments: <String, dynamic>{
          "home_map_lat": config.lat,
          "home_map_long": config.long
        });
  } catch (err) {
    print("errerr  $err");
  }
}

void showFullText(BuildContext context, String text) {
  showGeneralDialog<dynamic>(
    barrierLabel: "Label",
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(0.73),
    transitionDuration: const Duration(milliseconds: 350),
    context: context,
    pageBuilder: (BuildContext context, Animation<double> anim1,
        Animation<double> anim2) {
      return Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          margin:
              const EdgeInsets.only(bottom: 160, left: 24, right: 24, top: 160),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(40)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Material(
            type: MaterialType.transparency,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              // mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Expanded(child: Text(text, style: styles.textInShowMore)),
                const SizedBox(height: 15),
                RaisedButton(
                    color: colors.orange,
                    child: Text("??????????", style: styles.underHeadwhite),
                    onPressed: () {
                      Navigator.pop(context);
                    })
              ],
            ),
          ),
        ),
      );
    },
    transitionBuilder: (BuildContext context, Animation<double> anim1,
        Animation<double> anim2, Widget child) {
      return SlideTransition(
        position:
            Tween<Offset>(begin: const Offset(0, 1), end: const Offset(0, 0))
                .animate(anim1),
        child: child,
      );
    },
  );
}

