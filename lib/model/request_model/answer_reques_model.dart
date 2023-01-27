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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['question_id'] = this.questionId;
    data['user_id'] = this.userId;
    data['options'] = this.options;
    data['text'] = this.text;
    return data;
  }
}