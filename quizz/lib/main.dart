// main.dart
import 'package:flutter/material.dart';
import 'question_screen.dart';
import 'package:flutter/material.dart';
import 'question_screen.dart';
import 'models/database.dart';
import 'services/fetchQuestions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'services/connectivity.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final wifi = await isConnectedToInternet();
  await DatabaseProvider.db.database;
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final startTime = DateTime.now().millisecondsSinceEpoch;
  final updateTime = prefs.getInt('date');
  if (wifi) {
    if (updateTime == null || startTime - updateTime > 300000) {
      await questions();
    }
  }

  runApp(MyApp(wifi: wifi));
}

class MyApp extends StatelessWidget {
  final bool wifi;

  MyApp({required this.wifi});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(wifi: wifi),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final bool wifi;

  HomeScreen({required this.wifi});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
      ),
      body: Center(
          child: wifi
              ? ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => QuestionScreen(),
                      ),
                    );
                  },
                  child: Text('Start Quiz'),
                )
              : Text('You are not connected to the internet')),
    );
  }
}
