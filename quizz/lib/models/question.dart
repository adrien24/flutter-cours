import 'dart:convert';

class Question {
  String intitule;
  int bonneReponse;
  List reponses;

  Question({
    required this.intitule,
    required this.reponses,
    required this.bonneReponse,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      bonneReponse: json["bonneReponse"] as int,
      intitule: json["intitule"] as String,
      reponses: json['reponses'] as List,
    );
  }

  factory Question.fromDataBase(Map<String, dynamic> json) {
    return Question(
      bonneReponse: json["bonneReponse"] as int,
      intitule: json["intitule"] as String,
      reponses: jsonDecode(json['reponses']) as List,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'intitule': intitule,
      'bonneReponse': bonneReponse,
      'reponses': jsonEncode(reponses),
    };
  }
}
