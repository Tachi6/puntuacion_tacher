import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import 'package:puntuacion_tacher/models/models.dart';

class QuizServices extends ChangeNotifier {

  final String _baseUrl = 'puntos-tacher-default-rtdb.europe-west1.firebasedatabase.app';

  List<Question> selectedQuestionsList = [];

  final storage = const FlutterSecureStorage();

  Future<void> createQuiz({required String multipleId, required List<String> wineIdList}) async {

    final String jsonType = 'quiz/$multipleId.json';
    Map<String, Question> bodyMap = {};
    List<Question> tempQuestions = [];

    for (int i = 0; i < wineIdList.length; i++) {
      final Question question = Question(
        correctAnswer: i + 1, 
        wineId: wineIdList[i],
        answer: {},
      );
      final Map<String, Question> tempBodyMap = {
        wineIdList[i]: question
      };
      bodyMap = {...bodyMap, ...tempBodyMap};
      tempQuestions = [...tempQuestions, question];
    }
    // final Quiz quiz = Quiz(quiz: bodyMap); 
    final url = Uri.https(_baseUrl, jsonType, {
      'auth': await storage.read(key: 'idToken') ?? ''
    });
    await http.put(url, body: json.encode(bodyMap));

    selectedQuestionsList = tempQuestions;
    notifyListeners();
  }

  Future<List<Question>> loadQuiz(String multipleId) async {
    final String jsonType = 'quiz/$multipleId.json';
    
    final url = Uri.https(_baseUrl, jsonType, {
      'auth': await storage.read(key: 'idToken') ?? ''
    });
    final resp = await http.get(url);

    List<Question> tempQuestions = [];

    final Map<String, dynamic> quizResponse = json.decode(resp.body);
    // Añado al listado cada una de las catas multiples
    quizResponse.forEach((key, value) {
      final tempQuestion = Question.fromJson(value);
      tempQuestions.add(tempQuestion);
    });

    tempQuestions.sort((a, b) => a.correctAnswer.compareTo(b.correctAnswer));  

    selectedQuestionsList = tempQuestions;
    notifyListeners();

    return selectedQuestionsList;
  }

  Future<void> uploadUserQuiz({required String multipleId, required List<Question> questionList}) async { 

    for (Question question in questionList) {

      final String jsonType = 'quiz/$multipleId/${question.wineId}/answer.json';

      final url = Uri.https(_baseUrl, jsonType, {
        'auth': await storage.read(key: 'idToken') ?? ''
      });

      await http.patch(url, body: json.encode(question.answer));

      final int questionIndex = questionList.indexWhere((element) => element.wineId == question.wineId);

      selectedQuestionsList[questionIndex].answer == null
        ? selectedQuestionsList[questionIndex].answer = question.answer!
        : selectedQuestionsList[questionIndex].answer!.addEntries(question.answer!.entries);
    }
  }

}