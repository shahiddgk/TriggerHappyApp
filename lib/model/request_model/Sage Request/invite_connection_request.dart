class InviteConnectionRequestModel {
  String? userId;
  String? email;
  String? role;
  String? module;

  InviteConnectionRequestModel({this.userId,this.module,this.email,this.role});

  InviteConnectionRequestModel.fromJson(Map<String, dynamic> json) {
    userId = json['requester_id'];
    email = json['approver_email'];
    role = json['role'];
    module = json['module'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['requester_id'] = userId;
    data['approver_email'] = email;
    data['role'] = role;
    data['module'] = module;
    return data;
  }
}

class EditConnectionRequestModel {
  String? connectionId;
  String? role;
  String? module;
  String? senderId;
  String? recieverId;

  EditConnectionRequestModel({this.connectionId,this.module,this.role,this.senderId,this.recieverId});

  EditConnectionRequestModel.fromJson(Map<String, dynamic> json) {
    connectionId = json['connection_id'];
    role = json['role'];
    module = json['module'];
    senderId = json['requester_id'];
    recieverId = json['approver_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['connection_id'] = connectionId;
    data['role'] = role;
    data['module'] = module;
    data['requester_id'] = senderId;
    data['approver_id'] = recieverId;
    return data;
  }
}


class EditConnectionAcceptNoRequestModel {
  String? connectionId;
  String? role;
  String? module;

  EditConnectionAcceptNoRequestModel({this.connectionId,this.module,this.role});

  EditConnectionAcceptNoRequestModel  .fromJson(Map<String, dynamic> json) {
    connectionId = json['connection_id'];
    role = json['role'];
    module = json['module'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['connection_id'] = connectionId;
    data['role'] = role;
    data['module'] = module;
    return data;
  }
}