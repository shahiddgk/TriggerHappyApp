class ColumnReadDataModel {
  String? id;
  String? userId;
  String? entryTitle;
  String? entryDecs;
  String? entryDate;
  String? entryTakeaway;
  String? entryType;
  String? definedBy;
  String? completed;
  String? createdAt;

  ColumnReadDataModel(
      {this.id,
        this.userId,
        this.entryTitle,
        this.entryDecs,
        this.entryDate,
        this.entryType,
        this.entryTakeaway,
        this.definedBy,
        this.completed,
        this.createdAt});

  ColumnReadDataModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    entryTitle = json['entry_title'];
    entryDecs = json['entry_decs'];
    entryDate = json['entry_date'];
    entryType = json['entry_type'];
    entryTakeaway = json['entry_takeaway'];
    definedBy = json['defined_by'];
    completed = json['completed'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['entry_title'] = entryTitle;
    data['entry_decs'] = entryDecs;
    data['entry_date'] = entryDate;
    data['entry_type'] = entryType;
    data['entry_takeaway'] = entryTakeaway;
    data['defined_by'] = definedBy;
    data['completed'] = completed;
    data['created_at'] = createdAt;
    return data;
  }
}

class ColumnReadResponseListModel {
  List<ColumnReadDataModel> values = [];

  ColumnReadResponseListModel() {
    values = [];
  }

  ColumnReadResponseListModel.fromJson(var jsonObject) {
    for (var area in jsonObject) {
      ColumnReadDataModel model = ColumnReadDataModel.fromJson(area);
      values.add(model);
    }
  }
}