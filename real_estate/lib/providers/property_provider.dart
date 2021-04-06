import 'dart:convert' as convert;
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:location/location.dart';
import 'package:real_estate/helpers/functions.dart';
import 'package:real_estate/helpers/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:real_estate/constants/config.dart';
import 'package:real_estate/data_base/DBhelper.dart';
import 'package:real_estate/helpers/service_locator.dart';
import 'package:real_estate/models/chat_message.dart';
import 'package:real_estate/models/property.dart';
import 'package:real_estate/providers/location_provider.dart';
import 'package:geolocator/geolocator.dart';

class PropertiesProvider with ChangeNotifier {
  List<Property> myProps = <Property>[];
  List<Property> myFavs = <Property>[];
  List<Property> mySearch = <Property>[];
  List<Property> mySearchWithDistnce = <Property>[];

  DBHelper databaseHelper = DBHelper();
  List<File> fileImageArray = [];
  Property inFocusProperty;

  List<Marker> markers = <Marker>[];
  List<Marker> favMarkers = <Marker>[];
  List<Marker> searchMarkers = <Marker>[];
  double lat = config.lat;
  double long = config.long;
  GoogleMapController mapController;
  final TextEditingController addressController = TextEditingController();

  Future<List<Property>> getMyProps() async {
    myProps = await databaseHelper.readMyProperties(config.userId);
    for (final Property property in myProps) {
      await addMarker(
          property,
          property.id ==
              (inFocusProperty != null ? inFocusProperty.id : 99999));
    }
    notifyListeners();
    return myProps;
  }

  Future<List<Property>> getSearch(
      String state,
      int firstPrice,
      int secondprice,
      String timeAdded,
      String type,
      int roomMin,
      int roomMax,
      int furn) async {
    print("search with no distance");
    mySearch = await databaseHelper.searchProps(state, firstPrice, secondprice,
        timeAdded, type, roomMin, roomMax, furn);
    for (final Property property in mySearch) {
      await addSearchMarker(
          property,
          property.id ==
              (inFocusProperty != null ? inFocusProperty.id : 99999));
    }
    notifyListeners();
    return mySearch;
  }

  Future<List<Property>> getSearchWithDistance(
      String state,
      int distance,
      int firstPrice,
      int secondprice,
      String timeAdded,
      String type,
      int roomMin,
      int roomMax,
      int furn) async {
    mySearch = await databaseHelper.searchProps(state, firstPrice, secondprice,
        timeAdded, type, roomMin, roomMax, furn);
    // take out props not in area
    await location.getLocation().then((LocationData value) {
      lat = value.latitude;
      long = value.longitude;
    });
    mySearch.forEach((Property element) async {
      print("enter distance search");
      double distanceInKM = Geolocator.distanceBetween(
              element.latitude, element.longitude, lat, long) /
          1000;
      print("distance search $distance  kms  $distanceInKM");
      if (distanceInKM <= distance) {
        print("prop added ${element.price}");
        mySearchWithDistnce.add(element);
      }
    });
    for (final Property property in mySearchWithDistnce) {
      await addSearchMarker(
          property,
          property.id ==
              (inFocusProperty != null ? inFocusProperty.id : 99999));
    }
    notifyListeners();
    return mySearchWithDistnce;
  }

  Future<List<Property>> getFavs() async {
    myFavs = await databaseHelper.readFavs();
    for (final Property property in myFavs) {
      await addFavMarker(
          property,
          property.id ==
              (inFocusProperty != null ? inFocusProperty.id : 99999));
    }
    notifyListeners();
    return myFavs;
  }

  Future<void> addProp(String state, String type, int rooms, int price,
      int furniture, String description, List<Asset> images) async {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String dateString = formatter.format(now);
    Property p = Property(
        config.userId,
        state,
        type,
        rooms,
        price,
        furniture,
        dateString,
        getIt<LocationProvider>().addProplong,
        getIt<LocationProvider>().addProplat,
        <PropertyImage>[],
        description);
    int newPId = await databaseHelper.addProp(p);
    images.forEach((Asset asst) async {
      final filePath =
          await FlutterAbsolutePath.getAbsolutePath(asst.identifier);
      File tempFile = File(filePath);
      if (tempFile.existsSync()) {
        fileImageArray.add(tempFile);
      }
      List<int> imageBytes = tempFile.readAsBytesSync();
      print(imageBytes);
      String base64Image = convert.base64Encode(imageBytes);
      print("image file $base64Image");
      PropertyImage pI = PropertyImage(newPId, base64Image);
      await databaseHelper.addImage(pI);
    });

    myProps.add(p);
    notifyListeners();
  }

  Future<Marker> addMarker(Property element, bool focus) async {
    Uint8List markerIcon;
    if (focus) {
      print("a77777aaaaaa");
      markerIcon = await getBytesFromAsset('assets/images/apartment_f.png',
          (SizeConfig.blockSizeHorizontal * 46).round());
    } else {
      if (element.type == "شقة") {
        markerIcon = await getBytesFromAsset('assets/images/villa.png',
            (SizeConfig.blockSizeHorizontal * 38).toInt());
      } else if (element.type == "فيلا") {
        markerIcon = await getBytesFromAsset('assets/images/villa_2.png',
            (SizeConfig.blockSizeHorizontal * 38).round());
      } else {
        markerIcon = await getBytesFromAsset('assets/images/skyscrapers.png',
            (SizeConfig.blockSizeHorizontal * 40).round());
      }
    }

    final Marker marker = Marker(
        markerId: MarkerId(element.id.toString()),
        position: LatLng(element.latitude, element.longitude),
        icon: BitmapDescriptor.fromBytes(markerIcon),
        onTap: () async {
          inFocusProperty = element;
          editMarkersIcons(element);
          await mapController
              .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
            target: LatLng(element.latitude, element.longitude),
            zoom: 17,
          )));
          notifyListeners();
        },
        infoWindow: InfoWindow(title: element.price.toString()));

    markers.add(marker);
    return marker;
  }

  Future<Marker> addFavMarker(Property element, bool focus) async {
    Uint8List markerIcon;
    if (focus) {
      print("a77777aaaaaa");
      markerIcon = await getBytesFromAsset('assets/images/apartment_f.png',
          (SizeConfig.blockSizeHorizontal * 46).round());
    } else {
      if (element.type == "شقة") {
        markerIcon = await getBytesFromAsset('assets/images/villa.png',
            (SizeConfig.blockSizeHorizontal * 38).toInt());
      } else if (element.type == "فيلا") {
        markerIcon = await getBytesFromAsset('assets/images/villa_2.png',
            (SizeConfig.blockSizeHorizontal * 38).round());
      } else {
        markerIcon = await getBytesFromAsset('assets/images/skyscrapers.png',
            (SizeConfig.blockSizeHorizontal * 40).round());
      }
    }

    final Marker marker = Marker(
        markerId: MarkerId(element.id.toString()),
        position: LatLng(element.latitude, element.longitude),
        icon: BitmapDescriptor.fromBytes(markerIcon),
        onTap: () async {
          inFocusProperty = element;
          editMarkersIcons(element);
          await mapController
              .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
            target: LatLng(element.latitude, element.longitude),
            zoom: 17,
          )));
          notifyListeners();
        },
        infoWindow: InfoWindow(title: element.price.toString()));

    favMarkers.add(marker);
    return marker;
  }

  Future<Marker> addSearchMarker(Property element, bool focus) async {
    Uint8List markerIcon;
    if (focus) {
      markerIcon = await getBytesFromAsset('assets/images/apartment_f.png',
          (SizeConfig.blockSizeHorizontal * 46).round());
    } else {
      if (element.type == "شقة") {
        markerIcon = await getBytesFromAsset('assets/images/villa.png',
            (SizeConfig.blockSizeHorizontal * 38).toInt());
      } else if (element.type == "فيلا") {
        markerIcon = await getBytesFromAsset('assets/images/villa_2.png',
            (SizeConfig.blockSizeHorizontal * 38).round());
      } else {
        markerIcon = await getBytesFromAsset('assets/images/skyscrapers.png',
            (SizeConfig.blockSizeHorizontal * 40).round());
      }
    }

    final Marker marker = Marker(
        markerId: MarkerId(element.id.toString()),
        position: LatLng(element.latitude, element.longitude),
        icon: BitmapDescriptor.fromBytes(markerIcon),
        onTap: () async {
          inFocusProperty = element;
          editMarkersIcons(element);
          await mapController
              .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
            target: LatLng(element.latitude, element.longitude),
            zoom: 17,
          )));
          notifyListeners();
        },
        infoWindow: InfoWindow(title: element.price.toString()));

    searchMarkers.add(marker);
    return marker;
  }

  Future<void> editMarkersIcons(Property element) async {
    markers.clear();
    for (final Property property in myProps) {
      print(
          "${property.id}  =============  ${element.id} ${property.id == element.id}");
      await addMarker(property, property.id == element.id);
    }
    // addUserIcon();
  }

  // Future<void> addUserIcon() async {
  //   final Uint8List markerIcon = await getBytesFromAsset(
  //       'assets/images/logo.png',
  //       (SizeConfig.blockSizeHorizontal * 42).toInt());
  //   markers.add(Marker(
  //     markerId: MarkerId("user"),
  //     position: LatLng(config.lat, config.long),
  //     icon: BitmapDescriptor.fromBytes(markerIcon),
  //   ));
  // }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    final ByteData data = await rootBundle.load(path);
    final Codec codec = await instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    final FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ImageByteFormat.png))
        .buffer
        .asUint8List();
  }

  void addMessage(ChatMessage cm) {
    messages.add(cm);
    notifyListeners();
  }

  List<ChatMessage> messages = [
    ChatMessage(
        messageContent: "مرحبا,هل يمكنك مساعدتي", messageType: "sender"),
    ChatMessage(
        messageContent: "أهلا, كيف يمكنني مساعدتك ؟", messageType: "receiver"),
    // ChatMessage(
    //     messageContent: "Hey Kriss, I am doing fine dude. wbu?",
    //     messageType: "sender"),
    // ChatMessage(messageContent: "ehhhh, doing OK.", messageType: "receiver"),
    // ChatMessage(
    //     messageContent: "Is there any thing wrong?", messageType: "sender"),
  ];
}
