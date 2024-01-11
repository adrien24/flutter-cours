import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'question.dart';

class DatabaseProvider {
  static final DatabaseProvider db = DatabaseProvider();

  // Créer une instance de la base de données
  Database? _database;

  // Méthode pour récupérer la base de données
  Future<Database> get database async {
    // Si la base de données existe déjà, on la retourne
    if (_database != null) {
      return _database!;
    }

    // Sinon, on la crée
    _database = await createDatabase();
    return _database!;
  }

  // Méthode pour créer la base de données
  Future<Database> createDatabase() async {
    // Récupérer le chemin de la base de données
    String path = join(await getDatabasesPath(), 'database.db');

    // Créer la base de données
    return await openDatabase(
      path,
      version: 1, // Version de la base de données
      onCreate: (Database database, int version) async {
        // Créer la table
        await database.execute(
          'CREATE TABLE questions (id INTEGER PRIMARY KEY, intitule TEXT, bonneReponse INTEGER, reponses TEXT)',
        );
      },
    );
  }

  Future<int> createQuestions(Question question) async {
    // Récupérer la base de données
    final db = await DatabaseProvider.db.database;

    // Ajouter l'objet dans la base de données
    return db.insert('questions', question.toJson());
  }

  Future<List<Map<String, dynamic>>> getQuestions() async {
    final db = await DatabaseProvider.db.database;

    final List<Map<String, dynamic>> maps = await db.query('questions');
    return maps;
  }

  Future<void> clearQuestions() async {
    final db = await DatabaseProvider.db.database;
    await db.delete('questions');
  }
}
