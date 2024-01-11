import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  static const String _title = 'Exercice 1';

  @override
  Widget build(BuildContext context) {
    int age =
        30; // La variable age doit être déclarée ici, à l'intérieur de la méthode build
    double price = 19.99;
    String name = 'Alice';
    List<int> numbers = [1, 2, 3, 4, 5];
    print('Age: $age');
    print('Price: $price');
    print('Name: $name');
    print('Numbers: $numbers');
    return MaterialApp(
      title: _title,
      home: Scaffold(
        appBar: AppBar(title: const Text(_title)),
        body: Center(
          child: Text('Age: $age'), // Utilisez la variable age ici
        ),
      ),
    );
  }
}
