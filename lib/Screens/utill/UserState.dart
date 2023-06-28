
// ignore_for_file: file_names, avoid_print

import 'package:flutter_quiz_app/Screens/utill/userConstants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserStatePrefrence {

  late SharedPreferences _sharedPreferences;

  setAnswerText(bool isLoggedIn,String userType,String userName,String userEmail,String userId,String userTimezone,String allowEmail,String userPremium,String userPremiumType,String userCustomerId,String userSubscriptionId) async {
    // print("Submission called Successfully");
    _sharedPreferences = await SharedPreferences.getInstance();

    _sharedPreferences.setBool(UserConstants().userLoggedIn, isLoggedIn);
    _sharedPreferences.setString(UserConstants().userType, userType);
    _sharedPreferences.setString(UserConstants().userName, userName);
    _sharedPreferences.setString(UserConstants().userEmail, userEmail);
    _sharedPreferences.setString(UserConstants().userId, userId);
    _sharedPreferences.setString(UserConstants().timeZone, userTimezone);
    _sharedPreferences.setString(UserConstants().allowEmail, allowEmail);
    _sharedPreferences.setString(UserConstants().userPremium, userPremium);
    _sharedPreferences.setString(UserConstants().userPremiumType, userPremiumType);
    _sharedPreferences.setString(UserConstants().userCustomerId, userCustomerId);
    _sharedPreferences.setString(UserConstants().userSubscriptionId, userSubscriptionId);
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
    _sharedPreferences.remove(UserConstants().userPremium);
    _sharedPreferences.remove(UserConstants().userPremiumType);
    _sharedPreferences.remove(UserConstants().userCustomerId);
    _sharedPreferences.remove(UserConstants().userSubscriptionId);

    _sharedPreferences.remove(TrellisScreenStatus().needsExpended);
    _sharedPreferences.remove(TrellisScreenStatus().purposeExpended);
    _sharedPreferences.remove(TrellisScreenStatus().ladderExpended);
    _sharedPreferences.remove(TrellisScreenStatus().needsExpended);
    _sharedPreferences.remove(TrellisScreenStatus().identityExpended);
    _sharedPreferences.remove(TrellisScreenStatus().oPExpended);
    _sharedPreferences.remove(TrellisScreenStatus().rhythmsExpended);
    _sharedPreferences.remove(TrellisScreenStatus().tribeExpended);

    _sharedPreferences.remove("answerList");
    _sharedPreferences.remove("NaqIndex");
    _sharedPreferences.remove("answer1forQ1");
    _sharedPreferences.remove("answer2forQ2");
    _sharedPreferences.remove("answerIdList");


  }

}