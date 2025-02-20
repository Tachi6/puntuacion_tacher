import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:puntuacion_tacher/models/models.dart';

class QuizProvider extends ChangeNotifier {

  final List<String> wineSequence;
  final List<Question> selectedQuestionList;
  final String user;

  List<Question> questionsList = [];

  QuizProvider({required this.wineSequence, required this.selectedQuestionList, required this.user}){
    if(!selectedQuestionList.first.answer.containsKey(user)) {
      for (int i = 0; i < wineSequence.length; i++) {
        final String wineId = wineSequence[i];
        final Question tempQuestion = Question(
          correctAnswer: i + 1, 
          wineId: wineId,
          answer: {
            user: Answer(
              answerWine: -1, 
              user: user
            ),
          },
        );
        questionsList = [...questionsList, tempQuestion]; 
      }
    } else {
      questionsList = [...selectedQuestionList];
    }

  }

  // QuizProvider({required this.wineQuestions}) {
  //   loadUser();
  //   wineQuestions.forEach((key, value) {
  //     value.answer = {
  //       user: Answer.copyWith(user),
  //     };
  //   });
  // }

  // QuizProvider({required this.quizCopy}) {
  //   loadUser();
  //   quizCopy.quiz.forEach((key, value) {
  //     value.answer = {
  //       user: Answer(
  //         user: user,
  //       ),
  //     };
  //   });
  // }

  void completeAnswers({required String wineId, int? answerMouth, int? answerNose, int? answerEyes, int? answerWine}) {
    final Answer oldAnswer = questionsList.firstWhere((element) => element.wineId == wineId).answer[user]!;

    oldAnswer.answerMouth = answerMouth ?? oldAnswer.answerMouth;
    oldAnswer.answerNose = answerNose ?? oldAnswer.answerNose;
    oldAnswer.answerEyes = answerEyes ?? oldAnswer.answerEyes;
    oldAnswer.answerWine = answerWine ?? oldAnswer.answerWine;

    // Map<int, List<int>> checker = {};
    // for (Question question in questionsList) {
    //   final Map<int, List<int>> mapeo = {
    //     question.correctAnswer: [
    //       question.answer[user]!.answerEyes!,
    //       question.answer[user]!.answerNose!,
    //       question.answer[user]!.answerMouth!,
    //     ]
    //   };
    //   checker = {...checker, ...mapeo};
    // }

    print(json.encode(questionsList));
    notifyListeners();
  }

  Answer obtainUserAnswer(String wineId) {
    return questionsList.firstWhere((element) => element.wineId == wineId).answer[user]!;
  }

  int obtainCorrectAnswer(String wineId) {
    return questionsList.firstWhere((element) => element.wineId == wineId).correctAnswer;
  }

  String obtainPuntuation() {
    final List<Map<int, List<int>>> checkAnswers = [];

    for (Question question in questionsList) {
      Map<int, List<int>> tempAnswersMap = {
        question.correctAnswer: []
      };
      question.answer.forEach((key, value) {
        if (key == user) {
          tempAnswersMap[question.correctAnswer]!.add(value.answerWine);
          if (value.answerEyes != null) tempAnswersMap[question.correctAnswer]!.add(value.answerEyes!);
          if (value.answerNose != null) tempAnswersMap[question.correctAnswer]!.add(value.answerNose!);
          if (value.answerMouth != null) tempAnswersMap[question.correctAnswer]!.add(value.answerMouth!);
        }
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