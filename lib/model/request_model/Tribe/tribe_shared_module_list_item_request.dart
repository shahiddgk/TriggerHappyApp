class TribeSharedModuleRequestModel {
  String? connectionId;

  TribeSharedModuleRequestModel({this.connectionId});

  TribeSharedModuleRequestModel.fromJson(Map<String, dynamic> json) {
    connectionId = json['connection_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['connection_id'] = connectionId;
    return data;
  }
}