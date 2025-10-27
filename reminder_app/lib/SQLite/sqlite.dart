import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:reminder_app/JsonModels/users.dart';

class DatabaseHelper {
  // Singleton
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _db;

  static const String _dbName = 'reminder_app.db';
  static const String _userTable = 'users';

  // =====================================================
  // Obtener instancia de la DB
  // =====================================================
  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await initDB();
    return _db!;
  }

  Future<Database> initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  // =====================================================
  // Crear tabla de usuarios
  // =====================================================
  Future<void> _onCreate(Database db, int version) async {
  await db.execute('''
    CREATE TABLE users (
      usr_id INTEGER PRIMARY KEY AUTOINCREMENT,
      usr_name TEXT NOT NULL UNIQUE,
      usr_password TEXT NOT NULL,
      birthdate TEXT
    );
  ''');
  }

  // =====================================================
  // REGISTRO (SIGNUP)
  // =====================================================
  Future<int> signup(Users user) async {
    final dbClient = await database;

    final id = await dbClient.insert(
      _userTable,
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.abort,
    );

    return id;
  }

  // =====================================================
  // LOGIN
  // =====================================================
  Future<bool> login(Users user) async {
    final dbClient = await database;

    final res = await dbClient.query(
      'users',
      where: 'usr_name = ? AND usr_password = ?',
      whereArgs: [user.usrName.trim(), user.usrPassword],
      limit: 1,
    );

    return res.isNotEmpty;
  }


  // =====================================================
  // Obtener usuario por nombre
  // =====================================================
  Future<Users?> getUserByName(String name) async {
    final dbClient = await database;

    final res = await dbClient.query(
      _userTable,
      where: 'usr_name = ?',
      whereArgs: [name.trim()],
      limit: 1,
    );

    if (res.isNotEmpty) {
      return Users.fromMap(res.first);
    } else {
      return null;
    }
  }
}
