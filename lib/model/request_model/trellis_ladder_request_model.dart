class TrellisLadderGoalsRequestModel {
  String? userId;
  String? type;
  String? option1;
  String? option2;
  String? date;
  String? title;
  String? description;

  TrellisLadderGoalsRequestModel({
    this.userId,
    this.type,
    this.option1,
    this.option2,
    this.date,
    this.title,
    this.description
  });

  TrellisLadderGoalsRequestModel.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    type = json['type'];
    option1 = json['option1'];
    option2 = json['option2'];
    date = json['date'];
    title = json['text'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['user_id'] = userId;
    data['type'] = type;
    data['option1'] = option1;
    data['option2'] = option2;
    data['date'] = date;
    data['text'] = title;
    data['description'] = description;
    return data;
  }
}

class TrellisLadderAchievementRequestModel {
  String? userId;
  String? type;
  String? option1;
  String? date;
  String? title;
  String? description;

  TrellisLadderAchievementRequestModel({
    this.userId,
    this.type,
    this.option1,
    this.date,
    this.title,
    this.description
  });

  TrellisLadderAchievementRequestModel.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    type = json['type'];
    option1 = json['option1'];
    date = json['date'];
    title = json['text'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['user_id'] = userId;
    data['type'] = type;
    data['option1'] = option1;
    data['date'] = date;
    data['text'] = title;
    data['description'] = description;
    return data;
  }
}