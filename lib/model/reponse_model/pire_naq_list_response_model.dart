class PireNaqListResponseModel {
  int? status;
  List<PireNaqListItem>? responses;

  PireNaqListResponseModel({this.status, this.responses});

  PireNaqListResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['responses'] != null) {
      responses = <PireNaqListItem>[];
      json['responses'].forEach((v) {
        responses!.add(PireNaqListItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (responses != null) {
      data['responses'] = responses!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PireNaqListItem {
  String? type;
  String? responseId;
  String? createdAt;
  String? score;

  PireNaqListItem({this.type, this.responseId, this.createdAt,this.score});

  PireNaqListItem.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    responseId = json['response_id'];
    createdAt = json['created_at'];
    score = json['score'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['response_id'] = responseId;
    data['created_at'] = createdAt;
    data['score'] = score;
    return data;
  }
}

class PireNaqSingleItemResponseModel {
  int? status;
  List<PireNaqQuestionItem>? responses;

  PireNaqSingleItemResponseModel({this.status, this.responses});

  PireNaqSingleItemResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['responses'] != null) {
      responses = <PireNaqQuestionItem>[];
      json['responses'].forEach((v) {
        responses!.add(PireNaqQuestionItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (responses != null) {
      data['responses'] = responses!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PireNaqQuestionItem {
  String? options;
  String? text;
  String? responseId;
  String? title;

  PireNaqQuestionItem({this.options, this.text, this.responseId, this.title});

  PireNaqQuestionItem.fromJson(Map<String, dynamic> json) {
    options = json['options'];
    text = json['text'];
    responseId = json['response_id'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['options'] = options;
    data['text'] = text;
    data['response_id'] = responseId;
    data['title'] = title;
    return data;
  }
}