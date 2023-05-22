class TribeDataRequestModel {
  String? userId;
  String? mentor;
  // String? mentorDescription;
  String? peer;
  // String? peerDescription;
  String? mentee;
  // String? menteeDescription;

  TribeDataRequestModel({
    this.userId,
    this.mentor,
    // this.mentorDescription,
    this.peer,
    // this.peerDescription,
    this.mentee,
    // this.menteeDescription
  });

  TribeDataRequestModel.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
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
    data['mentor'] = mentor;
    // data['mentor_desc'] = mentorDescription;
    data['peer'] = peer;
    // data['peer_desc'] = peerDescription;
    data['mentee'] = mentee;
    // data['mentee_desc'] = menteeDescription;
    return data;
  }
}