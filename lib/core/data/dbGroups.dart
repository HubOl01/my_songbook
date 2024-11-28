import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../model/groupModel.dart';

bool isSuccess = false;

class DBGroups {
  static final DBGroups instance = DBGroups._init();
  static Database? _database;

  DBGroups._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('songs.db');
    print("SUCCESSED initDB");
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();

    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final textType = 'TEXT';
    await db.execute('''
    CREATE TABLE $tableGroups (
    ${Groups.id} $idType,
    ${Groups.name} $textType
    )
    ''');
  }

  Future<GroupModel> create(GroupModel model) async {
    final db = await instance.database;
    // final json = note.toJson();
// final columns = '${NoteFields.title}, ${NoteFields.content}, ${NoteFields.date_created}, ${NoteFields.note_color}';
// final values = '${json[NoteFields.title]}, ${json[NoteFields.content]}, ${json[NoteFields.date_created]}, ${json[NoteFields.note_color]}';
// final id = await db.rawInsert('insert into $tableSongs ($columns) values ($values)');
    final id = await db.insert(tableGroups, model.toJson());
    print("!!! Successed create id = ${id} !!!");
    isSuccess = true;
    return model.copy(id: id);
  }

  Future<GroupModel> readSong(int id) async {
    final db = await instance.database;
    final maps = await db.query(tableGroups,
        columns: Groups.values, where: '${Groups.id} = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return GroupModel.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<GroupModel>> readAllSongs() async {
    final db = await instance.database;
    // final orderBy = '${Groups.id} DESC';
    // final result = await db.rawQuery('select * from $tableSongs order by $orderBy');
    final result = await db.query(tableGroups);
    print("Reading all songs");
    return result.map((json) => GroupModel.fromJson(json)).toList();
  }

  Future<int> update(GroupModel model) async {
    final db = await instance.database;
    print("!!! Successed update id = ${model.id} !!!");
    return await db.update(tableGroups, model.toJson(),
        where: '${Groups.id} = ?', whereArgs: [model.id]);
  }

  Future<int> delete(int id) async {
    final db = await instance.database;
    print("!!! Successed delete id = ${id} !!!");
    return await db
        .delete(tableGroups, where: '${Groups.id} = ?', whereArgs: [id]);
  }

  Future<int> deleteAll() async {
    final db = await instance.database;
    print("!!! Deleting all records from $tableGroups !!!");

    return await db.delete(tableGroups);
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
