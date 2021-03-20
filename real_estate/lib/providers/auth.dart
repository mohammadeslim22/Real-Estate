import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:real_estate/constants/colors.dart';
import 'package:real_estate/constants/styles.dart';
import 'package:real_estate/helpers/data.dart';
import 'package:real_estate/providers/mainprovider.dart';
import 'package:real_estate/services/navigationService.dart';
import 'package:real_estate/helpers/service_locator.dart';
import 'package:country_provider/country_provider.dart';

class Auth with ChangeNotifier {
  Auth() {
    // TODO(ahmed): do login by dio library
  }
  String myCountryCode;
  String myCountryDialCode;
  String dialCodeFav;
  String errorMessage;
  static List<String> validators = <String>[null, null];
  static List<String> keys = <String>[
    'phone',
    'password',
  ];
  static List<String> registervalidators = <String>[
    null,
    null,
    null,
    null,
    null,
    null
  ];
  static List<String> regkeys = <String>[
    'name',
    'email',
    'phone',
    'password',
    'birthdate',
    'location'
  ];
  Map<String, String> regValidationMap =
      Map<String, String>.fromIterables(regkeys, registervalidators);
  Map<String, String> loginValidationMap =
      Map<String, String>.fromIterables(keys, validators);
  static List<String> profileValidators = <String>[
    null,
    null,
    null,
    null,
    null,
    null
  ];
  static List<String> profilekeys = <String>[
    'name',
    'email',
    'phone',
    'password',
    'birthdate',
    'location'
  ];
  Map<String, String> profileValidationMap =
      Map<String, String>.fromIterables(profilekeys, profileValidators);

  static List<String> pinCodeProfileValidators = <String>[null, null];
  static List<String> pinCodeProfilekeys = <String>[
    'phone',
    'password',
  ];
  Map<String, String> pinCodeProfileValidationMap =
      Map<String, String>.fromIterables(
          pinCodeProfilekeys, pinCodeProfileValidators);

  static List<String> changePassValidators = <String>[null, null];
  static List<String> changePasskeys = <String>['old_passwoed', 'new_password'];
  Map<String, String> changePassValidationMap =
      Map<String, String>.fromIterables(changePasskeys, changePassValidators);

  static List<String> forgetPassValidators = <String>[null];
  static List<String> forgetPasskeys = <String>[
    'phone',
  ];
  Map<String, String> forgetPassValidationMap =
      Map<String, String>.fromIterables(forgetPasskeys, forgetPassValidators);
  static List<String> resetPassValidators = <String>[null];
  static List<String> resetPasskeys = <String>[
    'password',
  ];
  Map<String, String> resetPassValidationMap =
      Map<String, String>.fromIterables(resetPasskeys, resetPassValidators);
  Future<void> getCountry(String countryCode) async {
    final Country result = await CountryProvider.getCountryByCode(countryCode);
    myCountryDialCode = result.callingCodes.first;
    print("numricCode:    ${result.callingCodes}");
  }

  void saveCountryCode(String code, String dialCode) {
    myCountryCode = code;
    myCountryDialCode = dialCode;
    data.setData("countryCodeTemp", code);
    data.setData("countryDialCodeTemp", dialCode);
    notifyListeners();
  }

  Future<bool> login(String username, String pass, BuildContext context) async {

  }

  Future<bool> register(
    BuildContext context,
    MainProvider mainProv,
    String username,
    String pass,
    String birth,
    String email,
    String mobile,
  ) async {

  }

  Map<String, dynamic> user;
  StreamSubscription<dynamic> userAuthSub;

  @override
  void dispose() {
    if (userAuthSub != null) {
      userAuthSub.cancel();
      userAuthSub = null;
    }
    super.dispose();
  }

  bool get isAuthenticated {
    return user != null;
  }

  void signInAnonymously() {}

  Future<void> signOut() async {
    await data.setData('authorization', null);  
    getIt<NavigationService>().navigateTo('/login', null);
  }

}
