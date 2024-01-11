import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'models/question.dart';
import 'result_screen.dart';
import 'models/database.dart';
import 'dart:convert';

class QuestionScreen extends StatefulWidget {
  @override
  _QuestionScreenState createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  bool isLoading = true;
  int currentQuestionIndex = 0;
  int score = 0;
  late List<Question> questions;

  void initState() {
    super.initState();
    fetchQuestions();
  }

  void fetchQuestions() async {
    final getQuestions = await DatabaseProvider.db.getQuestions();
    setState(() {
      questions = getQuestions
          .map((question) => Question.fromDataBase(question))
          .toList();
      isLoading = false;
    });
  }

  void answerQuestion(int selectedOptionIndex) {
    setState(() {
      if (selectedOptionIndex + 1 == questions[currentQuestionIndex].bonneReponse) {
        score++;
      }

      if (currentQuestionIndex < questions.length - 1) {
        currentQuestionIndex++;
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ResultScreen(score: score, totalQuestions: questions.length),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Scaffold(
        appBar: AppBar(
          title: Text("Question ${currentQuestionIndex + 1}"),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                questions[currentQuestionIndex].intitule,
                style: TextStyle(fontSize: 20.0),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20.0),
              ...List.generate(
                questions[currentQuestionIndex].reponses.length,
                (index) => ElevatedButton(
                  onPressed: () => answerQuestion(index),
                  child: Text(questions[currentQuestionIndex].reponses[index]
                      ["intitule"]),
                ),
              ),
            ],
          ),
        ));
  }
}
