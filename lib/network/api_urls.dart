// ignore_for_file: constant_identifier_names

class ApplicationURLs {

  static const BASE_URL_APP = "https://dashboard.burgeon.app/api/";
  static const BASE_URL_FOR_MOBILE_IMAGES = "https://dashboard.burgeon.app/uploads/mobile_tree/";
  static const BASE_URL_FOR_IPAD_IMAGES = "https://dashboard.burgeon.app/uploads/ipad_tree/";
  static const stripeTokenUrl = "https://api.stripe.com/v1/tokens";
  static const API_STRIPE_PAYMENT_URL = "${BASE_URL_APP}stripe_payment";
  static const API_STRIPE_CANCEL_SUBSCRIPTION_URL = "${BASE_URL_APP}subscription_cancel";
  static const API_SUBSCRIPTION_DETAILS_READ = "${BASE_URL_APP}subscription_details";

  //Stripe details key
  static const API_STRIPE_KEY_DETAILS = "${BASE_URL_APP}payment_settings";

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

  //Trellis Api's
  static const API_TRELLIS = "${BASE_URL_APP}trellis";
  static const API_TRELLIS_RESPONSE_TRIGGER = "${BASE_URL_APP}trellis_trigger";
  static const API_TRIBE = "${BASE_URL_APP}tribe";
  static const API_TRELLIS_LADDER = "${BASE_URL_APP}ladder";
  static const API_TRELLIS_IDENTITY = "${BASE_URL_APP}identity";
  static const API_TRELLIS_PRINCIPLES = "${BASE_URL_APP}principles";
  static const API_TRELLIS_READ = "${BASE_URL_APP}trellis_read";
  static const API_TRELLIS_DELETE = "${BASE_URL_APP}trellis_delete";

  static const API_LADDER_FAVOURITE = "${BASE_URL_APP}add_fav_ladder";

  static const API_COLUMN_ADD = "${BASE_URL_APP}session_entry";
  static const API_COLUMN_READ = "${BASE_URL_APP}session_read";
  static const API_COLUMN_DELETE = "${BASE_URL_APP}session_delete";

  static const API_APP_VERSION = "${BASE_URL_APP}app_version";

  //Naq  Api's
  static const API_NAQ_RESPONSE = "${BASE_URL_APP}naq_response";
  static const API_RESPONSE_NAQ = "${BASE_URL_APP}response_submit_naq";
}
