import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart' as intl;
import 'package:real_estate/constants/config.dart';
import 'package:real_estate/constants/styles.dart';
import 'package:real_estate/providers/mainprovider.dart';
import 'package:real_estate/providers/auth.dart';
import '../widgets/buttonTouse.dart';
import '../widgets/text_form_input.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:vibration/vibration.dart';
import 'package:real_estate/constants/colors.dart';
import 'package:real_estate/helpers/data.dart';
import 'package:real_estate/helpers/functions.dart';

class Registration extends StatefulWidget {
  @override
  _MyRegistrationState createState() => _MyRegistrationState();
}

class _MyRegistrationState extends State<Registration>
    with TickerProviderStateMixin {
  List<String> location2;
  bool _isButtonEnabled;
  bool _obscureText = false;
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileNoController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController birthDateController = TextEditingController();
  static DateTime today = DateTime.now();
  DateTime firstDate = DateTime(today.year - 90, today.month, today.day);
  DateTime lastDate = DateTime(today.year - 18, today.month, today.day);
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    _isButtonEnabled = true;
    data.getData("countryDialCodeTemp").then((String value) {});
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: lastDate,
        firstDate: firstDate,
        lastDate: lastDate);
    if (picked != null && picked != today)
      setState(() {
        today = picked;
        birthDateController.text = intl.DateFormat('yyyy-MM-dd').format(picked);
        FocusScope.of(context).requestFocus(FocusNode());
      });
    if (picked == null || picked != today)
      FocusScope.of(context).requestFocus(FocusNode());
  }

  Widget customcard(
      BuildContext context, MainProvider mainProvider, Auth auth) {
    final bool isRTL = Directionality.of(context) == TextDirection.rtl;
    final FocusNode focus = FocusNode();
    final FocusNode focus1 = FocusNode();
    final FocusNode focus2 = FocusNode();
    final FocusNode focus3 = FocusNode();
    final FocusNode focus4 = FocusNode();
    return Padding(
        padding: const EdgeInsets.fromLTRB(16, 32, 16, 0),
        child: Form(
            key: _formKey,
            // onWillPop: () {
            //   return onWillPop(context);
            // },
            child: Column(children: <Widget>[
              TextFormInput(
                  text: '??????????',
                  cController: usernameController,
                  prefixIcon: Icons.person_outline,
                  kt: TextInputType.visiblePassword,
                  obscureText: false,
                  focusNode: focus,
                  readOnly: false,
                  onFieldSubmitted: () {
                    focus1.requestFocus();
                  },
                  onTab: () {
                    focus.requestFocus();
                  },
                  validator: (String value) {
                    if (value.length < 3) {
                      return "?????? ???????? ???? 3 ????????";
                    }
                    return auth.regValidationMap['name'];
                  }),
              TextFormInput(
                  text: "????????????",
                  cController: mobileNoController,
                  prefixIcon: Icons.phone,
                  kt: TextInputType.phone,
                  readOnly: false,
                  onTab: () {
                    focus1.requestFocus();
                  },
                  onFieldSubmitted: () {
                    focus2.requestFocus();
                  },
                  obscureText: _obscureText,
                  focusNode: focus1,
                  validator: (String value) {
                    if (mobileNoController.text.length < 6) {
                      return "???????? ?????? ???????? ????????";
                    }
                    return auth.regValidationMap['mobile'];
                  }),
              TextFormInput(
                  text: "???????????? ????????????????????",
                  cController: emailController,
                  prefixIcon: Icons.mail_outline,
                  kt: TextInputType.emailAddress,
                  obscureText: false,
                  readOnly: false,
                  focusNode: focus2,
                  onTab: () {
                    focus2.requestFocus();
                  },
                  onFieldSubmitted: () {
                    focus3.requestFocus();
                  },
                  validator: (String value) {
                    if (value.isEmpty) {
                      return "???????? ?????????? ???????? ???? ????????";
                    }
                    return auth.regValidationMap['email'];
                  }),
              TextFormInput(
                  text: "???????? ????????????",
                  cController: passwordController,
                  prefixIcon: Icons.lock_outline,
                  kt: TextInputType.visiblePassword,
                  readOnly: false,
                  onTab: () {},
                  onFieldSubmitted: () {
                    focus4.requestFocus();
                  },
                  suffixicon: IconButton(
                    icon: Icon(
                      (_obscureText == false)
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: colors.blue,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  ),
                  obscureText: _obscureText,
                  focusNode: focus3,
                  validator: (String value) {
                    if (passwordController.text.length < 6) {
                      return "???????? ???????????? ?????? ???? ???????? ???????? ???? 6 ????????";
                    }
                    return auth.regValidationMap['password'];
                  }),
              TextFormInput(
                  text: "???????? ????????????",
                  cController: config.locationController,
                  prefixIcon: Icons.my_location,
                  kt: TextInputType.visiblePassword,
                  readOnly: true,
                  onTab: () async {
                    try {
                      mainProvider.togelocationloading(true);
                      if (await updateLocation) {
                        await getLocationName();
                        mainProvider.togelocationloading(false);
                      } else {
                        Vibration.vibrate(duration: 400);
                        mainProvider.togelocationloading(false);

                        Scaffold.of(context).showSnackBar(snackBar);
                        setState(() {
                          config.locationController.text = "???????? ???????????? ????????????";
                        });
                      }
                    } catch (e) {
                      Vibration.vibrate(duration: 400);
                      mainProvider.togelocationloading(false);
                      Scaffold.of(context).showSnackBar(snackBar);
                      setState(() {
                        config.locationController.text = "???????? ???????????? ????????????";
                      });
                    }
                  },
                  suffixicon: IconButton(
                    icon: const Icon(Icons.add_location, color: Colors.blue),
                    onPressed: () {
                      Navigator.pushNamed(context, '/AutoLocate',
                          arguments: <String, double>{
                            "lat": 51.0,
                            "long": 9.6,
                            "choice": 0
                          });
                    },
                  ),
                  obscureText: false,
                  focusNode: focus4,
                  validator: (String value) {
                    if (value.isEmpty) {
                      return "?????? ?????????????? ???? ????????";
                    }
                    return auth.regValidationMap['location'];
                  }),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: mainProvider.visibilityObs
                    ? Row(
                        children: <Widget>[
                          Expanded(
                            child: spinkit,
                          ),
                        ],
                      )
                    : Container(),
              )
            ])));
  }

  @override
  Widget build(BuildContext context) {
    final MainProvider mainProvider = Provider.of<MainProvider>(context);
    return Scaffold(
        appBar: AppBar(),
        body: Builder(
          builder: (BuildContext context) => GestureDetector(
            onTap: () {
              SystemChannels.textInput.invokeMethod<String>('TextInput.hide');
            },
            child: Consumer<Auth>(
                builder: (BuildContext context, Auth auth, Widget child) {
              return ListView(
                children: <Widget>[
                  const SizedBox(height: 16),
                  Text("?????????? ????????",
                      textAlign: TextAlign.center, style: styles.mystyle2),
                  const SizedBox(height: 8),
                  Text("???????? ???? ????????",
                      textAlign: TextAlign.center, style: styles.pleazeCheck),
                  customcard(context, mainProvider, auth),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 16),
                    child: RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: BorderSide(color: colors.blue)),
                        onPressed: () async {
                          if (_isButtonEnabled) {
                            if (_formKey.currentState.validate()) {
                              mainProvider.togelf(true);
                              setState(() {
                                _isButtonEnabled = false;
                              });
                              await auth.register(
                                context,
                                usernameController.text,
                                passwordController.text,
                                emailController.text,
                                mobileNoController.text,
                              );

                              _formKey.currentState.validate();

                              auth.regValidationMap
                                  .updateAll((String key, String value) {
                                return null;
                              });
                              Navigator.popAndPushNamed(context, "/login");
                            }
                            mainProvider.togelf(false);
                            setState(() {
                              _isButtonEnabled = true;
                            });
                          }
                        },
                        color: colors.blue,
                        textColor: colors.white,
                        child: mainProvider.returnchild("??????????")),
                  ),
                  const Padding(
                      padding: EdgeInsets.fromLTRB(30, 0, 30, 10),
                      child: Divider(color: Colors.black)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Flexible(
                        child: Text(
                          "?????????? ???? ?????????? ????????????",
                          style: styles.mystyle,
                        ),
                      ),
                      ButtonToUse(
                        "?????????? ??????????",
                        fontWait: FontWeight.bold,
                        fontColors: Colors.green,
                      ),
                    ],
                  ),
                ],
              );
            }),
          ),
        ));
  }
}
