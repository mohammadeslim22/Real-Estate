import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:real_estate/constants/colors.dart';
import 'package:real_estate/helpers/service_locator.dart';
import 'package:real_estate/models/property.dart';
import 'package:real_estate/providers/property_provider.dart';

import 'cards/property.dart';

class LoadMyProps extends StatelessWidget {
  LoadMyProps({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    {
      return getIt<PropertiesProvider>().myProps.isEmpty
          ? FutureBuilder<List<Property>>(
              future: getIt<PropertiesProvider>().getMyProps(),
              builder:
                  (BuildContext ctx, AsyncSnapshot<List<Property>> snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return MyProperties();
                } else {
                  return Container(
                      color: colors.white,
                      child: const CupertinoActivityIndicator(radius: 24));
                }
              },
            )
          : MyProperties();
    }
  }
}

class MyProperties extends StatefulWidget {
  MyProperties({Key key}) : super(key: key);
  @override
  _MyPropertiesState createState() => _MyPropertiesState();
}

class _MyPropertiesState extends State<MyProperties> {
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
        ),
        body: Consumer<PropertiesProvider>(
          builder:
              (BuildContext context, PropertiesProvider value, Widget child) {
            return ListView.builder(
              shrinkWrap: true,
              itemCount: getIt<PropertiesProvider>().myProps.length,
              itemBuilder: (BuildContext context, int index) {
                return PropertyCard(
                    prop: getIt<PropertiesProvider>().myProps[index]);
              },
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
}
