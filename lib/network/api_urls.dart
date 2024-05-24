// ignore_for_file: constant_identifier_names

class ApplicationURLs {

  static const BASE_URL_FOR_TEST_PAYMENT = "https://staging.burgeon.app/api/";


  //Staging Base URL
  //    static const BASE_URL_APP = "https://staging.burgeon.app/api/";
  //Live Base URL
  // static const BASE_URL_APP = "https://dashboard.burgeon.app/api/";
  static const BASE_URL_APP = "https://dashboard.burgeon.app/staging/api/";
  static const BASE_URL_FOR_MOBILE_IMAGES = "https://dashboard.burgeon.app/uploads/";
  // static const BASE_URL_FOR_IPAD_IMAGES = "https://dashboard.burgeon.app/uploads/ipad_tree/";
  static const stripeTokenUrl = "https://api.stripe.com/v1/tokens";
  static const API_STRIPE_PAYMENT_URL = "${BASE_URL_APP}stripe_payment";
  static const API_STRIPE_CANCEL_SUBSCRIPTION_URL = "${BASE_URL_APP}subscription_cancel";
  static const API_SUBSCRIPTION_DETAILS_READ = "${BASE_URL_APP}subscription_details";


  //Stripe details key
  static const API_STRIPE_KEY_DETAILS = "${BASE_URL_APP}payment_settings";

  // Pro Users
  static const API_PRO_USERS = "${BASE_URL_APP}pro_users";

  // Admin Access
  static const API_ADMIN_ACCESS = "${BASE_URL_APP}admin_access";

  static const API_ALL_APP_SHARE = "${BASE_URL_APP}app_share_insert";

  //Authentication
  static const API_REGISTER_USER = "${BASE_URL_APP}signup";
  static const API_REGISTER_USER_WITH_GOOGLE = "${BASE_URL_APP}social_login";
  static const API_TREE_GROWTH = "${BASE_URL_APP}growth_tree";
  static const API_SET_LEVE_SWITCH = "${BASE_URL_APP}level_switch";
  static const API_CHANGE_PASSWORD = "${BASE_URL_APP}change_password";
  static const API_CHANGE_PROFILE = "${BASE_URL_APP}update_profile";
  static const API_LOGIN = "${BASE_URL_APP}login";
  static const API_QUESTIONS = "${BASE_URL_APP}questions";
  static const API_ANSWER = "${BASE_URL_APP}user_response";
  static const API_DELETE = "${BASE_URL_APP}delete_user";
  static const API_FORGOT_PASSWORD = "${BASE_URL_APP}forgot_password";
  static const API_RESPONSE_PIRE = "${BASE_URL_APP}response_submit_pire";
  static const API_EMAIL_RESPONSE = "${BASE_URL_APP}get_email";
  static const API_RESPONSE_HISTORY = "${BASE_URL_APP}response_history";
  static const API_LOGOUT = "${BASE_URL_APP}logout";
  static const API_USER_DETAILS = "${BASE_URL_APP}user_detail";

  //Trellis Api's
  static const API_TRELLIS_SHARE = "${BASE_URL_APP}trellis_share_insert";
  static const API_SHARE_READ = "${BASE_URL_APP}share_trellis_read";

  static const API_TRELLIS = "${BASE_URL_APP}trellis";
  static const API_TRELLIS_RESPONSE_TRIGGER = "${BASE_URL_APP}trellis_trigger";
  static const API_LADDER_RESPONSE_TRIGGER = "${BASE_URL_APP}ladder_trigger";
  static const API_TRIBE = "${BASE_URL_APP}tribe";
  static const API_TRELLIS_LADDER = "${BASE_URL_APP}ladder";
  static const API_TRELLIS_IDENTITY = "${BASE_URL_APP}identity";
  static const API_TRELLIS_PRINCIPLES = "${BASE_URL_APP}principles";
  static const API_TRELLIS_READ = "${BASE_URL_APP}trellis_read";
  static const API_TRELLIS_DELETE = "${BASE_URL_APP}trellis_delete";
  static const API_LADDER_EDIT_RESPONSE = "${BASE_URL_APP}ladder_update";
  static const API_TRIBE_EDIT_RESPONSE = "${BASE_URL_APP}tribe_update";
  static const API_TRELLIS_UPDATE_IDENTITY = "${BASE_URL_APP}identity_update";
  static const API_TRELLIS_UPDATE_PRINCIPLES = "${BASE_URL_APP}principles_update";

  static const API_TRELLIS_NEW_DATA_READ = "${BASE_URL_APP}new_tribe_read";
  static const API_NEW_TRELLIS_TRIBE_DELETE = "${BASE_URL_APP}new_tribe_delete";
  static const API_NEW_TRELLIS_TRIBE_INSERTION = "${BASE_URL_APP}new_tribe_insert";

  static const API_LADDER_FAVOURITE = "${BASE_URL_APP}add_fav_ladder";


//Column Data
  static const API_COLUMN_ADD = "${BASE_URL_APP}session_entry";
  static const API_COLUMN_READ = "${BASE_URL_APP}session_read";
  static const API_COLUMN_DELETE = "${BASE_URL_APP}session_delete";
  static const API_COLUMN_UPDATE = "${BASE_URL_APP}session_update";
  static const API_COLUMN_COMPLETE_TASK = "${BASE_URL_APP}completed_chk";

  static const API_APP_VERSION = "${BASE_URL_APP}app_version";

  //Naq  Api's
  static const API_NAQ_RESPONSE = "${BASE_URL_APP}naq_response";
  static const API_NAQ_DATA_EXIST_RESPONSE = "${BASE_URL_APP}naq_data_exist";
  static const API_PIRE_NAQ_LIST = "${BASE_URL_APP}all_answers_response";

  static const API_PIRE_SINGLE_ITEM_DETAILS = "${BASE_URL_APP}single_pire_response";
  static const API_NAQ_SINGLE_ITEM_DETAILS = "${BASE_URL_APP}single_naq_response";

  static const API_RESPONSE_NAQ = "${BASE_URL_APP}response_submit_naq";

  //Garden Api's
  static const API_GARDEN_NEW_HISTORY = "${BASE_URL_APP}new_response_history";
  static const API_GARDEN_HISTORY_DETAILS = "${BASE_URL_APP}history_details";

  static const API_LEVEL_HISTORY = "${BASE_URL_APP}level_history";
  static const API_LEVEL_HISTORY_DETAILS = "${BASE_URL_APP}level_history_details";

  static const API_GARDEN_LEVELS = "${BASE_URL_APP}garden_levels";

  //Post Api's
  static const API_POST_INSERT = "${BASE_URL_APP}insert_reminder";
  static const API_POST_READ = "${BASE_URL_APP}read_reminder";
  static const API_POST_EDIT = "${BASE_URL_APP}edit_reminder";
  static const API_POST_DELETE = "${BASE_URL_APP}delete_reminder";
  static const API_POST_UPDATE_STATUS = "${BASE_URL_APP}update_reminder_status";
  static const API_POST_SNOOZE_REMINDER = "${BASE_URL_APP}snooze_reminder";
  static const API_POST_STOP_REMINDER = "${BASE_URL_APP}reminder_stop";
  static const API_SKIP_REMINDERS_LIST = "${BASE_URL_APP}waitings_reminders";

  //Tribe Api's
  static const API_SAGE_CONNECTION_SEARCH_USER = "${BASE_URL_APP}search_user";
  static const API_SAGE_CONNECTION_LIST = "${BASE_URL_APP}chat_connection";
  static const API_SAGE_SEND_CONNECTION = "${BASE_URL_APP}connection_request";

  static const API_SAGE_CHAT_ROOM_INSERT = "${BASE_URL_APP}share_response";
  static const API_SAGE_SHARED_WITH_OTHER = "${BASE_URL_APP}share_with_other";
  static const API_SAGE_SHARED_WITH_COACH = "${BASE_URL_APP}paid_share_response";
  static const API_SAGE_SHARED_WITH_ME = "${BASE_URL_APP}share_with_me";
  static const API_SAGE_SHARED_ITEM_DETAILS = "${BASE_URL_APP}detail_share_response";

  static const API_SAGE_PAYMENT_FOR_COACH = "${BASE_URL_APP}sage_payment";

  static const API_ACCEPT_PENDING_PERMISSION = "${BASE_URL_APP}accept_shared_module";

  static const API_SAGE_CHAT_ROOM_READ = "${BASE_URL_APP}chat_room_read";
  static const API_SAGE_CONNECTION_DELETE = "${BASE_URL_APP}chat_connection_delete";
  static const API_SAGE_INVITED_CONNECTION_LIST = "${BASE_URL_APP}invite_notification";
  static const API_SAGE_ACCEPT_CONNECTION = "${BASE_URL_APP}accept_invite_app";
  static const API_SAGE_REJECT_CONNECTION = "${BASE_URL_APP}reject_invite_app";

  static const API_SAGE_ACCEPTED_CONNECTION_LIST = "${BASE_URL_APP}accept_connection";
  static const API_SAGE_PENDING_CONNECTION_LIST = "${BASE_URL_APP}pending_connection";
  static const API_SAGE_SENT_CONNECTION_LIST = "${BASE_URL_APP}send_connection";
  static const API_SAGE_PENDING_CONNECTION_COUNT = "${BASE_URL_APP}pending_connection_count";
  static const API_Tribe_PENDING_PERMISSION_LIST = "${BASE_URL_APP}approver_sending_request";
  static const API_Tribe_PENDING_PERMISSION_REQUEST_LIST = "${BASE_URL_APP}requester_sending_request";

  static const API_SAGE_FEEDBACK = "${BASE_URL_APP}sage_feedback";
  static const API_SAGE_FEEDBACK_LIST_READ = "${BASE_URL_APP}read_sage_feedback";

  static const API_TRIBE_FULL_MODULE_DETAIL = "${BASE_URL_APP}module_details";
  static const API_TRIBE_SINGLE_TYPE_LIST = "${BASE_URL_APP}single_type_list";
  static const API_TRIBE_SINGLE_RESPONSE_DETAIL = "${BASE_URL_APP}detail_share_response";
  static const API_TRIBE_EDIT_MODULE_TYPE = "${BASE_URL_APP}edit_module";
  static const API_TRIBE_EDIT_MODULE_ACCEPT_NO_TYPE = "${BASE_URL_APP}pending_connection_update";
  static const API_TRIBE_MODULE_TYPE_LIST = "${BASE_URL_APP}module_type_list";

  static const API_ALL_SINGLE_SHARED_ITEM = "${BASE_URL_APP}single_share_list";
  static const API_SINGLE_SHARED_ITEM_DELETE = "${BASE_URL_APP}delete_single_share";

  //Tree Section Seed Option
  static const API_GARDEN_SEED = "${BASE_URL_APP}garden_seed";

  //User Activity
  static const API_USER_ACTIVITY_DETAIL = "${BASE_URL_APP}user_activity";


}
