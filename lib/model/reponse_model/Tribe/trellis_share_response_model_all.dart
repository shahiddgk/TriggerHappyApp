class TrellisShareResponseModel {
  int? status;
  String? message;
  TrellisDetailsItem? trellisDetailsItem;

  TrellisShareResponseModel({this.status, this.message, this.trellisDetailsItem});

  TrellisShareResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    trellisDetailsItem = json['data'] != null ? TrellisDetailsItem.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (trellisDetailsItem != null) {
      data['data'] = trellisDetailsItem!.toJson();
    }
    return data;
  }
}

class TrellisDetailsItem {
  List<Trellis>? trellis;
  List<Tribe>? tribe;
  List<Ladder>? ladder;
  List<Identity>? identity;
  List<Principles>? principles;

  TrellisDetailsItem({this.trellis, this.tribe, this.ladder, this.identity, this.principles});

  TrellisDetailsItem.fromJson(Map<String, dynamic> json) {
    if (json['trellis'] != null) {
      trellis = <Trellis>[];
      json['trellis'].forEach((v) {
        trellis!.add(Trellis.fromJson(v));
      });
    }
    if (json['tribe'] != null) {
      tribe = <Tribe>[];
      json['tribe'].forEach((v) {
        tribe!.add(Tribe.fromJson(v));
      });
    }
    if (json['ladder'] != null) {
      ladder = <Ladder>[];
      json['ladder'].forEach((v) {
        ladder!.add(Ladder.fromJson(v));
      });
    }
    if (json['identity'] != null) {
      identity = <Identity>[];
      json['identity'].forEach((v) {
        identity!.add(Identity.fromJson(v));
      });
    }
    if (json['principles'] != null) {
      principles = <Principles>[];
      json['principles'].forEach((v) {
        principles!.add(Principles.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (trellis != null) {
      data['trellis'] = trellis!.map((v) => v.toJson()).toList();
    }
    if (tribe != null) {
      data['tribe'] = tribe!.map((v) => v.toJson()).toList();
    }
    if (ladder != null) {
      data['ladder'] = ladder!.map((v) => v.toJson()).toList();
    }
    if (identity != null) {
      data['identity'] = identity!.map((v) => v.toJson()).toList();
    }
    if (principles != null) {
      data['principles'] = principles!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Trellis {
  String? id;
  String? name;
  String? nameDesc;
  String? purpose;

  Trellis({this.id, this.name, this.nameDesc, this.purpose});

  Trellis.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    nameDesc = json['name_desc'];
    purpose = json['purpose'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['name_desc'] = nameDesc;
    data['purpose'] = purpose;
    return data;
  }
}

class Tribe {
  String? id;
  String? userId;
  String? type;
  String? text;
  String? createdAt;

  Tribe({this.id, this.userId, this.type, this.text, this.createdAt});

  Tribe.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    type = json['type'];
    text = json['text'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['type'] = type;
    data['text'] = text;
    data['created_at'] = createdAt;
    return data;
  }
}

class Identity {
  String? id;
  String? userId;
  String? type;
  String? text;

  Identity({this.id, this.userId, this.type, this.text});

  Identity.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    type = json['type'];
    text = json['text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['type'] = type;
    data['text'] = text;
    return data;
  }
}

class Principles {
  String? id;
  String? userId;
  String? type;
  String? empTruths;
  String? powerlessBelieves;

  Principles(
      {this.id,
        this.userId,
        this.type,
        this.empTruths,
        this.powerlessBelieves});

  Principles.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    type = json['type'];
    empTruths = json['emp_truths'];
    powerlessBelieves = json['powerless_believes'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['type'] = type;
    data['emp_truths'] = empTruths;
    data['powerless_believes'] = powerlessBelieves;
    return data;
  }
}

class Ladder {
  String? id;
  String? userId;
  String? level;
  String? seed;
  String? responseId;
  String? type;
  String? favourite;
  String? option1;
  String? option2;
  String? date;
  String? text;
  String? description;
  String? createdAt;
  String? updatedAt;

  Ladder(
      {this.id,
        this.userId,
        this.level,
        this.seed,
        this.responseId,
        this.type,
        this.favourite,
        this.option1,
        this.option2,
        this.date,
        this.text,
        this.description,
        this.createdAt,
        this.updatedAt});

  Ladder.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    level = json['level'];
    seed = json['seed'];
    responseId = json['response_id'];
    type = json['type'];
    favourite = json['favourite'];
    option1 = json['option1'];
    option2 = json['option2'];
    date = json['date'];
    text = json['text'];
    description = json['description'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['level'] = level;
    data['seed'] = seed;
    data['response_id'] = responseId;
    data['type'] = type;
    data['favourite'] = favourite;
    data['option1'] = option1;
    data['option2'] = option2;
    data['date'] = date;
    data['text'] = text;
    data['description'] = description;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}