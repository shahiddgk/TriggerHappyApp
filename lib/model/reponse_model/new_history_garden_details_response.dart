class NewGardenHistoryResponseDetailsModel {
  int? status;
  String? message;
  List<Data>? data;
  String? score;

  NewGardenHistoryResponseDetailsModel({this.status, this.message, this.data,this.score});

  NewGardenHistoryResponseDetailsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    score = json['score'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    data['score'] = score;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? id;
  String? userId;
  String? type;
  String? question;
  String? options;
  String? text;
  String? createdAt;

  Data(
      {this.id,
        this.userId,
        this.type,
        this.question,
        this.options,
        this.text,
        this.createdAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    type = json['type'];
    question = json['question'];
    options = json['options'];
    text = json['text'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['type'] = type;
    data['question'] = question;
    data['options'] = options;
    data['text'] = text;
    data['created_at'] = createdAt;
    return data;
  }
}