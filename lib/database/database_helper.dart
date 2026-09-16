import 'package:flutter/foundation.dart' show defaultTargetPlatform, TargetPlatform, kIsWeb;
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart' show sqfliteFfiInit, databaseFactoryFfi;
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart' show databaseFactoryFfiWeb;
import 'package:path/path.dart';
import '../models/models.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  /// Test-only override so tests can point at an isolated database file.
  static String? dbDirectoryOverride;

  DatabaseHelper._init() {
    // Set the correct database factory for the current platform.
    if (kIsWeb) {
      databaseFactory = databaseFactoryFfiWeb;
    } else if (defaultTargetPlatform == TargetPlatform.linux ||
        defaultTargetPlatform == TargetPlatform.macOS ||
        defaultTargetPlatform == TargetPlatform.windows) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('vaultkey.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = DatabaseHelper.dbDirectoryOverride ?? await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE passwords (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        username TEXT NOT NULL,
        password TEXT NOT NULL,
        website TEXT NOT NULL,
        category TEXT NOT NULL,
        strength TEXT NOT NULL,
        lastUpdated TEXT NOT NULL,
        favorite INTEGER NOT NULL DEFAULT 0,
        notes TEXT NOT NULL DEFAULT ''
      )
    ''');
  }

  Future<int> insertPassword(PasswordEntry pw) async {
    final db = await database;
    return await db.insert('passwords', _toMap(pw), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<PasswordEntry>> getAllPasswords() async {
    final db = await database;
    final maps = await db.query('passwords', orderBy: 'id DESC');
    return maps.map((m) => _fromMap(m)).toList();
  }

  Future<PasswordEntry?> getPassword(int id) async {
    final db = await database;
    final maps = await db.query('passwords', where: 'id = ?', whereArgs: [id]);
    if (maps.isEmpty) return null;
    return _fromMap(maps.first);
  }

  Future<int> updatePassword(PasswordEntry pw) async {
    final db = await database;
    return await db.update(
      'passwords',
      _toMap(pw),
      where: 'id = ?',
      whereArgs: [int.parse(pw.id)],
    );
  }

  Future<int> deletePassword(int id) async {
    final db = await database;
    return await db.delete('passwords', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> countPasswords() async {
    final db = await database;
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM passwords');
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<int> countByStrength(String strength) async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM passwords WHERE strength = ?',
      [strength],
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<int> countCategories() async {
    final db = await database;
    final result = await db.rawQuery('SELECT COUNT(DISTINCT category) as count FROM passwords');
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Map<String, dynamic> _toMap(PasswordEntry pw) {
    return {
      'title': pw.title,
      'username': pw.username,
      'password': pw.password,
      'website': pw.website,
      'category': pw.category.name,
      'strength': pw.strength.name,
      'lastUpdated': pw.lastUpdated,
      'favorite': pw.favorite ? 1 : 0,
      'notes': pw.notes,
    };
  }

  PasswordEntry _fromMap(Map<String, dynamic> map) {
    return PasswordEntry(
      id: map['id'].toString(),
      title: map['title'],
      username: map['username'],
      password: map['password'],
      website: map['website'],
      category: Category.values.firstWhere((c) => c.name == map['category']),
      strength: PasswordStrength.values.firstWhere((s) => s.name == map['strength']),
      lastUpdated: map['lastUpdated'],
      favorite: map['favorite'] == 1,
      notes: map['notes'] ?? '',
    );
  }
}
