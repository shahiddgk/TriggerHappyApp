class TribeSharedRequestModel {
  String? userId;
  String? dataType;

  TribeSharedRequestModel({this.userId,this.dataType});

  TribeSharedRequestModel.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    dataType = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['type'] = dataType;
    return data;
  }
}

class TribeSingleSharedRequestModel {
  String? connectionId;
  String? dataType;
  String? requesterId;

  TribeSingleSharedRequestModel({this.connectionId,this.dataType,this.requesterId});

  TribeSingleSharedRequestModel.fromJson(Map<String, dynamic> json) {
    connectionId = json['connection_id'];
    dataType = json['module_type'];
    requesterId = json['approver_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['connection_id'] = connectionId;
    data['module_type'] = dataType;
    data['approver_id'] = requesterId;
    return data;
  }
}