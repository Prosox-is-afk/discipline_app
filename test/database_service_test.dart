import 'package:flutter_test/flutter_test.dart';
import 'package:discipline_app/models/objective.dart';
import 'package:discipline_app/services/database_service.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  late DatabaseService dbService;

  setUp(() async {
    // Initialise sqflite pour FFI (tests sur PC)
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;

    dbService = DatabaseService();
  });

  tearDown(() async {
    final db = await dbService.database;
    await db.delete(dbService.tableObjective);
  });

  test('CRUD complet pour Objective', () async {
    final obj = Objective(
      id: dbService.generateId(),
      title: 'Apprendre Flutter',
      description: 'Coder une app disciplinée étape par étape',
      dueDate: DateTime.now().add(const Duration(days: 7)),
    );

    await dbService.insertObjective(obj);

    var allObjectives = await dbService.getAllObjectives();
    expect(allObjectives.length, 1);
    expect(allObjectives.first.title, 'Apprendre Flutter');

    obj.toggleCompleted();
    await dbService.updateObjective(obj);

    allObjectives = await dbService.getAllObjectives();
    expect(allObjectives.first.isCompleted, true);

    await dbService.deleteObjective(obj.id);
    allObjectives = await dbService.getAllObjectives();
    expect(allObjectives.isEmpty, true);
  });
}
