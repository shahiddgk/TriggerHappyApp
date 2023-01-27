class QuestionListResponseModel {
  String? id;
  String? title;
  String? subTitle;
  String? textLength;
  List options = [];
  String? responseType;
  String? createdAt;

  QuestionListResponseModel(
      {this.id, this.title, this.subTitle,this.textLength, required this.options, this.responseType, this.createdAt});

  QuestionListResponseModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    subTitle = json['sub_title'] ?? "";
    textLength = json['text_length'];
    options = json['options'] ?? [];
    responseType = json['response_type'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['sub_title'] = this.subTitle;
    data['text_length'] = this.textLength;
    data['options'] = this.options;
    data['response_type'] = this.responseType;
    data['created_at'] = this.createdAt;
    return data;
  }
}

class QuestionListModel {
  List<QuestionListResponseModel> values = [];
  QuestionListModel() {
    values = [];
  }
  QuestionListModel.fromJson(var jsonObject) {
    for (var area in jsonObject) {
      QuestionListResponseModel model = QuestionListResponseModel.fromJson(area);
      this.values.add(model);
    }
  }
}