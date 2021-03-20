import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class HOMEMAProvider with ChangeNotifier {
  bool dataloaded = false;

  double rotation;
  bool specesLoaded = false;


  int selectedSpecialize = 1;


  bool offersHorizontalCardsList = false;
  GlobalKey<ScaffoldState> scaffoldkey = GlobalKey<ScaffoldState>();
  bool specSelected = false;
  int selectedBranchId;
  bool showSlidingPanel = false;
  bool showSepcializationsPad = true;
  AnimationController controller;




  void setRotation(double r) {
    rotation = r;
    notifyListeners();
  }


  void hideOffersHorizontalCards() {
    offersHorizontalCardsList = false;
    if (controller != null) controller.reverse();
    notifyListeners();
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

}
