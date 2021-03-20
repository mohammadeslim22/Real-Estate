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

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map['userid'] = id;
    }
    map['email'] = email;
    map['name'] = name;
    map['phones'] = phones;
    map['password'] = password;
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
