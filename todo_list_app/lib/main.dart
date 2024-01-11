import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

// Classe représentant une tâche
class Task {
  String title; // Le nom de la tâche
  bool isCompleted; // Indicateur si la tâche est terminée

  Task(this.title, this.isCompleted);
}

// Widget d'état pour gérer la liste de tâches
class TaskList extends StatefulWidget {
  @override
  _TaskListState createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  TextEditingController _taskController =
      TextEditingController(); // Contrôleur pour le champ de saisie
  List<Task> _tasks = []; // Liste des tâches

  @override
  void initState() {
    super.initState();
    _initializeApp(); // Assurez-vous que cette méthode est asynchrone
  }

  Future<void> _initializeApp() async {
    await _fetchTasks();
    // Le reste de votre initialisation ici
  }

  void _addTask() async {
    String title = _taskController.text.trim();
    print(title);
    if (title.isNotEmpty) {
      try {
        var response = await http.post(
          Uri.parse('http://10.0.2.2:8000/todo'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{'item': title}),
        );

        if (response.statusCode == 200) {
          print(response.body);
          setState(() {
            _taskController.clear();
          });
          const bool = false;
          _fetchTasks();
        } else {
          print('Échec de la requête : ${response.statusCode}');
        }
      } catch (error) {
        print('Erreur lors de la requête : $error');
      }
    }
  }

  // Fonction pour basculer l'état d'une tâche entre terminée et non terminée
  void _toggleTask(int index) async {
    try {
      final response = await http.put(
        Uri.parse(
            'http://10.0.2.2:8000/todo/${index}'), // Remplacez par votre adresse IP et port
      );

      if (response.statusCode == 200) {
        setState(() {
          _fetchTasks();
        });
      } else {
        print('Échec de la requête : ${response.statusCode}');
      }
    } catch (error) {
      print('Erreur lors de la requête : $error');
    }
  }

  // Fonction pour supprimer une tâche de la liste
  void _deleteTask(int index) async {
    try {
      final response = await http.delete(Uri.parse(
          'http://10.0.2.2:8000/todo/${_tasks[index]}')); // Remplacez par votre adresse IP et port

      if (response.statusCode == 200) {
        setState(() {
          _tasks.removeAt(index);
        });
      } else {
        print('Échec de la requête : ${response.statusCode}');
      }
    } catch (error) {
      print('Erreur lors de la requête : $error');
    }
  }

  Future<void> _fetchTasks() async {
    try {
      final response = await http.get(Uri.parse('http://10.0.2.2:8000/todo'));
      print(response.body);

      if (response.statusCode == 200) {
        if (response.body != null && response.body.isNotEmpty) {
          final List<dynamic> data = json.decode(response.body);
          setState(() {
            _tasks = data
                .map(
                    (task) => Task(task['item'] as String, task["isCompleted"]))
                .toList();
          });
        } else {
          print('Réponse du serveur vide.');
        }
      } else {
        print('Échec de la requête. Statut : ${response.statusCode}');
        print('Corps de la réponse : ${response.body}');
      }
    } catch (error) {
      print('Erreur lors de la requête : $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Liste de Tâches'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _taskController,
                    decoration: InputDecoration(labelText: 'Nom de la Tâche'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: _addTask,
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _tasks.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_tasks[index].title),
                  leading: Checkbox(
                    value: _tasks[index].isCompleted,
                    onChanged: (_) => _toggleTask(index),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => _deleteTask(index),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TaskList(),
    );
  }
}
