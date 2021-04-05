class Property {
  int id;
  int userId;
  String state;
  String type;
  int rooms;
  int price;
  int furniture;
  String dateAdded;
  double longitude;
  double latitude;
  List<PropertyImage> images;
  String description;

  Property(
      this.userId,
      this.state,
      this.type,
      this.rooms,
      this.price,
      this.furniture,
      this.dateAdded,
      this.longitude,
      this.latitude,
      this.images,
      this.description);

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map['p_id'] = id;
    }

    map['user_id'] = userId;
    map['state'] = state;
    map['type'] = type;
    map['rooms'] = rooms;
    map["price"] = price;
    map["furniture"] = furniture;
    map['date_added'] = dateAdded;
    map['longitude'] = longitude;
    map['latitude'] = latitude;
    map["description"] = description;
    return map;
  }

  Property.fromMapObject(dynamic map) {
    this.id = map['p_id'];
    this.userId = map['user_id'];
    this.state = map['state'];
    this.type = map['type'];
    this.rooms = map['rooms'];
    this.price = int.parse(map["price"].toString());
    this.furniture = map["furniture"];
    this.dateAdded = map['date_added'];
    this.longitude = double.parse(map['longitude'].toString());
    this.latitude = double.parse(map['latitude'].toString());
    this.description = map["description"];
  }
}

class PropertyImage {
  int id;
  int pId;
  String image;

  PropertyImage(this.pId, this.image);
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map['i_id'] = id;
    }
    map["p_id"] = pId;
    map['image'] = image;

    return map;
  }

  PropertyImage.fromMap(Map map) {
    id = map["id"];
    pId = map["p_id"];
    image = map["image"];
  }
}
