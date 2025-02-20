import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../model/groupModel.dart';
import '../model/songTogroupModel.dart';
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

    final db = await openDatabase(path,
        version: 4, onCreate: _createDB, onUpgrade: _updateDB);

    final version = await db.getVersion();
    print("Current database version: $version");

    return db;
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT';
    const intType = 'INTEGER DEFAULT 0';
    const realType = 'REAL DEFAULT 14.0';

    // Создаем таблицу песен
    await db.execute('''
     CREATE TABLE IF NOT EXISTS $tableSongs (
        ${Songs.id} $idType,
        ${Songs.name_song} $textType,
        ${Songs.name_singer} $textType,
        ${Songs.song} $textType,
        ${Songs.path_music} $textType,
        ${Songs.speedScroll} INTEGER DEFAULT 150,
        ${Songs.fontSizeText} $realType,
        ${Songs.tonalitySongText} $textType DEFAULT "",
        ${Songs.tempoSongText} $textType DEFAULT "",
        ${Songs.comment} $textType DEFAULT "",
        ${Songs.order} $int,
        ${Songs.group} $int,
        ${Songs.date_created} $textType
      )
    ''');
    // Убедимся, что столбцы order и group существуют
    final columns = await db.rawQuery('PRAGMA table_info($tableSongs)');
    final columnNames = columns.map((column) => column['name']).toList();

    if (!columnNames.contains(Songs.order)) {
      await db.execute(
          'ALTER TABLE $tableSongs ADD COLUMN ${Songs.order} $intType');
    }

    if (!columnNames.contains(Songs.group)) {
      await db.execute(
          'ALTER TABLE $tableSongs ADD COLUMN ${Songs.group} $intType');
    }

    // Создаем таблицу групп, если она не существует
    await db.execute('''
  CREATE TABLE IF NOT EXISTS $tableGroups (
    ${Groups.id} $idType,
    ${Groups.name} $textType NOT NULL UNIQUE,
    ${Groups.colorBackground} $textType DEFAULT "#8C5AFF",
    ${Groups.colorForeground} $textType DEFAULT "#8C5AFF",
    ${Groups.orderId} $intType DEFAULT -1
  )
''');

    await db.execute('''
      CREATE TABLE $tableSongToGroups (
        group_id INTEGER NOT NULL,
        song_id INTEGER NOT NULL,
        song_order INTEGER DEFAULT 0,
        PRIMARY KEY (group_id, song_id),
        FOREIGN KEY (group_id) REFERENCES groups(id) ON DELETE CASCADE,
        FOREIGN KEY (song_id) REFERENCES songs(id) ON DELETE CASCADE
      )
    ''');
  }

  Future _updateDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Проверяем и добавляем столбцы, если их нет
      final columns = await db.rawQuery('PRAGMA table_info($tableSongs)');
      final columnNames = columns.map((column) => column['name']).toList();

      if (!columnNames.contains(Songs.order)) {
        await db.execute(
            'ALTER TABLE $tableSongs ADD COLUMN ${Songs.order} INTEGER DEFAULT 0');
      }

      if (!columnNames.contains(Songs.group)) {
        await db.execute(
            'ALTER TABLE $tableSongs ADD COLUMN ${Songs.group} INTEGER DEFAULT 0');
      }
      await db.execute('''
    CREATE TABLE IF NOT EXISTS $tableGroups (
      ${Groups.id} INTEGER PRIMARY KEY AUTOINCREMENT,
      ${Groups.name} TEXT NOT NULL UNIQUE,
      ${Groups.colorBackground} TEXT DEFAULT "#8C5AFF",
      ${Groups.colorForeground} TEXT DEFAULT "#8C5AFF",
      ${Groups.orderId} INTEGER DEFAULT -1
    )
  ''');
    }
    if (oldVersion < 3) {
      // Добавление новых столбцов speedScroll и fontSizeText
      final columns = await db.rawQuery('PRAGMA table_info($tableSongs)');
      final columnNames = columns.map((column) => column['name']).toList();

      if (!columnNames.contains(Songs.speedScroll)) {
        await db.execute(
            'ALTER TABLE $tableSongs ADD COLUMN ${Songs.speedScroll} INTEGER DEFAULT 150');
      }

      if (!columnNames.contains(Songs.fontSizeText)) {
        await db.execute(
            'ALTER TABLE $tableSongs ADD COLUMN ${Songs.fontSizeText} REAL DEFAULT 14.0');
      }
      // Обновление таблицы групп для добавления значений по умолчанию
      final groupColumns = await db.rawQuery('PRAGMA table_info($tableGroups)');
      final groupColumnNames =
          groupColumns.map((column) => column['name']).toList();

      if (!groupColumnNames.contains(Groups.colorBackground)) {
        await db.execute(
            'ALTER TABLE $tableGroups ADD COLUMN ${Groups.colorBackground} TEXT DEFAULT "#8C5AFF"');
      }

      if (!groupColumnNames.contains(Groups.colorForeground)) {
        await db.execute(
            'ALTER TABLE $tableGroups ADD COLUMN ${Groups.colorForeground} TEXT DEFAULT "#8C5AFF"');
      }

      if (!groupColumnNames.contains(Groups.orderId)) {
        await db.execute(
            'ALTER TABLE $tableGroups ADD COLUMN ${Groups.orderId} INTEGER DEFAULT -1');
      }
    }
    if (oldVersion < 4) {
      // изменения в song
      await db.execute(
          'ALTER TABLE $tableSongs ADD COLUMN ${Songs.tonalitySongText} TEXT DEFAULT ""');
      await db.execute(
          'ALTER TABLE $tableSongs ADD COLUMN ${Songs.tempoSongText} TEXT DEFAULT ""');
      await db.execute(
          'ALTER TABLE $tableSongs ADD COLUMN ${Songs.comment} TEXT DEFAULT ""');
      // Удаляем старые связи "один ко многим"
      await db.execute('''
        CREATE TABLE IF NOT EXISTS $tableSongToGroups (
          group_id INTEGER NOT NULL,
          song_id INTEGER NOT NULL,
          song_order INTEGER DEFAULT 0,
          PRIMARY KEY (group_id, song_id),
          FOREIGN KEY (group_id) REFERENCES groups(id) ON DELETE CASCADE,
          FOREIGN KEY (song_id) REFERENCES songs(id) ON DELETE CASCADE
        )
      ''');
    }
  }

  Future<Song> create(Song song) async {
    final db = await instance.database;
    final id = await db.insert(tableSongs, song.toJson());
    print("!!! Successed create id = $id !!!");
    print("!!! Successed create song = ${song.toJson()} !!!");
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

  Future<Map<String, dynamic>?> readSongByName(String name) async {
    final db = await instance.database; // Получение экземпляра базы данных

    // Выполнение SQL-запроса для поиска песни по имени
    final results = await db.query(
      tableSongs, // Таблица с песнями
      where: '${Songs.name_song} = ?', // Условие поиска
      whereArgs: [name], // Аргументы для условия
      limit: 1,
    );

    if (results.isNotEmpty) {
      // Если запись найдена, возвращаем её
      return results.first;
    } else {
      // Если запись не найдена, возвращаем null
      return null;
    }
  }

  Future<List<Song>> readAllSongs() async {
    final db = await instance.database;
    const orderBy = '`${Songs.id}` DESC';
    // final result = await db.rawQuery('select * from $tableSongs order by $orderBy');
    final result = await db.query(tableSongs, orderBy: orderBy);
    print("Reading all songs");
    return result.map((json) => Song.fromJson(json)).toList();
  }

  Future<List<Map<String, dynamic>>> findSongByPath(String? path) async {
    final db = await instance.database;
    return await db.query(
      tableSongs,
      where: '${Songs.path_music} = ?',
      whereArgs: [path],
    );
  }

  Future<void> insertSong(Map<String, dynamic> songData) async {
    final db = await instance.database;
    await db.insert(tableSongs, songData);
  }

  Future<int> update(Song song) async {
    final db = await instance.database;
    print("!!! Successed update id = ${song.id} !!!");
    return await db.update(tableSongs, song.toJson(),
        where: '${Songs.id} = ?', whereArgs: [song.id]);
  }

  Future<int> updateFontSizeText(int id, double fontSizeText) async {
    final db = await instance.database;
    print("!!! Successed update fontSizeText for id = $id !!!");
    return await db.update(
      tableSongs,
      {Songs.fontSizeText: fontSizeText},
      where: '${Songs.id} = ?',
      whereArgs: [id],
    );
  }

  Future<int> updateSpeedScroll(int id, int speedScroll) async {
    final db = await instance.database;
    print("!!! Successed update speedScroll for id = $id !!!");
    return await db.update(
      tableSongs,
      {Songs.speedScroll: speedScroll},
      where: '${Songs.id} = ?',
      whereArgs: [id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;
    print("!!! Successed delete id = $id !!!");
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
    print("!!! Successed create group id = $id !!!");
    return group.copy(id: id);
  }

  Future<GroupModel> readGroup(int id) async {
    final db = await instance.database;
    final maps = await db.query(tableGroups,
        columns: Groups.values, where: '${Groups.id} = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return GroupModel.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<GroupModel?> readGroupByName(String name) async {
    final db = await instance.database;
    final result = await db.query(
      tableGroups,
      where: '${Groups.name} = ?',
      whereArgs: [name],
    );

    if (result.isNotEmpty) {
      return GroupModel.fromJson(result.first);
    }
    return null;
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

    print("!!! Successed update group id = ${group.toJson()} !!!");
    return await db.update(tableGroups, group.toJson(),
        where: '${Groups.id} = ?', whereArgs: [group.id]);
  }

  Future<int> deleteGroup(int id) async {
    final db = await instance.database;

    // Удаляем все песни, связанные с этой группой
    await db.update(tableSongs, {Songs.group: 0, Songs.order: 0},
        where: '${Songs.group} = ?', whereArgs: [id]);

    print("!!! Successed delete group id = $id !!!");
    return await db
        .delete(tableGroups, where: '${Groups.id} = ?', whereArgs: [id]);
  }

  Future<int> deleteAllGroup() async {
    final db = await instance.database;
    print("!!! Deleting all records from $tableGroups !!!");

    return await db.delete(tableGroups);
  }

  // Future<List<Song>> readSongsByGroup(int groupId) async {
  //   final db = await instance.database;

  //   final result = await db.query(
  //     tableSongs,
  //     where: '${Songs.group} = ?',
  //     whereArgs: [groupId],
  //     orderBy: '${Songs.order} ASC',
  //   );

  //   print("Reading songs for group $groupId");
  //   return result.map((json) => Song.fromJson(json)).toList();
  // }

  Future<void> updateSongPath(int songId, String newPath) async {
    final db = await instance.database;
    await db.update(
      tableSongs, // Имя таблицы
      {Songs.path_music: newPath}, // Новое значение пути
      where: '${Songs.id} = ?', // Условие обновления
      whereArgs: [songId],
    );
    print("!!! Successed update song path = $newPath !!!");
  }

  Future<GroupModel?> findGroupByName(String name) async {
    final db = await instance.database;

    final result = await db.query(
      tableGroups,
      columns: [(Groups.id), (Groups.name)],
      where: '${Groups.name} = ?',
      whereArgs: [name],
      limit: 1,
    );

    if (result.isNotEmpty) {
      return GroupModel.fromJson(result.first);
    } else {
      return null;
    }
  }

// Работа со связкой песни-группы
  Future<void> addSongToGroup(int songId, int groupId, int order) async {
    final db = await instance.database;
    await db.insert(tableSongToGroups,
        {'group_id': groupId, 'song_id': songId, 'song_order': order});
  }

  Future<void> updateSongOrder(int songId, int groupId, int newOrder) async {
    final db = await instance.database;
    await db.update(
      tableSongToGroups,
      {'song_order': newOrder},
      where: 'song_id = ? AND group_id = ?',
      whereArgs: [songId, groupId],
    );
  }

  Future<List<Song>> getSongsByGroup(int groupId) async {
    final db = await instance.database;

    final result = await db.rawQuery('''
    SELECT s.* FROM $tableSongs s
    JOIN $tableSongToGroups stg ON s.${Songs.id} = stg.song_id
    WHERE stg.group_id = ?
    ORDER BY stg.song_order ASC
  ''', [groupId]);
    print("res: ${result.toList()}");
    return result.map((json) => Song.fromJson(json)).toList();
  }

  Future<List<GroupModel>> getGroupsBySong(int songId) async {
    final db = await instance.database;

    final result = await db.rawQuery('''
    SELECT g.* FROM $tableGroups g
    JOIN $tableSongToGroups stg ON g.${Groups.id} = stg.group_id
    WHERE stg.song_id = ?
  ''', [songId]);

    return result.map((json) => GroupModel.fromJson(json)).toList();
  }

  Future<List<SongToGroupModel>> getSongsGroup() async {
    final db = await instance.database;
    final result = await db.query(
      tableSongToGroups,
      orderBy: '`${SongToGroups.groupId}` asc',
    );
    // print("Reading all groups");
    return result.map((json) => SongToGroupModel.fromJson(json)).toList();
  }

  Future<void> removeSongFromGroup(int songId, int groupId) async {
    final db = await instance.database;
    print(
        "Песня успешно удалена из группы: songId = $songId, groupId = $groupId");
    await db.delete(
      tableSongToGroups,
      where: 'song_id = ? AND group_id = ?',
      whereArgs: [songId, groupId],
    );
  }

  Future<void> clearGroupSongs(int groupId) async {
    final db = await instance.database;
    await db.delete(
      tableSongToGroups,
      where: 'group_id = ?',
      whereArgs: [groupId],
    );
  }

  Future<void> migrateSongsToGroups() async {
    final db = await database;

    // Выбираем все песни, у которых group и order заданы
    final songs = await db.query(
      tableSongs,
      columns: [Songs.id, Songs.group, Songs.order],
      where: '${Songs.group} IS NOT NULL AND ${Songs.group} != 0',
    );

    for (final song in songs) {
      final songId = song[Songs.id] as int;
      final groupId = song[Songs.group] as int?;
      final songOrder = song[Songs.order] as int?;

      if (groupId != null) {
        // Вставляем в songToGroups
        await db.insert(
          tableSongToGroups,
          {
            'group_id': groupId,
            'song_id': songId,
            'song_order': songOrder ?? 0,
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
        print("Migrate");
        // Обнуляем group и order в songs
        // await db.update(
        //   tableSongs,
        //   {
        //     Songs.group: 0,
        //     Songs.order: 0,
        //   },
        //   where: '${Songs.id} = ?',
        //   whereArgs: [songId],
        // );
      }
    }
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
