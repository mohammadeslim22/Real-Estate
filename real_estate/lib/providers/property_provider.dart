import 'package:flutter/material.dart';
import 'package:real_estate/constants/config.dart';
import 'package:real_estate/data_base/DBhelper.dart';
import 'package:real_estate/models/property.dart';

class PropertiesProvider with ChangeNotifier {
  List<Property> myProps = <Property>[];
  DBHelper databaseHelper = DBHelper();

  Future<List<Property>> getMyProps() async {
    myProps = await databaseHelper.readMyProperties(config.user.id);
    notifyListeners();
    return myProps;
  }

  Future<bool> addProp(Property p) async {
    myProps.add(p);
    // databaseHelper.addProp(p);
    notifyListeners();

  }
}
