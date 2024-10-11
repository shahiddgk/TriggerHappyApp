// ignore: camel_case_types
// ignore_for_file: unnecessary_this, camel_case_types, duplicate_ignore

class Trellis_principle_data_model_class {
  String? id;
  String? userId;
  String? type;
  String? empTruths;
  String? powerlessBelieves;
  bool? visibility;
  String? favourite;

  Trellis_principle_data_model_class({
        this.id,
        this.userId,
        this.type,
        this.empTruths,
        this.powerlessBelieves,
        this.visibility,
        this.favourite,
      });

  Trellis_principle_data_model_class.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    type = json['type'];
    empTruths = json['emp_truths'];
    powerlessBelieves = json['powerless_believes'];
    visibility = json['visibility'] ?? false ;
    favourite = json['favourite'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['type'] = type;
    data['emp_truths'] = empTruths;
    data['powerless_believes'] = powerlessBelieves;
    data['visibility'] = visibility;
    data['favourite'] = favourite;
    return data;
  }
}

class TrellisResponseListModel {
  List<Trellis_principle_data_model_class> values = [];

  TrellisResponseListModel() {
    values = [];
  }

  TrellisResponseListModel.fromJson(var jsonObject) {
    for (var area in jsonObject) {
      Trellis_principle_data_model_class model = Trellis_principle_data_model_class.fromJson(area);
      this.values.add(model);
    }
  }
}