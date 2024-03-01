class TribeAllSingleSharedRequestModel {
  String? requesterId;

  TribeAllSingleSharedRequestModel({this.requesterId});

  TribeAllSingleSharedRequestModel.fromJson(Map<String, dynamic> json) {
    requesterId = json['requester_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['requester_id'] = requesterId;
    return data;
  }
}

class TribeSingleSharedDeleteRequestModel {
  String? singleShareId;

  TribeSingleSharedDeleteRequestModel({this.singleShareId});

  TribeSingleSharedDeleteRequestModel.fromJson(Map<String, dynamic> json) {
    singleShareId = json['delete_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['delete_id'] = singleShareId;
    return data;
  }
}