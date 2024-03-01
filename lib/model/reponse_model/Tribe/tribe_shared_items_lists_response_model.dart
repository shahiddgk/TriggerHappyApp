class SharePireResponseModel {
  int? status;
  String? message;
  List<NaqPireDataItem>? data;

  SharePireResponseModel({this.status, this.message, this.data});

  SharePireResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <NaqPireDataItem>[];
      json['data'].forEach((v) {
        data!.add(NaqPireDataItem.fromJson(v));
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

class NaqPireDataItem {
  int? group;
  String? createdAt;
  String? score;
  List<NaqPireDataItemDetail>? response;

  NaqPireDataItem({this.group, this.response,this.createdAt});

  NaqPireDataItem.fromJson(Map<String, dynamic> json) {
    group = json['group'];
    createdAt = json['created_at'];
    score = json['score']??"";
    if (json['response'] != null) {
      response = <NaqPireDataItemDetail>[];
      json['response'].forEach((v) {
        response!.add(NaqPireDataItemDetail.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['group'] = group;
    data['created_at'] = createdAt;
    data['score'] = score;
    if (response != null) {
      data['response'] = response!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class NaqPireDataItemDetail {
  Question? question;
  Answer? answer;

  NaqPireDataItemDetail({this.question, this.answer});

  NaqPireDataItemDetail.fromJson(Map<String, dynamic> json) {
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
  String? responseId;
  String? type;
  String? options;
  String? text;
  String? questionId;

  Answer(
      {this.id,
        this.responseId,
        this.type,
        this.options,
        this.text,
        this.questionId});

  Answer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    responseId = json['response_id'];
    type = json['type'];
    options = json['options'];
    text = json['text'];
    questionId = json['question_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['response_id'] = responseId;
    data['type'] = type;
    data['options'] = options;
    data['text'] = text;
    data['question_id'] = questionId;
    return data;
  }
}


class ShareColumnResponseModel {
  int? status;
  String? message;
  List<ColumnDataItem>? columnDataItem;

  ShareColumnResponseModel({this.status, this.message, this.columnDataItem});

  ShareColumnResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      columnDataItem = <ColumnDataItem>[];
      json['data'].forEach((v) {
        columnDataItem!.add(ColumnDataItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (columnDataItem != null) {
      data['data'] = columnDataItem!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ColumnDataItem {
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
  String? definedBy;
  String? createdAt;

  ColumnDataItem(
      {this.id,
        this.userId,
        this.level,
        this.seed,
        this.responseId,
        this.entryTitle,
        this.entryDecs,
        this.entryDate,
        this.entryTakeaway,
        this.entryType,
        this.definedBy,
        this.createdAt});

  ColumnDataItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    level = json['level'];
    seed = json['seed'];
    responseId = json['response_id'];
    entryTitle = json['entry_title'];
    entryDecs = json['entry_decs'];
    entryDate = json['entry_date'];
    entryTakeaway = json['entry_takeaway'];
    entryType = json['entry_type'];
    definedBy = json['defined_by'];
    createdAt = json['created_at'];
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
    data['defined_by'] = definedBy;
    data['created_at'] = createdAt;
    return data;
  }
}

class ShareLadderResponseModel {
  int? status;
  String? message;
  List<LadderDataItem>? ladderDataItemList;

  ShareLadderResponseModel({this.status, this.message, this.ladderDataItemList});

  ShareLadderResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      ladderDataItemList = <LadderDataItem>[];
      json['data'].forEach((v) {
        ladderDataItemList!.add(LadderDataItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (ladderDataItemList != null) {
      data['data'] = ladderDataItemList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LadderDataItem {
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

  LadderDataItem(
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

  LadderDataItem.fromJson(Map<String, dynamic> json) {
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


/// Single Shared Item List

class ShareSingleItemResponseModel {
  int? status;
  List<ShareSingleItem>? responses;

  ShareSingleItemResponseModel({this.status, this.responses});

  ShareSingleItemResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['responses'] != null) {
      responses = <ShareSingleItem>[];
      json['responses'].forEach((v) {
        responses!.add(ShareSingleItem.fromJson(v));
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

class ShareSingleItem {
  String? id;
  String? senderId;
  String? receiverId;
  String? type;
  String? paid;
  String? connectionId;
  String? entityId;
  String? status;
  String? createdAt;
  String? senderName;

  ShareSingleItem(
      {this.id,
        this.senderId,
        this.receiverId,
        this.type,
        this.paid,
        this.connectionId,
        this.entityId,
        this.status,
        this.createdAt,
        this.senderName});

  ShareSingleItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    senderId = json['sender_id'];
    receiverId = json['receiver_id'];
    type = json['type'];
    paid = json['paid'];
    connectionId = json['connection_id'];
    entityId = json['entity_id'];
    status = json['status'];
    createdAt = json['created_at'];
    senderName = json['sender_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['sender_id'] = senderId;
    data['receiver_id'] = receiverId;
    data['type'] = type;
    data['paid'] = paid;
    data['connection_id'] = connectionId;
    data['entity_id'] = entityId;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['sender_name'] = senderName;
    return data;
  }
}