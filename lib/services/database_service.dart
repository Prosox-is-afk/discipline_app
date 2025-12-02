import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:uuid/uuid.dart';
import '../models/objective.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  static Database? _database;

  /// Nom de la table
  final String tableObjective = 'objectives';

  /// Getter pour la DB
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('discipline_app.db');
    return _database!;
  }

  /// Initialisation de la DB
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  /// Création des tables
  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableObjective (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        description TEXT,
        dueDate TEXT NOT NULL,
        isCompleted INTEGER NOT NULL
      )
    ''');
  }

  /// Créer un objectif
  Future<void> insertObjective(Objective obj) async {
    final db = await database;
    await db.insert(
      tableObjective,
      obj.toMap(),
      conflictAlgorithm:
          ConflictAlgorithm.replace, // protège contre les doublons
    );
  }

  /// Lire tous les objectifs
  Future<List<Objective>> getAllObjectives() async {
    final db = await database;
    final result = await db.query(tableObjective);
    return result.map((map) => Objective.fromMap(map)).toList();
  }

  /// Mettre à jour un objectif
  Future<void> updateObjective(Objective obj) async {
    final db = await database;
    await db.update(
      tableObjective,
      obj.toMap(),
      where: 'id = ?',
      whereArgs: [obj.id],
    );
  }

  /// Supprimer un objectif
  Future<void> deleteObjective(String id) async {
    final db = await database;
    await db.delete(tableObjective, where: 'id = ?', whereArgs: [id]);
  }

  /// Générer un id unique
  String generateId() {
    return const Uuid().v4();
  }
}
