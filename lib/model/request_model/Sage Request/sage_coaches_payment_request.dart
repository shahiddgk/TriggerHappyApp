class SageCoachesPayment {
  String? userId;
  String? token;
  String? recieverId;
  String? entityId;
  String? type;

  SageCoachesPayment({this.userId, this.token, this.recieverId,this.entityId,this.type});

  SageCoachesPayment.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'] ;
    token = json['token'] ;
    recieverId = json['approver_id'];
    entityId = json['entity_id'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['user_id'] = userId;
    data['token'] = token;
    data['approver_id'] = recieverId;
    data['entity_id'] = entityId;
    data['type'] = type;

    return data;
  }
}