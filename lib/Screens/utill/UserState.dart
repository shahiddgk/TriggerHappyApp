
import 'package:flutter_quiz_app/Screens/utill/userConstants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserStatePrefrence {

  late SharedPreferences _sharedPreferences;

  setAnswerText(bool isLoggedIn,String userType,String userName,String userEmail,String userId,String userTimezone,String allowEmail) async {
    print("Submission called Successfully");
    _sharedPreferences = await SharedPreferences.getInstance();

    _sharedPreferences.setBool(UserConstants().userLoggedIn, isLoggedIn);
    _sharedPreferences.setString(UserConstants().userType, userType);
    _sharedPreferences.setString(UserConstants().userName, userName);
    _sharedPreferences.setString(UserConstants().userEmail, userEmail);
    _sharedPreferences.setString(UserConstants().userId, userId);
    _sharedPreferences.setString(UserConstants().timeZone, userTimezone);
    _sharedPreferences.setString(UserConstants().allowEmail, allowEmail);
  }

  clearAnswerText() async {
    _sharedPreferences = await SharedPreferences.getInstance();

    print("Clearing data of answers");
    _sharedPreferences.remove(UserConstants().userLoggedIn);
    _sharedPreferences.remove(UserConstants().userType);
    _sharedPreferences.remove(UserConstants().userName);
    _sharedPreferences.remove(UserConstants().userEmail);
    _sharedPreferences.remove(UserConstants().userId);
    _sharedPreferences.remove(UserConstants().timeZone);
    _sharedPreferences.remove(UserConstants().allowEmail);
  }

}