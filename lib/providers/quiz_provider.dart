import 'package:flutter/material.dart';

import 'package:puntuacion_tacher/models/models.dart';

class QuizProvider extends ChangeNotifier {

  final List<String> wineSequence;
  final List<Question> defaultQuestionList;
  final String defaultUser;

  late String _selectedUser;

  List<Question> editingQuestionList = [];

  QuizProvider({required this.wineSequence, required this.defaultQuestionList, required this.defaultUser}){
    _selectedUser = defaultUser;

    if(defaultQuestionList.first.answer != null && !defaultQuestionList.first.answer!.containsKey(defaultUser)) {
      for (int i = 0; i < wineSequence.length; i++) {
        final String wineId = wineSequence[i];
        final Question tempQuestion = Question(
          correctAnswer: i + 1, 
          wineId: wineId,
          answer: {
            defaultUser: Answer(
              answerWine: -1, 
              user: defaultUser
            ),
          },
        );
        editingQuestionList = [...editingQuestionList, tempQuestion]; 
      }
    }
  }

  String get selectedUser => _selectedUser;

  set selectedUser(String value) {
    _selectedUser = value;
    notifyListeners();
  }

  void completeAnswers({required String wineId, int? answerMouth, int? answerNose, int? answerEyes, int? answerWine}) {
    final Answer oldAnswer = editingQuestionList.firstWhere((element) => element.wineId == wineId).answer![defaultUser]!;

    oldAnswer.answerMouth = answerMouth ?? oldAnswer.answerMouth;
    oldAnswer.answerNose = answerNose ?? oldAnswer.answerNose;
    oldAnswer.answerEyes = answerEyes ?? oldAnswer.answerEyes;
    oldAnswer.answerWine = answerWine ?? oldAnswer.answerWine;

    notifyListeners();
  }

  Answer? obtainUserAnswer(String wineId) {
    return defaultQuestionList.firstWhere((element) => element.wineId == wineId).answer?[selectedUser] ?? Answer(user: selectedUser);
  }

  int obtainCorrectAnswer(String wineId) {
    return defaultQuestionList.firstWhere((element) => element.wineId == wineId).correctAnswer;
  }

  String obtainPuntuation([String? otherUser]) {
    final List<Map<int, List<int>>> checkAnswers = [];

    List<Question> newQuestionList = [];

    final String checkUser = otherUser ?? defaultUser;

    for (Question question in defaultQuestionList) {
      question.answer!.forEach((key, value) {
        if (key == checkUser) {
          Question tempQuestionMap = Question(
            correctAnswer: question.correctAnswer, 
            wineId: question.wineId,
            answer: {
              checkUser: Answer(
                answerWine: question.answer?[checkUser]?.answerWine, 
                answerEyes: question.answer?[checkUser]?.answerEyes, 
                answerNose: question.answer?[checkUser]?.answerNose, 
                answerMouth: question.answer?[checkUser]?.answerMouth, 
                user: checkUser,
              ),
            } 
          );
          newQuestionList = [...newQuestionList, tempQuestionMap];
        }
      });
    }

    for (Question question in newQuestionList) {
      Map<int, List<int>> tempAnswersMap = {
        question.correctAnswer: []
      };
      question.answer!.forEach((key, value) {
        if (value.answerWine != null) tempAnswersMap[question.correctAnswer]!.add(value.answerWine!);
        if (value.answerEyes != null) tempAnswersMap[question.correctAnswer]!.add(value.answerEyes!);
        if (value.answerNose != null) tempAnswersMap[question.correctAnswer]!.add(value.answerNose!);
        if (value.answerMouth != null) tempAnswersMap[question.correctAnswer]!.add(value.answerMouth!);
      });

      checkAnswers.add(tempAnswersMap);
    }

    final int questionsNumber = checkAnswers.length * checkAnswers.first.values.first.length;

    int correctAnswers = 0;
    for (int i = 0; i < checkAnswers.length; i++) {
      int tempCorrectAnswers = checkAnswers[i].values.first.where((element) => element == checkAnswers[i].keys.first).length;
      correctAnswers = correctAnswers + tempCorrectAnswers;
    }

    return '$correctAnswers / $questionsNumber';
  }

  List<Map<String, String>> otherUsersQuiz() {
    List<String> usersAnsweredList = [];  
    defaultQuestionList.first.answer!.forEach((key, value) => usersAnsweredList.add(key));

    List<String> correctAnswersUsers = [];

    for (String user in usersAnsweredList) {
      correctAnswersUsers.add('${obtainPuntuation(user)}%$user');
    }
    correctAnswersUsers.sort((a, b) => b.compareTo(a));

    List<Map<String, String>> userPuntuation = [];

    for (String element in correctAnswersUsers) {
      final elementSplitted = element.split('%');
      final Map<String, String> userTempPuntuation = {
        elementSplitted[1]: elementSplitted[0],
      };
      userPuntuation.add(userTempPuntuation);
    }

    return userPuntuation;    
  }

  void clearQuiz() {
    //TODO: hacer metodo y llamarlo al salir o enviar
  }

  // updateAnswer({required String wineId, required Answer updatedAnswer}) {

  //   final Answer oldAnswer = questionsList;
  //   final Question questionResponse = Question(
  //     answer: {
  //       user: answer
  //     }, 
  //     wineId: wineId,
  //   );
  //   // final Answer newAnswer = wineIdAnswer.values.first;
    
  //   if (newAnswer.answerEyes != null) {
  //     oldAnswer.answerEyes = newAnswer.answerEyes;
  //   }
  //   if (newAnswer.answerMouth != null) {
  //     oldAnswer.answerMouth = newAnswer.answerMouth;
  //   }
  //   if (newAnswer.answerNose != null) {
  //     oldAnswer.answerNose = newAnswer.answerNose;
  //   }
  //   if (newAnswer.answerWine != null) {
  //     oldAnswer.answerWine = newAnswer.answerWine;
  //   }

  //   print(wineQuestions[wineIdAnswer.keys.first]!.answer[user]!);

  //   notifyListeners(); 
  // }
}