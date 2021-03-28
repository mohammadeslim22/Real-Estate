import 'package:real_estate/constants/config.dart';
import 'package:real_estate/helpers/data.dart';
import 'package:real_estate/models/User.dart';
import 'package:real_estate/models/property.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:encrypt/encrypt.dart';

class DBHelper {
  static Database _db;
  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDatabase();
    return _db;
  }

  final key = Key.fromUtf8('put32charactershereeeeeeeeeeeee!'); //32 chars
  final iv = IV.fromUtf8('put16characters!');
  Future<dynamic> initDatabase() async {
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, 'real_estate.db');
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  String encryptMyData(String text) {
    final e = Encrypter(AES(key, mode: AESMode.cbc));
    final encrypted_data = e.encrypt(text, iv: iv);
    return encrypted_data.base64;
  }

  _onCreate(Database db, int version) async {
    print("DB Created *****************************");
    // await db.execute('CREATE TABLE Notes (note_id INTEGER PRIMARY KEY AUTOINCREMENT, user_id INTEGER, description TEXT)');
    await db.execute(
        'CREATE TABLE Users (user_id INTEGER PRIMARY KEY AUTOINCREMENT, email TEXT,name TEXT ,phones TEXT,password TEXT, longitude TEXT, latitude TEXT)');
    await db.execute(
        'CREATE TABLE Properties (p_id INTEGER PRIMARY KEY AUTOINCREMENT,user_id INTEGER, state Text, type TEXT,longitude TEXT, latitude TEXT,rooms INTEGER, price INTEGER, term TEXT, date_added TEXT,furniture INTEGER, description TEXT)');
    await db.execute(
        'CREATE TABLE Searches (s_id INTEGER PRIMARY KEY AUTOINCREMENT,user_id INTEGER, search_string TEXT)');
    await db.execute(
        'CREATE TABLE favs (f_id INTEGER PRIMARY KEY AUTOINCREMENT,user_id INTEGER ,p_id INTEGER)');
    await db.execute(
        'CREATE TABLE Images (i_id INTEGER PRIMARY KEY AUTOINCREMENT,p_id INTEGER, image TEXT)');
  }

  // Future<Note> addNote(Note note) async {
  //   var dbClient = await db;
  //   await dbClient.insert('Notes', note.toMap());
  //   return note;
  // }

  Future<void> addSearch(String search) async {
    var dbClient = await db;
    await dbClient.rawInsert(
        'INSERT INTO Searches(user_id, search_string) VALUES("${config.userId}", "$search")');
  }

  Future<List<String>> readSearches() async {
    var dbClient = await db;
    var result = await dbClient.rawQuery('Select * from Searches');
    List<Map> maps = result;
    List<String> searches = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        searches.add(maps[i]["search_string"].toString().trim());
      }
    }
    return searches;
  }

  Future<User> adduser(User user) async {
    var dbClient = await db;
    int addUser = await dbClient.insert('Users', user.toMap());
    print("ADDED USER CORRECTLY ? $addUser");
    return user;
  }

  Future<List<User>> readAllUsers() async {
    var dbClient = await db;
    var result = await dbClient.rawQuery('Select * from Users');
    List<Map> maps = result;
    List<User> users = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        users.add(User.fromMapObject(maps[i]));
      }
    } else {
      print("no users -------------------empty");
    }
    return users;
  }

  Future<bool> readUser(String phone, String pass) async {
    // String password = encryptMyData(pass);
    var dbClient = await db;
    var result = await dbClient.rawQuery(
        'Select * from Users Where Users.phones = "$phone" AND Users.password = "$pass"');
    if (result.isEmpty) {
      return false;
    } else {
      User u = User.fromMapObject(result[0]);
      config.userId = u.id;
      print("config.userId ${config.userId}");
      await data.setData("user_id", u.id.toString());
      await data.setData("user_name", u.name.toString());
      await data.setData("loggedin", "true");
      print(result);
      return true;
    }
  }

  Future<int> addProp(Property p) async {
    var dbClient = await db;
    await dbClient.insert('Properties', p.toMap());
    List<Map> maxId =
        await dbClient.rawQuery("Select MAX(p_id) from Properties");
    int lastPropId = maxId[0]["MAX(p_id)"];
    return lastPropId;
  }

  Future<List<Property>> readMyProperties(int userId) async {
    var dbClient = await db;
    var result = await dbClient
        .rawQuery('Select * from Properties where user_id ="$userId"');
    List<Map> maps = result;
    print(result);
    var result2 = await dbClient.rawQuery(
        'Select * from Properties where (price BETWEEN 2000 AND 70000 )AND (rooms BETWEEN 1 AND 10) AND type ="شقة"  AND furniture=1');
    print(result2);
    List<Property> properties = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        properties.add(Property.fromMapObject(maps[i]));
      }
    }

    // List<Map> iMaps = result;
    properties.forEach((Property p) async {
      List<PropertyImage> pImages = [];
      List<Map> iMaps =
          await dbClient.rawQuery('Select * from Images where p_id ="${p.id}"');
      if (iMaps.length > 0) {
        for (int i = 0; i < iMaps.length; i++) {
          pImages.add(PropertyImage.fromMap(iMaps[i]));
        }
      }
      p.images = pImages;
    });

    return properties;
  }

  Future<bool> addImage(PropertyImage pI) async {
    var dbClient = await db;
    int addImage = await dbClient.insert('Images', pI.toMap());
    print("addImage addImage CORRECTLY ? $addImage");
    return addImage == 1;
  }

  Future<void> addFav(int pId) async {
    var dbClient = await db;
    await dbClient.rawInsert(
        'INSERT INTO favs(user_id, p_id) VALUES("${config.userId}", "$pId")');
  }

  Future<List<Property>> readFavs() async {
    var dbClient = await db;
    // List<Map> favPids = await dbClient
    //     .rawQuery('select p_id from favs where user_id ="${config.userId}"');
    // List<int> pIds = [];
    // print(favPids);
    // if (favPids.length > 0) {
    //   for (int i = 0; i < favPids.length; i++) {
    //     pIds.add(favPids[i]["p_id"] as int);
    //   }
    // }
    var result = await dbClient.rawQuery(
        'Select * from Properties where user_id ="${config.userId}" AND p_id in (select p_id from favs where user_id ="${config.userId}")');
    List<Map> maps = result;
    List<Property> favs = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        favs.add(Property.fromMapObject(maps[i]));
      }
    }
    favs.forEach((Property p) async {
      List<PropertyImage> pImages = [];
      List<Map> iMaps =
          await dbClient.rawQuery('Select * from Images where p_id ="${p.id}"');
      if (iMaps.length > 0) {
        for (int i = 0; i < iMaps.length; i++) {
          pImages.add(PropertyImage.fromMap(iMaps[i]));
        }
      }
      p.images = pImages;
    });
    return favs;
  }

  Future<List<Property>> searchProps(
      String state,
      int firstPrice,
      int secondprice,
      String timeAdded,
      String type,
      int roomMin,
      int roomMax,
      int furn) async {
    var dbClient = await db;
    print(
        'Select * from Properties where state ="$state" AND (price BETWEEN $firstPrice AND $secondprice) AND (rooms BETWEEN $roomMin AND $roomMax ) AND type ="$type" AND furniture = $furn');
    List<Map> sMap = await dbClient.rawQuery(
        'Select * from Properties where state ="$state" AND (price BETWEEN $firstPrice AND $secondprice) AND (rooms BETWEEN $roomMin AND $roomMax ) AND type ="$type" AND furniture = $furn');
    List<Property> searchRes = [];
    print("search map $sMap");
    if (sMap.length > 0) {
      for (int i = 0; i < sMap.length; i++) {
        searchRes.add(Property.fromMapObject(sMap[i]));
      }
    }
    searchRes.forEach((Property p) async {
      List<PropertyImage> pImages = [];
      List<Map> iMaps =
          await dbClient.rawQuery('Select * from Images where p_id ="${p.id}"');
      if (iMaps.length > 0) {
        for (int i = 0; i < iMaps.length; i++) {
          pImages.add(PropertyImage.fromMap(iMaps[i]));
        }
      }
      p.images = pImages;
    });
    return searchRes;
  }
  // Future<List<JoinObject>> getJoinData() async {
  //   var dbClient = await db;
  //   var result = await dbClient.rawQuery(
  //       'SELECT * FROM Notes,Users where Notes.note_id =Users.user_id order by user_id ASC');
  //   List<Map> maps = result;
  //   List<JoinObject> joinobjs = [];

  //   if (maps.length > 0) {
  //     for (int i = 0; i < maps.length; i++) {
  //       joinobjs.add(JoinObject.fromMapObject(maps[i]));
  //     }
  //   }
  //   return joinobjs;
  // }

  //   Future<List<JoinObject>> getJoinDatapaging(int offset, int limit) async {
  //   var dbClient = await db;
  //   var result = await dbClient.rawQuery(
  //    // 'SELECT * FROM Notes,Users where Notes.note_id =Users.user_id order by user_id ASC');
  //        'SELECT * FROM Notes,Users where Notes.note_id =Users.user_id order by user_id ASC LIMIT $offset, $limit');
  //   List<Map> maps = result;
  //   List<JoinObject> joinobjs = [];
  //         //  print("from inside the get method ///@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@//////////////////////////////////////////////");
  //     print(maps.isEmpty);
  //   if (maps.length > 0) {
  //     for (int i = 0; i < maps.length; i++) {
  //       joinobjs.add(JoinObject.fromMapObject(maps[i]));
  //           print("from inside the get method  ///@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@//////////////////////////////////////////////"+JoinObject.fromMapObject(maps[i]).toString());

  //     }
  //   }
  //   return joinobjs;
  // }
  //     Future<List<JoinObject>> getSearchDatapaging(String phone) async {
  //   var dbClient = await db;
  //   var result = await dbClient.rawQuery(
  //        'SELECT * FROM Notes,Users where Notes.note_id =Users.user_id AND Users.phones Like %$phone% order by user_id ASC');
  //   List<Map> maps = result;
  //   List<JoinObject> joinobjs = [];
  //         //  print("from inside the get method ///@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@//////////////////////////////////////////////");
  //     print(maps.isEmpty);
  //   if (maps.length > 0) {
  //     for (int i = 0; i < maps.length; i++) {
  //       joinobjs.add(JoinObject.fromMapObject(maps[i]));
  //           print("from inside the get method  ///@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@//////////////////////////////////////////////"+JoinObject.fromMapObject(maps[i]).toString());

  //     }
  //   }
  //   return joinobjs;
  // }

  Future<int> delete(int id) async {
    var dbClient = await db;
    return await dbClient.delete(
      'student',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }
}
