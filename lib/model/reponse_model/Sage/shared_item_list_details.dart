class SharedItemDetailsResponse {
  int? status;
  String? message;
  List<Data>? data;

  SharedItemDetailsResponse({this.status, this.message, this.data});

  SharedItemDetailsResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
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
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  Question? question;
  Answer? answer;

  Data({this.question, this.answer});

  Data.fromJson(Map<String, dynamic> json) {
    question = json['question'] != null
        ? Question.fromJson(json['question'])
        : null;
    answer =
    json['answer'] != null ? Answer.fromJson(json['answer']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (question != null) {
      data['question'] = question!.toJson();
    }
    if (answer != null) {
      data['answer'] = answer!.toJson();
    }
    return data;
  }
}

class Question {
  String? title;

  Question({this.title});

  Question.fromJson(Map<String, dynamic> json) {
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    return data;
  }
}

class Answer {
  String? id;
  String? type;
  String? options;
  String? text;
  String? questionId;

  Answer({this.id, this.type, this.options, this.text, this.questionId});

  Answer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    options = json['options'];
    text = json['text'];
    questionId = json['question_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['type'] = type;
    data['options'] = options;
    data['text'] = text;
    data['question_id'] = questionId;
    return data;
  }
}

class ColumnSharedItemDetail {
  int? status;
  String? message;
  ColumnData? data;

  ColumnSharedItemDetail({this.status, this.message, this.data});

  ColumnSharedItemDetail.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? ColumnData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class ColumnData {
  String? id;
  String? userId;
  String? level;
  String? seed;
  String? responseId;
  String? entryTitle;
  String? entryDecs;
  String? entryDate;
  String? entryTakeaway;
  String? entryType;

  ColumnData(
      {this.id,
        this.userId,
        this.level,
        this.seed,
        this.responseId,
        this.entryTitle,
        this.entryDecs,
        this.entryDate,
        this.entryTakeaway,
        this.entryType});

  ColumnData.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    userId = json['user_id'].toString();
    level = json['level'].toString();
    seed = json['seed'].toString();
    responseId = json['response_id'].toString();
    entryTitle = json['entry_title'].toString();
    entryDecs = json['entry_decs'].toString();
    entryDate = json['entry_date'].toString();
    entryTakeaway = json['entry_takeaway'].toString();
    entryType = json['entry_type'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['level'] = level;
    data['seed'] = seed;
    data['response_id'] = responseId;
    data['entry_title'] = entryTitle;
    data['entry_decs'] = entryDecs;
    data['entry_date'] = entryDate;
    data['entry_takeaway'] = entryTakeaway;
    data['entry_type'] = entryType;
    return data;
  }
}

class LadderSingleItemDetailsResponseModel {
  int? status;
  String? message;
  LadderSingle? data;

  LadderSingleItemDetailsResponseModel({this.status, this.message, this.data});

  LadderSingleItemDetailsResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? LadderSingle.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class LadderSingle {
  String? id;
  String? userId;
  String? level;
  String? seed;
  String? responseId;
  String? type;
  String? favourite;
  String? option1;
  String? option2;
  String? date;
  String? text;
  String? description;
  String? createdAt;
  String? updatedAt;

  LadderSingle(
      {this.id,
        this.userId,
        this.level,
        this.seed,
        this.responseId,
        this.type,
        this.favourite,
        this.option1,
        this.option2,
        this.date,
        this.text,
        this.description,
        this.createdAt,
        this.updatedAt});

  LadderSingle.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    level = json['level'];
    seed = json['seed'];
    responseId = json['response_id'];
    type = json['type'];
    favourite = json['favourite'];
    option1 = json['option1'];
    option2 = json['option2'];
    date = json['date'];
    text = json['text'];
    description = json['description'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['level'] = level;
    data['seed'] = seed;
    data['response_id'] = responseId;
    data['type'] = type;
    data['favourite'] = favourite;
    data['option1'] = option1;
    data['option2'] = option2;
    data['date'] = date;
    data['text'] = text;
    data['description'] = description;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}