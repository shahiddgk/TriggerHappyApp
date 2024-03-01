class TrellisShareRequest {
  String? connectionId;
  String? moduleType;
  // String? requesterId;
  // String? approverId;

  TrellisShareRequest({
    this.connectionId,
    this.moduleType,
  });

  TrellisShareRequest.fromJson(Map<String, dynamic> json) {
    connectionId = json['connection_id'];
    moduleType = json['module_type'];
    // requesterId = json['requester_id'];
    // approverId = json['approver_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['connection_id'] = connectionId;
    data['module_type'] = moduleType;
    // data['requester_id'] = requesterId;
    // data['approver_id'] = approverId;

    return data;
  }
}