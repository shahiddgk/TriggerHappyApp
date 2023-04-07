
class UserResponseRequestModel {
  String? name;
  String? email;
  String? userId;
  String? answerMap;

  UserResponseRequestModel({this.name,this.email, this.userId,this.answerMap});

  UserResponseRequestModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    userId = json['user_id'];
    answerMap = json['answers'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['email'] = this.email;
    data['user_id'] = this.userId;
    data['answers'] = this.answerMap;
    return data;
  }
}