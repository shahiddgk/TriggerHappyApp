class OrganizingPrincipleAddFavouriteItem {
  String? responseId;
  String? favStatus;

  OrganizingPrincipleAddFavouriteItem({this.responseId,this.favStatus});

  OrganizingPrincipleAddFavouriteItem.fromJson(Map<String, dynamic> json) {
    responseId = json['entity_id'];
    favStatus = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['entity_id'] = responseId;
    data['status'] = favStatus;
    return data;
  }
}