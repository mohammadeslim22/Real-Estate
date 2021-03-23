class Property {
  int id;
  int userId;
  String type;
  int rooms;
  double price;
  int furniture;
  String dateAdded;
  double longitude;
  double latitude;
  List<PropertyImage> images;

  Property(this.userId, this.type, this.rooms, this.price, this.furniture,
      this.dateAdded, this.longitude, this.latitude, this.images);

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map['p_id'] = id;
    }

    map['user_id'] = userId;
    map['type'] = type;
    map['rooms'] = rooms;
    map["price"] = price;
    map["furniture"] = furniture;
    map['date_added'] = dateAdded;
    map['longitude'] = longitude;
    map['latitude'] = latitude;
    return map;
  }

  Property.fromMapObject(dynamic map) {
    this.id = map['p_id'];
    this.userId = map['user_id'];
    this.type = map['type'];
    this.rooms = map['rooms'];
    this.price = map["price"];
    this.furniture = map["furniture"];
    this.dateAdded = map['date_added'];
    this.longitude = double.parse(map['longitude'].toString());
    this.latitude = double.parse(map['latitude'].toString());
  }
}

class PropertyImage {
  int id;
  String image;

  PropertyImage(this.id, this.image);

  PropertyImage.fromMap(Map map) {
    id = map[id];
    image = map[image];
  }
}
