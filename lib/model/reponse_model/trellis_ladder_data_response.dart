// ignore_for_file: unnecessary_this

class TrellisLadderDataModel {
  String? id;
  String? userId;
  String? type;
  String? favourite;
  String? option1;
  String? option2;
  String? date;
  String? text;
  String? description;
  bool? isExpired;

  TrellisLadderDataModel(
      {this.id,
        this.userId,
        this.type,
        this.favourite,
        this.option1,
        this.option2,
        this.date,
        this.text,
        this.description,
      this.isExpired});

  TrellisLadderDataModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    type = json['type'];
    favourite = json['favourite'];
    option1 = json['option1'];
    option2 = json['option2'] ?? "";
    date = json['date'];
    text = json['text'];
    description = json['description'];
    isExpired = false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['type'] = this.type;
    data['favourite'] = this.favourite;
    data['option1'] = this.option1;
    data['option2'] = this.option2;
    data['date'] = this.date;
    data['text'] = this.text;
    data['description'] = this.description;
    isExpired = this.isExpired;
    return data;
  }
}

class TrellisLadderDataListModel {
  List<TrellisLadderDataModel> values = [];


  int get length => values.length;

  TrellisLadderDataListModel() {
    values = [];
  }

  TrellisLadderDataListModel.fromJson(var jsonObject) {
    for (var area in jsonObject) {
      TrellisLadderDataModel model = TrellisLadderDataModel.fromJson(area);
      this.values.add(model);
    }
  }
}