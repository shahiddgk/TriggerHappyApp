// ignore_for_file: constant_identifier_names

class ApplicationURLs {

  static const BASE_URL_APP = "https://burgeon.trueincrease.com/api/";
  static const BASE_URL_FOR_MOBILE_IMAGES = "https://burgeon.trueincrease.com/uploads/mobile_tree/";
  static const BASE_URL_FOR_IPAD_IMAGES = "https://burgeon.trueincrease.com/uploads/ipad_tree/";

  //Authentication
  static const API_REGISTER_USER = "${BASE_URL_APP}signup";
  static const API_REGISTER_USER_WITH_GOOGLE = "${BASE_URL_APP}social_login";
  static const API_TREE_GROWTH = "${BASE_URL_APP}growth_tree";
  static const API_CHANGE_PASSWORD = "${BASE_URL_APP}change_password";
  static const API_CHANGE_PROFILE = "${BASE_URL_APP}update_profile";
  static const API_LOGIN = "${BASE_URL_APP}login";
  static const API_QUESTIONS = "${BASE_URL_APP}questions";
  static const API_ANSWER = "${BASE_URL_APP}user_response";
  static const API_DELETE = "${BASE_URL_APP}delete_user";
  static const API_FORGOT_PASSWORD = "${BASE_URL_APP}forgot_password";
  static const API_RESPONSE_EMAIL = "${BASE_URL_APP}response_submit_mail";
  static const API_EMAIL_RESPONSE = "${BASE_URL_APP}get_email";
  static const API_RESPONSE_HISTORY = "${BASE_URL_APP}response_history";
  static const API_LOGOUT = "${BASE_URL_APP}logout";
}
