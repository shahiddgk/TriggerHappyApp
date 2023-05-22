class AnswerRequestModel {
  String? questionId;
  String? userId;
  String? options;
  String? text;

  AnswerRequestModel({this.questionId, this.userId, this.options,this.text});

  AnswerRequestModel.fromJson(Map<String, dynamic> json) {
    questionId = json['question_id'];
    userId = json['user_id'];
    options = json['options'];
    text = json['text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['question_id'] = questionId;
    data['user_id'] = userId;
    data['options'] = options;
    data['text'] = text;
    return data;
  }
}