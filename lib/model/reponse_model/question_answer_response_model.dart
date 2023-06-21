// ignore_for_file: unnecessary_this

class QuestionListResponseModel {
  String? id;
  String? title;
  String? videoUrl;
  String? subTitle;
  String? textLength;
  List options = [];
  String? responseType;
  String? createdAt;

  QuestionListResponseModel(
      {this.id, this.title, this.videoUrl,this.subTitle,this.textLength, required this.options, this.responseType, this.createdAt});

  QuestionListResponseModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    videoUrl = json['video_url'];
    subTitle = json['sub_title'] ?? "";
    textLength = json['text_length'];
    options = json['options'] ?? [];
    responseType = json['response_type'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['video_url'] = videoUrl;
    data['sub_title'] = subTitle;
    data['text_length'] = textLength;
    data['options'] = options;
    data['response_type'] = responseType;
    data['created_at'] = createdAt;
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