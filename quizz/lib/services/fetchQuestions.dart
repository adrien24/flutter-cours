import 'dart:convert';

import 'package:http/http.dart' as http;
import '../models/question.dart';
import '../models/database.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<String> questions() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final startTime = DateTime.now().millisecondsSinceEpoch;
  await prefs.setInt('date', startTime);

  final dataQuestion = await http.get(
      Uri.parse('https://flutter-learning-iim.web.app/json/questions.json'));
  if (dataQuestion.statusCode == 200) {
    List<dynamic> listQuestions = jsonDecode(dataQuestion.body)['questions'];

    await DatabaseProvider.db.clearQuestions();

    for (var questionJson in listQuestions) {
      Question question = Question.fromJson(questionJson);
      await DatabaseProvider.db.createQuestions(question);
    }
    return dataQuestion.body;
  } else {
    return "Erreur";
  }
}
