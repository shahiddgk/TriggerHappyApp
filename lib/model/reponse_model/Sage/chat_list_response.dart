class ChatMessageListResponse {
  int? status;
  List<ChatMessage>? response;

  ChatMessageListResponse({this.status, this.response});

  ChatMessageListResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['response'] != null) {
      response = <ChatMessage>[];
      json['response'].forEach((v) {
        response!.add(ChatMessage.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (response != null) {
      data['response'] = response!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ChatMessage {
  String? id;
  String? senderId;
  String? receiverId;
  String? entryText;
  String? chatId;
  String? createdAt;

  ChatMessage(
      {this.id,
        this.senderId,
        this.receiverId,
        this.entryText,
        this.chatId,
        this.createdAt});

  ChatMessage.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    senderId = json['sender_id'];
    receiverId = json['receiver_id'];
    entryText = json['entry_text'];
    chatId = json['chat_id'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['sender_id'] = senderId;
    data['receiver_id'] = receiverId;
    data['entry_text'] = entryText;
    data['chat_id'] = chatId;
    data['created_at'] = createdAt;
    return data;
  }
}