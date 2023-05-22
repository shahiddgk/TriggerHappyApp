class ColumnAddRequestModel {
  String? userId;
  String? title;
  String? description;
  String? date;
  String? takeAways;
  String? entryType;

  ColumnAddRequestModel({this.userId,this.title,this.description,this.date,this.takeAways,this.entryType});

  ColumnAddRequestModel.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    title = json['entry_title'];
    description = json['entry_decs'];
    date = json['entry_date'];
    takeAways = json['entry_takeaway'];
    entryType = json['entry_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['entry_title'] = title;
    data['entry_decs'] = description;
    data['entry_date'] = date;
    data['entry_takeaway'] = takeAways;
    data['entry_type'] = entryType;
    return data;
  }
}