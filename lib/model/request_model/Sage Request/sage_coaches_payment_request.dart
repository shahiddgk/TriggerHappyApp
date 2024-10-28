class SageCoachesPayment {
  String? userId;
  String? token;
  String? recieverId;
  String? email;
  String? entityId;
  String? type;

  SageCoachesPayment({this.userId, this.token, this.recieverId,this.email,this.entityId,this.type});

  SageCoachesPayment.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'] ;
    token = json['token'] ;
    recieverId = json['approver_id'];
    email = json['approver_email'];
    entityId = json['entity_id'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['user_id'] = userId;
    data['token'] = token;
    data['approver_id'] = recieverId;
    data['approver_email'] = email;
    data['entity_id'] = entityId;
    data['type'] = type;

    return data;
  }
}