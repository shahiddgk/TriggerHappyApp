import 'package:flutter_quiz_app/Screens/PireScreens/utills/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuestionStatePrefrence {

  late SharedPreferences _sharedPreferences;

  setAnswerText(String idKey,String idValue,String textKey,List<String> textValue,String typeKey,String typeValue) async {
    // print("Submission called Successfully");
    _sharedPreferences = await SharedPreferences.getInstance();
    _sharedPreferences.setString(idKey, idValue);
    _sharedPreferences.setString(typeKey,typeValue);
    _sharedPreferences.setStringList(textKey, textValue);
  }

  // setNAQAnswerList(String id,List<String> textValue) async {
  //   _sharedPreferences = await SharedPreferences.getInstance();
  //   _sharedPreferences.setString(id, idValue);
  //   _sharedPreferences.setString(typeKey,typeValue);
  //   _sharedPreferences.setStringList(textKey, textValue);
  // }

  clearAnswerText() async {
    _sharedPreferences = await SharedPreferences.getInstance();

      // print("Clearing data of answers");
      _sharedPreferences.remove(PireConstants.questionOneText);
      _sharedPreferences.remove(PireConstants.questionOneId);
      _sharedPreferences.remove(PireConstants.questionOneType);

    _sharedPreferences.remove(PireConstants.questionTwoText);
    _sharedPreferences.remove(PireConstants.questionTwoId);
    _sharedPreferences.remove(PireConstants.questionTwoType);

    _sharedPreferences.remove(PireConstants.questionThreeText);
    _sharedPreferences.remove(PireConstants.questionThreeId);
    _sharedPreferences.remove(PireConstants.questionThreeType);

    _sharedPreferences.remove(PireConstants.questionFourText);
    _sharedPreferences.remove(PireConstants.questionFourId);
    _sharedPreferences.remove(PireConstants.questionFourType);

    _sharedPreferences.remove(PireConstants.questionFiveText);
    _sharedPreferences.remove(PireConstants.questionFiveId);
    _sharedPreferences.remove(PireConstants.questionFiveType);

    _sharedPreferences.remove(PireConstants.questionSixText);
    _sharedPreferences.remove(PireConstants.questionSixId);
    _sharedPreferences.remove(PireConstants.questionSixType);

    _sharedPreferences.remove(PireConstants.questionSevenText);
    _sharedPreferences.remove(PireConstants.questionSevenId);
    _sharedPreferences.remove(PireConstants.questionSevenType);

    _sharedPreferences.remove(PireConstants.questionEightText);
    _sharedPreferences.remove(PireConstants.questionEightId);
    _sharedPreferences.remove(PireConstants.questionEightType);

    _sharedPreferences.remove(PireConstants.questionNineText);
    _sharedPreferences.remove(PireConstants.questionNineId);
    _sharedPreferences.remove(PireConstants.questionNineType);

    _sharedPreferences.remove(PireConstants.questionTenText);
    _sharedPreferences.remove(PireConstants.questionTenId);
    _sharedPreferences.remove(PireConstants.questionTenType);
  }

}