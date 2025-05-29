import 'package:flutter/material.dart';

import 'package:puntuacion_tacher/models/models.dart';
import 'package:puntuacion_tacher/pages/pages.dart';

class QuizProvider extends ChangeNotifier {

  final List<String> wineSequence;
  List<Question> defaultQuestionList;
  final String defaultUser;
  final String? quizType;
  final bool hidden;

  QuizProvider({
    required this.wineSequence, 
    required this.defaultQuestionList, 
    required this.defaultUser,
    required this.quizType, 
    required this.hidden, 
  }){
    _selectedUser = defaultUser;
    if (quizType != null) {
      if (defaultQuestionList.first.answer != null && !defaultQuestionList.first.answer!.containsKey(defaultUser)) {
        for (int i = 0; i < wineSequence.length; i++) {
          final String wineId = wineSequence[i];
          final Question tempQuestion = Question(
            correctAnswer: i + 1, 
            wineId: wineId,
            answer: {
              defaultUser: Answer(
                user: defaultUser,
                answerWine: (!hidden && quizType == 'advanced') ? null : -1,
                answerEyes: quizType == 'advanced' ? -1 : null,
                answerNose: quizType == 'advanced' ? -1 : null,
                answerMouth: quizType == 'advanced' ? -1 : null,
              ),
            },
          );
          editingQuestionList = [...editingQuestionList, tempQuestion]; 
        }
      }
    }
  }

  late String _selectedUser;
  List<Question> editingQuestionList = [];
  bool _isBottomSheetOpen = false;
  bool _isReorderQuizNedeed = true;

  String get selectedUser => _selectedUser;
  bool get isBottomSheetOpen => _isBottomSheetOpen;
  bool get isReorderQuizNedeed => _isReorderQuizNedeed;

  set selectedUser(String value) {
    _selectedUser = value;
    notifyListeners();
  }

  void reloadQuestions(List<Question> questionsReloaded) {
    _isReorderQuizNedeed = false;
    defaultQuestionList = [...questionsReloaded];
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

  int? obtainUserAnswer(String wineId, QuizTypes quizTypes) {
    final Answer answer = defaultQuestionList.firstWhere((element) => element.wineId == wineId).answer?[selectedUser] ?? Answer(user: selectedUser);
    switch (quizTypes) {
      case QuizTypes.vino:
        return answer.answerWine;
      case QuizTypes.vista:
        return answer.answerEyes;
      case QuizTypes.nariz:
        return answer.answerNose;
      case QuizTypes.boca:
        return answer.answerMouth;
    }
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

  bool isValidQuiz() {
    List<int> answers = [];

    for (Question question in editingQuestionList) {
      question.answer!.forEach((key, value) {
        if (value.answerWine != null) answers.add(value.answerWine!);
        if (value.answerEyes != null) answers.add(value.answerEyes!);
        if (value.answerNose != null) answers.add(value.answerNose!);
        if (value.answerMouth != null) answers.add(value.answerMouth!);
      });
    }

    if (answers.contains(-1)) return false;
    return true;
  }

  bool isValidatedQuiz() {
    if (defaultQuestionList.isEmpty) return false;
    return defaultQuestionList.first.answer?[selectedUser] != null;
  }

  void openBottomSheet(BuildContext context) {
    if (isValidQuiz() && !isBottomSheetOpen) {
      Scaffold.of(context).showBottomSheet((BuildContext context) => const SafeArea(child: ValidateButton()));
      _isBottomSheetOpen = true;
      notifyListeners();
    }
  }

  void closeBottomSheet(BuildContext context) {
    if (isBottomSheetOpen) {
      Navigator.pop(context);
      _isBottomSheetOpen = false;
      notifyListeners();
    }
  }
}