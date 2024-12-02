import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../model/groupModel.dart';
import '../model/songsModel.dart';

bool isSuccess = false;

class DBSongs {
  static final DBSongs instance = DBSongs._init();
  static Database? _database;

  DBSongs._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('songs.db');
    print("SUCCESSED initDB");
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();

    final path = join(dbPath, filePath);
    return await openDatabase(path,
        version: 2, onCreate: _createDB, onUpgrade: _updateDB);
  }

  Future _createDB(Database db, int version) async {
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final textType = 'TEXT';
    final intType = 'INTEGER';
    await db.execute('''
    CREATE TABLE $tableSongs (
    ${Songs.id} $idType,
    ${Songs.name_song} $textType,
    ${Songs.name_singer} $textType,
    ${Songs.song} $textType,
    ${Songs.path_music} $textType,
    ${Songs.date_created} $textType
    )
    ''');
  }

  // Future _updateDB(Database db, int oldVersion, int newVersion) async {
  //   if (oldVersion < 2) {
  // await db.execute(
  //     'ALTER TABLE $tableSongs ADD COLUMN `${Songs.order}` INTEGER DEFAULT 0');
  //   }
  Future _updateDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute(
          'ALTER TABLE $tableSongs ADD COLUMN `${Songs.order}` INTEGER DEFAULT 0');
      await db.execute(
          'ALTER TABLE $tableSongs ADD COLUMN `${Songs.group}` INTEGER DEFAULT 0');
      await db.execute('''
      CREATE TABLE $tableGroups (
        ${Groups.id} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${Groups.name} TEXT NOT NULL
      )
    ''');
    }
  }

  Future<Song> create(Song song) async {
    final db = await instance.database;
    // final json = note.toJson();
// final columns = '${NoteFields.title}, ${NoteFields.content}, ${NoteFields.date_created}, ${NoteFields.note_color}';
// final values = '${json[NoteFields.title]}, ${json[NoteFields.content]}, ${json[NoteFields.date_created]}, ${json[NoteFields.note_color]}';
// final id = await db.rawInsert('insert into $tableSongs ($columns) values ($values)');
    final id = await db.insert(tableSongs, song.toJson());
    print("!!! Successed create id = ${id} !!!");
    isSuccess = true;
    return song.copy(id: id);
  }

  Future<Song> readSong(int id) async {
    final db = await instance.database;
    final maps = await db.query(tableSongs,
        columns: Songs.values, where: '${Songs.id} = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return Song.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<Song>> readAllSongs() async {
    final db = await instance.database;
    final orderBy = '`${Songs.id}` DESC';
    // final result = await db.rawQuery('select * from $tableSongs order by $orderBy');
    final result = await db.query(tableSongs, orderBy: orderBy);
    print("Reading all songs");
    return result.map((json) => Song.fromJson(json)).toList();
  }

  Future<int> update(Song song) async {
    final db = await instance.database;
    print("!!! Successed update id = ${song.id} !!!");
    return await db.update(tableSongs, song.toJson(),
        where: '${Songs.id} = ?', whereArgs: [song.id]);
  }

  Future<int> delete(int id) async {
    final db = await instance.database;
    print("!!! Successed delete id = ${id} !!!");
    return await db
        .delete(tableSongs, where: '${Songs.id} = ?', whereArgs: [id]);
  }

  Future<int> deleteAll() async {
    final db = await instance.database;
    print("!!! Deleting all records from $tableSongs !!!");

    return await db.delete(tableSongs);
  }

  Future<GroupModel> createGroup(GroupModel group) async {
    final db = await instance.database;

    final id = await db.insert(tableGroups, group.toJson());
    print("!!! Successed create group id = ${id} !!!");
    return group.copy(id: id);
  }

  Future<List<GroupModel>> readAllGroups() async {
    final db = await instance.database;

    final result = await db.query(
      tableGroups,
      orderBy: '`${Groups.id}` DESC',
    );
    print("Reading all groups");
    return result.map((json) => GroupModel.fromJson(json)).toList();
  }

  Future<int> updateGroup(GroupModel group) async {
    final db = await instance.database;

    print("!!! Successed update group id = ${group.id} !!!");
    return await db.update(tableGroups, group.toJson(),
        where: '${Groups.id} = ?', whereArgs: [group.id]);
  }

  Future<int> deleteGroup(int id) async {
    final db = await instance.database;

    // Удаляем все песни, связанные с этой группой
    await db.update(tableSongs, {'${Songs.group}': 0, '${Songs.order}': 0},
        where: '`${Songs.group}` = ?', whereArgs: [id]);

    print("!!! Successed delete group id = ${id} !!!");
    return await db
        .delete(tableGroups, where: '${Groups.id} = ?', whereArgs: [id]);
  }

  Future<List<Song>> readSongsByGroup(int groupId) async {
    final db = await instance.database;

    final result = await db.query(
      tableSongs,
      where: '`${Songs.group}` = ?',
      whereArgs: [groupId],
      orderBy: '`${Songs.order}` ASC',
    );

    print("Reading songs for group $groupId");
    return result.map((json) => Song.fromJson(json)).toList();
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
