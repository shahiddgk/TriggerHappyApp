class SharedListItemDetail {
  String? type;
  String? entityId;

  SharedListItemDetail({this.type,this.entityId});

  SharedListItemDetail.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    entityId = json['entity_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['entity_id'] = entityId;
    return data;
  }
}