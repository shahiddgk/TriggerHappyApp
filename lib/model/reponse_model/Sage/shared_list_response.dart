class SharedListResponse {
  int? status;
  List<ResponsesForMe>? responses;

  SharedListResponse({this.status, this.responses});

  SharedListResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['responses'] != null) {
      responses = <ResponsesForMe>[];
      json['responses'].forEach((v) {
        responses!.add(ResponsesForMe.fromJson(v));
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

class ResponsesForMe {
  String? id;
  String? senderId;
  String? receiverId;
  String? type;
  String? entryText;
  String? chatId;
  String? entityId;
  String? readAt;
  String? createdAt;
  String? paid;
  String? receiverName;

  ResponsesForMe(
      {this.id,
        this.senderId,
        this.receiverId,
        this.type,
        this.entryText,
        this.chatId,
        this.entityId,
        this.readAt,
        this.createdAt,
        this.paid,
        this.receiverName});

  ResponsesForMe.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    senderId = json['requester_id'];
    receiverId = json['approver_id'];
    type = json['type'];
    entryText = json['entry_text'];
    chatId = json['chat_id'];
    entityId = json['entity_id'];
    readAt = json['read_at'];
    createdAt = json['created_at'];
    paid = json['paid'].toString();
    receiverName = json['approver_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['requester_id'] = senderId;
    data['approver_id'] = receiverId;
    data['type'] = type;
    data['entry_text'] = entryText;
    data['chat_id'] = chatId;
    data['entity_id'] = entityId;
    data['read_at'] = readAt;
    data['created_at'] = createdAt;
    data['paid'] = paid.toString();
    data['approver_name'] = receiverName;
    return data;
  }
}

class SharedListResponseForOther {
  int? status;
  List<ResponsesForOther>? responses;

  SharedListResponseForOther({this.status, this.responses});

  SharedListResponseForOther.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['responses'] != null) {
      responses = <ResponsesForOther>[];
      json['responses'].forEach((v) {
        responses!.add(ResponsesForOther.fromJson(v));
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

class ResponsesForOther {
  String? id;
  String? senderId;
  String? receiverId;
  String? type;
  String? entryText;
  String? chatId;
  String? entityId;
  String? readAt;
  String? createdAt;
  String? paid;
  String? senderName;

  ResponsesForOther(
      {this.id,
        this.senderId,
        this.receiverId,
        this.type,
        this.entryText,
        this.chatId,
        this.entityId,
        this.readAt,
        this.createdAt,
        this.paid,
        this.senderName});

  ResponsesForOther.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    senderId = json['sender_id'];
    receiverId = json['receiver_id'];
    type = json['type'];
    entryText = json['entry_text'];
    chatId = json['chat_id'];
    entityId = json['entity_id'];
    readAt = json['read_at'];
    createdAt = json['created_at'];
    paid = json['paid'].toString();
    senderName = json['sender_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['sender_id'] = senderId;
    data['receiver_id'] = receiverId;
    data['type'] = type;
    data['entry_text'] = entryText;
    data['chat_id'] = chatId;
    data['entity_id'] = entityId;
    data['read_at'] = readAt;
    data['created_at'] = createdAt;
    data['paid'] = paid.toString();
    data['sender_name'] = senderName;
    return data;
  }
}