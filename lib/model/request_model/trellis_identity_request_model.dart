class TrellisIdentityRequestModel {
  String? userId;
  String? type;
  String? text;
  String? description;

  TrellisIdentityRequestModel({
    this.userId,
    this.type,
    this.text,
    this.description,

  });

  TrellisIdentityRequestModel.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    type = json['type'];
    text = json['text'];
    description = json['description'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['user_id'] = userId;
    data['type'] = type;
    data['text'] = text;
    data['description'] = description;
    return data;
  }
}

class TrellisUpdateIdentityRequestModel {
  String? id;
  String? type;
  String? text;
  String? description;


  TrellisUpdateIdentityRequestModel({
    this.id,
    this.type,
    this.text,
    this.description,
  });

  TrellisUpdateIdentityRequestModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    text = json['text'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['id'] = id;
    data['type'] = type;
    data['text'] = text;
    data['description'] = description;
    return data;
  }
}