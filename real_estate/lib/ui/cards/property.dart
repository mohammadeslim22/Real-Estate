import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:real_estate/constants/colors.dart';
import 'package:real_estate/helpers/image_utility.dart';
import 'package:real_estate/models/property.dart';

class PropertyCard extends StatefulWidget {
  PropertyCard({Key key, this.prop}) : super(key: key);
  final Property prop;
  @override
  _PropertyCardState createState() => _PropertyCardState();
}

class _PropertyCardState extends State<PropertyCard> {
  Property prop;
  String addresses;
  @override
  void initState() {
    super.initState();
    prop = widget.prop;
    Coordinates coordinates = Coordinates(prop.latitude, prop.longitude);

    Geocoder.local
        .findAddressesFromCoordinates(coordinates)
        .then((List<Address> adds) {
      setState(() {
        addresses = adds[0].addressLine;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CarouselSlider(
              options: CarouselOptions(
                  height: 300,
                  viewportFraction: 1,
                  initialPage: 0,
                  enableInfiniteScroll: true,
                  reverse: true,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 3),
                  autoPlayAnimationDuration: const Duration(milliseconds: 800),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  scrollDirection: Axis.horizontal,
                  pageViewKey:
                      const PageStorageKey<dynamic>('carousel_slider')),
              items: prop.images.isEmpty
                  ? <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width,
                       
                        child: Image.asset("assets/images/logo.jpg",
                            width: MediaQuery.of(context).size.width,
                            fit: BoxFit.fill),
                      ),
                    ]
                  : prop.images.map((photo) {
                      return Utility.imageFromBase64String(photo.image,context);
                    }).toList()),
          Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: colors.grey,
              child: Text(prop.price.toString())),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(prop.type ?? ""),
                  Text(addresses ?? ""),
                  const SizedBox(height: 6),
                  Text(prop.dateAdded ?? ""),
                ],
              )),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(icon: Icon(Icons.message), onPressed: () {}),
              IconButton(icon: Icon(Icons.phone), onPressed: () {}),
              IconButton(icon: Icon(Icons.clear), onPressed: () {}),
              IconButton(icon: Icon(Icons.favorite_outline), onPressed: () {}),
            ],
          )
        ],
      ),
    );
  }
}
