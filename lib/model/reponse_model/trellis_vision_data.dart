class TrellisVisionDataModel {
  String? vision;
  String? relationalVision;
  String? emotionalVision;
  String? physicalVision;
  String? workVision;
  String? financialVision;
  String? spiritualVision;

  TrellisVisionDataModel({
    this.vision,
    this.relationalVision,
    this.emotionalVision,
    this.physicalVision,
    this.workVision,
    this.financialVision,
    this.spiritualVision,
  });

  TrellisVisionDataModel.fromJson(Map<String, dynamic> json) {
    vision = json['vision'];
    relationalVision = json['relational_vision'];
    emotionalVision = json['emotional_vision'];
    physicalVision = json['physical_vision'];
    workVision = json['work_vision'];
    financialVision = json['financial_vision'];
    spiritualVision = json['spiritual_vision'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['vision'] = vision;
    data['relational_vision'] = relationalVision;
    data['emotional_vision'] = emotionalVision;
    data['physical_vision'] = physicalVision;
    data['work_vision'] = workVision;
    data['financial_vision'] = financialVision;
    data['spiritual_vision'] = spiritualVision;
    return data;
  }
}