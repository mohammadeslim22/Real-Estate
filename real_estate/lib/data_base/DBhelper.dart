import 'package:real_estate/models/User.dart';
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

  initDatabase() async {
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, 'real_estate.db');
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    // await db.execute('CREATE TABLE Notes (note_id INTEGER PRIMARY KEY AUTOINCREMENT, user_id INTEGER, description TEXT)');
    await db.execute(
        'CREATE TABLE Users (user_id INTEGER PRIMARY KEY AUTOINCREMENT, email TEXT,name TEXT ,phones TEXT,password TEXT, longitude TEXT, latitude TEXT)');
  }

  // Future<Note> addNote(Note note) async {
  //   var dbClient = await db;
  //   await dbClient.insert('Notes', note.toMap());
  //   return note;
  // }
  Future<User> adduser(User user) async {
    var dbClient = await db;
    await dbClient.insert('Users', user.toMap());
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
    }
    return users;
  }

  Future<bool> readUser(String phone, String pass) async {
    var dbClient = await db;
    var result = await dbClient.rawQuery(
        'Select * from Users Where phones= $phone AND password= $pass');
    if (result.isEmpty) {
      return false;
    } else {
      print(result);
      return true;
    }
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
