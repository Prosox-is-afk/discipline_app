import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // pour formater les dates
import '../services/database_service.dart';
import '../models/objective.dart';

class ObjectivesScreen extends StatefulWidget {
  const ObjectivesScreen({Key? key}) : super(key: key);

  @override
  _ObjectivesScreenState createState() => _ObjectivesScreenState();
}

class _ObjectivesScreenState extends State<ObjectivesScreen> {
  final DatabaseService _dbService = DatabaseService();
  List<Objective> _objectives = [];

  @override
  void initState() {
    super.initState();
    _loadObjectives(); // charge la liste au démarrage
  }

  /// Charger les objectifs depuis la DB
  Future<void> _loadObjectives() async {
    var objectives = await _dbService.getAllObjectives();

    // Si aucun objectif en DB, créer des objectifs de test
    if (objectives.isEmpty) {
      objectives = [
        Objective(
          id: _dbService.generateId(),
          title: 'Objectif test 1',
          description: 'Description test 1',
          dueDate: DateTime.now().add(const Duration(days: 3)),
        ),
        Objective(
          id: _dbService.generateId(),
          title: 'Objectif test 2',
          description: 'Description test 2',
          dueDate: DateTime.now().add(const Duration(days: 5)),
        ),
      ];

      for (var obj in objectives) {
        await _dbService.insertObjective(obj);
      }
    }

    setState(() {
      _objectives = objectives;
    });
  }

  /// Widget principal
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mes Objectifs')),
      body: _objectives.isEmpty
          ? const Center(child: Text('Aucun objectif pour le moment'))
          : ListView.builder(
              itemCount: _objectives.length,
              itemBuilder: (context, index) {
                final obj = _objectives[index];
                return Dismissible(
                  key: Key(obj.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (direction) async {
                    await _dbService.deleteObjective(obj.id);
                    _loadObjectives();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Objectif "${obj.title}" supprimé'),
                      ),
                    );
                  },
                  child: ListTile(
                    title: Text(obj.title),
                    subtitle: Text(
                      '${obj.description}\nDate limite: ${DateFormat('dd/MM/yyyy').format(obj.dueDate)}',
                    ),
                    isThreeLine: true,
                    trailing: Checkbox(
                      value: obj.isCompleted,
                      onChanged: (value) async {
                        obj.toggleCompleted();
                        await _dbService.updateObjective(obj);
                        _loadObjectives();
                      },
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddObjectiveDialog,
        child: const Icon(Icons.add),
      ),
    );
  }

  /// Affiche un dialogue pour ajouter un objectif
  void _showAddObjectiveDialog() {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nouvel Objectif'),
        content: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Titre'),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (titleController.text.isEmpty) return; // petit check
              final newObj = Objective(
                id: _dbService.generateId(),
                title: titleController.text,
                description: descriptionController.text,
                dueDate: DateTime.now().add(const Duration(days: 7)),
              );
              await _dbService.insertObjective(newObj);
              Navigator.of(context).pop();
              _loadObjectives();
            },
            child: const Text('Ajouter'),
          ),
        ],
      ),
    );
  }
}
