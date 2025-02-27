import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/video_model.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  static Database? _database;

  factory DatabaseService() {
    return _instance;
  }

  DatabaseService._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'video_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDb,
    );
  }

  Future<void> _createDb(Database db, int version) async {
    await db.execute('''
      CREATE TABLE videos(
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        filePath TEXT NOT NULL,
        thumbnailPath TEXT NOT NULL,
        duration INTEGER NOT NULL,
        addedDate TEXT NOT NULL,
        isDownloaded INTEGER NOT NULL,
        description TEXT
      )
    ''');
  }

  Future<void> insertVideo(Video video) async {
    final Database db = await database;
    await db.insert(
      'videos',
      video.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Video>> getVideos() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('videos');
    return List.generate(maps.length, (i) => Video.fromMap(maps[i]));
  }

  Future<Video?> getVideo(String id) async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'videos',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isEmpty) return null;
    return Video.fromMap(maps.first);
  }

  Future<void> updateVideo(Video video) async {
    final Database db = await database;
    await db.update(
      'videos',
      video.toMap(),
      where: 'id = ?',
      whereArgs: [video.id],
    );
  }

  Future<void> deleteVideo(String id) async {
    final Database db = await database;
    await db.delete(
      'videos',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
