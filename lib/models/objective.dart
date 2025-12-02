import 'package:flutter/foundation.dart';

/// Modèle représentant un objectif de l'utilisateur
class Objective {
  final String id; // identifiant unique
  final String title; // titre de l'objectif
  final String description; // description détaillée
  final DateTime dueDate; // date limite
  bool isCompleted; // statut de l'objectif

  /// Constructeur
  Objective({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    this.isCompleted = false,
  });

  /// Convertir l'objet en Map pour stockage en base
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dueDate': dueDate.toIso8601String(),
      'isCompleted': isCompleted ? 1 : 0, // SQLite n'aime pas les bool
    };
  }

  /// Créer un objet à partir d'une Map (lecture depuis la base)
  factory Objective.fromMap(Map<String, dynamic> map) {
    return Objective(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      dueDate: DateTime.parse(map['dueDate']),
      isCompleted: map['isCompleted'] == 1,
    );
  }

  /// Changer le statut de l'objectif
  void toggleCompleted() {
    isCompleted = !isCompleted;
  }
}
