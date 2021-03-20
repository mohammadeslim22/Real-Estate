// import 'package:database_create_error/joinobject.dart';
// import 'package:sqflite/sqflite.dart';

// import 'DBhelper.dart';

// class BackendService {
//   static DBHelper helper = DBHelper();
//  // static Database  dbClient =  helper.initDatabase();
//   static Future<List<JoinObject>>  getPosts(offset, limit) async {
//      //   print("from inside the get method ///@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@//////////////////////////////////////////////");

//      return helper.getJoinDatapaging(offset, limit);
//     // var result = await dbClient.rawQuery(
//     //     'SELECT * FROM Notes,Users where Notes.note_id =Users.user_id AND Users.user_id > $offset AND Users.user_id < $limit order by user_id ASC');
//     // List<Map> maps = result;
//     // List<JoinObject> joinobjs = [];

//     // if (maps.length > 0) {
//     //   for (int i = 0; i < maps.length; i++) {
//     //     joinobjs.add(JoinObject.fromMapObject(maps[i]));
//     //     JoinObject.fromMapObject(maps[i]).toString();
//     //   }
//     // }
//     // return joinobjs;
//   }
//   static Future<List<JoinObject>>  getSearchDatapaging(offset) async {
//       return helper.getSearchDatapaging(offset);

//   }
// }
