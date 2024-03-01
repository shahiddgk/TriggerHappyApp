// ignore_for_file: must_be_immutable, unused_field

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quiz_app/Screens/PireScreens/screen_16.dart';
import 'package:flutter_quiz_app/Screens/PireScreens/utills/constants.dart';
import 'package:flutter_quiz_app/Screens/PireScreens/utills/question_state_prefrence.dart';
import 'package:flutter_quiz_app/Screens/PireScreens/widgets/AppBar.dart';
import 'package:flutter_quiz_app/Widgets/colors.dart';
import 'package:flutter_quiz_app/Widgets/logo_widget_for_all_screens.dart';
import 'package:flutter_quiz_app/Widgets/question_text_widget.dart';
import 'package:flutter_quiz_app/Widgets/two_buttons_widget.dart';
import 'package:flutter_quiz_app/model/request_model/response_email_request.dart';
import 'package:flutter_quiz_app/network/http_manager.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../Widgets/constants.dart';
import '../../Widgets/option_mcq_widget.dart';
import '../../Widgets/video_player_in_pop_up.dart';
import '../../model/reponse_model/question_answer_response_model.dart';
import '../Widgets/toast_message.dart';
import '../utill/userConstants.dart';

class Screen15 extends StatefulWidget {

  List<QuestionListResponseModel> questionListResponse;

  Screen15(this.questionListResponse,{Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _Screen15State createState() => _Screen15State();
}

class _Screen15State extends State<Screen15> {
  String _groupValue ="";
  List<String> selectedAnswer = [];
  String name = "";
  String email = "";
  String id = "";
  String allowEmail = "";
  String answerNo = "";
  String answerText = "";
  bool _isUserDataLoading = true;
  bool isAnswerLoading = false;
  late SharedPreferences _sharedPreferences;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  int badgeCount1 = 0;
  int badgeCountShared = 0;

  String id3 = "";
  String type3 = "";
  late List text3;

  String id4 = "";
  String type4 = "";
  late List text4 ;

  String id5 = "";
  String type5 = "";
  late List text5 ;

  String id6 = "";
  String type6 = "";
  late List text6 ;

  String id7 = "";
  String type7 = "";
  late List text7 ;

  String id8 = "";
  String type8 = "";
  late List text8 ;

  String id9 = "";
  String type9 = "";
  late List text9 ;

  String id12 = "";
  String type12 = "";
  late List text12;

  String id13 = "";
  String type13 = "";
  late List text13;

  String id15 = "";
  String type15 = "";
  late List text15;

  String timeZone = "";
  String userType = "";

  _getUserData() async {
    setState(() {
      _isUserDataLoading = true;
    });
    // ignore: avoid_print
    print("Data getting called");
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    badgeCount1 = sharedPreferences.getInt("BadgeCount")!;
    badgeCountShared = sharedPreferences.getInt("BadgeShareResponseCount")!;

    name = sharedPreferences.getString(UserConstants().userName)!;
    id = sharedPreferences.getString(UserConstants().userId)!;
    email = sharedPreferences.getString(UserConstants().userEmail)!;
    timeZone = sharedPreferences.getString(UserConstants().timeZone)!;
    userType = sharedPreferences.getString(UserConstants().userType)!;
    allowEmail = sharedPreferences.getString(UserConstants().allowEmail)!;
    setState(() {
      _isUserDataLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getUserData();
    //_getAnswerData();
    _getCompleteAnswerData();
  }

  _getCompleteAnswerData() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      id3 = _sharedPreferences.getString(PireConstants.questionOneId)!;
      type3 = _sharedPreferences.getString(PireConstants.questionOneType)!;
      text3 = _sharedPreferences.getStringList(PireConstants.questionOneText)!;

      id4 = _sharedPreferences.getString(PireConstants.questionTwoId)!;
      type4 = _sharedPreferences.getString(PireConstants.questionTwoType)!;
      text4 = _sharedPreferences.getStringList(PireConstants.questionTwoText)!;

      id5 = _sharedPreferences.getString(PireConstants.questionThreeId)!;
      type5 = _sharedPreferences.getString(PireConstants.questionThreeType)!;
      text5 = _sharedPreferences.getStringList(PireConstants.questionThreeText)!;

      id6 = _sharedPreferences.getString(PireConstants.questionFourId)!;
      type6 = _sharedPreferences.getString(PireConstants.questionFourType)!;
      text6 = _sharedPreferences.getStringList(PireConstants.questionFourText)!;

      id7 = _sharedPreferences.getString(PireConstants.questionFiveId)!;
      type7 = _sharedPreferences.getString(PireConstants.questionFiveType)!;
      text7 = _sharedPreferences.getStringList(PireConstants.questionFiveText)!;

      id8 = _sharedPreferences.getString(PireConstants.questionSixId)!;
      type8 = _sharedPreferences.getString(PireConstants.questionSixType)!;
      text8 = _sharedPreferences.getStringList(PireConstants.questionSixText)!;

      id9 = _sharedPreferences.getString(PireConstants.questionSevenId)!;
      type9 = _sharedPreferences.getString(PireConstants.questionSevenType)!;
      text9 = _sharedPreferences.getStringList(PireConstants.questionSevenText)!;

      id12 = _sharedPreferences.getString(PireConstants.questionEightId)!;
      type12 = _sharedPreferences.getString(PireConstants.questionEightType)!;
      text12 = _sharedPreferences.getStringList(PireConstants.questionEightText)!;

      id13 = _sharedPreferences.getString(PireConstants.questionNineId)!;
      type13 = _sharedPreferences.getString(PireConstants.questionNineType)!;
      text13 = _sharedPreferences.getStringList(PireConstants.questionNineText)!;
    });

  }

  // ignore: unused_element
  _getAnswerData() async {
    setState(() {
    });
    _sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      answerNo = _sharedPreferences.getString("answerType15")!;
      answerText = _sharedPreferences.getString("answerText15")!;
    });

  }

  setAnswerText()  {
// ignore: avoid_print
    print("Calling question Submission");
    QuestionStatePrefrence().setAnswerText(
        PireConstants.questionTenId, widget.questionListResponse[10].id.toString(),
        PireConstants.questionTenText, selectedAnswer,
        PireConstants.questionTenType, widget.questionListResponse[10].responseType.toString()
    );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBarWidget().appBarGeneralButtons(
          context,
              () {
            // Navigator.pushAndRemoveUntil(
            //     context,
            //     MaterialPageRoute(builder: (BuildContext context) =>const Dashboard()),
            //         (Route<dynamic> route) => false
            // );
          }, true, true, true, id, false,true,badgeCount1,false,badgeCountShared),
      bottomNavigationBar: GestureDetector(
        // onTap: () {
        //   setAnswerText();
        //   _submitAnswer();
        // },
        child: Container(
          color: AppColors.backgroundColor,
          child:  PriviousNextButtonWidget((){
            setAnswerText();
            _sendResponseByEmail();
          },(){
            // widget.answersList.removeAt(widget.answersList.length-1);
            // print(widget.answersList);
            Navigator.of(context).pop();
          },true),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: AppColors.backgroundColor,
        child:  Stack(
          alignment: Alignment.center,
         // ignoring: isAnswerLoading,
         children: [
           Column(
             mainAxisAlignment: MainAxisAlignment.start,
             crossAxisAlignment: CrossAxisAlignment.center,
             children: [
               //Text("QUESTION 1 OF 24",style: TextStyle(color: Colors.deepOrangeAccent),),
               Column(
                 crossAxisAlignment: CrossAxisAlignment.center,
                 mainAxisAlignment: MainAxisAlignment.start,
                 children: [
                   LogoScreen("PIRE"),

                   Align(
                       alignment: Alignment.topLeft,
                       child: QuestionTextWidget(widget.questionListResponse[10].title,widget.questionListResponse[10].videoUrl,(){
                         String urlQ1 = "https://www.youtube.com/watch?v=RDgeJuHX22M";
                         String? videoId = YoutubePlayer.convertUrlToId(urlQ1);
                         YoutubePlayerController youtubePlayerController = YoutubePlayerController(
                             initialVideoId: videoId!,
                             flags: const YoutubePlayerFlags(
                               autoPlay: false,
                               controlsVisibleAtStart: false,
                             )

                         );
                         videoPopupDialog(context, "Introduction to question#15", youtubePlayerController);
                       },true)),
                   ListView.builder(
                       physics:const NeverScrollableScrollPhysics(),
                       scrollDirection: Axis.vertical,
                       itemCount: widget.questionListResponse[10].options.length,
                       shrinkWrap: true,
                       itemBuilder: (context, index){
                         return OptionMcqAnswer(
                           RadioListTile<String>(
                             tileColor: AppColors.textWhiteColor,
                             activeColor: AppColors.primaryColor,
                             value: widget.questionListResponse[10].options[index],
                             title: Text(widget.questionListResponse[10].options[index],style: const TextStyle(color: AppColors.textWhiteColor,fontSize: AppConstants.defaultFontSize)),
                             groupValue: _groupValue,
                             onChanged:  (newValue) {
                               selectedAnswer.clear();
                               setState(() {
                                 selectedAnswer.add(widget.questionListResponse[10].options[index]);

                                 //  print(widget.answersList);
                                 _groupValue = newValue.toString();
                               });
                             },
                           ),);
                       }),
                 ],
               ),

             ],
           ),
           Align(alignment: Alignment.center,
             child: isAnswerLoading ? const CircularProgressIndicator(): Container(),
           )
         ],
        ),
      ),
    );
  }

  void _sendResponseByEmail() {
    if(selectedAnswer.isNotEmpty) {
      setState(() {
        isAnswerLoading = true;
        id15 = widget.questionListResponse[10].id.toString();
        type15 = widget.questionListResponse[10].responseType.toString();
        text15 = selectedAnswer;
      });

      Map<String, dynamic> answerObject = {
        id3: { "type": type3,
          "answer": text3},

        id4: { "type": type4,
          "answer": text4},

        id5: { "type": type5,
          "answer": text5},

        id6: { "type": type6,
          "answer": text6},

        id7: { "type": type7,
          "answer": text7},

        id8: { "type": type8,
          "answer": text8},

        id9: { "type": type9,
          "answer": text9},

        id12: { "type": type12,
          "answer": text12},

        id13: { "type": type13,
          "answer": text13},

        id15: { "type": type15,
          "answer": text15},

      };
      // print("All Answer Response");
      // print(name);
      // print(email);
      // print(id);
      // print(answerObject);
      final String encodedData = jsonEncode(answerObject);
      HTTPManager().userResponseEmail(UserResponseRequestModel(
          name: name, email: email, userId: id, answerMap: encodedData)).then((
          value)  {

        QuestionStatePrefrence().clearAnswerText();
        setState(() {
          isAnswerLoading = false;
        });
        if(allowEmail == "yes") {
          showToastMessage(context, value['message'].toString(), true);
        } else {
          showToastMessage(context, "Pire Submitted successfully", true);
        }
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (BuildContext context) => Screen16(_groupValue,value['response_id'])),
                (Route<dynamic> route) => false
        );
        // Navigator.of(context).push(
        //     MaterialPageRoute(builder: (context) => Screen16(_groupValue));
      }).catchError((e) {
        setState(() {
          isAnswerLoading = false;
        });
        //print(e);
        showToastMessage(context, e.toString(),false);
      });
    } else {
      showToastMessage(context, "Please select any option",false);
    }
  }
}
