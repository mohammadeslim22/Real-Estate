import 'package:real_estate/constants/config.dart';
import 'package:real_estate/helpers/data.dart';
import 'package:real_estate/models/User.dart';
import 'package:real_estate/models/property.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DBHelper {
  static Database _db;
  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDatabase();
    return _db;
  }

  Future<dynamic> initDatabase() async {
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, 'real_estate.db');
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    print("DB Created *****************************");
    // await db.execute('CREATE TABLE Notes (note_id INTEGER PRIMARY KEY AUTOINCREMENT, user_id INTEGER, description TEXT)');
    await db.execute(
        'CREATE TABLE Users (user_id INTEGER PRIMARY KEY AUTOINCREMENT, email TEXT,name TEXT ,phones TEXT,password TEXT, longitude TEXT, latitude TEXT)');
    await db.execute(
        'CREATE TABLE Properties (p_id INTEGER PRIMARY KEY AUTOINCREMENT,user_id INTEGER , type TEXT,longitude TEXT, latitude TEXT,rooms INTEGER, price TEXT, term TEXT, date_added TEXT,furniture INTEGER, description TEXT )');
    await db.execute(
        'CREATE TABLE Searches (s_id INTEGER PRIMARY KEY AUTOINCREMENT,user_id INTEGER search_string TEXT)');
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
    var dbClient = await db;
    var result = await dbClient.rawQuery(
        'Select * from Users Where Users.phones = "$phone" AND Users.password = "$pass"');
    if (result.isEmpty) {
      return false;
    } else {
      User u = User.fromMapObject(result[0]);
      config.userId = u.id;
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
