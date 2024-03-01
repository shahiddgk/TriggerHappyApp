class SearchConnectionUserRequestModel {
  String? senderId;

  SearchConnectionUserRequestModel({this.senderId});

  SearchConnectionUserRequestModel.fromJson(Map<String, dynamic> json) {
    senderId = json['sender_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sender_id'] = senderId;
    return data;
  }
}