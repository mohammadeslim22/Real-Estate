import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:like_button/like_button.dart';
import 'package:real_estate/constants/colors.dart';
import 'package:real_estate/helpers/functions.dart';
import 'package:real_estate/helpers/image_utility.dart';
import 'package:real_estate/helpers/service_locator.dart';
import 'package:real_estate/helpers/size_config.dart';
import 'package:real_estate/models/property.dart';
import 'package:real_estate/providers/property_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class PropScreen extends StatefulWidget {
  PropScreen({Key key, this.prop}) : super(key: key);
  final Property prop;
  @override
  _PropScreenState createState() => _PropScreenState();
}

class _PropScreenState extends State<PropScreen> {
  Property prop;
  String addresses;
  Set<Marker> markers=<Marker>{};
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
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Row(children: [
          Text("شاشة العقار"),
        ]),
      ),
      body: ListView(
        children: [
          CarouselSlider(
              options: CarouselOptions(
                  height: 330,
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
                  Text(
                    prop.price.toString(),
                    style: TextStyle(fontSize: 25, color: Colors.black),
                  ),
                  LikeButton(
                    circleSize: SizeConfig.blockSizeHorizontal * 12,
                    size: SizeConfig.blockSizeHorizontal * 7,
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    countPostion: CountPostion.bottom,
                    circleColor: const CircleColor(
                        start: Colors.orange, end: Colors.purple),
                    isLiked: false,
                    onTap: (bool loved) async {
                      return !loved;
                    },
                    likeCountPadding: const EdgeInsets.symmetric(vertical: 0),
                  ),
                ],
              )),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(prop.type ?? "",
                      style: TextStyle(fontSize: 20, color: Colors.green)),
                  const SizedBox(height: 6),
                  Text(addresses ?? ""),
                  const SizedBox(height: 6),
                  Text(" تاريخ الإضافة :${prop.dateAdded}",
                      style: TextStyle(color: colors.ggrey)),
                  const SizedBox(height: 6),
                  Text(
                      " حالة الفرش :${prop.furniture == 1 ? "مفروشة" : "غير مفروشة"}",
                      style: TextStyle(color: colors.ggrey)),
                  const SizedBox(height: 16),
                  Text(prop.description ?? ""),
                ],
              )),
          Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ElevatedButton(
                onPressed: () async {
                  markers.add(await (getIt<PropertiesProvider>()
                      .addMarker(prop, false)));
                  showDialog(
                      context: context,
                      builder: (context) {
                        return Container(
                            width: MediaQuery.of(context).size.width - 100,
                            height: MediaQuery.of(context).size.height - 100,
                            child: GoogleMap(
                              myLocationEnabled: true,
                              myLocationButtonEnabled: true,
                              indoorViewEnabled: false,
                              zoomControlsEnabled: false,
                              onMapCreated:
                                  (GoogleMapController controller) async {},
                              onTap: (LatLng ll) {
                                //   value.showOffersHorizontalCards();
                              },
                              padding: const EdgeInsets.only(bottom: 60),
                              mapType: MapType.normal,
                              markers: markers,
                              initialCameraPosition: CameraPosition(
                                  target: LatLng(prop.latitude, prop.longitude),
                                  zoom: 13),
                              onCameraMove: (CameraPosition pos) {},
                              onCameraIdle: () {},
                            ));
                      });
                },
                child: Text("عرض على الخريطة")),
          )
        ],
      ),
      bottomNavigationBar: Container(
        height: 60,
        color: Color(0xFF252727),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const SizedBox(width: 6),
            Expanded(
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                color: Color(0xFF00A767),
                child: Text("اتصل بنا",
                    style: TextStyle(fontSize: 24, color: Color(0xFF170531))),
                onPressed: () {
                  launch("tel://21213123123");
                },
              ),
              // width: SizeConfig.blockSizeHorizontal * 32,
              // height: SizeConfig.blockSizeVertical * 6,
            ),
            const SizedBox(width: 6),
            Expanded(
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                color: Color(0xFF00A767),
                child: Text("محادثة",
                    style: TextStyle(fontSize: 24, color: Color(0xFF170531))),
                onPressed: () {
                  Navigator.pushNamed(context, "/ChatScreen");
                },
              ),
              // width: SizeConfig.blockSizeHorizontal * 32,
              // height: SizeConfig.blockSizeVertical * 6,
            ),
            const SizedBox(width: 6),
          ],
        ),
      ),
    );
  }
}
