class PendingPermissionRequestModel {
  String? permission;
  String? connectionId;
  String? approverId;

  PendingPermissionRequestModel({this.permission,this.connectionId,this.approverId});

  PendingPermissionRequestModel.fromJson(Map<String, dynamic> json) {
    permission = json['permission'];
    connectionId = json['connection_id'];
    approverId = json['approver_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['permission'] = permission;
    data['connection_id'] = connectionId;
    data['approver_id'] = approverId;
    return data;
  }
}