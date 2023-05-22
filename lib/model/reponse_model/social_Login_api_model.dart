class SocialLoginResponse {
  String? message;
  UserSession? userSession;

  SocialLoginResponse({this.message, this.userSession});

  SocialLoginResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    userSession = json['user_session'] != null
        ? UserSession.fromJson(json['user_session'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    if (userSession != null) {
      data['user_session'] = userSession!.toJson();
    }
    return data;
  }
}

class UserSession {
  bool? userLoggedIn;
  String? usertype;
  String? username;
  String? useremail;
  String? authID;
  String? userid;

  UserSession(
      {this.userLoggedIn,
        this.usertype,
        this.username,
        this.useremail,
        this.authID,
        this.userid});

  UserSession.fromJson(Map<String, dynamic> json) {
    userLoggedIn = json['user_logged_in'];
    usertype = json['usertype'];
    username = json['username'];
    useremail = json['useremail'];
    authID = json['authID'];
    userid = json['userid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_logged_in'] = userLoggedIn;
    data['usertype'] = usertype;
    data['username'] = username;
    data['useremail'] = useremail;
    data['authID'] = authID;
    data['userid'] = userid;
    return data;
  }
}