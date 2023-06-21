class NaqModelClassResponse {
  int status;
  String message;
  List<List<Question>> questions;

  NaqModelClassResponse({
    required this.status,
    required this.message,
    required this.questions,
  });

  factory NaqModelClassResponse.fromJson(Map<String, dynamic> json) {
    return NaqModelClassResponse(
      status: json['status'],
      message: json['message'],
      questions: List<List<Question>>.from(json['questions'].map((questions) =>
      List<Question>.from(
          questions.map((question) => Question.fromJson(question))))),
    );
  }
}

class Question {
  String id;
  String title;
  String? subTitle;
  String videoUrl;
  List<String> options;
  String textLength;
  String responseType;
  String type;
  String createdAt;

  Question({
    required this.id,
    required this.title,
    required this.subTitle,
    required this.videoUrl,
    required this.options,
    required this.textLength,
    required this.responseType,
    required this.type,
    required this.createdAt,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'],
      title: json['title'],
      subTitle: json['sub_title'],
      videoUrl: json['video_url'],
      options: List<String>.from(json['options']),
      textLength: json['text_length'],
      responseType: json['response_type'],
      type: json['type'],
      createdAt: json['created_at'],
    );
  }
}
