class SharedItemDetailsRequest {
  String? entityId;
  String? type;

  SharedItemDetailsRequest({this.entityId,this.type});

  SharedItemDetailsRequest.fromJson(Map<String, dynamic> json) {
    entityId = json['entity_id'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['entity_id'] = entityId;
    data['type'] = type;
    return data;
  }
}