import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:real_estate/constants/colors.dart';
import 'package:real_estate/constants/config.dart';
import 'package:real_estate/helpers/functions.dart';
import 'package:real_estate/helpers/service_locator.dart';
import 'package:real_estate/models/property.dart';
import 'package:real_estate/providers/property_provider.dart';
import 'cards/property.dart';

class LoadMyProps extends StatelessWidget {
  LoadMyProps({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    {
      return
          //  getIt<PropertiesProvider>().myProps.isEmpty
          //     ?
          FutureBuilder<List<Property>>(
        future: getIt<PropertiesProvider>().getMyProps(),
        builder: (BuildContext ctx, AsyncSnapshot<List<Property>> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return MyProperties(
              props: snapshot.data,
            );
          } else {
            return Container(
                color: colors.white,
                child: const CupertinoActivityIndicator(radius: 24));
          }
        },
      );
      // : MyProperties();
    }
  }
}

class MyProperties extends StatefulWidget {
  MyProperties({Key key, this.props}) : super(key: key);

  final List<Property> props;
  @override
  _MyPropertiesState createState() => _MyPropertiesState();
}

class _MyPropertiesState extends State<MyProperties> {
  @override
  void initState() {
    super.initState();
  }

  double long;
  double lat;
  void handleClick(String value) {
    switch (value) {
      case 'على الخريطة':
        setState(() {
          mapOrList = false;
        });
        break;
      case 'قائمة':
        setState(() {
          mapOrList = true;
        });
        break;
    }
  }

  bool mapOrList = false;
  bool serviceEnabled;
  PermissionStatus permissionGranted;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: colors.white,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          centerTitle: true,
          title: Text("مساكني"),
          backgroundColor: colors.white,
          actions: [
            PopupMenuButton<String>(
              onSelected: handleClick,
              itemBuilder: (BuildContext context) {
                return {"قائمة", "على الخريطة"}.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
            ),
          ],
        ),
        body: Consumer<PropertiesProvider>(
          builder:
              (BuildContext context, PropertiesProvider value, Widget child) {
            return Visibility(
              visible: mapOrList,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: widget.props.length,
                itemBuilder: (BuildContext context, int index) {
                  return PropertyCard(prop: widget.props[index]);
                },
              ),
              replacement: GoogleMap(
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                indoorViewEnabled: false,
                zoomControlsEnabled: false,
                
                onMapCreated: (GoogleMapController controller) async {
                  print("value.markers ${value.markers.length}");
                  serviceEnabled = await location.serviceEnabled();
                  permissionGranted = await location.hasPermission();
                  value.mapController = controller;
                  if (permissionGranted == PermissionStatus.denied) {
                  } else {
                    if (!serviceEnabled) {
                    } else {
                      _animateToUser(value);
                    }
                  }
                },
                onTap: (LatLng ll) {
                  //   value.showOffersHorizontalCards();
                },
                padding: const EdgeInsets.only(bottom: 60),
                mapType: MapType.satellite,
                markers: Set<Marker>.of(value.markers),
                initialCameraPosition: CameraPosition(
                    target: LatLng(config.lat, config.long), zoom: 13),
                onCameraMove: (CameraPosition pos) {
                  lat = pos.target.latitude;
                  long = pos.target.longitude;
                },
                onCameraIdle: () {},
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
            elevation: 0.0,
            child: Icon(Icons.add, size: 32, color: colors.white),
            backgroundColor: new Color(0xFF13B4B9),
            onPressed: () {
              Navigator.pushNamed(context, "/AddProp",
                  arguments: <String, String>{"address": ""});
            }));
  }

  Future<void> _animateToUser(PropertiesProvider propertiesProvider) async {
    try {
      if (mounted) {
        await location.getLocation().then((LocationData value) {
          propertiesProvider.mapController
              .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
            target: LatLng(value.latitude, value.longitude),
            zoom: 13,
          )));

          lat = value.latitude;
          long = value.longitude;
        });
      }
    } catch (e) {
      return;
    }
  }
}
