import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:progress_state_button/iconed_button.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:provider/provider.dart';
import 'package:real_estate/constants/colors.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:real_estate/data_base/DBhelper.dart';
import 'package:real_estate/helpers/service_locator.dart';
import 'package:real_estate/models/property.dart';
import 'package:real_estate/providers/property_provider.dart';
import 'package:smart_select/smart_select.dart';
import 'widgets/text_form_input.dart';

class SearchScreenLoad extends StatelessWidget {
  SearchScreenLoad({Key key, this.search}) : super(key: key);
  final DBHelper databaseHelper = DBHelper();
  final String search;
  @override
  Widget build(BuildContext context) {
    {
      return
          //  getIt<PropertiesProvider>().myProps.isEmpty
          //     ?
          FutureBuilder<List<String>>(
        future: databaseHelper.readSearches(),
        builder: (BuildContext ctx, AsyncSnapshot<List<String>> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return SearchScreen(search: search, searches: snapshot.data);
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

class SearchScreen extends StatefulWidget {
  SearchScreen({Key key, this.search, this.searches}) : super(key: key);
  final String search;
  final List<String> searches;
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  GlobalKey<AutoCompleteTextFieldState<String>> key = new GlobalKey();
  DBHelper databaseHelper = DBHelper();
  List<String> suggestions;
  List<String> added = [];
  String propType = 'شقة';
  List<S2Choice<String>> options = [
    S2Choice<String>(value: 'شقة', title: 'شقة'),
    S2Choice<String>(value: 'فيلا', title: 'فيلا'),
    S2Choice<String>(value: 'عمارة', title: 'عمارة'),
  ];
  SimpleAutoCompleteTextField textField;
  String currentText = "";
  bool showWhichErrorText = false;
  int minPrice = 1001;
  int maxPrice = 999999;
  int roomMin = 2;
  int roomMax = 2;
  bool furn = true;
  DateTime selectedDate = DateTime.now();
  ButtonState state;
  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        birthDateController.text =
            "${selectedDate.year} - ${selectedDate.month} - ${selectedDate.day}";
      });
  }

  List<bool> _isSelected;
  final TextEditingController birthDateController = TextEditingController();
  // final TextEditingController addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _isSelected = [furn, !furn];
    suggestions = widget.searches;
    textField = SimpleAutoCompleteTextField(
      key: key,
      decoration: new InputDecoration(
          alignLabelWithHint: true,
          helperText: "حدد موقع البحث",
          fillColor: colors.blue,
          hoverColor: colors.blue,
          focusColor: colors.blue),
      controller: getIt<PropertiesProvider>().addressController,
      submitOnSuggestionTap: true,
      suggestions: suggestions,
      textChanged: (text) {
        // setState(() {
        //   addressController.text = text;
        // });
      },
      clearOnSubmit: false,
      textSubmitted: (text) => setState(() {
        getIt<PropertiesProvider>().addressController.text = text;
        if (text != "") {
          setState(() {
            suggestions.add(text);
          });
        }
      }),
    );
    databaseHelper.readSearches().then((List<String> searchs) {
      setState(() {
        suggestions = searchs;
      });
      print(suggestions);
    });
    state = ButtonState.idle;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Row(children: [
            Text(widget.search),
          ]),
        ),
        body: Consumer<PropertiesProvider>(builder:
            (BuildContext context, PropertiesProvider value, Widget child) {
          return ListView(shrinkWrap: true, children: [
            ListTile(
                title: textField,
                trailing: new IconButton(
                    icon: new Icon(Icons.add),
                    onPressed: () {
                      try {
                        Navigator.pushNamed(context, '/AutoLocate',
                            arguments: <String, double>{
                              "lat": 24.774265,
                              "long": 46.738586
                            });
                      } catch (e) {}
                      // textField.triggerSubmitted();
                      // showWhichErrorText = !showWhichErrorText;
                      // textField.updateDecoration(
                      //     decoration: new InputDecoration(
                      //         errorText:
                      //             showWhichErrorText ? "لخمة" : "Tomatoes"));
                    })),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(children: <Widget>[
                  SizedBox(height: 16),
                  Text('السعر أكبر من ',
                      style: Theme.of(context).textTheme.headline6),
                  NumberPicker(
                    itemHeight: 40,
                    value: minPrice,
                    minValue: 1000,
                    maxValue: 1000000,
                    step: 1000,
                    haptics: true,
                    onChanged: (v) => setState(() => minPrice = v),
                  )
                ]),
                Column(children: <Widget>[
                  SizedBox(height: 16),
                  Text('السعر أصغر من ',
                      style: Theme.of(context).textTheme.headline6),
                  NumberPicker(
                    itemHeight: 40,
                    value: maxPrice,
                    minValue: 1000,
                    maxValue: 1000000,
                    step: 1000,
                    haptics: true,
                    onChanged: (int v) => setState(() => maxPrice = v),
                  )
                ]),
              ],
            ),
            Divider(),
            SizedBox(height: 16),
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              Column(children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('عدد الغرف أكبر من',
                      style: Theme.of(context).textTheme.headline6),
                ),
                NumberPicker(
                  value: roomMin,
                  minValue: 1,
                  maxValue: 20,
                  step: 1,
                  itemHeight: 25,
                  itemWidth: 50,
                  axis: Axis.horizontal,
                  onChanged: (value) => setState(() => roomMin = value),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.black26),
                  ),
                )
              ]),
              Column(children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('عدد الغرف أقل من',
                      style: Theme.of(context).textTheme.headline6),
                ),
                NumberPicker(
                  value: roomMax,
                  minValue: 1,
                  maxValue: 20,
                  step: 1,
                  itemHeight: 25,
                  itemWidth: 50,
                  axis: Axis.horizontal,
                  onChanged: (value) => setState(() => roomMax = value),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.black26),
                  ),
                )
              ]),
            ]),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    height: 50,
                    width: 180,
                    child: SmartSelect<String>.single(
                        title: 'نوع العقار',
                        value: propType,
                        choiceItems: options,
                        modalType: S2ModalType.bottomSheet,
                        onChange: (state) =>
                            setState(() => propType = state.value))),
                Container(
                  height: 50,
                  padding: EdgeInsets.symmetric(horizontal: 6),
                  child: Row(
                    children: [
                      ToggleButtons(
                          children: [
                            Icon(Icons.king_bed_outlined),
                            Icon(Icons.king_bed_rounded)
                          ],
                          onPressed: (int index) {
                            setState(() {
                              furn = !furn;
                              _isSelected = [furn, !furn];
                            });
                          },
                          isSelected: _isSelected),
                      Text(" حالة الفرش")
                    ],
                  ),
                ),
              ],
            ),
            Divider(),
            SizedBox(height: 12),
            TextFormInput(
                text: "تمت اضافته قبل",
                cController: birthDateController,
                prefixIcon: Icons.date_range,
                kt: TextInputType.visiblePassword,
                obscureText: false,
                readOnly: true,
                onTab: () {
                  _selectDate(context);
                },
                suffixicon: Icon(Icons.calendar_today, color: colors.blue),
                validator: (String value) {
                  return null;
                }),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: ProgressButton.icon(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 70, vertical: 0),
                  iconedButtons: {
                    ButtonState.idle: IconedButton(
                        text: "بحث",
                        icon: Icon(Icons.send, color: Colors.white),
                        color: Colors.blue.shade500),
                    ButtonState.loading: IconedButton(
                        text: "جاري التحميل",
                        color: Colors.deepPurple.shade700),
                    ButtonState.fail: IconedButton(
                        text: "فشل",
                        icon: Icon(Icons.cancel, color: Colors.white),
                        color: Colors.red.shade300),
                    ButtonState.success: IconedButton(
                        text: "تمت بنجاح",
                        icon: Icon(
                          Icons.check_circle,
                          color: Colors.white,
                        ),
                        color: Colors.green.shade400),
                  },
                  onPressed: () async {
                    setState(() {
                      state = ButtonState.loading;
                    });
                    List<Property> props = await getIt<PropertiesProvider>()
                        .getSearch(
                            widget.search,
                            minPrice,
                            maxPrice,
                            selectedDate.toString(),
                            propType,
                            roomMin,
                            roomMax,
                            furn ? 1 : 0);
                    setState(() {
                      state = ButtonState.success;
                    });
                    Navigator.pushNamed(context, "/SearchRes",
                        arguments: <String, dynamic>{"props": props});
                  },
                  state: state),
            ),
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 70, vertical: 0),
            //   child: ElevatedButton(
            //       style: ElevatedButton.styleFrom(
            //           padding:
            //               EdgeInsets.symmetric(horizontal: 20, vertical: 12)),
            //       onPressed: () async {
            //         print(
            //             "$minPrice, $maxPrice, ${selectedDate.toString()} , propType  $roomMin $roomMax ${furn ? 1 : 0}");
            //         Navigator.pushNamed(context, "/SearchResult",
            //             arguments: <String, dynamic>{
            //               "state": widget.search,
            //               "minPrice": minPrice,
            //               "maxPrice": maxPrice,
            //               "selectedDate": selectedDate.toString(),
            //               "propType": propType,
            //               "roomMin": roomMin,
            //               "roomMax": roomMax,
            //               "furn": furn ? 1 : 0
            //             });
            //         // await databaseHelper.searchProps(
            //         //     minPrice,
            //         //     maxPrice,
            //         //     selectedDate.toString(),
            //         //     propType,
            //         //     roomMin,
            //         //     roomMax,
            //         //     furn ? 1 : 0);
            //       },
            //       child: Text("بحث", style: TextStyle(fontSize: 26))),
            // )
          ]);
        }));
  }
}
