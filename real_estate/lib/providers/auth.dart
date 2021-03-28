import 'dart:async';
import 'package:flutter/material.dart';
import 'package:real_estate/constants/config.dart';
import 'package:real_estate/data_base/DBhelper.dart';
import 'package:real_estate/helpers/data.dart';
import 'package:real_estate/models/User.dart';
import 'package:real_estate/services/navigationService.dart';
import 'package:real_estate/helpers/service_locator.dart';
import 'package:country_provider/country_provider.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

class Auth with ChangeNotifier {
  DBHelper databaseHelper = DBHelper();

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

  final key =
      encrypt.Key.fromUtf8('put32charactershereeeeeeeeeeeee!'); //32 chars
  final iv = encrypt.IV.fromUtf8('put16characters!');
  String encryptMyData(String text) {
    final e = encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));
    final encrypted_data = e.encrypt(text, iv: iv);
    return encrypted_data.base64;
  }

  Future<bool> login(String phone, String pass, BuildContext context) async {
    // String password = encryptMyData(pass);
    bool login = await databaseHelper.readUser(phone, pass);
    print(phone);
    print("login  $login");
    return login;
  }

  Future<void> register(
    BuildContext context,
    String username,
    String pass,
    String email,
    String mobile,
  ) async {
    print("user is trying to register here $username  $pass  $email  $mobile");
    await databaseHelper
        .adduser(User(email, username, mobile, pass, config.long, config.lat));
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
    config.loggedin = false;
    await data.setData("loggedin", "false");
    getIt<NavigationService>().navigateTo('/login', null);
  }
}
