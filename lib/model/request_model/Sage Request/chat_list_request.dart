class ChatRequestModel {
  String? chatId;

  ChatRequestModel({this.chatId});

  ChatRequestModel.fromJson(Map<String, dynamic> json) {
    chatId = json['chat_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['chat_id'] = chatId;
    return data;
  }
}