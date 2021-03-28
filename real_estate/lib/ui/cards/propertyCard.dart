import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:real_estate/constants/colors.dart';
import 'package:real_estate/data_base/DBhelper.dart';
import 'package:real_estate/helpers/image_utility.dart';
import 'package:real_estate/models/property.dart';
import 'package:url_launcher/url_launcher.dart';

class PropertyCard extends StatefulWidget {
  PropertyCard({Key key, this.prop, this.fav}) : super(key: key);
  final Property prop;
  final bool fav;
  @override
  _PropertyCardState createState() => _PropertyCardState();
}

class _PropertyCardState extends State<PropertyCard> {
  Property prop;
  String addresses;
  Color favButton;
  DBHelper databaseHelper = DBHelper();

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
    if (widget.fav) {
      favButton = colors.red;
    } else {
      favButton = colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
          onTap: () {
            Navigator.pushNamed(context, "/PropScreen",
                arguments: <String, dynamic>{"prop": prop});
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CarouselSlider(
                  options: CarouselOptions(
                      height: 230,
                      viewportFraction: 1,
                      initialPage: 0,
                      enableInfiniteScroll: true,
                      reverse: true,
                      autoPlay: true,
                      autoPlayInterval: const Duration(seconds: 3),
                      autoPlayAnimationDuration:
                          const Duration(milliseconds: 800),
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
                          return Utility.imageFromBase64String(
                              photo.image, context);
                        }).toList()),
              Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  color: colors.grey,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(prop.price.toString()),
                      Text(
                        prop.state.toString(),
                        style: TextStyle(color: colors.green),
                      ),
                    ],
                  )),
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
                  IconButton(
                      icon: Icon(Icons.message),
                      onPressed: () {
                        Navigator.pushNamed(context, "/ChatScreen");
                      }),
                  IconButton(
                      icon: Icon(Icons.phone),
                      onPressed: () {
                        launch("tel://21213123123");
                      }),
                  IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                  IconButton(
                      icon: Icon(Icons.favorite_outline, color: favButton),
                      onPressed: () async {
                        await databaseHelper.addFav(prop.id);
                        setState(() {
                          if (widget.fav) {
                            favButton = colors.black;
                          } else {
                            favButton = colors.red;
                          }
                        });
                      }),
                ],
              )
            ],
          )),
    );
  }
}
