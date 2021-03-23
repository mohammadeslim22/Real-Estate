import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:real_estate/constants/colors.dart';
import 'package:real_estate/providers/location_provider.dart';

import 'widgets/text_form_input.dart';

class AddProp extends StatefulWidget {
  AddProp({Key key, this.address}) : super(key: key);
  final String address;
  @override
  _AddPropState createState() => _AddPropState();
}

class _AddPropState extends State<AddProp> {
  final FocusNode focus1 = FocusNode();
  final FocusNode focus2 = FocusNode();

  final FocusNode focus3 = FocusNode();

  final TextEditingController locationController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController roomsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    locationController.text = widget.address;
  }

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
          title: Text("إضافة مسكن"),
          backgroundColor: colors.white,
        ),
        body: Consumer<LocationProvider>(builder:
            (BuildContext context, LocationProvider value, Widget child) {
          return ListView(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            shrinkWrap: true,
            children: [
              TextFormInput(
                  text: "ادخل الموقع",
                  cController: locationController,
                  prefixIcon: Icons.my_location,
                  kt: TextInputType.visiblePassword,
                  readOnly: true,
                  onTab: () async {
                    try {
                      Navigator.popAndPushNamed(context, '/AutoLocate',
                          arguments: <String, double>{
                            "lat": 24.774265,
                            "long": 46.738586
                          });
                    } catch (e) {}
                  },
                  suffixicon: IconButton(
                    icon: const Icon(Icons.add_location, color: Colors.blue),
                    onPressed: () {},
                  ),
                  obscureText: false,
                  focusNode: focus1,
                  validator: (String value) {
                    if (value.isEmpty) {
                      return "حدد العنوان من فضلك";
                    }
                    return value;
                  }),
              Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
                  child: RaisedButton(
                      padding:
                          EdgeInsets.symmetric(horizontal: 0, vertical: 12),
                      onPressed: () {},
                      child: Text("اضف بعض الصور",
                          style: TextStyle(color: colors.white, fontSize: 20)),
                      color: colors.blue)),
              TextFormInput(
                  text: "ادخل السعر",
                  cController: priceController,
                  prefixIcon: Icons.money,
                  kt: TextInputType.number,
                  readOnly: false,
                  onTab: () async {
                    try {} catch (e) {}
                  },
                  obscureText: false,
                  focusNode: focus2,
                  validator: (String value) {
                    if (value.isEmpty) {
                      return "حدد السعر من فضلك";
                    }
                    return value;
                  }),
              TextFormInput(
                  text: "ادخل عدد الغرف",
                  cController: roomsController,
                  prefixIcon: Icons.money,
                  kt: TextInputType.number,
                  readOnly: false,
                  onTab: () async {
                    try {} catch (e) {}
                  },
                  obscureText: false,
                  focusNode: focus3,
                  validator: (String value) {
                    if (value.isEmpty) {
                      return "حدد عدد الغرف من فضلك";
                    }
                    return value;
                  }),
            ],
          );
        }));
  }
}
