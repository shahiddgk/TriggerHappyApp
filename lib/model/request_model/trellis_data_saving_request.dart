class TrellisDataRequestModel {
  String? userId;
  String? name;
  String? nameDescription;
  String? purpose;
  String? mentor;
  // String? mentorDescription;
  String? peer;
  // String? peerDescription;
  String? mentee;
  // String? menteeDescription;

  TrellisDataRequestModel({
    this.userId,
    this.name,
    this.nameDescription,
    this.purpose,
    this.mentor,
    // this.mentorDescription,
    this.peer,
    // this.peerDescription,
    this.mentee,
    // this.menteeDescription
  });

  TrellisDataRequestModel.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    name = json['name'];
    nameDescription = json['name_desc'];
    purpose = json['purpose'];
    mentor = json['mentor'];
    // mentorDescription = json['mentor_desc'];
    peer = json['peer'];
    // peerDescription = json['peer_desc'];
    mentee = json['mentee'];
    // menteeDescription = json['mentee_desc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['user_id'] = userId;
    data['name'] = name;
     data['name_desc'] = nameDescription;
    data['purpose'] = purpose;
    data['mentor'] = mentor;
    // data['mentor_desc'] = mentorDescription;
    data['peer'] = peer;
    // data['peer_desc'] = peerDescription;
    data['mentee'] = mentee;
    // data['mentee_desc'] = menteeDescription;
    return data;
  }
}