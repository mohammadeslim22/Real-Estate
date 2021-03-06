import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:real_estate/constants/colors.dart';
import 'package:real_estate/constants/config.dart';
import 'package:real_estate/data_base/DBhelper.dart';
import 'package:real_estate/helpers/functions.dart';
import 'package:real_estate/helpers/service_locator.dart';
import 'package:real_estate/providers/location_provider.dart';
import 'package:real_estate/providers/mainprovider.dart';
import 'package:location/location.dart';
import 'package:geocoder/geocoder.dart';
import 'package:provider/provider.dart';
import 'package:real_estate/constants/styles.dart';
import 'package:real_estate/providers/property_provider.dart';

class AutoLocate extends StatefulWidget {
  const AutoLocate({Key key, this.long, this.lat, this.choice})
      : super(key: key);
  final double long;
  final double lat;
  final double choice;
  @override
  _AutoLocateState createState() => _AutoLocateState();
}

class _AutoLocateState extends State<AutoLocate> {
  StreamSubscription<dynamic> getPositionSubscription;
  GoogleMapController mapController;
  double lat;
  double long;
  bool serviceEnabled;
  PermissionStatus permissionGranted;
  LocationData locationData;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  DBHelper databaseHelper = DBHelper();

  final GlobalKey _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> _onMapCreated(GoogleMapController controller) async {
    mapController = controller;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
    } else {
      permissionGranted = await location.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
      } else {
        _animateToUser();
      }
    }
  }

  Coordinates coordinates;
  List<Address> addresses;
  Address address;
  @override
  void initState() {
    super.initState();
    lat = widget.lat;
    long = widget.long;
  }

  @override
  void dispose() {
    super.dispose();
    getPositionSubscription?.cancel();
  }

  Future<void> getLocationName(double long, double lat) async {
    try {
      coordinates = Coordinates(lat, long);
      addresses =
          await Geocoder.local.findAddressesFromCoordinates(coordinates);

      setState(() => address = addresses.first);
      print('fetched ${address.addressLine}');
    } catch (e) {
      address = null;
    }
  }

  Future<bool> _willPopCallback() async {
    Provider.of<MainProvider>(context, listen: false)
        .togelocationloading(false);
    Navigator.pop(context);
    return true;
  }

  Future<void> tryToAnimate() async {
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
    } else {
      _animateToUser();
      permissionGranted = await location.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
      } else {
        _animateToUser();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _willPopCallback,
        child: Stack(
          children: <Widget>[
            Scaffold(
              appBar: AppBar(
                  title: Text("?????? ??????????", style: styles.appBars),
                  centerTitle: true),
              key: _scaffoldKey,
              resizeToAvoidBottomInset: false,
              body: Stack(
                children: <Widget>[
                  GoogleMap(
                    myLocationEnabled: true,
                    // circles: <Circle>{
                    //   Circle(
                    //       circleId: CircleId("id"),
                    //       center: LatLng(lat, long),
                    //       fillColor: Colors.blue.withOpacity(.3),
                    //       radius: 40000,
                    //       strokeColor: Colors.transparent,
                    //       zIndex: 20,
                    //       strokeWidth: 2)
                    // },
                    myLocationButtonEnabled: false,
                    indoorViewEnabled: true,
                    zoomControlsEnabled: false,
                    onMapCreated: _onMapCreated,
                    padding: const EdgeInsets.only(bottom: 60),
                    mapType: MapType.normal,
                    markers: Set<Marker>.of(markers.values),
                    initialCameraPosition:
                        CameraPosition(target: LatLng(lat, long), zoom: 5),
                    onCameraMove: (CameraPosition pos) {
                      setState(() {
                        lat = pos.target.latitude;
                        long = pos.target.longitude;
                      });
                    },
                    onCameraIdle: () {
                      setState(() {
                        getLocationName(long, lat);
                      });
                    },
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      height: 170,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: <Color>[
                            Color.fromARGB(1023, 249, 249, 249),
                            Color.fromARGB(0, 255, 255, 255)
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Card(
                              elevation: 8,
                              margin: const EdgeInsets.all(0),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0)),
                              child: ListTile(
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      address == null
                                          ? 'Loading'
                                          : address.addressLine ?? '',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 11),
                                    ),
                                    Text(
                                      address == null
                                          ? 'Loading'
                                          : address.adminArea ?? 'Unknown',
                                      style: const TextStyle(fontSize: 9),
                                    ),
                                  ],
                                ),
                                leading: const IconButton(
                                    onPressed: null, icon: Icon(Icons.search)),
                                trailing: IconButton(
                                  onPressed: () {
                                    // getIt<LocationProvider>().saveLocation(
                                    //     address.addressLine.toString(),
                                    //     lat,
                                    //     long);
                                  },
                                  icon: const Icon(Icons.bookmark),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Align(
                  //   alignment: Alignment.center,
                  //   child: Container(
                  //     child: Icon(
                  //       FontAwesomeIcons.mapMarkerAlt,
                  //       color: colors.blue,
                  //       size: 32,
                  //     ),
                  //   ),
                  // ),

                  accesptDeclineButtons(),
                ],
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                child: Icon(FontAwesomeIcons.mapMarkerAlt,
                    color: colors.blue, size: 32),
              ),
            ),
          ],
        ));
  }

  void _addMarker(Marker marker) {
    final MarkerId markerId = MarkerId('current_location');

    setState(() {
      markers[markerId] = marker;
    });
  }

  Future<void> _animateToUser() async {
    try {
      if (mounted) {}
      final Uint8List markerIcon =
          await getBytesFromAsset('assets/images/logo.jpg', 100);
      await location.getLocation().then((LocationData value) {
        mapController
            .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: LatLng(value.latitude, value.longitude),
          zoom: 13,
        )));
        final Marker marker = Marker(
          markerId: MarkerId('current_location'),
          position: LatLng(value.latitude, value.longitude),
          icon: BitmapDescriptor.fromBytes(markerIcon),
          flat: true,
          anchor: const Offset(0.5, 0.5),
        );
        _addMarker(marker);
        // getPositionSubscription =
        //     location.onLocationChanged.listen((LocationData value) {
        //   // final Marker marker = Marker(
        //   //   markerId: MarkerId('current_location'),
        //   //   position: LatLng(value.latitude, value.longitude),
        //   //   icon: BitmapDescriptor.fromBytes(markerIcon),
        //   //   flat: true,
        //   //   anchor: const Offset(0.5, 0.5),
        //   // );
        //    _addMarker(marker);
        // });
        setState(() {
          lat = value.latitude;
          long = value.longitude;
        });
      });
    } catch (e) {
      return;
    }
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    final ByteData data = await rootBundle.load(path);
    final Codec codec = await instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    final FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ImageByteFormat.png))
        .buffer
        .asUint8List();
  }

  Widget accesptDeclineButtons() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 100,
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 50),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: const BorderSide(color: Colors.orange)),
                onPressed: () {
                  config.locationController.text =
                      "Tap to get your Location...";
                  Navigator.pop(context);
                },
                color: colors.white,
                textColor: colors.orange,
                child: Text("??????????")),
            const SizedBox(width: 30),
            RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(color: colors.orange)),
                onPressed: () async {
                  getIt<LocationProvider>().setLocation(lat, long);
                  getIt<LocationProvider>().setAddress(address.addressLine);
                  print(
                      "addPropAddress ${getIt<LocationProvider>().addPropAddress}");
                  if (widget.choice == 1) {
                    Navigator.popAndPushNamed(context, '/AddProp',
                        arguments: <String, String>{
                          "address": address.addressLine
                        });
                  } else {
                    await databaseHelper.addSearch(address.addressLine.trim());
                    getIt<PropertiesProvider>().addressController.text =
                        address.addressLine;
                    Navigator.pop(context);
                  }

                  // Navigator.pop(context);
                },
                color: colors.orange,
                textColor: colors.white,
                child: Text("????????????")),
          ],
        ),
      ),
    );
  }
}
