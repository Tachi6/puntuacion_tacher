import 'dart:convert';

class Quiz {
    final Map<String, Question> quiz;

    Quiz({
        required this.quiz
    });

    factory Quiz.fromRawJson(String str) => Quiz.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Quiz.fromJson(Map<String, dynamic> json) => Quiz(
        quiz: Map.from(json["quiz"]).map((k, v) => MapEntry<String, Question>(k, Question.fromJson(v))),
    );

    Map<String, dynamic> toJson() => {
        "quiz": Map.from(quiz).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
    };
}

class Question {
    final int correctAnswer;
    final Map<String, Answer>? answer;
    final String wineId;

    Question({
        required this.correctAnswer,
        required this.answer,
        required this.wineId,
    });

    factory Question.fromRawJson(String str) => Question.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Question.fromJson(Map<String, dynamic> json) => Question(
        correctAnswer: json["correctAnswer"],
        answer: Map.from(json["answer"] ?? {}).map((k, v) => MapEntry<String, Answer>(k, Answer.fromJson(v))),
        wineId: json["wineId"],
    );

    Map<String, dynamic> toJson() => {
        "correctAnswer": correctAnswer,
        "answer": answer == null ? {} : Map.from(answer!).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
        "wineId": wineId,
    };
}

class Answer {
    int? answerMouth;
    int? answerNose;
    int? answerEyes;
    int? answerWine;
    final String user;

    Answer({
        this.answerMouth,
        this.answerNose,
        this.answerEyes,
        this.answerWine,
        required this.user,
    });

    factory Answer.fromRawJson(String str) => Answer.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Answer.fromJson(Map<String, dynamic> json) => Answer(
        answerMouth: json["answerMouth"],
        answerNose: json["answerNose"],
        answerEyes: json["answerEyes"],
        answerWine: json["answerWine"],
        user: json["user"],
    );

    Map<String, dynamic> toJson() => {
        "answerMouth": answerMouth,
        "answerNose": answerNose,
        "answerEyes": answerEyes,
        "answerWine": answerWine,
        "user": user,
    };
}
