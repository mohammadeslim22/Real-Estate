import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:real_estate/constants/colors.dart';
import 'package:real_estate/providers/location_provider.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';
import 'package:real_estate/providers/mainprovider.dart';
import 'package:real_estate/providers/property_provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'widgets/text_form_input.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';

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
  final RoundedLoadingButtonController _btnController =
      new RoundedLoadingButtonController();

  String type = "";
  @override
  void initState() {
    type = _items.first;
    super.initState();
    locationController.text = widget.address;
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool furn = true;
  String propState = "للبيع";
  final TextEditingController descController = TextEditingController();
  List<Asset> images = <Asset>[];
  final List<String> _items = ['شقة', 'فيلا', 'عمارة'].toList();
  @override
  Widget build(BuildContext context) {
    final PropertiesProvider propProvider =
        Provider.of<PropertiesProvider>(context);

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
          return Form(
              key: _formKey,
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                shrinkWrap: true,
                children: [
                  TextFormInput(
                      text: "ادخل الموقع",
                      cController: locationController,
                      prefixIcon: Icons.my_location,
                      kt: TextInputType.visiblePassword,
                      readOnly: true,
                      onTab: () {
                        try {
                          print("where are we going");
                          Navigator.popAndPushNamed(context, '/AutoLocate',
                              arguments: <String, double>{
                                "lat": 24.774265,
                                "long": 46.738586,
                                "choice": 1.0
                              });
                        } catch (e) {
                          print("going in catch $e");
                        }
                      },
                      suffixicon: IconButton(
                        icon:
                            const Icon(Icons.add_location, color: Colors.blue),
                        onPressed: () {},
                      ),
                      obscureText: false,
                      focusNode: focus1,
                      validator: (String value) {
                        if (value.isEmpty) {
                          return "حدد العنوان من فضلك";
                        }
                        return null;
                      }),
                  Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 16),
                      child: RaisedButton(
                          padding:
                              EdgeInsets.symmetric(horizontal: 0, vertical: 12),
                          onPressed: () {
                            loadAssets();
                          },
                          child: Text("اضف بعض الصور",
                              style:
                                  TextStyle(color: colors.white, fontSize: 20)),
                          color: colors.blue)),
                  Visibility(
                      child: buildGridView(), visible: images.isNotEmpty),

                  CustomRadioButton(
                    absoluteZeroSpacing: false,
                    unSelectedColor: Theme.of(context).canvasColor,
                    buttonLables: [
                      "للبيع",
                      "للإيجار",
                    ],
                    buttonValues: [
                      "للبيع",
                      "للإيجار",
                    ],
                    radioButtonValue: (value) {
                      setState(() {
                        propState = value.toString();
                      });
                    },
                    defaultSelected: "للبيع",
                    width: MediaQuery.of(context).size.width / 3,
                    horizontal: false,
                    enableShape: true,
                    enableButtonWrap: true,
                    selectedColor: Theme.of(context).accentColor,
                    padding: 5,
                    spacing: 0.0,
                    unSelectedBorderColor: colors.blue,
                  ),
                  const SizedBox(height: 12),
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
                        } else {
                          return null;
                        }
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
                        } else {
                          return null;
                        }
                      }),

                  Padding(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          LiteRollingSwitch(
                            value: true,
                            textOn: 'فرش',
                            textOff: 'بدون فرش',
                            colorOn: Colors.blue,
                            colorOff: Colors.grey,
                            iconOn: Icons.done,
                            iconOff: Icons.remove_circle_outline,
                            textSize: 16.0,
                            onSwipe: () {
                              setState(() {
                                furn = !furn;
                              });
                            },
                            onChanged: (bool state) {},
                          ),
                          DropdownButton<String>(
                            dropdownColor: colors.grey,
                            value: type,
                            hint: Text("اختر نوع العقار"),
                            items: <String>['شقة', 'فيلا', 'عمارة']
                                .map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (String choice) {
                              print("type on change $choice");
                              setState(() {
                                type = choice;
                              });
                            },
                          ),

                          // LiteRollingSwitch(

                          //   value: true,
                          //   textOn: 'للبيع',
                          //   textOff: 'للإيجار',
                          //   colorOn: Colors.blue,
                          //   colorOff: Colors.grey,
                          //   iconOn: Icons.done,
                          //   iconOff: Icons.remove_circle_outline,
                          //   textSize: 16.0,
                          //   onSwipe: () {
                          //     setState(() {
                          //       propState = !propState;
                          //     });
                          //   },
                          //   onChanged: (bool state) {},
                          // ),
                        ],
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 12)),
                  simpleForm(3, 5, "message", descController),
                  const SizedBox(height: 24),
                  RoundedLoadingButton(
                    child: Text("إضافة مسكن",
                        style: TextStyle(color: Colors.white, fontSize: 24)),
                    controller: _btnController,
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        await propProvider.addProp(
                            propState??"للبيع",
                            type,
                            int.parse(roomsController.text),
                            int.parse(priceController.text),
                            furn ? 1 : 0,
                            descController.text,
                            images);
                            Navigator.popAndPushNamed(context, "/MyProps");
                      }
                    },
                  ),
                  // RaisedButton(
                  //     shape: RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.circular(18.0),
                  //         side: BorderSide(color: colors.blue)),
                  //     onPressed: () async {
                  //       if (_formKey.currentState.validate()) {
                  //         mainProvider.togelf(true);
                  //         print(
                  //             "trying to add prop $type ${int.parse(roomsController.text)},${double.parse(priceController.text)},$furn ${descController.text}");

                  //         Navigator.popAndPushNamed(context, "/MyProps");

                  //         mainProvider.togelf(false);
                  //       }
                  //     },
                  //     color: colors.blue,
                  //     textColor: colors.white,
                  //     child: mainProvider.returnchild("إضافة مسكن")),
                ],
              ));
        }));
  }

  Widget buildGridView() {
    return GridView.count(
      physics: const ScrollPhysics(),
      shrinkWrap: true,
      crossAxisCount: 3,
      children: List.generate(images.length, (index) {
        Asset asset = images[index];
        return AssetThumb(asset: asset, width: 300, height: 300);
      }),
    );
  }

  Future<void> loadAssets() async {
    List<Asset> resultList = <Asset>[];
    String error = 'No Error Detected';

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 300,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "اختار صور المسكن",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      print("images $images");
      images = resultList;
      print("images $images");
    });
  }

  Widget simpleForm(
      int minLines, int maxLines, String text, TextEditingController controller,
      {Widget sufixIcon, Widget suffix, TextInputType tit}) {
    return TextFormField(
        minLines: minLines,
        maxLines: maxLines,
        controller: controller,
        keyboardType: tit,
        decoration: InputDecoration(
          filled: true,
          fillColor: colors.white,
          hintText: text,
          hintStyle: TextStyle(
            color: colors.ggrey,
            fontSize: 15,
          ),
          suffixIcon: sufixIcon,
          suffix: suffix,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(7),
          ),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
            color: colors.ggrey,
          )),
        ));
  }
}
