// ignore_for_file: camel_case_types

class naq_reponse_model {
  String? id;
  String? userId;
  String? type;
  String? questionId;
  String? responseId;
  String? options;
  String? text;
  String? createdAt;

  naq_reponse_model(
      {this.id,
        this.userId,
        this.type,
        this.questionId,
        this.responseId,
        this.options,
        this.text,
        this.createdAt});

  naq_reponse_model.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    type = json['type'];
    questionId = json['question_id'];
    responseId = json['response_id'];
    options = json['options'];
    text = json['text'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['type'] = type;
    data['question_id'] = questionId;
    data['response_id'] = responseId;
    data['options'] = options;
    data['text'] = text;
    data['created_at'] = createdAt;
    return data;
  }
}

class NaqResponseListModel {
  List<naq_reponse_model> values = [];
  NaqResponseListModel() {
    values = [];
  }
  NaqResponseListModel.fromJson(var jsonObject) {
    for (var area in jsonObject) {
      naq_reponse_model model = naq_reponse_model.fromJson(area);
      values.add(model);
    }
  }
}