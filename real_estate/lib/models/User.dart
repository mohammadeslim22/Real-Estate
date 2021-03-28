import 'package:encrypt/encrypt.dart';

class User {
  int id;
  String email;
  String name;
  String phones;
  String password;
  double longitude;
  double latitude;

  User(this.email, this.name, this.phones, this.password, this.longitude,
      this.latitude);

  User.withId(this.id, this.email, [this.phones]);

  int get idd => id;

  String get emaill => email;

  String get description => phones;
  final key = Key.fromUtf8('put32charactershereeeeeeeeeeeee!'); //32 chars
  final iv = IV.fromUtf8('put16characters!');
  set setemail(String newemail) {
    if (newemail.length <= 255) {
      this.email = newemail;
    }
  }

  set phone(String newDescription) {
    if (newDescription.length <= 255) {
      this.phones = newDescription;
    }
  }

  String encryptMyData(String text) {
    final e = Encrypter(AES(key, mode: AESMode.cbc));
    final encrypted_data = e.encrypt(text, iv: iv);
    return encrypted_data.base64;
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map['user_id'] = id;
    }
    map['email'] = email;
    map['name'] = name;
    map['phones'] = phones;
    map['password'] = encryptMyData(password);
    map['longitude'] = longitude;
    map['latitude'] = latitude;
    return map;
  }

  // Extract a Note object from a Map object
  User.fromMapObject(dynamic map) {
    this.id = map['user_id'];
    this.email = map['email'];
    this.name = map['name'];
    this.phones = map['phones'];
    this.password = map['password'];
    this.longitude = double.parse(map['longitude'].toString());
    this.latitude = double.parse(map['latitude'].toString());
  }
}
