class SharedListItemAddRequest {
  String? senderId;
  String? recieverId;
  String? type;
  String? chatId;
  String? entityId;

  SharedListItemAddRequest({this.senderId,this.recieverId,this.type,this.chatId,this.entityId});

  SharedListItemAddRequest.fromJson(Map<String, dynamic> json) {
    senderId = json['requester_id'];
    recieverId = json['receivers'];
    type = json['type'];
    chatId = json['connection_ids'];
    entityId = json['entity_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['requester_id'] = senderId;
    data['receivers'] = recieverId;
    data['type'] = type;
    data['connection_ids'] = chatId;
    data['entity_id'] = entityId;
    return data;
  }
}